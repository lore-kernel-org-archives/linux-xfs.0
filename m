Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:52859 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725817AbeKMHAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 02:00:31 -0500
Message-ID: <cd6650d08304418a25f3e51ad910cce6d15b8716.camel@perches.com>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
From: Joe Perches <joe@perches.com>
In-Reply-To: <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
         <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Date: Mon, 12 Nov 2018 13:05:02 -0800
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, 2018-11-12 at 14:12 -0600, Eric Sandeen wrote:
> On 11/10/18 7:21 PM, Joe Perches wrote:
> > Reduce total object size quite a bit (~32KB) and presumably
> > improve performance at the same time.
> > 
> > Total object size old vs new (x86-64 defconfig with xfs)
> > 
> >     text	   data	    bss	    dec	    hex	filename
> > - 959351	 165573	    632	1125556	 112cb4	(TOTALS) (old)
> > + 924683	 165669	    632	1090984	 10a5a8	(TOTALS) (new)
> 
> And what does it do to maximum stack excursions?

It seems to add a maximum of 40 bytes in xfs_reclaim_inodes_ag
and xfs_readdir, but I didn't do more than visually scan
checkstack output.

Using scripts/checkstack.pl on defconfig x86-64 with xfs
and cutting out absolute addresses

 diff -urN xfs_cs_old_2 xfs_cs_new_2 
--- xfs_cs_old_2	2018-11-12 12:55:03.195282512 -0800
+++ xfs_cs_new_2	2018-11-12 12:55:09.219168923 -0800
@@ -1,18 +1,20 @@
 xfs_ag_init_headers [vmlinux]:	464
 xfs_ag_init_headers [vmlinux]:	464
-xfs_inode_ag_walk.isra.19 [vmlinux]:	416
-xfs_inode_ag_walk.isra.19 [vmlinux]:	416
+xfs_inode_ag_walk.isra.21 [vmlinux]:	424
+xfs_inode_ag_walk.isra.21 [vmlinux]:	424
+xfs_reclaim_inodes_ag [vmlinux]:	368
+xfs_reclaim_inodes_ag [vmlinux]:	368
 xfs_trans_committed_bulk [vmlinux]:	336
-xfs_reclaim_inodes_ag [vmlinux]:	328
-xfs_reclaim_inodes_ag [vmlinux]:	328
 xfs_ioc_getfsmap.isra.23 [vmlinux]:	320
 xfs_ioc_getfsmap.isra.23 [vmlinux]:	320
+xfs_file_ioctl [vmlinux]:		320
+xfs_file_ioctl [vmlinux]:		320
+xfs_bmapi_write [vmlinux]:		312
 xfs_getfsmap [vmlinux]:		304
 xfs_qm_dquot_walk.isra.11 [vmlinux]:	296
 xfs_qm_dquot_walk.isra.11 [vmlinux]:	296
-xfs_bmapi_write [vmlinux]:		288
-xfs_file_ioctl [vmlinux]:		288
-xfs_file_ioctl [vmlinux]:		288
+xfs_file_compat_ioctl [vmlinux]:	288
+xfs_file_compat_ioctl [vmlinux]:	288
 xfs_sb_read_verify [vmlinux]:	280
 xfs_sb_read_verify [vmlinux]:	280
 xfs_sb_write_verify [vmlinux]:	272
@@ -21,36 +23,38 @@
 xfs_rmap_convert [vmlinux]:		264
 xfs_rmap_convert_shared [vmlinux]:	256
 xfs_rmap_convert_shared [vmlinux]:	256
-xfs_file_compat_ioctl [vmlinux]:	256
-xfs_file_compat_ioctl [vmlinux]:	256
 xfs_bmap_extents_to_btree [vmlinux]:	248
 xfs_bmap_extents_to_btree [vmlinux]:	248
+xfs_bmap_del_extent_real [vmlinux]:	240
+xfs_alloc_fix_freelist [vmlinux]:	224
+xfs_alloc_fix_freelist [vmlinux]:	224
+xfs_bmap_add_extent_unwritten_real [vmlinux]:224
 xfs_symlink [vmlinux]:		224
 xfs_symlink [vmlinux]:		224
