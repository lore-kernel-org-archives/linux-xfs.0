Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A940C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F63B2070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hd96bFsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgA2RES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:04:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgA2RES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AX/WOHUABEeOvZCzRV3Gh3fSYuQuDPag68qK33JaWj0=; b=Hd96bFsm2sZ3VvWnM08QPyZ1CE
        UXaldzLVm/YKTp4m1h2XTje5faDonlwnn3AlO1VBBOKzJ31SlC6PHqYDuNLxbUrvVgom18Vu1QncO
        q3sTvghF3Z1c3XkH3NhY7HotEuJiAeZcoVK8RCD7YkKNhLC0PiFzA8o0sWRmKkmQKBl3RoikZihBo
        gyn9VrYhkVLcJgmt5gsUkmCTUM+iYy/W+ypsLJ0gHbjMNmLakdRm39brUU1ihArsIPJfH9DnDDnjf
        wUrOgv8/bIREyIePwQtwiJv7q3gwUnXW5tdv1Fb8MrkVJx7HaUP8mwdzlN7z7P7ZF65jE0vpYxqFU
        it+ngO+g==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqlG-00070P-2w; Wed, 29 Jan 2020 17:04:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/30] xfs: improve xfs_forget_acl
Date:   Wed, 29 Jan 2020 18:03:05 +0100
Message-Id: <20200129170310.51370-27-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the function to xfs_acl.c and provide a proper stub for the
!CONFIG_XFS_POSIX_ACL case.  Lift the flags check to the caller as it
nicely fits in there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_acl.c   | 16 ++++++++++++++++
 fs/xfs/xfs_acl.h   |  4 ++--
 fs/xfs/xfs_ioctl.c |  4 ++--
 fs/xfs/xfs_xattr.c | 26 ++------------------------
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index bc78b7c33401..e9a48d718c3a 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -264,3 +264,19 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 
 	return error;
 }
+
+/*
+ * Invalidate any cached ACLs if the user has bypassed the ACL interface.
+ * We don't validate the content whatsoever so it is caller responsibility to
+ * provide data in valid format and ensure i_mode is consistent.
+ */
+void
+xfs_forget_acl(
+	struct inode		*inode,
+	const char		*name)
+{
+	if (!strcmp(name, SGI_ACL_FILE))
+		forget_cached_acl(inode, ACL_TYPE_ACCESS);
+	else if (!strcmp(name, SGI_ACL_DEFAULT))
+		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
+}
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 94615e34bc86..bd8a306046a9 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -13,14 +13,14 @@ struct posix_acl;
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
+void xfs_forget_acl(struct inode *inode, const char *name);
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
 	return NULL;
 }
 # define xfs_set_acl					NULL
+# define xfs_forget_acl(inode, name)			0
 #endif /* CONFIG_XFS_POSIX_ACL */
 
-extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
-
 #endif	/* __XFS_ACL_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5d160e82778e..4f26c3962215 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -509,8 +509,8 @@ xfs_attrmulti_attr_set(
 	}
 
 	error = xfs_attr_set(&args);
-	if (!error)
-		xfs_forget_acl(inode, name, flags);
+	if (!error && (flags & ATTR_ROOT))
+		xfs_forget_acl(inode, name);
 	kfree(args.value);
 	return error;
 }
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index e1951d2b878e..863e9fdec162 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -37,28 +37,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	return args.valuelen;
 }
 
-void
-xfs_forget_acl(
-	struct inode		*inode,
-	const char		*name,
-	int			xflags)
-{
-	/*
-	 * Invalidate any cached ACLs if the user has bypassed the ACL
-	 * interface. We don't validate the content whatsoever so it is caller
-	 * responsibility to provide data in valid format and ensure i_mode is
-	 * consistent.
-	 */
-	if (xflags & ATTR_ROOT) {
-#ifdef CONFIG_XFS_POSIX_ACL
-		if (!strcmp(name, SGI_ACL_FILE))
-			forget_cached_acl(inode, ACL_TYPE_ACCESS);
-		else if (!strcmp(name, SGI_ACL_DEFAULT))
-			forget_cached_acl(inode, ACL_TYPE_DEFAULT);
-#endif
-	}
-}
-
 static int
 xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, const void *value,
@@ -81,8 +59,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		args.flags |= ATTR_REPLACE;
 
 	error = xfs_attr_set(&args);
-	if (!error)
-		xfs_forget_acl(inode, name, args.flags);
+	if (!error && (flags & ATTR_ROOT))
+		xfs_forget_acl(inode, name);
 	return error;
 }
 
-- 
2.24.1

