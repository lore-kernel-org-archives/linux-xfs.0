Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01EE13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991750; cv=none; b=Fc1/CoDz8FmNFkxsxtipSE90NYXU5f0PFSL1778ASYzDGZctgEMTt/FEQn/b+FIP/VV1AlXpq6vBgjjTHOPgVsx4oTack/oG9LAharaNUoTfPUh42XTkmeyT5PTrQ5SmFJ5yWcEbz8bn+yZkkdo/Q8NxH0pJIegxs08KFTDNI6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991750; c=relaxed/simple;
	bh=1D7tfXE7JuxvVxl+c+fFqdCW2Rap+UMhirKdMShco6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lt5E1LIHK3dBZGOrnMp9nRSGvXsKuc6182y648szZ3VuYVLtqzBt3MbJrXFddiJ8OXQoKmII/9RediBQGu5IwBAe0Do+XKbZ/v7bt0TGX2UiLUZdPs3qyW6MDyloIfSWaf2xd5TobbIg4hWsBD0SP1x8JG9sldO2VigoJfduiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsAlmsrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsAlmsrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B58C4CED3;
	Mon, 23 Dec 2024 22:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991750;
	bh=1D7tfXE7JuxvVxl+c+fFqdCW2Rap+UMhirKdMShco6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AsAlmsrjkrMGjwaC94B+Cy45iCWZvyjLmOfwgh5rXsV63lzhkn63vee5+i1VjtxTE
	 x/wDDbvNv2aeenB1mxEMjvkS3ZMJTzEEey5XYFm8YWgqcI97I7NRW8jJDNmN7Jx6LR
	 3afD2E6X7LQ29/vct2gvxxM6ElyqNfwyLESnPYwgs5ZctRPqKZuxZdfifS9P3RqPpU
	 LR/POPXKSpzzvcjbnvbmFFrl5OhAOOg1Ft4xNKog7eNk1qIBueE+eInG4e39exUWwO
	 OH6jg++Vmw/jiqMou26OUJvnrLLp/YdfyH11vQczvbqTJw9E3cK9Ey1hjjclVpblgL
	 g9zXxUEPTehTg==
Date: Mon, 23 Dec 2024 14:09:10 -0800
Subject: [PATCH 42/52] xfs: separate space btree structures in xfs_ondisk.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943134.2295836.15611579694941156621.stgit@frogsfrogsfrogs>
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

Source kernel commit: 131a883fffb1a194957dc0e400d9f627c7cd1924

Create a separate section for space management btrees so that they're
not mixed in with file structures.  Ignore the dsb stuff sprinkled
around for now, because we'll deal with that in a subsequent patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ondisk.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 98208c8a0d9ed0..7b7c3d6d0d62d9 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -22,38 +22,39 @@
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
-	/* ag/file structures */
+	/* file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			288);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
+
+	/* space btrees */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
-	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			56);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
@@ -74,6 +75,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
 
 	/* realtime structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			56);
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);

