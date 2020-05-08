Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060C5C54E7F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93E0208D6
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XIIzlGN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEHGer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363C5C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=nrmBOHmYraqq19vTF5eFljn4sqanE/eo91X9Wn/sex4=; b=XIIzlGN++aQkCe73ogOf/7EHBK
        VmsLm+4GxkdUDyBgnpxdsHv/ZtaknaAZrIEIg8lSeEjjmKzYVTLyw30BgzXOXRqYeFI4fyPbrsrCE
        N9SQJwSFL2CcwwPPx4mtlEBjhYu4siXqYTZr5APY/4U/ydT63rsHgw5kAFDrqC5oGiM+x7gUcYOiR
        Wbz1hqIluC8486vj3WIe6m0l3Rn2K85m6ERg69hBRq/ea0TuZHhgy+GTktN7BoYBIVmGdRME3wnmr
        1QHhAm40u8t1wn/W2a3rmMG4JE7CeElmcUW6eyJEkGtkP29ZFT8oOViTujOH4I3Jg267Z4zQ1X/zI
        /6hVDMHw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwas-0002w5-Nh
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Date:   Fri,  8 May 2020 08:34:20 +0200
Message-Id: <20200508063423.482370-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The split between xfs_inode_verify_forks and the two helpers
implementing the actual functionality is a little strange.  Reshuffle
it so that xfs_inode_verify_forks verifies if the data and attr forks
are actually in local format and only call the low-level helpers if
that is the case.  Handle the actual error reporting in the low-level
handlers to streamline the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 51 ++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
 fs/xfs/xfs_inode.c             | 21 +++-----------
 3 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e346e143f1053..401921975d75b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -674,34 +674,51 @@ xfs_ifork_init_cow(
 }
 
 /* Verify the inline contents of the data fork of an inode. */
-xfs_failaddr_t
-xfs_ifork_verify_data(
+int
+xfs_ifork_verify_local_data(
 	struct xfs_inode	*ip)
 {
-	/* Non-local data fork, we're done. */
-	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-		return NULL;
+	xfs_failaddr_t		fa = NULL;
 
-	/* Check the inline data fork if there is one. */
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFDIR:
-		return xfs_dir2_sf_verify(ip);
+		fa = xfs_dir2_sf_verify(ip);
+		break;
 	case S_IFLNK:
-		return xfs_symlink_shortform_verify(ip);
+		fa = xfs_symlink_shortform_verify(ip);
+		break;
 	default:
-		return NULL;
+		break;
 	}
+
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
+			ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
 
 /* Verify the inline contents of the attr fork of an inode. */
-xfs_failaddr_t
-xfs_ifork_verify_attr(
+int
+xfs_ifork_verify_local_attr(
 	struct xfs_inode	*ip)
 {
-	/* There has to be an attr fork allocated if aformat is local. */
-	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
-		return NULL;
-	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
-		return __this_address;
-	return xfs_attr_shortform_verify(ip);
+	struct xfs_ifork	*ifp = ip->i_afp;
+	xfs_failaddr_t		fa;
+
+	if (!ifp)
+		fa = __this_address;
+	else
+		fa = xfs_attr_shortform_verify(ip);
+
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
+			ifp ? ifp->if_u1.if_data : NULL,
+			ifp ? ifp->if_bytes : 0, fa);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 3f84d33abd3b7..f46a8c1db5964 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -176,7 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
-xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
-xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
+int xfs_ifork_verify_local_data(struct xfs_inode *ip);
+int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 25c00ffe18409..c8abdefe00377 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3715,25 +3715,12 @@ bool
 xfs_inode_verify_forks(
 	struct xfs_inode	*ip)
 {
-	struct xfs_ifork	*ifp;
-	xfs_failaddr_t		fa;
-
-	fa = xfs_ifork_verify_data(ip);
-	if (fa) {
-		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
-				ifp->if_u1.if_data, ifp->if_bytes, fa);
+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_data(ip))
 		return false;
-	}
-
-	fa = xfs_ifork_verify_attr(ip);
-	if (fa) {
-		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-				ifp ? ifp->if_u1.if_data : NULL,
-				ifp ? ifp->if_bytes : 0, fa);
+	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_attr(ip))
 		return false;
-	}
 	return true;
 }
 
-- 
2.26.2

