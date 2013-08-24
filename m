Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6851F7CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 18:22:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5591D304032
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 16:22:23 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id fwlRRFRdsY9Znlve (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 16:22:20 -0700 (PDT)
Message-ID: <52194023.2060702@tlinx.org>
Date: Sat, 24 Aug 2013 16:22:11 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: does having ~Ncore+1? kworkers flushing XFS to 1 disk improve
	throughput?
References: <52181B69.6060707@tlinx.org> <52183194.2060008@hardwarefreak.com>
	<5218EADD.4000704@tlinx.org> <521904F4.90208@hardwarefreak.com>
In-Reply-To: <521904F4.90208@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs-oss <xfs@oss.sgi.com>



Stan Hoeppner wrote:
> On 8/24/2013 12:18 PM, Linda Walsh wrote:
>>
>> Stan Hoeppner wrote:
>>> On 8/23/2013 9:33 PM, Linda Walsh wrote:
>>>
>>>> So what are all the kworkers doing and does having 6 of them do
>>>> things at the same time really help disk-throughput?
>>>>
>>>> Seems like they would conflict w/each other, cause disk
>>>> contention, and extra fragmentation as they do things?  If they
>>>> were all writing to separate disks, that would make sense, but do
>>>> that many kworker threads need to be finishing out disk I/O on
>>>> 1 disk?
>>> https://raw.github.com/torvalds/linux/master/Documentation/workqueue.txt
>> ----
>>
>> Thanks for the pointer.
>>
>> I see ways to limit #workers/cpu if they were hogging too much cpu,
>> which isn't the problem..  My concern is that the work they are
>> doing is all writing info back to the same physical disk -- and that
>> while >1 writer can improve throughput, generally, it would be best
>> if the pending I/O was sorted in disk order and written out using
>> the elevator algorithm.  I.e. I can't imagine that it takes 6-8
>> processes (mostly limiting themselves to 1 NUMA node) to keep the
>> elevator filled?
> 
> You're making a number of incorrect assumptions here.  The work queues
> are generic, which is clearly spelled out in the document above.  The
> kworker threads are just that, kernel threads, not processes as you
> assume above.
----
	Sorry, terminology.  Linux threads are implemented as processes with
minor differences -- they are threads, though as the kernel see them.

>  XFS is not the only subsystem that uses them.  Any
> subsystem or driver can use work queues.  You can't tell what's
> executing within a kworker thread from top or ps output.  You must look
> at the stack trace.
> 
> The work you are seeing in those 7 or 8 kworker threads is not all
> parallel XFS work.  Your block device driver, whether libata, SCSI, or
> proprietary RAID card driver, is placing work in these queues as well.
---
Hmmm.... I hadn't thought of the driver doing that... I sort thought
it just took blocks as fed by the kernel and when it was done with
a DMA, then it told the kernel it was done and was ready for another.

I thought such drivers did direct IO at that point -- i.e. they are below
the elevator algorithm?


> The work queues are not limited to filesystems and block device drivers.
>  Any device driver or kernel subsystem can use work queues.
---
	True, but I when I see a specific number come up and work
constantly when I unpack a tar, I would see it as related to that
command.   What other things would use that much cpu?

> 
> Nothing bypasses the elevator; sectors are still sorted.  But keep in
> mind if you're using a hardware RAID controller -it- does the final
> sorting of writeback anyway, so this is a non issue.
LSI raid

> 
> So in a nutshell, whatever performance issue you're having, if you
> indeed have an issue, isn't caused by work queues or the number of
> kworker threads on your system, per CPU, or otherwise.

Um... but it could be made worse by having an excessive number of
threads all contending for a limited resource.   The more contenders
for a limited resource, the more the scheduler has to sort out who
gets access to the resource next.

If you have 6 threads dumping sectors to different areas of the
disk that need seeks between each thread's output becoming complete,
then you have a seek penalty with each thread switch -- vs. if
they were coalesced and sorted into 1 queue, 1 worker could do
the work of the 6 without the extra seeks between the different
kworkers emptying their queues.


> You need to look
> elsewhere for the bottleneck.  Given it's lightning fast up to the point
> buffers start flushing to disk it's pretty clear your spindles simply
> can't keep up.
----
	That's not the point (though it is a given).  What I'm focusing on
is how the kernel handles a backlog.

	If I want throughput, I use 1 writer -- to an unfragmented file that
won't require seeks.  If I try to use 2 writers -- each to unfrag'd files
and run them at the same time, It's almost certain that that the throughput will
drop == since the disk will have to seek back and forth between the two files
to give "disk-write-resources" to each writer.

	It would be faster if I did both files sequentially rather than trying to
do them in parallel, The disk is limited to ~1GB/s, -- every seek that needs to
be done to get files out reduces that.  So tar splats 5000 files into memory.
Then it takes time for those to be written.   If I write 5000 files sequentially
with 1 writer, I will get faster performance than if I use 25 threads each
dumping 50 files in parallel.  The disk subsystem's responsiveness drops
due to all the seeks between writes, whereas if it was 1 big sorted write --
it could be written out in 1-2 elevator passes... I don't think it is being
that efficient.  Thus my Q about whether or not it was really the optimal way
to improve throughput to have "too many writers" accessing a resource at the
same time.

	I'm not saying there is a "problem" per se, I'm just asking/wondering
how so many writers won't have the disk seeking all over the place to round-robin
service their requests.

	FWIW, the disk could probably handle 2-3 writers and show improvement
over a single -- but anything over that, and I have started to see an overall
drop in throughput.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
