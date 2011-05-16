Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4GIieiq144153 for <xfs@oss.sgi.com>; Mon, 16 May 2011 13:44:40 -0500
Received: from sycorax.lbl.gov (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F26A41E2BDAF
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 11:44:38 -0700 (PDT)
Received: from sycorax.lbl.gov (sycorax.lbl.gov [128.3.11.121]) by
	cuda.sgi.com with ESMTP id F6Z3Fb3gvTDLuEjC for
	<xfs@oss.sgi.com>; Mon, 16 May 2011 11:44:38 -0700 (PDT)
From: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: system hangs 2.6.39-rc7 xfs related
Date: Mon, 16 May 2011 11:44:37 -0700
Message-ID: <87ei3y7aei.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

my system just sort of locked up and everything that's trying to write
to disk is stuck. dmesg gives me this:

xulrunner-stub  D 0000000000000000     0 11600      1 0x00000000
 ffff88012cfbb988 0000000000000086 ffff880100000000 ffff88012cfbbfd8
 0000000000004000 0000000000011600 ffffffff814cd020 ffff8801aa9efa10
 ffff88012cfbb928 ffffffff81190ba3 0000000000000000 ffff880027b07c58
Call Trace:
 [<ffffffff81190ba3>] ? xfs_iext_bno_to_ext+0xa3/0x123
 [<ffffffff81193c22>] ? xfs_iomap_write_delay+0x164/0x1ff
 [<ffffffff8117ab1b>] ? xfs_bmbt_get_all+0x13/0x15
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff81193d64>] xfs_iomap_write_allocate+0xa7/0x29d
 [<ffffffff8102dd83>] ? sub_preempt_count+0x8f/0xa3
 [<ffffffff811a75c0>] xfs_map_blocks+0x15d/0x16e
 [<ffffffff811a7fee>] xfs_vm_writepage+0x208/0x3da
 [<ffffffff81075f22>] __writepage+0xf/0x28
 [<ffffffff8107631a>] write_cache_pages+0x1e9/0x2fd
 [<ffffffff81075f13>] ? bdi_set_max_ratio+0x6a/0x6a
 [<ffffffff8118e6ed>] ? xfs_iunlock+0x33/0x7f
 [<ffffffff81076469>] generic_writepages+0x3b/0x51
 [<ffffffff811a7443>] xfs_vm_writepages+0x45/0x50
 [<ffffffff81076f58>] do_writepages+0x1c/0x25
 [<ffffffff810700d3>] __filemap_fdatawrite_range+0x4b/0x4d
 [<ffffffff81070165>] filemap_write_and_wait_range+0x28/0x51
 [<ffffffff810c4e92>] vfs_fsync_range+0x36/0x73
 [<ffffffff810c4f27>] vfs_fsync+0x17/0x19
 [<ffffffff810c51ad>] sys_fdatasync+0x27/0x3a
 [<ffffffff8136753b>] system_call_fastpath+0x16/0x1b
INFO: task flush-8:48:11768 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:48      D 0000000000000002     0 11768      2 0x00000000
 ffff8801b0e99720 0000000000000046 ffff880100000000 ffff8801b0e99fd8
 0000000000004000 0000000000011600 ffff8801b8c7d160 ffff8801af883ff0
 ffff8801b0e996c0 ffffffff81190ba3 0000000000000000 ffff88017215e058
Call Trace:
 [<ffffffff81190ba3>] ? xfs_iext_bno_to_ext+0xa3/0x123
 [<ffffffff8117ab1b>] ? xfs_bmbt_get_all+0x13/0x15
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff81193d64>] xfs_iomap_write_allocate+0xa7/0x29d
 [<ffffffff811c4312>] ? submit_bio+0xba/0xc5
 [<ffffffff811a75c0>] xfs_map_blocks+0x15d/0x16e
 [<ffffffff811a7fee>] xfs_vm_writepage+0x208/0x3da
 [<ffffffff81075f22>] __writepage+0xf/0x28
 [<ffffffff8107631a>] write_cache_pages+0x1e9/0x2fd
 [<ffffffff81075f13>] ? bdi_set_max_ratio+0x6a/0x6a
 [<ffffffff81366857>] ? _raw_spin_unlock+0x10/0x2b
 [<ffffffff81076469>] generic_writepages+0x3b/0x51
 [<ffffffff811a7443>] xfs_vm_writepages+0x45/0x50
 [<ffffffff81076f58>] do_writepages+0x1c/0x25
 [<ffffffff810c17f2>] writeback_single_inode+0xc6/0x1e5
 [<ffffffff810c1a59>] writeback_sb_inodes+0xbe/0x143
 [<ffffffff810c1fc2>] writeback_inodes_wb+0x114/0x126
 [<ffffffff810c21a2>] wb_writeback+0x1ce/0x27f
 [<ffffffff810c235a>] wb_do_writeback+0x107/0x187
 [<ffffffff8103cec5>] ? usleep_range+0x3d/0x3d
 [<ffffffff810c2442>] bdi_writeback_thread+0x68/0x12e
 [<ffffffff810c23da>] ? wb_do_writeback+0x187/0x187
 [<ffffffff810489d4>] kthread+0x7f/0x87
 [<ffffffff81368294>] kernel_thread_helper+0x4/0x10
 [<ffffffff81048955>] ? kthread_worker_fn+0x111/0x111
 [<ffffffff81368290>] ? gs_change+0xb/0xb
