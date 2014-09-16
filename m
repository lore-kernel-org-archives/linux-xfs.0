Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB7137F53
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2014 22:52:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A1608F8039
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2014 20:52:36 -0700 (PDT)
Received: from atrey.karlin.mff.cuni.cz (atrey.karlin.mff.cuni.cz
	[195.113.26.193]) by cuda.sgi.com with ESMTP id
	XOXT1BTqWUF29aKr for <xfs@oss.sgi.com>;
	Mon, 15 Sep 2014 20:52:33 -0700 (PDT)
Date: Tue, 16 Sep 2014 05:52:31 +0200
From: Petr Janecek <janecek@ucw.cz>
Subject: possible irq lock inversion dependency detected on 3.16.2
Message-ID: <20140916035230.GA7100@atrey.karlin.mff.cuni.cz>
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

Hello,
      this happened during nightly ext4 -> xfs rsync, both of them on lvm
on md raid1.  I would happily provide more info if needed.  Probably
not easy to reproduce, same job has been running daily since January.

Regards,

Petr


[ 5935.518518] [ INFO: possible irq lock inversion dependency detected ]
[ 5935.524971] 3.16.2 #59 Not tainted
[ 5935.528381] ---------------------------------------------------------
[ 5935.534826] kswapd0/66 just changed the state of lock:
[ 5935.539999]  (&xfs_dir_ilock_class){++++-+}, at: [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5935.548866] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[ 5935.555862]  (&mm->mmap_sem){++++++}
[ 5935.555862] 
[ 5935.555862] and interrupts could create inverse lock ordering between them.
[ 5935.555862] 
[ 5935.565508] 
[ 5935.565508] other info that might help us debug this:
[ 5935.572057]  Possible interrupt unsafe locking scenario:
[ 5935.572057] 
[ 5935.578880]        CPU0                    CPU1
[ 5935.583438]        ----                    ----
[ 5935.587994]   lock(&mm->mmap_sem);
[ 5935.591459]                                local_irq_disable();
[ 5935.597399]                                lock(&xfs_dir_ilock_class);
[ 5935.603991]                                lock(&mm->mmap_sem);
[ 5935.609976]   <Interrupt>
[ 5935.612619]     lock(&xfs_dir_ilock_class);
[ 5935.616864] 
[ 5935.616864]  *** DEADLOCK ***
[ 5935.616864] 
[ 5935.622834] 3 locks held by kswapd0/66:
[ 5935.626695]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810dcdcf>] shrink_slab+0x39/0x137
[ 5935.635209]  #1:  (&type->s_umount_key#30){.+.+.+}, at: [<ffffffff8111ebec>] grab_super_passive+0x4c/0x76
[ 5935.644963]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffffa0cde03e>] xfs_reclaim_inodes_ag+0x6a/0x279 [xfs]
[ 5935.655929] 
[ 5935.655929] the shortest dependencies between 2nd lock and 1st lock:
[ 5935.663824]  -> (&mm->mmap_sem){++++++} ops: 488821045 {
[ 5935.669303]     HARDIRQ-ON-W at:
[ 5935.672577]                       [<ffffffff81072ed7>] __lock_acquire+0x345/0xe77
[ 5935.680130]                       [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5935.687415]                       [<ffffffff8139c91e>] down_write+0x3f/0x5b
[ 5935.694432]                       [<ffffffff81121d69>] do_execve_common.isra.27+0x25a/0x5ca
[ 5935.702850]                       [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5935.709781]                       [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5935.717333]                       [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5935.724436]                       [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5935.731722]     HARDIRQ-ON-R at:
[ 5935.735056]                       [<ffffffff81072eae>] __lock_acquire+0x31c/0xe77
[ 5935.742634]                       [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5935.749920]                       [<ffffffff810ef2c9>] might_fault+0x82/0xa5
[ 5935.757023]                       [<ffffffff811d1802>] __clear_user+0x12/0x56
[ 5935.764213]                       [<ffffffff811d186f>] clear_user+0x29/0x2b
[ 5935.771228]                       [<ffffffff81396a9d>] padzero+0x1e/0x2b
[ 5935.777984]                       [<ffffffff8115be33>] load_elf_binary+0x920/0xd15
[ 5935.785693]                       [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5935.793862]                       [<ffffffff8115a2c6>] load_script+0x1aa/0x1bc
[ 5935.801145]                       [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5935.809264]                       [<ffffffff81121f4b>] do_execve_common.isra.27+0x43c/0x5ca
[ 5935.817682]                       [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5935.824654]                       [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5935.832200]                       [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5935.839327]                       [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5935.846646]     SOFTIRQ-ON-W at:
[ 5935.849922]                       [<ffffffff81072ef9>] __lock_acquire+0x367/0xe77
[ 5935.857509]                       [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5935.864803]                       [<ffffffff8139c91e>] down_write+0x3f/0x5b
[ 5935.871820]                       [<ffffffff81121d69>] do_execve_common.isra.27+0x25a/0x5ca
[ 5935.880230]                       [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5935.887219]                       [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5935.900221]                       [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5935.907359]                       [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5935.914730]     SOFTIRQ-ON-R at:
[ 5935.918005]                       [<ffffffff81072ef9>] __lock_acquire+0x367/0xe77
[ 5935.925593]                       [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5935.932877]                       [<ffffffff810ef2c9>] might_fault+0x82/0xa5
[ 5935.939970]                       [<ffffffff811d1802>] __clear_user+0x12/0x56
[ 5935.947160]                       [<ffffffff811d186f>] clear_user+0x29/0x2b
[ 5935.954176]                       [<ffffffff81396a9d>] padzero+0x1e/0x2b
[ 5935.960932]                       [<ffffffff8115be33>] load_elf_binary+0x920/0xd15
[ 5935.968564]                       [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5935.976628]                       [<ffffffff8115a2c6>] load_script+0x1aa/0x1bc
[ 5935.983914]                       [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5935.991995]                       [<ffffffff81121f4b>] do_execve_common.isra.27+0x43c/0x5ca
[ 5936.000413]                       [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5936.007344]                       [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5936.014913]                       [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5936.022052]                       [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5936.029337]     RECLAIM_FS-ON-W at:
[ 5936.032868]                          [<ffffffff810741de>] mark_held_locks+0x54/0x76
[ 5936.040583]                          [<ffffffff810748ce>] lockdep_trace_alloc+0xc3/0xcd
[ 5936.048643]                          [<ffffffff810d5f94>] __alloc_pages_nodemask+0x8d/0x878
[ 5936.057123]                          [<ffffffff81108080>] alloc_pages_current+0xc9/0xe6
[ 5936.065177]                          [<ffffffff810f1565>] __pmd_alloc+0x1d/0xec
[ 5936.072541]                          [<ffffffff810f85ec>] move_page_tables+0x1b0/0x505
[ 5936.080528]                          [<ffffffff81120844>] shift_arg_pages+0xa3/0x14d
[ 5936.088358]                          [<ffffffff81120aae>] setup_arg_pages+0x1c0/0x1f0
[ 5936.096240]                          [<ffffffff8115b8aa>] load_elf_binary+0x397/0xd15
[ 5936.104123]                          [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5936.112437]                          [<ffffffff8115a2c6>] load_script+0x1aa/0x1bc
[ 5936.119966]                          [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5936.128290]                          [<ffffffff81121f4b>] do_execve_common.isra.27+0x43c/0x5ca
[ 5936.136951]                          [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5936.144124]                          [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5936.151919]                          [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5936.159272]                          [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5936.166826]     RECLAIM_FS-ON-R at:
[ 5936.170351]                          [<ffffffff810741de>] mark_held_locks+0x54/0x76
[ 5936.178070]                          [<ffffffff810748ce>] lockdep_trace_alloc+0xc3/0xcd
[ 5936.186125]                          [<ffffffff810d5f94>] __alloc_pages_nodemask+0x8d/0x878
[ 5936.194535]                          [<ffffffff81108080>] alloc_pages_current+0xc9/0xe6
[ 5936.202590]                          [<ffffffff810d261e>] __get_free_pages+0x9/0x36
[ 5936.210300]                          [<ffffffff810d265c>] get_zeroed_page+0x11/0x13
[ 5936.218010]                          [<ffffffff810f1000>] __pud_alloc+0x1b/0x76
[ 5936.225373]                          [<ffffffff810f1080>] pud_alloc+0x25/0x30
[ 5936.232545]                          [<ffffffff810f1815>] handle_mm_fault+0x98/0x818
[ 5936.240340]                          [<ffffffff81030d62>] __do_page_fault+0x36f/0x3bb
[ 5936.248221]                          [<ffffffff81030dd9>] do_page_fault+0xc/0xe
[ 5936.255584]                          [<ffffffff8139faa2>] page_fault+0x22/0x30
[ 5936.262853]                          [<ffffffff811d186f>] clear_user+0x29/0x2b
[ 5936.270129]                          [<ffffffff81396a9d>] padzero+0x1e/0x2b
[ 5936.277128]                          [<ffffffff8115be33>] load_elf_binary+0x920/0xd15
[ 5936.285010]                          [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5936.293325]                          [<ffffffff8115a2c6>] load_script+0x1aa/0x1bc
[ 5936.300852]                          [<ffffffff81120c11>] search_binary_handler+0x6f/0x167
[ 5936.309168]                          [<ffffffff81121f4b>] do_execve_common.isra.27+0x43c/0x5ca
[ 5936.317829]                          [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5936.325002]                          [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5936.332797]                          [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5936.340152]                          [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5936.347686]     INITIAL USE at:
[ 5936.350866]                      [<ffffffff81072f40>] __lock_acquire+0x3ae/0xe77
[ 5936.358308]                      [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.365478]                      [<ffffffff8139c91e>] down_write+0x3f/0x5b
[ 5936.372401]                      [<ffffffff81121d69>] do_execve_common.isra.27+0x25a/0x5ca
[ 5936.380715]                      [<ffffffff811220ec>] do_execve+0x13/0x15
[ 5936.387541]                      [<ffffffff810001ee>] run_init_process+0x26/0x28
[ 5936.394989]                      [<ffffffff8138b7e4>] kernel_init+0x3d/0xda
[ 5936.401988]                      [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5936.409160]   }
[ 5936.410927]   ... key      at: [<ffffffff8179f708>] __key.48993+0x0/0x8
[ 5936.417581]   ... acquired at:
[ 5936.420654]    [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.426268]    [<ffffffff810ef2c9>] might_fault+0x82/0xa5
[ 5936.431708]    [<ffffffff8112a94a>] filldir+0x84/0xf7
[ 5936.436802]    [<ffffffffa0cd8247>] dir_emit+0x13/0x1a [xfs]
[ 5936.442520]    [<ffffffffa0cd89e7>] xfs_dir2_block_getdents+0x145/0x190 [xfs]
[ 5936.449716]    [<ffffffffa0cd8df2>] xfs_readdir+0xfc/0x15a [xfs]
[ 5936.455815]    [<ffffffffa0cda35f>] xfs_file_readdir+0x26/0x35 [xfs]
[ 5936.462225]    [<ffffffff8112a834>] iterate_dir+0x88/0x11a
[ 5936.467759]    [<ffffffff8112aaa6>] SyS_getdents+0x76/0xd2
[ 5936.473285]    [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5936.479504] 
[ 5936.481011] -> (&xfs_dir_ilock_class){++++-+} ops: 462317 {
[ 5936.486720]    HARDIRQ-ON-W at:
[ 5936.489916]                     [<ffffffff81072ed7>] __lock_acquire+0x345/0xe77
[ 5936.497280]                     [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.504372]                     [<ffffffff8107020d>] down_write_nested+0x45/0x62
[ 5936.511823]                     [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5936.519117]                     [<ffffffffa0ce34c6>] xfs_setattr_nonsize+0x167/0x40a [xfs]
[ 5936.527475]                     [<ffffffffa0ce3aaa>] xfs_vn_setattr+0x55/0x5e [xfs]
[ 5936.535192]                     [<ffffffff811321bd>] notify_change+0x1f1/0x2d4
[ 5936.542504]                     [<ffffffff81141a9a>] utimes_common+0x116/0x176
[ 5936.549780]                     [<ffffffff81141be5>] do_utimes+0xeb/0x122
[ 5936.556604]                     [<ffffffff81141da7>] SyS_utimensat+0x65/0x7f
[ 5936.563690]                     [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5936.571399]    HARDIRQ-ON-R at:
[ 5936.574577]                     [<ffffffff81072eae>] __lock_acquire+0x31c/0xe77
[ 5936.581949]                     [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.589033]                     [<ffffffff81070132>] down_read_nested+0x48/0x57
[ 5936.596398]                     [<ffffffffa0d135af>] xfs_ilock+0xb2/0xda [xfs]
[ 5936.603700]                     [<ffffffffa0d13631>] xfs_ilock_data_map_shared+0x28/0x2e [xfs]
[ 5936.612388]                     [<ffffffffa0d1421d>] xfs_lookup+0x6e/0xfd [xfs]
[ 5936.619767]                     [<ffffffffa0ce2eb7>] xfs_vn_lookup+0x49/0x88 [xfs]
[ 5936.627407]                     [<ffffffff81123a54>] lookup_real+0x27/0x42
[ 5936.634320]                     [<ffffffff8112403a>] __lookup_hash+0x2e/0x37
[ 5936.641405]                     [<ffffffff81124db6>] walk_component+0x73/0x17d
[ 5936.648681]                     [<ffffffff81124eee>] lookup_last+0x2e/0x30
[ 5936.655592]                     [<ffffffff81125b23>] path_lookupat+0x8b/0x2c6
[ 5936.662766]                     [<ffffffff81125d7f>] filename_lookup.isra.27+0x21/0x57
[ 5936.670733]                     [<ffffffff81128a6a>] user_path_at_empty+0x52/0x90
[ 5936.678270]                     [<ffffffff81128ab4>] user_path_at+0xc/0xe
[ 5936.685104]                     [<ffffffff8111a334>] SYSC_faccessat+0x9a/0x182
[ 5936.697629]                     [<ffffffff8111af8a>] SyS_access+0x13/0x15
[ 5936.704455]                     [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5936.712163]    SOFTIRQ-ON-W at:
[ 5936.715343]                     [<ffffffff81072ef9>] __lock_acquire+0x367/0xe77
[ 5936.722730]                     [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.729817]                     [<ffffffff8107020d>] down_write_nested+0x45/0x62
[ 5936.737267]                     [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5936.744567]                     [<ffffffffa0ce34c6>] xfs_setattr_nonsize+0x167/0x40a [xfs]
[ 5936.752900]                     [<ffffffffa0ce3aaa>] xfs_vn_setattr+0x55/0x5e [xfs]
[ 5936.760626]                     [<ffffffff811321bd>] notify_change+0x1f1/0x2d4
[ 5936.767904]                     [<ffffffff81141a9a>] utimes_common+0x116/0x176
[ 5936.775185]                     [<ffffffff81141be5>] do_utimes+0xeb/0x122
[ 5936.782013]                     [<ffffffff81141da7>] SyS_utimensat+0x65/0x7f
[ 5936.789099]                     [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5936.796816]    SOFTIRQ-ON-R at:
[ 5936.799996]                     [<ffffffff81072ef9>] __lock_acquire+0x367/0xe77
[ 5936.807394]                     [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.814480]                     [<ffffffff81070132>] down_read_nested+0x48/0x57
[ 5936.821841]                     [<ffffffffa0d135af>] xfs_ilock+0xb2/0xda [xfs]
[ 5936.829150]                     [<ffffffffa0d13631>] xfs_ilock_data_map_shared+0x28/0x2e [xfs]
[ 5936.837840]                     [<ffffffffa0d1421d>] xfs_lookup+0x6e/0xfd [xfs]
[ 5936.845220]                     [<ffffffffa0ce2eb7>] xfs_vn_lookup+0x49/0x88 [xfs]
[ 5936.852860]                     [<ffffffff81123a54>] lookup_real+0x27/0x42
[ 5936.859771]                     [<ffffffff8112403a>] __lookup_hash+0x2e/0x37
[ 5936.866857]                     [<ffffffff81124db6>] walk_component+0x73/0x17d
[ 5936.874134]                     [<ffffffff81124eee>] lookup_last+0x2e/0x30
[ 5936.881049]                     [<ffffffff81125b23>] path_lookupat+0x8b/0x2c6
[ 5936.888235]                     [<ffffffff81125d7f>] filename_lookup.isra.27+0x21/0x57
[ 5936.896239]                     [<ffffffff81128a6a>] user_path_at_empty+0x52/0x90
[ 5936.903775]                     [<ffffffff81128ab4>] user_path_at+0xc/0xe
[ 5936.910600]                     [<ffffffff8111a334>] SYSC_faccessat+0x9a/0x182
[ 5936.917876]                     [<ffffffff8111af8a>] SyS_access+0x13/0x15
[ 5936.924701]                     [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5936.932410]    IN-RECLAIM_FS-W at:
[ 5936.935849]                        [<ffffffff81072f28>] __lock_acquire+0x396/0xe77
[ 5936.943473]                        [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5936.950835]                        [<ffffffff8107020d>] down_write_nested+0x45/0x62
[ 5936.958543]                        [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5936.966106]                        [<ffffffffa0cdddbb>] xfs_reclaim_inode+0x2f/0x248 [xfs]
[ 5936.974438]                        [<ffffffffa0cde16a>] xfs_reclaim_inodes_ag+0x196/0x279 [xfs]
[ 5936.983205]                        [<ffffffffa0cdeb5d>] xfs_reclaim_inodes_nr+0x2e/0x37 [xfs]
[ 5936.991831]                        [<ffffffffa0ce7840>] xfs_fs_free_cached_objects+0x10/0x12 [xfs]
[ 5937.000858]                        [<ffffffff8111ed3e>] super_cache_scan+0x128/0x145
[ 5937.008653]                        [<ffffffff810dc733>] shrink_slab_node+0x156/0x23b
[ 5937.016448]                        [<ffffffff810dce0e>] shrink_slab+0x78/0x137
[ 5937.023725]                        [<ffffffff810df942>] balance_pgdat+0x317/0x47e
[ 5937.031261]                        [<ffffffff810dfdb5>] kswapd+0x30c/0x379
[ 5937.038173]                        [<ffffffff81056235>] kthread+0xb5/0xbd
[ 5937.044999]                        [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5937.052378]    RECLAIM_FS-ON-R at:
[ 5937.055818]                        [<ffffffff810741de>] mark_held_locks+0x54/0x76
[ 5937.063353]                        [<ffffffff810748ce>] lockdep_trace_alloc+0xc3/0xcd
[ 5937.071236]                        [<ffffffff810d5f94>] __alloc_pages_nodemask+0x8d/0x878
[ 5937.079465]                        [<ffffffff81108fea>] alloc_pages_vma+0xe0/0x123
[ 5937.087087]                        [<ffffffff810f1a67>] handle_mm_fault+0x2ea/0x818
[ 5937.094795]                        [<ffffffff81030d62>] __do_page_fault+0x36f/0x3bb
[ 5937.102506]                        [<ffffffff81030dd9>] do_page_fault+0xc/0xe
[ 5937.109677]                        [<ffffffff8139faa2>] page_fault+0x22/0x30
[ 5937.116763]                        [<ffffffffa0cd8247>] dir_emit+0x13/0x1a [xfs]
[ 5937.124228]                        [<ffffffffa0cd89e7>] xfs_dir2_block_getdents+0x145/0x190 [xfs]
[ 5937.133170]                        [<ffffffffa0cd8df2>] xfs_readdir+0xfc/0x15a [xfs]
[ 5937.141002]                        [<ffffffffa0cda35f>] xfs_file_readdir+0x26/0x35 [xfs]
[ 5937.149166]                        [<ffffffff8112a834>] iterate_dir+0x88/0x11a
[ 5937.156442]                        [<ffffffff8112aaa6>] SyS_getdents+0x76/0xd2
[ 5937.163718]                        [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5937.171689]    INITIAL USE at:
[ 5937.174781]                    [<ffffffff81072f40>] __lock_acquire+0x3ae/0xe77
[ 5937.182056]                    [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5937.189059]                    [<ffffffff81070132>] down_read_nested+0x48/0x57
[ 5937.196339]                    [<ffffffffa0d135af>] xfs_ilock+0xb2/0xda [xfs]
[ 5937.203539]                    [<ffffffffa0d13631>] xfs_ilock_data_map_shared+0x28/0x2e [xfs]
[ 5937.212138]                    [<ffffffffa0d1421d>] xfs_lookup+0x6e/0xfd [xfs]
[ 5937.219441]                    [<ffffffffa0ce2eb7>] xfs_vn_lookup+0x49/0x88 [xfs]
[ 5937.226987]                    [<ffffffff81123a54>] lookup_real+0x27/0x42
[ 5937.233812]                    [<ffffffff8112403a>] __lookup_hash+0x2e/0x37
[ 5937.240811]                    [<ffffffff81124db6>] walk_component+0x73/0x17d
[ 5937.247981]                    [<ffffffff81124eee>] lookup_last+0x2e/0x30
[ 5937.254808]                    [<ffffffff81125b23>] path_lookupat+0x8b/0x2c6
[ 5937.261893]                    [<ffffffff81125d7f>] filename_lookup.isra.27+0x21/0x57
[ 5937.269809]                    [<ffffffff81128a6a>] user_path_at_empty+0x52/0x90
[ 5937.277259]                    [<ffffffff81128ab4>] user_path_at+0xc/0xe
[ 5937.283999]                    [<ffffffff8111a334>] SYSC_faccessat+0x9a/0x182
[ 5937.291170]                    [<ffffffff8111af8a>] SyS_access+0x13/0x15
[ 5937.297910]                    [<ffffffff8139de92>] system_call_fastpath+0x16/0x1b
[ 5937.305540]  }
[ 5937.307220]  ... key      at: [<ffffffffa0d58998>] xfs_dir_ilock_class+0x0/0xfffffffffffdb4cf [xfs]
[ 5937.316333]  ... acquired at:
[ 5937.319321]    [<ffffffff8107249c>] check_usage_forwards+0x95/0xa6
[ 5937.325542]    [<ffffffff81072a85>] mark_lock+0x105/0x212
[ 5937.330982]    [<ffffffff81072f28>] __lock_acquire+0x396/0xe77
[ 5937.336890]    [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5937.342500]    [<ffffffff8107020d>] down_write_nested+0x45/0x62
[ 5937.348461]    [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5937.354273]    [<ffffffffa0cdddbb>] xfs_reclaim_inode+0x2f/0x248 [xfs]
[ 5937.360878]    [<ffffffffa0cde16a>] xfs_reclaim_inodes_ag+0x196/0x279 [xfs]
[ 5937.367889]    [<ffffffffa0cdeb5d>] xfs_reclaim_inodes_nr+0x2e/0x37 [xfs]
[ 5937.374750]    [<ffffffffa0ce7840>] xfs_fs_free_cached_objects+0x10/0x12 [xfs]
[ 5937.382042]    [<ffffffff8111ed3e>] super_cache_scan+0x128/0x145
[ 5937.388088]    [<ffffffff810dc733>] shrink_slab_node+0x156/0x23b
[ 5937.394168]    [<ffffffff810dce0e>] shrink_slab+0x78/0x137
[ 5937.399695]    [<ffffffff810df942>] balance_pgdat+0x317/0x47e
[ 5937.405482]    [<ffffffff810dfdb5>] kswapd+0x30c/0x379
[ 5937.410661]    [<ffffffff81056235>] kthread+0xb5/0xbd
[ 5937.415756]    [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5937.421368] 
[ 5937.422902] 
[ 5937.422902] stack backtrace:
[ 5937.427330] CPU: 0 PID: 66 Comm: kswapd0 Not tainted 3.16.2 #59
[ 5937.433271] Hardware name: Supermicro X8SIL/X8SIL, BIOS 1.1 05/27/2010
[ 5937.439819]  ffff880234a2f6f8 ffff880234a2f688 ffffffff8139835a 0000000000000006
[ 5937.447388]  ffffffff81a1bf40 ffff880234a2f6d8 ffffffff81393afc ffffffff810709e0
[ 5937.454898]  ffffffff81579064 ffff880234a2f6ec 0000000000000000 ffff880235f51880
[ 5937.462408] Call Trace:
[ 5937.464881]  [<ffffffff8139835a>] dump_stack+0x4e/0x68
[ 5937.470042]  [<ffffffff81393afc>] print_irq_inversion_bug.part.36+0x1a1/0x1b0
[ 5937.477214]  [<ffffffff810709e0>] ? noop_count+0xb/0xb
[ 5937.482376]  [<ffffffff8107249c>] check_usage_forwards+0x95/0xa6
[ 5937.488405]  [<ffffffff81072407>] ? check_usage_backwards+0xa0/0xa0
[ 5937.494694]  [<ffffffff81072a85>] mark_lock+0x105/0x212
[ 5937.499944]  [<ffffffff81072f28>] __lock_acquire+0x396/0xe77
[ 5937.505635]  [<ffffffff810731a7>] ? __lock_acquire+0x615/0xe77
[ 5937.516694]  [<ffffffff81072f40>] ? __lock_acquire+0x3ae/0xe77
[ 5937.522550]  [<ffffffff81073ed0>] lock_acquire+0xd8/0x11a
[ 5937.527997]  [<ffffffffa0d13597>] ? xfs_ilock+0x9a/0xda [xfs]
[ 5937.533781]  [<ffffffffa0cdddbb>] ? xfs_reclaim_inode+0x2f/0x248 [xfs]
[ 5937.540334]  [<ffffffff8107020d>] down_write_nested+0x45/0x62
[ 5937.546160]  [<ffffffffa0d13597>] ? xfs_ilock+0x9a/0xda [xfs]
[ 5937.551989]  [<ffffffffa0d13597>] xfs_ilock+0x9a/0xda [xfs]
[ 5937.557622]  [<ffffffffa0cdddbb>] xfs_reclaim_inode+0x2f/0x248 [xfs]
[ 5937.564021]  [<ffffffffa0cde16a>] xfs_reclaim_inodes_ag+0x196/0x279 [xfs]
[ 5937.570833]  [<ffffffff81074345>] ? trace_hardirqs_on_caller+0x145/0x1a1
[ 5937.577562]  [<ffffffff810743ae>] ? trace_hardirqs_on+0xd/0xf
[ 5937.583357]  [<ffffffff8106284b>] ? try_to_wake_up+0x1c5/0x1d7
[ 5937.589212]  [<ffffffff810628a9>] ? wake_up_process+0x30/0x34
[ 5937.595007]  [<ffffffffa0d27524>] ? xfs_ail_push+0x49/0x4e [xfs]
[ 5937.601051]  [<ffffffffa0cdeb5d>] xfs_reclaim_inodes_nr+0x2e/0x37 [xfs]
[ 5937.607703]  [<ffffffffa0ce7840>] xfs_fs_free_cached_objects+0x10/0x12 [xfs]
[ 5937.614801]  [<ffffffff8111ed3e>] super_cache_scan+0x128/0x145
[ 5937.620656]  [<ffffffff810dc733>] shrink_slab_node+0x156/0x23b
[ 5937.626520]  [<ffffffff810dce0e>] shrink_slab+0x78/0x137
[ 5937.631854]  [<ffffffff810df942>] balance_pgdat+0x317/0x47e
[ 5937.637450]  [<ffffffff810dfdb5>] kswapd+0x30c/0x379
[ 5937.642431]  [<ffffffff8106cd60>] ? bit_waitqueue+0x87/0x87
[ 5937.648027]  [<ffffffff810dfaa9>] ? balance_pgdat+0x47e/0x47e
[ 5937.653799]  [<ffffffff81056235>] kthread+0xb5/0xbd
[ 5937.658716]  [<ffffffff81056180>] ? __kthread_parkme+0x5c/0x5c
[ 5937.664596]  [<ffffffff8139ddec>] ret_from_fork+0x7c/0xb0
[ 5937.670021]  [<ffffffff81056180>] ? __kthread_parkme+0x5c/0x5c
[ 5937.675900] [sched_delayed] sched: RT throttling activated

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
