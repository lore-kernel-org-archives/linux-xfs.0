Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74455C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9624A2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aEQ9DYRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391182AbfIEWTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391116AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8il078144
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=l/u1MMDWBzRtygzmC+38HX5JV8o13IdEp5duevBRbcQ=;
 b=aEQ9DYRfUQFOGMAW5TJrKE4IOrcfo7to01ADCGdVXw3e83bN6XyFZV9zKsmM+4ljRpyY
 1M2kWaw2kuHsFREOfWvv2ReCnsgrHhjK9GKTWFQBfaXlcYxbYdERyAHvt/FRiAOTe59B
 ktyaMYPONI0wU0OnKtHrluxjpkoC72IpXA1mr2Dv0X8/rHULKfhQeLksaqsfZPeRTIXh
 mAxPkN5U3+nLUd/iICHslUqLjsNkbq/9zAOzqRXFHHIn9//SzUmTcWwq9Q88cnrQYKQ8
 2Q0nZ7f/X6np0yfDMcFQMZusv2gEPciwcgpAx6MRt/ayj9qw/V15+pWDCBVnGApPbgQe CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uuaqj02kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOhe101602
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b946hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:18:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MIiDJ008662
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:44 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:43 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 01/19] xfs: Replace attribute parameters with struct xfs_name
Date:   Thu,  5 Sep 2019 15:18:19 -0700
Message-Id: <20190905221837.17388-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch replaces the attribute name, length and flags parameters with a
single struct xfs_name parameter.  This helps to clean up the numbers of
parameters being passed around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 46 +++++++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
 fs/xfs/xfs_acl.c         | 27 +++++++++++++--------------
 fs/xfs/xfs_ioctl.c       | 28 ++++++++++++++++++----------
 fs/xfs/xfs_iops.c        | 12 ++++++++----
 fs/xfs/xfs_xattr.c       | 30 +++++++++++++++++-------------
 6 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7589cb7..d0308d6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -61,9 +61,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 
 	if (!name)
