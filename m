Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3A7E7CA4
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:11:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6725304032
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:11:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EuPM4octX7amcBFX for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 14:11:15 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EE9682AD4
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:11:01 -0600 (CST)
Subject: [PATCH 1/4] xfs: only return -errno or success from attr ->put_listent
References: <56E3425E.40509@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E34282.5050906@sandeen.net>
Date: Fri, 11 Mar 2016 16:11:14 -0600
MIME-Version: 1.0
In-Reply-To: <56E3425E.40509@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Today, the put_listent formatters return either 1 or 0; if
they return 1, some callers treat this as an error and return
it up the stack, despite "1" not being a valid (negative)
error code.

The intent seems to be that if the input buffer is full,
we set seen_enough or set count = -1, and return 1;
but some callers check the return before checking the
seen_enough or count fields of the context.

Fix this by only returning non-zero for actual errors
encountered, and rely on the caller to first check the
return value, then check the values in the context to
decide what to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_attr.h      |    1 +
 fs/xfs/xfs_attr_list.c |    8 +++-----
 fs/xfs/xfs_xattr.c     |   14 ++++++++++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index dd48245..2343312 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -112,6 +112,7 @@ typedef struct attrlist_cursor_kern {
  *========================================================================*/
 
 
+/* Return 0 on success, or -errno; other state communicated via *context */
 typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int, unsigned char *);
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0ef7c2e..d5ab59f 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -108,16 +108,14 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					   (int)sfe->namelen,
 					   (int)sfe->valuelen,
 					   &sfe->nameval[sfe->namelen]);
-
+			if (error)
+				return error;
 			/*
 			 * Either search callback finished early or
 			 * didn't fit it all in the buffer after all.
 			 */
 			if (context->seen_enough)
 				break;
-
-			if (error)
-				return error;
 			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
 		}
 		trace_xfs_attr_list_sf_all(context);
@@ -580,7 +578,7 @@ xfs_attr_put_listent(
 		trace_xfs_attr_list_full(context);
 		alist->al_more = 1;
 		context->seen_enough = 1;
-		return 1;
+		return 0;
 	}
 
 	aep = (attrlist_ent_t *)&context->alist[context->firstu];
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 110f1d7..f220129 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -146,7 +146,7 @@ __xfs_xattr_put_listent(
 	arraytop = context->count + prefix_len + namelen + 1;
 	if (arraytop > context->firstu) {
 		context->count = -1;	/* insufficient space */
-		return 1;
+		return 0;
 	}
 	offset = (char *)context->alist + context->count;
 	strncpy(offset, prefix, prefix_len);
@@ -221,11 +221,15 @@ xfs_xattr_put_listent(
 }
 
 ssize_t
-xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
+xfs_vn_listxattr(
+	struct dentry	*dentry,
+	char		*data,
+	size_t		size)
 {
 	struct xfs_attr_list_context context;
 	struct attrlist_cursor_kern cursor = { 0 };
-	struct inode		*inode = d_inode(dentry);
+	struct inode	*inode = d_inode(dentry);
+	int		error;
 
 	/*
 	 * First read the regular on-disk attributes.
@@ -239,7 +243,9 @@ xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
-	xfs_attr_list_int(&context);
+	error = xfs_attr_list_int(&context);
+	if (error)
+		return error;
 	if (context.count < 0)
 		return -ERANGE;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