INFO: task kworker/6:4:24185 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/6:4     D 0000000000000006     0 24185      2 0x00000000
 ffff880193655ca0 0000000000000046 0000000000000000 ffff880193655fd8
 0000000000004000 0000000000011600 ffff8801b8ce2e80 ffff880139299d10
 0000000000000001 0000000000000001 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811b026e>] ? xfs_sync_inode_attr+0xbb/0xbb
 [<ffffffff811b026e>] ? xfs_sync_inode_attr+0xbb/0xbb
 [<ffffffff8118c5b9>] xfs_fs_log_dummy+0x3e/0x7a
 [<ffffffff811b02ac>] xfs_sync_worker+0x3e/0x64
 [<ffffffff8104500b>] process_one_work+0x1be/0x2ed
 [<ffffffff8104559b>] worker_thread+0x15b/0x21c
 [<ffffffff81045440>] ? manage_workers.isra.29+0x16c/0x16c
 [<ffffffff810489d4>] kthread+0x7f/0x87
 [<ffffffff81368294>] kernel_thread_helper+0x4/0x10
 [<ffffffff81048955>] ? kthread_worker_fn+0x111/0x111
 [<ffffffff81368290>] ? gs_change+0xb/0xb
INFO: task chromium:7532 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
chromium        D 0000000000000002     0  7532   6648 0x00000000
 ffff8801072b7d98 0000000000000086 ffff880100000000 ffff8801072b7fd8
 0000000000004000 0000000000011600 ffff8801b8c7d160 ffff8801b1e5e2d0
 ffffffff00000000 0000000000000001 ffff8801072b7ce8 ffffffff8102dcc3
Call Trace:
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81077aa7>] ? lru_deactivate_fn+0x1b4/0x1b4
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff811aae63>] xfs_file_fsync+0xdf/0x1b4
 [<ffffffff810c4eaf>] vfs_fsync_range+0x53/0x73
 [<ffffffff810c4f27>] vfs_fsync+0x17/0x19
 [<ffffffff810c51ad>] sys_fdatasync+0x27/0x3a
 [<ffffffff8136753b>] system_call_fastpath+0x16/0x1b
INFO: task as:23872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
as              D 0000000000000000     0 23872  23870 0x00000000
 ffff88010ce13cb8 0000000000000086 ffff880100000000 ffff88010ce13fd8
 0000000000004000 0000000000011600 ffffffff814cd020 ffff88013929d160
 ffff88017b8f8400 ffff88010ce13d50 ffff88017b8f8400 ffff88010ce13dac
Call Trace:
 [<ffffffff811d6d58>] ? radix_tree_gang_lookup_slot+0x66/0x87
 [<ffffffff8106f015>] ? file_remove_suid+0x22/0x5f
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a3a7b>] xfs_free_eofblocks+0x14e/0x1dd
 [<ffffffff811a4b8a>] xfs_release+0x1a3/0x1da
 [<ffffffff811aaf48>] xfs_file_release+0x10/0x14
 [<ffffffff810a6342>] fput+0xf8/0x1a5
 [<ffffffff810a35f4>] filp_close+0x69/0x75
 [<ffffffff810a36a8>] sys_close+0xa8/0xea
 [<ffffffff8136753b>] system_call_fastpath+0x16/0x1b
INFO: task as:23917 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
as              D 0000000000000005     0 23917  23915 0x00000000
 ffff88012cc69cb8 0000000000000082 ffff880100000000 ffff88012cc69fd8
 0000000000004000 0000000000011600 ffff8801b8ce1740 ffff8801a41d62d0
 ffff880179e18800 ffff88012cc69d50 ffff880179e18800 ffff88012cc69dac
Call Trace:
 [<ffffffff811d6d58>] ? radix_tree_gang_lookup_slot+0x66/0x87
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a3a7b>] xfs_free_eofblocks+0x14e/0x1dd
 [<ffffffff811a4b8a>] xfs_release+0x1a3/0x1da
 [<ffffffff811aaf48>] xfs_file_release+0x10/0x14
 [<ffffffff810a6342>] fput+0xf8/0x1a5
 [<ffffffff810a35f4>] filp_close+0x69/0x75
 [<ffffffff810a36a8>] sys_close+0xa8/0xea
 [<ffffffff8136753b>] system_call_fastpath+0x16/0x1b
INFO: task as:23921 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
as              D 0000000000000000     0 23921  23919 0x00000000
 ffff88010779dcb8 0000000000000082 ffff88010779dc08 ffff88010779dfd8
 0000000000004000 0000000000011600 ffffffff814cd020 ffff8801b840a2e0
 ffff88016ee62000 ffff88010779dd50 ffff88016ee62000 ffff88010779ddac
