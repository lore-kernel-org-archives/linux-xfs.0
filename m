Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D760C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbiEVP2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348050AbiEVP2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E1A38D80
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBCF5B80CA1
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C8C385AA;
        Sun, 22 May 2022 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233322;
        bh=1kUjgI2oR9LePoUX7NuK4eBiQy2laS3btT80KFpWSBE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o++qxEPfXkf7TAJVyfYsnZE8+cje/UN1I98wLbaMg2JJmTxmAz0sCjbkvVoIuIwC2
         74f/QFcSooRXYggKXgFY9SrWqDt8kMITDzsWpeqst4NCo14NXRSKtw06FN0WF03Nb4
         gHsBWCeDi83Grn+DyDd3CcTjMCc36WwtrjCwLAA47NT9L6VaWWyPfl4r3iAXgTVQq7
         Mh612x0vq3fRxao9zcy31LtKENLvkbHKH4OG3KXMYjHmM44shat+gXOMBTT2VpmLn0
         6h2gDVLlKnM6/8YBehaWjDPc+l7DzdV1Flgqw8zqx8AKLhMBn62ox+yHC/8EGBi4WX
         RGZtPAXrVgVfg==
Subject: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:42 -0700
Message-ID: <165323332197.78886.8893427108008735872.stgit@magnolia>
In-Reply-To: <165323329374.78886.11371349029777433302.stgit@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

libxfs itself should never be messing with whether or not to enable
logging for extended attribute updates -- this decision should be made
on a case-by-case basis by libxfs callers.  Move the code that actually
enables the log features to xfs_xattr.c, and adjust the callers.

This removes an awkward coupling point between libxfs and what would be
libxlog, if the XFS log were actually its own library.  Furthermore, it
makes bulk attribute updates and inode security initialization a tiny
bit more efficient, since they now avoid cycling the log feature between
every single xattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   12 +-------
 fs/xfs/xfs_acl.c         |   10 +++++++
 fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
 fs/xfs/xfs_ioctl.h       |    2 +
 fs/xfs/xfs_ioctl32.c     |    4 ++-
 fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
 fs/xfs/xfs_log.c         |   45 --------------------------------
 fs/xfs/xfs_log.h         |    1 -
 fs/xfs/xfs_super.h       |    2 +
 fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 120 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1de3db88e006..682ad9563fe0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -982,7 +982,6 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
