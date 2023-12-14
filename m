Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ivc8P09n"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A03BA6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F6gqpRQ/QpgLC8y80e1IrbCS6vrNOQLNggsNLrWQAVQ=; b=ivc8P09n6V+PFYNnQDCJHP8tjT
	Fg043bPJMLCflxUDOEVegd4oZzBx22e6nDNYOH9x130jwBPX3TH+UqWpsLJvL+VnmihmeDBkey775
	PJt9Z5IWtPHP+HdK23QcShbXV3Gk2C/vCrYDhbJZYhj6kz9tZFtLmSyDqmm+vCoZrc/oZltqxzgJJ
	/ozcoiWnkzCCxG0bp2qdpwIhUn4tMXMCfUTRF2SbVdsfmAkErxOR94hX4RbiY/iKZ7Z8xopSXrpqh
	7SCQXI7P42gLVThmMbdSuLGxKTuPDGjK3WlN7hM+e/SVCA7znIpxQHImddG217xmoq3m4RoEg97/J
	4ybmAQeQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJG-00GzLz-2r;
	Thu, 14 Dec 2023 06:35:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/19] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
Date: Thu, 14 Dec 2023 07:34:27 +0100
Message-Id: <20231214063438.290538-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
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

