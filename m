Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 697797F51
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 11:12:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D89B3AC006
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 09:12:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tKEdKEGI1iDp3REe for
	<xfs@oss.sgi.com>; Tue, 28 May 2013 09:12:34 -0700 (PDT)
Date: Tue, 28 May 2013 12:12:30 -0400
From: Dave Jones <davej@redhat.com>
Subject: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528161230.GA7577@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
xfs chose to spew and then hang instead of replaying the journal and mounting :(

	Dave

[   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[   14.722328] XFS (sda2): Mounting Filesystem
[   14.757801] XFS (sda2): Starting recovery (logdev: internal)
[   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
[   14.783989] ------------[ cut here ]------------
[   14.785547] kernel BUG at fs/xfs/xfs_message.c:108!
[   14.787169] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   14.789038] Modules linked in: xfs libcrc32c coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi e1000e usb_debug snd_hda_intel snd_hda_codec snd_seq ptp snd_seq_device snd_hwdep pps_core snd_pcm snd_page_alloc snd_timer snd soundcore binfmt_misc
[   14.795850] CPU: 1 PID: 300 Comm: mount Not tainted 3.10.0-rc3+ #39 
[   14.800660] task: ffff88022b9e4a40 ti: ffff880240e1a000 task.ti: ffff880240e1a000
[   14.802737] RIP: 0010:[<ffffffffa0259162>]  [<ffffffffa0259162>] assfail+0x22/0x30 [xfs]
[   14.802738] RSP: 0018:ffff880240e1b868  EFLAGS: 00010296
[   14.802739] RAX: 0000000000000048 RBX: ffff88022b653020 RCX: 0000000000000006
[   14.802739] RDX: 0000000000003900 RSI: ffff88022b9e51c0 RDI: ffff88022b9e4a40
[   14.802740] RBP: ffff880240e1b868 R08: 0000000000000001 R09: 0000000000000000
[   14.802740] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880241301bd8
[   14.802741] R13: 0000000000000000 R14: ffff88022b653ed8 R15: ffff88022b653ed8
[   14.802741] FS:  00007fecff34a880(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
[   14.802742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.802743] CR2: 00007f5bc7bfca60 CR3: 000000022b9f4000 CR4: 00000000001407e0
[   14.802743] Stack:
[   14.802745]  ffff880240e1b8d8 ffffffffa029a1a0 000000022b5dcb40 ffff88022b653000
[   14.802746]  ffff88022b653ff8 ffff88022b653004 ffff880200000004 ffff88022b653029
[   14.802747]  ffff880200000002 ffff88022a86de00 ffff88022b653000 ffff88022b653000
[   14.802748] Call Trace:
[   14.802761]  [<ffffffffa029a1a0>] __xfs_dir3_data_check+0x5a0/0x6c0 [xfs]
[   14.802773]  [<ffffffffa029715a>] xfs_dir3_block_verify+0x7a/0x90 [xfs]
[   14.802783]  [<ffffffffa0297425>] xfs_dir3_block_write_verify+0x35/0x120 [xfs]
[   14.802791]  [<ffffffffa02449e5>] ? xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   14.802797]  [<ffffffffa02444db>] _xfs_buf_ioapply+0x6b/0x370 [xfs]
[   14.802801]  [<ffffffff8108ebd0>] ? wake_up_state+0x20/0x20
[   14.802807]  [<ffffffffa02449e5>] ? xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   14.802814]  [<ffffffffa024484b>] xfs_buf_iorequest+0x6b/0x1b0 [xfs]
[   14.802820]  [<ffffffffa02449e5>] xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   14.802826]  [<ffffffffa0244d1d>] __xfs_buf_delwri_submit+0x1ed/0x2f0 [xfs]
[   14.802833]  [<ffffffffa0246000>] xfs_buf_delwri_submit+0x30/0x90 [xfs]
[   14.802847]  [<ffffffffa02b74ba>] xlog_recover_commit_trans+0xda/0x130 [xfs]
[   14.802858]  [<ffffffffa02b76b9>] xlog_recover_process_data+0x179/0x2a0 [xfs]
[   14.802870]  [<ffffffffa02b879d>] xlog_do_recovery_pass+0x4dd/0x760 [xfs]
[   14.802880]  [<ffffffffa02b8abb>] xlog_do_log_recovery+0x9b/0x130 [xfs]
[   14.802890]  [<ffffffffa02b8c56>] xlog_do_recover+0x16/0x1c0 [xfs]
[   14.802900]  [<ffffffffa02b8e82>] xlog_recover+0x82/0xc0 [xfs]
[   14.802913]  [<ffffffffa02c2a80>] xfs_log_mount+0xa0/0x1a0 [xfs]
[   14.802924]  [<ffffffffa02bcd69>] xfs_mountfs+0x3b9/0x800 [xfs]
[   14.802933]  [<ffffffffa025ca58>] xfs_fs_fill_super+0x308/0x390 [xfs]
[   14.802936]  [<ffffffff811b0960>] mount_bdev+0x1c0/0x200
[   14.802944]  [<ffffffffa025c750>] ? xfs_finish_flags+0x130/0x130 [xfs]
[   14.802946]  [<ffffffff8119de78>] ? __kmalloc_track_caller+0x218/0x360
[   14.802955]  [<ffffffffa025a645>] xfs_fs_mount+0x15/0x20 [xfs]
[   14.802957]  [<ffffffff811b12c9>] mount_fs+0x39/0x1b0
[   14.802959]  [<ffffffff81168900>] ? __alloc_percpu+0x10/0x20
[   14.802961]  [<ffffffff811ce803>] vfs_kern_mount+0x63/0xf0
[   14.802963]  [<ffffffff811d10ce>] do_mount+0x23e/0xa20
[   14.802965]  [<ffffffff8116323b>] ? strndup_user+0x4b/0xf0
[   14.802967]  [<ffffffff811d1933>] SyS_mount+0x83/0xc0
[   14.802969]  [<ffffffff816f4dd4>] tracesys+0xdd/0xe2
[   14.802984] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 20 67 2e a0 31 ff 31 c0 e8 ce fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
[   14.802992] RIP  [<ffffffffa0259162>] assfail+0x22/0x30 [xfs]
[   14.802992]  RSP <ffff880240e1b868>

