Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026FBC33FA0
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B64D12064C
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J3QKxnBl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgBQNBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:01:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:01:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lTVzNWNY6LUO3ty9DWFghP32JGLJT6hMIZ2L91+GiNQ=; b=J3QKxnBleHaddvkwifa+fbbwb3
        lIIJpLAy3N7LJ5gDs8J442/1HzfYQNmbxkKdPiNYStgHcEhf23txmXjDCNn795uBJsNQfH7mYQGWu
        gw/LPWBivj1rg0hqptp16t2FWOyAiI/BS6PfLgkQ6rbalQrvH5a37spVhYSXzKMfpErTCVsnYY9Ca
        XQTWABmSAC8Gz23dWZaH8sFUXfl9a8IVhjNkGssDl9wcQAei/wp0yV+hDEchVRFdrBm6fj3D0hj7E
        9ljmvdG22pXMwmvV8WEYKcxGEmMqOcv2krz9DYq6rmMwQKXS/2CiMITKfXuF0QJFUwTwyW6XBpw9x
        Xq8u6bVw==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1c-00020k-6Z; Mon, 17 Feb 2020 13:01:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 29/31] xfs: clean up the attr flag confusion
Date:   Mon, 17 Feb 2020 13:59:55 +0100
Message-Id: <20200217125957.263434-30-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ATTR_* flags have a long IRIX history, where they a userspace
interface, the on-disk format and an internal interface.  We've split
out the on-disk interface to the XFS_ATTR_* values, but despite (or
because?) of that the flag have still been a mess.  Switch the
internal interface to pass the on-disk XFS_ATTR_* flags for the
namespace and the Linux XATTR_* flags for the actual flags instead.
The ATTR_* values that are actually used are move to xfs_fs.h with a
new XFS_IOC_* prefix to not conflict with the userspace version that
has the same name and must have the same value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 16 ++++++-------
 fs/xfs/libxfs/xfs_attr.h      | 22 +-----------------
 fs/xfs/libxfs/xfs_attr_leaf.c | 14 +++++------
 fs/xfs/libxfs/xfs_da_format.h | 12 ----------
 fs/xfs/libxfs/xfs_fs.h        | 12 +++++++++-
 fs/xfs/libxfs/xfs_types.h     |  3 ++-
 fs/xfs/scrub/attr.c           |  5 +---
 fs/xfs/xfs_acl.c              |  5 ++--
 fs/xfs/xfs_ioctl.c            | 44 +++++++++++++++++++++++++----------
 fs/xfs/xfs_iops.c             |  3 +--
 fs/xfs/xfs_linux.h            |  1 +
 fs/xfs/xfs_trace.h            | 35 +++++++++++++++++-----------
 fs/xfs/xfs_xattr.c            | 18 +++++---------
 13 files changed, 94 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9c629c7c912d..d5c112b6dcdd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -295,7 +295,7 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	int			rsvd = (args->flags & ATTR_ROOT) != 0;
+	bool			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
 	int			error, local;
 	unsigned int		total;
 
@@ -423,10 +423,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	trace_xfs_attr_sf_addname(args);
 
 	retval = xfs_attr_shortform_lookup(args);
-	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
+	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
 		return retval;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->attr_flags & XATTR_CREATE)
 			return retval;
 		retval = xfs_attr_shortform_remove(args);
 		if (retval)
@@ -436,7 +436,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 		 * that the leaf format add routine won't trip over the attr
 		 * not being around.
 		 */
-		args->flags &= ~ATTR_REPLACE;
+		args->attr_flags &= ~XATTR_REPLACE;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
@@ -489,10 +489,10 @@ xfs_attr_leaf_addname(
 	 * the given flags produce an error or call for an atomic rename.
 	 */
 	retval = xfs_attr3_leaf_lookup_int(bp, args);
-	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
+	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
 		goto out_brelse;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)	/* pure create op */
+		if (args->attr_flags & XATTR_CREATE)	/* pure create op */
 			goto out_brelse;
 
 		trace_xfs_attr_leaf_replace(args);
@@ -763,10 +763,10 @@ xfs_attr_node_addname(
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
+	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
 		goto out;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->attr_flags & XATTR_CREATE)
 			goto out;
 
 		trace_xfs_attr_node_replace(args);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8d42f5782ff7..7a3525dff411 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -21,26 +21,6 @@ struct xfs_attr_list_context;
  * as possible so as to fit into the literal area of the inode.
  */
 
