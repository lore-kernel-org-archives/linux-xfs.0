Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD54A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607860; cv=none; b=aaHR88fc9Zax9CHuiM+XodxFFDEL5s/PrxjeeMPTYTz3y0cEZrZe9EkaHStGsgMf4jEaEL4+iFMFyjEgpGEHnpVAU7/0xNZjNRlTA0XGRtbdhz12vxV/G8axGfJ/xZ3UH8ZF6sS2ywzqWqeHUGwneOE7kPLnhAFGFvY3nGXQr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607860; c=relaxed/simple;
	bh=wpLjkWg7lVfkAkmJ5OudpW8ylhmg5UbMy0bqdvFxfj4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtV3kp9vhuxle8i898Rph2+QJTkcvExJCY9ftPZRZVrN9z6nBkJO5DbV1slFznnAZRfqd7UXCeSYonk9aLHX/ghXxruq7lIANvf63D1EcJN9e/Z1D7Zr5O8xUUQ65IipXUeX2kFNtzHJaBJSmVUl0ztUgiSKrIrWL1B6TlbmetQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3f7VuMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3f7VuMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A4C4CEC5;
	Fri, 11 Oct 2024 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607860;
	bh=wpLjkWg7lVfkAkmJ5OudpW8ylhmg5UbMy0bqdvFxfj4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u3f7VuMVWbokHF48yvOoFFyYptir5MzFKN59VG3ZCvOSYyVKYdApp/IUwlg8H80kC
	 fEVJcoUoWTlI4xCsWzUEDh4pOq490v4la6fY4L0+Y6WXp0ojEXGtl9hv6wNyxu/Ay4
	 L/YUTWO6qBn0MSc6SjGshPl3tDUSldEV46o1rGlqwqDfuT6uZEc2inAcEBibr2PQkG
	 epvovBSZV2lWSo5YRseqe1EhmpvLLadQkGq36ADdMdMmzEE/ukjpPk2vjl8ZG5RWCT
	 q89iKPvQnF/4o3yICPOc8XtXzQKMg7tV5xiYraYs/cm4jp+bML8gL9j75xaTy4OZNP
	 CvxsgQ5tnRm9Q==
Date: Thu, 10 Oct 2024 17:50:59 -0700
Subject: [PATCH 10/28] xfs: hide metadata inodes from everyone because they
 are special
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642188.4176876.1023529207915303461.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
index ee79cf161312ca..33b51ea9bd210c 100644
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
+	bool			is_meta = xfs_is_metadata_inode(ip);
 
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

