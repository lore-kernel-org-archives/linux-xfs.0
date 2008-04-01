Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:11:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m321Aoh4014887
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:11:15 -0700
Date: Wed, 2 Apr 2008 09:00:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Review] Improve XFS error checking and propagation
Message-ID: <20080401230044.GS103491721@sgi.com>
References: <20080311010420.GD155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311010420.GD155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

ping?

On Tue, Mar 11, 2008 at 12:04:21PM +1100, David Chinner wrote:
> A recent paper at the FAST08 conference highlighted a large number
> of unchecked error paths in Linux filesystems and I/O layers.  As a
> subsystem, XFS had the highest aggregate numbers of bad error
> propagation. A tarball which contains a quilt patch series of 32
> patches aimed at improving this situation can be found here:
> 
> http://oss.sgi.com/~dgc/xfs/error-check/xfs-error-checking.tar.gz
> 
> The paper "EIO: Error Handling is Occasionally Correct" can be found
> here:
> 
> http://www.cs.wisc.edu/adsl/Publications/eio-fast08.html
> 
> And the in depth results here:
> 
> http://www.cs.wisc.edu/adsl/Publications/eio-fast08/readme.html
> http://www.cs.wisc.edu/adsl/Publications/eio-fast08/
> 
> The XFS results I've been working from are here:
> 
> http://www.cs.wisc.edu/adsl/Publications/eio-fast08/fullfs-xfs-without-false-positives.txt
> 
> and included below is an annotated version of this file as I've
> worked through it. The graph of the XFS error paths is a good
> visual representation of how the bad error paths tend to cluster
> together:
> 
> http://www.cs.wisc.edu/adsl/Publications/eio-fast08/singlefs-xfs.pdf
> 
> (you'll need at least 800% zoom to be able to read it at all)
> 
> The paper analysed a 2.6.15 kernel, but I've been working against an
> xfs-dev tree (~2.6.24). Of the 101 reported problems for the 2.6.15
> kernel that was analysed:
> 
> - 7 did not exist anymore (bhv layer, dirv1, write path changes)
> - 11 were false positives that were not modified
> - 24 were false positives that have been patched to remove
>   (e.g. int xfs_foo() to void xfs_foo())
> - 37 real problems where an error needed to be returned and are
>   fixed in the patch series.
> - 3 where there is no error path to return an error and no
>   point in even warning about it (ENOSPC flushing)
> - 10 where there is no error path to return an error, but
>   patched to warn to the syslog about potential data loss
>   or metadata I/O errors
> - 4 were already fixed in the xfs-dev tree
> - 2 where the error is ignored because we must continue anyway
>   (patched to warn to syslog)
> - 4 that I haven't yet fixed (xfs_buf_iostrategy and
>   xfs_buf_iostart) because I need to think about them more.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> ---------------------------------------- fs/xfs/ ----
> 
> d    1	                       xfs_write -> _xfs_log_force                    fs/xfs/linux-2.6/xfs_lrw.c             881 
> d    2	                       xfs_write -> _xfs_log_force                    fs/xfs/linux-2.6/xfs_lrw.c             884 
> F    3	                xfs_flush_device -> _xfs_log_force                    fs/xfs/linux-2.6/xfs_super.c           547 
> F    4	                  xfs_qm_dqflush -> _xfs_log_force                    fs/xfs/quota/xfs_dquot.c              1294 
> F    5	     xfs_qm_dqflock_pushbuf_wait -> _xfs_log_force                    fs/xfs/quota/xfs_dquot.c              1591 
> F    6	             xfs_qm_dqunpin_wait -> _xfs_log_force                    fs/xfs/quota/xfs_dquot_item.c          204 
> F    7	    xfs_qm_dquot_logitem_pushbuf -> _xfs_log_force                    fs/xfs/quota/xfs_dquot_item.c          267 
> F    8	           xfs_alloc_search_busy -> _xfs_log_force                    fs/xfs/xfs_alloc.c                    2593 
> F    9	                 xfs_iunpin_wait -> _xfs_log_force                    fs/xfs/xfs_inode.c                    2847 
> F   10	                      xfs_iflush -> _xfs_log_force                    fs/xfs/xfs_inode.c                    3243 
> F   11	          xfs_inode_item_pushbuf -> _xfs_log_force                    fs/xfs/xfs_inode_item.c                819 
> P   12	           xfs_log_unmount_write -> _xfs_log_force                    fs/xfs/xfs_log.c                       529 
> F   13	             xlog_recover_finish -> _xfs_log_force                    fs/xfs/xfs_log_recover.c              3961 
> F   14	                   xfs_unmountfs -> _xfs_log_force                    fs/xfs/xfs_mount.c                    1088 
> F   15	              xfs_trans_push_ail -> _xfs_log_force                    fs/xfs/xfs_trans_ail.c                 198 
> F   16	                     xfs_syncsub -> _xfs_log_force                    fs/xfs/xfs_vfsops.c                   1440 
> F   17	                     xfs_syncsub -> _xfs_log_force                    fs/xfs/xfs_vfsops.c                   1455 
> F   18	                     xfs_syncsub -> _xfs_log_force                    fs/xfs/xfs_vfsops.c                   1491 
> F   19	                     xfs_syncsub -> _xfs_log_force                    fs/xfs/xfs_vfsops.c                   1543 
> P   20	                       xfs_fsync -> _xfs_log_force                    fs/xfs/xfs_vnodeops.c                 1129 
> P   21	         xfs_qm_write_sb_changes -> _xfs_trans_commit                 fs/xfs/quota/xfs_qm.c                 2414 
> P   22	            xfs_qm_scall_setqlim -> _xfs_trans_commit                 fs/xfs/quota/xfs_qm_syscalls.c         739 
> P   23	            xfs_itruncate_finish -> _xfs_trans_commit                 fs/xfs/xfs_inode.c                    1718 
> P   24	        xlog_recover_process_efi -> _xfs_trans_commit                 fs/xfs/xfs_log_recover.c              3047 
> P   25	   xlog_recover_clear_agi_bucket -> _xfs_trans_commit                 fs/xfs/xfs_log_recover.c              3174 
> PB  26	            xfs_mount_log_sbunit -> _xfs_trans_commit                 fs/xfs/xfs_mount.c                    1579 
> P   27	             xfs_growfs_rt_alloc -> _xfs_trans_commit                 fs/xfs/xfs_rtalloc.c                   154 
> P   28	             xfs_growfs_rt_alloc -> _xfs_trans_commit                 fs/xfs/xfs_rtalloc.c                   191 
> P   29	                   xfs_growfs_rt -> _xfs_trans_commit                 fs/xfs/xfs_rtalloc.c                  2103 
> P   30	              xfs_inactive_attrs -> _xfs_trans_commit                 fs/xfs/xfs_vnodeops.c                 1505 
> C   31	                    xfs_inactive -> _xfs_trans_commit                 fs/xfs/xfs_vnodeops.c                 1790 
> d   32	            xfs_initialize_vnode -> bhv_insert                        fs/xfs/linux-2.6/xfs_super.c           220 
> d   33	                   vfs_insertops -> bhv_insert                        fs/xfs/linux-2.6/xfs_vfs.c             259 
> N   34	                 linvfs_truncate -> block_truncate_page               fs/xfs/linux-2.6/xfs_iops.c            651 
> G   35	             fs_flushinval_pages -> filemap_fdatawait                 fs/xfs/linux-2.6/xfs_fs_subr.c          83 
> G   36	                  fs_flush_pages -> filemap_fdatawait                 fs/xfs/linux-2.6/xfs_fs_subr.c         108 
> G   37	             fs_flushinval_pages -> filemap_fdatawrite                fs/xfs/linux-2.6/xfs_fs_subr.c          82 
> G   38	                  fs_flush_pages -> filemap_fdatawrite                fs/xfs/linux-2.6/xfs_fs_subr.c         105 
> n   39	            xfs_flush_inode_work -> filemap_flush                     fs/xfs/linux-2.6/xfs_super.c           508 
> PM  40	                       xlog_sync -> pagebuf_associate_memory          fs/xfs/xfs_log.c                      1358 
> PM  41	                       xlog_sync -> pagebuf_associate_memory          fs/xfs/xfs_log.c                      1395 
> PM  42	          xlog_write_log_records -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              1156 
> PM  43	          xlog_write_log_records -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              1159 
> PM  44	           xlog_do_recovery_pass -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              3646 
> PM  45	           xlog_do_recovery_pass -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              3653 
> PM  46	           xlog_do_recovery_pass -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              3705 
> PM  47	           xlog_do_recovery_pass -> pagebuf_associate_memory          fs/xfs/xfs_log_recover.c              3711 
>  M  48	              xfs_buf_read_flags -> pagebuf_iostart                   fs/xfs/linux-2.6/xfs_buf.c             636 
>  M  49	                         xfsbufd -> pagebuf_iostrategy                fs/xfs/linux-2.6/xfs_buf.c            1755 
>  M  50	               xfs_flush_buftarg -> pagebuf_iostrategy                fs/xfs/linux-2.6/xfs_buf.c            1816 
>  M  51	                      XFS_bwrite -> pagebuf_iostrategy                fs/xfs/linux-2.6/xfs_buf.h             503 
> n   52	           xfs_flush_device_work -> sync_blockdev                     fs/xfs/linux-2.6/xfs_super.c           533 
> f   53	                     exit_xfs_fs -> unregister_filesystem             fs/xfs/linux-2.6/xfs_super.c           999 
> PM  54	                    xfs_acl_vset -> xfs_acl_vremove                   fs/xfs/xfs_acl.c                       326 
> f   55	            xfs_ialloc_ag_select -> xfs_alloc_pagf_init               fs/xfs/xfs_ialloc.c                    411 
> P   56	                  xfs_qm_dqflush -> xfs_bawrite                       fs/xfs/quota/xfs_dquot.c              1300 
> N   57	     xfs_qm_dqflock_pushbuf_wait -> xfs_bawrite                       fs/xfs/quota/xfs_dquot.c              1595 
> N   58	    xfs_qm_dquot_logitem_pushbuf -> xfs_bawrite                       fs/xfs/quota/xfs_dquot_item.c          275 
> N   59	               xfs_buf_item_push -> xfs_bawrite                       fs/xfs/xfs_buf_item.c                  669 
> P   60	                      xfs_iflush -> xfs_bawrite                       fs/xfs/xfs_inode.c                    3249 
> N   61	          xfs_inode_item_pushbuf -> xfs_bawrite                       fs/xfs/xfs_inode_item.c                823 
> F   62	                  xfs_qm_dqflush -> xfs_bdwrite                       fs/xfs/quota/xfs_dquot.c              1298 
> F   63	              xfs_qm_dqiter_bufs -> xfs_bdwrite                       fs/xfs/quota/xfs_qm.c                 1551 
> F   64	                      xfs_iflush -> xfs_bdwrite                       fs/xfs/xfs_inode.c                    3247 
> F   65	    xlog_recover_do_buffer_trans -> xfs_bdwrite                       fs/xfs/xfs_log_recover.c              2271 
> F   66	     xlog_recover_do_inode_trans -> xfs_bdwrite                       fs/xfs/xfs_log_recover.c              2535 
> F   67	     xlog_recover_do_dquot_trans -> xfs_bdwrite                       fs/xfs/xfs_log_recover.c              2664 
> C   68	                    xfs_inactive -> xfs_bmap_finish                   fs/xfs/xfs_vnodeops.c                 1788 
> P   69	        xfs_iomap_write_allocate -> xfs_bmap_last_offset              fs/xfs/xfs_iomap.c                     787 
> d   70	          xfs_dir_leaf_rebalance -> xfs_dir_leaf_compact              fs/xfs/xfs_dir_leaf.c                 1146 
> d   71	          xfs_dir_leaf_rebalance -> xfs_dir_leaf_compact              fs/xfs/xfs_dir_leaf.c                 1176 
> d   72	       xfs_dir_leaf_to_shortform -> xfs_dir_shortform_addname         fs/xfs/xfs_dir_leaf.c                  693 
> P   73	        xlog_recover_process_efi -> xfs_free_extent                   fs/xfs/xfs_log_recover.c              3041 
> n   74	             xfs_inode_item_push -> xfs_iflush                        fs/xfs/xfs_inode_item.c                879 
> P   75	     xlog_recover_do_inode_trans -> xfs_imap                          fs/xfs/xfs_log_recover.c              2320 
> f   76	             xfs_bmap_add_extent -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                      689 
> f   77	  xfs_bmap_add_extent_hole_delay -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     1918 
> f   78	             xfs_bmap_del_extent -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     3117 
> f   79	                       xfs_bmapi -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     4801 
> f   80	                       xfs_bmapi -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     4805 
> f   81	                     xfs_bunmapi -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     5452 
> f   82	                     xfs_bunmapi -> xfs_mod_incore_sb                 fs/xfs/xfs_bmap.c                     5458 
> f   83	               xfs_trans_reserve -> xfs_mod_incore_sb                 fs/xfs/xfs_trans.c                     305 
> P   84	               xfs_qm_quotacheck -> xfs_mount_reset_sbqflags          fs/xfs/quota/xfs_qm.c                 1962 
> N   85	                  xfs_qm_dqpurge -> xfs_qm_dqflush                    fs/xfs/quota/xfs_dquot.c              1505 
> NB  86	       xfs_qm_dquot_logitem_push -> xfs_qm_dqflush                    fs/xfs/quota/xfs_dquot_item.c          168 
> N   87	           xfs_qm_shake_freelist -> xfs_qm_dqflush                    fs/xfs/quota/xfs_qm.c                 2134 
> N   88	            xfs_qm_dqreclaim_one -> xfs_qm_dqflush                    fs/xfs/quota/xfs_qm.c                 2306 
> PM  89	               xfs_qm_quotacheck -> xfs_qm_dqflush_all                fs/xfs/quota/xfs_qm.c                 1930 
> P   90	           xfs_qm_scall_quotaoff -> xfs_qm_log_quotaoff               fs/xfs/quota/xfs_qm_syscalls.c         291 
> P   91	           xfs_qm_scall_quotaoff -> xfs_qm_log_quotaoff_end           fs/xfs/quota/xfs_qm_syscalls.c         347 
> F   92	                 xfs_qm_newmount -> xfs_qm_mount_quotas               fs/xfs/quota/xfs_qm_bhv.c              273 
> F   93	                 xfs_qm_endmount -> xfs_qm_mount_quotas               fs/xfs/quota/xfs_qm_bhv.c              301 
> PM  94	                  xfs_quiesce_fs -> xfs_syncsub                       fs/xfs/xfs_vfsops.c                    632 
> P   95	        xlog_recover_process_efi -> xfs_trans_reserve                 fs/xfs/xfs_log_recover.c              3036 
> P   96	   xlog_recover_clear_agi_bucket -> xfs_trans_reserve                 fs/xfs/xfs_log_recover.c              3152 
> P   97	       xfs_qm_scall_trunc_qfiles -> xfs_truncate_file                 fs/xfs/quota/xfs_qm_syscalls.c         395 
> P   98	       xfs_qm_scall_trunc_qfiles -> xfs_truncate_file                 fs/xfs/quota/xfs_qm_syscalls.c         404 
> P   99	           xfs_log_unmount_write -> xlog_state_release_iclog          fs/xfs/xfs_log.c                       570 
> P  100	           xfs_log_unmount_write -> xlog_state_release_iclog          fs/xfs/xfs_log.c                       606 
> f  101	            xfs_log_force_umount -> xlog_state_sync_all               fs/xfs/xfs_log.c                      3586 
> 
> f = false positive
> F = false positive + patch to remove condition
> G = patch in mainline git tree already
> M = __must_check annotations found this as well
> P = real, patch to fix
> n = no error path to return error
> N = no error path to return error, patch to warn about error added
> d = does not exist anymore.
> B = some other bug found and fixed at same time
> C = error ignored, must continue anyway. If silent, made noisy
> 
> Notes:
> 
> - all the xfs_mod_incore_sb() are false positive because they are freeing
>   blocks or extents which means there can never be an error returned. The only
>   error that can be returned is ENOSPC when trying to allocate blocks....
> 
> - none of the callers of xfs_mount_log_sb() check the return value.
> 
> - new function xfs_log_sbcount failed to check return of xfs_trans_commit.
>   Callers are failing to check return value.
> 
> - most of the callers to xfs_log_force() are not interested in errors - they'll
>   get them through other means (i.e. log error implies filesystem shutdown).
>   Only a handful of callers really should return errors, such as fsync(),
>   sync writes or synchronous transaction commits.
> 

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
