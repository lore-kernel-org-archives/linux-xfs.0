Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D075E13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991768; cv=none; b=ljNzvjPo2UMn9HnPpcyZv5dYpAg0OUyKysq8eQxPajWmMYpPtlkZ7c76r4EF45RcEgc+eEgTND3QNf+oRq+sFpbOWWaWZ3jh4T2jt1V+CAdWgLqgdr/T8tYrXwpXTBC/xj/0y65vIhm6sWHRlaRDpq4BZkjRz3aPPZ3w9nzM6ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991768; c=relaxed/simple;
	bh=uCvXduSHuA7+HaOsVeYArYOK/UxQn3d+GV2fBYI5ca4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9gBmABZZOWG8GZB5ZlA9Z/7CSMO6qIK6UtR55JfqKfr3CXc3UGMRIm5BHttezMSvbi8mYT56z1EjzyTPf4KB54z2z4o52DoDY9zA56v5MnBEpBs9K87VV+4BoAVe8Wq4bVMmdUJw31/qpo4fJDVCX6T72F4N88Ld4qCXdwZdfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ft5Pgj1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ft5Pgj1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B550C4CED3;
	Mon, 23 Dec 2024 22:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991766;
	bh=uCvXduSHuA7+HaOsVeYArYOK/UxQn3d+GV2fBYI5ca4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ft5Pgj1/7ph5DUVyuxm4AjLQH0JjMf9ghCmLpobeeXt4ryzjzBo3SLzALpQUfQxlL
	 A9mAQfKM/hAA7vkFCq6OCeVzIT1MIslfqKp6xqLbizOShH869NqxZf9lihKWBz/K2a
	 w30++JEptRQ4rK04Nd7VYaUEh2ItlDbaHIq+kDO9LOneQo+JtXT7llh8tK/CG9dx6t
	 iInv3LL6uR07aqUSDegJAQEu3sPzH/BIrpSciucv+blBScpPz/e72A4hspFWR6fah4
	 MvGjtVKGS/niE9ILRkkkJ8O2L3ZVDukdhIdD3W3BPeenP7wViUbvQ0yWjWJNdTTIz1
	 K39Mhwx4UeCEw==
Date: Mon, 23 Dec 2024 14:09:25 -0800
Subject: [PATCH 43/52] xfs: port ondisk structure checks from xfs/122 to the
 kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943149.2295836.16415131077959821471.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 13877bc79d81354c53e91f3c86ac0f7bafe3ba7b

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
 libxfs/xfs_ondisk.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 7b7c3d6d0d62d9..ad0dedf00f1898 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
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

