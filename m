Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 698357F3F
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 16:53:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EA908F8033
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 14:53:22 -0800 (PST)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	CDebFFdsWS7IMxrw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 14:53:18 -0800 (PST)
Received: by mail-qc0-f179.google.com with SMTP id c9so20370210qcz.10
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 14:53:17 -0800 (PST)
Date: Mon, 12 Jan 2015 17:53:14 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150112225314.GC22156@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B429EB.9050807@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello, Eric.

On Mon, Jan 12, 2015 at 02:09:15PM -0600, Eric Sandeen wrote:
> crash> bt 17056
> PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
                                                                 ^
This is an unbound worker which doesn't participate in the concurrency
management, so this can't be the direct source althought it can
definitely be causing something else.

>  #0 [c000000060b83190] hardware_interrupt_common at c000000000002294
>  Hardware Interrupt  [501] exception frame:
...
>  #1 [c000000060b83480] arch_local_irq_restore at c000000000010880  (unreliable)
>  #2 [c000000060b834a0] _raw_spin_unlock_irqrestore at c00000000090392c
>  #3 [c000000060b834c0] redirty_page_for_writepage at c000000000230b7c
>  #4 [c000000060b83510] xfs_vm_writepage at d000000005c0bfc0 [xfs]
>  #5 [c000000060b835f0] write_cache_pages.constprop.10 at c000000000230688
>  #6 [c000000060b83730] generic_writepages at c000000000230a00
>  #7 [c000000060b837b0] xfs_vm_writepages at d000000005c0a658 [xfs]
>  #8 [c000000060b837f0] do_writepages at c0000000002324f0
>  #9 [c000000060b83860] __writeback_single_inode at c00000000031eff0
> #10 [c000000060b838b0] writeback_sb_inodes at c000000000320e68
> #11 [c000000060b839c0] __writeback_inodes_wb at c0000000003212a4
> #12 [c000000060b83a30] wb_writeback at c00000000032168c
> #13 [c000000060b83b10] bdi_writeback_workfn at c000000000321ea4
> #14 [c000000060b83c50] process_one_work at c0000000000ecadc
> #15 [c000000060b83cf0] worker_thread at c0000000000ed100
> #16 [c000000060b83d80] kthread at c0000000000f8e0c
> #17 [c000000060b83e30] ret_from_kernel_thread at c00000000000a3e8
> 
> all I have is a snapshot of the system, of course, so I don't know if this
> is progressing or not.  But the report is that the system is hung for 
> hours (the aio-stress task hasn't run for 1 day, 11:14:39).

I see.

> Hmmm:
> 
> PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
>     RUN TIME: 1 days, 11:48:06

lol, that's some serious cpu burning.

>   START TIME: 285818
>        UTIME: 0
>        STIME: 126895310000000
> 
> (ok, that's some significant system time ...)
> 
> vs
> 
> PID: 39292  TASK: c000000038240000  CPU: 27  COMMAND: "aio-stress"
>     RUN TIME: 1 days, 11:14:40
>   START TIME: 287824
>        UTIME: 0
>        STIME: 130000000
> 
> maybe that is spinning... I'm not quite clear on how to definitively
> say whether it's blocking the xfsalloc work from completing...
> 
> I'll look more at that writeback thread, but what do you think?

This doesn't look like the direct cause.  It could just be reclaim
path going berserk as the filesystem can't writeout pages.  Can you
dump all runnable tasks?  Was this the only runnable kworker?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
