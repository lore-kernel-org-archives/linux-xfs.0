Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F11DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845171; cv=none; b=J1SFwuvdkC1Ia/oY6v8wAXpV5B9fSg6ke7PPPoqbKUqkr2dF6W2U8iJX8XRhyiKIoxxPyOK1ZizOIYgPkW1yWow38Sk3uwtJO9zUR1KULxk4fMscZhSEOLgWLnusroh9oa+ULLl51WFHtnnw14meNMYt7y5pHOFDg3NFUM9X7PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845171; c=relaxed/simple;
	bh=0PxynT7fZiEIvVqhx1ukZH748KLMZyS1Uk9zyzZB8wg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWCEVkLsGg87/FT0XV9soLN5QGzf0kblYRqH/mS4RmIiwo07SHpvdkFtoAwLXfFL/u0fBKfp9B8aspwQoDLnBQAhwGfFLPKySbHf+fn3cczdtYhzkDRNNi81H5qZ3GpLsOfsK01ezqqqzEP8zigWk/UGx977HycnCklNm8xsAkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IV++sWzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IV++sWzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7149AC4CECF;
	Tue,  5 Nov 2024 22:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845170;
	bh=0PxynT7fZiEIvVqhx1ukZH748KLMZyS1Uk9zyzZB8wg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IV++sWzKEKNRIC5Un5Hza/5ruGygPSKKNIVNZxiWHeVhe87OMU7cjl5kp6YhP8qz3
	 HVRsLq5EQX1oWPE34yiSJgHwGVnk+iE4W0wK+ymukE2j04s8nH2amk0jCGqhG1i7Ff
	 0Op2aFhZNWMD4R7hIOkmyUTrri+pWMUpqsY1ahLF3ZrZsCw8b6M09OGHFeiR9V6Fz/
	 aP+WoN2ScOUwTEkh87eCmgA6aOW7sJKzuEIvt4AEA0GEKBGWoQKZwZv+Rmqfjd/qlB
	 AbJGDUzsmT/2r/6m708AZLqv+d9bEvbchhvrYADlRTZvpHJPgW++zo+kbDDKxOHmBS
	 YNNBV4GUO3t2w==
Date: Tue, 05 Nov 2024 14:19:30 -0800
Subject: [PATCH 11/28] xfs: hide metadata inodes from everyone because they
 are special
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396209.1870066.7408723354973665738.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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

