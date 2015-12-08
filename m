Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6E037F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 07:53:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 582A1AC001
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 05:52:59 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id diSuBUD675UPxkT0
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 05:52:56 -0800 (PST)
Received: by wmec201 with SMTP id c201so213355395wme.0
	for <xfs@oss.sgi.com>; Tue, 08 Dec 2015 05:52:55 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com> <20151201180321.GA4762@redhat.com>
	<565DEFE2.2000308@scylladb.com> <20151201211914.GZ19199@dastard>
	<565E1355.4020900@scylladb.com> <20151201230644.GD19199@dastard>
	<565EB390.3020309@scylladb.com> <20151202231933.GL19199@dastard>
	<56603AF8.1080209@scylladb.com> <20151204031648.GC26718@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5666E0B4.70401@scylladb.com>
Date: Tue, 8 Dec 2015 15:52:52 +0200
MIME-Version: 1.0
In-Reply-To: <20151204031648.GC26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com



On 12/04/2015 05:16 AM, Dave Chinner wrote:
> On Thu, Dec 03, 2015 at 02:52:08PM +0200, Avi Kivity wrote:
>>
>> On 12/03/2015 01:19 AM, Dave Chinner wrote:
>>> On Wed, Dec 02, 2015 at 11:02:08AM +0200, Avi Kivity wrote:
>>>> On 12/02/2015 01:06 AM, Dave Chinner wrote:
>>>>> On Tue, Dec 01, 2015 at 11:38:29PM +0200, Avi Kivity wrote:
>>>>>> On 12/01/2015 11:19 PM, Dave Chinner wrote:
>>>>>>>>> XFS spread files across the allocation groups, based on the directory these
>>>>>>>>> files are created,
>>>>>>>> Idea: create the files in some subdirectory, and immediately move
>>>>>>>> them to their required location.
>>> ....
>>>>>> My hack involves creating the file in a random directory, and while
>>>>>> it is still zero sized, move it to its final directory.  This is
>>>>>> simply to defeat the ag selection heuristic.
>>>>> Which you really don't want to do.
>>>> Why not?  For my directory structure, files in the same directory do
>>>> not share temporal locality.  What does the ag selection heuristic
>>>> give me?
>>> Wrong question. The right question is this: what problems does
>>> subverting the AG selection heuristic cause me?
>>>
>>> If you can't answer that question, then you can't quantify the risks
>>> involved with making such a behavioural change.
>> Okay.  Any hint about the answer to that question?
> If your file set is randomly distributed across the filesystem,

I think that happens whether or not I break the "files in the same 
directory are related" heuristic, because I have many directories. It's 
just that some of them get churned more than others.

>   then
> it's quite likely that the filesystem will use all of the LBA space
> rather than reusing the same AGs and hence LBA regions. That's going
> to slowly fragment free space as metadata (which has different
> lifetimes to data) and long term data gets more widely distributed.
> That, in term will slowly result in the working dataset being made
> up of more and smaller extents, whcih will also slowly get more
> distributed over time, which them means allocation and freeing of
> extents takes longer, trim becomes less effective because it's
> workingwith smaller spaces, the SSD's "LBA in use" mapping becomes
> more fragmented so garbage collection becomes harder, etc...
>
> But, really, the only way to tell is to test, measure, observe and
> analyse....

Sure.

