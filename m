Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80249FC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE0F21848
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tms79+Wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbfKGB3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfKGB3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71T20l155110
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ljQiaOPoeVKzOLGyQMJy9beXzbyv6TFhWQ5KUh9Xp8A=;
 b=Tms79+Wu+111Reob7bgEPNGJ8nPYYvL7qOuCV3nLVgXi7+FkmZyZ8t3BQtPJevdptCc8
 qskDYCnu3OHlhHfHrCnTTcm+VhHG37JCeoXcNvqNoQqtOyM9Q2kkLgCnjZczPjfU6eOh
 Zap9F+xUFd/qcCZJvrJZsuvJo6InrubZKlqpIc8XinB91/JbZn6Dqs/77GBj+XCyaRkY
 uUm6+DUsRI3pbo5Sxadmpq1zSqRqq2bz1GpUyYC+3wBXN3Y15/UDnUgeCdqGAkk8XBLA
 uC4E4NINldHZsUXWbv8EhcyYufSYRCZ/VJIg6gq5Gn3aer0HcEza1BMulSpoysFkvUdI cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w0tq71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71Sxii008272
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wdmsvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71Sjfv011236
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:45 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:45 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 01/17] xfs: Remove all strlen in all xfs_attr_* functions for attr names.
Date:   Wed,  6 Nov 2019 18:27:45 -0700
Message-Id: <20191107012801.22863-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This helps to pre-simplify the extra handling of the null terminator in
delayed operations which use memcpy rather than strlen.  Later
when we introduce parent pointers, attribute names will become binary,
so strlen will not work at all.  Removing uses of strlen now will
help reduce complexities later

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 12 ++++++++----
 fs/xfs/libxfs/xfs_attr.h |  8 +++++---
 fs/xfs/xfs_acl.c         | 11 +++++++----
 fs/xfs/xfs_ioctl.c       | 13 ++++++++++---
 fs/xfs/xfs_iops.c        |  6 ++++--
 fs/xfs/xfs_xattr.c       | 11 +++++++----
 6 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 510ca69..7589cb7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -62,6 +62,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -74,7 +75,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -139,6 +140,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		**value,
 	int			*valuelenp,
 	int			flags)
@@ -154,7 +156,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -338,6 +340,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -353,7 +356,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -442,6 +445,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -453,7 +457,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 94badfa..106a2f2 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -145,11 +145,13 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char **value, int *valuelenp, int flags);
+		 size_t namelen, unsigned char **value, int *valuelenp,
+		 int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 96d7071..12be708 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -135,7 +135,8 @@ xfs_get_acl(struct inode *inode, int type)
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
+	error = xfs_attr_get(ip, ea_name, strlen(ea_name), 
+				(unsigned char **)&xfs_acl, &len,
 				ATTR_ALLOC | ATTR_ROOT);
 	if (error) {
 		/*
@@ -186,15 +187,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
-		error = xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
-				len, ATTR_ROOT);
+		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
+				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name, ATTR_ROOT);
+		error = xfs_attr_remove(ip, ea_name,
+					strlen(ea_name),
+					ATTR_ROOT);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 800f070..269c321 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -432,6 +432,7 @@ xfs_attrmulti_attr_get(
 {
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
+	size_t			namelen;
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
@@ -439,7 +440,9 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	error = xfs_attr_get(XFS_I(inode), name, &kbuf, (int *)len, flags);
+	namelen = strlen(name);
+	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
+			     flags);
 	if (error)
 		goto out_kfree;
 
@@ -461,6 +464,7 @@ xfs_attrmulti_attr_set(
 {
 	unsigned char		*kbuf;
 	int			error;
+	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -471,7 +475,8 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+	namelen = strlen(name);
+	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
@@ -485,10 +490,12 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
+	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	error = xfs_attr_remove(XFS_I(inode), name, flags);
+	namelen = strlen(name);
+	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 18e45e3..7f47f87 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -49,8 +49,10 @@ xfs_initxattrs(
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name, xattr->value,
-				      xattr->value_len, ATTR_SECURE);
+		error = xfs_attr_set(ip, xattr->name,
+				     strlen(xattr->name),
+				     xattr->value, xattr->value_len,
+				     ATTR_SECURE);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index cb895b1..59ffe6c 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -23,6 +23,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	int xflags = handler->flags;
 	struct xfs_inode *ip = XFS_I(inode);
 	int error, asize = size;
+	size_t namelen = strlen(name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
@@ -30,7 +31,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, name, (unsigned char **)&value, &asize, xflags);
+	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
+			     &asize, xflags);
 	if (error)
 		return error;
 	return asize;
@@ -66,6 +68,7 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
+	size_t			namelen = strlen(name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
@@ -74,9 +77,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		xflags |= ATTR_REPLACE;
 
 	if (!value)
-		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	error = xfs_attr_set(ip, (unsigned char *)name,
-				(void *)value, size, xflags);
+		return xfs_attr_remove(ip, name,
+				       namelen, xflags);
+	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
 	if (!error)
 		xfs_forget_acl(inode, name, xflags);
 
-- 
2.7.4

