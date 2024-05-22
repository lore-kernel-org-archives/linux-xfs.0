Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061061DFD0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346659; cv=none; b=ODAxf3H8peVJnD/hF7xFiZf3QPP//a5ZkWLY8fRS0WA4V33rceWzQPEvaUbCGGosvB6/JLiYrlQEmeRQidG+Csns7ulh3oV0hgs6WFdBZWh/8lO/zyF79KDWvHsC1qeDI1sKx6A+xRhwPESdzA8TsGi/WNRbMdYeor2kgih0ggg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346659; c=relaxed/simple;
	bh=K+ZPeg1tTMykCsMegqzonbFOa8oJmC8QJJmq0rRPiqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJUrnOsrjzLvdBKSp8R8glAJICYowzA/CYRnnwfnfk4C2Z5jSmuEjZZOH+WQOzU2Z1Wz2yZvfcyI8ViLsut250XD/EWGrWQXenbIW0qXpfrnSPewtVUGx5RVdB0HwIEUZX3N0hTgk9Ak6MsNfFjvznloPbBjslLmeyHkucOnCGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ornf+rDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ornf+rDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB1CC2BD11;
	Wed, 22 May 2024 02:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346658;
	bh=K+ZPeg1tTMykCsMegqzonbFOa8oJmC8QJJmq0rRPiqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ornf+rDzqngbLMLTdZCyM5wy2kuN+/1j4gFHLF4t7NWJzibYXuE3/Z93PV4EKM+fM
	 mJ45norzp2rHVq6LZm4SJbg72VaZ9IEmpUgDGgaymALoqbwJDb4OprwBBskVi2g2ER
	 Tu2DsNqFVZxUWW01CyYGZf/Kar3LINauqGgUCZuY60aYdoIYW0i2iuUc66T8K1UpbB
	 K6kyQ+Bl8Fp7yg7lEv3Xu/iheoiungLX1vxFbb4tX7XmLMZU73of9sB859ZWY9N95D
	 GZ3RY8jnol8xATBkrlE4zY9ES1es///7KTzBajEZ/0hnU9GjNrLpSi/uPkwIVmyOQI
	 RHtYoyJhUYofA==
Date: Tue, 21 May 2024 19:57:38 -0700
Subject: [PATCH 034/111] xfs: consolidate the xfs_alloc_lookup_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532222.2478931.8186703878688955256.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 73a8fd93c421c4a6ac2c581c4d3478d3d68a0def

Add a single xfs_alloc_lookup helper to sort out the argument passing and
setting of the active flag instead of duplicating the logic three times.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3d7686ead..458436166 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -147,23 +147,35 @@ xfs_alloc_ag_max_usable(
 	return mp->m_sb.sb_agblocks - blocks;
 }
 
+
+static int
+xfs_alloc_lookup(
+	struct xfs_btree_cur	*cur,
+	xfs_lookup_t		dir,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	int			*stat)
+{
+	int			error;
+
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	error = xfs_btree_lookup(cur, dir, stat);
+	cur->bc_ag.abt.active = (*stat == 1);
+	return error;
+}
+
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
-STATIC int				/* error */
+static inline int				/* error */
 xfs_alloc_lookup_eq(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_EQ, bno, len, stat);
 }
 
 /*
@@ -177,13 +189,7 @@ xfs_alloc_lookup_ge(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_GE, bno, len, stat);
 }
 
 /*
@@ -197,12 +203,7 @@ xfs_alloc_lookup_le(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_LE, bno, len, stat);
 }
 
 static inline bool

