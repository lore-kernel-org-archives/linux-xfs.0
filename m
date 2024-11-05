Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6331CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846559; cv=none; b=kcY/C0QWdzzxSIFEHzmt9ImHPGFTgsHx3nbaulOgHnkzz2lfK0om8vnRWq39BomJHK6qyVm3oCYU/x3fVGJeFr5cdjRkW08n/Y0sJh5Xr2VjNXROY0WjC5mmGdOMunJwI9a71ITQa5sHSaj/+nxPNOZMRJsTKxxfEH30BXlipEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846559; c=relaxed/simple;
	bh=t/0cIP8yDnqOkuF5yA+UipgdP/zFPyQ4qmmew8t5tz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIJI5doiKahYWT7P8e+LQ221NdZJUtyCn517/jmHTA4X49T0ittsS7terJM84WBWgAsnMI7QyxqIGJBx+3XZzYm7Vn915cGQukUiUzVDknVyMCkIZ7YWvq6cvn91Jf+GLmnj0FEkZ+tRnxkH+Vc721tUNE5eztex3/fvWhjDgM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/o6DeRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/o6DeRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A539FC4CECF;
	Tue,  5 Nov 2024 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846559;
	bh=t/0cIP8yDnqOkuF5yA+UipgdP/zFPyQ4qmmew8t5tz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J/o6DeRdL8zTzF/tch8lolGKn8n3BfrhH1goLLv7kRuAE8tRd3fnj7N2tm04eom79
	 nYOCktKKCOuPiOgdotuvTuysI77FbelxiThlSOOIfuGr/IFm8Wi17Irbmu/LToUPFL
	 g+8R6mrYCH2I+4HE2fovrdZx0sQKuO05S4k1uC+iQHoH0Eo/kB/ynkDlviFxpKShbH
	 mLn55nKIP+Sf/g8vs6JEOuIwZTPIXy1UjIlYIbpAB/KH/czpPVeDXWH3ztnTA5x/v6
	 x9HDS28G1ktV4YZ5vjAsbxhR2XjfHUi9YQ57m3twIbvTYXLkcXeoc1P6fAKdd8wASl
	 pEG0BV7/eiiPA==
Date: Tue, 05 Nov 2024 14:42:39 -0800
Subject: [PATCH 3/3] xfs: port ondisk structure checks from xfs/122 to the
 kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400460.1873612.3814710391866560581.stgit@frogsfrogsfrogs>
In-Reply-To: <173084400403.1873612.4794500935296519016.stgit@frogsfrogsfrogs>
References: <173084400403.1873612.4794500935296519016.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check this with every kernel and userspace build, so we can drop the
nonsense in xfs/122.  Roughly drafted with:

sed -e 's/^offsetof/\tXFS_CHECK_OFFSET/g' \
	-e 's/^sizeof/\tXFS_CHECK_STRUCT_SIZE/g' \
	-e 's/ = \([0-9]*\)/,\t\t\t\1);/g' \
	-e 's/xfs_sb_t/struct xfs_dsb/g' \
	-e 's/),/,/g' \
	-e 's/xfs_\([a-z0-9_]*\)_t,/struct xfs_\1,/g' \
	< tests/xfs/122.out | sort

and then manual fixups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ondisk.h |   90 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 7b7c3d6d0d62d9..ad0dedf00f1898 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -19,6 +19,10 @@
 	static_assert((value) == (expected), \
 		"XFS: value of " #value " is wrong, expected " #expected)
 
+#define XFS_CHECK_SB_OFFSET(field, offset) \
+	XFS_CHECK_OFFSET(struct xfs_dsb, field, offset); \
+	XFS_CHECK_OFFSET(struct xfs_sb, field, offset);
+
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
@@ -31,7 +35,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			288);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
@@ -55,6 +58,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,			8);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
@@ -89,7 +93,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,	12);
 	 */
 
-	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, valuelen,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, namelen,	2);
 	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, nameval,	3);
@@ -126,6 +129,20 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
+	/* ondisk dir/attr structures from xfs/122 */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,		3);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,	6);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
+
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
@@ -161,6 +178,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* ondisk log structures from xfs/122 */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_unmount_log_format,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_xmd_log_format,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_xmi_log_format,		88);
+
 	/* parent pointer ioctls */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
@@ -205,6 +227,70 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
 	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
 			16299260424LL);
