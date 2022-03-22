Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8E8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 06:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiCVGIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiCVGIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 02:08:17 -0400
Received: from mail1.bemta36.messagelabs.com (mail1.bemta36.messagelabs.com [85.158.142.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDED7E23
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 23:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1647929205; i=@fujitsu.com;
        bh=IHUsWU5cN4WnTtlPo3SLdJHYN298iRKXLy+biFihrsw=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=JjDaSM8k1FsPFbdCLrdd7+48kS0JjaEcDa4sycWinNwlLCN3+0cyRNrL5wc/c2EgZ
         A7mz7IYuXXxKnBI+xwvCmuFDt5LXe9ukx40uLAAyTSr4dGJ5nYfhUQUOtlffoctW8b
         t+OGa/Ha2zryj6xp4f+Wst/F+ufVmYDv0e75Gu3vhCwwTecxz/Ek7fc+hxm+g5hJyk
         lnlQKgPG4mXDzWrJAKYQsZjBHIZOS4JRTfWyK+Y1WrroVciFVZnp8xJAYlIkShsFjO
         dIlse78ZUb9Ge5Nh+tbobji3JkVckUv4pqwMMoF4haLJoKDj6DS4ZBA5ioDueVf8Ut
         +YtZZ6Jsa2eZQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRWlGSWpSXmKPExsViZ8ORqFuSbpl
  k0PNXyeLyEz6LXX92sFv8uHWDxYHZY9OqTjaPMwuOsHt83iQXwBzFmpmXlF+RwJqx5eh6loJ+
  24oFjy+xNjDeNepi5OIQEtjCKNG+9SwzhLOASWLr9KNMEM4eRol3jU9Zuxg5OdgENCWedS5gB
  rFFBOQl+hu/MYLYzAJ+Egfm/AOzhQUiJFbNbASrZxFQlei9PBcszivgITFh+0kwW0JAQWLKw/
  fMEHFBiZMzn7BAzJGQOPjiBTNEjaLEpY5vUPUVErNmtTFB2GoSV89tYp7AyD8LSfssJO0LGJl
  WMdomFWWmZ5TkJmbm6BoaGOgaGprqmlnqGhvrJVbpJuqlluomp+aVFCUCZfUSy4v1UouL9Yor
  c5NzUvTyUks2MQIDOKXYVXEH47W+n3qHGCU5mJREeecFWyYJ8SXlp1RmJBZnxBeV5qQWH2KU4
  eBQkuAtjQLKCRalpqdWpGXmAKMJJi3BwaMkwlsVC5TmLS5IzC3OTIdInWI05ljbcGAvM8fOLZ
  f3Mgux5OXnpUqJ8x5MBSoVACnNKM2DGwSL8kuMslLCvIwMDAxCPAWpRbmZJajyrxjFORiVhHk
  fg0zhycwrgdv3CugUJqBT9FnNQE4pSURISTUwxWg+uHgyNLbUvrW8ft3+olZOgUmp4icfy0S1
  TBSvvTF/8nuj72zmh/LXLN7St08zP/Iv7wv9vNnGHMs+fBTfcqPt52OTbQq/tFyvPlsboce4s
  v9Gck+9ilPvbe/KxwJf5t20Pq1144/NkUPdzY+Tls51j1rcnThjUvMy0TaNqANJX/cJMIm1XH
  vUuf999wwR7kkG/tE3fVRPVvSeSlKR3O/74UbQ3n6haUZdeTn7OCY2cs3w/eEpmuLgEHzwWOX
  UPeHMebM5bX7w2srpxxT8+bTJIHBD0iPpH7ZysWI2sZelnrSV7rt5svXhjVsHEs6/VPjT9pfh
  /mdurlt+J5VY0012S1u7Vs6dM1NyxccZSizFGYmGWsxFxYkAL9x7z20DAAA=
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-10.tower-532.messagelabs.com!1647929204!214543!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.10; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 13024 invoked from network); 22 Mar 2022 06:06:44 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-10.tower-532.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 22 Mar 2022 06:06:44 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 071A110018E;
        Tue, 22 Mar 2022 06:06:44 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id DD161100186;
        Tue, 22 Mar 2022 06:06:43 +0000 (GMT)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 22 Mar 2022 06:06:21 +0000
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <djwong@kernel.org>, <pvorel@suse.cz>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [RFC] xfs: fix up non-directory creation in SGID directories when umask S_IXGRP
Date:   Tue, 22 Mar 2022 14:06:59 +0800
Message-ID: <1647929219-5388-1-git-send-email-xuyang2018.jy@fujitsu.com>
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

Petr reported a problem that S_ISGID bit was not clean when testing ltp case
create09[1] by using umask(077).

It fails because xfs will call posix_acl_create before xfs_init_new_node calls
inode_init_owner, so S_IXGRP mode will be clear when enable CONFIG_XFS_POSIXACL
and doesn't set acl or default acl on dir, then inode_init_owner will not clear
S_ISGID bit.

The calltrace as below:

   will use  inode_init_owner(struct user_namespace *mnt_userns, structinode *inode)
[  296.760675]  xfs_init_new_inode+0x10e/0x6c0
[  296.760678]  xfs_create+0x401/0x610
   will use posix_acl_create(dir, &mode, &default_acl, &acl);
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

[1]https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/creat/creat09.c
Reported-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/xfs_inode.c | 54 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_iops.c  | 63 ++++------------------------------------------
 2 files changed, 57 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 26227d26f274..8127b83b376c 100644
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
@@ -805,7 +837,7 @@ xfs_init_new_inode(
 	int			error;
 	struct timespec64	tv;
 	struct inode		*inode;
-
+	struct posix_acl 	*default_acl, *acl;
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
 	 * xfs_iget checks will catch re-allocation of other active in-memory
@@ -893,6 +925,9 @@ xfs_init_new_inode(
 		ASSERT(0);
 	}
 
+	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (error)
+		return error;
 	/*
 	 * If we need to create attributes immediately after allocating the
 	 * inode, initialise an empty attribute fork right now. We use the
@@ -902,7 +937,9 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if (init_xattrs &&
+	    xfs_create_need_xattr(dir, default_acl, acl) &&
+	    xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -916,6 +953,19 @@ xfs_init_new_inode(
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
 
+#ifdef CONFIG_XFS_POSIX_ACL
+	if (default_acl) {
+		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		if (error)
+			posix_acl_release(default_acl);
+	}
+	if (acl) {
+		error = __xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		if (error)
+			posix_acl_release(acl);
+	}
+#endif
+
 	*ipp = ip;
 	return 0;
 }
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

