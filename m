Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC245C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3A02072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ak1dR4KL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgBZUZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgBZUZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/9ATVj99rfXDfeHkVaeosS8d/EjwPFIUYRgdPWDJbSE=; b=Ak1dR4KLKepnWxI1ZsfOS9ZrzM
        twdF6z7KxvfMaU6ASM0vh66ZwtYLV/6Po72DvA0fx9haGcuYN21XIs7FDfJlaDqfcVqIFURolPyhq
        gZPp3ZokdINlhPtxdTJL1oy91ivww1K0KH06HDW745c1+EXsRMdYY7MAFwmyk4mIiYRe4kjrsLgQL
        RGhLexG3WUmh3uZhX/VHsslSrPUIvJ41ZzGri8eveF+/cmr6eEhdfnNgDxj1aki5zF3ZIFjburwhm
        wrBoL6h0Z1Db0+frr64XWbG0Q3wiL63LZOOIv0hzghG41b83fVhICqV+Yuus7/rfD1bupXdmOoyck
        6EPcJ95g==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73FF-0001LB-2a; Wed, 26 Feb 2020 20:25:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/32] xfs: improve xfs_forget_acl
Date:   Wed, 26 Feb 2020 12:22:59 -0800
Message-Id: <20200226202306.871241-26-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_acl.c   | 16 ++++++++++++++++
 fs/xfs/xfs_acl.h   |  6 ++++--
 fs/xfs/xfs_ioctl.c |  4 ++--
 fs/xfs/xfs_xattr.c | 26 ++------------------------
 4 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 079656da3c18..c62265cb9062 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -266,3 +266,19 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 
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
index 94615e34bc86..c042c0868016 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -13,14 +13,16 @@ struct posix_acl;
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
+static inline void xfs_forget_acl(struct inode *inode, const char *name)
+{
+}
 #endif /* CONFIG_XFS_POSIX_ACL */
 
-extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
-
 #endif	/* __XFS_ACL_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c67d2277490d..d3b5d8336583 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -510,8 +510,8 @@ xfs_attrmulti_attr_set(
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
index 260287552ad4..6e149fedd75a 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -39,28 +39,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
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
@@ -83,8 +61,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		args.flags |= ATTR_REPLACE;
 
 	error = xfs_attr_set(&args);
-	if (!error)
-		xfs_forget_acl(inode, name, args.flags);
+	if (!error && (handler->flags & ATTR_ROOT))
+		xfs_forget_acl(inode, name);
 	return error;
 }
 
-- 
2.24.1

