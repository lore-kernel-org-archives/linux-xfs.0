Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 11:52:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LIqmMu023473
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:52:49 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B088FFD25B
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:53:20 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id CVlC0hp06FlLoIDi for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:53:20 -0700 (PDT)
Date: Fri, 21 Mar 2008 13:45:56 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: BUG: xfs on linux lvm - lvconvert random hungs when doing i/o
Message-ID: <20080321174556.GA5433@josefsipek.net>
References: <200803211520.16398.stf_xl@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803211520.16398.stf_xl@wp.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: xfs@oss.sgi.com

On Fri, Mar 21, 2008 at 03:20:16PM +0100, Stanislaw Gruszka wrote:

Interesting, I've noticed similar hang (based on my un-expert inspection of
your backtraces) which went away as suddenly as it appeared. I wasn't making
snapshots or any other LVM operation at the time. It just happened - logs
didn't contain anything.

It's an LVM with 2 disks => 1 LV with XFS
It's a bit dated version of XFS (2.6.24-rc7 vanilla).

...
> Here is sysrq show-blocked-task output of such situation:

I did the same...

SysRq : Show Blocked State
  task                PC stack   pid father
postgres      D 0003469a     0  3435   3432
       df072d90 00200096 3f8d021a 0003469a f76c8e20 00000000 0002c7fb 00000000 
       3f8fca15 0003469a dfec20b4 dfec2f68 dfc308ec df072dd8 c032274f 00000001 
       dfec20b4 00000001 00200246 dfec20b4 dfec20b4 00200282 df072dc4 00000001 
Call Trace:
 [<c032274f>] schedule_timeout+0x69/0xa2
 [<f92c3a8b>] xlog_state_sync+0xf0/0x1ef [xfs]
 [<f92c3be2>] _xfs_log_force+0x58/0x5f [xfs]
 [<f92cef4f>] _xfs_trans_commit+0x2a0/0x371 [xfs]
 [<f92d5ea5>] xfs_fsync+0x13a/0x1d0 [xfs]
 [<f92de9fc>] xfs_file_fsync+0x6f/0x79 [xfs]
 [<c0187858>] do_fsync+0x5c/0x93
 [<c01878af>] __do_fsync+0x20/0x2f
 [<c01878dd>] sys_fsync+0xd/0xf
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
postgres      D 0003469a     0  3437   3432
       df0d4ce0 00200096 ee0ef4db 0003469a f7a9bd9c 00000000 00671954 00000000 
       ee760e2f 0003469a fffeffff f7a9bd98 f76ad0e0 df0d4d08 c0323b86 df0d4d10 
       f7a9bd9c f7a9bdb8 f76ad0e0 e94642a8 f7a9bd98 00000000 00000000 df0d4d24 
Call Trace:
 [<c0323b86>] rwsem_down_failed_common+0x66/0x15f
 [<c0323cc1>] rwsem_down_read_failed+0x1d/0x28
 [<c0323d13>] call_rwsem_down_read_failed+0x7/0xc
 [<f92b6903>] xfs_ilock+0x2f/0x87 [xfs]
 [<f92d38a3>] xfs_access+0x16/0x39 [xfs]
 [<f92e0766>] xfs_vn_permission+0x13/0x17 [xfs]
 [<c0170a68>] permission+0x7b/0xe3
 [<c0170bfc>] vfs_permission+0xf/0x11
 [<c0172217>] __link_path_walk+0x71/0xce8
 [<c0172ed2>] link_path_walk+0x44/0xbf
 [<c0172f65>] path_walk+0x18/0x1a
 [<c0173152>] do_path_lookup+0x78/0x1b0
 [<c0173c15>] __path_lookup_intent_open+0x44/0x81
 [<c0173cca>] path_lookup_open+0x21/0x27
 [<c0173da9>] open_namei+0x5b/0x646
 [<c0168a2b>] do_filp_open+0x26/0x43
 [<c0168a8b>] do_sys_open+0x43/0xcc
 [<c0168b4c>] sys_open+0x1c/0x1e
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
postgres      D dfed43d0     0  3438   3432
       df0debc0 00200092 00000000 dfed43d0 c032e760 dfed43d0 df0debb0 f92dd5ea 
       00200046 dfec2f78 df0dec20 dfc308ec dfec2f68 df0dec08 c032274f 00000001 
       dfec2f68 00000001 00200246 dfec2f68 dfec2f68 00200282 df0debf4 00000001 
