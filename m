Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H4hJjZrq"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03DA6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NvhMfP9T7Wtowh0mfbPX+GloSwRuyGF71U1yFpLOSOk=; b=H4hJjZrqa3RxNmvQtPALbVPCV9
	Kcu4+VzmtxYaCziHB7EChwSjaBZ/apexz6Bi4QSL8XxXdbXJ3fyl7zDF/Q129nKa/9AKotBaY7yqN
	X6aOrvT4JCyCWMNG+PNu0FCK1TqYyRLlCjZUn4lnuewRA4ajRRMq6LvGv1kKqTaKrsjDmVIgodvg5
	TZ+c/wjdIiLV5iswdW963lCz/xLf+fWb41XUj4KKFP+GY6Z+6kkK7hFKAbz0VH/X/lpChBGCMihLa
	LVbhA9TRpmOd+EaAPPbATTDXKrSAkMcVmbnE8B75XtHaIucUp9/frsBnq9ybgjfFbBHq2X3uW9338
	B+x7KCCw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJ3-00GzJS-29;
	Thu, 14 Dec 2023 06:34:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/19] xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
Date: Thu, 14 Dec 2023 07:34:22 +0100
Message-Id: <20231214063438.290538-4-hch@lst.de>
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

xfs_bmap_btalloc_accounting only uses the len field from args, but that
has just been propagated to ap->length field by the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

