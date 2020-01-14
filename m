Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59667C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F67A207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UqaHO5J7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgANIQ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:16:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgANIQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QMfusmFzD47GFFpNDP0WkrxKKE/2hxt9KoLe0B2I1nE=; b=UqaHO5J7gGolWpyFGBvWNFD+eb
        LgYlESDJ4AwvFO5dR9uqqo5Zqf29+WfHjgznE2UhjGFHS6eX3ZlPV5wl1QDdO7FWHoH4BhPBU2rPj
        WJ553opeBMPnqnmDNZxtyjXHPsmZBjSrfDFYbnkO0zE5TSbbJ2DfY9BUbduOp6lqa16fdJ3I0u7/N
        idYAJUul8RJtfBGYLzz0ztPOWiQzFQwcCKdLtV5CWLQ5NJUtqdDaJt+bmOzWMqLDmqMluEh8G+eGm
        oWF/1OD2X+djNZmDAczCbyZ1VE6eVRhPHYOeb07s7HV5JlMwupxGDeXSs8j+5Z4sRm+FkdB0anUZw
        FJR2119A==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHNE-00075S-WE; Tue, 14 Jan 2020 08:16:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 25/29] xfs: improve xfs_forget_acl
Date:   Tue, 14 Jan 2020 09:10:47 +0100
Message-Id: <20200114081051.297488-26-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114081051.297488-1-hch@lst.de>
References: <20200114081051.297488-1-hch@lst.de>
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
---
 fs/xfs/xfs_acl.c   | 16 ++++++++++++++++
 fs/xfs/xfs_acl.h   |  4 ++--
 fs/xfs/xfs_ioctl.c |  4 ++--
 fs/xfs/xfs_xattr.c | 26 ++------------------------
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 89f076e2ed7d..c993ffd9b767 100644
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
index 899a3b41fa91..7a1ff66b4786 100644
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

