Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R9MTQ0034067 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 03:22:30 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 554241867163
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 01:21:44 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id XBmVOzkMVCX3pF8q for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2009 01:21:44 -0800 (PST)
Date: Tue, 27 Jan 2009 10:21:41 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: List corruption with corrupted xfs image
Message-ID: <20090127092141.GA7068@alice>
References: <20090122091255.GB29546@alice>
	<20090122201149.GA13282@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122201149.GA13282@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Jan 22, 2009 at 10:12:55AM +0100, Eric Sesterhenn wrote:
> > Hi,
> > 
> > with the image at http://www.cccmz.de/~snakebyte/xfs.42.img.bz2
> > and the following commands:
> > 
> >   mount -o loop -t xfs xfs.42.img /media/test
> >   touch /media/test/file >/dev/null 2>&1
> >   ln -s /media/test/file /media/test/fileb >/dev/null 2>&1
> >   mkdir /media/test/dir1 >/dev/null 2>&1
> >   cp /media/test/file /media/test/dir1 >/dev/null 2>&1
> >   umount /media/test
> > 
> > I get a list corruption and dead box
> 
> The oops is in code we don't have around anymore in 2.6.29-rc, but I'll
> give it a try on more recent code.

I tried this again with todays -git and got a different trace,
but I guess the trace is where the corruption was 
detected, not where it occured.

