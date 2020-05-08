Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59500C54E4A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C18A20870
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UI7N7gnx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEHGed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BB0C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=ePri7BjWuK/XQ25/wv8X+5XyBLVunACIa2W4GrbF2iM=; b=UI7N7gnxPTY9oqf61Xw3Xg8ki+
        DYIAW8FgWaHgIOYNaCIvrBhbJVyWF0/lLiGgsjPu4SwjiaETemyCv3s3DIAD18bTGKUs0MIe2pD/9
        Be9tl/1kqddBZ8Tpx+FXyWaluCHvW+093/5kfPLMfIDWnDCDCN3WYN5av+F4f+CQVLotgMW5SRLJY
        QfJY/8uqe/yjXO3/2JkLURmG4/Fa6SCwrhYEW0cJB9rJH3WJyGk0/hS5JvDhXkip5C+GVzJ3fR7N9
        pP+FSQMz8rP/BeiuWwTj/bPdsSF3m+4lNAD+J2lTw5z6hsePG9SBKhooYOEsNjqZmL+NSFTEnE1Lx
        46jmkp1Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwae-0002tw-EX
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: split xfs_iformat_fork
Date:   Fri,  8 May 2020 08:34:14 +0200
Message-Id: <20200508063423.482370-4-hch@lst.de>
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

xfs_iformat_fork is a weird catchall.  Split it into one helper for
the data fork and one for the attr fork, and then call both helper
as well as the COW fork initialization from xfs_inode_from_disk.  Order
the COW fork initialization after the attr fork initialization given
that it can't fail to simplify the error handling.

Note that the newly split helpers are moved down the file in
xfs_inode_fork.c to avoid the need for forward declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |  20 +++-
 fs/xfs/libxfs/xfs_inode_fork.c | 186 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_inode_fork.h |   3 +-
 3 files changed, 103 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dc00ce6fc4a2f..abdecc80579e3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -187,6 +187,10 @@ xfs_inode_from_disk(
 {
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	ASSERT(ip->i_cowfp == NULL);
+	ASSERT(ip->i_afp == NULL);
 
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
@@ -242,7 +246,21 @@ xfs_inode_from_disk(
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
-	return xfs_iformat_fork(ip, from);
+	error = xfs_iformat_data_fork(ip, from);
+	if (error)
+		return error;
+	if (XFS_DFORK_Q(from)) {
+		error = xfs_iformat_attr_fork(ip, from);
+		if (error)
+			goto out_destroy_data_fork;
+	}
+	if (xfs_is_reflink_inode(ip))
+		xfs_ifork_init_cow(ip);
+	return 0;
+
+out_destroy_data_fork:
+	xfs_idestroy_fork(ip, XFS_DATA_FORK);
+	return error;
 }
 
 void
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 3e9a42f1e23b9..5fadfa9a17eb9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,110 +26,6 @@
 
 kmem_zone_t *xfs_ifork_zone;
 
-STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
-STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
-STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
-
-/*
- * Copy inode type and data and attr format specific information from the
- * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
- * and sockets this means set i_rdev to the proper value.  For files,
- * directories, and symlinks this means to bring in the in-line data or extent
- * pointers as well as the attribute fork.  For a fork in B-tree format, only
- * the root is immediately brought in-core.  The rest will be read in later when
- * first referenced (see xfs_iread_extents()).
- */
-int
-xfs_iformat_fork(
-	struct xfs_inode	*ip,
-	struct xfs_dinode	*dip)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct xfs_attr_shortform *atp;
-	int			size;
-	int			error = 0;
-	xfs_fsize_t             di_size;
-
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
-		ip->i_d.di_size = 0;
-		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
-		break;
-
-	case S_IFREG:
-	case S_IFLNK:
-	case S_IFDIR:
-		switch (dip->di_format) {
-		case XFS_DINODE_FMT_LOCAL:
-			di_size = be64_to_cpu(dip->di_size);
-			size = (int)di_size;
-			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK, size);
-			break;
-		case XFS_DINODE_FMT_EXTENTS:
-			error = xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
-			break;
-		case XFS_DINODE_FMT_BTREE:
-			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
-			break;
-		default:
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
-					dip, sizeof(*dip), __this_address);
-			return -EFSCORRUPTED;
-		}
-		break;
-
-	default:
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
-				sizeof(*dip), __this_address);
-		return -EFSCORRUPTED;
-	}
-	if (error)
-		return error;
-
-	if (xfs_is_reflink_inode(ip)) {
-		ASSERT(ip->i_cowfp == NULL);
-		xfs_ifork_init_cow(ip);
-	}
-
-	if (!XFS_DFORK_Q(dip))
-		return 0;
-
-	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
-
-	switch (dip->di_aformat) {
-	case XFS_DINODE_FMT_LOCAL:
-		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
-		size = be16_to_cpu(atp->hdr.totsize);
-
-		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
-		break;
-	case XFS_DINODE_FMT_EXTENTS:
-		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
-		break;
-	default:
-		xfs_inode_verifier_error(ip, error, __func__, dip,
-				sizeof(*dip), __this_address);
-		error = -EFSCORRUPTED;
-		break;
-	}
-	if (error) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
-		ip->i_afp = NULL;
-		if (ip->i_cowfp)
-			kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
-		ip->i_cowfp = NULL;
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-	}
-	return error;
-}
-
 void
 xfs_init_local_fork(
 	struct xfs_inode	*ip,
@@ -325,6 +221,88 @@ xfs_iformat_btree(
 	return 0;
 }
 
+int
+xfs_iformat_data_fork(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_d.di_size = 0;
+		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
+		return 0;
+	case S_IFREG:
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (dip->di_format) {
+		case XFS_DINODE_FMT_LOCAL:
+			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
+					be64_to_cpu(dip->di_size));
+		case XFS_DINODE_FMT_EXTENTS:
+			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
+		case XFS_DINODE_FMT_BTREE:
+			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
+		default:
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
+		return -EFSCORRUPTED;
+	}
+}
+
+static uint16_t
+xfs_dfork_attr_shortform_size(
+	struct xfs_dinode		*dip)
+{
+	struct xfs_attr_shortform	*atp =
+		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
+
+	return be16_to_cpu(atp->hdr.totsize);
+}
+
+int
+xfs_iformat_attr_fork(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	int			error = 0;
+
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
+				xfs_dfork_attr_shortform_size(dip));
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
+		break;
+	default:
+		xfs_inode_verifier_error(ip, error, __func__, dip,
+				sizeof(*dip), __this_address);
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	if (error) {
+		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		ip->i_afp = NULL;
+	}
+	return error;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 668ee942be224..8487b0c88a75e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -88,7 +88,8 @@ struct xfs_ifork {
 
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
-int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
+int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
+int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
-- 
2.26.2

