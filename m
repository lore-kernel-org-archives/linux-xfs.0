Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE270C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 08:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiCVIFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 04:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiCVIFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 04:05:10 -0400
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B443222516
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 01:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1647936221; i=@fujitsu.com;
        bh=HXl6R9aCSm6xGbW43kjgkaVKOUSKKcRbZzl4B0kVicM=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=PPRs6b9o+HDUM1kkQE7DYvZs9Q7yXg8wU2BwBYIooUktJWjOovOpB7HUc6z2Plrvy
         RKrL8emxNbyydbqLi73wFlFHd/JLvyAJ8elHfss4vGy+Oe6S8eKYiN8Z5dPsu0Sq/X
         HGWe5sC9zMngHOiX9cuaBoMVxy9eZmI781Y5SWV8s1bBnxXM+i0a8Ry39OSeG9/t1e
         Uplr/Hw6sPC7x3p1AprEt2t45UY8oxIrsJGioiKBPLzO/WdwcUeRtikADm88Hwc+XO
         4t0zqb95kXhVEdXrXq2JHlIBweZH6HqrK4ly0A8SsiqffyAgSvvP5rNmBoXc5GX72R
         UtjnQaPqvPk5w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRWlGSWpSXmKPExsViZ8ORqHunyTL
  JYOpNPYvLT/gsdv3ZwW7x49YNFgdmj02rOtk8ziw4wu7xeZNcAHMUa2ZeUn5FAmvGmtMXmQum
  eFVMvDaNvYFxmW0XIxeHkMAWRondn5+zQzgLmCQ+zv3H1MXICeTsYZTo+K4OYrMJaEo861zAD
  GKLCMhL9Dd+YwSxmQX8JA7M+Qdkc3AIC8RL3O8uBjFZBFQl3j10BKngFfCQ2Hp+F9hECQEFiS
  kP3zNDxAUlTs58wgIxRULi4IsXzBA1ihKXOiCmSwhUSMya1QbVqyZx9dwm5gmM/LOQtM9C0r6
  AkWkVo3VSUWZ6RkluYmaOrqGBga6hoamusbmuoZmRXmKVbqJeaqlueWpxiS6QW16sl1pcrFdc
  mZuck6KXl1qyiREYtinFqot2MO5f9VPvEKMkB5OSKO+8YMskIb6k/JTKjMTijPii0pzU4kOMM
  hwcShK8SwqBcoJFqempFWmZOcAYgklLcPAoifBeLwFK8xYXJOYWZ6ZDpE4xGnOsbTiwl5lj55
  bLe5mFWPLy81KlxHnPNAKVCoCUZpTmwQ2CxfYlRlkpYV5GBgYGIZ6C1KLczBJU+VeM4hyMSsK
  8c0Gm8GTmlcDtewV0ChPQKfqsZiCnlCQipKQamJav2qx9qzZx+fItx2rr3wc0X3dLVrIuE3qR
  VP9rxcZts/f8qygzsbqqcO/kFOm7AZKzdJmj5tlo/y+6uTv1K2vG9behL9zSV/yw35mRHOBqP
  7mL62XCzpWXt7w6/ral6EnLzpKr/YfcG/69TFkV0K5zlrXDKO5odvLN6Su1bmXkfXSNqXiYVh
  Okmj8n7at2896VSn1aWx/Uvpol3vyjcFZR2ZaXj/mCtp/TmWOheXeZ8MaVFufFYvJsE28HKbV
  dtv30/vkpJo6y590PbOvbw1bv+1vkJP9M48K67lDtT6Gckvy2m4K4tufe37hKIfjeoax1ojJp
  s3fsZnnyUehp/NtJCdM70hQjXjPwdqpfO6bEUpyRaKjFXFScCADpgTmkaAMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-15.tower-565.messagelabs.com!1647936220!239370!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.5; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 7958 invoked from network); 22 Mar 2022 08:03:40 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-15.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 22 Mar 2022 08:03:40 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 407DA100195;
        Tue, 22 Mar 2022 08:03:40 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 14BC710018F;
        Tue, 22 Mar 2022 08:03:40 +0000 (GMT)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 22 Mar 2022 08:03:32 +0000
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <djwong@kernel.org>, <pvorel@suse.cz>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [RFC RESEND] xfs: fix up non-directory creation in SGID directories when umask S_IXGRP
Date:   Tue, 22 Mar 2022 16:04:17 +0800
Message-ID: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Petr reported a problem that S_ISGID bit was not clean when testing ltp
case create09[1] by using umask(077).

