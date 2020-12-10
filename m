Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFB0C4167B
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B680123D58
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 05:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732779AbgLJFtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 00:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLJFtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 00:49:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA29C061794
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 21:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=1l5/w6dCv+US83UuOdNoMU3cDolRIxRGQKpbwag1/4Q=; b=BgMmXeuyeDGbKxdWuXMNyowG1z
        mRXhepBW404+Dh2e2OhJ+REVsLBTLniKtC8kxeRm2n+v/ypDe7n6OYiPJhwVnZtC/YfuY0Fh1nG++
        DgA/fW2sQyk7bwcWJzhQoE+JDpW/ABr884z5gfAadCuN8UlZ+FAhkrlaZs6JzIQ4pVmcvAIVsV3N0
        q1n6pktAXc2AufIY2T8tWZTI/n50MfH7TlAZqXxG+GvqxRLSSou039vWcvN+DdTtGEWyfmJh3PHTK
        zs4JstFxS28mYXWxa0HTDXXnT9xW90/vq1DGJPab0ynZQdg/+voHIhqn0JFhy8WlH7dV8cYqJWzSk
        FS6VjlRg==;
Received: from [2001:4bb8:199:f14c:a24a:d231:8d9c:a947] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1knEoU-000436-VC
        for linux-xfs@vger.kernel.org; Thu, 10 Dec 2020 05:48:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: open code updating i_mode in xfs_set_acl
Date:   Thu, 10 Dec 2020 06:48:21 +0100
Message-Id: <20201210054821.2704734-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210054821.2704734-1-hch@lst.de>
References: <20201210054821.2704734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rather than going through the big and hairy xfs_setattr_nonsize function,
just open code a transactional i_mode and i_ctime update.  This allows
to mark xfs_setattr_nonsize and remove the flags argument to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_acl.c  | 40 ++++++++++++++++++++++------------------
 fs/xfs/xfs_iops.c | 11 +++++------
 fs/xfs/xfs_iops.h |  7 -------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index c544951a0c07f3..779cb73b3d006f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -16,6 +16,7 @@
 #include "xfs_acl.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_trans.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -212,21 +213,28 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 }
 
 static int
-xfs_set_mode(struct inode *inode, umode_t mode)
+xfs_acl_set_mode(
+	struct inode		*inode,
+	umode_t			mode)
 {
-	int error = 0;
-
-	if (mode != inode->i_mode) {
-		struct iattr iattr;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
 
-		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
-		iattr.ia_mode = mode;
-		iattr.ia_ctime = current_time(inode);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
 
-		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
-	}
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	inode->i_mode = mode;
+	inode->i_ctime = current_time(inode);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	return error;
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
 }
 
 int
@@ -251,18 +259,14 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	}
 
  set_acl:
-	error =  __xfs_set_acl(inode, acl, type);
-	if (error)
-		return error;
-
 	/*
 	 * We set the mode after successfully updating the ACL xattr because the
 	 * xattr update can fail at ENOSPC and we don't want to change the mode
 	 * if the ACL update hasn't been applied.
 	 */
-	if (set_mode)
-		error = xfs_set_mode(inode, mode);
-
+	error =  __xfs_set_acl(inode, acl, type);
+	if (!error && set_mode && mode != inode->i_mode)
+		error = xfs_acl_set_mode(inode, mode);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 54c7c94f82951b..88d6dbeb81e9ca 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -648,11 +648,10 @@ xfs_vn_change_ok(
  * Caution: The caller of this function is responsible for calling
  * setattr_prepare() or otherwise verifying the change is fine.
  */
-int
+static int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
+	struct iattr		*iattr)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
@@ -809,7 +808,7 @@ xfs_setattr_nonsize(
 	 *	     to attr_set.  No previous user of the generic
 	 * 	     Posix ACL code seems to care about this issue either.
 	 */
-	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
+	if (mask & ATTR_MODE) {
 		error = posix_acl_chmod(inode, inode->i_mode);
 		if (error)
 			return error;
@@ -865,7 +864,7 @@ xfs_setattr_size(
 		 * Use the regular setattr path to update the timestamps.
 		 */
 		iattr->ia_valid &= ~ATTR_SIZE;
-		return xfs_setattr_nonsize(ip, iattr, 0);
+		return xfs_setattr_nonsize(ip, iattr);
 	}
 
 	/*
@@ -1076,7 +1075,7 @@ xfs_vn_setattr(
 
 		error = xfs_vn_change_ok(dentry, iattr);
 		if (!error)
-			error = xfs_setattr_nonsize(ip, iattr, 0);
+			error = xfs_setattr_nonsize(ip, iattr);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index a91e2d1b47b45d..99ca745c1071bf 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -13,14 +13,7 @@ extern const struct file_operations xfs_dir_file_operations;
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-/*
- * Internal setattr interfaces.
- */
-#define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
-
 extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
-extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
-			       int flags);
 extern int xfs_vn_setattr_size(struct dentry *dentry, struct iattr *vap);
 
 #endif /* __XFS_IOPS_H__ */
-- 
2.29.2

