Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kz+JTwD3"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72714F4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QSwcZE1unIGlvyZL+bB0IhyrESYPqj44hIlYqUw7BGY=; b=kz+JTwD3SDgzR4EnjfPS6eTHgy
	gJEiHyyQMc8qsj+lNqVHfVOu0sO3ypsLCUouWSAIGC9fJfpB5o/PIhxlLi5UMdyMW4V0mqGni8rNH
	0GSPqe4TZIE1zKXzSUHoSLGgzNrta+8ZUVbU5Jn45eT0rJ89CmNbBSnFxMQvo8tGht6YLRqEzrejS
	q6NY8AJI5FkUSLa0nfAGESI8IGeRRF2ezuKvzmCjGQp1VZu3I7Ik0Bv11dVzMRgIAeDKoHRNE1VNz
	T6HkHT507Vfw38wfdih45iACV6dVmXfIYnmKnWN6+CmsCn8AU+q4U9TCHaA9YaynpPwxSltRpQhoT
	zL/ss5XA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJ6-00GzK3-0p;
	Thu, 14 Dec 2023 06:34:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/19] xfs: also use xfs_bmap_btalloc_accounting for RT allocations
Date: Thu, 14 Dec 2023 07:34:23 +0100
Message-Id: <20231214063438.290538-5-hch@lst.de>
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

Make xfs_bmap_btalloc_accounting more generic by handling the RT quota
reservations and then also use it from xfs_bmap_rtalloc instead of
open coding the accounting logic there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 21 ++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.h |  2 ++
 fs/xfs/xfs_bmap_util.c   | 12 +-----------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index afdfb3455d9ebe..6722205949ad4c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3263,10 +3263,14 @@ xfs_bmap_btalloc_select_lengths(
 }
 
 /* Update all inode and quota accounting for the allocation we just did. */
-static void
-xfs_bmap_btalloc_accounting(
+void
+xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
+	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
+					(ap->flags & XFS_BMAPI_ATTRFORK);
+	uint			fld;
+
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
 		 * COW fork blocks are in-core only and thus are treated as
@@ -3291,7 +3295,8 @@ xfs_bmap_btalloc_accounting(
 		 * to that of a delalloc extent.
 		 */
 		ap->ip->i_delayed_blks += ap->length;
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, isrt ?
+				XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
 				-(long)ap->length);
 		return;
 	}
@@ -3302,10 +3307,12 @@ xfs_bmap_btalloc_accounting(
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
 		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
+	} else {
+		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 	}
-	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		ap->length);
+
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, fld, ap->length);
 }
 
 static int
@@ -3379,7 +3386,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap);
+	xfs_bmap_alloc_account(ap);
 }
 
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e33470e39728d5..cb86f3d15abe9f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -116,6 +116,8 @@ static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
 	return XFS_DATA_FORK;
 }
 
+void xfs_bmap_alloc_account(struct xfs_bmalloca *ap);
+
 /*
  * Special values for xfs_bmbt_irec_t br_startblock field.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 731260a5af6db4..d6432a7ef2857d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -168,17 +168,7 @@ xfs_bmap_rtalloc(
 	if (rtx != NULLRTEXTNO) {
 		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
-		ap->ip->i_nblocks += ap->length;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= ap->length;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
-					XFS_TRANS_DQ_RTBCOUNT, ap->length);
+		xfs_bmap_alloc_account(ap);
 		return 0;
 	}
 
-- 
2.39.2

