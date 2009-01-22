Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M9Dl4C063552 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 03:13:48 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id ECBEAAB071
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 01:13:00 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id qBmW4qPthckpJDob for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 01:13:00 -0800 (PST)
Date: Thu, 22 Jan 2009 10:12:55 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: List corruption with corrupted xfs image
Message-ID: <20090122091255.GB29546@alice>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Hi,

with the image at http://www.cccmz.de/~snakebyte/xfs.42.img.bz2
and the following commands:

  mount -o loop -t xfs xfs.42.img /media/test
  touch /media/test/file >/dev/null 2>&1
  ln -s /media/test/file /media/test/fileb >/dev/null 2>&1
  mkdir /media/test/dir1 >/dev/null 2>&1
  cp /media/test/file /media/test/dir1 >/dev/null 2>&1
  umount /media/test

I get a list corruption and dead box

[  229.389247] XFS mounting filesystem loop0
[  229.408550] Ending clean XFS mount for filesystem: loop0
[  229.794445] ------------[ cut here ]------------
[  229.794620] WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
[  229.794792] Hardware name: System Name
[  229.794920] list_add corruption. next->prev should be prev
(c0a47670), but was ca342698. (next=c7e41db4).
[  229.795225] Modules linked in:
[  229.795439] Pid: 5039, comm: cp Not tainted
2.6.29-rc2-00021-gd84d31c-dirty #221
[  229.795626] Call Trace:
[  229.795789]  [<c0123af1>] warn_slowpath+0x79/0x8f
[  229.795932]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  229.796202]  [<c0142c7a>] ? __lock_acquire+0x6a8/0x6fe
[  229.796344]  [<c013ec6d>] ? put_lock_stats+0xd/0x21
[  229.796508]  [<c019f495>] ? iget_locked+0x59/0x120
[  229.796645]  [<c050585b>] __list_add+0x27/0x5c
[  229.796803]  [<c019f4c7>] iget_locked+0x8b/0x120
[  229.796945]  [<c01c5145>] proc_get_inode+0x74/0x134
[  229.797168]  [<c01c91b8>] proc_lookup_de+0x79/0xaa
[  229.797304]  [<c01c948f>] proc_lookup+0x17/0x1c
[  229.797461]  [<c01c57ba>] proc_root_lookup+0x16/0x30
[  229.797604]  [<c019638c>] do_lookup+0xbc/0x159
[  229.797763]  [<c0198007>] __link_path_walk+0x6cd/0xa65
[  229.797912]  [<c0107084>] ? native_sched_clock+0x41/0x68
[  229.798131]  [<c01983dc>] path_walk+0x3d/0x76
[  229.798264]  [<c019858b>] do_path_lookup+0xee/0x14f
[  229.798425]  [<c0198f50>] path_lookup_open+0x48/0x7a
[  229.798564]  [<c0199181>] do_filp_open+0xa6/0x668
[  229.798738]  [<c017ccb3>] ? might_fault+0x4f/0x8b
[  229.798877]  [<c0107084>] ? native_sched_clock+0x41/0x68
[  229.799118]  [<c07b0696>] ? _spin_unlock+0x2c/0x41
[  229.799261]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  229.799425]  [<c07b2617>] ? sub_preempt_count+0xc0/0xd1
[  229.799565]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  229.799728]  [<c018e052>] do_sys_open+0x47/0xbd
[  229.799864]  [<c0102ecf>] ? sysenter_exit+0xf/0x16
[  229.800143]  [<c018e114>] sys_open+0x23/0x2b
[  229.800278]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  229.800437] ---[ end trace 826801eb6ce5fdb9 ]---
[  229.887923] ------------[ cut here ]------------
[  229.888179] WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
[  229.888320] Hardware name: System Name
[  229.888464] list_add corruption. next->prev should be prev
(ca342698), but was c7c9e5b0. (next=c7e41db4).
[  229.888662] Modules linked in:
[  229.888866] Pid: 5039, comm: cp Tainted: G        W
2.6.29-rc2-00021-gd84d31c-dirty #221
[  229.889111] Call Trace:
[  229.889265]  [<c0123af1>] warn_slowpath+0x79/0x8f
[  229.889409]  [<c013f6f2>] ? print_lock_contention_bug+0x11/0xb2
[  229.889570]  [<c0505d86>] ? __debug_check_no_obj_freed+0x52/0x145
[  229.889714]  [<c013f21f>] ? trace_hardirqs_off+0xb/0xd
[  229.889871]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  229.890069]  [<c018b904>] ? __slab_free+0xad/0x287
[  229.890206]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  229.890364]  [<c013f6f2>] ? print_lock_contention_bug+0x11/0xb2
[  229.890505]  [<c013ec6d>] ? put_lock_stats+0xd/0x21
[  229.890660]  [<c01a66d6>] ? __mark_inode_dirty+0xc3/0x13d
[  229.890802]  [<c050585b>] __list_add+0x27/0x5c
[  229.890954]  [<c01a673d>] __mark_inode_dirty+0x12a/0x13d
[  229.891166]  [<c038636b>] ? xfs_buf_item_format+0xa6/0x15e
[  229.891324]  [<c03b6e2c>] xfs_mark_inode_dirty_sync+0x20/0x22
[  229.891487]  [<c039b441>] xfs_inode_item_format+0x5a/0x2a7
[  229.891643]  [<c03a972f>] xfs_trans_fill_vecs+0x44/0x9e
[  229.891800]  [<c03aa7a6>] _xfs_trans_commit+0x14e/0x2b3
[  229.891942]  [<c03ae383>] xfs_create+0x313/0x3a2
[  229.892133]  [<c03b7430>] xfs_vn_mknod+0x120/0x1e5
[  229.892271]  [<c03b7518>] xfs_vn_create+0xf/0x11
[  229.892428]  [<c0196dd4>] vfs_create+0xb6/0x126
[  229.892565]  [<c01992cd>] do_filp_open+0x1f2/0x668
[  229.892717]  [<c013f6f2>] ? print_lock_contention_bug+0x11/0xb2
[  229.892882]  [<c07b0696>] ? _spin_unlock+0x2c/0x41
[  229.893117]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  229.893256]  [<c07b2617>] ? sub_preempt_count+0xc0/0xd1
[  229.893413]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  229.893550]  [<c018e052>] do_sys_open+0x47/0xbd
[  229.893705]  [<c0102fc4>] ? restore_nocheck_notrace+0x0/0xe
[  229.894906]  [<c018e114>] sys_open+0x23/0x2b
[  229.895093]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  229.895228] ---[ end trace 826801eb6ce5fdba ]---
[  230.085160] ------------[ cut here ]------------
[  230.085333] WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
[  230.085492] Hardware name: System Name
[  230.085619] list_add corruption. next->prev should be prev
(c0a47670), but was ca342698. (next=c7e41db4).
[  230.085848] Modules linked in:
[  230.086102] Pid: 5045, comm: mkdir Tainted: G        W
2.6.29-rc2-00021-gd84d31c-dirty #221
[  230.086295] Call Trace:
[  230.086450]  [<c0123af1>] warn_slowpath+0x79/0x8f
[  230.086594]  [<c0542d38>] ? extract_buf+0x8a/0xdb
[  230.086751]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  230.086897]  [<c018b402>] ? __slab_alloc+0xb6/0x50b
[  230.087089]  [<c018bb5a>] ? kmem_cache_alloc+0x7c/0xea
[  230.087236]  [<c07b2617>] ? sub_preempt_count+0xc0/0xd1
[  230.087395]  [<c019f495>] ? iget_locked+0x59/0x120
[  230.087531]  [<c050585b>] __list_add+0x27/0x5c
[  230.087683]  [<c019f4c7>] iget_locked+0x8b/0x120
[  230.087825]  [<c01c5145>] proc_get_inode+0x74/0x134
[  230.087986]  [<c01c91b8>] proc_lookup_de+0x79/0xaa
[  230.088366]  [<c01c948f>] proc_lookup+0x17/0x1c
[  230.088503]  [<c01c57ba>] proc_root_lookup+0x16/0x30
[  230.088666]  [<c019638c>] do_lookup+0xbc/0x159
[  230.088804]  [<c0198007>] __link_path_walk+0x6cd/0xa65
[  230.088962]  [<c07b2617>] ? sub_preempt_count+0xc0/0xd1
[  230.089157]  [<c01983dc>] path_walk+0x3d/0x76
[  230.089292]  [<c019858b>] do_path_lookup+0xee/0x14f
[  230.089447]  [<c0198f50>] path_lookup_open+0x48/0x7a
[  230.089586]  [<c0199181>] do_filp_open+0xa6/0x668
[  230.089740]  [<c04f8b60>] ? trace_hardirqs_on_thunk+0xc/0x10
[  230.089886]  [<c01a063c>] ? alloc_fd+0x26/0xce
[  230.090096]  [<c07b0696>] ? _spin_unlock+0x2c/0x41
[  230.090233]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  230.090387]  [<c07b2617>] ? sub_preempt_count+0xc0/0xd1
[  230.090526]  [<c01a06da>] ? alloc_fd+0xc4/0xce
[  230.090679]  [<c018e052>] do_sys_open+0x47/0xbd
[  230.090819]  [<c0102ecf>] ? sysenter_exit+0xf/0x16
[  230.090971]  [<c018e114>] sys_open+0x23/0x2b
[  230.091158]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  230.091294] ---[ end trace 826801eb6ce5fdbb ]---
[  230.180722] ------------[ cut here ]------------
[  230.180898] WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
[  230.181116] Hardware name: System Name
[  230.181243] list_add corruption. next->prev should be prev
(ca342698), but was c7c9e2e8. (next=c7e41db4).
[  230.181471] Modules linked in:
[  230.181673] Pid: 5045, comm: mkdir Tainted: G        W
2.6.29-rc2-00021-gd84d31c-dirty #221
[  230.181868] Call Trace:
[  230.182021]  [<c0123af1>] warn_slowpath+0x79/0x8f
[  230.182222]  [<c03b4284>] ? xfs_buf_read_flags+0x19/0x6e
[  230.182375]  [<c03826dc>] ? xfs_btree_check_sblock+0x57/0xc6
[  230.182533]  [<c0505d86>] ? __debug_check_no_obj_freed+0x52/0x145
[  230.182680]  [<c013f21f>] ? trace_hardirqs_off+0xb/0xd
[  230.182837]  [<c018a797>] ? check_bytes_and_report+0x26/0x94
[  230.182978]  [<c01a66d6>] ? __mark_inode_dirty+0xc3/0x13d
[  230.183169]  [<c050585b>] __list_add+0x27/0x5c
[  230.183301]  [<c01a673d>] __mark_inode_dirty+0x12a/0x13d
[  230.183461]  [<c038636b>] ? xfs_buf_item_format+0xa6/0x15e
[  230.183604]  [<c03b6e2c>] xfs_mark_inode_dirty_sync+0x20/0x22
[  230.183762]  [<c039b441>] xfs_inode_item_format+0x5a/0x2a7
[  230.183915]  [<c03a972f>] xfs_trans_fill_vecs+0x44/0x9e
[  230.184110]  [<c03aa7a6>] _xfs_trans_commit+0x14e/0x2b3
[  230.184254]  [<c0389d8e>] ? xfs_dir_init+0x4f/0x57
[  230.184407]  [<c03ab900>] ? xfs_trans_log_inode+0x19/0x34
[  230.184546]  [<c03aecc1>] xfs_mkdir+0x320/0x3a3
[  230.184699]  [<c03b7451>] xfs_vn_mknod+0x141/0x1e5
[  230.184836]  [<c03b7507>] xfs_vn_mkdir+0x12/0x14
[  230.184992]  [<c0196b75>] vfs_mkdir+0xaa/0x116
[  230.185181]  [<c0198b9e>] sys_mkdirat+0x88/0xc3
[  230.185321]  [<c0102fc4>] ? restore_nocheck_notrace+0x0/0xe
[  230.185479]  [<c0198bee>] sys_mkdir+0x15/0x17
[  230.185613]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  230.185764] ---[ end trace 826801eb6ce5fdbc ]---
[  295.279028] BUG: soft lockup - CPU#0 stuck for 61s! [umount:5047]
[  295.279028] Modules linked in:
[  295.279028] irq event stamp: 0
[  295.279028] hardirqs last  enabled at (0): [<(null)>] (null)
[  295.279028] hardirqs last disabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  295.279028] softirqs last  enabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  295.279028] softirqs last disabled at (0): [<(null)>] (null)
[  295.279028] 
[  295.279028] Pid: 5047, comm: umount Tainted: G        W
(2.6.29-rc2-00021-gd84d31c-dirty #221) System Name
[  295.279028] EIP: 0060:[<c01a6205>] EFLAGS: 00000246 CPU: 0
[  295.279028] EIP is at generic_sync_sb_inodes+0xb0/0x2e6
[  295.279028] EAX: cae46720 EBX: cae46728 ECX: ca342698 EDX: ca342698
[  295.279028] ESI: ca342698 EDI: ca3425b0 EBP: ca392ec8 ESP: ca392e94
[  295.279028]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  295.279028] CR0: 8005003b CR2: b7c86000 CR3: 0a390000 CR4: 000006d0
[  295.279028] DR0: c0122f08 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  295.279028] DR6: ffff0ff0 DR7: 00000400
[  295.279028] Call Trace:
[  295.279028]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  295.279028]  [<c01a6448>] sync_sb_inodes+0xd/0xf
[  295.279028]  [<c01a64b2>] sync_inodes_sb+0x68/0x6f
[  295.279028]  [<c01910a6>] __fsync_super+0x12/0x6b
[  295.279028]  [<c019110f>] fsync_super+0x10/0x1e
[  295.279028]  [<c01913b4>] generic_shutdown_super+0x21/0xc9
[  295.279028]  [<c019147e>] kill_block_super+0x22/0x36
[  295.279028]  [<c0191549>] deactivate_super+0x5c/0x6f
[  295.279028]  [<c01a1beb>] mntput_no_expire+0xa0/0xca
[  295.279028]  [<c01a2099>] sys_umount+0x25f/0x285
[  295.279028]  [<c01a20d1>] sys_oldumount+0x12/0x14
[  295.279028]  [<c0102ea1>] sysenter_do_call+0x12/0x31
[  360.778027] BUG: soft lockup - CPU#0 stuck for 61s! [umount:5047]
[  360.778027] Modules linked in:
[  360.778027] irq event stamp: 0
[  360.778027] hardirqs last  enabled at (0): [<(null)>] (null)
[  360.778027] hardirqs last disabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  360.778027] softirqs last  enabled at (0): [<c01221f9>]
copy_process+0x31f/0xfef
[  360.778027] softirqs last disabled at (0): [<(null)>] (null)
[  360.778027] 
[  360.778027] Pid: 5047, comm: umount Tainted: G        W
(2.6.29-rc2-00021-gd84d31c-dirty #221) System Name
[  360.778027] EIP: 0060:[<c01a6205>] EFLAGS: 00000246 CPU: 0
[  360.778027] EIP is at generic_sync_sb_inodes+0xb0/0x2e6
[  360.778027] EAX: cf77e850 EBX: cf77e858 ECX: ca342698 EDX: ca342698
[  360.778027] ESI: ca342698 EDI: ca3425b0 EBP: ca392ec8 ESP: ca392e94
[  360.778027]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  360.778027] CR0: 8005003b CR2: b7c86000 CR3: 0a390000 CR4: 000006d0
[  360.778027] DR0: c0122f08 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  360.778027] DR6: ffff0ff0 DR7: 00000400
[  360.778027] Call Trace:
[  360.778027]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  360.778027]  [<c01a6448>] sync_sb_inodes+0xd/0xf
[  360.778027]  [<c01a64b2>] sync_inodes_sb+0x68/0x6f
[  360.778027]  [<c01910a6>] __fsync_super+0x12/0x6b
[  360.778027]  [<c019110f>] fsync_super+0x10/0x1e
[  360.778027]  [<c01913b4>] generic_shutdown_super+0x21/0xc9
[  360.778027]  [<c019147e>] kill_block_super+0x22/0x36
[  360.778027]  [<c0191549>] deactivate_super+0x5c/0x6f
[  360.778027]  [<c01a1beb>] mntput_no_expire+0xa0/0xca
[  360.778027]  [<c01a2099>] sys_umount+0x25f/0x285
[  360.778027]  [<c01a20d1>] sys_oldumount+0x12/0x14
[  360.778027]  [<c0102ea1>] sysenter_do_call+0x12/0x31

Greeting, Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
