Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D0417CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 14:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D2748F8033
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 12:09:45 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id IKiowVsi5O6BLwUa
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 12:09:44 -0700 (PDT)
Message-ID: <521904F4.90208@hardwarefreak.com>
Date: Sat, 24 Aug 2013 14:09:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: does having ~Ncore+1? kworkers flushing XFS to 1 disk improve
	throughput?
References: <52181B69.6060707@tlinx.org> <52183194.2060008@hardwarefreak.com>
	<5218EADD.4000704@tlinx.org>
In-Reply-To: <5218EADD.4000704@tlinx.org>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/24/2013 12:18 PM, Linda Walsh wrote:
> 
> 
> Stan Hoeppner wrote:
>> On 8/23/2013 9:33 PM, Linda Walsh wrote:
>>
>>> So what are all the kworkers doing and does having 6 of them do
>>> things at the same time really help disk-throughput?
>>>
>>> Seems like they would conflict w/each other, cause disk
>>> contention, and extra fragmentation as they do things?  If they
>>> were all writing to separate disks, that would make sense, but do
>>> that many kworker threads need to be finishing out disk I/O on
>>> 1 disk?
>>
>> https://raw.github.com/torvalds/linux/master/Documentation/workqueue.txt
> ----
> 
> Thanks for the pointer.
> 
> I see ways to limit #workers/cpu if they were hogging too much cpu,
> which isn't the problem..  My concern is that the work they are
> doing is all writing info back to the same physical disk -- and that
> while >1 writer can improve throughput, generally, it would be best
> if the pending I/O was sorted in disk order and written out using
> the elevator algorithm.  I.e. I can't imagine that it takes 6-8
> processes (mostly limiting themselves to 1 NUMA node) to keep the
> elevator filled?

You're making a number of incorrect assumptions here.  The work queues
are generic, which is clearly spelled out in the document above.  The
kworker threads are just that, kernel threads, not processes as you
assume above.  XFS is not the only subsystem that uses them.  Any
subsystem or driver can use work queues.  You can't tell what's
executing within a kworker thread from top or ps output.  You must look
at the stack trace.

The work you are seeing in those 7 or 8 kworker threads is not all
parallel XFS work.  Your block device driver, whether libata, SCSI, or
proprietary RAID card driver, is placing work in these queues as well.
The work queues are not limited to filesystems and block device drivers.
 Any device driver or kernel subsystem can use work queues.

Nothing bypasses the elevator; sectors are still sorted.  But keep in
mind if you're using a hardware RAID controller -it- does the final
sorting of writeback anyway, so this is a non issue.  I can't recall if
you use md/RAID or an LSI RAID controller.  ISTR you stating LSI
sometime back, but my memory may be faulty here.

So in a nutshell, whatever performance issue you're having, if you
indeed have an issue, isn't caused by work queues or the number of
kworker threads on your system, per CPU, or otherwise.  You need to look
elsewhere for the bottleneck.  Given it's lightning fast up to the point
buffers start flushing to disk it's pretty clear your spindles simply
can't keep up.

-- 
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
