Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826E1C54E8C
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCBD20731
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TPvhrtaj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgEJHYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE67AC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=HcvqauKbbvmOkDbvdzMKsDz5PQAfxyIY1S1D2UfmENQ=; b=TPvhrtajVcJ5PZ9c86WuqyqGKm
        9K7CkNkqcapaZFij9ac+6sjzq2mO6t8277OslARB4RAW71p+DUJFHHVQnoYaET0P1SI5ozjYL4x1a
        GvaxyuzHOqIPxR2nUPmCQ0rMgXks2Wzfym5+ImkPkEyBKZ6F3dtvWJC135rEbUTEX/V4upORNHBH5
        CyrRucAXnBXBnWskdR+E++h65jDkUy4PB48udgSS0vL6njHPaRvgKFrgz3TYPZSD6NoezjgTmmrLj
        55AcYdrLLDR0QzfOH86MorMdzVtRKaa4p6azfyaQvu6JmRCQpoOq5ymBmSSnqyb3HqHgvayXVBluG
        wJXmbKAA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgJz-0004wL-7s
        for linux-xfs@vger.kernel.org; Sun, 10 May 2020 07:24:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: cleanup xfs_idestroy_fork
Date:   Sun, 10 May 2020 09:24:04 +0200
Message-Id: <20200510072404.986627-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510072404.986627-1-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move freeing the dynamically allocated attr and COW fork, as well
as zeroing the pointers where actually needed into the callers, and
just pass the xfs_ifork structure to xfs_idestroy_fork.  Simplify
the kmem_free calls by not checking for NULL first, and not zeroing
the pointers in structure that are about to be freed (either the
ifork or the containing inode in case of the data fork).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
 fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 36 +++++++++-------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_attr_inactive.c     |  7 +++++--
 fs/xfs/xfs_icache.c            | 15 ++++++++------
 6 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d7f3173ce3c31..8d775942f1c6c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -716,11 +716,10 @@ xfs_attr_fork_remove(
 	struct xfs_inode	*ip,
 	struct xfs_trans	*tp)
 {
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
index 6562f2bcd15cc..577cc20e03170 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -495,38 +495,20 @@ xfs_idata_realloc(
 
 void
 xfs_idestroy_fork(
-	xfs_inode_t	*ip,
-	int		whichfork)
+	struct xfs_ifork	*ifp)
 {
-	struct xfs_ifork	*ifp;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (ifp->if_broot != NULL) {
-		kmem_free(ifp->if_broot);
-		ifp->if_broot = NULL;
-	}
+	kmem_free(ifp->if_broot);
 
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

