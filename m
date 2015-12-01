Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C09EC7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:38:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5869DAC004
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:38:39 -0800 (PST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 0NXuQnqnB6p5Sthr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 13:38:37 -0800 (PST)
Received: by wmww144 with SMTP id w144so31658258wmw.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 13:38:36 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com> <20151201180321.GA4762@redhat.com>
	<565DEFE2.2000308@scylladb.com> <20151201211914.GZ19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565E1355.4020900@scylladb.com>
Date: Tue, 1 Dec 2015 23:38:29 +0200
MIME-Version: 1.0
In-Reply-To: <20151201211914.GZ19199@dastard>
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

On 12/01/2015 11:19 PM, Dave Chinner wrote:
> On Tue, Dec 01, 2015 at 09:07:14PM +0200, Avi Kivity wrote:
>> On 12/01/2015 08:03 PM, Carlos Maiolino wrote:
>>> Hi Avi,
>>>
>>>>> else is going to execute in our place until this thread can make
>>>>> progress.
>>>> For us, nothing else can execute in our place, we usually have exactly one
>>>> thread per logical core.  So we are heavily dependent on io_submit not
>>>> sleeping.
>>>>
>>>> The case of a contended lock is, to me, less worrying.  It can be reduced by
>>>> using more allocation groups, which is apparently the shared resource under
>>>> contention.
>>>>
>>> I apologize if I misread your previous comments, but, IIRC you said you can't
>>> change the directory structure your application is using, and IIRC your
>>> application does not spread files across several directories.
>> I miswrote somewhat: the application writes data files and commitlog
>> files.  The data file directory structure is fixed due to
>> compatibility concerns (it is not a single directory, but some
>> workloads will see most access on files in a single directory.  The
>> commitlog directory structure is more relaxed, and we can split it
>> to a directory per shard (=cpu) or something else.
>>
>> If worst comes to worst, we'll hack around this and distribute the
>> data files into more directories, and provide some hack for
>> compatibility.
>>
>>> XFS spread files across the allocation groups, based on the directory these
>>> files are created,
>> Idea: create the files in some subdirectory, and immediately move
>> them to their required location.
> See xfs_fsr.

Can you elaborate?  I don't see how it is applicable.

My hack involves creating the file in a random directory, and while it 
is still zero sized, move it to its final directory.  This is simply to 
defeat the ag selection heuristic.  No data is copied.

>>>   trying to keep files as close as possible from their
>>> metadata.
>> This is pointless for an SSD. Perhaps XFS should randomize the ag on
>> nonrotational media instead.
> Actually, no, it is not pointless. SSDs do not require optimisation
> for minimal seek time, but data locality is still just as important
> as spinning disks, if not moreso. Why? Because the garbage
> collection routines in the SSDs are all about locality and we can't
> drive garbage collection effectively via discard operations if the
> filesystem is not keeping temporally related files close together in
> it's block address space.

In my case, files in the same directory are not temporally related. But 
I understand where the heuristic comes from.

Maybe an ioctl to set a directory attribute "the files in this directory 
are not temporally related"?

I imagine this will be useful for many server applications.

> e.g. If the files in a directory are all close together, and the
> directory is removed, we then leave a big empty contiguous region in
> the filesystem free space map, and when we send discards over that
> we end up with a single big trim and the drive handles that far more

Would this not be defeated if a directory that happens to share the 
allocation group gets populated simultaneously?

> effectively than lots of little trims (i.e. one per file) that the
> drive cannot do anything useful with because they are all smaller
> than the internal SSD page/block sizes and so get ignored.  This is
> one of the reasons fstrim is so much more efficient and effective
> than using the discard mount option.

In my use case, the files are fairly large, and there is constant 
rewriting (not in-place: files are read, merged, and written back). So 
I'm worried an fstrim can happen too late.

>
> And, well, XFS is designed to operate on storage devices made up of
> more than one drive, so the way AGs are selected is designed to
> given long term load balancing (both for space usage and
> instantenous performance). With the existing algorithms we've not
> had any issues with SSD lifetimes, long term performance
> degradation, etc, so there's no evidence that we actually need to
> change the fundamental allocation algorithms specially for SSDs.
>

Ok.  Maybe the SSDs can deal with untrimmed overwrites efficiently, 
provided the io sizes are large enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
