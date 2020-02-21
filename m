Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DEFC35657
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2025824650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BhGidvBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgBUOL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgBUOL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YP2Zrb4X0y6hRsFdmuFqjarJBx/RRb2+4f8ZuVcOySM=; b=BhGidvBgyWYxaTj4I6U2wumq7l
        0kYSpMhtqQiFQxOewIcnoF7Lk1HmALU+W2HJq22AmAdG69cpk2e1yzR2PJhw35SjSAF3BoQRrTe38
        EzI0wwC9NXkA8QQHo9r5XmcpLnNcHrFRxEJEvtP6XsaCCvhS0CoPZPaik80+7Z6jOWiVPODWobdnf
        mY2dECzhXDhmdonCmUHgRAsXnPzhOUiMv5jvDnGKA+WVOQt6yUJBgSFdNyEQaOKUo745nGufvtTMl
        gMBTm92iYMlNFpznNXZVn69Km/IC7m2suJShM1QjSvogb00+qJrZ/ErJcQdR/w4LymTj6c2QMcfEO
        rDwPDBrA==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5925-0000HP-IS; Fri, 21 Feb 2020 14:11:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/31] xfs: pass an initialized xfs_da_args to xfs_attr_get
Date:   Fri, 21 Feb 2020 06:11:35 -0800
Message-Id: <20200221141154.476496-13-hch@lst.de>
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

Instead of converting from one style of arguments to another in
xfs_attr_set, pass the structure from higher up in the call chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++----------------------------
 fs/xfs/libxfs/xfs_attr.h |  4 +-
 fs/xfs/xfs_acl.c         | 35 ++++++++----------
 fs/xfs/xfs_ioctl.c       | 25 ++++++++-----
 fs/xfs/xfs_xattr.c       | 24 ++++++------
 5 files changed, 68 insertions(+), 100 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index eea6d90af276..288b39e81efd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -56,26 +56,6 @@ STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
