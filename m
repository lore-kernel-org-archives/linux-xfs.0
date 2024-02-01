Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A784FCC
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816506; cv=none; b=MIr2lMQH6g/wSxYBEOeyVQyIHjtstC9TZ4gBRgnORuM1+1g9mctrCo/dPadoMungymA6Vd8Ee0sC2ABLvrpfGUbPMtVuzGHnqlhSqwmAgttE/9TelkunHZVo/t4wmve/aYfqn1BJUN5eG0pHXeYs0hR5s71rQop1N/FXHcuzD0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816506; c=relaxed/simple;
	bh=gTiVtaPSQeumtmIvwIwBRQNDcBuWhNRCcruX9iEXur8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+IgN5BAvr0U4Cd9hTv8AKYinnG7ef7EG+DXe9a/h9iZ6VVHqnlkSqnKFkrZP9JjkCLcsf2Z5nWyFZymAKqeXwn19fdfK5Rf213jTF9EOOETZXO24mDDcdmETMIYlkW+vK5K6I3Oahqtf136WyYah5NOlSwlFAhogQikBWD7ij8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ch1l9Weo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ch1l9Weo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16DDC433C7;
	Thu,  1 Feb 2024 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816505;
	bh=gTiVtaPSQeumtmIvwIwBRQNDcBuWhNRCcruX9iEXur8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ch1l9Weo3YxoZd++u4uoUSgVHBk5NUOHIPcWESFNFw8dzS3I8fo13KCUL1PuveMg/
	 kwlsEFIx+XFB+AQ0OzCsGUypAAtnFheVrZb6T3lpWAnh1ji/WnLfzcG7ezzIUiUdci
	 4w1DwchKXR6np7vAxxlm9j7SwydSXvnPCwQ1IZ9Zh9jYt00BE/ZXMiDGATpRA8WFbq
	 +pueRGJ2apH325i1jXOw2k1R1VZovAx5YcJYyV6bQDBeoWfiLYBFdej3vc3TPSgLUN
	 h0Q8dYk10ucZT/0YSl+6//y2+l+wuhJ+nLJo+XIB+fO1pKXhNKvs/PEABk7eGWoqlH
	 fW9ysbFh3urfw==
Date: Thu, 01 Feb 2024 11:41:45 -0800
Subject: [PATCH 08/23] xfs: consolidate the xfs_alloc_lookup_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334069.1604831.7076286382782728966.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Add a single xfs_alloc_lookup helper to sort out the argument passing and
setting of the active flag instead of duplicating the logic three times.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ac31b62e70177..a40a5e43e94c8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -151,23 +151,35 @@ xfs_alloc_ag_max_usable(
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
@@ -181,13 +193,7 @@ xfs_alloc_lookup_ge(
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
@@ -201,12 +207,7 @@ xfs_alloc_lookup_le(
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

