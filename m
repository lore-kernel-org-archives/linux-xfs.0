Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10ABA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295330; cv=none; b=CaJ42tBfPWVARdZop+sPcFP4HIXu41QlxZwJfveWp2e2yhLMjO2a1qoMeCWqvjuJC62B1tPvZiDNFIvIrJ5AhdQ/sV9d2PZLM0yLYNwvz6lFGpCxRE8WYxFMLhB+hq3CtmfwyMnP1jGWnDcVSKOFYL1pX8+OlQ1YJByLKMfoHdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295330; c=relaxed/simple;
	bh=KktIAY77eM8f5+MJtAixwXtf1V7glpRBON4nvIaT+rA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=orPsHxt65HuSSA0ze33cr9ZQPxWWQQnj6WF3EOkU1AoBLdWkxiq7u6OQRAWnF4q8lLEA/h/uw5LFgM0iyTzvxGrqCmBDwd1nZxG/iu1MxxXyyZrLc8up8N7S2j48Vhxu+WSnkP51zwcVrBqpoqZN7Ixi3CYhig8KoCqpgmigmQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzLz4vq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzLz4vq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23909C433F1;
	Wed, 13 Mar 2024 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295330;
	bh=KktIAY77eM8f5+MJtAixwXtf1V7glpRBON4nvIaT+rA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QzLz4vq4RA0V/n9wKC24Uv5MO7lfOt2CzeZjFrve+YIEk5X3IGCu1jd/BpLkWZXcw
	 gXQEN2SxiBEfof/NVZzLD/YDCvLU3repforZmrr2RBquzq4Rr8O/RjePlW41wtZzRK
	 3r+heZOxQUrieuhlBahZWoLn/Asc4SSiUA1+yDi5OSUKxvpMx8IkdU7UFhCPOvXl9r
	 Qpf+NP326yNRiAFm8j9ITSrToPXkI0AfV94I8WiGQIzzVE8zl7zTK4EVls4WUMuzhn
	 XFKV6nS/+uV9MLGevImTTe2fRhIhzjraN4n2v0kkvXEgAQuJl4G2p0/b4WPi+wWaF6
	 PBhm/rs/WSU6w==
Date: Tue, 12 Mar 2024 19:02:09 -0700
Subject: [PATCH 35/67] xfs: repair inode btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431698.2061787.15853543079792941380.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: dbfbf3bdf639a20da7d5fb390cd2e197d25aa418

Use the rmapbt to find inode chunks, query the chunks to compute hole
and free masks, and with that information rebuild the inobt and finobt.
Refer to the case study in
Documentation/filesystems/xfs-online-fsck-design.rst for more details.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c |   31 ++++++++++++++++++-------------
 libxfs/xfs_ialloc.h |    3 ++-
 2 files changed, 20 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 14826280d46e..5ff09c8c9439 100644
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
index fe824bb04a09..f1412183bb44 100644
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