Call Trace:
 [<c032274f>] schedule_timeout+0x69/0xa2
 [<f92c372e>] xlog_state_sync_all+0xcd/0x1aa [xfs]
 [<f92c3bca>] _xfs_log_force+0x40/0x5f [xfs]
 [<f92b71a9>] xfs_iget_core+0x404/0x5c4 [xfs]
 [<f92b7418>] xfs_iget+0xaf/0x117 [xfs]
 [<f92cffa8>] xfs_trans_iget+0xe1/0x149 [xfs]
 [<f92bb199>] xfs_ialloc+0xb2/0x5ad [xfs]
 [<f92d0a99>] xfs_dir_ialloc+0x6c/0x2a3 [xfs]
 [<f92d6712>] xfs_create+0x2ba/0x467 [xfs]
 [<f92e0fe1>] xfs_vn_mknod+0x163/0x29f [xfs]
 [<f92e1146>] xfs_vn_create+0x12/0x14 [xfs]
 [<c0171700>] vfs_create+0x96/0xe9
 [<c0174283>] open_namei+0x535/0x646
 [<c0168a2b>] do_filp_open+0x26/0x43
 [<c0168a8b>] do_sys_open+0x43/0xcc
 [<c0168b4c>] sys_open+0x1c/0x1e
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
bash          D 00000000     0  4251   4155
       e3deade8 00000082 00000000 00000000 e8d9d76c 00000000 00000000 00000000 
       7a4ec347 0003469a fffeffff e8d9d768 e3d7b220 e3deae10 c0323b86 e3deae18 
       e8d9d76c e8d9d788 e3deaf20 cc9fb000 e8d9d768 00000000 00000000 e3deae2c 
Call Trace:
 [<c0323b86>] rwsem_down_failed_common+0x66/0x15f
 [<c0323cc1>] rwsem_down_read_failed+0x1d/0x28
 [<c0323d13>] call_rwsem_down_read_failed+0x7/0xc
 [<f92b6903>] xfs_ilock+0x2f/0x87 [xfs]
 [<f92d38a3>] xfs_access+0x16/0x39 [xfs]
 [<f92e0766>] xfs_vn_permission+0x13/0x17 [xfs]
 [<c0170a68>] permission+0x7b/0xe3
 [<c0170bfc>] vfs_permission+0xf/0x11
 [<c0171de3>] may_open+0xa5/0x240
 [<c0173dbb>] open_namei+0x6d/0x646
 [<c0168a2b>] do_filp_open+0x26/0x43
 [<c0168a8b>] do_sys_open+0x43/0xcc
 [<c0168b4c>] sys_open+0x1c/0x1e
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
bash          D dfed49a0     0 15791   4155
       e792c9c4 00000096 00000001 dfed49a0 c032e760 00000046 dfed49a0 dfed49a0 
       00000282 e792c9c4 dfed4998 00000282 dfed49a0 e792c9f0 c0323ede dfbca6f0 
       00000001 dfbca6f0 c0116f2f dfed49bc dfed49bc dfed4998 dfef0b88 c8901aa8 
Call Trace:
 [<c0323ede>] __down+0x86/0xed
 [<c0323cd6>] __down_failed+0xa/0x10
 [<f92dc724>] xfs_buf_lock+0x46/0x49 [xfs]
 [<f92c9335>] xfs_getsb+0x16/0x33 [xfs]
 [<f92cf77a>] xfs_trans_getsb+0x36/0x74 [xfs]
 [<f92ce856>] xfs_trans_apply_sb_deltas+0x16/0x46f [xfs]
 [<f92ced3c>] _xfs_trans_commit+0x8d/0x371 [xfs]
 [<f92be719>] xfs_iomap_write_allocate+0x2ce/0x491 [xfs]
 [<f92bd870>] xfs_iomap+0x439/0x484 [xfs]
 [<f92e12ab>] xfs_bmap+0x2c/0x32 [xfs]
 [<f92da6b2>] xfs_map_blocks+0x38/0x78 [xfs]
 [<f92dbc5b>] xfs_page_state_convert+0x311/0x79b [xfs]
 [<f92dc1e4>] xfs_vm_writepage+0x54/0xe0 [xfs]
 [<c0150bbd>] __writepage+0xb/0x27
 [<c015113f>] write_cache_pages+0x202/0x2e5
 [<c0151245>] generic_writepages+0x23/0x2d
 [<f92da892>] xfs_vm_writepages+0x3d/0x45 [xfs]
 [<c0151275>] do_writepages+0x26/0x39
 [<c014bbbf>] __filemap_fdatawrite_range+0x66/0x72
 [<c014bdc7>] filemap_fdatawrite+0x26/0x28
 [<f92dec5e>] xfs_flush_pages+0x4d/0x74 [xfs]
 [<f92d8f2f>] xfs_release+0x12a/0x218 [xfs]
 [<f92dea14>] xfs_file_release+0xe/0x12 [xfs]
 [<c016ae99>] __fput+0xb6/0x18f
 [<c016b143>] fput+0x18/0x1a
 [<c01686a0>] filp_close+0x41/0x67
 [<c01698ac>] sys_close+0x65/0xa7
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
pdflush       D 0003469a     0 27649      2
       c2aa4ea4 00000092 3f8e2cc7 0003469a 00000282 c2aa4e94 000089ca 00000000 
       3f8eb691 0003469a dfed4998 dfed49cc c2aa4eac c2aa4ecc f92dd57f 00000000 
       ceb64ea0 c0116f2f dfed49e8 dfed49e8 dfed4998 00000020 00000000 c2aa4ed8 
