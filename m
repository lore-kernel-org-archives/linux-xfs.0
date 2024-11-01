Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D91BDC3
	for <linux-xfs@vger.kernel.org>; Fri,  1 Nov 2024 22:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730499515; cv=none; b=MeJdygvQto8+cyXW8wRLFsy29l44w4FbDcAmiJpGY/3bn92ySNEV27hoSJKO2V3TKphVspCk0tRwx/4AZMBjqWJektQThyHxkrNLcMyaEatEPnc9p3rStDu1tCYlna1CuhnhQCxGwxkZ/kPGljYbCXyiYl80mtzuS4tA5pHL+qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730499515; c=relaxed/simple;
	bh=mlpJkcrdO9fDwYScAWjKt18Kc1D8sxv2LoF1BOxGL1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3T+vmG+NQBrsSS71yh5nNfGscEDRABfN92Pm6TonSF3G28h1kYA+UKZESVH9AV96WtMyfc6SsOlmsih+RxwLzVul6+iE4j9A69GjZSQ34918qom9JmP5gUmA9Agp2BxpwE7XZZTUJkP6GrCkwRRhmcLQHA9LPdPTuXLbmfmU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4FDeDEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4FDeDEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD6CC4CECD;
	Fri,  1 Nov 2024 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730499514;
	bh=mlpJkcrdO9fDwYScAWjKt18Kc1D8sxv2LoF1BOxGL1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4FDeDEMgP810+oOkxJTk3aIbJQxr0I5EizXBEZjfiFAggTlfj2rM4qNfwv6kWrix
	 +fLGcft2ZHdTtm5fgElQNl1ZDHftIu3nugRnZwVCzLZQ26h5OA3dF4uYZd1BMKUj1d
	 wLu20NI5jE40zmGEYIueuWM8CSthS9M1ByOE/9D9rLB2bpL8208b5Ghxgs7R3849xu
	 0xHQ8r0Ey+3fd6s1DX8d+GvdHGvWRXYJ2zC1OiyNHigLUtuk543nsfiuWYZRKWYXxc
	 b9xkJ4n2ndSydI60nCWfGmLVoFA1m+kH5xUfmRR3vszKubyWr2AVFPcVgZMM81S1iN
	 3/6m7bDw0EVnw==
Date: Fri, 01 Nov 2024 15:18:34 -0700
Subject: [PATCH 1/3] xfs: convert struct typedefs in xfs_ondisk.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Message-ID: <173049942768.1909552.16910486013106825236.stgit@frogsfrogsfrogs>
In-Reply-To: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
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

