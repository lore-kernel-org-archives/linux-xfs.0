Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC1FC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuNqtzbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD2C433C8;
	Sun, 31 Dec 2023 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060029;
	bh=3I4h+Z4FiGA5E3VjTTpNqopyNCRrMMrlzvwmo2C67as=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BuNqtzbub6w6her4lC8CDtqzQtg1GBQOQrNl4JuHnjPquPKfQem5r72RVvewj+urt
	 vPj48tquRoM3jLIrdq8WQSxwG09nitE87HBuqoKd2sNQaKKrLuuzvg8lvtFKgvPijH
	 3cGKaxEwKiAk8b4R726J2WLTdNh7q5KISeKALHlb/A+4V4UVGjqC3t9O/j9Whs9XDr
	 +juTWnNO6wpD7z9ZAJe9xpEfNKM8Gd8o6lAzHfKRP1B8rtOLfi6KQ6sR0FDZHkmAUV
	 mGfYfcUTTNjnxTdrFTeBDvpkyAk70CwZNEORi8SDZqoY2lLp9wV4om2K8ANgstzQry
	 CZTgB8Z0oASLw==
Date: Sun, 31 Dec 2023 14:00:28 -0800
Subject: [PATCH 2/3] xfs: don't free EOF blocks on read close
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170404854358.1769544.9714669653726216761.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854320.1769544.582901935144092640.stgit@frogsfrogsfrogs>
References: <170404854320.1769544.582901935144092640.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/read/close in parallel with other
allocation, the file becomes rapidly fragmented. This is due to close()
calling xfs_release() and removing the speculative preallocation beyond
EOF.

The existing open/*/close heuristic in xfs_release() does not catch this
as a sync writer does not leave delayed allocation blocks allocated on
the inode for later writeback that can be detected in xfs_release() and
hence XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we know more about the released file context, and
so we need to communicate some of the details to xfs_release() so it can
do the right thing here and skip EOF block truncation. This defers the
EOF block cleanup for synchronous write contexts to the background EOF
block cleaner which will clean up within a few minutes.

Before:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 919
/mnt/scratch/file.1: 916
/mnt/scratch/file.2: 919
/mnt/scratch/file.3: 920
/mnt/scratch/file.4: 920
/mnt/scratch/file.5: 921
/mnt/scratch/file.6: 916
/mnt/scratch/file.7: 918

After:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 24
/mnt/scratch/file.1: 24
/mnt/scratch/file.2: 11
/mnt/scratch/file.3: 24
/mnt/scratch/file.4: 3
/mnt/scratch/file.5: 24
/mnt/scratch/file.6: 24
/mnt/scratch/file.7: 23

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: wordsmithing, fix commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   14 ++++++++++++--
 fs/xfs/xfs_inode.c |    9 +++++----
 fs/xfs/xfs_inode.h |    2 +-
 3 files changed, 18 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebdda286cb2a2..f2dd4daaa4e24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1367,12 +1367,22 @@ xfs_dir_open(
 	return error;
 }
 
+/*
+ * When we release the file, we don't want it to trim EOF blocks if it is a
+ * readonly context.  This avoids open/read/close workloads from removing
+ * EOF blocks that other writers depend upon to reduce fragmentation.
+ */
 STATIC int
 xfs_file_release(
 	struct inode	*inode,
-	struct file	*filp)
+	struct file	*file)
 {
-	return xfs_release(XFS_I(inode));
+	bool		free_eof_blocks = true;
+
+	if ((file->f_mode & (FMODE_WRITE | FMODE_READ)) == FMODE_READ)
+		free_eof_blocks = false;
+
+	return xfs_release(XFS_I(inode), free_eof_blocks);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dc0710661013f..3408804bee9b2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1137,10 +1137,11 @@ xfs_itruncate_extents_flags(
 
 int
 xfs_release(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip,
+	bool			want_free_eofblocks)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
 
 	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
 		return 0;
@@ -1182,7 +1183,7 @@ xfs_release(
 	 * another chance to drop them once the last reference to the inode is
 	 * dropped, so we'll never leak blocks permanently.
 	 */
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
+	if (!want_free_eofblocks || !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
 	if (xfs_can_free_eofblocks(ip, false)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index df8197fe4cb82..2779a353b4618 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -525,7 +525,7 @@ enum layout_break_reason {
 #define XFS_INHERIT_GID(pip)	\
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
-int		xfs_release(struct xfs_inode *ip);
+int		xfs_release(struct xfs_inode *ip, bool want_free_eofblocks);
 int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);