[   40.642521] BUG: soft lockup - CPU#0 stuck for 22s! [fsck.ext2:294]
[   40.644139] Modules linked in: xfs libcrc32c coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi e1000e usb_debug snd_hda_intel snd_hda_codec snd_seq ptp snd_seq_device snd_hwdep pps_core snd_pcm snd_page_alloc snd_timer snd soundcore binfmt_misc
[   40.649456] irq event stamp: 141855
[   40.650742] hardirqs last  enabled at (141855): [<ffffffff816ecd0d>] retint_swapgs+0xe/0x13
[   40.652618] hardirqs last disabled at (141854): [<ffffffff816f4e37>] int_with_check+0x53/0x73
[   40.654515] softirqs last  enabled at (137936): [<ffffffff81054335>] __do_softirq+0x185/0x430
[   40.656410] softirqs last disabled at (137913): [<ffffffff8105479d>] irq_exit+0xcd/0xe0
[   40.658222] CPU: 0 PID: 294 Comm: fsck.ext2 Tainted: G      D      3.10.0-rc3+ #39 
[   40.662692] task: ffff88023d5fca40 ti: ffff8802413e2000 task.ti: ffff8802413e2000
[   40.664421] RIP: 0010:[<ffffffff810c19be>]  [<ffffffff810c19be>] smp_call_function_many+0x2be/0x360
[   40.666343] RSP: 0018:ffff8802413e3d10  EFLAGS: 00000202
[   40.667808] RAX: 0000000000000001 RBX: ffffffff816ecd20 RCX: ffff880244bd8008
[   40.669484] RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000000
[   40.671159] RBP: ffff8802413e3d68 R08: ffff8802444287e0 R09: 0000000000000000
[   40.672860] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802413e3c88
[   40.674536] R13: ffff8802449d3f00 R14: ffff8802413e2000 R15: ffff88023d5fca40
[   40.676215] FS:  00007f784e690780(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
[   40.678014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.679539] CR2: 0000003159c4b102 CR3: 00000002413b7000 CR4: 00000000001407f0
[   40.681225] Stack:
[   40.682307]  0000000144404240 00000000001d4a80 0000000000000000 ffffffff811e2590
[   40.684074]  ffff880244fd4a80 0000000000000282 ffff88022a760fc0 0000000000000000
[   40.685838]  ffffffff811e2590 0000000000000000 0000000000000001 ffff8802413e3da0
[   40.687607] Call Trace:
[   40.688754]  [<ffffffff811e2590>] ? __bforget+0x70/0x70
[   40.690222]  [<ffffffff811e2590>] ? __bforget+0x70/0x70
[   40.691684]  [<ffffffff810c1be2>] on_each_cpu_mask+0x42/0xb0
[   40.693241]  [<ffffffff811e1a10>] ? mark_buffer_async_write+0x20/0x20
[   40.694847]  [<ffffffff810c1d34>] on_each_cpu_cond+0xe4/0x250
[   40.696366]  [<ffffffff811e2590>] ? __bforget+0x70/0x70
[   40.697828]  [<ffffffff811e2119>] invalidate_bh_lrus+0x29/0x30
[   40.699358]  [<ffffffff811e9801>] kill_bdev+0x21/0x30
[   40.700800]  [<ffffffff811ead49>] __blkdev_put+0x69/0x1b0
[   40.702279]  [<ffffffff811eb800>] blkdev_put+0x50/0x160
[   40.703745]  [<ffffffff811eb9c8>] blkdev_close+0x28/0x30
[   40.705209]  [<ffffffff811ae6f5>] __fput+0xf5/0x2d0
[   40.706619]  [<ffffffff811ae98e>] ____fput+0xe/0x10
[   40.708022]  [<ffffffff810745ec>] task_work_run+0xac/0xe0
[   40.709487]  [<ffffffff810029d9>] do_notify_resume+0x69/0x90
[   40.710983]  [<ffffffff816f4eca>] int_signal+0x12/0x17
[   40.712417] Code: 00 41 89 c4 39 f0 0f 8d d5 fd ff ff 48 63 d0 48 8b 0b 48 03 0c d5 40 50 cf 81 f6 41 20 01 74 14 0f 1f 44 00 00 f3 90 f6 41 20 01 <75> f8 48 63 35 e1 6a c3 00 83 f8 ff 48 8b 7b 08 74 b0 39 c6 77 
[   44.790350] ---[ end trace b71cb3732bfc4a50 ]---

[   44.791921] ------------[ cut here ]------------
[   44.793459] WARNING: at kernel/exit.c:715 do_exit+0x55/0xcd0()
[   44.795138] Modules linked in: xfs libcrc32c coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi e1000e usb_debug snd_hda_intel snd_hda_codec snd_seq ptp snd_seq_device snd_hwdep pps_core snd_pcm snd_page_alloc snd_timer
[   44.800315] [sched_delayed] sched: RT throttling activated
[   44.804099]  snd soundcore binfmt_misc
[   44.806032] CPU: 1 PID: 300 Comm: mount Tainted: G      D      3.10.0-rc3+ #39 
[   44.811587]  ffffffff81a0e953 ffff880240e1b588 ffffffff816e375b ffff880240e1b5c0
[   44.813612]  ffffffff8104a1b1 000000000000000b ffff880240e1b7b8 ffff88022b9e4a40
[   44.816016]  0000000000000000 0000000000000000 ffff880240e1b5d0 ffffffff8104a28a
[   44.818374] Call Trace:
[   44.819778]  [<ffffffff816e375b>] dump_stack+0x19/0x1b
[   44.821662]  [<ffffffff8104a1b1>] warn_slowpath_common+0x61/0x80
[   44.823554]  [<ffffffff8104a28a>] warn_slowpath_null+0x1a/0x20
[   44.825390]  [<ffffffff8104f155>] do_exit+0x55/0xcd0
[   44.827120]  [<ffffffff813094a9>] ? __const_udelay+0x29/0x30
[   44.828875]  [<ffffffff81076064>] ? __rcu_read_unlock+0x54/0xa0
[   44.831417]  [<ffffffff8104db2d>] ? kmsg_dump+0x1bd/0x230
[   44.833132]  [<ffffffff8104d995>] ? kmsg_dump+0x25/0x230
[   44.834803]  [<ffffffff816edbe0>] oops_end+0x90/0xd0
[   44.836404]  [<ffffffff8100609b>] die+0x4b/0x70
[   44.838067]  [<ffffffff816ed400>] do_trap+0x60/0x170
[   44.839693]  [<ffffffff81002fc8>] do_invalid_op+0xa8/0xe0
[   44.841508]  [<ffffffffa0259162>] ? assfail+0x22/0x30 [xfs]
[   44.841510]  [<ffffffff8130a91d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   44.841514]  [<ffffffff816ecd50>] ? restore_args+0x30/0x30
[   44.841515]  [<ffffffff816f5db8>] invalid_op+0x18/0x20
[   44.841524]  [<ffffffffa0259162>] ? assfail+0x22/0x30 [xfs]
[   44.841532]  [<ffffffffa0259162>] ? assfail+0x22/0x30 [xfs]
[   44.841545]  [<ffffffffa029a1a0>] __xfs_dir3_data_check+0x5a0/0x6c0 [xfs]
[   44.841557]  [<ffffffffa029715a>] xfs_dir3_block_verify+0x7a/0x90 [xfs]
[   44.841568]  [<ffffffffa0297425>] xfs_dir3_block_write_verify+0x35/0x120 [xfs]
[   44.841575]  [<ffffffffa02449e5>] ? xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   44.841582]  [<ffffffffa02444db>] _xfs_buf_ioapply+0x6b/0x370 [xfs]
[   44.841585]  [<ffffffff8108ebd0>] ? wake_up_state+0x20/0x20
[   44.841591]  [<ffffffffa02449e5>] ? xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   44.841598]  [<ffffffffa024484b>] xfs_buf_iorequest+0x6b/0x1b0 [xfs]
[   44.841604]  [<ffffffffa02449e5>] xfs_bdstrat_cb+0x55/0x1a0 [xfs]
[   44.841611]  [<ffffffffa0244d1d>] __xfs_buf_delwri_submit+0x1ed/0x2f0 [xfs]
[   44.841618]  [<ffffffffa0246000>] xfs_buf_delwri_submit+0x30/0x90 [xfs]
[   44.841632]  [<ffffffffa02b74ba>] xlog_recover_commit_trans+0xda/0x130 [xfs]
[   44.841644]  [<ffffffffa02b76b9>] xlog_recover_process_data+0x179/0x2a0 [xfs]
[   44.841656]  [<ffffffffa02b879d>] xlog_do_recovery_pass+0x4dd/0x760 [xfs]
[   44.841667]  [<ffffffffa02b8abb>] xlog_do_log_recovery+0x9b/0x130 [xfs]
[   44.841678]  [<ffffffffa02b8c56>] xlog_do_recover+0x16/0x1c0 [xfs]
[   44.841688]  [<ffffffffa02b8e82>] xlog_recover+0x82/0xc0 [xfs]
[   44.841700]  [<ffffffffa02c2a80>] xfs_log_mount+0xa0/0x1a0 [xfs]
[   44.841712]  [<ffffffffa02bcd69>] xfs_mountfs+0x3b9/0x800 [xfs]
[   44.841721]  [<ffffffffa025ca58>] xfs_fs_fill_super+0x308/0x390 [xfs]
[   44.841723]  [<ffffffff811b0960>] mount_bdev+0x1c0/0x200
[   44.841732]  [<ffffffffa025c750>] ? xfs_finish_flags+0x130/0x130 [xfs]
[   44.841734]  [<ffffffff8119de78>] ? __kmalloc_track_caller+0x218/0x360
[   44.841743]  [<ffffffffa025a645>] xfs_fs_mount+0x15/0x20 [xfs]
[   44.841745]  [<ffffffff811b12c9>] mount_fs+0x39/0x1b0
[   44.841747]  [<ffffffff81168900>] ? __alloc_percpu+0x10/0x20
[   44.841749]  [<ffffffff811ce803>] vfs_kern_mount+0x63/0xf0
[   44.841751]  [<ffffffff811d10ce>] do_mount+0x23e/0xa20
[   44.841753]  [<ffffffff8116323b>] ? strndup_user+0x4b/0xf0
[   44.841755]  [<ffffffff811d1933>] SyS_mount+0x83/0xc0
[   44.841757]  [<ffffffff816f4dd4>] tracesys+0xdd/0xe2
[   44.841795] ---[ end trace b71cb3732bfc4a51 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
