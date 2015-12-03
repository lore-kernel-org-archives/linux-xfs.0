Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E7287F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 06:52:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22399304048
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 04:52:16 -0800 (PST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id 7crC1PoGDgoBDzhT
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Dec 2015 04:52:12 -0800 (PST)
Received: by wmww144 with SMTP id w144so19748582wmw.1
	for <xfs@oss.sgi.com>; Thu, 03 Dec 2015 04:52:11 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com> <20151201180321.GA4762@redhat.com>
	<565DEFE2.2000308@scylladb.com> <20151201211914.GZ19199@dastard>
	<565E1355.4020900@scylladb.com> <20151201230644.GD19199@dastard>
	<565EB390.3020309@scylladb.com> <20151202231933.GL19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <56603AF8.1080209@scylladb.com>
Date: Thu, 3 Dec 2015 14:52:08 +0200
MIME-Version: 1.0
In-Reply-To: <20151202231933.GL19199@dastard>
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



On 12/03/2015 01:19 AM, Dave Chinner wrote:
> On Wed, Dec 02, 2015 at 11:02:08AM +0200, Avi Kivity wrote:
>> On 12/02/2015 01:06 AM, Dave Chinner wrote:
>>> On Tue, Dec 01, 2015 at 11:38:29PM +0200, Avi Kivity wrote:
>>>> On 12/01/2015 11:19 PM, Dave Chinner wrote:
>>>>>>> XFS spread files across the allocation groups, based on the directory these
>>>>>>> files are created,
>>>>>> Idea: create the files in some subdirectory, and immediately move
>>>>>> them to their required location.
> ....
>>>> My hack involves creating the file in a random directory, and while
>>>> it is still zero sized, move it to its final directory.  This is
>>>> simply to defeat the ag selection heuristic.
>>> Which you really don't want to do.
>> Why not?  For my directory structure, files in the same directory do
>> not share temporal locality.  What does the ag selection heuristic
>> give me?
> Wrong question. The right question is this: what problems does
> subverting the AG selection heuristic cause me?
>
> If you can't answer that question, then you can't quantify the risks
> involved with making such a behavioural change.

Okay.  Any hint about the answer to that question?


>
>>>>>>>   trying to keep files as close as possible from their
>>>>>>> metadata.
>>>>>> This is pointless for an SSD. Perhaps XFS should randomize the ag on
>>>>>> nonrotational media instead.
>>>>> Actually, no, it is not pointless. SSDs do not require optimisation
>>>>> for minimal seek time, but data locality is still just as important
>>>>> as spinning disks, if not moreso. Why? Because the garbage
>>>>> collection routines in the SSDs are all about locality and we can't
>>>>> drive garbage collection effectively via discard operations if the
>>>>> filesystem is not keeping temporally related files close together in
>>>>> it's block address space.
>>>> In my case, files in the same directory are not temporally related.
>>>> But I understand where the heuristic comes from.
>>>>
>>>> Maybe an ioctl to set a directory attribute "the files in this
>>>> directory are not temporally related"?
>>> And exactly what does that gain us?
>> I have a directory with commitlog files that are constantly and
>> rapidly being created, appended to, and removed, from all logical
>> cores in the system.  Does this not put pressure on that allocation
>> group's locks?
> Not usually, because if an AG is contended, the allocation algorithm
> skips the contended AG and selects the next uncontended AG to
> allocate in. And given that the append algorithm used by the
> allocator attempts to use the last block of the last extent as the
> target for the new extent (i.e. contiguous allocation) once a file
> has skipped to a different AG all allocations will continue in that
> new AG until it is either full or it becomes contended....
>
> IOWs, when AG contention occurs, the filesystem automatically
> spreads out the load over multiple AGs. Put simply, we optimise for
> locality first, but we're willing to compromise on locality to
> minimise contention when it occurs. But, also, keep in mind that
> in minimising contention we are still selecting the most local of
> possible alternatives, and that's something you can't do in
> userspace....

Cool.  I don't think "nearly-local" matters much for an SSD (it's either 
contiguous or it is not), but it's good to know that it's self-tuning 
wrt. contention.

In some good news, Glauber hacked our I/O engine not to throw so many 
concurrent I/Os at the filesystem, and indeed so the contention 
reduced.  So it's likely we were pushing the fs so hard all the ags were 
contended, but this is no longer the case.


>
>>> Exactly what problem are you
>>> trying to solve by manipulating file locality that can't be solved
>>> by existing knobs and config options?
>> I admit I don't know much about the existing knobs and config
>> options.  Pointers are appreciated.
> You can find some work in progress here:
>
> https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/
>
> looks like there's some problem with xfs.org wiki, so the links
> to the user/training info on this page:
>
> http://xfs.org/index.php/XFS_Papers_and_Documentation
>
> aren't working.
>
>>> Perhaps you'd like to read up on how the inode32 allocator behaves?
>> Indeed I would, pointers are appreciated.
> Inode allocation section here:
>
> https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

Thanks for all the links, I'll study them and see what we can do to tune 
for our workload.