>
>>>>>>>> This is pointless for an SSD. Perhaps XFS should randomize the ag on
>>>>>>>> nonrotational media instead.
>>>>>>> Actually, no, it is not pointless. SSDs do not require optimisation
>>>>>>> for minimal seek time, but data locality is still just as important
>>>>>>> as spinning disks, if not moreso. Why? Because the garbage
>>>>>>> collection routines in the SSDs are all about locality and we can't
>>>>>>> drive garbage collection effectively via discard operations if the
>>>>>>> filesystem is not keeping temporally related files close together in
>>>>>>> it's block address space.
>>>>>> In my case, files in the same directory are not temporally related.
>>>>>> But I understand where the heuristic comes from.
>>>>>>
>>>>>> Maybe an ioctl to set a directory attribute "the files in this
>>>>>> directory are not temporally related"?
>>>>> And exactly what does that gain us?
>>>> I have a directory with commitlog files that are constantly and
>>>> rapidly being created, appended to, and removed, from all logical
>>>> cores in the system.  Does this not put pressure on that allocation
>>>> group's locks?
>>> Not usually, because if an AG is contended, the allocation algorithm
>>> skips the contended AG and selects the next uncontended AG to
>>> allocate in. And given that the append algorithm used by the
>>> allocator attempts to use the last block of the last extent as the
>>> target for the new extent (i.e. contiguous allocation) once a file
>>> has skipped to a different AG all allocations will continue in that
>>> new AG until it is either full or it becomes contended....
>>>
>>> IOWs, when AG contention occurs, the filesystem automatically
>>> spreads out the load over multiple AGs. Put simply, we optimise for
>>> locality first, but we're willing to compromise on locality to
>>> minimise contention when it occurs. But, also, keep in mind that
>>> in minimising contention we are still selecting the most local of
>>> possible alternatives, and that's something you can't do in
>>> userspace....
>> Cool.  I don't think "nearly-local" matters much for an SSD (it's
>> either contiguous or it is not), but it's good to know that it's
>> self-tuning wrt. contention.
> "Nearly local" matters a lot for filesystem free space management
> and hence minimising the amount o LBA space the filesystem actually
> uses in the long term given a relatively predicatable workload....
>
>> In some good news, Glauber hacked our I/O engine not to throw so
>> many concurrent I/Os at the filesystem, and indeed so the contention
>> reduced.  So it's likely we were pushing the fs so hard all the ags
>> were contended, but this is no longer the case.
> What is the xfs_info output of the filesystem you tested on?

It was a cloud disk so someone else now has the pleasure...

>
>>> With the way the XFS allocator works, it fills AGs from lowest to
>>> highest blocks, and if you free lots of space down low in the AG
>>> then that tends to get reused before the higher offset free space.
>>> hence the XFS allocates space in the above workload would result in
>>> roughly 1/3rd of the LBA space associated with the filesystem
>>> remaining unused. This is another allocator behaviour designed for
>>> spinning disks (to keep the data on the faster outer edges of
>>> drives) that maps very well to internal SSD allocation/reclaim
>>> algorithms....
>> Cool.  So we'll keep fstrim usage to daily, or something similarly low.
> Well, it's something you'll need to monitor to determine what the
> best frequency is, as even fstrim doesn't come for free (esp. if the
> storage does not support queued TRIM commands).

I was able to trigger a load where discard caused io_submit to sleep 
even on my super-fast nvme drive.

The bad news is, disabling discard and running fstrim in parallel with 
this load also caused io_submit to sleep.

>
>>> FWIW, did you know that TRIM generally doesn't return the disk to
>>> the performance of a pristine, empty disk?  Generally only a secure
>>> erase will guarantee that a SSD returns to "empty disk" performance,
>>> but that also removes all data from then entire SSD.  Hence the
>>> baseline "sustained performance" you should be using is not "empty
>>> disk" performance, but the performance once the disk has been
>>> overwritten completely at least once. Only them will you tend to see
>>> what effect TRIM will actually have.
>> I did not know that.  Maybe that's another factor in why cloud SSDs
>> are so slow.
> Have a look at the random write performance consistency graphs for
> the different enterprise SSDs here:
>
> http://www.anandtech.com/show/9430/micron-m510dc-480gb-enterprise-sata-ssd-review/3
>
> You'll see just how different sustained write load performance is to
> the empty drive performance (which is only the first few hundred
> seconds of each graph) across the different drives that have been
> tested. The next page has similar results for mixed random
> read/write workloads....
>
> That will give you a good idea of how the current enterprise SSDs
> behave under sustained write load. It's a *lot* better than the way
> the 1st and 2nd generation drives performed....
>
>>>> write 10%-20% of the disk's capacity.
>>> Run the workload to steady state performance and measure the
>>> degradation as it continues to run and overwrite the SSDs
>>> repeatedly. To do this properly you are going to have to sacrifice
>>> some SSDs, because you're going to need to overwrite them quite a
>>> few times to get an idea of the degradation characteristics and
>>> whether a periodic trim makes any difference or not.
>> Enterprise SSDs are guaranteed for something like N full writes /
>> day for several years, are they not?
> Yes, usually somewhere between 3-15 DWPD (Drive Writes Per Day) - it
> typically works out at around 5000 full drive write cycles for
> enterprise drives.  However, at both the low capacity end of the
> scale or the high performance end (i.e. pcie cards capable of multiple
> GB/s writes), it's not uncommon to be able to burn a DW cycle in
> under 10 minutes and so you can easily burn the life out of a drive
> in a couple of weeks of intense testing....
>
>> So such a test can take weeks
>> or months, depending on the ratio between disk size and bandwidth.
>> Still, I guess it has to be done.
> *nod*
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
