Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AA9C29E1E
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EE9CAC008
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsDA003644
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.215757527@sgi.com>
Date: Wed, 15 Jan 2014 16:00:24 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 12/17] xfs: (parent ptr) add parent pointer support for user
	space
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline;
	filename=12-pptr-add-incore-to-getparentpaths_by_handle.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add the parent inode / offset support for user space.
This adds two new ioctls to provide the names or paths
for an inode that is pointed to by handle.

---
 fs/xfs/xfs_attr.h   |    2 
 fs/xfs/xfs_fs.h     |   10 +
 fs/xfs/xfs_ioctl.c  |   72 ++++++++
 fs/xfs/xfs_parent.c |  435 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent.h |   30 +++
 5 files changed, 548 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_attr.h
===================================================================
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -131,6 +131,8 @@ typedef struct xfs_attr_list_context {
 	int				put_value;	/* T/F: need value for listent */
 	put_listent_func_t		put_listent;	/* list output fmt function */
 	int				index;		/* index into output buffer */
+	char				*scratch;	/* parent private buf */
+	int				srtchlen;	/* parent priv buf len */
 } xfs_attr_list_context_t;
 
 
Index: b/fs/xfs/xfs_fs.h
===================================================================
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -438,6 +438,14 @@ typedef struct xfs_fsop_attrmulti_handle
 	struct xfs_attr_multiop		__user *ops; /* attr_multi data */
 } xfs_fsop_attrmulti_handlereq_t;
 
+typedef struct xfs_fsop_parentlist_handlereq {
+	struct xfs_fsop_handlereq	hreq;	/* handle interface structure */
+	u32				flags;	/* which namespace to use */
+	u32				buflen;	/* length of supplied buffer */
+	__s32				__user *ocount; /* output count ptr */
+	void				__user *buffer; /* returned names */
+} xfs_fsop_parentlist_handlereq_t;
+
 /*
  * per machine unique filesystem identifier types.
  */
@@ -553,6 +561,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 126, struct xfs_fsop_parentlist_handlereq)
+#define XFS_IOC_GETPARENTPATHS_BY_HANDLE _IOWR('X', 127, struct xfs_fsop_parentlist_handlereq)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: b/fs/xfs/xfs_ioctl.c
===================================================================
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_symlink.h"
 #include "xfs_dinode.h"
 #include "xfs_trans.h"
+#include "xfs_parent.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -632,6 +633,73 @@ xfs_attrmulti_by_handle(
 	return -error;
 }
 
