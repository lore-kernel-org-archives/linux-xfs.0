Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbcLBCB7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 21:01:59 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABD71CA62D
        for <linux-xfs@vger.kernel.org>; Fri,  2 Dec 2016 02:01:58 +0000 (UTC)
Received: from Liberator.local (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uB221vJe014589
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 1 Dec 2016 21:01:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: several xattr functions can be void
Message-ID: <e4c97fe1-9e48-6d17-96fb-11dfe11da5dd@redhat.com>
Date: Thu, 1 Dec 2016 20:01:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

There are a handful of xattr functions which now return
nothing but zero.  They can be made void, chased through calling
functions, and error handling etc can be removed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/xfs_attr_leaf.h |    2 -
 xfs_attr.h             |    4 +--
 xfs_attr_list.c        |   59 ++++++++++++++++++-------------------------------
 xfs_xattr.c            |   23 ++++++++-----------
 4 files changed, 35 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 4f2aed0..91f5163 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -77,7 +77,7 @@ int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
 int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
+void	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
 				      struct xfs_attr_list_context *context);
 
 /*
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index e3da5d4..d14691a 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -112,8 +112,8 @@
  *========================================================================*/
 
 
-/* Return 0 on success, or -errno; other state communicated via *context */
-typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, int,
+/* void; state communicated via *context */
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int);
 
 typedef struct xfs_attr_list_context {
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 25e76cd..97c45b6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -74,7 +74,6 @@
 	xfs_attr_sf_entry_t *sfe;
 	xfs_inode_t *dp;
 	int sbsize, nsbuf, count, i;
-	int error;
 
 	ASSERT(context != NULL);
 	dp = context->dp;
@@ -102,13 +101,11 @@
 	    (XFS_ISRESET_CURSOR(cursor) &&
              (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
-			error = context->put_listent(context,
-					   sfe->flags,
-					   sfe->nameval,
-					   (int)sfe->namelen,
-					   (int)sfe->valuelen);
-			if (error)
-				return error;
+			context->put_listent(context,
+					     sfe->flags,
+					     sfe->nameval,
+					     (int)sfe->namelen,
+					     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
 			 * didn't fit it all in the buffer after all.
@@ -193,15 +190,11 @@
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
-		error = context->put_listent(context,
-					sbp->flags,
-					sbp->name,
-					sbp->namelen,
-					sbp->valuelen);
-		if (error) {
-			kmem_free(sbuf);
-			return error;
-		}
+		context->put_listent(context,
+				     sbp->flags,
+				     sbp->name,
+				     sbp->namelen,
+				     sbp->valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
@@ -335,11 +328,7 @@
 	 */
 	for (;;) {
 		leaf = bp->b_addr;
-		error = xfs_attr3_leaf_list_int(bp, context);
-		if (error) {
-			xfs_trans_brelse(NULL, bp);
-			return error;
-		}
+		xfs_attr3_leaf_list_int(bp, context);
 		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 		if (context->seen_enough || leafhdr.forw == 0)
 			break;
@@ -356,7 +345,7 @@
 /*
  * Copy out attribute list entries for attr_list(), for leaf attribute lists.
  */
-int
+void
 xfs_attr3_leaf_list_int(
 	struct xfs_buf			*bp,
 	struct xfs_attr_list_context	*context)
@@ -366,7 +355,6 @@
 	struct xfs_attr3_icleaf_hdr	ichdr;
 	struct xfs_attr_leaf_entry	*entries;
 	struct xfs_attr_leaf_entry	*entry;
-	int				retval;
 	int				i;
 	struct xfs_mount		*mp = context->dp->i_mount;
 
@@ -399,7 +387,7 @@
 		}
 		if (i == ichdr.count) {
 			trace_xfs_attr_list_notfound(context);
-			return 0;
+			return;
 		}
 	} else {
 		entry = &entries[0];
@@ -410,7 +398,6 @@
 	/*
 	 * We have found our place, start copying out the new attributes.
 	 */
-	retval = 0;
 	for (; i < ichdr.count; entry++, i++) {
 		char *name;
 		int namelen, valuelen;
@@ -439,16 +426,14 @@
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
-		retval = context->put_listent(context, entry->flags,
+		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-		if (retval)
-			break;
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
 	}
 	trace_xfs_attr_list_leaf_end(context);
-	return retval;
+	return;
 }
 
 /*
@@ -467,9 +452,9 @@
 	if (error)
 		return error;
 
-	error = xfs_attr3_leaf_list_int(bp, context);
+	xfs_attr3_leaf_list_int(bp, context);
 	xfs_trans_brelse(NULL, bp);
-	return error;
+	return 0;
 }
 
 int
@@ -513,7 +498,7 @@
  * Take care to check values and protect against them changing later,
  * we may be reading them directly out of a user buffer.
  */
-STATIC int
+STATIC void
 xfs_attr_put_listent(
 	xfs_attr_list_context_t *context,
 	int		flags,
@@ -536,10 +521,10 @@
 	 */
 	if (((context->flags & ATTR_SECURE) == 0) !=
 	    ((flags & XFS_ATTR_SECURE) == 0))
-		return 0;
+		return;
 	if (((context->flags & ATTR_ROOT) == 0) !=
 	    ((flags & XFS_ATTR_ROOT) == 0))
-		return 0;
+		return;
 
 	arraytop = sizeof(*alist) +
 			context->count * sizeof(alist->al_offset[0]);
@@ -548,7 +533,7 @@
 		trace_xfs_attr_list_full(context);
 		alist->al_more = 1;
 		context->seen_enough = 1;
-		return 0;
+		return;
 	}
 
 	aep = (attrlist_ent_t *)&context->alist[context->firstu];
@@ -558,7 +543,7 @@
 	alist->al_offset[context->count++] = context->firstu;
 	alist->al_count = context->count;
 	trace_xfs_attr_list_add(context);
-	return 0;
+	return;
 }
 
 /*
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 6290093..0594db4 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -130,7 +130,7 @@
 	NULL
 };
 
-static int
+static void
 __xfs_xattr_put_listent(
 	struct xfs_attr_list_context *context,
 	char *prefix,
@@ -148,7 +148,7 @@
 	if (arraytop > context->firstu) {
 		context->count = -1;	/* insufficient space */
 		context->seen_enough = 1;
-		return 0;
+		return;
 	}
 	offset = (char *)context->alist + context->count;
 	strncpy(offset, prefix, prefix_len);
@@ -159,10 +159,10 @@
 
 compute_size:
 	context->count += prefix_len + namelen + 1;
-	return 0;
+	return;
 }
 
-static int
+static void
 xfs_xattr_put_listent(
 	struct xfs_attr_list_context *context,
 	int		flags,
@@ -180,23 +180,19 @@
 		if (namelen == SGI_ACL_FILE_SIZE &&
 		    strncmp(name, SGI_ACL_FILE,
 			    SGI_ACL_FILE_SIZE) == 0) {
-			int ret = __xfs_xattr_put_listent(
+			__xfs_xattr_put_listent(
 					context, XATTR_SYSTEM_PREFIX,
 					XATTR_SYSTEM_PREFIX_LEN,
 					XATTR_POSIX_ACL_ACCESS,
 					strlen(XATTR_POSIX_ACL_ACCESS));
-			if (ret)
-				return ret;
 		} else if (namelen == SGI_ACL_DEFAULT_SIZE &&
 			 strncmp(name, SGI_ACL_DEFAULT,
 				 SGI_ACL_DEFAULT_SIZE) == 0) {
-			int ret = __xfs_xattr_put_listent(
+			__xfs_xattr_put_listent(
 					context, XATTR_SYSTEM_PREFIX,
 					XATTR_SYSTEM_PREFIX_LEN,
 					XATTR_POSIX_ACL_DEFAULT,
 					strlen(XATTR_POSIX_ACL_DEFAULT));
-			if (ret)
-				return ret;
 		}
 #endif
 
@@ -205,7 +201,7 @@
 		 * see them.
 		 */
 		if (!capable(CAP_SYS_ADMIN))
-			return 0;
+			return;
 
 		prefix = XATTR_TRUSTED_PREFIX;
 		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
@@ -217,8 +213,9 @@
 		prefix_len = XATTR_USER_PREFIX_LEN;
 	}
 
-	return __xfs_xattr_put_listent(context, prefix, prefix_len, name,
-				       namelen);
+	__xfs_xattr_put_listent(context, prefix, prefix_len, name,
+				namelen);
+	return;
 }
 
 ssize_t

