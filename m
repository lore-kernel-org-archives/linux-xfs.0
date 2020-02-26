Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51C3C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFCC24670
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nzj9E3zX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBZUY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:24:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3BxufE7W4khx9w3WZQlDWfEkDnNdQhD9GiQHmuOH+NU=; b=Nzj9E3zXcMr1joxTMHg+Rbx9qH
        EXzB03wPgpGB9vfP7oOZ1Py/6ARsO7aUDzrcV1xOZ80sLpEj5bysvbHIi4lqqcqsJV3QlSL0ye1W6
        iAKZfGGrFxX51fOpda0KExF3qbyJXBed8OfansEDGze8voW2XQMokedBb3586vEE3I9xx60Yi7VIz
        32StnggY3TMSR+JQm01QusjlcS78UU7pQM/Rkwg28bvu08wi0Hl/BcjNxPtvNPP7ReIM81u1ISc0e
        qUVP626oRjZQ8JiRLbVGKXKmIbTjv+l9x4RDQHw1NyK7WwiKJui5oWxZ/MyQli8FnAakYoICDk0bX
        k7n3L0LA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73EI-0008Rh-Pp; Wed, 26 Feb 2020 20:24:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/32] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Wed, 26 Feb 2020 12:22:48 -0800
Message-Id: <20200226202306.871241-15-hch@lst.de>
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

Use a NULL args->value as the indicator to lazily allocate a buffer
instead, and let the caller always free args->value instead of
duplicating the cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 20 +++++---------------
 fs/xfs/libxfs/xfs_attr.h      |  7 ++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_da_btree.h  |  2 --
 fs/xfs/xfs_acl.c              | 20 ++++++++++----------
 5 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 469417786bfc..1382e51ef85e 100644
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
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0967d1bd3ceb..dd1ac522b3e8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -88,7 +88,6 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
 #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
@@ -97,7 +96,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
 	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 468dd7c6b406..079656da3c18 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -127,7 +127,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct posix_acl	*acl = NULL;
 	struct xfs_da_args	args = {
 		.dp		= ip,
-		.flags		= ATTR_ALLOC | ATTR_ROOT,
+		.flags		= ATTR_ROOT,
 		.valuelen	= XFS_ACL_MAX_SIZE(mp),
 	};
 	int			error;
@@ -146,19 +146,19 @@ xfs_get_acl(struct inode *inode, int type)
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
2.24.1