+STATIC int
+xfs_getparent_by_handle(
+	struct file		*parfilp,
+	void			__user *arg,
+	unsigned int		cmd)
+{
+	int			error = -ENOMEM;
+	int			count = 0;
+	struct xfs_fsop_parentlist_handlereq	pl_hreq;
+	struct dentry		*dentry;
+	char			*kbuf;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
+	if (copy_from_user(&pl_hreq, arg, sizeof(pl_hreq)))
+		return -XFS_ERROR(EFAULT);
+
+	if (pl_hreq.buflen > XATTR_LIST_MAX)
+		return -XFS_ERROR(EINVAL);
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (pl_hreq.flags & ~(ATTR_PARENT))
+		return -XFS_ERROR(EINVAL);
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &pl_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	kbuf = kmem_zalloc_large(pl_hreq.buflen, KM_SLEEP);
+	if (!kbuf)
+		goto out_dput;
+
+	switch (cmd) {
+	case XFS_IOC_GETPARENTS_BY_HANDLE:
+		error = -xfs_parents_attr_list(XFS_I(dentry->d_inode), kbuf,
+					pl_hreq.buflen, &count);
+		break;
+	case XFS_IOC_GETPARENTPATHS_BY_HANDLE:
+		error = -xfs_parentpaths_attr_list(XFS_I(dentry->d_inode),
+					kbuf, pl_hreq.buflen, &count);
+		break;
+	default:
+		error = -ENOTTY;
+	}
+	if (error)
+		goto out_kfree;
+
+	if (copy_to_user(pl_hreq.buffer, kbuf, pl_hreq.buflen)) {
+		error = -XFS_ERROR(EFAULT);
+		goto out_kfree;
+	}
+
+	if (pl_hreq.ocount != NULL) {
+		if (copy_to_user(pl_hreq.ocount, &count, sizeof(count)))
+			error = -XFS_ERROR(EFAULT);
+	}
+
+ out_kfree:
+	kmem_free(kbuf);
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
 int
 xfs_ioc_space(
 	struct xfs_inode	*ip,
@@ -1675,6 +1743,10 @@ xfs_file_ioctl(
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 		return xfs_attrmulti_by_handle(filp, arg);
 
+	case XFS_IOC_GETPARENTS_BY_HANDLE:
+	case XFS_IOC_GETPARENTPATHS_BY_HANDLE:
+		return xfs_getparent_by_handle(filp, arg, cmd);
+
 	case XFS_IOC_SWAPEXT: {
 		struct xfs_swapext	sxp;
 
Index: b/fs/xfs/xfs_parent.c
===================================================================
--- a/fs/xfs/xfs_parent.c
+++ b/fs/xfs/xfs_parent.c
@@ -156,3 +156,438 @@ xfs_pptr_rename(
 	 */
 	return XFSREMOVESRC;
 }
+
+/* the fill function for xfs_readdir */
+static int
+xfs_gpfill(
+	void		*gfill,
+	const char	*name,
+	int		namlen,
+	loff_t		offset,
+	u64		ino,
+	unsigned int	type)
+{
+	struct xfs_pfillinfo *gfp = (struct xfs_pfillinfo *) gfill;
+
+	if (offset != gfp->gp_off)	/*XXX mft remove */
+		return 0;
+
+	namlen = MIN(namlen, gfp->gp_len);
+	strncpy(gfp->gp_path + gfp->gp_len - namlen, name, namlen);
+	gfp->gp_len -= namlen;
+	return 1;	/* return a 1 to stop */
+}
+
+/* save name of entry at directory pino/offset to the buffer (path) */
+int
+xfs_getpname(
+	struct xfs_mount	*mp,		/* IN mount point */
+	xfs_ino_t		pino,		/* IN starting parent ino */
+	xfs_off_t		offset,		/* IN starting dir offset */
+	char			*path,		/* OUT buffer to hold path */
+	int			*plen)		/* IN/OUT pref MAXPATHLEN+1 */
+{
+	int			error = 0;
+	struct xfs_inode	*dp = NULL;
+	struct xfs_pfillinfo	gfill = {
+		.ctx.actor = xfs_gpfill
+        };
+
+	ASSERT(path != NULL);
+
+	gfill.ctx.pos = offset;
+	gfill.gp_off = offset;
+	gfill.gp_path = path;
+	gfill.gp_path[*plen-1] = '\0';
+	memset(path, 0, *plen);
+	gfill.gp_len = *plen-1;
+
+	error = xfs_iget(mp, NULL, pino, 0, XFS_ILOCK_SHARED, &dp);
+	if (error)
+		return error;
+
+	error = xfs_readdir(dp, &(gfill.ctx), *plen);
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+	IRELE(dp);
+	*plen = *plen - 1 - gfill.gp_len;
+	return error;
+}
+
+STATIC int
+xfs_attr_paths_put_listent(
+	struct xfs_attr_list_context *context,
+	int		flags,
+	unsigned char	*name,
+	int		namelen,
+	int		valuelen,
+	unsigned char	*value)
+{
+	struct xfs_pattr	*p_attr;
+	struct xfs_parent	*p_entry;
+
+	ASSERT(!(context->flags & ATTR_KERNOVAL));
+	ASSERT(context->count >= 0);
+	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
+	ASSERT(namelen == sizeof(struct xfs_pattr));
+
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if ((context->flags & ATTR_PARENT) == 0)
+		return 0;
+
+	if (namelen != sizeof(struct xfs_pattr))
+		return 0;
+
+	p_attr = (struct xfs_pattr *) name;
+
+	p_entry = (struct xfs_parent *)context->alist;
+	p_entry->p_ino = be64_to_cpu(p_attr->p_ino);
+	p_entry->p_offset = be32_to_cpu(p_attr->p_offset);
+	context->seen_enough = 1;
+	return 0;
+}
+
+/* save path of entry at directory pino/offset to the buffer (path) */
+int
+xfs_getpath(
+	struct xfs_mount	*mp,		/* IN mount point */
+	xfs_ino_t		pino,		/* IN starting parent ino */
+	xfs_off_t		offset,		/* IN starting dir offset */
+	char			*path,		/* OUT buffer to hold path */
+	int			*plen)		/* IN/OUT pref MAXPATHLEN+1 */
+{
+	int			error = 0;
+	uint32_t		dotdot;
+	struct xfs_inode	*dp = NULL;
+	struct xfs_pfillinfo	gfill = {
+		.ctx.actor = xfs_gpfill
+        };
+
+	ASSERT(path != NULL);
+
+	gfill.ctx.pos = offset;
+	gfill.gp_off = offset;
+	gfill.gp_path = path;
+	gfill.gp_path[*plen-1] = '\0';
+	memset(path, 0, *plen);
+	gfill.gp_len = *plen-1;
+
+
+	error = xfs_iget(mp, NULL, pino, 0, XFS_ILOCK_SHARED, &dp);
+	if (error)
+		return error;
+
+	dotdot = dp->d_ops->data_dotdot_offset >> XFS_DIR2_DATA_ALIGN_LOG;
+
+	/*
+	 * start with the specified parent inode/offset. save the current
+	 * name and then loop through the parent directories filling in
+	 * the current directory name until the mount point is reached or
+	 * the buffer is full.
+	 */
+
+	while (gfill.gp_len > 1 ) {
+		gfill.gp_off = offset; /*XXX mft remove */
+		gfill.ctx.pos = offset;
+		error = xfs_readdir(dp, &(gfill.ctx), *plen);
+		if (error)
+			goto out_irelse;
+
+		/* look for the parent attribute in the current directory */
+		pino = be64_to_cpu(dp->i_d.di_parent);
+		offset = be32_to_cpu(dp->i_d.di_poffset);
+
+		/* stop at root directory */
+		if (pino == mp->m_sb.sb_rootino && offset <= dotdot)
+			break;
+
+		xfs_iunlock(dp, XFS_ILOCK_SHARED);
+		IRELE(dp);
+
+		error = xfs_iget(mp, NULL, pino, 0, XFS_ILOCK_SHARED, &dp);
+		if (error)
+			goto out_irelse;
+
+		if (gfill.gp_len < 1)
+			break;
+
+		/* there is another parent directory - add dir slash */
+		gfill.gp_len--;
+		*(gfill.gp_path + gfill.gp_len) = '/';
+	}
+
+	*plen = *plen - 1 - gfill.gp_len;
+
+ out_irelse:
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+	IRELE(dp);
+	return error;
+}
+
+/*
+ * Format an attribute and copy it out to the user's buffer.
+ * Take care to check values and protect against them changing later,
+ * we may be reading them directly out of a user buffer.
+ */
+/*ARGSUSED*/
+STATIC int
+xfs_attr_parents_put_listent(
+	struct xfs_attr_list_context *context,
+	int		flags,
+	unsigned char	*name,
+	int		namelen,
+	int		valuelen,
+	unsigned char	*value)
+{
+	int error;
+	int len;
+	int reclen;
+	struct xfs_pattr *p_attr;
+	struct xfs_parent *p_entry;
+
+	ASSERT(!(context->flags & ATTR_KERNOVAL));
+	ASSERT(context->count >= 0);
+	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
+	ASSERT(namelen == sizeof(struct xfs_pattr));
+
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if ((context->flags & ATTR_PARENT) == 0)
+		return 0;
+
+	if (namelen != sizeof(struct xfs_pattr))
+		return 0;
+
+	len = context->srtchlen;
+	p_attr = (struct xfs_pattr *) name;
+	error = xfs_getpname(context->dp->i_mount, be64_to_cpu(p_attr->p_ino),
+			be32_to_cpu(p_attr->p_offset), context->scratch, &len);
+	if (error)
+		return 0;
+
+	/* round up to the nearest 8 byte alignment */
+	reclen = PARENT_ENTSIZE(namelen);
+	if ((context->index + reclen) >= context->bufsize) {
+		context->seen_enough = 1;
+		return 0;
+	}
+
+	p_entry = (struct xfs_parent *)(context->alist + context->index);
+	p_entry->p_ino = be64_to_cpu(p_attr->p_ino);
+	p_entry->p_offset = be32_to_cpu(p_attr->p_offset);
+
+	/*
+	 * xfs_getpname() will write the name at the end of the buffer
+	 * and null terminated. Copy the path and null to xfs_parent_t
+	 */
+	memcpy(p_entry->p_name, context->scratch + context->srtchlen -1 - len,
+		len + 1);
+	p_entry->p_reclen = reclen;
+
+	context->index += reclen;
+	context->count++;
+	return 0;
+}
+
+/*
+ * Format an attribute and copy it out to the user's buffer.
+ * Take care to check values and protect against them changing later,
+ * we may be reading them directly out of a user buffer.
+ */
+/*ARGSUSED*/
+STATIC int
+xfs_attr_parentpaths_put_listent(
+	struct xfs_attr_list_context *context,
+	int		flags,
+	unsigned char	*name,
+	int		namelen,
+	int		valuelen,
+	unsigned char	*value)
+{
+	int error;
+	int len;
+	int reclen;
+	struct xfs_pattr *p_attr;
+	struct xfs_parent *p_entry;
+
+	ASSERT(!(context->flags & ATTR_KERNOVAL));
+	ASSERT(context->count >= 0);
+	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
+	ASSERT(namelen == sizeof(struct xfs_pattr));
+
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if ((context->flags & ATTR_PARENT) == 0)
+		return 0;
+
+	if (namelen != sizeof(struct xfs_pattr))
+		return 0;
+
+	len = context->srtchlen;
+	p_attr = (struct xfs_pattr *) name;
+	error = xfs_getpath(context->dp->i_mount, be64_to_cpu(p_attr->p_ino),
+			be32_to_cpu(p_attr->p_offset), context->scratch, &len);
+	if (error)
+		return 0;
+
+	/* round up to the nearest 8 byte alignment */
+	reclen = PARENT_ENTSIZE(len);
+	if ((context->index + reclen) >= context->bufsize) {
+		context->seen_enough = 1;
+		return 0;
+	}
+
+	p_entry = (struct xfs_parent *)(context->alist + context->index);
+	p_entry->p_ino = be64_to_cpu(p_attr->p_ino);
+	p_entry->p_offset = be32_to_cpu(p_attr->p_offset);
+
+	/*
+	 * xfs_getpath() will write the path at the end of the buffer
+	 * and null terminated. Copy the path and null to xfs_parent_t
+	 */
+	memcpy(p_entry->p_name, context->scratch + context->srtchlen - 1 - len,
+		len + 1);
+	p_entry->p_reclen = reclen;
+
+	context->index += reclen;
+	context->count++;
+	return 0;
+}
+
+/*
+ * Generate a list of extended attribute parent directory path names */
+int
+xfs_parents_attr_list(
+	struct xfs_inode	*dp,
+	char			*buffer,
+	int			bufsize,
+	int			*count)
+{
+	struct attrlist_cursor_kern	cursor;
+	struct xfs_attr_list_context	context;
+	int error;
+
+	/*
+	 * Check for a properly aligned buffer.
+	 */
+	if (((long)buffer) & (sizeof(int)-1))
+		return XFS_ERROR(EFAULT);
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	memset(&cursor, 0, sizeof(cursor));
+	memset(&context, 0, sizeof(context));
+	context.dp = dp;
+	context.cursor = &cursor;
+	context.resynch = 1;
+	context.flags = ATTR_PARENT;
+	context.alist = buffer;
+	context.bufsize = (bufsize & ~(sizeof(int)-1));		/* align */
+	context.firstu = context.bufsize;
+	context.put_listent = xfs_attr_parents_put_listent;
+	context.scratch = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
+	context.srtchlen = MAXPATHLEN+1;
+	*(context.scratch+MAXPATHLEN) = '\0';
+
+	if (dp->i_d.di_parent != NULLFSINO) {
+		struct xfs_pattr	p_attr;
+
+		/* copy the incore entry */
+		p_attr.p_ino = dp->i_d.di_parent;
+		p_attr.p_offset = dp->i_d.di_poffset;
+		xfs_attr_parents_put_listent(&context, ATTR_PARENT,
+				(char *)&p_attr, sizeof(p_attr), 0, NULL);
+		if (context.seen_enough) {
+			*count = context.count;
+			error = ERANGE;
+			goto freeout;
+		}
+	}
+
+	/* copy the parent extended attribute entries */
+	error = xfs_attr_list_int(&context);
+
+	*count = context.count;
+	if (context.seen_enough) {
+		/*
+		* The buffer is full and we return error.
+		* User would need to recall us with a bigger buffer.
+		*/
+		error = ERANGE;
+	}
+ freeout:
+	kfree(context.scratch);
+	return XFS_ERROR(error);
+}
+
+/*
+ * Generate a list of extended attribute parent directory path names
+ */
+int
+xfs_parentpaths_attr_list(
+	struct xfs_inode	*dp,
+	char			*buffer,
+	int			bufsize,
+	int			*count)
+{
+	struct attrlist_cursor_kern	cursor;
+	struct xfs_attr_list_context	context;
+	int error;
+
+	/*
+	 * Check for a properly aligned buffer.
+	 */
+	if (((long)buffer) & (sizeof(int) - 1))
+		return XFS_ERROR(EFAULT);
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	memset(&cursor, 0, sizeof(cursor));
+	memset(&context, 0, sizeof(context));
+	context.dp = dp;
+	context.cursor = &cursor;
+	context.resynch = 1;
+	context.flags = ATTR_PARENT;
+	context.alist = buffer;
+	context.bufsize = (bufsize & ~(sizeof(int) - 1));	/* align */
+	context.firstu = context.bufsize;
+	context.put_listent = xfs_attr_parentpaths_put_listent;
+	context.scratch = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
+	context.srtchlen = MAXPATHLEN+1;
+	*(context.scratch+MAXPATHLEN) = '\0';
+
+	if (dp->i_d.di_parent != NULLFSINO) {
+		struct xfs_pattr	p_attr;
+
+		/* copy the incore entry */
+		p_attr.p_ino = dp->i_d.di_parent;
+		p_attr.p_offset = dp->i_d.di_poffset;
+		xfs_attr_parentpaths_put_listent(&context, ATTR_PARENT,
+				(char *)&p_attr, sizeof(p_attr), 0, NULL);
+		if (context.seen_enough) {
+			*count = context.count;
+			error = ERANGE;
+			goto freeout;
+		}
+	}
+
+	/* copy the parent extended attribute entries */
+	error = xfs_attr_list_int(&context);
+
+	*count = context.count;
+	if (context.seen_enough) {
+		/*
+		* The buffer is full and we return error.
+		* User would need to recall us with a bigger buffer.
+		*/
+		error = ERANGE;
+	}
+ freeout:
+	kfree(context.scratch);
+	return XFS_ERROR(error);
+}
Index: b/fs/xfs/xfs_parent.h
===================================================================
--- a/fs/xfs/xfs_parent.h
+++ b/fs/xfs/xfs_parent.h
@@ -28,6 +28,22 @@ struct xfs_pattr {
 	__be32  p_offset;
 } __attribute__((packed));
 
+/* xfs_readdir fill program private data */
+struct xfs_pfillinfo {
+	struct dir_context	ctx;		/* must be first entry */
+	int			gp_len;
+	int			gp_off;
+	char			*gp_path;
+};
+
+typedef struct xfs_parent {
+	uint64_t	p_ino;		/* parent inode number */
+	uint32_t	p_offset;	/* entry offset in parent inode */
+	uint16_t	p_reclen;	/* name length */
+	uint16_t	p_pad;		/* padding for future */
+	char		p_name[1];	/* variable length name */
+} xfs_parent_t;
+
 static inline void xfs_parent_pname(xfs_ino_t ino, __uint32_t off, struct xfs_pattr *pe, struct xfs_name *pn)
 {
 	pe->p_ino = cpu_to_be64(ino);
@@ -36,9 +52,21 @@ static inline void xfs_parent_pname(xfs_
 	pn->len = sizeof(struct xfs_pattr);
 }
 
+/* actual bytes used by parent entry */
+#define PARENT_ENTSIZE(namelen)					\
+	((offsetof(struct xfs_parent, p_name) + (namelen) + 1 +	\
+	sizeof(uint64_t)-1) & ~(sizeof(uint64_t)-1))
+
+int xfs_getpath(struct xfs_mount *mp, xfs_ino_t pino, xfs_off_t offset,
+		char *path, int *plen);
+int xfs_getpname(struct xfs_mount *mp, xfs_ino_t pino, xfs_off_t offset,
+		char *path, int *plen);
+int xfs_parents_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+		int *count);
+int xfs_parentpaths_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+		int *count);
 int xfs_pptr_rename(struct xfs_mount *mp, struct xfs_trans *tp,
 	struct xfs_inode *src_dp, struct xfs_inode *target_dp,
 	struct xfs_inode *src_ip, struct xfs_inode *target_ip,
 	uint src_offset, uint tar_offset);
 #endif /* __XFS_PARENT_H__ */
-


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
