Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 08:17:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EFHCX4010836
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 08:17:14 -0700
Date: Sat, 14 Jun 2008 17:17:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] simplify xfs_vn_listxattr
Message-ID: <20080614151756.GA11331@lst.de>
References: <20080603114837.GB2703@lst.de> <4851F30C.4000108@sgi.com> <20080613162433.GA23022@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613162433.GA23022@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 13, 2008 at 06:24:33PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 13, 2008 at 02:09:48PM +1000, Timothy Shimmin wrote:
> > This appears to break xfstests/063 (EA xfsdump test).
> 
> Indeed, I did some stupid last minute changes after running it through
> xfsqa.  Here's the updated version which makes 063 happy again:

Needs another update to fix a (harmless) warning:


Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-06-14 17:14:30.000000000 +0200
@@ -16,8 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/capability.h>
-
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
@@ -607,12 +605,20 @@ xfs_attr_remove(
 	return xfs_attr_remove_int(dp, &xname, flags);
 }
 
-STATIC int
+int
 xfs_attr_list_int(xfs_attr_list_context_t *context)
 {
 	int error;
 	xfs_inode_t *dp = context->dp;
 
+	XFS_STATS_INC(xs_attr_list);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return EIO;
+
+	xfs_ilock(dp, XFS_ILOCK_SHARED);
+	xfs_attr_trace_l_c("syscall start", context);
+
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
@@ -625,6 +631,10 @@ xfs_attr_list_int(xfs_attr_list_context_
 	} else {
 		error = xfs_attr_node_list(context);
 	}
+
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+	xfs_attr_trace_l_c("syscall end", context);
+
 	return error;
 }
 
