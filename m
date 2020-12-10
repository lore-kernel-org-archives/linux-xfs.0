Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0553C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A061E23D51
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbgLJFtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 00:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLJFtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 00:49:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742A5C061793
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 21:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=vGybSBF/XKHvvpbnScxl/wddM6bgMH54aSlEol6jZrQ=; b=qWcNriHRBWflw/pfp7NxSSz8un
        2xyQ+rfb8Pz9MXB+pTG/cbYSYOF5/jeMgmytgFISeBXknh+atlAXRaYzKpatHe1aKdxVPDYjOJhXd
        3Gi0oVmEetUylr+aFKKqpOFYCo6jzxttNkS9EfCzRLiwY4SBb5ydi8nIDmSmD7Po7NdQNIUhf2M0J
        Sx7Py1Vw5qZyxM4tYF1f5SknBmkwlvQg1x0KIVysEcqSXQTgilG7jD8zeZsd6UqZOS+8nONN0ka9t
        hJds2WDj+wNNIdWSpkB1sbuJEDaN64TUFwiKPAX/f+mg1EyLKTZs5QjuWBn0PweJqAx36TxNSaPpa
        0TgnG6DA==;
Received: from [2001:4bb8:199:f14c:a24a:d231:8d9c:a947] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1knEoT-000432-UA
        for linux-xfs@vger.kernel.org; Thu, 10 Dec 2020 05:48:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove xfs_vn_setattr_nonsize
Date:   Thu, 10 Dec 2020 06:48:20 +0100
Message-Id: <20201210054821.2704734-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210054821.2704734-1-hch@lst.de>
References: <20201210054821.2704734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge xfs_vn_setattr_nonsize into the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 26 +++++++-------------------
 fs/xfs/xfs_iops.h |  1 -
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1414ab79eacfc2..54c7c94f82951b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -826,22 +826,6 @@ xfs_setattr_nonsize(
 	return error;
 }
 
-int
-xfs_vn_setattr_nonsize(
-	struct dentry		*dentry,
-	struct iattr		*iattr)
-{
-	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
-	int error;
-
-	trace_xfs_setattr(ip);
-
-	error = xfs_vn_change_ok(dentry, iattr);
-	if (error)
-		return error;
-	return xfs_setattr_nonsize(ip, iattr, 0);
-}
-
 /*
  * Truncate file.  Must have write permission and not be a directory.
  *
@@ -1069,11 +1053,11 @@ xfs_vn_setattr(
 	struct dentry		*dentry,
 	struct iattr		*iattr)
 {
+	struct inode		*inode = d_inode(dentry);
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		struct inode		*inode = d_inode(dentry);
-		struct xfs_inode	*ip = XFS_I(inode);
 		uint			iolock;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
@@ -1088,7 +1072,11 @@ xfs_vn_setattr(
 		error = xfs_vn_setattr_size(dentry, iattr);
 		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	} else {
-		error = xfs_vn_setattr_nonsize(dentry, iattr);
+		trace_xfs_setattr(ip);
+
+		error = xfs_vn_change_ok(dentry, iattr);
+		if (!error)
+			error = xfs_setattr_nonsize(ip, iattr, 0);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 4d24ff309f593f..a91e2d1b47b45d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -21,7 +21,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
-extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);
 extern int xfs_vn_setattr_size(struct dentry *dentry, struct iattr *vap);
 
 #endif /* __XFS_IOPS_H__ */
-- 
2.29.2

