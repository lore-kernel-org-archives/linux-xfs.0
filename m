Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A820C001DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 15:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjGXPoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGXPoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 11:44:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C710121
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SqSZx4AJs6yPI+E7neTlkL/SJhFHeLCtpYjo/tn37N8=; b=VfKcQVxc1Wuh7RSqgz7i6DDOrW
        U0hDmIY1urDkg5sn9Rw2pSNMgsZEh3TGFvqw/4YY/MvhN9Src6OtPcSECdUbWjzryC61ZqmJ1t99u
        GM4iJbu2nlrI4DMO/F0zRE3jK/3E4glXlDb91gbpXcnOuVZGtGJ2bqNZEQ9aCuna2u2O0iBrPq6Hr
        feyvaUPFlktf4vGgn4x8350u4vYhpbeFU6kMI86DY4ueCBsUKXr2Cew2CnsFfkGIxMmFc2OQHiXCr
        B0VQpcxJnuYm2FmLz6kTD+J+mXmq4MzTVa9hbU1C+VnmjhlVGdh8WFvyhm876nJ1KcS9Jm06QBlEL
        7wvclJOg==;
Received: from 67-207-104-238.static.wiline.com ([67.207.104.238] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qNxjB-004ldW-0O;
        Mon, 24 Jul 2023 15:44:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the XFS_IOC_ATTRLIST_BY_HANDLE definitions out of xfs_fs.h
Date:   Mon, 24 Jul 2023 08:44:04 -0700
Message-Id: <20230724154404.34524-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230724154404.34524-1-hch@lst.de>
References: <20230724154404.34524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_attrlist and xfs_attrlist_ent structures as well as the
XFS_ATTR_* flags used by the XFS_IOC_ATTRLIST_BY_HANDLE are a very
odd and special kind of UAPI in that there is no userspace actually
ever using the definition.  The reason for that is that libattr has
copies of these definitions without the xfs_ prefix that are used
by libattr for the emulation of the IRIX-style attr calls, to which
XFS_IOC_ATTRLIST_BY_HANDLE is an extension, and users of
XFS_IOC_ATTRLIST_BY_HANDLE like xfsdump (though libhandle in xfsprogs)
use that definition.

So far, so odd, but with the change away from the deprecated and
dangerous "[1]" syntax for variable sized array, the kernel now
has actually changed the sizeof these structures, so even if some
obscure unkown userspace actually used it, it could easily get in
trouble next time xfs_fs.h gets synced to xfsprogs and it picks it up.

Move the definition to a new private xfs_ioctl_attr.h so that it
stops getting exposed in xfsprogs with the next sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  | 36 -------------------------------
 fs/xfs/xfs_ioctl.c      |  1 +
 fs/xfs/xfs_ioctl_attr.h | 48 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 36 deletions(-)
 create mode 100644 fs/xfs/xfs_ioctl_attr.h

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2cbf9ea39b8cc4..d069a72b8ae246 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -560,46 +560,10 @@ typedef struct xfs_fsop_handlereq {
 	__u32		__user *ohandlen;/* user buffer length		*/
 } xfs_fsop_handlereq_t;
 
-/*
- * Compound structures for passing args through Handle Request interfaces
- * xfs_attrlist_by_handle, xfs_attrmulti_by_handle
- * - ioctls: XFS_IOC_ATTRLIST_BY_HANDLE, and XFS_IOC_ATTRMULTI_BY_HANDLE
- */
-
-/*
- * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
- *
- * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
- */
-#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
-#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
-#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
-#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
-
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
 } xfs_attrlist_cursor_t;
 
-/*
- * Define how lists of attribute names are returned to userspace from the
- * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
- * beginning of the returned buffer, and a each entry in al_offset contains the
- * relative offset of an xfs_attrlist_ent containing the actual entry.
- *
- * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
- * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
- */
-struct xfs_attrlist {
-	__s32	al_count;	/* number of entries in attrlist */
-	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
-};
-
-struct xfs_attrlist_ent {	/* data from attr_list() */
-	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[];	/* attr name (NULL terminated) */
-};
-
 typedef struct xfs_fsop_attrlist_handlereq {
 	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
 	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde8c..7d9154e0e198f6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_ioctl_attr.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_ioctl_attr.h b/fs/xfs/xfs_ioctl_attr.h
new file mode 100644
index 00000000000000..7bf3046665c322
--- /dev/null
+++ b/fs/xfs/xfs_ioctl_attr.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (c) 1995-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef _XFS_ATTR_IOCTL_H
+#define _XFS_ATTR_IOCTL_H
+
+/*
+ * Attr structures for passing through XFS_IOC_ATTRLIST_BY_HANDLE.
+ *
+ * These are UAPIs, but in a rather strange way - nothing in userspace uses
+ * these declarations directly, but instead they use separate definitions
+ * in libattr that are derived from the same IRIX interface and must stay
+ * binary compatible forever.  They generally match the names in this file,
+ * but without the xfs_ or XFS_ prefix.
+ *
+ * For extra fun the kernel version has replace the [1] sized arrays for
+ * variable sized parts with the newer [] syntax that produces the same
+ * structure layout, but can produce different sizeof results.
+ */
+
+/*
+ * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
+ */
+#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
+#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
+#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
+#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+
+/*
+ * Define how lists of attribute names are returned to userspace from the
+ * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
+ * beginning of the returned buffer, and a each entry in al_offset contains the
+ * relative offset of an xfs_attrlist_ent containing the actual entry.
+ */
+struct xfs_attrlist {
+	__s32	al_count;	/* number of entries in attrlist */
+	__s32	al_more;	/* T/F: more attrs (do call again) */
+	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
+};
+
+struct xfs_attrlist_ent {	/* data from attr_list() */
+	__u32	a_valuelen;	/* number bytes in value of attr */
+	char	a_name[];	/* attr name (NULL terminated) */
+};
+
+#endif /* _XFS_ATTR_IOCTL_H */
-- 
2.39.2