It fails because xfs will call posix_acl_create before xfs_init_new_node
calls inode_init_owner, so S_IXGRP mode will be clear when enable CONFIG_XFS_POSIXACL
and doesn't set acl or default acl on dir, then inode_init_owner will not clear
S_ISGID bit.

The calltrace as below:

use inode_init_owner(mnt_userns, inode)
[  296.760675]  xfs_init_new_inode+0x10e/0x6c0
[  296.760678]  xfs_create+0x401/0x610
use posix_acl_create(dir, &mode, &default_acl, &acl);
[  296.760681]  xfs_generic_create+0x123/0x2e0
[  296.760684]  ? _raw_spin_unlock+0x16/0x30
[  296.760687]  path_openat+0xfb8/0x1210
[  296.760689]  do_filp_open+0xb4/0x120
[  296.760691]  ? file_tty_write.isra.31+0x203/0x340
[  296.760697]  ? __check_object_size+0x150/0x170
[  296.760699]  do_sys_openat2+0x242/0x310
[  296.760702]  do_sys_open+0x4b/0x80
[  296.760704]  do_syscall_64+0x3a/0x80

Fix this is simple, we can call posix_acl_create after xfs_init_new_inode completed,
so inode_init_owner can clear S_ISGID bit correctly like ext4 or btrfs does.

But commit e6a688c33238 ("xfs: initialise attr fork on inode create") has created
attr fork in advance according to acl, so a better solution is that moving these
functions into xfs_init_new_inode.

Convert init_attrs into init_acl because xfs_create/xfs_create_tmpfile in
xfs_generic_create will call posix_acl_create, and use nlink to decide whether
initialise attr fork on inode create.

[1]https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/creat/creat09.c

Reported-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_inode.h |  2 +-
 fs/xfs/xfs_iops.c  | 63 ++++-----------------------------------------
 3 files changed, 64 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 26227d26f274..935f28c08bbc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/posix_acl.h>
 
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -36,6 +37,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_acl.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -781,6 +783,36 @@ xfs_inode_inherit_flags2(
 	}
 }
 