@@ -641,74 +651,50 @@ xfs_attr_list_int(xfs_attr_list_context_
  */
 /*ARGSUSED*/
 STATIC int
-xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
+xfs_attr_put_listent(xfs_attr_list_context_t *context, int flags,
 		     char *name, int namelen,
 		     int valuelen, char *value)
 {
+	struct attrlist *alist = (struct attrlist *)context->alist;
 	attrlist_ent_t *aep;
 	int arraytop;
 
 	ASSERT(!(context->flags & ATTR_KERNOVAL));
 	ASSERT(context->count >= 0);
 	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
-	ASSERT(context->firstu >= sizeof(*context->alist));
+	ASSERT(context->firstu >= sizeof(*alist));
 	ASSERT(context->firstu <= context->bufsize);
 
-	arraytop = sizeof(*context->alist) +
-			context->count * sizeof(context->alist->al_offset[0]);
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if (((context->flags & ATTR_SECURE) == 0) !=
+	    ((flags & XFS_ATTR_SECURE) == 0))
+		return 0;
+	if (((context->flags & ATTR_ROOT) == 0) !=
+	    ((flags & XFS_ATTR_ROOT) == 0))
+		return 0;
+
+	arraytop = sizeof(*alist) +
+			context->count * sizeof(alist->al_offset[0]);
 	context->firstu -= ATTR_ENTSIZE(namelen);
 	if (context->firstu < arraytop) {
 		xfs_attr_trace_l_c("buffer full", context);
-		context->alist->al_more = 1;
+		alist->al_more = 1;
 		context->seen_enough = 1;
 		return 1;
 	}
 
-	aep = (attrlist_ent_t *)&(((char *)context->alist)[ context->firstu ]);
+	aep = (attrlist_ent_t *)&context->alist[context->firstu];
 	aep->a_valuelen = valuelen;
 	memcpy(aep->a_name, name, namelen);
-	aep->a_name[ namelen ] = 0;
-	context->alist->al_offset[ context->count++ ] = context->firstu;
-	context->alist->al_count = context->count;
+	aep->a_name[namelen] = 0;
+	alist->al_offset[context->count++] = context->firstu;
+	alist->al_count = context->count;
 	xfs_attr_trace_l_c("add", context);
 	return 0;
 }
 
-STATIC int
-xfs_attr_kern_list(xfs_attr_list_context_t *context, attrnames_t *namesp,
-		     char *name, int namelen,
-		     int valuelen, char *value)
-{
-	char *offset;
-	int arraytop;
-
-	ASSERT(context->count >= 0);
-
-	arraytop = context->count + namesp->attr_namelen + namelen + 1;
-	if (arraytop > context->firstu) {
-		context->count = -1;	/* insufficient space */
-		return 1;
-	}
-	offset = (char *)context->alist + context->count;
-	strncpy(offset, namesp->attr_name, namesp->attr_namelen);
-	offset += namesp->attr_namelen;
-	strncpy(offset, name, namelen);			/* real name */
-	offset += namelen;
-	*offset = '\0';
-	context->count += namesp->attr_namelen + namelen + 1;
-	return 0;
-}
-
-/*ARGSUSED*/
-STATIC int
-xfs_attr_kern_list_sizes(xfs_attr_list_context_t *context, attrnames_t *namesp,
-		     char *name, int namelen,
-		     int valuelen, char *value)
-{
-	context->count += namesp->attr_namelen + namelen + 1;
-	return 0;
-}
-
 /*
  * Generate a list of extended attribute names and optionally
  * also value lengths.  Positive return value follows the XFS
@@ -725,10 +711,9 @@ xfs_attr_list(
 	attrlist_cursor_kern_t *cursor)
 {
 	xfs_attr_list_context_t context;
+	struct attrlist *alist;
 	int error;
 
-	XFS_STATS_INC(xs_attr_list);
-
 	/*
 	 * Validate the cursor.
 	 */
@@ -749,52 +734,23 @@ xfs_attr_list(
 	/*
 	 * Initialize the output buffer.
 	 */
+	memset(&context, 0, sizeof(context));
 	context.dp = dp;
 	context.cursor = cursor;
-	context.count = 0;
-	context.dupcnt = 0;
 	context.resynch = 1;
 	context.flags = flags;
-	context.seen_enough = 0;
-	context.alist = (attrlist_t *)buffer;
-	context.put_value = 0;
-
-	if (flags & ATTR_KERNAMELS) {
-		context.bufsize = bufsize;
-		context.firstu = context.bufsize;
-		if (flags & ATTR_KERNOVAL)
-			context.put_listent = xfs_attr_kern_list_sizes;
-		else
-			context.put_listent = xfs_attr_kern_list;
-	} else {
-		context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
-		context.firstu = context.bufsize;
-		context.alist->al_count = 0;
-		context.alist->al_more = 0;
-		context.alist->al_offset[0] = context.bufsize;
-		context.put_listent = xfs_attr_put_listent;
-	}
-
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return EIO;
-
-	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	xfs_attr_trace_l_c("syscall start", &context);
+	context.alist = buffer;
+	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
+	context.firstu = context.bufsize;
+	context.put_listent = xfs_attr_put_listent;
+
+	alist = (struct attrlist *)context.alist;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context.bufsize;
 
 	error = xfs_attr_list_int(&context);
-
-	xfs_iunlock(dp, XFS_ILOCK_SHARED);
-	xfs_attr_trace_l_c("syscall end", &context);
-
-	if (context.flags & (ATTR_KERNOVAL|ATTR_KERNAMELS)) {
-		/* must return negated buffer size or the error */
-		if (context.count < 0)
-			error = XFS_ERROR(ERANGE);
-		else
-			error = -context.count;
-	} else
-		ASSERT(error >= 0);
-
+	ASSERT(error >= 0);
 	return error;
 }
 
@@ -2357,12 +2313,7 @@ xfs_attr_trace_enter(int type, char *whe
 		(void *)((__psunsigned_t)context->bufsize),
 		(void *)((__psunsigned_t)context->count),
 		(void *)((__psunsigned_t)context->firstu),
-		(void *)((__psunsigned_t)
-			(((context->count > 0) &&
-			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
-				? (ATTR_ENTRY(context->alist,
-					      context->count-1)->a_valuelen)
-				: 0)),
+		NULL,
 		(void *)((__psunsigned_t)context->dupcnt),
 		(void *)((__psunsigned_t)context->flags),
 		(void *)a13, (void *)a14, (void *)a15);
Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.c	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c	2008-06-14 17:14:30.000000000 +0200
@@ -94,13 +94,6 @@ STATIC int xfs_attr_leaf_entsize(xfs_att
  * Namespace helper routines
  *========================================================================*/
 
-STATIC_INLINE attrnames_t *
-xfs_attr_flags_namesp(int flags)
-{
-	return ((flags & XFS_ATTR_SECURE) ? &attr_secure:
-		  ((flags & XFS_ATTR_ROOT) ? &attr_trusted : &attr_user));
-}
-
 /*
  * If namespace bits don't match return 0.
  * If all match then return 1.
@@ -111,25 +104,6 @@ xfs_attr_namesp_match(int arg_flags, int
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
 }
 
-/*
- * If namespace bits don't match and we don't have an override for it
- * then return 0.
- * If all match or are overridable then return 1.
- */
-STATIC_INLINE int
-xfs_attr_namesp_match_overrides(int arg_flags, int ondisk_flags)
-{
-	if (((arg_flags & ATTR_SECURE) == 0) !=
-	    ((ondisk_flags & XFS_ATTR_SECURE) == 0) &&
-	    !(arg_flags & ATTR_KERNORMALS))
-		return 0;
-	if (((arg_flags & ATTR_ROOT) == 0) !=
-	    ((ondisk_flags & XFS_ATTR_ROOT) == 0) &&
-	    !(arg_flags & ATTR_KERNROOTLS))
-		return 0;
-	return 1;
-}
-
 
 /*========================================================================
  * External routines when attribute fork size < XFS_LITINO(mp).
@@ -626,15 +600,8 @@ xfs_attr_shortform_list(xfs_attr_list_co
 	    (XFS_ISRESET_CURSOR(cursor) &&
              (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
-			attrnames_t	*namesp;
-
-			if (!xfs_attr_namesp_match_overrides(context->flags, sfe->flags)) {
-				sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
-				continue;
-			}
-			namesp = xfs_attr_flags_namesp(sfe->flags);
 			error = context->put_listent(context,
-					   namesp,
+					   sfe->flags,
 					   (char *)sfe->nameval,
 					   (int)sfe->namelen,
 					   (int)sfe->valuelen,
@@ -681,10 +648,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 			kmem_free(sbuf);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
-		if (!xfs_attr_namesp_match_overrides(context->flags, sfe->flags)) {
-			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
-			continue;
-		}
+
 		sbp->entno = i;
 		sbp->hash = xfs_da_hashname((char *)sfe->nameval, sfe->namelen);
 		sbp->name = (char *)sfe->nameval;
@@ -728,16 +692,12 @@ xfs_attr_shortform_list(xfs_attr_list_co
 	 * Loop putting entries into the user buffer.
 	 */
 	for ( ; i < nsbuf; i++, sbp++) {
-		attrnames_t	*namesp;
-
-		namesp = xfs_attr_flags_namesp(sbp->flags);
-
 		if (cursor->hashval != sbp->hash) {
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
 		error = context->put_listent(context,
-					namesp,
+					sbp->flags,
 					sbp->name,
 					sbp->namelen,
 					sbp->valuelen,
@@ -2402,8 +2362,6 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 	 */
 	retval = 0;
 	for (  ; (i < be16_to_cpu(leaf->hdr.count)); entry++, i++) {
-		attrnames_t *namesp;
-
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
 			cursor->hashval = be32_to_cpu(entry->hashval);
 			cursor->offset = 0;
@@ -2411,17 +2369,13 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
 			continue;		/* skip incomplete entries */
-		if (!xfs_attr_namesp_match_overrides(context->flags, entry->flags))
-			continue;
-
-		namesp = xfs_attr_flags_namesp(entry->flags);
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			xfs_attr_leaf_name_local_t *name_loc =
 				XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
 
 			retval = context->put_listent(context,
-						namesp,
+						entry->flags,
 						(char *)name_loc->nameval,
 						(int)name_loc->namelen,
 						be16_to_cpu(name_loc->valuelen),
@@ -2448,16 +2402,15 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 				if (retval)
 					return retval;
 				retval = context->put_listent(context,
-						namesp,
+						entry->flags,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
 						valuelen,
 						(char*)args.value);
 				kmem_free(args.value);
-			}
-			else {
+			} else {
 				retval = context->put_listent(context,
-						namesp,
+						entry->flags,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
 						valuelen,
Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.h	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.h	2008-06-14 17:16:25.000000000 +0200
@@ -30,7 +30,7 @@
 
 struct attrlist;
 struct attrlist_cursor_kern;
-struct attrnames;
+struct xfs_attr_list_context;
 struct xfs_dabuf;
 struct xfs_da_args;
 struct xfs_da_state;
@@ -204,33 +204,6 @@ static inline int xfs_attr_leaf_entsize_
 	return (((bsize) >> 1) + ((bsize) >> 2));
 }
 
-
-/*========================================================================
- * Structure used to pass context around among the routines.
- *========================================================================*/
-
-
-struct xfs_attr_list_context;
-
-typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, struct attrnames *,
-				      char *, int, int, char *);
-
-typedef struct xfs_attr_list_context {
-	struct xfs_inode		*dp;		/* inode */
-	struct attrlist_cursor_kern	*cursor;	/* position in list */
-	struct attrlist			*alist;		/* output buffer */
-	int				seen_enough;	/* T/F: seen enough of list? */
-	int				count;		/* num used entries */
-	int				dupcnt;		/* count dup hashvals seen */
-	int				bufsize;	/* total buffer size */
-	int				firstu;		/* first used byte in buffer */
-	int				flags;		/* from VOP call */
-	int				resynch;	/* T/F: resynch with cursor */
-	int				put_value;	/* T/F: need value for listent */
-	put_listent_func_t		put_listent;	/* list output fmt function */
-	int				index;		/* index into output buffer */
-} xfs_attr_list_context_t;
-
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_xattr.c	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c	2008-06-14 17:14:30.000000000 +0200
@@ -17,7 +17,11 @@
  */
 
 #include "xfs.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
 #include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
 #include "xfs_acl.h"
 #include "xfs_vnodeops.h"
 
@@ -145,11 +149,6 @@ xfs_xattr_user_set(struct inode *inode, 
 	return __xfs_xattr_set(inode, name, value, size, flags, 0);
 }
 
-struct attrnames attr_user = {
-	.attr_name	= "user.",
-	.attr_namelen	= sizeof("user.") - 1,
-};
-
 static struct xattr_handler xfs_xattr_user_handler = {
 	.prefix	= XATTR_USER_PREFIX,
 	.get	= xfs_xattr_user_get,
@@ -171,11 +170,6 @@ xfs_xattr_trusted_set(struct inode *inod
 	return __xfs_xattr_set(inode, name, value, size, flags, ATTR_ROOT);
 }
 
-struct attrnames attr_trusted = {
-	.attr_name	= "trusted.",
-	.attr_namelen	= sizeof("trusted.") - 1,
-};
-
 static struct xattr_handler xfs_xattr_trusted_handler = {
 	.prefix	= XATTR_TRUSTED_PREFIX,
 	.get	= xfs_xattr_trusted_get,
@@ -197,11 +191,6 @@ xfs_xattr_secure_set(struct inode *inode
 	return __xfs_xattr_set(inode, name, value, size, flags, ATTR_SECURE);
 }
 
-struct attrnames attr_secure = {
-	.attr_name	= "security.",
-	.attr_namelen	= sizeof("security.") - 1,
-};
-
 static struct xattr_handler xfs_xattr_security_handler = {
 	.prefix	= XATTR_SECURITY_PREFIX,
 	.get	= xfs_xattr_secure_get,
@@ -217,6 +206,66 @@ struct xattr_handler *xfs_xattr_handlers
 	NULL
 };
 
+static unsigned int xfs_xattr_prefix_len(int flags)
+{
+	if (flags & XFS_ATTR_SECURE)
+		return sizeof("security");
+	else if (flags & XFS_ATTR_ROOT)
+		return sizeof("trusted");
+	else
+		return sizeof("user");
+}
+
+static const char *xfs_xattr_prefix(int flags)
+{
+	if (flags & XFS_ATTR_SECURE)
+		return xfs_xattr_security_handler.prefix;
+	else if (flags & XFS_ATTR_ROOT)
+		return xfs_xattr_trusted_handler.prefix;
+	else
+		return xfs_xattr_user_handler.prefix;
+}
+
+static int
+xfs_xattr_put_listent(struct xfs_attr_list_context *context, int flags,
+		char *name, int namelen, int valuelen, char *value)
+{
+	unsigned int prefix_len = xfs_xattr_prefix_len(flags);
+	char *offset;
+	int arraytop;
+
+	ASSERT(context->count >= 0);
+
+	/*
+	 * Only show root namespace entries if we are actually allowed to
+	 * see them.
+	 */
+	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
+		return 0;
+
+	arraytop = context->count + prefix_len + namelen + 1;
+	if (arraytop > context->firstu) {
+		context->count = -1;	/* insufficient space */
+		return 1;
+	}
+	offset = (char *)context->alist + context->count;
+	strncpy(offset, xfs_xattr_prefix(flags), prefix_len);
+	offset += prefix_len;
+	strncpy(offset, name, namelen);			/* real name */
+	offset += namelen;
+	*offset = '\0';
+	context->count += prefix_len + namelen + 1;
+	return 0;
+}
+
+static int
+xfs_xattr_put_listent_sizes(struct xfs_attr_list_context *context, int flags,
+		char *name, int namelen, int valuelen, char *value)
+{
+	context->count += xfs_xattr_prefix_len(flags) + namelen + 1;
+	return 0;
+}
+
 static int
 list_one_attr(const char *name, const size_t len, void *data,
 		size_t size, ssize_t *result)
@@ -236,28 +285,30 @@ list_one_attr(const char *name, const si
 ssize_t
 xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
 {
+	struct xfs_attr_list_context context;
+	struct attrlist_cursor_kern cursor = { 0 };
 	struct inode		*inode = dentry->d_inode;
-	struct xfs_inode	*ip = XFS_I(inode);
-	attrlist_cursor_kern_t	cursor = { 0 };
-	int			error, xflags;
-	ssize_t			result;
-
-	xflags = ATTR_KERNAMELS;
-	if (!size)
-		xflags |= ATTR_KERNOVAL;
-
-	if (capable(CAP_SYS_ADMIN))
-		xflags |= ATTR_KERNFULLS;
-	else
-		xflags |= ATTR_KERNORMALS;
-
+	int			error;
 
 	/*
 	 * First read the regular on-disk attributes.
 	 */
-	result = -xfs_attr_list(ip, data, size, xflags, &cursor);
-	if (result < 0)
-		return result;
+	memset(&context, 0, sizeof(context));
+	context.dp = XFS_I(inode);
+	context.cursor = &cursor;
+	context.resynch = 1;
+	context.alist = data;
+	context.bufsize = size;
+	context.firstu = context.bufsize;
+
+	if (size)
+		context.put_listent = xfs_xattr_put_listent;
+	else
+		context.put_listent = xfs_xattr_put_listent_sizes;
+
+	xfs_attr_list_int(&context);
+	if (context.count < 0)
+		return -ERANGE;
 
 	/*
 	 * Then add the two synthetic ACL attributes.
@@ -265,7 +316,7 @@ xfs_vn_listxattr(struct dentry *dentry, 
 	if (xfs_acl_vhasacl_access(inode)) {
 		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
 				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
-				data, size, &result);
+				data, size, &context.count);
 		if (error)
 			return error;
 	}
@@ -273,10 +324,10 @@ xfs_vn_listxattr(struct dentry *dentry, 
 	if (xfs_acl_vhasacl_default(inode)) {
 		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
 				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
-				data, size, &result);
+				data, size, &context.count);
 		if (error)
 			return error;
 	}
 
-	return result;
+	return context.count;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-06-14 17:14:30.000000000 +0200
@@ -341,8 +341,7 @@ xfs_acl_iaccess(
 
 	/* If the file has no ACL return -1. */
 	rval = sizeof(xfs_acl_t);
-	if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval,
-					ATTR_ROOT | ATTR_KERNACCESS)) {
+	if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval, ATTR_ROOT)) {
 		_ACL_FREE(acl);
 		return -1;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-06-14 17:12:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-06-14 17:14:30.000000000 +0200
@@ -18,9 +18,11 @@
 #ifndef __XFS_ATTR_H__
 #define	__XFS_ATTR_H__
 
+struct xfs_inode;
+struct xfs_da_args;
+struct xfs_attr_list_context;
+
 /*
- * xfs_attr.h
- *
  * Large attribute lists are structured around Btrees where all the data
  * elements are in the leaf nodes.  Attribute names are hashed into an int,
  * then that int is used as the index into the Btree.  Since the hashval
@@ -35,17 +37,6 @@
  * External interfaces
  *========================================================================*/
 
-struct cred;
-struct xfs_attr_list_context;
-
-typedef struct attrnames {
-	char *		attr_name;
-	unsigned int	attr_namelen;
-} attrnames_t;
-
-extern struct attrnames attr_user;
-extern struct attrnames attr_secure;
-extern struct attrnames attr_trusted;
 
 #define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
 #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
@@ -54,14 +45,8 @@ extern struct attrnames attr_trusted;
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
 
-#define ATTR_KERNACCESS	0x0400	/* [kernel] iaccess, inode held io-locked */
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
-#define ATTR_KERNAMELS	0x4000	/* [kernel] list attr names (simple list) */
-
-#define ATTR_KERNORMALS	0x0800	/* [kernel] normal attr list: user+secure */
-#define ATTR_KERNROOTLS	0x8000	/* [kernel] include root in the attr list */
-#define ATTR_KERNFULLS	(ATTR_KERNORMALS|ATTR_KERNROOTLS)
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
@@ -113,20 +98,40 @@ typedef struct attrlist_cursor_kern {
 
 
 /*========================================================================
- * Function prototypes for the kernel.
+ * Structure used to pass context around among the routines.
  *========================================================================*/
 
-struct xfs_inode;
-struct attrlist_cursor_kern;
-struct xfs_da_args;
+
+typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, int,
+				      char *, int, int, char *);
+
+typedef struct xfs_attr_list_context {
+	struct xfs_inode		*dp;		/* inode */
+	struct attrlist_cursor_kern	*cursor;	/* position in list */
+	char				*alist;		/* output buffer */
+	int				seen_enough;	/* T/F: seen enough of list? */
+	int				count;		/* num used entries */
+	int				dupcnt;		/* count dup hashvals seen */
+	int				bufsize;	/* total buffer size */
+	int				firstu;		/* first used byte in buffer */
+	int				flags;		/* from VOP call */
+	int				resynch;	/* T/F: resynch with cursor */
+	int				put_value;	/* T/F: need value for listent */
+	put_listent_func_t		put_listent;	/* list output fmt function */
+	int				index;		/* index into output buffer */
+} xfs_attr_list_context_t;
+
+
+/*========================================================================
+ * Function prototypes for the kernel.
+ *========================================================================*/
 
 /*
  * Overall external interface routines.
  */
 int xfs_attr_inactive(struct xfs_inode *dp);
-
-int xfs_attr_shortform_getvalue(struct xfs_da_args *);
 int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, int);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
+int xfs_attr_list_int(struct xfs_attr_list_context *);
 
 #endif	/* __XFS_ATTR_H__ */
