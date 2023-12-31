Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE0C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ks7FEYZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2DAC433C8;
	Sun, 31 Dec 2023 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061326;
	bh=GarnTWWkz/IFGJEcYxfjluoQeepfydy66BkeKKk0/Rk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ks7FEYZ3ZpCdGZb1AKS+TaCWO8558OZEkLhQqscRxGoKBz6XMY58ooffHWU/O2Iu3
	 sZyzCOXEDN5ASWmNz8YCLXhQ60UCt/KbnkWV6u7wOsYHX+Lff4CevstkgqiRzw5b9j
	 NMbv0UlEQS86UnBttBAT0wSKgbFdVfzZ/Gxzfi9/ear5cAn8U5BK4Z2x0bD+UMiGoM
	 kyFknSzH8Z1EZ7QxFFdzGskwd3pwHmzJ24e+3YuSz20rB9EwLkTgtBC3YPgMfLdWxw
	 fDcTuBJjI8iGynK/o5BoLjLpxNf6NREkRmN3YRpw1SszUXHOWQ3dRYRzw/AoNIQRHV
	 /eTm8QlLU7Txg==
Date: Sun, 31 Dec 2023 14:22:06 -0800
Subject: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994110.1795132.12835250791258551159.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
References: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove these fields now that we get all the info we need from the btree
ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c        |    4 ++--
 libxfs/xfs_btree_mem.h  |    9 ---------
 libxfs/xfs_rmap_btree.c |    1 -
 3 files changed, 2 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index d76b3d5ea70..b4762393b3a 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -370,7 +370,7 @@ xfbtree_rec_bytes(
 {
 	unsigned int			blocklen = xfo_to_b(1);
 
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS) {
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_has_crc(mp))
 			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
 
@@ -464,7 +464,7 @@ xfbtree_create(
 		goto err_buftarg;
 
 	/* Set up min/maxrecs for this btree. */
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
 		keyptr_len += sizeof(__be64);
 	else
 		keyptr_len += sizeof(__be32);
diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
index 29f97c50304..1f961f3f554 100644
--- a/libxfs/xfs_btree_mem.h
+++ b/libxfs/xfs_btree_mem.h
@@ -17,17 +17,8 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
-
-	/* Btree type number */
-	xfs_btnum_t			btnum;
-
-	/* XFBTREE_CREATE_* flags */
-	unsigned int			flags;
 };
 
-/* btree has long pointers */
-#define XFBTREE_CREATE_LONG_PTRS	(1U << 0)
-
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f1325586433..e36237bf750 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -667,7 +667,6 @@ xfs_rmapbt_mem_create(
 	struct xfbtree_config	cfg = {
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
-		.btnum		= XFS_BTNUM_RMAP,
 		.owner		= agno,
 	};
 

