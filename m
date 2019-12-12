Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A310C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E9A2077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pizh3TPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfLLKzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:55:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbfLLKzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X85ESZmvjyOfLpAKulrJ+tUGSCDLwyIkSMPzbBpFuNE=; b=pizh3TPq6bjt1RoCxqq6EPViVJ
        D02hj7t+sNEDw33XZmwDbXlAuvG6IVmYODLW2DQIGuOxHq+Oc4AEka0qJkfqWE2MTHfFaF4+Vcwz7
        vLy9KCar++9/3l1CtWFLwykeAQ/5MB4JlnTR436MlGqjmcglx8rUnvpxOgEafJhQXjErJKlH2dVNY
        u8ctRpaPN3BxUb0hBSakdGkKScE9IVe7tXBxwj0T2jFMkic6jXCkJYiOaI2yFiL5VPQZKTVoybZKJ
        lsdO5jxG/0eVjbRbvEdbnjMVezLM9JQTadPuo1unUGldEB6UvfWCCjsd3perzFib5WbAyqBI4u2yi
        CEIO75FQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7s-0002SS-Pp; Thu, 12 Dec 2019 10:55:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 18/33] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Thu, 12 Dec 2019 11:54:18 +0100
Message-Id: <20191212105433.1692-19-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use a NULL args->value as the indicator to lazily allocate a buffer
instead, and let the caller always free args->value instead of
duplicating the cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      | 20 +++++---------------
 fs/xfs/libxfs/xfs_attr.h      |  7 ++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_types.h     |  2 --
 fs/xfs/xfs_acl.c              | 20 ++++++++++----------
 5 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c4e8ac38d5a..c362dbab1a6a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -98,15 +98,14 @@ xfs_attr_get_ilocked(
  * indication whether the attribute exists and the size of the value if it
  * exists. The size is returned in args.valuelen.
  *
+ * If args->value is NULL but args->valuelen is non-zero, allocate the buffer
+ * for the value after existence of the attribute has been determined. The
+ * caller always has to free args->value if it is set, no matter if this
+ * function was successful or not.
+ *
  * If the attribute is found, but exceeds the size limit set by the caller in
  * args->valuelen, return -ERANGE with the size of the attribute that was found
  * in args->valuelen.
- *
- * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
- * existence of the attribute has been determined. On success, return that
- * buffer to the caller and leave them to free it. On failure, free any
- * allocated buffer and ensure the buffer pointer returned to the caller is
- * null.
  */
 int
 xfs_attr_get(
@@ -115,8 +114,6 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
-
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
@@ -128,18 +125,11 @@ xfs_attr_get(
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
-	if (args->flags & ATTR_ALLOC)
-		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
 	error = xfs_attr_get_ilocked(args);
 	xfs_iunlock(args->dp, lock_mode);
 
-	/* on error, we have to clean up allocated value buffers */
-	if (error && (args->flags & ATTR_ALLOC)) {
-		kmem_free(args->value);
-		args->value = NULL;
-	}
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index fe064cd81747..a6de050675c9 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -35,10 +35,8 @@ struct xfs_attr_list_context;
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 
-#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
-
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_ALLOC)
+	(ATTR_KERNOTIME)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -47,8 +45,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
-	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
-	{ ATTR_ALLOC,		"ALLOC" }
+	{ ATTR_KERNOTIME,	"KERNOTIME" }
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5e700dfc48a9..b0658eb8fbcc 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -477,7 +477,7 @@ xfs_attr_copy_value(
 		return -ERANGE;
 	}
 
-	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
+	if (!args->value) {
 		args->value = kmem_alloc_large(valuelen, 0);
 		if (!args->value)
 			return -ENOMEM;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 634814dd1d10..3379ebc0c7c5 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -223,7 +223,6 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
 #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
@@ -232,7 +231,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
 	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index c72003b73926..7d417e6b1484 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -125,7 +125,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct posix_acl	*acl = NULL;
 	struct xfs_da_args	args = {
 		.dp		= ip,
-		.flags		= ATTR_ALLOC | ATTR_ROOT,
+		.flags		= ATTR_ROOT,
 		.valuelen	= XFS_ACL_MAX_SIZE(mp),
 	};
 	int error;
@@ -144,19 +144,19 @@ xfs_get_acl(struct inode *inode, int type)
 	}
 	args.namelen = strlen(args.name);
 
+	/*
+	 * If the attribute doesn't exist make sure we have a negative cache
+	 * entry, for any other error assume it is transient.
+	 */
 	error = xfs_attr_get(&args);
-	if (error) {
-		/*
-		 * If the attribute doesn't exist make sure we have a negative
-		 * cache entry, for any other error assume it is transient.
-		 */
-		if (error != -ENOATTR)
-			acl = ERR_PTR(error);
-	} else  {
+	if (!error) {
 		acl = xfs_acl_from_disk(mp, args.value, args.valuelen,
 					XFS_ACL_MAX_ENTRIES(mp));
-		kmem_free(args.value);
+	} else if (error != -ENOATTR) {
+		acl = ERR_PTR(error);
 	}
+
+	kmem_free(args.value);
 	return acl;
 }
 
-- 
2.20.1

