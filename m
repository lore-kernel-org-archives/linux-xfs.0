Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB6DC47247
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F2A207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VNhQDVwD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgEHGet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727119AbgEHGet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E74BC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=gGJpt2ZYeo1MSVzR5v4GxOQPB2Jh2rMEB0EXSsPOlh4=; b=VNhQDVwDAmVm+K2jRjCnS2pgm+
        WwsAEqQHr0v2/EwiAHZVrFyHClgNQs2/dBtHT6OhZErmxP11V3sFf/SU0DWUsst+O3PwWnHMaL47p
        pVk+Hf/q+nENRKgCWGsRT7Q6xR938LLcdGwDpyHX78hR5aOrKgPnTHkRfNg1f5AzKQUBM5Ak4N+uI
        svrvAxoCz+VjizZTePCRwwqTBdXvfJsTFcEZWuXnlknqjpH3+jNOiuk+HACIJuYLbf5AfTavRR8Pz
        ZenjxQ7yBFjP7KSEu/dJvhFl7cpK0hFoSUlmWWG9hbDYco8R5wQHPzCpBiIe5WnF6PwzLuFrTvuNa
        vUsRbe1w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwav-0002wO-3i
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: improve local fork verification
Date:   Fri,  8 May 2020 08:34:21 +0200
Message-Id: <20200508063423.482370-11-hch@lst.de>
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
index 401921975d75b..2fe325e38fd88 100644
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
index af5748f5d9271..5a3a520b95288 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -543,14 +543,8 @@ xfs_iget_cache_miss(
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
index c8abdefe00377..549ff468b7b60 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3707,23 +3707,6 @@ xfs_iflush(
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
@@ -3808,8 +3791,15 @@ xfs_iflush_int(
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
+		goto flush_out;
+	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
+	    xfs_ifork_verify_local_attr(ip))
 		goto flush_out;
 
 	/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 83073c883fbf9..ff846197941e4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -498,8 +498,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
-bool xfs_inode_verify_forks(struct xfs_inode *ip);
-
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3960caf51c9f7..87b940cb760db 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2878,11 +2878,6 @@ xfs_recover_inode_owner_change(
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

