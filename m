Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E71BC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BD72083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rToQeW9U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEGMUm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725949AbgEGMUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4B9C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7Jkq4RmU8+xnCKUZQI0oGxbWl35AE2MTivqjwrhXb+c=; b=rToQeW9Ue3XiYF6zCYSvfOi2Ha
        iUlzWQGZULwIag99fOsCjvVkIn1x+Q3dFgXSiMg1wOliom0V91sNmlrlEwq26Y779BStnDd+RTKtz
        rRjGH1Ku8PhrDVEF+afJaC5tNi5U4EoSAIL8X6cQ6Ve1kRwyjotpRBmCclH4QiFat+bg7LFWkBXH/
        3N/zKmz3hM3oVTpV/M29QH3ZSakcon4loYOgy0U9D5g/Ij1V0JLiQRi9vO/2+hNmmhWLhks3WKpzT
        H+WX0hm5FOjRAHyiJqR5benwFxtYSeKvRGAGAgZ8vpbukubEQGA+Um1aZzlT7NQEQ7oCPBg9sJOKs
        ICa2RJBw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfW5-0007jE-8C; Thu, 07 May 2020 12:20:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 44/58] xfs: make the btree cursor union members named structure
Date:   Thu,  7 May 2020 14:18:37 +0200
Message-Id: <20200507121851.304002-45-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 68422d90dad4fe98f99d6e414aeec9a58d5185d5

we need to name the btree cursor private structures to be able
to pull them out of the deeply nested structure definition they are
in now.

Based on code extracted from a patchset by Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.h | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 337fb1d0..5e1bae45 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -188,6 +188,27 @@ union xfs_btree_cur_private {
 	} abt;
 };
 
+/* Per-AG btree information. */
+struct xfs_btree_cur_ag {
+	struct xfs_buf			*agbp;
+	xfs_agnumber_t			agno;
+	union xfs_btree_cur_private	priv;
+};
+
+/* Btree-in-inode cursor information */
+struct xfs_btree_cur_ino {
+	struct xfs_inode		*ip;
+	int				allocated;
+	short				forksize;
+	char				whichfork;
+	char				flags;
+/* We are converting a delalloc reservation */
+#define	XFS_BTCUR_BMBT_WASDEL		(1 << 0)
+
+/* For extent swap, ignore owner check in verifier */
+#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -209,21 +230,9 @@ typedef struct xfs_btree_cur
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 	union {
-		struct {			/* needed for BNO, CNT, INO */
-			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
-			xfs_agnumber_t	agno;	/* ag number */
-			union xfs_btree_cur_private	priv;
-		} bc_ag;
-		struct {			/* needed for BMAP */
-			struct xfs_inode *ip;	/* pointer to our inode */
-			int		allocated;	/* count of alloced */
-			short		forksize;	/* fork's inode space */
-			char		whichfork;	/* data or attr fork */
-			char		flags;		/* flags */
-#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
-#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
-		} bc_ino;
-	};				/* per-btree type data */
+		struct xfs_btree_cur_ag	bc_ag;
+		struct xfs_btree_cur_ino bc_ino;
+	};
 } xfs_btree_cur_t;
 
 /* cursor flags */
-- 
2.26.2