+
+	/* superblock field checks we got from xfs/122 */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		288);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		288);
+	XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
+	XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
+	XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
+	XFS_CHECK_SB_OFFSET(sb_rblocks,			16);
+	XFS_CHECK_SB_OFFSET(sb_rextents,		24);
+	XFS_CHECK_SB_OFFSET(sb_uuid,			32);
+	XFS_CHECK_SB_OFFSET(sb_logstart,		48);
+	XFS_CHECK_SB_OFFSET(sb_rootino,			56);
+	XFS_CHECK_SB_OFFSET(sb_rbmino,			64);
+	XFS_CHECK_SB_OFFSET(sb_rsumino,			72);
+	XFS_CHECK_SB_OFFSET(sb_rextsize,		80);
+	XFS_CHECK_SB_OFFSET(sb_agblocks,		84);
+	XFS_CHECK_SB_OFFSET(sb_agcount,			88);
+	XFS_CHECK_SB_OFFSET(sb_rbmblocks,		92);
+	XFS_CHECK_SB_OFFSET(sb_logblocks,		96);
+	XFS_CHECK_SB_OFFSET(sb_versionnum,		100);
+	XFS_CHECK_SB_OFFSET(sb_sectsize,		102);
+	XFS_CHECK_SB_OFFSET(sb_inodesize,		104);
+	XFS_CHECK_SB_OFFSET(sb_inopblock,		106);
+	XFS_CHECK_SB_OFFSET(sb_blocklog,		120);
+	XFS_CHECK_SB_OFFSET(sb_fname[12],		120);
+	XFS_CHECK_SB_OFFSET(sb_sectlog,			121);
+	XFS_CHECK_SB_OFFSET(sb_inodelog,		122);
+	XFS_CHECK_SB_OFFSET(sb_inopblog,		123);
+	XFS_CHECK_SB_OFFSET(sb_agblklog,		124);
+	XFS_CHECK_SB_OFFSET(sb_rextslog,		125);
+	XFS_CHECK_SB_OFFSET(sb_inprogress,		126);
+	XFS_CHECK_SB_OFFSET(sb_imax_pct,		127);
+	XFS_CHECK_SB_OFFSET(sb_icount,			128);
+	XFS_CHECK_SB_OFFSET(sb_ifree,			136);
+	XFS_CHECK_SB_OFFSET(sb_fdblocks,		144);
+	XFS_CHECK_SB_OFFSET(sb_frextents,		152);
+	XFS_CHECK_SB_OFFSET(sb_uquotino,		160);
+	XFS_CHECK_SB_OFFSET(sb_gquotino,		168);
+	XFS_CHECK_SB_OFFSET(sb_qflags,			176);
+	XFS_CHECK_SB_OFFSET(sb_flags,			178);
+	XFS_CHECK_SB_OFFSET(sb_shared_vn,		179);
+	XFS_CHECK_SB_OFFSET(sb_inoalignmt,		180);
+	XFS_CHECK_SB_OFFSET(sb_unit,			184);
+	XFS_CHECK_SB_OFFSET(sb_width,			188);
+	XFS_CHECK_SB_OFFSET(sb_dirblklog,		192);
+	XFS_CHECK_SB_OFFSET(sb_logsectlog,		193);
+	XFS_CHECK_SB_OFFSET(sb_logsectsize,		194);
+	XFS_CHECK_SB_OFFSET(sb_logsunit,		196);
+	XFS_CHECK_SB_OFFSET(sb_features2,		200);
+	XFS_CHECK_SB_OFFSET(sb_bad_features2,		204);
+	XFS_CHECK_SB_OFFSET(sb_features_compat,		208);
+	XFS_CHECK_SB_OFFSET(sb_features_ro_compat,	212);
+	XFS_CHECK_SB_OFFSET(sb_features_incompat,	216);
+	XFS_CHECK_SB_OFFSET(sb_features_log_incompat,	220);
+	XFS_CHECK_SB_OFFSET(sb_crc,			224);
+	XFS_CHECK_SB_OFFSET(sb_spino_align,		228);
+	XFS_CHECK_SB_OFFSET(sb_pquotino,		232);
+	XFS_CHECK_SB_OFFSET(sb_lsn,			240);
+	XFS_CHECK_SB_OFFSET(sb_meta_uuid,		248);
+	XFS_CHECK_SB_OFFSET(sb_metadirino,		264);
+	XFS_CHECK_SB_OFFSET(sb_rgcount,			272);
+	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
+	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
+	XFS_CHECK_SB_OFFSET(sb_pad,			281);
 }
 
 #endif /* __XFS_ONDISK_H */

