Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94F63A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aF0e4Edi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yeqkwb9qKY6xnvBBwHEuiqqYYeBFaZpLUeN13y83b5o=; b=aF0e4Edivjlk2cldJZwSV3Ldho
	j9Ij/1Xyvp4S6XSNZF9y31mo0Lsjs/MwEZiKdfQwr12sjlW5vkHXf5Qaaet/6KFbKgHGnJAUBHTHV
	BK3WvH/KNGrE4KrRPrp3FZOIymfZc9Ew766DpmmAjoRoLQJNUsntAXa1m7u9rsMxflO9/OXliQkgj
	iB9WXElrHBW8WLaxHG8b0ol9Pg1iZWgaV6Y8UNVUY9AW3FleBII+6wh1Pb7wQMzX6mgLYGD7S3Xn5
	2tKF2a2ccbtO4vlvETseWFVaLEDq2MOBR6AkiKl5Teu3EztYJxDP7saHqBMkUimETAhAep9wqbzRO
	uJ0KuMUw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hL-00956f-0i;
	Mon, 18 Dec 2023 04:57:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/22] xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
Date: Mon, 18 Dec 2023 05:57:19 +0100
Message-Id: <20231218045738.711465-4-hch@lst.de>
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

xfs_bmap_btalloc_accounting only uses the len field from args, but that
has just been propagated to ap->length field by the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca6614f4eac50a..afdfb3455d9ebe 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3265,8 +3265,7 @@ xfs_bmap_btalloc_select_lengths(
 /* Update all inode and quota accounting for the allocation we just did. */
 static void
 xfs_bmap_btalloc_accounting(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args)
+	struct xfs_bmalloca	*ap)
 {
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
@@ -3279,7 +3278,7 @@ xfs_bmap_btalloc_accounting(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 			return;
 		}
 
@@ -3291,22 +3290,22 @@ xfs_bmap_btalloc_accounting(
 		 * This essentially transfers the transaction quota reservation
 		 * to that of a delalloc extent.
 		 */
-		ap->ip->i_delayed_blks += args->len;
+		ap->ip->i_delayed_blks += ap->length;
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
-				-(long)args->len);
+				-(long)ap->length);
 		return;
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_nblocks += args->len;
+	ap->ip->i_nblocks += ap->length;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
-		ap->ip->i_delayed_blks -= args->len;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+		ap->ip->i_delayed_blks -= ap->length;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 	}
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		args->len);
+		ap->length);
 }
 
 static int
@@ -3380,7 +3379,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap, args);
+	xfs_bmap_btalloc_accounting(ap);
 }
 
 #ifdef DEBUG
-- 
2.39.2

