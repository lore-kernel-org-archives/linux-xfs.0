Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:11812 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfBGFIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 00:08:37 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0003pJ-Pc
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92-RC5)
        (envelope-from <david@fromorbit.com>)
        id 1grbv6-0006KT-Nk
        for linux-xfs@vger.kernel.org; Thu, 07 Feb 2019 16:08:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: Don't free EOF blocks on sync write close
Date: Thu,  7 Feb 2019 16:08:11 +1100
Message-Id: <20190207050813.24271-2-david@fromorbit.com>
In-Reply-To: <20190207050813.24271-1-david@fromorbit.com>
References: <20190207050813.24271-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/sync write/close in parallel
with other allocation, the file becomes rapidly fragmented. This is
due to close() calling xfs_release() and removing the speculative
preallocation beyond EOF.

The existing open/write/close hueristic in xfs_release() does not
catch this as sync writes do not leave delayed allocation blocks
allocated on the inode for later writeback that can be detected in
xfs_release() and hence XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we can tell whether the release context was a
synchronous write context, and so we need to communicate this to
xfs_release() so it can do the right thing here and skip EOF
block truncation. This defers the EOF block cleanup for synchronous
write contexts to the background EOF block cleaner which will clean
up within a few minutes.

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
---
 fs/xfs/xfs_file.c  | 15 +++++++++++++--
 fs/xfs/xfs_inode.c |  9 +++++----
 fs/xfs/xfs_inode.h |  2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..02f76b8e6c03 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1019,12 +1019,23 @@ xfs_dir_open(
 	return error;
 }
 
+/*
+ * When we release the file, we don't want it to trim EOF blocks for synchronous
+ * write contexts as this leads to severe fragmentation when applications do
+ * repeated open/appending sync write/close to a file amongst other file IO.
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
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_DSYNC))
+		free_eof_blocks = false;
+
+	return xfs_release(XFS_I(inode), free_eof_blocks);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae667ba74a1c..a74dc240697f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1603,10 +1603,11 @@ xfs_itruncate_extents_flags(
 
 int
 xfs_release(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip,
+	bool			can_free_eofblocks)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
 		return 0;
@@ -1642,7 +1643,7 @@ xfs_release(
 	if (VFS_I(ip)->i_nlink == 0)
 		return 0;
 
-	if (xfs_can_free_eofblocks(ip, false)) {
+	if (can_free_eofblocks && xfs_can_free_eofblocks(ip, false)) {
 
 		/*
 		 * Check if the inode is being opened, written and closed
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be2014520155..7e59b0e086d7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -397,7 +397,7 @@ enum layout_break_reason {
 	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
 	 (VFS_I(pip)->i_mode & S_ISGID))
 
-int		xfs_release(struct xfs_inode *ip);
+int		xfs_release(struct xfs_inode *ip, bool can_free_eofblocks);
 void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-- 
2.20.1
