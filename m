Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A161747F7C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389674; cv=none; b=XrSs26Zjj/M2mH3c65XeN96KvHY3x+LABDxkkVaoYLOoOVSSaUa3Yb4TzKVv9G1kHCt5QU5/4zmmY/PmHC0PQxqnP9FmKWLp3JQtWMnUk78+i+hc+m3huT+iL2Av03K0bNebagcGl7s7JfN/kZmSCSIxePn/qTlr5WtLFnia8Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389674; c=relaxed/simple;
	bh=Batcmwd6NHF1qzs4ArLisAv0FuXjeo9TNXta5nPoFi8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvWjs6gjUUpZGkKfuBR4QonphyH5qk7JGrsxCeZUvcFgDVRVl1J1D9+gk+whaY+qIpkmBIdm8NaCiwRA5U8TSDonQ65VjB0k88NAO9xTHE3kkgVRUT8t/c57g3WOp0KXCAjLA2+1aDVHAIo4+UgeiA019pdAPQGAgdSjjTFRDaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxdtv3ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxdtv3ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C45C072AA;
	Wed, 17 Apr 2024 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389674;
	bh=Batcmwd6NHF1qzs4ArLisAv0FuXjeo9TNXta5nPoFi8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nxdtv3ke80Ml6xJ/o7bmkczune9ivz8rTrnBKWgzVSMTZuqbZ37oveY7jTixU2aSd
	 rolHtfa9XnbyVdqcnGTpWtKTCGV8NDaYMN0XWU7+c8FYLmPAcWcK+BBonDAvs5J4YV
	 CzkcqqFLcDC7pOpIwioJAEMkImkhGdOdDoZaU/9AIXWJpVHAspeZGLEj8Uhd61OQD5
	 MlvcfNJcY5aUnCqzbP33LGvZOvQ9tIXIrCgIUXzfIyyH6jEAzUkp6lhBJ0UaMSlP24
	 /vb6rty3mu+3xIRsTgFXa9z2HKpXsrJRLz0JBNOvBfowGBHZNVdmQ1a8IqtKqsQrgE
	 PJ4vn0ky1r9dQ==
Date: Wed, 17 Apr 2024 14:34:33 -0700
Subject: [PATCH 49/67] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843075.1853449.12045956383522964085.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 676544c27e710aee7f8357f57abd348d98b1ccd4

Add a return value to xfs_bmap_adjacent to indicate if it did change
ap->blkno or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/libxfs_priv.h |    2 +-
 libxfs/xfs_bmap.c    |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 28ee19250..705b66bed 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -565,7 +565,7 @@ int xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
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

