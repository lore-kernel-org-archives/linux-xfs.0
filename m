Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A86FA4
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Umg/7TsJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h2F8OnVs6GqMlUzVOFort8Imc4dYf60IXkKZGlxmu/o=; b=Umg/7TsJjsqt5fLl+8OLS5/HFw
	QcGFewR6SyhTP6F+dieXV3X81xUuZTtlH/IB5RWRlwzWbFxCkwyCuM5B1lePmVvshI76WffkURJGd
	tqpo0CznzQb55VRAUZO6fKQ5Adp0Yz9QUqOOket53ihhP6mkUpC9FNZwZLEzLcCAdMG1yJmfmeb2Q
	BB9J3ED2CLeRKA9u/tqwEs/nWc7/C8ci+sJE3ZgfgstJRCOAIZIBgxGd+53OkOTEuKIwZC6S+IKE3
	ftyaV4OgEQ/DN4oB+sEwnwHbasBCR76UHdb8DLJ4nSE+MPczjAmrHSeejsh4gyndCO0iDx74tN3uk
	1fM3krUw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hY-00959l-2I;
	Mon, 18 Dec 2023 04:58:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/22] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
Date: Mon, 18 Dec 2023 05:57:24 +0100
Message-Id: <20231218045738.711465-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a return value to xfs_bmap_adjacent to indicate if it did change
ap->blkno or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 ++++++++++++++-----
 fs/xfs/xfs_bmap_util.h   |  2 +-
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6722205949ad4c..46a9b22a3733e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3044,7 +3044,8 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-void
+/* returns true if ap->blkno was modified */
+bool
 xfs_bmap_adjacent(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
@@ -3079,13 +3080,14 @@ xfs_bmap_adjacent(
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
@@ -3165,14 +3167,21 @@ xfs_bmap_adjacent(
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
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 6888078f5c31e0..77ecbb753ef207 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -47,7 +47,7 @@ int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
 			       int rt, int eof, int delay, int convert,
 			       xfs_fileoff_t *offp, xfs_extlen_t *lenp);
-void	xfs_bmap_adjacent(struct xfs_bmalloca *ap);
+bool	xfs_bmap_adjacent(struct xfs_bmalloca *ap);
 int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 			     int whichfork, struct xfs_bmbt_irec *rec,
 			     int *is_empty);
-- 
2.39.2

