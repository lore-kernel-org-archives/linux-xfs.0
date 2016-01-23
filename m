Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 363717F5E
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:37:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E95E8F8040
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5qgO2E2tO2ZajEZQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:03 -0800 (PST)
Subject: [PATCH 3/5] xfs/122: update against xfsprogs 4.3
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:37:00 -0800
Message-ID: <20160123003700.2666.8133.stgit@birch.djwong.org>
In-Reply-To: <20160123003648.2666.37062.stgit@birch.djwong.org>
References: <20160123003648.2666.37062.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

Make the xfsprogs sb layout and structure size checker work with
modern xfsprogs (i.e. 4.3+ and all the new v5 stuff).  The old test
wasn't picking up structures because they're no longer defined in the
"typedef struct xfs_foo { } xfs_foo_t;" style.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |   29 +++++-
 tests/xfs/122.out |  265 +++++++++++++++++++++++++++++------------------------
 2 files changed, 166 insertions(+), 128 deletions(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 682ffb4..e6697a2 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -74,10 +74,22 @@ progout=$tmp.output
 
 cat >$cprog <<EOF
 #include <stdio.h>
-#include <xfs/libxlog.h>
 EOF
+for hdr in /usr/include/xfs/xfs*.h; do
+	echo "#include <$(echo "$hdr" | sed -e 's|/usr/include/||g')>" >> $cprog
+done
+
+# missing:
+# xfs_attr_shortform_t
+# xfs_trans_header_t
 
 cat >$tmp.ignore <<EOF
+xfs_buf_log_format_t
+xfs_attr3_icleaf_hdr
+xfs_da3_icnode_hdr
+xfs_dir3_icfree_hdr
+xfs_dir3_icleaf_hdr
+xfs_name
 xfs_alloctype_t
 xfs_buf_cancel_t
 xfs_bmbt_rec_32_t
@@ -177,11 +189,16 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
 #
 cat /usr/include/xfs/xfs*.h | indent |\
 _attribute_filter |\
-tee $seqres.full |\
-egrep '} *xfs_.*_t' |\
+egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' > /tmp/barf
+
+cat /usr/include/xfs/xfs*.h | indent |\
+_attribute_filter |\
+egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
 egrep -v -f $tmp.ignore |\
-awk '{sub(/[;,]/,"",$2); print "printf(\"sizeof(", $2, ") = %d\\n\", sizeof(", $2, "));"}' \
->>$cprog
+sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
+sort | uniq |\
+awk '{printf("printf(\"sizeof(%s) = \\%zu\\n\", sizeof(%s));\n", $0, $0);}' |\
+cat >> $cprog
 
 #
 # Look at offsets of key ones which differ in lengths
@@ -192,7 +209,7 @@ cat /usr/include/xfs/xfs*.h | indent |\
 awk '
    /typedef struct xfs_sb/ { structon = 1; next }
    structon && $2 ~ /^sb_/ { sub(/[;,]/,"",$2)
-                             print "printf(\"offsetof(xfs_sb_t,", $2, ") = %d\\n\", offsetof(xfs_sb_t,", $2, "));"; next}
+                             printf("printf(\"offsetof(xfs_sb_t, %s) = \\%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
    structon && /}/ { structon = 0; next}
 '>>$cprog
 
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index c30e988..8ba121e 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -1,123 +1,144 @@
 QA output created by 122
-offsetof(xfs_sb_t, sb_agblklog ) = 124
-offsetof(xfs_sb_t, sb_agblocks ) = 84
-offsetof(xfs_sb_t, sb_agcount ) = 88
-offsetof(xfs_sb_t, sb_bad_features2 ) = 204
-offsetof(xfs_sb_t, sb_blocklog ) = 120
-offsetof(xfs_sb_t, sb_blocksize ) = 4
-offsetof(xfs_sb_t, sb_dblocks ) = 8
-offsetof(xfs_sb_t, sb_dirblklog ) = 192
-offsetof(xfs_sb_t, sb_fdblocks ) = 144
-offsetof(xfs_sb_t, sb_features2 ) = 200
-offsetof(xfs_sb_t, sb_flags ) = 178
-offsetof(xfs_sb_t, sb_fname[12] ) = 120
-offsetof(xfs_sb_t, sb_frextents ) = 152
-offsetof(xfs_sb_t, sb_gquotino ) = 168
-offsetof(xfs_sb_t, sb_icount ) = 128
-offsetof(xfs_sb_t, sb_ifree ) = 136
-offsetof(xfs_sb_t, sb_imax_pct ) = 127
-offsetof(xfs_sb_t, sb_inoalignmt ) = 180
-offsetof(xfs_sb_t, sb_inodelog ) = 122
-offsetof(xfs_sb_t, sb_inodesize ) = 104
-offsetof(xfs_sb_t, sb_inopblock ) = 106
-offsetof(xfs_sb_t, sb_inopblog ) = 123
-offsetof(xfs_sb_t, sb_inprogress ) = 126
-offsetof(xfs_sb_t, sb_logblocks ) = 96
-offsetof(xfs_sb_t, sb_logsectlog ) = 193
-offsetof(xfs_sb_t, sb_logsectsize ) = 194
-offsetof(xfs_sb_t, sb_logstart ) = 48
-offsetof(xfs_sb_t, sb_logsunit ) = 196
-offsetof(xfs_sb_t, sb_magicnum ) = 0
-offsetof(xfs_sb_t, sb_qflags ) = 176
-offsetof(xfs_sb_t, sb_rblocks ) = 16
-offsetof(xfs_sb_t, sb_rbmblocks ) = 92
-offsetof(xfs_sb_t, sb_rbmino ) = 64
-offsetof(xfs_sb_t, sb_rextents ) = 24
-offsetof(xfs_sb_t, sb_rextsize ) = 80
-offsetof(xfs_sb_t, sb_rextslog ) = 125
-offsetof(xfs_sb_t, sb_rootino ) = 56
-offsetof(xfs_sb_t, sb_rsumino ) = 72
-offsetof(xfs_sb_t, sb_sectlog ) = 121
-offsetof(xfs_sb_t, sb_sectsize ) = 102
-offsetof(xfs_sb_t, sb_shared_vn ) = 179
-offsetof(xfs_sb_t, sb_unit ) = 184
-offsetof(xfs_sb_t, sb_uquotino ) = 160
-offsetof(xfs_sb_t, sb_uuid ) = 32
-offsetof(xfs_sb_t, sb_versionnum ) = 100
-offsetof(xfs_sb_t, sb_width ) = 188
-sizeof( xfs_agf_t ) = <SIZE>
-sizeof( xfs_agfl_t ) = 4
-sizeof( xfs_agi_t ) = 296
-sizeof( xfs_alloc_rec_incore_t ) = 8
-sizeof( xfs_alloc_rec_t ) = 8
-sizeof( xfs_attr_inactive_list_t ) = 8
-sizeof( xfs_attr_leaf_entry_t ) = 8
-sizeof( xfs_attr_leaf_hdr_t ) = 32
-sizeof( xfs_attr_leaf_map_t ) = 4
-sizeof( xfs_attr_leaf_name_local_t ) = 4
-sizeof( xfs_attr_leaf_name_remote_t ) = 12
-sizeof( xfs_attr_leafblock_t ) = 56
-sizeof( xfs_attr_shortform_t ) = 8
-sizeof( xfs_attrlist_cursor_t ) = 16
-sizeof( xfs_bmbt_key_t ) = 8
-sizeof( xfs_bmbt_rec_t ) = 16
-sizeof( xfs_bmdr_block_t ) = 4
-sizeof( xfs_btnum_t ) = 4
-sizeof( xfs_buf_log_format_t ) = 24
-sizeof( xfs_da_blkinfo_t ) = 12
-sizeof( xfs_da_intnode_t ) = 24
-sizeof( xfs_dinode_fmt_t ) = 4
-sizeof( xfs_dir2_data_free_t ) = 4
-sizeof( xfs_dir2_data_hdr_t ) = 16
-sizeof( xfs_dir2_data_unused_t ) = 6
-sizeof( xfs_dir2_free_hdr_t ) = 16
-sizeof( xfs_dir2_free_t ) = 20
-sizeof( xfs_dir2_ino4_t ) = 4
-sizeof( xfs_dir2_ino8_t ) = 8
-sizeof( xfs_dir2_inou_t ) = 8
-sizeof( xfs_dir2_leaf_entry_t ) = 8
-sizeof( xfs_dir2_leaf_hdr_t ) = 16
-sizeof( xfs_dir2_leaf_t ) = 32
-sizeof( xfs_dir2_leaf_tail_t ) = 4
-sizeof( xfs_dir2_sf_entry_t ) = 12
-sizeof( xfs_dir2_sf_hdr_t ) = 10
-sizeof( xfs_dir2_sf_off_t ) = 2
-sizeof( xfs_dir2_sf_t ) = 22
-sizeof( xfs_dir_leaf_entry_t ) = 8
-sizeof( xfs_dir_leaf_hdr_t ) = 32
-sizeof( xfs_dir_leaf_map_t ) = 4
-sizeof( xfs_dir_leaf_name_t ) = 9
-sizeof( xfs_dir_leafblock_t ) = 52
-sizeof( xfs_dir_sf_entry_t ) = 10
-sizeof( xfs_dir_sf_hdr_t ) = 9
-sizeof( xfs_dir_shortform_t ) = 19
-sizeof( xfs_disk_dquot_t ) = 104
-sizeof( xfs_dq_logformat_t ) = 24
-sizeof( xfs_dqblk_t ) = 136
-sizeof( xfs_dsb_t ) = 208
-sizeof( xfs_efd_log_format_32_t ) = 28
-sizeof( xfs_efd_log_format_64_t ) = 32
-sizeof( xfs_efi_log_format_32_t ) = 28
-sizeof( xfs_efi_log_format_64_t ) = 32
-sizeof( xfs_error_injection_t ) = 8
-sizeof( xfs_exntfmt_t ) = 4
-sizeof( xfs_exntst_t ) = 4
-sizeof( xfs_extent_32_t ) = 12
-sizeof( xfs_extent_64_t ) = 16
-sizeof( xfs_fid_t ) = 16
-sizeof( xfs_fsid_t ) = 8
-sizeof( xfs_fsop_counts_t ) = 32
-sizeof( xfs_fsop_geom_t ) = 112
-sizeof( xfs_fsop_resblks_t ) = 16
-sizeof( xfs_growfs_log_t ) = 8
-sizeof( xfs_handle_t ) = 24
-sizeof( xfs_inobt_key_t ) = 4
-sizeof( xfs_inobt_rec_t ) = 16
-sizeof( xfs_inode_log_format_32_t ) = 52
-sizeof( xfs_inode_log_format_64_t ) = 56
-sizeof( xfs_lookup_t ) = 4
-sizeof( xfs_qoff_logformat_t ) = 20
-sizeof( xfs_sb_field_t ) = 4
-sizeof( xfs_timestamp_t ) = 8
-sizeof( xfs_trans_header_t ) = 16
-sizeof( xfs_trans_reservations_t ) = 84
+offsetof(xfs_sb_t, sb_agblklog) = 124
+offsetof(xfs_sb_t, sb_agblocks) = 84
+offsetof(xfs_sb_t, sb_agcount) = 88
+offsetof(xfs_sb_t, sb_bad_features2) = 204
+offsetof(xfs_sb_t, sb_blocklog) = 120
+offsetof(xfs_sb_t, sb_blocksize) = 4
+offsetof(xfs_sb_t, sb_crc) = 224
+offsetof(xfs_sb_t, sb_dblocks) = 8
+offsetof(xfs_sb_t, sb_dirblklog) = 192
+offsetof(xfs_sb_t, sb_fdblocks) = 144
+offsetof(xfs_sb_t, sb_features2) = 200
+offsetof(xfs_sb_t, sb_features_compat) = 208
+offsetof(xfs_sb_t, sb_features_incompat) = 216
+offsetof(xfs_sb_t, sb_features_log_incompat) = 220
+offsetof(xfs_sb_t, sb_features_ro_compat) = 212
+offsetof(xfs_sb_t, sb_flags) = 178
+offsetof(xfs_sb_t, sb_fname[12]) = 120
+offsetof(xfs_sb_t, sb_frextents) = 152
+offsetof(xfs_sb_t, sb_gquotino) = 168
+offsetof(xfs_sb_t, sb_icount) = 128
+offsetof(xfs_sb_t, sb_ifree) = 136
+offsetof(xfs_sb_t, sb_imax_pct) = 127
+offsetof(xfs_sb_t, sb_inoalignmt) = 180
+offsetof(xfs_sb_t, sb_inodelog) = 122
+offsetof(xfs_sb_t, sb_inodesize) = 104
+offsetof(xfs_sb_t, sb_inopblock) = 106
+offsetof(xfs_sb_t, sb_inopblog) = 123
+offsetof(xfs_sb_t, sb_inprogress) = 126
+offsetof(xfs_sb_t, sb_logblocks) = 96
+offsetof(xfs_sb_t, sb_logsectlog) = 193
+offsetof(xfs_sb_t, sb_logsectsize) = 194
+offsetof(xfs_sb_t, sb_logstart) = 48
+offsetof(xfs_sb_t, sb_logsunit) = 196
+offsetof(xfs_sb_t, sb_lsn) = 240
+offsetof(xfs_sb_t, sb_magicnum) = 0
+offsetof(xfs_sb_t, sb_meta_uuid) = 248
+offsetof(xfs_sb_t, sb_pquotino) = 232
+offsetof(xfs_sb_t, sb_qflags) = 176
+offsetof(xfs_sb_t, sb_rblocks) = 16
+offsetof(xfs_sb_t, sb_rbmblocks) = 92
+offsetof(xfs_sb_t, sb_rbmino) = 64
+offsetof(xfs_sb_t, sb_rextents) = 24
+offsetof(xfs_sb_t, sb_rextsize) = 80
+offsetof(xfs_sb_t, sb_rextslog) = 125
+offsetof(xfs_sb_t, sb_rootino) = 56
+offsetof(xfs_sb_t, sb_rsumino) = 72
+offsetof(xfs_sb_t, sb_sectlog) = 121
+offsetof(xfs_sb_t, sb_sectsize) = 102
+offsetof(xfs_sb_t, sb_shared_vn) = 179
+offsetof(xfs_sb_t, sb_spino_align) = 228
+offsetof(xfs_sb_t, sb_unit) = 184
+offsetof(xfs_sb_t, sb_uquotino) = 160
+offsetof(xfs_sb_t, sb_uuid) = 32
+offsetof(xfs_sb_t, sb_versionnum) = 100
+offsetof(xfs_sb_t, sb_width) = 188
+sizeof(struct xfs_acl) = 4
+sizeof(struct xfs_acl_entry) = 12
+sizeof(struct xfs_attr3_leaf_hdr) = 80
+sizeof(struct xfs_attr3_leafblock) = 88
+sizeof(struct xfs_attr3_rmt_hdr) = 56
+sizeof(struct xfs_btree_block) = 72
+sizeof(struct xfs_clone_args) = 32
+sizeof(struct xfs_da3_blkinfo) = 56
+sizeof(struct xfs_da3_intnode) = 64
+sizeof(struct xfs_da3_node_hdr) = 64
+sizeof(struct xfs_dir3_blk_hdr) = 48
+sizeof(struct xfs_dir3_data_hdr) = 64
+sizeof(struct xfs_dir3_free) = 64
+sizeof(struct xfs_dir3_free_hdr) = 64
+sizeof(struct xfs_dir3_leaf) = 64
+sizeof(struct xfs_dir3_leaf_hdr) = 64
+sizeof(struct xfs_dsymlink_hdr) = 56
+sizeof(struct xfs_extent_data) = 24
+sizeof(struct xfs_extent_data_info) = 32
+sizeof(struct xfs_fs_eofblocks) = 128
+sizeof(struct xfs_icreate_log) = 28
+sizeof(xfs_agf_t) = 224
+sizeof(xfs_agfl_t) = 36
+sizeof(xfs_agi_t) = 336
+sizeof(xfs_alloc_key_t) = 8
+sizeof(xfs_alloc_rec_incore_t) = 8
+sizeof(xfs_alloc_rec_t) = 8
+sizeof(xfs_attr_leaf_entry_t) = 8
+sizeof(xfs_attr_leaf_hdr_t) = 32
+sizeof(xfs_attr_leaf_map_t) = 4
+sizeof(xfs_attr_leaf_name_local_t) = 4
+sizeof(xfs_attr_leaf_name_remote_t) = 12
+sizeof(xfs_attr_leafblock_t) = 40
+sizeof(xfs_attr_shortform_t) = 8
+sizeof(xfs_attrlist_cursor_t) = 16
+sizeof(xfs_bmbt_key_t) = 8
+sizeof(xfs_bmbt_rec_t) = 16
+sizeof(xfs_bmdr_block_t) = 4
+sizeof(xfs_bmdr_key_t) = 8
+sizeof(xfs_btnum_t) = 4
+sizeof(xfs_da_blkinfo_t) = 12
+sizeof(xfs_da_intnode_t) = 16
+sizeof(xfs_da_node_entry_t) = 8
+sizeof(xfs_da_node_hdr_t) = 16
+sizeof(xfs_dinode_fmt_t) = 4
+sizeof(xfs_dir2_data_free_t) = 4
+sizeof(xfs_dir2_data_hdr_t) = 16
+sizeof(xfs_dir2_data_unused_t) = 6
+sizeof(xfs_dir2_free_hdr_t) = 16
+sizeof(xfs_dir2_free_t) = 16
+sizeof(xfs_dir2_ino4_t) = 4
+sizeof(xfs_dir2_ino8_t) = 8
+sizeof(xfs_dir2_inou_t) = 8
+sizeof(xfs_dir2_leaf_entry_t) = 8
+sizeof(xfs_dir2_leaf_hdr_t) = 16
+sizeof(xfs_dir2_leaf_t) = 16
+sizeof(xfs_dir2_leaf_tail_t) = 4
+sizeof(xfs_dir2_sf_entry_t) = 3
+sizeof(xfs_dir2_sf_hdr_t) = 10
+sizeof(xfs_dir2_sf_off_t) = 2
+sizeof(xfs_disk_dquot_t) = 104
+sizeof(xfs_dq_logformat_t) = 24
+sizeof(xfs_dqblk_t) = 136
+sizeof(xfs_dsb_t) = 264
+sizeof(xfs_efd_log_format_32_t) = 28
+sizeof(xfs_efd_log_format_64_t) = 32
+sizeof(xfs_efi_log_format_32_t) = 28
+sizeof(xfs_efi_log_format_64_t) = 32
+sizeof(xfs_error_injection_t) = 8
+sizeof(xfs_exntfmt_t) = 4
+sizeof(xfs_exntst_t) = 4
+sizeof(xfs_extent_32_t) = 12
+sizeof(xfs_extent_64_t) = 16
+sizeof(xfs_fid_t) = 16
+sizeof(xfs_fsid_t) = 8
+sizeof(xfs_fsop_counts_t) = 32
+sizeof(xfs_fsop_geom_t) = 112
+sizeof(xfs_fsop_resblks_t) = 16
+sizeof(xfs_growfs_log_t) = 8
+sizeof(xfs_handle_t) = 24
+sizeof(xfs_inobt_key_t) = 4
+sizeof(xfs_inobt_rec_t) = 16
+sizeof(xfs_inode_log_format_32_t) = 52
+sizeof(xfs_inode_log_format_64_t) = 56
+sizeof(xfs_lookup_t) = 4
+sizeof(xfs_qoff_logformat_t) = 20
+sizeof(xfs_timestamp_t) = 8
+sizeof(xfs_trans_header_t) = 16

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