-
-STATIC int
-xfs_attr_args_init(
-	struct xfs_da_args	*args,
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
-{
-	memset(args, 0, sizeof(*args));
-	args->geo = dp->i_mount->m_attr_geo;
-	args->whichfork = XFS_ATTR_FORK;
-	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
-	return 0;
-}
-
 int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
@@ -115,15 +95,15 @@ xfs_attr_get_ilocked(
 /*
  * Retrieve an extended attribute by name, and its value if requested.
  *
- * If ATTR_KERNOVAL is set in @flags, then the caller does not want the value,
- * just an indication whether the attribute exists and the size of the value if
- * it exists. The size is returned in @valuelenp,
+ * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
+ * value, just an indication whether the attribute exists and the size of the
+ * value if it exists. The size is returned in args.valuelen.
  *
  * If the attribute is found, but exceeds the size limit set by the caller in
- * @valuelenp, return -ERANGE with the size of the attribute that was found in
- * @valuelenp.
+ * args->valuelen, return -ERANGE with the size of the attribute that was found
+ * in args->valuelen.
  *
- * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
+ * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
  * existence of the attribute has been determined. On success, return that
  * buffer to the caller and leave them to free it. On failure, free any
  * allocated buffer and ensure the buffer pointer returned to the caller is
@@ -131,51 +111,37 @@ xfs_attr_get_ilocked(
  */
 int
 xfs_attr_get(
-	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
-	unsigned char		**value,
-	int			*valuelenp,
-	int			flags)
+	struct xfs_da_args	*args)
 {
-	struct xfs_da_args	args;
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
+	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
 
-	XFS_STATS_INC(ip->i_mount, xs_attr_get);
+	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
-	if (error)
-		return error;
+	args->geo = args->dp->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/* Entirely possible to look up a name which doesn't exist */
-	args.op_flags = XFS_DA_OP_OKNOENT;
-	if (flags & ATTR_ALLOC)
-		args.op_flags |= XFS_DA_OP_ALLOCVAL;
-	else
-		args.value = *value;
-	args.valuelen = *valuelenp;
+	args->op_flags = XFS_DA_OP_OKNOENT;
+	if (args->flags & ATTR_ALLOC)
+		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
-	lock_mode = xfs_ilock_attr_map_shared(ip);
-	error = xfs_attr_get_ilocked(ip, &args);
-	xfs_iunlock(ip, lock_mode);
-	*valuelenp = args.valuelen;
+	lock_mode = xfs_ilock_attr_map_shared(args->dp);
+	error = xfs_attr_get_ilocked(args->dp, args);
+	xfs_iunlock(args->dp, lock_mode);
 
 	/* on error, we have to clean up allocated value buffers */
-	if (error) {
-		if (flags & ATTR_ALLOC) {
-			kmem_free(args.value);
-			*value = NULL;
-		}
-		return error;
+	if (error && (args->flags & ATTR_ALLOC)) {
+		kmem_free(args->value);
+		args->value = NULL;
 	}
-	*value = args.value;
-	return 0;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 07ca543db831..be77d13a2902 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -146,9 +146,7 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
+int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index e9ae7cbe1973..780924984492 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -120,34 +120,31 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 struct posix_acl *
 xfs_get_acl(struct inode *inode, int type)
 {
-	struct xfs_inode *ip = XFS_I(inode);
-	struct posix_acl *acl = NULL;
-	struct xfs_acl *xfs_acl = NULL;
-	unsigned char *ea_name;
-	int error;
-	int len;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct posix_acl	*acl = NULL;
+	struct xfs_da_args	args = {
+		.dp		= ip,
+		.flags		= ATTR_ALLOC | ATTR_ROOT,
+		.valuelen	= XFS_ACL_MAX_SIZE(mp),
+	};
+	int			error;
 
 	trace_xfs_get_acl(ip);
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		args.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
-		ea_name = SGI_ACL_DEFAULT;
+		args.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		BUG();
 	}
+	args.namelen = strlen(args.name);
 
-	/*
-	 * If we have a cached ACLs value just return it, not need to
-	 * go out to the disk.
-	 */
-	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
-				(unsigned char **)&xfs_acl, &len,
-				ATTR_ALLOC | ATTR_ROOT);
+	error = xfs_attr_get(&args);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
@@ -156,9 +153,9 @@ xfs_get_acl(struct inode *inode, int type)
 		if (error != -ENOATTR)
 			acl = ERR_PTR(error);
 	} else  {
-		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
-					XFS_ACL_MAX_ENTRIES(ip->i_mount));
-		kmem_free(xfs_acl);
+		acl = xfs_acl_from_disk(mp, args.value, args.valuelen,
+					XFS_ACL_MAX_ENTRIES(mp));
+		kmem_free(args.value);
 	}
 	return acl;
 }
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index eb59be2ebfb0..ce393a97c85c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -357,27 +357,32 @@ xfs_attrmulti_attr_get(
 	uint32_t		*len,
 	uint32_t		flags)
 {
-	unsigned char		*kbuf;
-	int			error = -EFAULT;
-	size_t			namelen;
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.flags		= flags,
+		.name		= name,
+		.namelen	= strlen(name),
+		.valuelen	= *len,
+	};
+	int			error;
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
-	kbuf = kmem_zalloc_large(*len, 0);
-	if (!kbuf)
+
+	args.value = kmem_zalloc_large(*len, 0);
+	if (!args.value)
 		return -ENOMEM;
 
-	namelen = strlen(name);
-	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
-			     flags);
+	error = xfs_attr_get(&args);
 	if (error)
 		goto out_kfree;
 
-	if (copy_to_user(ubuf, kbuf, *len))
+	*len = args.valuelen;
+	if (copy_to_user(ubuf, args.value, args.valuelen))
 		error = -EFAULT;
 
 out_kfree:
-	kmem_free(kbuf);
+	kmem_free(args.value);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7c140fb93bf8..d3b3264dae78 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -21,22 +21,24 @@ static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, void *value, size_t size)
 {
-	int xflags = handler->flags;
-	struct xfs_inode *ip = XFS_I(inode);
-	int error, asize = size;
-	size_t namelen = strlen(name);
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.flags		= handler->flags,
+		.name		= name,
+		.namelen	= strlen(name),
+		.value		= value,
+		.valuelen	= size,
+	};
+	int			error;
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (!size) {
-		xflags |= ATTR_KERNOVAL;
-		value = NULL;
-	}
+	if (!size)
+		args.flags |= ATTR_KERNOVAL;
 
-	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
-			     &asize, xflags);
+	error = xfs_attr_get(&args);
 	if (error)
 		return error;
-	return asize;
+	return args.valuelen;
 }
 
 void
-- 
2.24.1