@@ -73,9 +71,9 @@ xfs_attr_args_init(
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->flags = name->type;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -139,30 +137,28 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		**value,
-	int			*valuelenp,
-	int			flags)
+	int			*valuelenp)
 {
 	struct xfs_da_args	args;
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
+	ASSERT((name->type & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
 
 	XFS_STATS_INC(ip->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name);
 	if (error)
 		return error;
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args.op_flags = XFS_DA_OP_OKNOENT;
-	if (flags & ATTR_ALLOC)
+	if (name->type & ATTR_ALLOC)
 		args.op_flags |= XFS_DA_OP_ALLOCVAL;
 	else
 		args.value = *value;
@@ -175,7 +171,7 @@ xfs_attr_get(
 
 	/* on error, we have to clean up allocated value buffers */
 	if (error) {
-		if (flags & ATTR_ALLOC) {
+		if (name->type & ATTR_ALLOC) {
 			kmem_free(args.value);
 			*value = NULL;
 		}
@@ -339,16 +335,14 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (name->type & ATTR_ROOT) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
@@ -356,7 +350,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -419,7 +413,7 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
@@ -444,9 +438,7 @@ xfs_attr_set(
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
@@ -457,7 +449,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -478,7 +470,7 @@ xfs_attr_remove(
 	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
 			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			(name->type & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
 			&args.trans);
 	if (error)
 		return error;
@@ -501,7 +493,7 @@ xfs_attr_remove(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 106a2f2..cedb4e2 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -144,14 +144,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char **value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 12be708..f8fb6e10 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -113,7 +113,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl = NULL;
 	struct xfs_acl *xfs_acl = NULL;
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 	int len;
 
@@ -121,10 +121,10 @@ xfs_get_acl(struct inode *inode, int type)
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		name.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
-		ea_name = SGI_ACL_DEFAULT;
+		name.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		BUG();
@@ -135,9 +135,9 @@ xfs_get_acl(struct inode *inode, int type)
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	error = xfs_attr_get(ip, ea_name, strlen(ea_name), 
-				(unsigned char **)&xfs_acl, &len,
-				ATTR_ALLOC | ATTR_ROOT);
+	name.len = strlen(name.name);
+	name.type = ATTR_ALLOC | ATTR_ROOT;
+	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
@@ -157,17 +157,17 @@ int
 __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		name.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
 			return acl ? -EACCES : 0;
-		ea_name = SGI_ACL_DEFAULT;
+		name.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		return -EINVAL;
@@ -187,17 +187,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
-		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
-				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
+		name.len = strlen(name.name);
+		name.type = ATTR_ROOT;
+		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name,
-					strlen(ea_name),
-					ATTR_ROOT);
+		error = xfs_attr_remove(ip, &name);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d440426..626420d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -431,7 +431,11 @@ xfs_attrmulti_attr_get(
 {
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
-	size_t			namelen;
+	struct xfs_name		xname = {
+		.name		= name,
+		.len		= strlen(name),
+		.type		= flags,
+	};
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
@@ -439,9 +443,7 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	namelen = strlen(name);
-	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
-			     flags);
+	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len);
 	if (error)
 		goto out_kfree;
 
@@ -463,7 +465,7 @@ xfs_attrmulti_attr_set(
 {
 	unsigned char		*kbuf;
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -474,8 +476,10 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	namelen = strlen(name);
-	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
+	xname.name = name;
+	xname.len = strlen(name);
+	xname.type = flags;
+	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
@@ -489,12 +493,16 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname = {
+		.name		= name,
+		.len		= strlen(name),
+		.type		= flags,
+	};
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	namelen = strlen(name);
-	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
+
+	error = xfs_attr_remove(XFS_I(inode), &xname);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 92de0a7..469e8e2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -49,10 +49,14 @@ xfs_initxattrs(
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name,
-				     strlen(xattr->name),
-				     xattr->value, xattr->value_len,
-				     ATTR_SECURE);
+		struct xfs_name	name = {
+			.name	= xattr->name,
+			.len	= strlen(xattr->name),
+			.type	= ATTR_SECURE,
+		};
+
+		error = xfs_attr_set(ip, &name,
+				     xattr->value, xattr->value_len);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 59ffe6c..6309da4 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -20,19 +20,21 @@ static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, void *value, size_t size)
 {
-	int xflags = handler->flags;
 	struct xfs_inode *ip = XFS_I(inode);
 	int error, asize = size;
-	size_t namelen = strlen(name);
+	struct xfs_name xname = {
+		.name	= name,
+		.len	= strlen(name),
+		.type	= handler->flags
+	};
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
-		xflags |= ATTR_KERNOVAL;
+		xname.type |= ATTR_KERNOVAL;
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
-			     &asize, xflags);
+	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize);
 	if (error)
 		return error;
 	return asize;
@@ -65,23 +67,25 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, const void *value,
 		size_t size, int flags)
 {
-	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
-	size_t			namelen = strlen(name);
+	struct xfs_name		xname = {
+		.name		= name,
+		.len		= strlen(name),
+		.type		= handler->flags,
+	};
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
-		xflags |= ATTR_CREATE;
+		xname.type |= ATTR_CREATE;
 	if (flags & XATTR_REPLACE)
-		xflags |= ATTR_REPLACE;
+		xname.type |= ATTR_REPLACE;
 
 	if (!value)
-		return xfs_attr_remove(ip, name,
-				       namelen, xflags);
-	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
+		return xfs_attr_remove(ip, &xname);
+	error = xfs_attr_set(ip, &xname, (void *)value, size);
 	if (!error)
-		xfs_forget_acl(inode, name, xflags);
+		xfs_forget_acl(inode, name, xname.type);
 
 	return error;
 }
-- 
2.7.4