Call Trace:
 [<ffffffff811d6d58>] ? radix_tree_gang_lookup_slot+0x66/0x87
 [<ffffffff8106f015>] ? file_remove_suid+0x22/0x5f
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a3a7b>] xfs_free_eofblocks+0x14e/0x1dd
 [<ffffffff811a4b8a>] xfs_release+0x1a3/0x1da
 [<ffffffff811aaf48>] xfs_file_release+0x10/0x14
 [<ffffffff810a6342>] fput+0xf8/0x1a5
 [<ffffffff810a35f4>] filp_close+0x69/0x75
 [<ffffffff810a36a8>] sys_close+0xa8/0xea
 [<ffffffff8136753b>] system_call_fastpath+0x16/0x1b
INFO: task winebuild:23950 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
winebuild       D 0000000121aad697     0 23950  23949 0x00020000
 ffff88012cc39c48 0000000000000082 ffff880000000001 ffff88012cc39fd8
 0000000000004000 0000000000011600 ffff8801b1e59740 ffff88006e580000
 ffff88012cc39bd8 ffffffff810b6e40 ffffffff814545ef 000000000000000d
Call Trace:
 [<ffffffff810b6e40>] ? __d_lookup+0x11c/0x12e
 [<ffffffff810b6e7d>] ? d_lookup+0x2b/0x41
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a574d>] xfs_remove+0xdf/0x2f8
 [<ffffffff8102dd83>] ? sub_preempt_count+0x8f/0xa3
 [<ffffffff81365d7d>] ? __mutex_lock_slowpath+0x269/0x291
 [<ffffffff811ada50>] xfs_vn_unlink+0x3c/0x76
 [<ffffffff810afbe0>] vfs_unlink+0x5b/0xc2
 [<ffffffff810afd10>] do_unlinkat+0xc9/0x157
 [<ffffffff81024497>] ? sys32_rt_sigaction+0xca/0x14c
 [<ffffffff810b0f77>] sys_unlink+0x11/0x13
 [<ffffffff81368425>] sysenter_dispatch+0x7/0x2b
INFO: task winebuild:23953 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
winebuild       D 0000000000000002     0 23953  23948 0x00020000
 ffff88012fd4dcb8 0000000000000082 ffff880100000000 ffff88012fd4dfd8
 0000000000004000 0000000000011600 ffff8801b8c7d160 ffff8801aa9edd00
 ffff88016ee71400 ffff88012fd4dd50 ffff88016ee71400 ffff88012fd4ddac
Call Trace:
 [<ffffffff81173975>] ? xfs_bmap_search_extents+0x57/0xba
 [<ffffffff8106f941>] ? generic_file_buffered_write+0x1e8/0x24d
 [<ffffffff8106f015>] ? file_remove_suid+0x22/0x5f
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196645>] xlog_grant_log_space+0xf3/0x2dc
 [<ffffffff811dc662>] ? random32+0x3b/0x5d
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a3a7b>] xfs_free_eofblocks+0x14e/0x1dd
 [<ffffffff811a4b8a>] xfs_release+0x1a3/0x1da
 [<ffffffff811aaf48>] xfs_file_release+0x10/0x14
 [<ffffffff810a6342>] fput+0xf8/0x1a5
 [<ffffffff810a35f4>] filp_close+0x69/0x75
 [<ffffffff810a36a8>] sys_close+0xa8/0xea
 [<ffffffff81368425>] sysenter_dispatch+0x7/0x2b
INFO: task winebuild:23957 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
winebuild       D 0000000000000007     0 23957  23951 0x00020000
 ffff8801b4adbc98 0000000000000086 ffff880100000000 ffff8801b4adbfd8
 0000000000004000 0000000000011600 ffff8801b8ce45c0 ffff88006e584b90
 ffff88018ff76038 ffff88018ff76038 ffff8801b4adbbd8 ffffffff81366884
Call Trace:
 [<ffffffff81366884>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
 [<ffffffff8104cc45>] ? up+0x34/0x3b
 [<ffffffff8109c9fd>] ? kmem_cache_free+0x15/0x93
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff8102dcc3>] ? get_parent_ip+0xf/0x40
 [<ffffffff81196747>] xlog_grant_log_space+0x1f5/0x2dc
 [<ffffffff8102dd83>] ? sub_preempt_count+0x8f/0xa3
 [<ffffffff8102f900>] ? try_to_wake_up+0x283/0x283
 [<ffffffff811983e8>] xfs_log_reserve+0xb7/0xbf
 [<ffffffff811a148a>] xfs_trans_reserve+0xca/0x196
 [<ffffffff811a4d26>] xfs_inactive+0x165/0x395
 [<ffffffff811aeb79>] xfs_fs_evict_inode+0x8a/0x8e
 [<ffffffff810b8aeb>] evict+0x82/0x126
 [<ffffffff810b8d18>] iput+0x14f/0x158
 [<ffffffff810afd48>] do_unlinkat+0x101/0x157
 [<ffffffff81024497>] ? sys32_rt_sigaction+0xca/0x14c
 [<ffffffff810b0f77>] sys_unlink+0x11/0x13
 [<ffffffff81368425>] sysenter_dispatch+0x7/0x2b

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
