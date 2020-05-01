Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFF5C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E5972173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jFquEkK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEAIOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgEAIOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C69C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=Wooz13WAVxLUnWepwpMDBsy3UdFeAHUf3Tsngz8gFZ8=; b=jFquEkK6/pYDTUjbT2jOz9dOzy
        ZZDgos3S0MrlqNXUPRTJzQyza3lkeKN9yPzE/pEZza+rVI8d3udj4eupay9JCk1N2DSZzpl1GflOL
        xgfLcG1/8vKyt36RBsUb1oxSONmx9rh2G2WYqGPtGfVuuysoqsIpdjPlYEQ+12SI6fxX94QtaIeZu
        wTcdwG4GYA+GvrdhI0QC086o5VkXVPkYf7FOVCy+WPrJd1wzOdIWiwVRBWdrL313XjAZ9dcOk/AuF
        7P3MLTue27aOs1BI5Wc4RRz551bek6EgiQbWfYq/uDclXo+kWPKGpQxrmqhuuOhzlHj9B0Z3QCk/7
        bLWLCHlQ==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQos-0002wS-0i
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: improve local fork verification
Date:   Fri,  1 May 2020 10:14:22 +0200
Message-Id: <20200501081424.2598914-11-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Call the data/attr local fork verifies as soon as we are ready for them.
This keeps them close to the code setting up the forks, and avoids a
few branches later on.  Also open code xfs_inode_verify_forks in the
only remaining caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c |  8 +++++++-
 fs/xfs/xfs_icache.c            |  6 ------
 fs/xfs/xfs_inode.c             | 28 +++++++++-------------------
 fs/xfs/xfs_inode.h             |  2 --
 fs/xfs/xfs_log_recover.c       |  5 -----
 5 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7e129ed2f345f..cbe3347d6f23a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -227,6 +227,7 @@ xfs_iformat_data_fork(
 	struct xfs_dinode	*dip)
 {
 	struct inode		*inode = VFS_I(ip);
+	int			error;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -241,8 +242,11 @@ xfs_iformat_data_fork(
 	case S_IFDIR:
 		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
+			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK,
 					be64_to_cpu(dip->di_size));
+			if (!error)
+				error = xfs_ifork_verify_local_data(ip);
+			return error;
 		case XFS_DINODE_FMT_EXTENTS:
 			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_BTREE:
@@ -282,6 +286,8 @@ xfs_iformat_attr_fork(
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
 				xfs_dfork_attr_shortform_size(dip));
+		if (!error)
+			error = xfs_ifork_verify_local_attr(ip);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dd757c6614956..f9ed02aafa89a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -545,14 +545,8 @@ xfs_iget_cache_miss(
 			goto out_destroy;
 	}
 
-	if (!xfs_inode_verify_forks(ip)) {
-		error = -EFSCORRUPTED;
-		goto out_destroy;
-	}
-
 	trace_xfs_iget_miss(ip);
 
-
 	/*
 	 * Check the inode free state is valid. This also detects lookup
 	 * racing with unlinks.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2ec7789317133..a0dfdee7db4f1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3758,23 +3758,6 @@ xfs_iflush(
 	return error;
 }
 
-/*
- * If there are inline format data / attr forks attached to this inode,
- * make sure they're not corrupt.
- */
-bool
-xfs_inode_verify_forks(
-	struct xfs_inode	*ip)
-{
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
-	    xfs_ifork_verify_local_data(ip))
-		return false;
-	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
-	    xfs_ifork_verify_local_attr(ip))
-		return false;
-	return true;
-}
-
 STATIC int
 xfs_iflush_int(
 	struct xfs_inode	*ip,
@@ -3852,8 +3835,15 @@ xfs_iflush_int(
 	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 		ip->i_d.di_flushiter++;
 
-	/* Check the inline fork data before we write out. */
-	if (!xfs_inode_verify_forks(ip))
+	/*
+	 * If there are inline format data / attr forks attached to this inode,
+	 * make sure they are not corrupt.
+	 */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_data(ip))
+		goto corrupt_out;
+	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_attr(ip))
 		goto corrupt_out;
 
 	/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c6a63f6764a67..c7b201b4655ba 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -497,8 +497,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
-bool xfs_inode_verify_forks(struct xfs_inode *ip);
-
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 464388125d20b..554646892c62a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2874,11 +2874,6 @@ xfs_recover_inode_owner_change(
 	if (error)
 		goto out_free_ip;
 
-	if (!xfs_inode_verify_forks(ip)) {
-		error = -EFSCORRUPTED;
-		goto out_free_ip;
-	}
-
 	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
 		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
 		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
-- 
2.26.2

