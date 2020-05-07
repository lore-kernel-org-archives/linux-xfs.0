Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE11C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B032083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fu13OeSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgEGMUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgEGMUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FC2C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VcNRMEgf+RGj1yK1iBKKM/Y7CT8ySINfX3RyN7Q2qUE=; b=fu13OeSrRmI4vs5Fp7AsgzHP7c
        rKUPKloGbHFm5Yno5/VTfIVWpk6TSS/5q9aRfrkjm16l8qqKV1mOW4tGgWXh2qXyQTywDdmBvcEDD
        2Z973ElbhwUz/iD4MfNTP6NQbNoOLiYwXP4/+SSesB9NYVGsx6jJakCH57FTCvUVqQGhStiyd9VSQ
        K/XXDL3kIS5UzUMItXesmU1v9QwlCygqR+H9TNDk95fuycmniqaE0jV07bK/QQBl+k7EqXEHBU5yy
        0sa6EoMJgRC4P8wo+ijj2pKULf7TyL2Q4krZw+8wljzKDrxKdBqxZBhUXIpKX4xjL7AD6ouG5lCYu
        tZ182VSA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfW2-0007iN-S6; Thu, 07 May 2020 12:20:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 43/58] xfs: make btree cursor private union anonymous
Date:   Thu,  7 May 2020 14:18:36 +0200
Message-Id: <20200507121851.304002-44-hch@lst.de>
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

Source kernel commit: 352890735e52343b1690f6d5d32224e2aa88a56a

Rename the union and it's internal structures to the new name and
remove the temporary defines that facilitated the change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 33980a12..337fb1d0 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -213,7 +213,7 @@ typedef struct xfs_btree_cur
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
 			xfs_agnumber_t	agno;	/* ag number */
 			union xfs_btree_cur_private	priv;
-		} a;
+		} bc_ag;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
 			int		allocated;	/* count of alloced */
@@ -222,10 +222,8 @@ typedef struct xfs_btree_cur
 			char		flags;		/* flags */
 #define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
-		} b;
-	}		bc_private;	/* per-btree type data */
-#define bc_ag	bc_private.a
-#define bc_ino	bc_private.b
+		} bc_ino;
+	};				/* per-btree type data */
 } xfs_btree_cur_t;
 
 /* cursor flags */
-- 
2.26.2

