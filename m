Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB6267F84
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 04:58:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45F7EAC002
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 02:58:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8r1LxAbWK3SX9LXX for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 02:58:29 -0700 (PDT)
Date: Thu, 10 Oct 2013 20:58:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010095824.GX4446@dastard>
References: <20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
	<20131010033834.GA13141@localhost> <20131010042820.GA5663@dastard>
	<20131010060334.GA17576@localhost> <20131010080652.GW4446@dastard>
	<20131010082350.GA31385@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010082350.GA31385@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 04:23:50PM +0800, Fengguang Wu wrote:
> Dave,
> 
> >> This is an easily reproducible bug. And I further confirmed it in
> >> two ways:
> >>
> >> 1) turn off XFS, build 39 commits and boot them 2000+ times
> >>
> >> => no single mount error
> >
> >That doesn't tell you it is an XFS error. Absence of symptoms !=
> >absence of bug.
> 
> True.
> 
> >> 2) turn off all other filesystems, build 2 kernels on v3.12-rc3
> >>    v3.12-rc4 and boot them
> >> 
> >> => half boots have oops
> >
> >Again, it doesn't tell you that it is an XFS bug. XFS is well known
> >for exposing bugs in less used block devices, and you are definitely
> >using devices that are unusual and not commonly tested by filesystem
> >developers (e.g. zram, nbd, etc).
> >
> 
> Yeah, it's possible that your commit exposed a bug in the less used
> nbd/zram devices.

So please reproduce it on a brd/scsi/sata/virtio block device before
going any further. Preferably with a bash script I can point at a
single block device, not a binary initrd blob that I have to
deconstruct to try to work out what your test is doing.

because this:

> [    7.707009] end_request: I/O error, dev fd0, sector 0
> [   10.475988] block nbd4: Attempted send on closed socket
> [   10.478272] end_request: I/O error, dev nbd4, sector 0
> [   10.492950] block nbd15: Attempted send on closed socket
> [   10.498283] end_request: I/O error, dev nbd15, sector 0

says that nbd is going through I/O error land, and that's the most
likely cause of problems being seen by higher level IO completion
operations....

> [   10.504236] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   10.507558] IP: [<c1034419>] pool_mayday_timeout+0x5f/0x9c

And that's deep inside the workqueue infrastructure, indicating that
rescues are being used (allocation deadlock?) which is also less
tested error handling code path....

> [   10.507558] *pdpt = 000000000ce6a001 *pde = 0000000000000000
> [   10.507558] Oops: 0000 [#1]
> [   10.507558] CPU: 0 PID: 516 Comm: mount Not tainted 3.12.0-rc4 #2
> [   10.507558] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   10.507558] task: ccda7440 ti: cf40a000 task.ti: cce2e000
> [   10.507558] EIP: 0060:[<c1034419>] EFLAGS: 00010046 CPU: 0
> [   10.507558] EIP is at pool_mayday_timeout+0x5f/0x9c
> [   10.507558] EAX: 00000000 EBX: c1931d50 ECX: 00000000 EDX: 00000000
> [   10.507558] ESI: c10343ba EDI: cd5a3258 EBP: cf40bf94 ESP: cf40bf80
> [   10.507558]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   10.507558] CR0: 8005003b CR2: 00000004 CR3: 0cdbd000 CR4: 000006b0
> [   10.507558] Stack:
> [   10.507558]  c1931d60 cf40bf90 00000100 c10343ba cf40bfc0 cf40bfa4 c102cd96 c1a52700
> [   10.507558]  cf40bfc0 cf40bfd4 c102cf7e c1931d50 c1a53110 c1a52f10 cf40bfc0 c10343ba
> [   10.507558]  cf40bfc0 cf40bfc0 00000001 c1a52588 00000100 cf40bff8 c1028f61 00000001
> [   10.507558] Call Trace:
> [   10.507558]  [<c10343ba>] ? need_to_create_worker+0x32/0x32
> [   10.507558]  [<c102cd96>] call_timer_fn.isra.39+0x16/0x60
> [   10.507558]  [<c102cf7e>] run_timer_softirq+0x144/0x15e
> [   10.507558]  [<c10343ba>] ? need_to_create_worker+0x32/0x32
> [   10.507558]  [<c1028f61>] __do_softirq+0x87/0x12b
> [   10.507558]  [<c1028eda>] ? local_bh_enable_ip+0xa/0xa
> [   10.507558]  <IRQ>
> [   10.507558]  [<c10290c4>] ? irq_exit+0x3a/0x48
> [   10.507558]  [<c1018818>] ? smp_apic_timer_interrupt+0x23/0x2c
> [   10.507558]  [<c164f38d>] ? apic_timer_interrupt+0x2d/0x34
> [   10.507558]  [<c126f5e2>] ? arch_local_irq_restore+0x5/0xb
> [   10.507558]  [<c126f694>] ? spin_unlock_irqrestore.isra.4+0x8/0x14
> [   10.507558]  [<c126f705>] ? nbd_end_request+0x65/0x6d
> [   10.507558]  [<c126f784>] ? do_nbd_request+0x77/0xc1
> [   10.507558]  [<c11abe4f>] ? __blk_run_queue_uncond+0x1e/0x27
> [   10.507558]  [<c11abe6b>] ? __blk_run_queue+0x13/0x15
> [   10.507558]  [<c11abfe8>] ? queue_unplugged.isra.56+0x13/0x1f
> [   10.507558]  [<c11ad70b>] ? blk_flush_plug_list+0x140/0x14f
> [   10.507558]  [<c11ad95f>] ? blk_finish_plug+0xd/0x27
> [   10.507558]  [<c11051b6>] ? _xfs_buf_ioapply+0x236/0x24e

and it has happened deep inside the nbd IO path in the context of
the xfs_buf allocation that has seen corruptions in previous dumps.

So before I look any further at this, you need to rule out nbd as
the cause of the problems because the XFS code paths on scsi, sata,
brd and virtio block device don't cause any problems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
