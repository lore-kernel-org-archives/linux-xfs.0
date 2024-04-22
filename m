Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C4515530C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804002; cv=none; b=EhzmOjtz5GgZpIs24SCLynYg418yZxMoNnolrxkpglpBX5yY6gkkRTW+eatG29i1X3fvyF7irZhNRHbdpL5Bwl3WoiMF/+MMlkQBPHJjQFYvVoW3R5LylkdUzSyLra1vka4qpnNVmavPeAfyu+RVF6BJSYjxO56DR7sn1DudQf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804002; c=relaxed/simple;
	bh=gm6AxcRc8hnyA/NI+z6ayH9dKLueLSB1MyhG12tWfFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3jHv4D6XvOJm3P9vsGW6HVcinmWs8YxuCI2O/kvjNq51v+n1yRBHCNSidjz8Pm6f0Z47Czg7kZMyazyk+u8yCC7C6jfMST0wRyg9SxepnJPgesmGG25yMQZb82cHBsR6CcwYV86jP3uE/nTU45CvFurTYe0l7bJSXKYMGPxh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roPZlkw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roPZlkw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E349C116B1;
	Mon, 22 Apr 2024 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804001;
	bh=gm6AxcRc8hnyA/NI+z6ayH9dKLueLSB1MyhG12tWfFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roPZlkw//nTb7FF568Cz2WsrRmcy6QBg8CKnj5HkG6MT1u4lbnvyFFrui41TLbHjO
	 W2rPkMLZH1kSfOskNkDg0GyXAa5V7Ue+pQA17WvO91SJ/LhJGGgR25ddxgZVuh5NNr
	 94xKUkMHV/qDdV7ia8FF/i9t9O7e0lgiJ7JPi7Yv1D3rCPo18BfLL2j6mZW5JvMwMW
	 3J3qCvBQ9SFQHLdO57TvSbwwK1vu9H3WHFWcMNla5cQOmTVgGiTnwyUuHmNdUPjBEp
	 0jW4fpyattujuTgIj5uIGRrODzH0AB7XdX//K7XxWtktNhQWPN8QHO8XbPKHwxrHM5
	 3auPYkniwt1LQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 35/67] xfs: repair inode btrees
Date: Mon, 22 Apr 2024 18:25:57 +0200
Message-ID: <20240422163832.858420-37-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: dbfbf3bdf639a20da7d5fb390cd2e197d25aa418

Use the rmapbt to find inode chunks, query the chunks to compute hole
and free masks, and with that information rebuild the inobt and finobt.
Refer to the case study in
Documentation/filesystems/xfs-online-fsck-design.rst for more details.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c | 31 ++++++++++++++++++-------------
 libxfs/xfs_ialloc.h |  3 ++-
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 14826280d..5ff09c8c9 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -90,18 +90,28 @@ xfs_inobt_btrec_to_irec(
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 }
 
+/* Compute the freecount of an incore inode record. */
+uint8_t
+xfs_inobt_rec_freecount(
+	const struct xfs_inobt_rec_incore	*irec)
+{
+	uint64_t				realfree = irec->ir_free;
+
+	if (xfs_inobt_issparse(irec->ir_holemask))
+		realfree &= xfs_inobt_irec_to_allocmask(irec);
+	return hweight64(realfree);
+}
+
 /* Simple checks for inode records. */
 xfs_failaddr_t
 xfs_inobt_check_irec(
-	struct xfs_btree_cur			*cur,
+	struct xfs_perag			*pag,
 	const struct xfs_inobt_rec_incore	*irec)
 {
-	uint64_t			realfree;
-
 	/* Record has to be properly aligned within the AG. */
-	if (!xfs_verify_agino(cur->bc_ag.pag, irec->ir_startino))
+	if (!xfs_verify_agino(pag, irec->ir_startino))
 		return __this_address;
-	if (!xfs_verify_agino(cur->bc_ag.pag,
+	if (!xfs_verify_agino(pag,
 				irec->ir_startino + XFS_INODES_PER_CHUNK - 1))
 		return __this_address;
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
@@ -110,12 +120,7 @@ xfs_inobt_check_irec(
 	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
 		return __this_address;
 
-	/* if there are no holes, return the first available offset */
-	if (!xfs_inobt_issparse(irec->ir_holemask))
-		realfree = irec->ir_free;
-	else
-		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
-	if (hweight64(realfree) != irec->ir_freecount)
+	if (xfs_inobt_rec_freecount(irec) != irec->ir_freecount)
 		return __this_address;
 
 	return NULL;
@@ -159,7 +164,7 @@ xfs_inobt_get_rec(
 		return error;
 
 	xfs_inobt_btrec_to_irec(mp, rec, irec);
-	fa = xfs_inobt_check_irec(cur, irec);
+	fa = xfs_inobt_check_irec(cur->bc_ag.pag, irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, irec);
 
@@ -2735,7 +2740,7 @@ xfs_ialloc_count_inodes_rec(
 	xfs_failaddr_t			fa;
 
 	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
-	fa = xfs_inobt_check_irec(cur, &irec);
+	fa = xfs_inobt_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index fe824bb04..f1412183b 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -79,6 +79,7 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
  */
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
+uint8_t xfs_inobt_rec_freecount(const struct xfs_inobt_rec_incore *irec);
 
 /*
  * Inode chunk initialisation routine
@@ -93,7 +94,7 @@ union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
 		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
-xfs_failaddr_t xfs_inobt_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_inobt_check_irec(struct xfs_perag *pag,
 		const struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len,
-- 
2.44.0

