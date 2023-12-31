Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC10BAD25
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlE4dlFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D880C433C7;
	Sun, 31 Dec 2023 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057024;
	bh=zqGjmZRjWaXnEM40x2ecsNpUJi5uFrwPpwZAPRs3Guo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tlE4dlFQh7eek2/4d38uQZIqZpSpHbN2hvbqsGo1wsMRbDXrUGS1Roq3PP3tDiAGK
	 0UBnXVL6ENQE+38ZSYdk7EgB8mdRx5giTTKucswkxMo3V2ZC6+JO3+iSkj2OGPDwzg
	 35Kbk0wDFcnizrc11jQl13BAgOWJTsPNNlhqW+DVQdxk6uwhloSAfyAYRnnMxl+EGs
	 UBHFrekUIsAoYS+lyZtSe9kAhKtSiltczWiNuwZx7T93FPAOvCrju6lAfa8YPyhqRn
	 ekh1flfWukQ4WmFskfRdikaMc7T1fBeasunLiYtk9H927FcZZRWjOIHA3CnwSQr9Yg
	 yV20lRVdrjvlQ==
Date: Sun, 31 Dec 2023 13:10:23 -0800
Subject: [PATCH 16/32] xfs: hide metadata inodes from everyone because they
 are special
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845124.1760491.852047742800681411.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index db3a9a47e1f82..583bbd5a02bc9 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -867,6 +867,14 @@ xrep_is_tempfile(
 	const struct xfs_inode	*ip)
 {
 	const struct inode	*inode = &ip->i_vnode;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/*
+	 * Files in the metadata directory tree also have S_PRIVATE set and
+	 * IOP_XATTR unset, so we must distinguish them separately.
+	 */
+	if (xfs_has_metadir(mp) && (ip->i_diflags2 & XFS_DIFLAG2_METADIR))
+		return false;
 
 	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
 		return true;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 90296b3c838aa..461e77dd54e38 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -45,6 +45,15 @@
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
@@ -1291,6 +1300,7 @@ xfs_setup_inode(
 {
 	struct inode		*inode = &ip->i_vnode;
 	gfp_t			gfp_mask;
+	bool			is_meta = xfs_is_metadata_inode(ip);
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state |= I_NEW;
@@ -1302,6 +1312,16 @@ xfs_setup_inode(
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
@@ -1311,9 +1331,19 @@ xfs_setup_inode(
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

