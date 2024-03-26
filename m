Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9635D129A7C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424237; cv=none; b=l7GohzEGrvOJdK5z2DZ7zgre7o++oZOr3LZ4h9OoV0XRQCDzfIjUbBpI5avkNSR6gwYVMscovmUTaTCcy2EieBybgtvW6/ISYmgidR92gIRN739qfk891iGO0REj0BxVge2fH27y7dQagENMkCq/T+B4LAw3XfhOufWNqphaiSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424237; c=relaxed/simple;
	bh=nzP3Jo/JfNALRpK0HbVKico6WOer2zfFjy0xzUOwU/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAuYcum0WTJzBsEjj+ZXRH4aDRHeDTf4v6K6Q5lscbcAM7PcfmiUanuaJCQc2ddJbOuKa9cl6hAoSnfNeMyaXk71+P6/AV8OVV0mCTRc3MS1hY4Q1c6D/Iup+s/5GY29SThfmqFFQjO17aI+E7ZPKuToPFnR1KgAgYN9xnp5EXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndQXbcHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndQXbcHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5DAC433F1;
	Tue, 26 Mar 2024 03:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424237;
	bh=nzP3Jo/JfNALRpK0HbVKico6WOer2zfFjy0xzUOwU/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ndQXbcHHlRI1ZGn4AijzkpZDrAVvMHEhvzapNRl0CthDk7/IKfql9Uko3rzkbqPSH
	 BDq0bcveVmCtul8N8zbwbziH/o0q/pLgM6+UWsK87GNMtg3CytS/Ppsx9KyEUg7tpN
	 RIl4HRaiii/TZD6qKIh8qLNEoJGumQvkneFhWvzxNBT5KDtQ1b7nVLjWUGNZkw2rkY
	 q1M2sacvfQQbS1+qOrkxGUtnXghMO3Vv7rCb07E9blyAs2FP442gDP0jKBHPHmeFvP
	 6xX2rMJ8HEg5rNhWzuuzp1StfEXDN7Ei38qEbHU3gtsZ/UxzmhOI7pgz6cQtrCs2EJ
	 jB+/Uf2tO586Q==
Date: Mon, 25 Mar 2024 20:37:16 -0700
Subject: [PATCH 034/110] xfs: consolidate the xfs_alloc_lookup_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131874.2215168.2036413680962712282.stgit@frogsfrogsfrogs>
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
index 3d7686eadab2..45843616647d 100644
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

