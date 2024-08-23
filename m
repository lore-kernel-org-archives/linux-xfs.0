Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2613317721
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371455; cv=none; b=rg4iXi6vWJKvfvF4hoktXimCkfe5kxgACJNERigXVZR1NboDsyoWjUlw4DJ6KUxX9DqlGmTI9CNFpSlMi5PN9Be93YwyyuCjCxkAYuAx0J4Rs4tbOJEtWGdZmo3Apt1gqM+9230CV/Hct5e5XE4kvjZCHD9z2j4xbKAx/bjOnxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371455; c=relaxed/simple;
	bh=nUm7aW2dypPtnE0SvlraQyTvj71u96aKtvugkvXflz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2oFy66u9wyNLD0yqZCA8XV5dvseXAwv51TJkZe/UzTcarF5lbHLi2p+lxGuAwGQDyEbohqOJPlYsZog2WpJvrp0sKG18bOJShZeR/YUDWahaqc7wBpoVgB+z5yUbAsv+xFkhi4VPeZXl7eKgGx7R0eqEIm2KXHXX+royCCeeNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtwfDiXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtwfDiXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03210C4AF0B;
	Fri, 23 Aug 2024 00:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371455;
	bh=nUm7aW2dypPtnE0SvlraQyTvj71u96aKtvugkvXflz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BtwfDiXAQTw53W1UJEbLdzYuRIKi7crutAh44M1tGmEf004iiUZ0wN+e0xzPGLPBk
	 nHU7nGXGPdmUorNDBzlB1whTUytL26+P83CBhl+w4ofkqepQBnPq5+6AUCUm3SfQBr
	 RiwBfmOtUAq54nui89vJ4pXQ05nPzPIMGceiJQaAOn6kDAvNWM+cF5aM0ugbnxCC9U
	 bvanOoPlKuE3Vl4O8GtU/arVzvfJUl6yhhxhQMTK7uq9NrCfN1VgHjJxfzg295vvMM
	 YvovIb/Idh0bE7Z9CSoLDik7kEsJk+zFwQiDjXqu+D2IyVNfQucFFIlo0VtctVYC9Q
	 c7AmOC92ZaQAg==
Date: Thu, 22 Aug 2024 17:04:14 -0700
Subject: [PATCH 08/26] xfs: hide metadata inodes from everyone because they
 are special
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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
write to a rt file and need to allocate from the rt bitmap file.  The
static function that we use to do this will be exported in the rtgroups
patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    8 ++++++++
 fs/xfs/xfs_iops.c       |   15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 177f922acfaf1..3c5a1d77fefae 100644
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
index 1cdc8034f54d9..c1686163299a0 100644
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
@@ -1299,6 +1301,7 @@ xfs_setup_inode(
 {
 	struct inode		*inode = &ip->i_vnode;
 	gfp_t			gfp_mask;
+	bool			is_meta = xfs_is_metadata_inode(ip);
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state |= I_NEW;
@@ -1310,6 +1313,16 @@ xfs_setup_inode(
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