-xfs_alloc_fix_freelist [vmlinux]:	216
-xfs_alloc_fix_freelist [vmlinux]:	216
-xfs_bmap_local_to_extents.constprop.27 [vmlinux]:208
-xfs_bmap_local_to_extents.constprop.27 [vmlinux]:208
-xfs_ialloc_ag_alloc [vmlinux]:	208
-xfs_ialloc_ag_alloc [vmlinux]:	208
-xfs_bmap_add_extent_unwritten_real [vmlinux]:192
-xfs_bmap_add_extent_unwritten_real [vmlinux]:192
-xfs_bmap_add_extent_delay_real [vmlinux]:192
-xfs_bmap_add_extent_delay_real [vmlinux]:192
-xfs_bmap_del_extent_real [vmlinux]:	192
-xfs_bmap_del_extent_real [vmlinux]:	192
-xfs_bmap_btalloc [vmlinux]:		192
-xfs_bmap_btalloc [vmlinux]:		192
+xfs_bmap_btalloc [vmlinux]:		216
+xfs_bmap_btalloc [vmlinux]:		216
+xfs_attr_rmtval_set [vmlinux]:	208
+xfs_bmap_add_extent_delay_real [vmlinux]:208
+xfs_bmap_local_to_extents.constprop.28 [vmlinux]:208
+xfs_bmap_local_to_extents.constprop.28 [vmlinux]:208
+xfs_bulkstat [vmlinux]:		208
+xfs_ialloc_ag_alloc [vmlinux]:	200
+xfs_ialloc_ag_alloc [vmlinux]:	200
 xfs_refcountbt_alloc_block [vmlinux]:192
 xfs_refcountbt_alloc_block [vmlinux]:192
+xfs_reflink_remap_blocks [vmlinux]:	192
+xfs_reflink_remap_blocks [vmlinux]:	192
 __xfs_bunmapi [vmlinux]:		184
 __xfs_bunmapi [vmlinux]:		184
 xfs_rmap_map [vmlinux]:		184
 xfs_rmap_map [vmlinux]:		184
+xfs_readdir [vmlinux]:		184
+xfs_readdir [vmlinux]:		184
 xfs_attr_set [vmlinux]:		176
 xfs_attr_set [vmlinux]:		176
 xfs_attr3_leaf_to_shortform [vmlinux]:176
 xfs_attr3_leaf_to_shortform [vmlinux]:176
+xfs_bmap_add_extent_hole_real [vmlinux]:176
 xfs_attr_shortform_to_leaf [vmlinux]:168
 xfs_attr_shortform_to_leaf [vmlinux]:168
 xfs_btree_delrec [vmlinux]:		168
@@ -59,89 +63,99 @@
 xfs_rmap_unmap [vmlinux]:		168
 xfs_rmap_map_shared [vmlinux]:	168
 xfs_rmap_map_shared [vmlinux]:	168
-xfs_bulkstat [vmlinux]:		168
-xfs_bulkstat [vmlinux]:		168
 xfs_scrub_metadata [vmlinux]:	168
 xfs_scrub_metadata [vmlinux]:	168
 xfs_free_extent_fix_freelist [vmlinux]:160
 xfs_free_extent_fix_freelist [vmlinux]:160
-xfs_bmap_add_extent_hole_real [vmlinux]:160
-xfs_bmap_add_extent_hole_real [vmlinux]:160
+xfs_attr3_leaf_split [vmlinux]:	160
+xfs_attr3_leaf_split [vmlinux]:	160
 xfs_bmap_insert_extents [vmlinux]:	160
 xfs_bmap_insert_extents [vmlinux]:	160
 xfs_bmbt_alloc_block [vmlinux]:	160
 xfs_bmbt_alloc_block [vmlinux]:	160
 xfs_btree_overlapped_query_range [vmlinux]:160
 xfs_btree_overlapped_query_range [vmlinux]:160
+xfs_dialloc [vmlinux]:		160
+xfs_dialloc [vmlinux]:		160
 __xfs_inobt_alloc_block.isra.9 [vmlinux]:160
 __xfs_inobt_alloc_block.isra.9 [vmlinux]:160
 xfs_ag_resv_rmapbt_alloc [vmlinux]:	160
 xfs_ag_resv_rmapbt_alloc [vmlinux]:	160
