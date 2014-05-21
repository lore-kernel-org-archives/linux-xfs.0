Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDB107F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 02:33:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D515304081
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 00:33:52 -0700 (PDT)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	lZEk05cdWpi9DYea (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 00:33:50 -0700 (PDT)
Received: by mail-ve0-f180.google.com with SMTP id db12so1991596veb.39
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 00:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
	<CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
Date: Wed, 21 May 2014 09:33:49 +0200
Message-ID: <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Richard Weinberger <richard.weinberger@gmail.com>
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
To: Austin Schuh <austin@peloton-tech.com>
Cc: rt-users <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

CC'ing RT folks

On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com> wrote:
> On Tue, May 13, 2014 at 7:29 PM, Austin Schuh <austin@peloton-tech.com> wrote:
>> Hi,
>>
>> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
>> patched kernel.  I have currently only triggered it using dpkg.  Dave
>> Chinner on the XFS mailing list suggested that it was a rt-kernel
>> workqueue issue as opposed to a XFS problem after looking at the
>> kernel messages.
>>
>> The only modification to the kernel besides the RT patch is that I
>> have applied tglx's "genirq: Sanitize spurious interrupt detection of
>> threaded irqs" patch.
>
> I upgraded to 3.14.3-rt4, and the problem still persists.
>
> I turned on event tracing and tracked it down further.  I'm able to
> lock it up by scping a new kernel debian package to /tmp/ on the
> machine.  scp is locking the inode, and then scheduling
> xfs_bmapi_allocate_worker in the work queue.  The work then never gets
> run.  The kworkers then lock up waiting for the inode lock.
>
> Here are the relevant events from the trace.  ffff8803e9f10288
> (blk_delay_work) gets run later on in the trace, but ffff8803b4c158d0
> (xfs_bmapi_allocate_worker) never does.  The kernel then warns about
> blocked tasks 120 seconds later.
>
>
>              scp-5393  [001] ....1..   148.883383: xfs_writepage: dev
> 8:5 ino 0xd8e pgoff 0x4a3e000 size 0x16af02b0 offset 0 length 0
> delalloc 1 unwritten 0
>              scp-5393  [001] ....1..   148.883383: xfs_ilock_nowait:
> dev 8:5 ino 0xd8e flags ILOCK_SHARED caller xfs_map_blocks
>              scp-5393  [001] ....1..   148.883384: xfs_iunlock: dev
> 8:5 ino 0xd8e flags ILOCK_SHARED caller xfs_map_blocks
>              scp-5393  [001] ....1..   148.883386: xfs_log_reserve:
> dev 8:5 type STRAT_WRITE t_ocnt 2 t_cnt 2 t_curr_res 112332 t_unit_res
> 112332 t_flags XLOG_TIC_INITED|XLOG_TIC_PERM_RESERV reserveq empty
> writeq empty grant_reserve_cycle 57 grant_reserve_bytes 9250852
> grant_write_cycle 57 grant_write_bytes 9250852 curr_cycle 57
> curr_block 18031 tail_cycle 57 tail_block 17993
>              scp-5393  [001] ....1..   148.883386:
> xfs_log_reserve_exit: dev 8:5 type STRAT_WRITE t_ocnt 2 t_cnt 2
> t_curr_res 112332 t_unit_res 112332 t_flags
> XLOG_TIC_INITED|XLOG_TIC_PERM_RESERV reserveq empty writeq empty
> grant_reserve_cycle 57 grant_reserve_bytes 9475516 grant_write_cycle
> 57 grant_write_bytes 9475516 curr_cycle 57 curr_block 18031 tail_cycle
> 57 tail_block 17993
>              scp-5393  [001] ....1..   148.883386: xfs_ilock: dev 8:5
> ino 0xd8e flags ILOCK_EXCL caller xfs_iomap_write_allocate
>              scp-5393  [001] ....1.3   148.883390:
> workqueue_queue_work: work struct=ffff8803b4c158d0
> function=xfs_bmapi_allocate_worker workqueue=ffff8803ea85dc00
> req_cpu=512 cpu=1
>              scp-5393  [001] ....1.3   148.883390:
> workqueue_activate_work: work struct ffff8803b4c158d0
>              scp-5393  [001] ....1.4   148.883396:
> workqueue_queue_work: work struct=ffff8803e9f10288
> function=blk_delay_work workqueue=ffff8803ecf96200 req_cpu=512 cpu=1
>              scp-5393  [001] ....1.4   148.883396:
> workqueue_activate_work: work struct ffff8803e9f10288
>              scp-5393  [001] dN..3.4   148.883399: sched_wakeup:
> comm=kworker/1:1H pid=573 prio=100 success=1 target_cpu=001
>              scp-5393  [001] dN..3.4   148.883400: sched_stat_runtime:
> comm=scp pid=5393 runtime=32683 [ns] vruntime=658862317 [ns]
>              scp-5393  [001] d...3.4   148.883400: sched_switch:
> prev_comm=scp prev_pid=5393 prev_prio=120 prev_state=R+ ==>
> next_comm=kworker/1:1H next_pid=573 next_prio=100
>
>     irq/44-ahci-273   [000] d...3.5   148.883647: sched_wakeup:
> comm=kworker/0:2 pid=732 prio=120 success=1 target_cpu=000
>     irq/44-ahci-273   [000] d...3..   148.883667: sched_switch:
> prev_comm=irq/44-ahci prev_pid=273 prev_prio=49 prev_state=S ==>
> next_comm=kworker/0:2 next_pid=732 next_prio=120
>     kworker/0:2-732   [000] ....1..   148.883674:
> workqueue_execute_start: work struct ffff8800aea30cb8: function
> xfs_end_io
>     kworker/0:2-732   [000] ....1..   148.883674: xfs_ilock: dev 8:5
> ino 0xd8e flags ILOCK_EXCL caller xfs_setfilesize
>     kworker/0:2-732   [000] d...3..   148.883677: sched_stat_runtime:
> comm=kworker/0:2 pid=732 runtime=11392 [ns] vruntime=46907654869 [ns]
>     kworker/0:2-732   [000] d...3..   148.883679: sched_switch:
> prev_comm=kworker/0:2 prev_pid=732 prev_prio=120 prev_state=D ==>
> next_comm=swapper/0 next_pid=0 next_prio=120
>
>    kworker/1:1-99    [001] ....1..   148.884208:
> workqueue_execute_start: work struct ffff8800aea30c20: function
> xfs_end_io
>     kworker/1:1-99    [001] ....1..   148.884208: xfs_ilock: dev 8:5
> ino 0xd8e flags ILOCK_EXCL caller xfs_setfilesize
>     kworker/1:1-99    [001] d...3..   148.884210: sched_stat_runtime:
> comm=kworker/1:1 pid=99 runtime=36705 [ns] vruntime=48354424724 [ns]
>     kworker/1:1-99    [001] d...3..   148.884211: sched_switch:
> prev_comm=kworker/1:1 prev_pid=99 prev_prio=120 prev_state=R+ ==>
> next_comm=swapper/1 next_pid=0 next_prio=120
>
>   kworker/u16:4-296   [001] ....1..   151.560358:
> workqueue_execute_start: work struct ffff8803e9f10660: function
> bdi_writeback_workfn
>   kworker/u16:4-296   [001] ....1..   151.560389:
> workqueue_execute_end: work struct ffff8803e9f10660
>   kworker/u16:4-296   [001] d...3..   151.560398: sched_stat_runtime:
> comm=kworker/u16:4 pid=296 runtime=51174 [ns] vruntime=48345513312
> [ns]
>   kworker/u16:4-296   [001] d...3..   151.560403: sched_switch:
> prev_comm=kworker/u16:4 prev_pid=296 prev_prio=120 prev_state=R+ ==>
> next_comm=swapper/1 next_pid=0 next_prio=120
>
>
> I have a peak_pci can card in the machine that is consuming about 1.5
> CPU cores because it is not connected to a CAN bus and gets error
> interrupts every time it tries to send and resend.  If I disable the
> card (ifconfig can0 down; ifconfig can1 down), I have a lot more
> trouble reproducing the lockup.
>
> Any ideas why the scheduled work is never getting run?
>
> Thanks,
> Austin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
