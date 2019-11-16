Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE99C43215
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BDB2068E
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t7Tbk0rQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfKPSWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=idoSAQV0/T9sT3Y+JYCvhA2gYZvG7jfaC75vKqNrsY0=; b=t7Tbk0rQZs7SBSNrJPW5Z8bR88
        /NM1jurSFNqQ05oio55HxGnE1f0oNxE4XJjSmzCQd0ZLxXDI7hDW/awhdXGyWGb8BYaU7YxY5KkK2
        rWeCxiJ2NTtyHYYOzcI0qijv2SeOMqXUuh1n7ZtYVJR0my//gdpFhcHRNyHtLdVNijIvGd4JlOrSD
        exk/wjJxDR83jXIlghQsxM0OMkM3HF5Di52zn4bia0cMtVg3XG3WfGlyGJdWoPkhXGjkC0pkKeOFu
        xphtX4z5V4ISKnY8UUpH4WlBsSDzCvOiUodTvRASihPa+VI8Xdhx0O2kCRvXB8Jh/hFeIT9sKapOZ
        PHyQSFlg==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iN-0006iD-98; Sat, 16 Nov 2019 18:22:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 5/9] xfs: remove the mappedbno argument to xfs_dir3_leaf_read
Date:   Sat, 16 Nov 2019 19:22:10 +0100
Message-Id: <20191116182214.23711-6-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116182214.23711-1-hch@lst.de>
References: <20191116182214.23711-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This argument is always hard coded to -1, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 9 ++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h | 4 ++--
 fs/xfs/scrub/dir.c            | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index e2e4b2c6d6c2..2eee4e299e19 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -262,13 +262,12 @@ xfs_dir3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
+	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
+			&xfs_dir3_leaf1_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
 	return err;
@@ -639,7 +638,7 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
 	if (error)
 		return error;
 
@@ -1230,7 +1229,7 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index a730c5223c64..ade41556901a 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -91,8 +91,8 @@ void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
 void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
-extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
+int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t fbno, struct xfs_buf **bpp);
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 7983ea40668a..910e0bf85bd7 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -497,7 +497,7 @@ xchk_directory_leaf1_bestfree(
 	int				error;
 
 	/* Read the free space block. */
-	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
 	xchk_buffer_recheck(sc, bp);
-- 
2.20.1

