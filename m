Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6424C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34D8207D8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BwVCh09I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgERHeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 03:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERHeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 03:34:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D63C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 00:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=S9bSTPTKkEZQj8aqobMXpWBmnHA72STcxtENaSdfS6M=; b=BwVCh09IZNcz/fZ43X4Wv0X1Bc
        0WUIH/EPq7xTue3VNK7ER6GcLJk+coF72i1YcdTUi8ZeiLrgNtLdqhT0iceAhXH+MhjUHj3Hgdnak
        bPI6HuwJ46LMiSOEmMvB5f2FYQIkSUHraOpyCVO2LcAS3w4iLwkhunTkXllP3mfs0BRd1qWPWkEOi
        0TzDC9LYPbTclOlw1CwJHbPIRMX3Dq3zlz+cMl1y9j6EvQL++7xSJ9zUITKZaoyJkZlHzDV5C/0XE
        Z/KSdMqtirhtSU562sIDGsrN8zaJaQfJ3X7okgrdOYaO4TJZ0LJcw4rTB+za9TxuavYWmEcF6v0Dp
        /Fvg5NvQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaaHz-0002tD-GJ; Mon, 18 May 2020 07:34:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 6/6] xfs: cleanup xfs_idestroy_fork
Date:   Mon, 18 May 2020 09:33:58 +0200
Message-Id: <20200518073358.760214-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518073358.760214-1-hch@lst.de>
References: <20200518073358.760214-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move freeing the dynamically allocated attr and COW fork, as well
as zeroing the pointers where actually needed into the callers, and
just pass the xfs_ifork structure to xfs_idestroy_fork.  Also simplify
the kmem_free calls by not checking for NULL first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
 fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 32 +++++++++-----------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_attr_inactive.c     |  7 +++++--
 fs/xfs/xfs_icache.c            | 15 +++++++++------
 6 files changed, 28 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b279200519777..394805abb4535 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -718,11 +718,10 @@ xfs_attr_fork_remove(
 {
 	ASSERT(ip->i_afp->if_nextents == 0);
 
-	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	xfs_idestroy_fork(ip->i_afp);
+	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+	ip->i_afp = NULL;
 	ip->i_d.di_forkoff = 0;
-
-	ASSERT(ip->i_afp == NULL);
-
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ab555671e1543..6f84ea85fdd83 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -271,7 +271,7 @@ xfs_inode_from_disk(
 	return 0;
 
 out_destroy_data_fork:
-	xfs_idestroy_fork(ip, XFS_DATA_FORK);
+	xfs_idestroy_fork(&ip->i_df);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ef43b4893766c..28b366275ae0e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -503,38 +503,24 @@ xfs_idata_realloc(
 
 void
 xfs_idestroy_fork(
-	xfs_inode_t	*ip,
-	int		whichfork)
+	struct xfs_ifork	*ifp)
 {
-	struct xfs_ifork	*ifp;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (ifp->if_broot != NULL) {
 		kmem_free(ifp->if_broot);
 		ifp->if_broot = NULL;
 	}
 
 	/*
-	 * If the format is local, then we can't have an extents
-	 * array so just look for an inline data array.  If we're
-	 * not local then we may or may not have an extents list,
-	 * so check and free it up if we do.
+	 * If the format is local, then we can't have an extents array so just
+	 * look for an inline data array.  If we're not local then we may or may
+	 * not have an extents list, so check and free it up if we do.
 	 */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
-		if (ifp->if_u1.if_data != NULL) {
-			kmem_free(ifp->if_u1.if_data);
-			ifp->if_u1.if_data = NULL;
-		}
-	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
-		xfs_iext_destroy(ifp);
-	}
-
-	if (whichfork == XFS_ATTR_FORK) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
-		ip->i_afp = NULL;
-	} else if (whichfork == XFS_COW_FORK) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
-		ip->i_cowfp = NULL;
+		kmem_free(ifp->if_u1.if_data);
+		ifp->if_u1.if_data = NULL;
+	} else if (ifp->if_flags & XFS_IFEXTENTS) {
+		if (ifp->if_height)
+			xfs_iext_destroy(ifp);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d849cca103edd..a4953e95c4f3f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -86,7 +86,7 @@ int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
 int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
-void		xfs_idestroy_fork(struct xfs_inode *, int);
+void		xfs_idestroy_fork(struct xfs_ifork *ifp);
 void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 00ffc46c0bf71..bfad669e6b2f8 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -388,8 +388,11 @@ xfs_attr_inactive(
 	xfs_trans_cancel(trans);
 out_destroy_fork:
 	/* kill the in-core attr fork before we drop the inode lock */
-	if (dp->i_afp)
-		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
+	if (dp->i_afp) {
+		xfs_idestroy_fork(dp->i_afp);
+		kmem_cache_free(xfs_ifork_zone, dp->i_afp);
+		dp->i_afp = NULL;
+	}
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
 	return error;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c09b3e9eab1da..d806d3bfa8936 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -87,15 +87,18 @@ xfs_inode_free_callback(
 	case S_IFREG:
 	case S_IFDIR:
 	case S_IFLNK:
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
+		xfs_idestroy_fork(&ip->i_df);
 		break;
 	}
 
-	if (ip->i_afp)
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-	if (ip->i_cowfp)
-		xfs_idestroy_fork(ip, XFS_COW_FORK);
-
+	if (ip->i_afp) {
+		xfs_idestroy_fork(ip->i_afp);
+		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+	}
+	if (ip->i_cowfp) {
+		xfs_idestroy_fork(ip->i_cowfp);
+		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
+	}
 	if (ip->i_itemp) {
 		ASSERT(!test_bit(XFS_LI_IN_AIL,
 				 &ip->i_itemp->ili_item.li_flags));
-- 
2.26.2

