Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90A1DF754
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191395; cv=none; b=GxQk2poiLCZI8MRY93YWrLjEqs8oXdCIu9y+0j5QQHmoJLwv4rVt8Ez/zAhik2PyqyKz9Kt6ewaN/kgRSL5jgiAn/cm8OoZMz99neYaW/y0qLB7qCYVi9Uli/Nn3RKa8ghg96dErvHQUd+R/sTwQRzXF0NPaC48ylVHlsCrRmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191395; c=relaxed/simple;
	bh=0PxynT7fZiEIvVqhx1ukZH748KLMZyS1Uk9zyzZB8wg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hwiu68SaZGsUYQ+6bOddMsQnjilAVwuMIsRrEBD767LJEFeAkMfO9SjLdEOtX4Y0qWFfgnh7wPbXM7gaBs8piT/sJAxJPsLSuCHKzeGli3OyiSdu5mrOu4egqNCSTe1Yb6GTbEjMQvr4jLAIytgr8wp8MwRK83PzxfpYTHxK58M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScLRqnwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScLRqnwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24758C4CEC3;
	Thu, 17 Oct 2024 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191395;
	bh=0PxynT7fZiEIvVqhx1ukZH748KLMZyS1Uk9zyzZB8wg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ScLRqnwPoIDQ8lWz9qaNn5FT7rIFThHejPXtDNc9Ln/kIjPvMAPubnMO00OBieKMO
	 gFUvPlFIfw1uKsCKJKNOBDCURrLyAvvdvqJ0uAm1uZlSFT4KSRYI4OjPSzxHs5hwVn
	 4r2PNwXuizGeEuYOPbp5ldZtWq/d2ge0AN7EBDHhJGjM1W8sM/8OrUGker5XHia0NY
	 VFsrvv84PxylmqMzQyTZoEryfGSOvmGmx5fXoK3d6fl9ckbcHCtzK0EN95U7dDfyzW
	 aztRHDsF+HZUtxX2hU7QLL7oN9r5yupTib0W2L1ToIuNREA60VrBU4DnYYg6ASTuko
	 M8XXFmIOfv3rQ==
Date: Thu, 17 Oct 2024 11:56:34 -0700
Subject: [PATCH 11/29] xfs: hide metadata inodes from everyone because they
 are special
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069639.3451313.17291471877660399434.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/tempfile.c |    8 ++++++++
 fs/xfs/xfs_iops.c       |   15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 177f922acfaf1b..3c5a1d77fefae9 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -844,6 +844,14 @@ xrep_is_tempfile(
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
index ee79cf161312ca..66a726a5fbbba2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -42,7 +42,9 @@
  * held. For regular files, the lock order is the other way around - the
  * mmap_lock is taken during the page fault, and then we lock the ilock to do
  * block mapping. Hence we need a different class for the directory ilock so
- * that lockdep can tell them apart.
+ * that lockdep can tell them apart.  Directories in the metadata directory
+ * tree get a separate class so that lockdep reports will warn us if someone
+ * ever tries to lock regular directories after locking metadata directories.
  */
 static struct lock_class_key xfs_nondir_ilock_class;
 static struct lock_class_key xfs_dir_ilock_class;
@@ -1289,6 +1291,7 @@ xfs_setup_inode(
 {
 	struct inode		*inode = &ip->i_vnode;
 	gfp_t			gfp_mask;
+	bool			is_meta = xfs_is_internal_inode(ip);
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state |= I_NEW;
@@ -1300,6 +1303,16 @@ xfs_setup_inode(
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