+xfs_do_writepage [vmlinux]:		160
+xfs_do_writepage [vmlinux]:		160
 xfs_dir2_leaf_readbuf [vmlinux]:	160
 xfs_readlink_bmap_ilocked [vmlinux]:	160
 xfs_readlink_bmap_ilocked [vmlinux]:	160
 xfs_ag_resv_rmapbt_alloc [vmlinux]:	160
 xfs_ag_resv_rmapbt_alloc [vmlinux]:	160
+xfs_da3_split [vmlinux]:		152
+xfs_da3_split [vmlinux]:		152
 xfs_getbmap [vmlinux]:		152
 xfs_getbmap [vmlinux]:		152
 trace_raw_output_xfs_loggrant_class [vmlinux]:144
 trace_raw_output_xfs_alloc_class [vmlinux]:144
 xfs_attr_remove [vmlinux]:		144
 xfs_attr_remove [vmlinux]:		144
-xfs_dialloc_ag_inobt [vmlinux]:	144
-xfs_dialloc_ag_inobt [vmlinux]:	144
+xfs_bmap_split_extent_at [vmlinux]:	144
+__xfs_btree_split.isra.45 [vmlinux]:	144
+__xfs_btree_split.isra.45 [vmlinux]:	144
+xfs_btree_insrec [vmlinux]:		144
+xfs_btree_insrec [vmlinux]:		144
+xfs_da_shrink_inode [vmlinux]:	144
+xfs_da_shrink_inode [vmlinux]:	144
+xfs_attr_list_int_ilocked [vmlinux]:	144
+xfs_attr_list_int_ilocked [vmlinux]:	144
 xfs_swap_extent_rmap [vmlinux]:	144
 xfs_swap_extent_rmap [vmlinux]:	144
-xfs_readdir [vmlinux]:		144
-xfs_readdir [vmlinux]:		144
+xfs_ioc_trim [vmlinux]:		144
+xfs_ioc_trim [vmlinux]:		144
 xfs_inactive_symlink_rmt [vmlinux]:	144
 xfs_inactive_symlink_rmt [vmlinux]:	144
 xfs_attr_get [vmlinux]:		136
 xfs_attr_get [vmlinux]:		136
+xfs_attr_rmtval_get [vmlinux]:	136
+xfs_attr_rmtval_get [vmlinux]:	136
 xfs_bmap_add_attrfork_local [vmlinux]:136
 xfs_bmap_add_attrfork_local [vmlinux]:136
-__xfs_btree_split.isra.38 [vmlinux]:	136
-__xfs_btree_split.isra.38 [vmlinux]:	136
 xfs_btree_split [vmlinux]:		136
 xfs_btree_split [vmlinux]:		136
-xfs_btree_insrec [vmlinux]:		136
-xfs_btree_insrec [vmlinux]:		136
+xfs_rmap_finish_one [vmlinux]:	136
+xfs_rmap_finish_one [vmlinux]:	136
+xfs_attr3_leaf_inactive [vmlinux]:	136
+xfs_attr3_leaf_inactive [vmlinux]:	136
 xfs_rename [vmlinux]:		136
 xfs_rename [vmlinux]:		136
 xfs_attr3_leaf_unbalance [vmlinux]:	120
 xfs_attr3_leaf_unbalance [vmlinux]:	120
-xfs_attr_rmtval_set [vmlinux]:	120
-xfs_attr_rmtval_set [vmlinux]:	120
-xfs_ioc_fsgeometry_v1 [vmlinux]:	120
-xfs_ioc_fsgeometry_v1 [vmlinux]:	120
-xfs_ioc_fsgeometry [vmlinux]:	120
-xfs_ioc_fsgeometry [vmlinux]:	120
+xfs_refcount_merge_extents [vmlinux]:120
+xfs_refcount_merge_extents [vmlinux]:120
 xfs_file_iomap_begin [vmlinux]:	120
 xfs_file_iomap_begin [vmlinux]:	120