Call Trace:
 [<f92dd57f>] xfs_buf_wait_unpin+0x7a/0xa8 [xfs]
 [<f92dd5f6>] xfs_buf_iorequest+0x49/0x70 [xfs]
 [<f92e12fe>] xfs_bdstrat_cb+0x4d/0x52 [xfs]
 [<f92d9b86>] xfs_bwrite+0x54/0xb7 [xfs]
 [<f92d2856>] xfs_syncsub+0x130/0x2df [xfs]
 [<f92d2a42>] xfs_sync+0x3d/0x4f [xfs]
 [<f92e2802>] xfs_fs_write_super+0x1c/0x23 [xfs]
 [<c016bf4e>] sync_supers+0x84/0xb2
 [<c0151a51>] wb_kupdate+0x27/0xd3
 [<c0151fcb>] pdflush+0xc0/0x175
 [<c012c242>] kthread+0x38/0x5a
 [<c0104be7>] kernel_thread_helper+0x7/0x10
 =======================
amarokapp     D 00000000     0 27973  27967
       df915bc0 00000092 00000000 00000000 f77854f8 00000000 00000000 00000000 
       f2938f82 0003469a df915c20 f7f6392c f7f5c258 df915c08 c032274f 00000001 
       f7f5c258 00000001 00000246 f7f5c258 f7f5c258 00000282 df915bf4 00000001 
Call Trace:
 [<c032274f>] schedule_timeout+0x69/0xa2
 [<f92c372e>] xlog_state_sync_all+0xcd/0x1aa [xfs]
 [<f92c3bca>] _xfs_log_force+0x40/0x5f [xfs]
 [<f92b71a9>] xfs_iget_core+0x404/0x5c4 [xfs]
 [<f92b7418>] xfs_iget+0xaf/0x117 [xfs]
 [<f92cffa8>] xfs_trans_iget+0xe1/0x149 [xfs]
 [<f92bb199>] xfs_ialloc+0xb2/0x5ad [xfs]
 [<f92d0a99>] xfs_dir_ialloc+0x6c/0x2a3 [xfs]
 [<f92d6712>] xfs_create+0x2ba/0x467 [xfs]
 [<f92e0fe1>] xfs_vn_mknod+0x163/0x29f [xfs]
 [<f92e1146>] xfs_vn_create+0x12/0x14 [xfs]
 [<c0171700>] vfs_create+0x96/0xe9
 [<c0174283>] open_namei+0x535/0x646
 [<c0168a2b>] do_filp_open+0x26/0x43
 [<c0168a8b>] do_sys_open+0x43/0xcc
 [<c0168b4c>] sys_open+0x1c/0x1e
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================
find          D 0003469a     0 28000  26670
       c899bb88 00000086 9ad0d912 0003469a 00000001 00000046 0009a6ff 00000000 
       9ada8011 0003469a dffe1b80 00000296 dffe1b88 c899bbb4 c0323ede f3d410a0 
       00000001 f3d410a0 c0116f2f dffe1ba4 dffe1ba4 dffe1ac0 dffe1ac0 f3a6a880 
Call Trace:
 [<c0323ede>] __down+0x86/0xed
 [<c0323cd6>] __down_failed+0xa/0x10
 [<f92dc6d4>] xfs_buf_iowait+0x4e/0x58 [xfs]
 [<f92dd805>] xfs_buf_iostart+0x7a/0x8b [xfs]
 [<f92de1a9>] xfs_buf_read_flags+0x51/0x75 [xfs]
 [<f92cf9b5>] xfs_trans_read_buf+0x3f/0x333 [xfs]
 [<f92b8f77>] xfs_itobp+0x70/0x1d1 [xfs]
 [<f92bc650>] xfs_iread+0x79/0x1d9 [xfs]
 [<f92b6ef1>] xfs_iget_core+0x14c/0x5c4 [xfs]
 [<f92b7418>] xfs_iget+0xaf/0x117 [xfs]
 [<f92d099e>] xfs_dir_lookup_int+0x81/0xec [xfs]
 [<f92d4adc>] xfs_lookup+0x56/0x7a [xfs]
 [<f92e0b75>] xfs_vn_lookup+0x2f/0x61 [xfs]
 [<c0170f93>] do_lookup+0x12a/0x16a
 [<c01728f3>] __link_path_walk+0x74d/0xce8
 [<c0172ed2>] link_path_walk+0x44/0xbf
 [<c0172f65>] path_walk+0x18/0x1a
 [<c0173152>] do_path_lookup+0x78/0x1b0
 [<c0173a73>] __user_walk_fd+0x32/0x4a
 [<c016d2d8>] vfs_lstat_fd+0x18/0x3e
 [<c016d369>] vfs_lstat+0x11/0x13
 [<c016d37f>] sys_lstat64+0x14/0x28
 [<c0103f72>] sysenter_past_esp+0x5f/0xa5
 =======================

Josef 'Jeff' Sipek.

-- 
It used to be said [...] that AIX looks like one space alien discovered
Unix, and described it to another different space alien who then implemented
AIX. But their universal translators were broken and they'd had to gesture a
lot.
		- Paul Tomblin 
