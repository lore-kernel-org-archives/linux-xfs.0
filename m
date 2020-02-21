Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21FCC3565E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B73F82073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TTta92eC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgBUOL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgBUOL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wpU+2YNqoFgk/sp02qqBSIIAG7SM7XEEImCP8x9zSLA=; b=TTta92eCUHMaRM1X+rAS9k+Jp1
        x6K0kqubbZke2XnBS5q+E1L3LFXHovHX+ivjnHTael9YkX7o6fZu00s6KfrB/GiirW27Eh/7iFFwL
        DCjewNl27EPqSvAswss8CmGh0cHIY4Z6ex6vZvqy1MZ8rQPJQowpV1VU2a5r8poPO5XiY6x3iAX60
        3tA51fTMX6use12Z7AF1dB2jqmmYUQIfsbtBSgdDPQwpTwScojfWY6sVUbKSvAg6KOjtaICvPQNmO
        ijul3zxscykYqPO6GNlOcZlEa6n97ubH22IC3x02lDH+v/+Vaxi95yyCNFP0UgcTU8szrppSk1q+n
        95VUYBXw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5926-0000Hw-6A; Fri, 21 Feb 2020 14:11:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 15/31] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Fri, 21 Feb 2020 06:11:38 -0800
Message-Id: <20200221141154.476496-16-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_attr.c      | 20 +++++---------------
 fs/xfs/libxfs/xfs_attr.h      |  7 ++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_types.h     |  2 --
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
index 780924984492..bc78b7c33401 100644
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
 	int			error;
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
2.24.1

