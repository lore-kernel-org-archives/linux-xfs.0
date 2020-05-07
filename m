Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB857C4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC3B2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HgB0odns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEGMTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124ACC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+4WtnhZqGZBGYLip6VwyGtA1uMAalwnNYwBy56vg6bI=; b=HgB0odnsxgHcJnIsyO3tMBdEyb
        OWiJrLrGxI3H4BAzoAgr8/hE0vXXgifD9zSvsBhHrtXedII486sd3+0xGTrMHXx/LrpgBAcNzC8hT
        os+xDxpPScy0o4UxK1PTI9DqxYCiBr8HRFp9QDA7HO93fF2s+yu5eNxDpRze2MOOqhgXxW5bY0e/C
        JXrMLg/deJsJA4wp/zgJ6Oky0j0ZlHtm0CmlBgWRJYiJ7/BdSIAYJDlvNTr8Xp/1Nt91kMofaA/rm
        t6iE26NEKaoVbaSDHbm720U2Y32EEV4AIEv2oXGpJJkfzZQaFfPydoaWvHZ/w46CuSJs+zdgc1K62
        XQc+fR0w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUz-00059m-If; Thu, 07 May 2020 12:19:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/58] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Date:   Thu,  7 May 2020 14:18:09 +0200
Message-Id: <20200507121851.304002-17-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: d49db18b247d8e7e16f2178cd713f4621d1d7ade

Use a NULL args->value as the indicator to lazily allocate a buffer
instead, and let the caller always free args->value instead of
duplicating the cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      | 20 +++++---------------
 libxfs/xfs_attr.h      |  7 ++-----
 libxfs/xfs_attr_leaf.c |  2 +-
 libxfs/xfs_da_btree.h  |  2 --
 4 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 72e25256..62bed271 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index fe064cd8..a6de0506 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8e07e2a0..fb07d1de 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -474,7 +474,7 @@ xfs_attr_copy_value(
 		return -ERANGE;
 	}
 
-	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
+	if (!args->value) {
 		args->value = kmem_alloc_large(valuelen, 0);
 		if (!args->value)
 			return -ENOMEM;
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 0967d1bd..dd1ac522 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
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
-- 
2.26.2

