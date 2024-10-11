Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F71C8FB3
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671048; cv=none; b=t8XhiXLdR/BY+NRRTy8epT5u4GsokZ2iIoh4Nxi/Z9Hvrmzl2Qcle9U83YNdNE8BaO67bfzv7M0XG3Wz6fSB4uqSKJwG9CbqG3jvRpLw3ppubKdZKBjmEKKBdUTv39B8VzSV8VSfbkNJzClZgzmytrnjRFJMRvdQJNuxnDvByqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671048; c=relaxed/simple;
	bh=hP2obfoW8MErhfKytFiwf7QH7qV+ZsDE5NbthQrLKgM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bdH7in58MVx3YdomZS8ltd7zB8DxyzYNpbTh9io/W7PgO+SCviuGyiw6BW32m6KtjieTYKJQ/rfoq86EQhnrzAtB4ye+vwjmclZHH3Gas7h9jm/jR7o7OrvMWRs8yzGrgoaqpsi+NYIu8xpyRDDckL9Tgdgwh/qBL4CatEeVMB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVtGqJwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVtGqJwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA96C4CEC7;
	Fri, 11 Oct 2024 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728671047;
	bh=hP2obfoW8MErhfKytFiwf7QH7qV+ZsDE5NbthQrLKgM=;
	h=Date:From:To:Cc:Subject:From;
	b=cVtGqJwC3pRLkUp3qHzJ/+I9MPKcK+kkj0DJ1yAx2sTwe9QwQRNzRT/MlcOgfFckI
	 fsG4dmTZkJvy6aaXhQUNPHTf5PclgauYGuNbijl2gy6Vuq3kSXP8k74poPMffl1qJ3
	 1txkzJJwgQuFWHwhjJGzkVKJX+o2qZJAoMIx4eeZ4OIrp5Zt7QAsN/uLH+QzEn5MV5
	 rStYeDIBOd+AFZTiSFLNdmTRMGz5BpaIqQ2Rqu2/K4EBaqglE92WDN701WDTXRdYcq
	 mLcgxCVyoYyx7g08ajNm4FQSqNt+iwIEDoVrvJhyONsN5ugvaR3jz84q/Bz9JbKxFv
	 tQ049pu75Ok5g==
Date: Fri, 11 Oct 2024 11:24:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <20241011182407.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
---
 fs/xfs/libxfs/xfs_ondisk.h |  111 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 23c133fd36f5bb..89d9139394c466 100644
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
@@ -85,7 +89,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
-	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
@@ -201,6 +204,112 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
 	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
 			16299260424LL);
+
+	/* stuff we got from xfs/122 */
+	XFS_CHECK_SB_OFFSET(sb_agblklog,		124);
+	XFS_CHECK_SB_OFFSET(sb_agblocks,		84);
+	XFS_CHECK_SB_OFFSET(sb_agcount,			88);
+	XFS_CHECK_SB_OFFSET(sb_bad_features2,		204);
+	XFS_CHECK_SB_OFFSET(sb_blocklog,		120);
+	XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
+	XFS_CHECK_SB_OFFSET(sb_crc,			224);
+	XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
+	XFS_CHECK_SB_OFFSET(sb_dirblklog,		192);
+	XFS_CHECK_SB_OFFSET(sb_fdblocks,		144);
+	XFS_CHECK_SB_OFFSET(sb_features2,		200);
+	XFS_CHECK_SB_OFFSET(sb_features_compat,		208);
+	XFS_CHECK_SB_OFFSET(sb_features_incompat,	216);
+	XFS_CHECK_SB_OFFSET(sb_features_log_incompat,	220);
+	XFS_CHECK_SB_OFFSET(sb_features_ro_compat,	212);
+	XFS_CHECK_SB_OFFSET(sb_flags,			178);
+	XFS_CHECK_SB_OFFSET(sb_fname[12],		120);
+	XFS_CHECK_SB_OFFSET(sb_frextents,		152);
+	XFS_CHECK_SB_OFFSET(sb_gquotino,		168);
+	XFS_CHECK_SB_OFFSET(sb_icount,			128);
+	XFS_CHECK_SB_OFFSET(sb_ifree,			136);
+	XFS_CHECK_SB_OFFSET(sb_imax_pct,		127);
+	XFS_CHECK_SB_OFFSET(sb_inoalignmt,		180);
+	XFS_CHECK_SB_OFFSET(sb_inodelog,		122);
+	XFS_CHECK_SB_OFFSET(sb_inodesize,		104);
+	XFS_CHECK_SB_OFFSET(sb_inopblock,		106);
+	XFS_CHECK_SB_OFFSET(sb_inopblog,		123);
+	XFS_CHECK_SB_OFFSET(sb_inprogress,		126);
+	XFS_CHECK_SB_OFFSET(sb_logblocks,		96);
+	XFS_CHECK_SB_OFFSET(sb_logsectlog,		193);
+	XFS_CHECK_SB_OFFSET(sb_logsectsize,		194);
+	XFS_CHECK_SB_OFFSET(sb_logstart,		48);
+	XFS_CHECK_SB_OFFSET(sb_logsunit,		196);
+	XFS_CHECK_SB_OFFSET(sb_lsn,			240);
+	XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
+	XFS_CHECK_SB_OFFSET(sb_meta_uuid,		248);
+	XFS_CHECK_SB_OFFSET(sb_pquotino,		232);
+	XFS_CHECK_SB_OFFSET(sb_qflags,			176);
+	XFS_CHECK_SB_OFFSET(sb_rblocks,			16);
+	XFS_CHECK_SB_OFFSET(sb_rbmblocks,		92);
+	XFS_CHECK_SB_OFFSET(sb_rbmino,			64);
+	XFS_CHECK_SB_OFFSET(sb_rextents,		24);
+	XFS_CHECK_SB_OFFSET(sb_rextsize,		80);
+	XFS_CHECK_SB_OFFSET(sb_rextslog,		125);
+	XFS_CHECK_SB_OFFSET(sb_rootino,			56);
+	XFS_CHECK_SB_OFFSET(sb_rsumino,			72);
+	XFS_CHECK_SB_OFFSET(sb_sectlog,			121);
+	XFS_CHECK_SB_OFFSET(sb_sectsize,		102);
+	XFS_CHECK_SB_OFFSET(sb_shared_vn,		179);
+	XFS_CHECK_SB_OFFSET(sb_spino_align,		228);
+	XFS_CHECK_SB_OFFSET(sb_unit,			184);
+	XFS_CHECK_SB_OFFSET(sb_uquotino,		160);
+	XFS_CHECK_SB_OFFSET(sb_uuid,			32);
+	XFS_CHECK_SB_OFFSET(sb_versionnum,		100);
+	XFS_CHECK_SB_OFFSET(sb_width,			188);
+
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,			128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec_incore,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,			32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,			3);
+	XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,				8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,			64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_commit_range,			88);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_blkinfo,			12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,			16);
+	XFS_CHECK_STRUCT_SIZE(enum xfs_dinode_fmt,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,		6);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,			3);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,			10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
+	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,			112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_resblks,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_growfs_log,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_handle,			24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,		40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_unmount_log_format,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_xmd_log_format,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_xmi_log_format,		88);
 }
 
 #endif /* __XFS_ONDISK_H */