[ 4860.163183] XFS mounting filesystem loop0
[ 4882.817393] ------------[ cut here ]------------
[ 4882.817521] WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
[ 4882.817642] Hardware name: System Name
[ 4882.817734] list_add corruption. next->prev should be prev
(c0a47670), but was c2cbd1a8. (next=c929ddb4).
[ 4882.817922] Modules linked in: [last unloaded: rcutorture]
[ 4882.818148] Pid: 4921, comm: bash Tainted: G        W
2.6.29-rc2-00362-g884f64f #224
[ 4882.818312] Call Trace:
[ 4882.818412]  [<c0123b31>] warn_slowpath+0x79/0x8f
[ 4882.818531]  [<c020a89c>] ? ext3_getblk+0x51/0x170
[ 4882.818628]  [<c020a8f3>] ? ext3_getblk+0xa8/0x170
[ 4882.818745]  [<c018aa63>] ? check_bytes_and_report+0x26/0x94
[ 4882.818849]  [<c018b6ce>] ? __slab_alloc+0xb6/0x50b
[ 4882.818964]  [<c018be00>] ? kmem_cache_alloc+0x56/0xea
[ 4882.819124]  [<c07b2507>] ? sub_preempt_count+0xc0/0xd1
[ 4882.819230]  [<c013f96a>] ? print_lock_contention_bug+0x11/0xb2
[ 4882.819351]  [<c013f96a>] ? print_lock_contention_bug+0x11/0xb2
[ 4882.819457]  [<c019f759>] ? iget_locked+0x59/0x120
[ 4882.819571]  [<c050555b>] __list_add+0x27/0x5c
[ 4882.819666]  [<c019f78b>] iget_locked+0x8b/0x120
[ 4882.819781]  [<c020c376>] ext3_iget+0x13/0x333
[ 4882.819878]  [<c020f46e>] ext3_lookup+0x6d/0xa8
[ 4882.819996]  [<c0196650>] do_lookup+0xbc/0x159
[ 4882.820150]  [<c01982cb>] __link_path_walk+0x6cd/0xa65
[ 4882.820251]  [<c07b2507>] ? sub_preempt_count+0xc0/0xd1
[ 4882.820372]  [<c013f96a>] ? print_lock_contention_bug+0x11/0xb2
[ 4882.820479]  [<c01986a0>] path_walk+0x3d/0x76
[ 4882.820594]  [<c019884f>] do_path_lookup+0xee/0x14f
[ 4882.820695]  [<c0197adf>] ? getname+0x65/0xb8
[ 4882.820809]  [<c01990b0>] user_path_at+0x41/0x67
[ 4882.820912]  [<c023a1fc>] ? journal_stop+0x2d2/0x2dd
[ 4882.821074]  [<c01a23b7>] ? mnt_drop_write+0x20/0xee
[ 4882.821178]  [<c0141747>] ? trace_hardirqs_on+0xb/0xd
[ 4882.821297]  [<c0192e15>] vfs_stat_fd+0x1e/0x45
[ 4882.821395]  [<c0192eff>] vfs_stat+0x16/0x18
[ 4882.821507]  [<c0192f1a>] sys_stat64+0x19/0x2f
[ 4882.821619]  [<c07ae635>] ? mutex_unlock+0xd/0xf
[ 4882.821736]  [<c019af27>] ? vfs_readdir+0x76/0x87
[ 4882.821837]  [<c019ad20>] ? filldir64+0x0/0xd2
[ 4882.821967]  [<c04f8860>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 4882.822130]  [<c0102ecf>] ? sysenter_exit+0xf/0x16
[ 4882.822233]  [<c01415f9>] ? trace_hardirqs_on_caller+0x17/0x15a
[ 4882.822356]  [<c04f8860>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 4882.822460]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[ 4882.822574] ---[ end trace a7919e7f17c0a727 ]---
[ 4949.950030] BUG: soft lockup - CPU#0 stuck for 61s! [umount:7487]
[ 4949.950030] Modules linked in: [last unloaded: rcutorture]
[ 4949.950030] irq event stamp: 0
[ 4949.950030] hardirqs last  enabled at (0): [<(null)>] (null)
[ 4949.950030] hardirqs last disabled at (0): [<c012223a>]
copy_process+0x31f/0xfef
[ 4949.950030] softirqs last  enabled at (0): [<c012223a>]
copy_process+0x31f/0xfef
[ 4949.950030] softirqs last disabled at (0): [<(null)>] (null)
[ 4949.950030] 
[ 4949.950030] Pid: 7487, comm: umount Tainted: G        W
(2.6.29-rc2-00362-g884f64f #224) System Name
[ 4949.950030] EIP: 0060:[<c01a64c9>] EFLAGS: 00000246 CPU: 0
[ 4949.950030] EIP is at generic_sync_sb_inodes+0xb0/0x2e6
[ 4949.950030] EAX: cf4b751c EBX: cf4b7524 ECX: c2cbd1a8 EDX: c2cbd1a8
[ 4949.950030] ESI: c2cbd1a8 EDI: c2cbd0c0 EBP: cbb94ec8 ESP: cbb94e94
[ 4949.950030]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 4949.950030] CR0: 8005003b CR2: b7ce8000 CR3: 0336e000 CR4: 000006d0
[ 4949.950030] DR0: c0122f49 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 4949.950030] DR6: ffff0ff0 DR7: 00000400
[ 4949.950030] Call Trace:
[ 4949.950030]  [<c013f96a>] ? print_lock_contention_bug+0x11/0xb2
[ 4949.950030]  [<c01a670c>] sync_sb_inodes+0xd/0xf
[ 4949.950030]  [<c01a6776>] sync_inodes_sb+0x68/0x6f
[ 4949.950030]  [<c0191372>] __fsync_super+0x12/0x6b
[ 4949.950030]  [<c01913db>] fsync_super+0x10/0x1e
[ 4949.950030]  [<c0191680>] generic_shutdown_super+0x21/0xc9
[ 4949.950030]  [<c019174a>] kill_block_super+0x22/0x36
[ 4949.950030]  [<c0191815>] deactivate_super+0x5c/0x6f
[ 4949.950030]  [<c01a1eaf>] mntput_no_expire+0xa0/0xca
[ 4949.950030]  [<c01a235d>] sys_umount+0x25f/0x285
[ 4949.950030]  [<c01a2395>] sys_oldumount+0x12/0x14
[ 4949.950030]  [<c0102ea1>] sysenter_do_call+0x12/0x31

Greetings, Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
