Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E00021353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424582; cv=none; b=sJ4oXfzInFw61mZcQ4G5g2dCakXcrHZPonpMhclx21R94SpiV6JkGk2aFMFH6sg8nPKwvC46at6POpLJAM2Xf9tD6uXD25JeoS+xGktKm4J7Dxat0fjGJ4zCUD54XRw44Ji6MfnRRC9QlVR0+Mor3Z7xo/uG7neYBNpWkEK4hGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424582; c=relaxed/simple;
	bh=lLHt/K4/ZRG9uKHJcrfcNefJzvzMNLjeXZ2DJ7siW1Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sePLjY4lQobzK2sfcXSBs7zu20zoLTyU4BSio5ti943QSsUC7/AZ6MyQZtcO8vIAH6bGzbfPJKUFE/7veTzdIUX82/PdZSlvLbiFISEXOd+4xeQm1SmW1e664jGvxqIDWV3Jvbuz61PRGYfSetSPAO9/HgfVFogGeVetERo5rHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNyvY2BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNyvY2BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68288C433F1;
	Tue, 26 Mar 2024 03:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424582;
	bh=lLHt/K4/ZRG9uKHJcrfcNefJzvzMNLjeXZ2DJ7siW1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RNyvY2BGsV5cxSyCvzE+2s/xWylBr7+TSyzB4z5MngMllxrGNW7tMdjCzKvHwVh6y
	 k6Tct/9yYkEZVP6W/f82rDzttkJt8bhbRyf9z2sVNgElvdUMJdcHAE1CFAY36zqQAV
	 MXxRHWGuNEsdbs6CcwazFkb+O8wIPDFftceUUAbxKfnTfipWnS9nrOWuecm8qK2cAn
	 is9OSUp94n+Oobiz3rYqs05xaEgbhN8GXlzzKL0cwJW1XN2N8cRsWEH6hpRVAoI1Rs
	 JqpFm2Re1Ne/dlibjtUCHHw7DxfYcXAgkKrhvbCuw/HQ+oMQdP3VPMwJE2to1kvaR2
	 cEh7XhyjkJZIw==
Date: Mon, 25 Mar 2024 20:43:01 -0700
Subject: [PATCH 056/110] xfs: remove xfs_inobt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132190.2215168.6384719854816054858.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6234dee7e6f58676379f3a2d8b0629a6e9a427fd

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h  |    1 +
 libxfs/xfs_ialloc_btree.c |   14 --------------
 libxfs/xfs_ialloc_btree.h |    2 --
 repair/agbtree.c          |    8 +++++---
 4 files changed, 6 insertions(+), 19 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9a2968906c42..2adf20ce8a41 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,6 +147,7 @@
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
 
+#define xfs_inobt_init_cursor		libxfs_inobt_init_cursor
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index aa3f586dab01..6a34de28293b 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -488,20 +488,6 @@ xfs_inobt_init_cursor(
 	return cur;
 }
 
-/* Create an inode btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_inobt_stage_cursor(
-	struct xfs_perag	*pag,
-	struct xbtree_afakeroot	*afake,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new inobt btree root.  Caller is responsible for invalidating
  * and freeing the old btree blocks.
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 3262c3fe5ebe..40f0fc0e8da3 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -48,8 +48,6 @@ struct xfs_perag;
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
-		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/repair/agbtree.c b/repair/agbtree.c
index d5fa4eafb633..22e31c47a827 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -524,8 +524,9 @@ init_ino_cursors(
 			fino_recs++;
 	}
 
-	btr_ino->cur = libxfs_inobt_stage_cursor(pag, &btr_ino->newbt.afake,
+	btr_ino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
 			XFS_BTNUM_INO);
+	libxfs_btree_stage_afakeroot(btr_ino->cur, &btr_ino->newbt.afake);
 
 	btr_ino->bload.get_records = get_inobt_records;
 	btr_ino->bload.claim_block = rebuild_claim_block;
@@ -544,8 +545,9 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_fino);
-	btr_fino->cur = libxfs_inobt_stage_cursor(pag,
-			&btr_fino->newbt.afake, XFS_BTNUM_FINO);
+	btr_fino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
+			XFS_BTNUM_FINO);
+	libxfs_btree_stage_afakeroot(btr_fino->cur, &btr_fino->newbt.afake);
 
 	btr_fino->bload.get_records = get_inobt_records;
 	btr_fino->bload.claim_block = rebuild_claim_block;