+/*
+ * Check to see if we are likely to need an extended attribute to be added to
+ * the inode we are about to allocate. This allows the attribute fork to be
+ * created during the inode allocation, reducing the number of transactions we
+ * need to do in this fast path.
+ *
+ * The security checks are optimistic, but not guaranteed. The two LSMs that
+ * require xattrs to be added here (selinux and smack) are also the only two
+ * LSMs that add a sb->s_security structure to the superblock. Hence if security
+ * is enabled and sb->s_security is set, we have a pretty good idea that we are
+ * going to be asked to add a security xattr immediately after allocating the
+ * xfs inode and instantiating the VFS inode.
+ */
+static inline bool
+xfs_create_need_xattr(
+	struct inode    *dir,
+	struct posix_acl *default_acl,
+	struct posix_acl *acl)
+{
+	if (acl)
+		return true;
+	if (default_acl)
+		return true;
+#if IS_ENABLED(CONFIG_SECURITY)
+	if (dir->i_sb->s_security)
+		return true;
+#endif
+	return false;
+}
+
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
@@ -795,7 +827,7 @@ xfs_init_new_inode(
 	xfs_nlink_t		nlink,
 	dev_t			rdev,
 	prid_t			prid,
-	bool			init_xattrs,
+	bool			init_acl,
 	struct xfs_inode	**ipp)
 {
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
@@ -805,6 +837,7 @@ xfs_init_new_inode(
 	int			error;
 	struct timespec64	tv;
 	struct inode		*inode;
+	struct posix_acl	*default_acl = NULL, *acl = NULL;
 
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
@@ -893,6 +926,11 @@ xfs_init_new_inode(
 		ASSERT(0);
 	}
 
+	if (init_acl) {
+		error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+		if (error)
+			return error;
+	}
 	/*
 	 * If we need to create attributes immediately after allocating the
 	 * inode, initialise an empty attribute fork right now. We use the
@@ -902,7 +940,10 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if (init_acl &&
+	    nlink &&
+	    xfs_create_need_xattr(dir, default_acl, acl) &&
+	    xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -916,8 +957,19 @@ xfs_init_new_inode(
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
 
+#ifdef CONFIG_XFS_POSIX_ACL
+	if (default_acl) {
+		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		posix_acl_release(default_acl);
+	}
+	if (acl) {
+		if (!error)
+			error = __xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		posix_acl_release(acl);
+	}
+#endif
 	*ipp = ip;
-	return 0;
+	return error;
 }
 
 /*
@@ -962,7 +1014,7 @@ xfs_create(
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
-	bool			init_xattrs,
+	bool			init_acl,
 	xfs_inode_t		**ipp)
 {
 	int			is_dir = S_ISDIR(mode);
@@ -1037,7 +1089,7 @@ xfs_create(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
+				is_dir ? 2 : 1, rdev, prid, init_acl, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1161,7 +1213,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, true, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 740ab13d1aa2..b0cae7b48ea9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -448,7 +448,7 @@ xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
 int xfs_init_new_inode(struct user_namespace *mnt_userns, struct xfs_trans *tp,
 		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
-		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
+		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_acl,
 		struct xfs_inode **ipp);
 
 static inline int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b34e8e4344a8..5f9fcb6e7cf8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -127,37 +127,6 @@ xfs_cleanup_inode(
 	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
 }
 
-/*
- * Check to see if we are likely to need an extended attribute to be added to
- * the inode we are about to allocate. This allows the attribute fork to be
- * created during the inode allocation, reducing the number of transactions we
- * need to do in this fast path.
- *
- * The security checks are optimistic, but not guaranteed. The two LSMs that
- * require xattrs to be added here (selinux and smack) are also the only two
- * LSMs that add a sb->s_security structure to the superblock. Hence if security
- * is enabled and sb->s_security is set, we have a pretty good idea that we are
- * going to be asked to add a security xattr immediately after allocating the
- * xfs inode and instantiating the VFS inode.
- */
-static inline bool
-xfs_create_need_xattr(
-	struct inode	*dir,
-	struct posix_acl *default_acl,
-	struct posix_acl *acl)
-{
-	if (acl)
-		return true;
-	if (default_acl)
-		return true;
-#if IS_ENABLED(CONFIG_SECURITY)
-	if (dir->i_sb->s_security)
-		return true;
-#endif
-	return false;
-}
-
-
 STATIC int
 xfs_generic_create(
 	struct user_namespace	*mnt_userns,
@@ -169,7 +138,6 @@ xfs_generic_create(
 {
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl, *acl;
 	struct xfs_name	name;
 	int		error;
 
@@ -184,24 +152,19 @@ xfs_generic_create(
 		rdev = 0;
 	}
 
-	error = posix_acl_create(dir, &mode, &default_acl, &acl);
-	if (error)
-		return error;
-
 	/* Verify mode is valid also for tmpfile case */
 	error = xfs_dentry_mode_to_name(&name, dentry, mode);
 	if (unlikely(error))
-		goto out_free_acl;
+		return error;
 
 	if (!tmpfile) {
 		error = xfs_create(mnt_userns, XFS_I(dir), &name, mode, rdev,
-				xfs_create_need_xattr(dir, default_acl, acl),
-				&ip);
+				true, &ip);
 	} else {
 		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
 	}
 	if (unlikely(error))
-		goto out_free_acl;
+		return error;
 
 	inode = VFS_I(ip);
 
@@ -209,19 +172,6 @@ xfs_generic_create(
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
-#ifdef CONFIG_XFS_POSIX_ACL
-	if (default_acl) {
-		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
-		if (error)
-			goto out_cleanup_inode;
-	}
-	if (acl) {
-		error = __xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
-		if (error)
-			goto out_cleanup_inode;
-	}
-#endif
-
 	xfs_setup_iops(ip);
 
 	if (tmpfile) {
@@ -240,17 +190,14 @@ xfs_generic_create(
 
 	xfs_finish_inode_setup(ip);
 
- out_free_acl:
-	posix_acl_release(default_acl);
-	posix_acl_release(acl);
-	return error;
+	return 0;
 
  out_cleanup_inode:
 	xfs_finish_inode_setup(ip);
 	if (!tmpfile)
 		xfs_cleanup_inode(dir, inode, dentry);
 	xfs_irele(ip);
-	goto out_free_acl;
+	return error;
 }
 
 STATIC int
-- 
2.27.0

