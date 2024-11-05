Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992031CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846528; cv=none; b=j6fYP/n8fRFsizMCNYDLryrgTpHCX2EnltGTYTTQ0fRgS3LonhdNdww9fJ8F61A4L3BKfk3xQVznB72mZDbjWDWDeTLbPK2on4k+vJzZzA4Y2Gk8GompcH/JpmH43L3+Hv5QdlyGdcyMY7AuxUN8kNDiWi721hd656XEc3fVS8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846528; c=relaxed/simple;
	bh=E3ohtq3W305wplGUPuWmCIGv7C93HPjX6xWXa2Gsqa0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtXUo3bEQRHMrguckCsVHy5btEv+1JZlmf9YbqsMY/Kj58w6YtiyL1I6gruGN7rfyUI+nywwT4+SB+0et+JJfS5QYLkHzv2Lz/gxqw7IK0+dLjRKG9VylM4K7GMHabhMKy+eH861f5Pu7o0UZ5kfPgLDoZSaan30nFqaK+fFJOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFmsyKhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFmsyKhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F879C4CECF;
	Tue,  5 Nov 2024 22:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846528;
	bh=E3ohtq3W305wplGUPuWmCIGv7C93HPjX6xWXa2Gsqa0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SFmsyKhORRO7q4Rzoi8RdBKNSnmE42eMSbxTctC5Ug7fEn5TkXWQUuZg3KmLKGS6l
	 d51ojbwZPFJrYAmPd100Zr+iRzjcGe0cq5SXPNuC4fN6lwL3RIVEuJWTw8jypq18aS
	 tkkS5x41ZMV1LAolWWHq/oewMR1W6l2rnWyiG8bpPhJF2Wlg5IuhrAeqd1sUfQEJlY
	 2xB/2RScsDT3yjW6lzG/jVLXa6tT8cg2D/hu8nDsArbUREPYseQiBtlU4djLPRBPej
	 MGvUJcSuXOOQvcpAjW6Ednsiwsyw/leuD4ldxDV9CifQ5VFXOViO78XCEOTonpn8Z8
	 PzpwMRN/2vbGQ==
Date: Tue, 05 Nov 2024 14:42:08 -0800
Subject: [PATCH 1/3] xfs: convert struct typedefs in xfs_ondisk.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400426.1873612.15677824437991872158.stgit@frogsfrogsfrogs>
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

Replace xfs_foo_t with struct xfs_foo where appropriate.  The next patch
will import more checks from xfs/122, and it's easier to automate
deduplication if we don't have to reason about typedefs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ondisk.h |   74 ++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 99eae7f67e961b..98208c8a0d9ed0 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -49,7 +49,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
-	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
@@ -68,10 +68,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
 
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
@@ -79,23 +79,23 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 
 	/*
-	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
-	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment
-	 * we don't check this structure. This can be re-instated when the attr
-	 * definitions are updated to use c99 VLA definitions.
+	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
+	 * it to 4 bytes anyway so it's not obviously a problem.  Hence for the
+	 * moment we don't check this structure. This can be re-instated when
+	 * the attr definitions are updated to use c99 VLA definitions.
 	 *
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,	12);
 	 */
 
 	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
-	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, valuelen,	0);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, namelen,	2);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, nameval,	3);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valueblk,	0);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valuelen,	4);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, namelen,	8);
+	XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, name,	9);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leafblock,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
@@ -103,25 +103,25 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
 	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
-	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
-	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
-	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
-	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
-	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
-	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
-	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
-	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
-	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_blkinfo,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
+	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
+	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
+	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, namelen,	0);
+	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, offset,	1);
+	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, name,	3);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* log structures */

