Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74040C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiLaBOT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiLaBOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:14:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF4018E30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B01ECE1921
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E7CC433D2;
        Sat, 31 Dec 2022 01:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449254;
        bh=/heM1ZPC3PURgd83vq9uzCv0YjiU97tvFBpQV9U+qXU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c0iB48yRyKqcH6bFS6Sw0xL2qUBrjs5e8Cs3FYkoavYJZO68xwoL1wFGB75KzbWGN
         ZtbKe8sXgVwPjwkJj/As6V48hedotFPnslP9KxHu34Ns6AKEuQR4Vs8ZO3F5/QpUDs
         QsEr8MJgHHUE1x+7qwZ7koqNMTQ+aY/yBRhLY/QHbC9u9rG7namVYHtNY1AhM9pZJb
         A7z88jAz25OqVVqSyBTEwrHWZH+nxWRz0eWeHwVnCGCOFk4ASmV4tUCoxJXxKdLUlQ
         HKpAtg30DMnzG0Fm5UVPA6BJQCS8768PsYhfKHcoRWPG+xzFZRo67P1DXqROiEVc5d
         pyZt+OB/KVX4Q==
Subject: [PATCH 15/23] xfs: hide metadata inodes from everyone because they
 are special
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864669.708110.10147796623388213764.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Metadata inodes are private files and therefore cannot be exposed to
userspace.  This means no bulkstat, no open-by-handle, no linking them
into the directory tree, and no feeding them to LSMs.  As such, we mark
them S_PRIVATE, which stops all that.

While we're at it, put them in a separate lockdep class so that it won't
get confused by "recursive" i_rwsem locking such as what happens when we
write to a rt file and need to allocate from the rt bitmap file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    8 ++++++++
 fs/xfs/xfs_iops.c       |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index beaaebf27284..9ae556fa4b7a 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -805,6 +805,14 @@ xrep_is_tempfile(
 	const struct xfs_inode	*ip)
 {
 	const struct inode	*inode = &ip->i_vnode;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/*
+	 * Files in the metadata directory tree also have S_PRIVATE set and
+	 * IOP_XATTR unset, so we must distinguish them separately.
+	 */
+	if (xfs_has_metadir(mp) && (ip->i_diflags2 & XFS_DIFLAG2_METADATA))
+		return false;
 
 	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
 		return true;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d580bf591d73..626ce6c4e2bf 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -44,6 +44,15 @@
 static struct lock_class_key xfs_nondir_ilock_class;
 static struct lock_class_key xfs_dir_ilock_class;
 
+/*
+ * Metadata directories and files are not exposed to userspace, which means
+ * that they never access any of the VFS IO locks and never experience page
+ * faults.  Give them separate locking classes so that lockdep will not
+ * complain about conflicts that cannot happen.
+ */
+static struct lock_class_key xfs_metadata_file_ilock_class;
+static struct lock_class_key xfs_metadata_dir_ilock_class;
+
 static int
 xfs_initxattrs(
 	struct inode		*inode,
@@ -1270,6 +1279,7 @@ xfs_setup_inode(
 {
 	struct inode		*inode = &ip->i_vnode;
 	gfp_t			gfp_mask;
+	bool			is_meta = xfs_is_metadata_inode(ip);
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state |= I_NEW;
@@ -1281,6 +1291,16 @@ xfs_setup_inode(
 	i_size_write(inode, ip->i_disk_size);
 	xfs_diflags_to_iflags(ip, true);
 
+	/*
+	 * Mark our metadata files as private so that LSMs and the ACL code
+	 * don't try to add their own metadata or reason about these files,
+	 * and users cannot ever obtain file handles to them.
+	 */
+	if (is_meta) {
+		inode->i_flags |= S_PRIVATE;
+		inode->i_opflags &= ~IOP_XATTR;
+	}
+
 	if (S_ISDIR(inode->i_mode)) {
 		/*
 		 * We set the i_rwsem class here to avoid potential races with
@@ -1290,9 +1310,19 @@ xfs_setup_inode(
 		 */
 		lockdep_set_class(&inode->i_rwsem,
 				  &inode->i_sb->s_type->i_mutex_dir_key);
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
+		if (is_meta)
+			lockdep_set_class(&ip->i_lock.mr_lock,
+					  &xfs_metadata_dir_ilock_class);
+		else
+			lockdep_set_class(&ip->i_lock.mr_lock,
+					  &xfs_dir_ilock_class);
 	} else {
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
+		if (is_meta)
+			lockdep_set_class(&ip->i_lock.mr_lock,
+					  &xfs_metadata_file_ilock_class);
+		else
+			lockdep_set_class(&ip->i_lock.mr_lock,
+					  &xfs_nondir_ilock_class);
 	}
 
 	/*