-/*========================================================================
- * External interfaces
- *========================================================================*/
-
-
-#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
-#define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
-#define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
-#define ATTR_SECURE	0x0008	/* use attrs in security namespace */
-#define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
-#define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
-
-#define XFS_ATTR_FLAGS \
-	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
-	{ ATTR_ROOT,		"ROOT" }, \
-	{ ATTR_TRUST,		"TRUST" }, \
-	{ ATTR_SECURE,		"SECURE" }, \
-	{ ATTR_CREATE,		"CREATE" }, \
-	{ ATTR_REPLACE,		"REPLACE" }
-
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
  * attribute value or the buffer used for an attr_list() call.  Larger
@@ -87,7 +67,7 @@ struct xfs_attr_list_context {
 	int			dupcnt;		/* count dup hashvals seen */
 	int			bufsize;	/* total buffer size */
 	int			firstu;		/* first used byte in buffer */
-	int			flags;		/* from VOP call */
+	unsigned int		attr_namespace;	/* XFS_ATTR_{ROOT,SECURE} */
 	int			resynch;	/* T/F: resynch with cursor */
 	put_listent_func_t	put_listent;	/* list output fmt function */
 	int			index;		/* index into output buffer */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8852754153ba..9081ba7af90a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,8 +456,7 @@ xfs_attr_match(
 		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
-	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
-	    XFS_ATTR_NSP_ONDISK(flags))
+	if (args->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
 		return false;
 	return true;
 }
@@ -697,7 +696,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
-	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	sfe->flags = args->attr_namespace;
 	memcpy(sfe->nameval, args->name, args->namelen);
 	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
 	sf->hdr.count++;
@@ -906,7 +905,7 @@ xfs_attr_shortform_to_leaf(
 		nargs.valuelen = sfe->valuelen;
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
+		nargs.attr_namespace = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1112,7 +1111,7 @@ xfs_attr3_leaf_to_shortform(
 		nargs.value = &name_loc->nameval[nargs.namelen];
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
+		nargs.attr_namespace = entry->flags & XFS_ATTR_NSP_ONDISK_MASK;
 		xfs_attr_shortform_add(&nargs, forkoff);
 	}
 	error = 0;
@@ -1437,8 +1436,9 @@ xfs_attr3_leaf_add_work(
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
 	entry->hashval = cpu_to_be32(args->hashval);
-	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
-	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	entry->flags = args->attr_namespace;
+	if (tmp)
+		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 734837a9b51a..08c0a4d98b89 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -692,19 +692,7 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
-
-/*
- * Conversion macros for converting namespace bits from argument flags
- * to ondisk flags.
- */
-#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
-#define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
-#define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
-#define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
-					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
-#define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
-					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 21920f613d42..02f20d8bbfd1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -568,6 +568,16 @@ typedef struct xfs_fsop_setdm_handlereq {
 	struct fsdmidata		__user *data;	/* DMAPI data	*/
 } xfs_fsop_setdm_handlereq_t;
 
+/*
+ * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
+ *
+ * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
+ */
+#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
+#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
+#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
+#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
 } xfs_attrlist_cursor_t;
@@ -609,7 +619,7 @@ typedef struct xfs_attr_multiop {
 	void		__user *am_attrname;
 	void		__user *am_attrvalue;
 	__u32		am_length;
-	__u32		am_flags;
+	__u32		am_flags; /* XFS_IOC_ATTR_* */
 } xfs_attr_multiop_t;
 
 typedef struct xfs_fsop_attrmulti_handlereq {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 1594325d7742..2b02f854ebaf 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -194,7 +194,8 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
-	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
+	unsigned int	attr_namespace;	/* XFS_ATTR_{ROOT,SECURE} */
+	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9e336d797616..d84237af5455 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -148,10 +148,7 @@ xchk_xattr_listent(
 	}
 
 	args.op_flags = XFS_DA_OP_NOTIME;
-	if (flags & XFS_ATTR_ROOT)
-		args.flags |= ATTR_ROOT;
-	else if (flags & XFS_ATTR_SECURE)
-		args.flags |= ATTR_SECURE;
+	args.attr_namespace = flags & XFS_ATTR_NSP_ONDISK_MASK;
 	args.geo = context->dp->i_mount->m_attr_geo;
 	args.whichfork = XFS_ATTR_FORK;
 	args.dp = context->dp;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index e9a48d718c3a..6690906cd16f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -14,6 +14,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_acl.h"
+#include "xfs_da_format.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -125,7 +126,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct posix_acl	*acl = NULL;
 	struct xfs_da_args	args = {
 		.dp		= ip,
-		.flags		= ATTR_ROOT,
+		.attr_namespace	= XFS_ATTR_ROOT,
 		.valuelen	= XFS_ACL_MAX_SIZE(mp),
 	};
 	int			error;
@@ -166,7 +167,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_da_args	args = {
 		.dp		= ip,
-		.flags		= ATTR_ROOT,
+		.attr_namespace	= XFS_ATTR_ROOT,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4f26c3962215..d2318857497b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -319,11 +319,7 @@ xfs_ioc_attr_put_listent(
 	/*
 	 * Only list entries in the right namespace.
 	 */
-	if (((context->flags & ATTR_SECURE) == 0) !=
-	    ((flags & XFS_ATTR_SECURE) == 0))
-		return;
-	if (((context->flags & ATTR_ROOT) == 0) !=
-	    ((flags & XFS_ATTR_ROOT) == 0))
+	if (context->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
 		return;
 
 	arraytop = sizeof(*alist) +
@@ -348,6 +344,28 @@ xfs_ioc_attr_put_listent(
 	trace_xfs_attr_list_add(context);
 }
 
+static unsigned int
+xfs_attr_namespace(
+	u32			ioc_flags)
+{
+	if (ioc_flags & XFS_IOC_ATTR_ROOT)
+		return XFS_ATTR_ROOT;
+	if (ioc_flags & XFS_IOC_ATTR_SECURE)
+		return XFS_ATTR_SECURE;
+	return 0;
+}
+
+static unsigned int
+xfs_attr_flags(
+	u32			ioc_flags)
+{
+	if (ioc_flags & XFS_IOC_ATTR_CREATE)
+		return XATTR_CREATE;
+	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
+		return XATTR_REPLACE;
+	return 0;
+}
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -369,9 +387,9 @@ xfs_ioc_attr_list(
 	/*
 	 * Reject flags, only allow namespaces.
 	 */
-	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
+	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
-	if (flags == (ATTR_ROOT | ATTR_SECURE))
+	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
 
 	/*
@@ -396,7 +414,7 @@ xfs_ioc_attr_list(
 	context.dp = dp;
 	context.cursor = &cursor;
 	context.resynch = 1;
-	context.flags = flags;
+	context.attr_namespace = xfs_attr_namespace(flags);
 	context.buffer = buffer;
 	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
 	context.firstu = context.bufsize;
@@ -453,7 +471,8 @@ xfs_attrmulti_attr_get(
 {
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
-		.flags		= flags,
+		.attr_namespace	= xfs_attr_namespace(flags),
+		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
@@ -490,7 +509,8 @@ xfs_attrmulti_attr_set(
 {
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
-		.flags		= flags,
+		.attr_namespace	= xfs_attr_namespace(flags),
+		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 	};
@@ -509,7 +529,7 @@ xfs_attrmulti_attr_set(
 	}
 
 	error = xfs_attr_set(&args);
-	if (!error && (flags & ATTR_ROOT))
+	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
 	return error;
@@ -528,7 +548,7 @@ xfs_ioc_attrmulti_one(
 	unsigned char		*name;
 	int			error;
 
-	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
+	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
 
 	name = strndup_user(uname, MAXNAMELEN);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 94cd4254656c..8b1a3e7d83e6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -22,7 +22,6 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 
-#include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
 #include <linux/iversion.h>
@@ -52,7 +51,7 @@ xfs_initxattrs(
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		struct xfs_da_args	args = {
 			.dp		= ip,
-			.flags		= ATTR_SECURE,
+			.attr_namespace	= XFS_ATTR_SECURE,
 			.name		= xattr->name,
 			.namelen	= strlen(xattr->name),
 			.value		= xattr->value,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 8738bb03f253..8c0070a797de 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -60,6 +60,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/list_sort.h>
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
+#include <linux/xattr.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 43b1b03ae00f..0e316a35a456 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -36,6 +36,10 @@ struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 
+#define XFS_ATTR_NSP_FLAGS \
+	{ XFS_ATTR_ROOT,	"ROOT" }, \
+	{ XFS_ATTR_SECURE,	"SECURE" }
+
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
 	TP_ARGS(ctx),
@@ -50,7 +54,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		__field(int, count)
 		__field(int, firstu)
 		__field(int, dupcnt)
-		__field(int, flags)
+		__field(int, attr_namespace)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
@@ -62,10 +66,10 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
 		__entry->firstu = ctx->firstu;
-		__entry->flags = ctx->flags;
+		__entry->attr_namespace = ctx->attr_namespace;
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "buffer %p size %u count %u firstu %u flags %d %s",
+		  "buffer %p size %u count %u firstu %u namespace %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
 		   __entry->hashval,
@@ -76,8 +80,9 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		   __entry->bufsize,
 		   __entry->count,
 		   __entry->firstu,
-		   __entry->flags,
-		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
+		   __entry->attr_namespace,
+		   __print_flags(__entry->attr_namespace, "|",
+				 XFS_ATTR_NSP_FLAGS)
 	)
 )
 
@@ -174,7 +179,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__field(int, count)
 		__field(int, firstu)
 		__field(int, dupcnt)
-		__field(int, flags)
+		__field(int, attr_namespace)
 		__field(u32, bt_hashval)
 		__field(u32, bt_before)
 	),
@@ -188,12 +193,12 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
 		__entry->firstu = ctx->firstu;
-		__entry->flags = ctx->flags;
+		__entry->attr_namespace = ctx->attr_namespace;
 		__entry->bt_hashval = be32_to_cpu(btree->hashval);
 		__entry->bt_before = be32_to_cpu(btree->before);
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "buffer %p size %u count %u firstu %u flags %d %s "
+		  "buffer %p size %u count %u firstu %u namespae %d %s "
 		  "node hashval %u, node before %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
@@ -205,8 +210,9 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		   __entry->bufsize,
 		   __entry->count,
 		   __entry->firstu,
-		   __entry->flags,
-		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
+		   __entry->attr_namespace,
+		   __print_flags(__entry->attr_namespace, "|",
+				 XFS_ATTR_NSP_FLAGS),
 		   __entry->bt_hashval,
 		   __entry->bt_before)
 );
@@ -1701,7 +1707,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(int, namelen)
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
-		__field(int, flags)
+		__field(int, attr_namespace)
 		__field(int, op_flags)
 	),
 	TP_fast_assign(
@@ -1712,11 +1718,11 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__entry->namelen = args->namelen;
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
-		__entry->flags = args->flags;
+		__entry->attr_namespace = args->attr_namespace;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
-		  "hashval 0x%x flags %s op_flags %s",
+		  "hashval 0x%x namespace %s op_flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -1724,7 +1730,8 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		  __entry->namelen,
 		  __entry->valuelen,
 		  __entry->hashval,
-		  __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
+		  __print_flags(__entry->attr_namespace, "|",
+				XFS_ATTR_NSP_FLAGS),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
 )
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 10ff60e96051..456101c9c17d 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -14,7 +14,6 @@
 #include "xfs_acl.h"
 
 #include <linux/posix_acl_xattr.h>
-#include <linux/xattr.h>
 
 
 static int
@@ -23,7 +22,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 {
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
-		.flags		= handler->flags,
+		.attr_namespace	= handler->flags,
 		.name		= name,
 		.namelen	= strlen(name),
 		.value		= value,
@@ -44,7 +43,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 {
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
-		.flags		= handler->flags,
+		.attr_namespace	= handler->flags,
+		.attr_flags	= flags,
 		.name		= name,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
@@ -52,14 +52,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	};
 	int			error;
 
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (flags & XATTR_CREATE)
-		args.flags |= ATTR_CREATE;
-	if (flags & XATTR_REPLACE)
-		args.flags |= ATTR_REPLACE;
-
 	error = xfs_attr_set(&args);
-	if (!error && (handler->flags & ATTR_ROOT))
+	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;
 }
@@ -73,14 +67,14 @@ static const struct xattr_handler xfs_xattr_user_handler = {
 
 static const struct xattr_handler xfs_xattr_trusted_handler = {
 	.prefix	= XATTR_TRUSTED_PREFIX,
-	.flags	= ATTR_ROOT,
+	.flags	= XFS_ATTR_ROOT,
 	.get	= xfs_xattr_get,
 	.set	= xfs_xattr_set,
 };
 
 static const struct xattr_handler xfs_xattr_security_handler = {
 	.prefix	= XATTR_SECURITY_PREFIX,
-	.flags	= ATTR_SECURE,
+	.flags	= XFS_ATTR_SECURE,
 	.get	= xfs_xattr_get,
 	.set	= xfs_xattr_set,
 };
-- 
2.24.1

