Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E434C1BDC3
	for <linux-xfs@vger.kernel.org>; Fri,  1 Nov 2024 22:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730499531; cv=none; b=YNMPsfe3Ls6T5d/D5uixjl/yj7mVACMthCRPQTPdo49LJmT7gty43OeNkUkljOEOM7tbgGOBEtll3a7nikyekEiOkfz0irObDR29a2a+DJSHJTGQ8yNZNgIoNgOneqQPVY11oR1svBQ8HJV01i6r1VKX16oxx2rn74wGYA3noe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730499531; c=relaxed/simple;
	bh=UlyhZBDWikgi6BGYEBgoFMtK8gmn8aG367ZyVH1ZY0w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i5qkdLbpplXdfSa9UNzMiITMwqNZzUG95CY8iMq9ZqE2sdv4BW732PRTcTHiWKo3oju0/ujK2mcF7IM0hDvhoW5RAzkmYa7C6SUuYldiq3fPyvPp3p5dqd0ig8d1HPHL2Ewnkv7HgE1+Nodsc5+o6+dQ0kW+YZUwz6a+7zh0DBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUuvLIiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUuvLIiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7794FC4CECD;
	Fri,  1 Nov 2024 22:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730499530;
	bh=UlyhZBDWikgi6BGYEBgoFMtK8gmn8aG367ZyVH1ZY0w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XUuvLIiWEMI8j84bOMcEP+prJ/kInKur2aAqrZmZgn2ENzGCOvdJ9IOIEnHWAYu4Y
	 cXBFgJB+JQF+2498RHyFrrrMn+OnmmQWok26PExWsfXzZ32/XVeJOs4gJbqnriHSXm
	 gylEOOA1WL5Vo9wWu3d50fKxk5h04PQKmli8AQjxGoVzNC9MHMfCQWJaw3/Nnl4zFG
	 07k9PJVhkIz/3e5JVNnD6/tI/6Zl+SdWWIT/oBWeTvM+hwtAa5TZPD4v78z924BGs1
	 loJ+hcyEZfuZLWeEGKBLITlIz7ssj5Wuz13TJsxuM4ycss554w1fu5wb2+Y1sqQ79f
	 Z3/mwdolhpEaw==
Date: Fri, 01 Nov 2024 15:18:50 -0700
Subject: [PATCH 2/3] xfs: separate space btree structures in xfs_ondisk.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Message-ID: <173049942785.1909552.1399958870612921080.stgit@frogsfrogsfrogs>
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

Create a separate section for space management btrees so that they're
not mixed in with file structures.  Ignore the dsb stuff sprinkled
around for now, because we'll deal with that in a subsequent patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

