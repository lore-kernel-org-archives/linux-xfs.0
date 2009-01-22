Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MAEJIc066264 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 04:14:20 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 8652D18400D9
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 02:13:32 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 3BYNTkfO0mt6Hiz3 for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 02:13:32 -0800 (PST)
Date: Thu, 22 Jan 2009 11:06:48 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122100648.GA16660@alice>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
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
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.
> 
> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)
> 
> Except for these nitpicks it looks fine to me.

Using the image at http://www.cccmz.de/~snakebyte/xfs.254.img.bz2
I was able to produce a pretty similar error with the patch applied

[  227.138277] XFS mounting filesystem loop0
[  227.142703] ------------[ cut here ]------------
[  227.142881] kernel BUG at mm/vmalloc.c:164!
[  227.143009] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  227.143040] last sysfs file: /sys/block/ram9/range
[  227.143040] Modules linked in:
[  227.143040] 
[  227.143040] Pid: 5021, comm: mount Tainted: G        W
(2.6.29-rc2-00021-gd84d31c-dirty #221) System Name
[  227.143040] EIP: 0060:[<c0182af1>] EFLAGS: 00010246 CPU: 0
[  227.143040] EIP is at vmap_page_range+0x19/0x112
[  227.143040] EAX: d1000000 EBX: d1000000 ECX: 00000163 EDX: d1000000
[  227.143040] ESI: 00000003 EDI: d1000000 EBP: cb774c48 ESP: cb774c28
[  227.143040]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  227.143040] Process mount (pid: 5021, ti=cb774000 task=cb760000
task.ti=cb774000)
[  227.143040] Stack:
[  227.143040]  00000246 cb760000 00000163 c01414cf cb774c4c d1000000
00000003 cb66ba40
[  227.143040]  cb774c80 c018367c cb7f7ee0 00100000 00000000 cb7f7ee0
00000000 00000014
[  227.143040]  d1000000 cb66bb74 00000000 cb7f7dc0 00000000 cb7f7dc0
cb774c94 c03b2ed6
[  227.143040] Call Trace:
[  227.143040]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  227.143040]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
[  227.143040]  [<c03b2ed6>] ? _xfs_buf_map_pages+0x42/0x6d
[  227.143040]  [<c03b382b>] ? xfs_buf_get_noaddr+0xbc/0x11f
[  227.143040]  [<c03a24bc>] ? xlog_get_bp+0x92/0x97
[  227.143040]  [<c03a343a>] ? xlog_find_zeroed+0x37/0x214
[  227.143040]  [<c0141381>] ? trace_hardirqs_on_caller+0x17/0x15a
[  227.143040]  [<c07b07bc>] ? _spin_unlock_irq+0x32/0x47
[  227.143040]  [<c03a363c>] ? xlog_find_head+0x25/0x358
[  227.143040]  [<c011ca1f>] ? __enqueue_entity+0xa1/0xa9
[  227.143040]  [<c03a398a>] ? xlog_find_tail+0x1b/0x3fa
[  227.143040]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  227.143040]  [<c07b0768>] ? _spin_unlock_irqrestore+0x3b/0x5d
[  227.143040]  [<c07b0774>] ? _spin_unlock_irqrestore+0x47/0x5d
[  227.143040]  [<c01209c6>] ? try_to_wake_up+0x12f/0x13a
[  227.143040]  [<c03a570c>] ? xlog_recover+0x19/0x81
[  227.143040]  [<c03aab7b>] ? xfs_trans_ail_init+0x4b/0x64
[  227.143040]  [<c039f97d>] ? xfs_log_mount+0xef/0x13d
[  227.143040]  [<c03a720a>] ? xfs_mountfs+0x30d/0x5b8
[  227.143040]  [<c05061c1>] ? __debug_object_init+0x28b/0x293
[  227.143040]  [<c012b3b5>] ? init_timer+0x1c/0x1f
[  227.143040]  [<c03a7b59>] ? xfs_mru_cache_create+0x114/0x14e
[  227.143040]  [<c03ba2bd>] ? xfs_fs_fill_super+0x196/0x2e5
[  227.143040]  [<c01919c5>] ? get_sb_bdev+0xf1/0x13f
[  227.143040]  [<c0178896>] ? kstrdup+0x2f/0x51
[  227.143040]  [<c03b88d3>] ? xfs_fs_get_sb+0x18/0x1a
[  227.143040]  [<c03ba127>] ? xfs_fs_fill_super+0x0/0x2e5
[  227.143040]  [<c019159c>] ? vfs_kern_mount+0x40/0x7b
[  227.143040]  [<c0191625>] ? do_kern_mount+0x37/0xbf
[  227.143040]  [<c01a2cb0>] ? do_mount+0x5cc/0x609
[  227.143040]  [<c07b093b>] ? lock_kernel+0x19/0x8c
[  227.143040]  [<c01a2d43>] ? sys_mount+0x56/0xa0
[  227.143040]  [<c01a2d56>] ? sys_mount+0x69/0xa0
[  227.143040]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  227.143040] Code: 0f 0b eb fe ba 01 00 00 00 89 c8 e8 02 ff ff ff 5d
c3 55 89 e5 57 56 53 83 ec 14 0f 1f 44 00 00 39 d0 89 c3 89 d7 89 4d e8
72 04 <0f> 0b eb fe c1 e8 16 8d 34 85 00 00 00 00 03 35 84 91 a3 c0 8d 
[  227.143040] EIP: [<c0182af1>] vmap_page_range+0x19/0x112 SS:ESP
0068:cb774c28
[  227.161166] ---[ end trace a7919e7f17c0a727 ]---
[  553.569010] general protection fault: 0000 [#2] PREEMPT
DEBUG_PAGEALLOC
[  553.569043] last sysfs file: /sys/block/ram9/range
[  553.569043] Modules linked in:
[  553.569043] 
[  553.569043] Pid: 328, comm: kswapd0 Tainted: G      D W
(2.6.29-rc2-00021-gd84d31c-dirty #221) System Name
[  553.569043] EIP: 0060:[<c0181bb6>] EFLAGS: 00010282 CPU: 0
[  553.569043] EIP is at page_referenced+0x85/0xdf
[  553.569043] EAX: 00000000 EBX: c12b5f20 ECX: cf168e60 EDX: ffffffff
[  553.569043] ESI: ffffffcb EDI: cb665580 EBP: cf168e70 ESP: cf168e54
[  553.569043]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  553.569043] Process kswapd0 (pid: 328, ti=cf168000 task=cf090000
task.ti=cf168000)
[  553.569043] Stack:
[  553.569043]  cb6655a4 00000000 00000000 00000001 c12b5f20 00000000
c0a88964 cf168ef4
[  553.569043]  c0174049 cf168edc cf168f70 00000000 c0a88c00 c0a88bb0
cf090000 00000005
[  553.569043]  c1074578 cf168ea8 cf168ed8 cf168eb4 c013f6f2 c0a88bb0
cf090000 ffffffff
[  553.569043] Call Trace:
[  553.569043]  [<c0174049>] ? shrink_active_list+0x12d/0x2e3
[  553.569043]  [<c013f6f2>] ? print_lock_contention_bug+0x11/0xb2
[  553.569043]  [<c0174c5f>] ? shrink_zone+0x95/0x24b
[  553.569043]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  553.569043]  [<c07b07bc>] ? _spin_unlock_irq+0x32/0x47
[  553.569043]  [<c0174e00>] ? shrink_zone+0x236/0x24b
[  553.569043]  [<c0175546>] ? kswapd+0x2d1/0x443
[  553.569043]  [<c01735d1>] ? isolate_pages_global+0x0/0x1d2
[  553.569043]  [<c013416c>] ? autoremove_wake_function+0x0/0x35
[  553.569043]  [<c0175275>] ? kswapd+0x0/0x443
[  553.569043]  [<c0134094>] ? kthread+0x3e/0x66
[  553.569043]  [<c0134056>] ? kthread+0x0/0x66
[  553.569043]  [<c01035a7>] ? kernel_thread_helper+0x7/0x10
[  553.569043] Code: 45 f0 8d 47 24 8b 77 24 89 45 e4 83 ee 34 eb 1b 8d
4d f0 89 f2 89 d8 e8 0d f7 ff ff 01 45 ec 83 7d f0 00 74 15 8b 76 34 83
ee 34 <8b> 46 34 0f 18 00 90 8d 46 34 3b 45 e4 75 d6 89 f8 e8 51 f4 ff 
[  553.569043] EIP: [<c0181bb6>] page_referenced+0x85/0xdf SS:ESP
0068:cf168e54
[  553.582779] ---[ end trace a7919e7f17c0a728 ]---
[  553.582900] note: kswapd0[328] exited with preempt_count 1
[  697.933024] BUG: soft lockup - CPU#0 stuck for 61s! [make:14851]
[  697.933024] Modules linked in:
[  697.933024] irq event stamp: 0
[  697.933024] hardirqs last  enabled at (0): [<(null)>] (null)
[  697.933024] hardirqs last disabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  697.933024] softirqs last  enabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  697.933024] softirqs last disabled at (0): [<(null)>] (null)
[  697.933024] 
[  697.933024] Pid: 14851, comm: make Tainted: G      D W
(2.6.29-rc2-00021-gd84d31c-dirty #221) System Name
[  697.933024] EIP: 0060:[<c07b2628>] EFLAGS: 00000286 CPU: 0
[  697.933024] EIP is at add_preempt_count+0x0/0xde
[  697.933024] EAX: 00000001 EBX: 00000001 ECX: c018100f EDX: 00000096
[  697.933024] ESI: 166556bb EDI: 00000001 EBP: c1c83bd0 ESP: c1c83bbc
[  697.933024]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  697.933024] CR0: 8005003b CR2: 400c3044 CR3: 01c87000 CR4: 000006d0
[  697.933024] DR0: c0122f08 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  697.933024] DR6: ffff0ff0 DR7: 00000400
[  697.933024] Call Trace:
[  697.933024]  [<c04f87fa>] ? delay_tsc+0x1a/0x88
[  697.933024]  [<c04f8778>] __delay+0xe/0x10
[  697.933024]  [<c0505465>] _raw_spin_lock+0x83/0xcb
[  697.933024]  [<c07b00da>] _spin_lock+0x4c/0x5d
[  697.933024]  [<c018100f>] page_lock_anon_vma+0x29/0x37
[  697.933024]  [<c0181b79>] page_referenced+0x48/0xdf
[  697.933024]  [<c07b07bc>] ? _spin_unlock_irq+0x32/0x47
[  697.933024]  [<c0173ddb>] ? __remove_mapping+0xb8/0xcd
[  697.933024]  [<c017433f>] shrink_page_list+0x140/0x5ff
[  697.933024]  [<c017499c>] shrink_list+0x19e/0x3cc
[  697.933024]  [<c0174d9f>] shrink_zone+0x1d5/0x24b
[  697.933024]  [<c0175121>] try_to_free_pages+0x1b4/0x29e
[  697.933024]  [<c01735d1>] ? isolate_pages_global+0x0/0x1d2
[  697.933024]  [<c017022f>] __alloc_pages_internal+0x247/0x3af
[  697.933024]  [<c018b4cd>] ? __slab_alloc+0x181/0x50b
[  697.933024]  [<c018b50d>] __slab_alloc+0x1c1/0x50b
[  697.933024]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  697.933024]  [<c018bb5a>] kmem_cache_alloc+0x7c/0xea
[  697.933024]  [<c0121f43>] ? copy_process+0x69/0xfef
[  697.933024]  [<c0121f43>] ? copy_process+0x69/0xfef
[  697.933024]  [<c0121f43>] copy_process+0x69/0xfef
[  697.933024]  [<c013f6f2>] ? print_lock_contention_bug+0x11/0xb2
[  697.933024]  [<c018de9a>] ? fd_install+0x28/0x55
[  697.933024]  [<c0123029>] do_fork+0x121/0x2b8
[  697.933024]  [<c04f9195>] ? copy_to_user+0x38/0x43
[  697.933024]  [<c04f8b60>] ? trace_hardirqs_on_thunk+0xc/0x10
[  697.933024]  [<c0102ecf>] ? sysenter_exit+0xf/0x16
[  697.933024]  [<c01015a2>] sys_vfork+0x1e/0x20
[  697.933024]  [<c0102f7a>] syscall_call+0x7/0xb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