-xfs_compat_ioc_fsgeometry_v1 [vmlinux]:120
-xfs_compat_ioc_fsgeometry_v1 [vmlinux]:120
+xfs_ifree [vmlinux]:			120
+xfs_ifree [vmlinux]:			120
+xfs_qm_reset_dqcounts_buf.part.15 [vmlinux]:120
+xfs_qm_reset_dqcounts_buf.part.15 [vmlinux]:120
+xfs_rtallocate_extent [vmlinux]:	120
+xfs_rtallocate_extent [vmlinux]:	120
+xfs_free_ag_extent [vmlinux]:	112
 xfs_attr3_leaf_toosmall [vmlinux]:	112
 xfs_attr3_leaf_toosmall [vmlinux]:	112
-xfs_attr3_leaf_rebalance [vmlinux]:	112
-xfs_attr3_leaf_rebalance [vmlinux]:	112
+xfs_bmap_del_extent_delay [vmlinux]:	112
+xfs_bmap_del_extent_delay [vmlinux]:	112
 xfs_iread_extents [vmlinux]:		112
 xfs_iread_extents [vmlinux]:		112
-xfs_bmap_split_extent_at [vmlinux]:	112
-xfs_bmap_split_extent_at [vmlinux]:	112
 xfs_btree_insert [vmlinux]:		112
 xfs_btree_query_range [vmlinux]:	112
-xfs_da3_swap_lastblock [vmlinux]:	112
-xfs_da3_swap_lastblock [vmlinux]:	112
 xfs_dir2_node_addname [vmlinux]:	112
 xfs_dir2_node_addname [vmlinux]:	112
 xfs_dir2_node_removename [vmlinux]:	112
 xfs_dir2_node_removename [vmlinux]:	112
-xfs_trim_extents [vmlinux]:		112
-xfs_trim_extents [vmlinux]:		112
+xfs_difree [vmlinux]:		112
+xfs_difree [vmlinux]:		112
 xfs_growfs_data [vmlinux]:		112
 xfs_growfs_data [vmlinux]:		112
-xfs_ifree_cluster.isra.21 [vmlinux]:	112
-xfs_ifree_cluster.isra.21 [vmlinux]:	112
+xfs_iget [vmlinux]:			112
+xfs_iget [vmlinux]:			112
 xfs_inumbers [vmlinux]:		112
 xfs_inumbers [vmlinux]:		112
 xfs_reflink_end_cow [vmlinux]:	112
@@ -149,17 +163,19 @@
 xfs_vn_listxattr [vmlinux]:		112
 xfs_vn_listxattr [vmlinux]:		112
 xfsaild [vmlinux]:			112
+xfs_growfs_rt [vmlinux]:		112
+xfs_growfs_rt [vmlinux]:		112
 trace_raw_output_xfs_dquot_class [vmlinux]:104
 xfs_bmapi_reserve_delalloc [vmlinux]:104
 xfs_bmapi_reserve_delalloc [vmlinux]:104
+xfs_btree_lshift [vmlinux]:		104
+xfs_btree_lshift [vmlinux]:		104
 xfs_da_grow_inode_int [vmlinux]:	104
 xfs_da_grow_inode_int [vmlinux]:	104
 xfs_dir2_leaf_removename [vmlinux]:	104
 xfs_dir2_leaf_removename [vmlinux]:	104
 xfs_dir2_leafn_split [vmlinux]:	104
 xfs_dir2_leafn_split [vmlinux]:	104
-xfs_iget [vmlinux]:			104
-xfs_iget [vmlinux]:			104
 xfs_ioc_space [vmlinux]:		104
 xfs_ioc_space [vmlinux]:		104
 xfs_emerg [vmlinux]:			104
@@ -169,15 +185,9 @@
 xfs_warn [vmlinux]:			104
 xfs_notice [vmlinux]:		104
 xfs_info [vmlinux]:			104
-xfs_reflink_remap_extent [vmlinux]:	104
-xfs_reflink_remap_extent [vmlinux]:	104
-xfs_reflink_dirty_extents [vmlinux]:	104
-xfs_reflink_dirty_extents [vmlinux]:	104
 xfs_reflink_cancel_cow_blocks [vmlinux]:104
 xfs_reflink_cancel_cow_blocks [vmlinux]:104
 xfs_log_quiesce [vmlinux]:		104
 xfs_log_quiesce [vmlinux]:		104
-xfs_rtallocate_extent_near [vmlinux]:104
-xfs_rtallocate_extent_near [vmlinux]:104
 xfs_set_acl [vmlinux]:		104
 xfs_set_acl [vmlinux]:		104
