Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeH1XSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJRqt097573
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:03 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2m2xhtnxs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:03 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJP2NM032453
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:02 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7SJP2ro003090
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:02 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 25/28] xfs: Add helper function xfs_attr_list_context_init
Date: Tue, 28 Aug 2018 12:22:38 -0700
Message-Id: <1535484161-11059-26-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_list_context_init
used by xfs_attr_list.  This function initializes the
xfs_attr_list_context structure passed to xfs_attr_list_int.
We will need this later to call xfs_attr_list_int_ilocked when
the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h |  3 ++
 fs/xfs/xfs_attr_list.c   | 72 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 14cb7c1..913dcb7 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -188,6 +188,9 @@ int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
+int xfs_attr_list_context_init(struct xfs_inode *dp, char *buffer, int bufsize,
+		int flags, struct attrlist_cursor_kern *cursor,
+		struct xfs_attr_list_context *context);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a580340..3c30ec4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -592,23 +592,19 @@ xfs_attr_put_listent(
 }
 
 /*
- * Generate a list of extended attribute names and optionally
- * also value lengths.  Positive return value follows the XFS
- * convention of being an error, zero or negative return code
- * is the length of the buffer returned (negated), indicating
- * success.
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
  */
 int
-xfs_attr_list(
-	xfs_inode_t	*dp,
-	char		*buffer,
-	int		bufsize,
-	int		flags,
-	attrlist_cursor_kern_t *cursor)
+xfs_attr_list_context_init(
+	xfs_inode_t			*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct attrlist_cursor_kern	*cursor,
+	struct xfs_attr_list_context	*context)
 {
-	xfs_attr_list_context_t context;
 	struct attrlist *alist;
-	int error;
 
 	/*
 	 * Validate the cursor.
@@ -634,20 +630,46 @@ xfs_attr_list(
 	/*
 	 * Initialize the output buffer.
 	 */
-	memset(&context, 0, sizeof(context));
-	context.dp = dp;
-	context.cursor = cursor;
-	context.resynch = 1;
-	context.flags = flags;
-	context.alist = buffer;
-	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_attr_put_listent;
-
-	alist = (struct attrlist *)context.alist;
+	memset(context, 0, sizeof(xfs_attr_list_context_t));
+	context->dp = dp;
+	context->cursor = cursor;
+	context->resynch = 1;
+	context->flags = flags;
+	context->alist = buffer;
+	context->bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_attr_put_listent;
+
+	alist = (struct attrlist *)context->alist;
 	alist->al_count = 0;
 	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+/*
+ * Generate a list of extended attribute names and optionally
+ * also value lengths.  Positive return value follows the XFS
+ * convention of being an error, zero or negative return code
+ * is the length of the buffer returned (negated), indicating
+ * success.
+ */
+int
+xfs_attr_list(
+	xfs_inode_t		*dp,
+	char			*buffer,
+	int			bufsize,
+	int			flags,
+	attrlist_cursor_kern_t	*cursor)
+{
+	xfs_attr_list_context_t context;
+	int			error;
+
+	error = xfs_attr_list_context_init(dp, buffer, bufsize, flags,
+			cursor, &context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list_int(&context);
 	ASSERT(error <= 0);
-- 
2.7.4