>>> Once we know which of the different algorithms is causing the
>>> blocking issues, we'll know a lot more about why we're having
>>> problems and a better idea of what problems we actually need to
>>> solve.
>> I'm happy to hack off the lowest hanging fruit and then go after the
>> next one.  I understand you're annoyed at having to defend against
>> what may be non-problems; but for me it is an opportunity to learn
>> about the file system.
> No, I'm not annoyed. I just don't want to be chasing ghosts and so
> we need to be on the same page about how to track down these issues.
> And, beleive me, you'll learn a lot about how the filesystem behaves
> just by watching how the different configs react to the same
> input...

Ok.  Looks like I have a lot of homework.


>
>> For us it is the weakest spot in our system,
>> because on the one hand we heavily depend on async behavior and on
>> the other hand Linux is notoriously bad at it.  So we are very
>> nervous when blocking happens.
> I can't disagree with you there - we really need to fix what we can
> within the constraints of the OS first, then we once we have it
> working as well as we can, then we can look to solving the remaining
> "notoriously bad" AIO problems...

There are lots of users who will be eternally grateful to you if you can 
get this fixed.  Linux has a very bad reputation in this area with the 
accepted wisdom that you can only use aio reliably against block 
devices.  XFS comes very close, it will make a huge impact if it can be 
used to do aio reliably, without a lot of constraints on the application.

>
>>>>> effectively than lots of little trims (i.e. one per file) that the
>>>>> drive cannot do anything useful with because they are all smaller
>>>>> than the internal SSD page/block sizes and so get ignored.  This is
>>>>> one of the reasons fstrim is so much more efficient and effective
>>>>> than using the discard mount option.
>>>> In my use case, the files are fairly large, and there is constant
>>>> rewriting (not in-place: files are read, merged, and written back).
>>>> So I'm worried an fstrim can happen too late.
>>> Have you measured the SSD performance degradation over time due to
>>> large overwrites? If not, then again it is a good chance you are
>>> trying to solve a theoretical problem rather than a real problem....
>>>
>> I'm not worried about that (maybe I should be) but about the SSD
>> reaching internal ENOSPC due to the fstrim happening too late.
>>
>> Consider this scenario, which is quite typical for us:
>>
>> 1. Fill 1/3rd of the disk with a few large files.
>> 2. Copy/merge the data into a new file, occupying another 1/3rd of the disk.
>> 3. Repeat 1+2.
>>
>> If this is repeated few times, the disk can see 100% of its space
>> occupied (depending on how free space is allocated), even if from a
>> user's perspective it is never more than 2/3rds full.
> I don't think that's true. SSD behaviour largely depends on how much
> of the LBA space has been written to (i.e. marked used) and so that
> metric tends to determine how the SSD behaves under such workloads.
> This is one of the reasons that overprovisioning SSD space (e.g.
> leaving 25% of the LBA space completely unused) results in better
> performance under overwrite workloads - there's lots more scratch
> space for the garbage collector to work with...
>
> Hence as long as the filesystem is reusing the same LBA regions for
> the files, TRIM will probably not make a significant difference to
> performance because there's still 1/3rd of the LBA region that is
> "unused". Hence the overwrites go into the unused 1/3rd of the SSD,
> and the underlying SSD blocks associated with the "overwritten" LBA
> region are immediately marked free, just like if you issued a trim
> for that region before you start the overwrite.
>
> With the way the XFS allocator works, it fills AGs from lowest to
> highest blocks, and if you free lots of space down low in the AG
> then that tends to get reused before the higher offset free space.
> hence the XFS allocates space in the above workload would result in
> roughly 1/3rd of the LBA space associated with the filesystem
> remaining unused. This is another allocator behaviour designed for
> spinning disks (to keep the data on the faster outer edges of
> drives) that maps very well to internal SSD allocation/reclaim
> algorithms....

Cool.  So we'll keep fstrim usage to daily, or something similarly low.

>
> FWIW, did you know that TRIM generally doesn't return the disk to
> the performance of a pristine, empty disk?  Generally only a secure
> erase will guarantee that a SSD returns to "empty disk" performance,
> but that also removes all data from then entire SSD.  Hence the
> baseline "sustained performance" you should be using is not "empty
> disk" performance, but the performance once the disk has been
> overwritten completely at least once. Only them will you tend to see
> what effect TRIM will actually have.

I did not know that.  Maybe that's another factor in why cloud SSDs are 
so slow.

>
>> Maybe a simple countermeasure is to issue an fstrim every time we
>> write 10%-20% of the disk's capacity.
> Run the workload to steady state performance and measure the
> degradation as it continues to run and overwrite the SSDs
> repeatedly. To do this properly you are going to have to sacrifice
> some SSDs, because you're going to need to overwrite them quite a
> few times to get an idea of the degradation characteristics and
> whether a periodic trim makes any difference or not.

Enterprise SSDs are guaranteed for something like N full writes / day 
for several years, are they not?  So such a test can take weeks or 
months, depending on the ratio between disk size and bandwidth.

Still, I guess it has to be done.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
