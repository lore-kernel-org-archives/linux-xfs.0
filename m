Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752F0C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC01223D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSFCW5Vq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfKTLRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7eCoI9J4rSCPfndM2bor5P/UeXh+l5fXz6LsEeccKHk=; b=jSFCW5Vqcrpp76hInmBcpST/k2
        rOQ3z81Kt9N/GFL9xkTArj5+3zpJK092u2gV4kxBMaVQUB33z6wtnmVO5cnqF0ufqB+kZrifgvO87
        u7kd1gMyezj0B+bXk9Aet4+6I5lE5ZpxJML28gNSEJk9hI9KPaVF4bqlVPK0lCxUjP9jA+Zhtlqon
        VXmwNDHezdsfz0ak+NNEtFnELKE0ZtCb7aaFtnceU1tjKWOWz8DnXAwll3NAGaGgW4VFW4M8qJY/g
        RMp/gPOhQe0SI852edj7U+QgFEdO1NUtTd4Ll000N+9bg0FGpRLmRCAU/rDRqh4Kyl6loywB6QzlF
        a3D1PNJg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzR-0001Rs-7w; Wed, 20 Nov 2019 11:17:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/10] xfs: remove the mappedbno argument to xfs_dir3_leaf_read
Date:   Wed, 20 Nov 2019 12:17:23 +0100
Message-Id: <20191120111727.16119-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120111727.16119-1-hch@lst.de>
References: <20191120111727.16119-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This argument is always hard coded to -1, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 9 ++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h | 4 ++--
 fs/xfs/scrub/dir.c            | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 73edd96ce0ac..41df4322f260 100644
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
index 372c2000f951..4d5e17a81cd4 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -94,8 +94,8 @@ void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
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

