Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 606397F3F
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 14:09:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 312F58F8033
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 12:09:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xg38HN9wZEZWGCKn for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 12:09:31 -0800 (PST)
Message-ID: <54B429EB.9050807@sandeen.net>
Date: Mon, 12 Jan 2015 14:09:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com>
	<54B019F4.8030009@sandeen.net>	<20150109182310.GA2785@htj.dyndns.org>	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
In-Reply-To: <20150110192852.GD25319@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/10/15 1:28 PM, Tejun Heo wrote:
> Hello, Eric.
> 
> On Fri, Jan 09, 2015 at 02:36:28PM -0600, Eric Sandeen wrote:

...

> As long as the split worker is queued on a separate workqueue, it's
> not really stuck behind xfs_end_io's.  If the global pool that the
> work item is queued on can't make forward progress due to memory
> pressure, the rescuer will be summoned and it will pick out that work
> item and execute it.
> 
> The only reasons that work item would stay there are
> 
> * The rescuer is already executing something else from that workqueue
>   and that one is stuck.

That does not seem to be the case:

PID: 2563   TASK: c00000060f101370  CPU: 33  COMMAND: "xfsalloc"
 #0 [c000000602787850] __switch_to at c0000000000164d8
 #1 [c000000602787a20] __switch_to at c0000000000164d8
 #2 [c000000602787a80] __schedule at c000000000900200
 #3 [c000000602787cd0] rescuer_thread at c0000000000ed770
 #4 [c000000602787d80] kthread at c0000000000f8e0c
 #5 [c000000602787e30] ret_from_kernel_thread at c00000000000a3e8

> * The worker pool is still considered to be making forward progress -
>   there's a worker which isn't blocked and can burn CPU cycles.
>   ie. if you have a busy spinning work item on the per-cpu workqueue,
>   it can stall progress.

So, the only interesting runnable task I see is this:

crash> bt 17056
PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
 #0 [c000000060b83190] hardware_interrupt_common at c000000000002294
 Hardware Interrupt  [501] exception frame:
 R0:  c00000000090392c    R1:  c000000060b83480    R2:  c0000000010adb68   
 R3:  0000000000000500    R4:  0000000000000001    R5:  0000000000000001   
 R6:  00032e4d45dc10ff    R7:  0000000000ba0000    R8:  0000000000000004   
 R9:  000000000000002b    R10: c0000002cacc0d88    R11: 0000000000000001   
 R12: d000000005c0bef0    R13: c000000007df1c00   
 NIP: c000000000010880    MSR: 8000000100009033    OR3: c00000000047e1cc
 CTR: 0000000000000001    LR:  c000000000010880    XER: 0000000020000000
 CCR: 00000000220c2044    MQ:  0000000000000001    DAR: 8000000100009033
 DSISR: c0000000009544d0     Syscall Result: 0000000000000000

 #1 [c000000060b83480] arch_local_irq_restore at c000000000010880  (unreliable)
 #2 [c000000060b834a0] _raw_spin_unlock_irqrestore at c00000000090392c
 #3 [c000000060b834c0] redirty_page_for_writepage at c000000000230b7c
 #4 [c000000060b83510] xfs_vm_writepage at d000000005c0bfc0 [xfs]
 #5 [c000000060b835f0] write_cache_pages.constprop.10 at c000000000230688
 #6 [c000000060b83730] generic_writepages at c000000000230a00
 #7 [c000000060b837b0] xfs_vm_writepages at d000000005c0a658 [xfs]
 #8 [c000000060b837f0] do_writepages at c0000000002324f0
 #9 [c000000060b83860] __writeback_single_inode at c00000000031eff0
#10 [c000000060b838b0] writeback_sb_inodes at c000000000320e68
#11 [c000000060b839c0] __writeback_inodes_wb at c0000000003212a4
#12 [c000000060b83a30] wb_writeback at c00000000032168c
#13 [c000000060b83b10] bdi_writeback_workfn at c000000000321ea4
#14 [c000000060b83c50] process_one_work at c0000000000ecadc
#15 [c000000060b83cf0] worker_thread at c0000000000ed100
#16 [c000000060b83d80] kthread at c0000000000f8e0c
#17 [c000000060b83e30] ret_from_kernel_thread at c00000000000a3e8

all I have is a snapshot of the system, of course, so I don't know if this
is progressing or not.  But the report is that the system is hung for 
hours (the aio-stress task hasn't run for 1 day, 11:14:39).

Hmmm:

PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
    RUN TIME: 1 days, 11:48:06
  START TIME: 285818
       UTIME: 0
       STIME: 126895310000000

(ok, that's some significant system time ...)

vs

PID: 39292  TASK: c000000038240000  CPU: 27  COMMAND: "aio-stress"
    RUN TIME: 1 days, 11:14:40
  START TIME: 287824
       UTIME: 0
       STIME: 130000000

maybe that is spinning... I'm not quite clear on how to definitively
say whether it's blocking the xfsalloc work from completing...

I'll look more at that writeback thread, but what do you think?

Thanks,
-Eric

> ...
>> and xfs_iomap_write_direct() takes the ilock exclusively.
>>
>>         xfs_ilock(ip, XFS_ILOCK_EXCL);
>>
>> before calling xfs_bmapi_write(), so it must be the holder.  Until
>> this work item runs, everything else working on this inode is stuck,
>> but it's not getting run, behind other items waiting for the lock it
>> holds.
> 
> Again, if xfs is using workqueue correctly, that work item shouldn't
> get stuck at all.  What other workqueues are doing is irrelevant.
> 
> Thanks.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
