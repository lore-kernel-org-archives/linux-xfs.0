Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352BF1CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846544; cv=none; b=jPp/6HlPsWE7VVmFVlAa4wQhhTjVMNID6dcNbJc5gy2+bKSAChysgxd1bqqNNduQQ4IPamU3CJLK/m+2vO9FUytyj+Jhuxdc6lYFlAUw2Rl2N0rkFfmOwiEeKRdRv/llzJK/dxdPN2MEUFC+tI+wQrmGuyKU3iBir2NSnYwFfhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846544; c=relaxed/simple;
	bh=KGsb4lOSIkdr0ORSwhT59YSmzKuIL9B4dZ9itK5m6nI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EAJDc2p81kml+Wza01hRJzLqTdOQrOGe3acmLNDV1TQRTiA09GUrutrji5hXcYRcPlUKpigTqbVfeR+pBR6ulTj2X4B++0F8fg3cHEAxDMPRafiZ+4azKiD69HRE5ilcv3pYNs7MTUUf9h7ghXgDRPdLbwXSvL60vFnpCR/ieiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2ZVLSxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2ZVLSxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE10C4CECF;
	Tue,  5 Nov 2024 22:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846544;
	bh=KGsb4lOSIkdr0ORSwhT59YSmzKuIL9B4dZ9itK5m6nI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2ZVLSxrERdkyf6tjf99e8g7SqZZvSJr1/Q4NrNPWaKoAYdgvMpEwPG+3QqDZkRXm
	 59KhWNyVz5Dlaoru2K1LhC4JaQD2E0DMw7xUicPPQM5V+wZwCXAhTloaGXQYIs5dkq
	 sgEH/LG08ihL8Of0hHGgGcnJLY0Sd4lwS1Vix0N8D6Ek407M1N2IGV1lGlF/7yw+As
	 EziK5d3pqfYbGWUjwFXLduS1wvpHB008zvNo1xQL+0Ih4IHYf72FEqw4qIxb+pVeuT
	 Q5E073XJb3iPVyeJ3bgf2VYONuBU/LDkSuVCCJEjloVrPYb/TKHu/Ve48VDC+nMSpl
	 +edGjFOLLvA2g==
Date: Tue, 05 Nov 2024 14:42:23 -0800
Subject: [PATCH 2/3] xfs: separate space btree structures in xfs_ondisk.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400443.1873612.9132705124312264091.stgit@frogsfrogsfrogs>
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

Create a separate section for space management btrees so that they're
not mixed in with file structures.  Ignore the dsb stuff sprinkled
around for now, because we'll deal with that in a subsequent patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ondisk.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 98208c8a0d9ed0..7b7c3d6d0d62d9 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
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