-	bool			need_rele = false;
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -1027,12 +1026,6 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
-	if (xfs_has_larp(mp)) {
-		error = xfs_attr_use_log_assist(mp, &need_rele);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
@@ -1040,7 +1033,7 @@ xfs_attr_set(
 	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		goto drop_incompat;
+		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -1100,9 +1093,6 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-drop_incompat:
-	if (need_rele)
-		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3df9c1782ead..b0928175a3f4 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -17,6 +17,7 @@
 #include "xfs_error.h"
 #include "xfs_acl.h"
 #include "xfs_trans.h"
+#include "xfs_log.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -174,10 +175,12 @@ int
 __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_da_args	args = {
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_ROOT,
 	};
+	bool			need_rele = false;
 	int			error;
 
 	switch (type) {
@@ -202,8 +205,15 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
+	if (xfs_has_larp(mp)) {
+		error = xfs_xattr_use_log_assist(mp, &need_rele);
+		if (error)
+			return error;
+	}
+
 	error = xfs_attr_set(&args);
 	kmem_free(args.value);
+	xfs_xattr_rele_log_assist(mp, need_rele);
 
 	/*
 	 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e5cb7936206..b22c7c87ec08 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_log.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -501,7 +502,8 @@ xfs_attrmulti_attr_set(
 	unsigned char		*name,
 	const unsigned char	__user *ubuf,
 	uint32_t		len,
-	uint32_t		flags)
+	uint32_t		flags,
+	bool			*need_rele)
 {
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
@@ -510,6 +512,7 @@ xfs_attrmulti_attr_set(
 		.name		= name,
 		.namelen	= strlen(name),
 	};
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
 	int			error;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
@@ -524,6 +527,12 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
+	if (!(*need_rele) && xfs_has_larp(mp)) {
+		error = xfs_xattr_use_log_assist(mp, need_rele);
+		if (error)
+			return error;
+	}
+
 	error = xfs_attr_set(&args);
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
@@ -539,7 +548,8 @@ xfs_ioc_attrmulti_one(
 	void __user		*uname,
 	void __user		*value,
 	uint32_t		*len,
-	uint32_t		flags)
+	uint32_t		flags,
+	bool			*need_rele)
 {
 	unsigned char		*name;
 	int			error;
@@ -563,7 +573,8 @@ xfs_ioc_attrmulti_one(
 		error = mnt_want_write_file(parfilp);
 		if (error)
 			break;
-		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags);
+		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags,
+				need_rele);
 		mnt_drop_write_file(parfilp);
 		break;
 	default:
@@ -584,6 +595,7 @@ xfs_attrmulti_by_handle(
 	xfs_attr_multiop_t	*ops;
 	xfs_fsop_attrmulti_handlereq_t am_hreq;
 	struct dentry		*dentry;
+	bool			need_rele = false;
 	unsigned int		i, size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -615,8 +627,10 @@ xfs_attrmulti_by_handle(
 		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
 				d_inode(dentry), ops[i].am_opcode,
 				ops[i].am_attrname, ops[i].am_attrvalue,
-				&ops[i].am_length, ops[i].am_flags);
+				&ops[i].am_length, ops[i].am_flags,
+				&need_rele);
 	}
+	xfs_xattr_rele_log_assist(XFS_I(d_inode(dentry))->i_mount, need_rele);
 
 	if (copy_to_user(am_hreq.ops, ops, size))
 		error = -EFAULT;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..18a7e0853277 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -31,7 +31,7 @@ xfs_readlink_by_handle(
 
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
-		uint32_t *len, uint32_t flags);
+		uint32_t *len, uint32_t flags, bool *need_rele);
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 2f54b701eead..a3874ce4469c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -372,6 +372,7 @@ xfs_compat_attrmulti_by_handle(
 	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
 	struct dentry				*dentry;
 	unsigned int				i, size;
+	bool					need_rele = false;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -404,8 +405,9 @@ xfs_compat_attrmulti_by_handle(
 				d_inode(dentry), ops[i].am_opcode,
 				compat_ptr(ops[i].am_attrname),
 				compat_ptr(ops[i].am_attrvalue),
-				&ops[i].am_length, ops[i].am_flags);
+				&ops[i].am_length, ops[i].am_flags, &need_rele);
 	}
+	xfs_xattr_rele_log_assist(XFS_I(d_inode(dentry))->i_mount, need_rele);
 
 	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
 		error = -EFAULT;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e912b7fee714..5a59c1a14344 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -24,6 +24,7 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
+#include "xfs_log.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -50,6 +51,8 @@ xfs_initxattrs(
 {
 	const struct xattr	*xattr;
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			*need_rele = fs_info;
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
@@ -61,6 +64,13 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
+
+		if (!(*need_rele) && xfs_has_larp(mp)) {
+			error = xfs_xattr_use_log_assist(mp, need_rele);
+			if (error)
+				return error;
+		}
+
 		error = xfs_attr_set(&args);
 		if (error < 0)
 			break;
@@ -77,12 +87,17 @@ xfs_initxattrs(
 
 STATIC int
 xfs_init_security(
-	struct inode	*inode,
-	struct inode	*dir,
-	const struct qstr *qstr)
+	struct inode		*inode,
+	struct inode		*dir,
+	const struct qstr	*qstr)
 {
-	return security_inode_init_security(inode, dir, qstr,
-					     &xfs_initxattrs, NULL);
+	bool			need_rele = false;
+	int			error;
+
+	error = security_inode_init_security(inode, dir, qstr, &xfs_initxattrs,
+			&need_rele);
+	xfs_xattr_rele_log_assist(XFS_I(inode)->i_mount, need_rele);
+	return error;
 }
 
 static void
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bd41e0dc95ff..1e972f884a81 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3877,48 +3877,3 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
-
-/*
- * Get permission to use log-assisted extended attribute updates.
- *
- * Callers must not be running any transactions or hold any inode locks, and
- * they must release the permission by calling xlog_drop_incompat_feat
- * when they're done.  The @need_rele parameter will be set to true if the
- * caller should drop permission after the call.
- */
-int
-xfs_attr_use_log_assist(
-	struct xfs_mount	*mp,
-	bool			*need_rele)
-{
-	int			error = 0;
-
-	/*
-	 * Protect ourselves from an idle log clearing the logged xattrs log
-	 * incompat feature bit.
-	 */
-	xlog_use_incompat_feat(mp->m_log);
-	*need_rele = true;
-
-	/*
-	 * If log-assisted xattrs are already enabled, the caller can use the
-	 * log assisted swap functions with the log-incompat reference we got.
-	 */
-	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
-		return 0;
-
-	/* Enable log-assisted xattrs. */
-	error = xfs_add_incompat_log_feature(mp,
-			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
-	if (error)
-		goto drop_incompat;
-
-	xfs_warn_daily(mp,
- "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
-
-	return 0;
-drop_incompat:
-	xlog_drop_incompat_feat(mp->m_log);
-	*need_rele = false;
-	return error;
-}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 166d2310af0b..67b839ccaa38 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -160,6 +160,5 @@ bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
-int xfs_attr_use_log_assist(struct xfs_mount *mp, bool *need_rele);
 
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 167d23f92ffe..65f839c5a7cd 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -92,6 +92,8 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 
 extern const struct export_operations xfs_export_operations;
 extern const struct xattr_handler *xfs_xattr_handlers[];
+int xfs_xattr_use_log_assist(struct xfs_mount *mp, bool *need_rele);
+void xfs_xattr_rele_log_assist(struct xfs_mount *mp, bool need_rele);
 extern const struct quotactl_ops xfs_quotactl_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7a044afd4c46..356971223f26 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -15,6 +15,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
+#include "xfs_log.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -39,6 +40,61 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	return args.valuelen;
 }
 
+/*
+ * Get permission to use log-assisted extended attribute updates.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.  The @need_rele parameter will be set to true if the
+ * caller should drop permission after the call.
+ */
+int
+xfs_xattr_use_log_assist(
+	struct xfs_mount	*mp,
+	bool			*need_rele)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+	*need_rele = true;
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+	if (error)
+		goto drop_incompat;
+
+	xfs_warn_daily(mp,
+ "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	*need_rele = false;
+	return error;
+}
+
+/* Release permission to use log-assisted xattr updates. */
+void
+xfs_xattr_rele_log_assist(
+	struct xfs_mount	*mp,
+	bool			need_rele)
+{
+	if (need_rele)
+		xlog_drop_incompat_feat(mp->m_log);
+}
+
 static int
 xfs_xattr_set(const struct xattr_handler *handler,
 	      struct user_namespace *mnt_userns, struct dentry *unused,
@@ -54,11 +110,20 @@ xfs_xattr_set(const struct xattr_handler *handler,
 		.value		= (void *)value,
 		.valuelen	= size,
 	};
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	bool			need_rele = false;
 	int			error;
 
+	if (xfs_has_larp(mp)) {
+		error = xfs_xattr_use_log_assist(mp, &need_rele);
+		if (error)
+			return error;
+	}
+
 	error = xfs_attr_set(&args);
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
+	xfs_xattr_rele_log_assist(mp, need_rele);
 	return error;
 }
 

