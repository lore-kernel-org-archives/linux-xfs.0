Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939315381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804022; cv=none; b=OynzbXRPvNHbqvvOxILcAY8hWbKVeJlzTivjUW3qO1tlR1j8kjTctTDHN7x+O2qX7jf498/fehhsjksZffna2D2FzJfEIEAMBam8pqDBQtj3ZqYDE+rAdfAhEIfxo2VbULUwVZh2ecNeMwWnbHRjHzo3qzyCwtn4Qzi1C/QxwBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804022; c=relaxed/simple;
	bh=P54o824N1PjamxFOK4ata08tWArrCHw6v+E6IyhbzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blJGg8h6U6n0Tid5JMuQPjJ3yolg9KLxiZVumwziNkEIOD9ESzuJhGDk0Njtbuqiw9wmjVZr7su5G/mjdQAv1LPGcIPFoJ4xhstKK9Q6R3MkvYmh0CpOkQzMzrGXPdK6RLOtd1rSMJTesP7SXF11LP27fmNaQq5UrnH+0XKxrqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSjkTlEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSjkTlEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B56C116B1;
	Mon, 22 Apr 2024 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804022;
	bh=P54o824N1PjamxFOK4ata08tWArrCHw6v+E6IyhbzSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSjkTlEA/qhybr8VRy46HMduht8FHONuIoJBifzOLTGOFhd/hMNzxa6vMgZ2H/7OX
	 2fI79P9AdfTFz4nG+fhv/uK+pqLzjgPLGBG2YL/Y9mZ0efVlkCoz8Xa+xZd+no5ZFO
	 CrOMfWpzf57TLsn6/hDloKxBBYm9FaTDPefCYP2778zJNeG6YCLEmHUdvuFM0iwBwT
	 T3Wg42FDXY29dut9jZ+XWS/YCafeMzXHXZeKiHqA6GILdAU257bvKZp8gh38cKFEG2
	 j0/bQHRj/y4IwGUxBCvTGYftTCF2mYRvFsFWv9D0+hUzts//TzQPz9WrmB+ZuKKNWe
	 tj70UxSRbtIVA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 49/67] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
Date: Mon, 22 Apr 2024 18:26:11 +0200
Message-ID: <20240422163832.858420-51-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 676544c27e710aee7f8357f57abd348d98b1ccd4

Add a return value to xfs_bmap_adjacent to indicate if it did change
ap->blkno or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_priv.h |  2 +-
 libxfs/xfs_bmap.c    | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 3ba6b0e55..ae01b076c 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -568,7 +568,7 @@ int xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			   struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
 			   int rt, int eof, int delay, int convert,
 			   xfs_fileoff_t *offp, xfs_extlen_t *lenp);
-void xfs_bmap_adjacent(struct xfs_bmalloca *ap);
+bool xfs_bmap_adjacent(struct xfs_bmalloca *ap);
 int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 			 int whichfork, struct xfs_bmbt_irec *rec,
 			 int *is_empty);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4f6bd8dff..b977032d8 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3038,7 +3038,8 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-void
+/* returns true if ap->blkno was modified */
+bool
 xfs_bmap_adjacent(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
@@ -3073,13 +3074,14 @@ xfs_bmap_adjacent(
 		if (adjust &&
 		    ISVALID(ap->blkno + adjust, ap->prev.br_startblock))
 			ap->blkno += adjust;
+		return true;
 	}
 	/*
 	 * If not at eof, then compare the two neighbor blocks.
 	 * Figure out whether either one gives us a good starting point,
 	 * and pick the better one.
 	 */
-	else if (!ap->eof) {
+	if (!ap->eof) {
 		xfs_fsblock_t	gotbno;		/* right side block number */
 		xfs_fsblock_t	gotdiff=0;	/* right side difference */
 		xfs_fsblock_t	prevbno;	/* left side block number */
@@ -3159,14 +3161,21 @@ xfs_bmap_adjacent(
 		 * If both valid, pick the better one, else the only good
 		 * one, else ap->blkno is already set (to 0 or the inode block).
 		 */
-		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK)
+		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK) {
 			ap->blkno = prevdiff <= gotdiff ? prevbno : gotbno;
-		else if (prevbno != NULLFSBLOCK)
+			return true;
+		}
+		if (prevbno != NULLFSBLOCK) {
 			ap->blkno = prevbno;
-		else if (gotbno != NULLFSBLOCK)
+			return true;
+		}
+		if (gotbno != NULLFSBLOCK) {
 			ap->blkno = gotbno;
+			return true;
+		}
 	}
 #undef ISVALID
+	return false;
 }
 
 int
-- 
2.44.0

