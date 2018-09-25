Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbeIYJGE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Sep 2018 05:06:04 -0400
Subject: [PATCH 2/2 V3] xfs: verify size-vs-format for symlinks & dirs
References: <ba65356c-2b57-75fb-0436-804913285809@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <1e55b111-eae4-b0cf-0221-c96eb3f17b77@redhat.com>
Date: Mon, 24 Sep 2018 22:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <ba65356c-2b57-75fb-0436-804913285809@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: "Xu, Wen" <wen.xu@gatech.edu>

Today, xfs_ifork_verify_data() will simply skip verification if the inode
claims to be in non-local format.  However, nothing catches the case where
the size for the format is too small to be non-local.  xfs_repair tests
for this mismatch in process_check_inode_sizes(), so do the same in this
verifier.

Reported-by: Xu, Wen <wen.xu@gatech.edu>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200925
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: restructure code & tests per Dave's suggestion on the V1 patch.
V3: rewrite dave's comments per brian's suggestions

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f9acf1d436f6..d1a58e7a872f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -704,12 +704,33 @@ xfs_ifork_verify_data(
 	struct xfs_inode	*ip,
 	struct xfs_ifork_ops	*ops)
 {
-	/* Non-local data fork, we're done. */
-	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+	struct xfs_mount	*mp = ip->i_mount;
+	int			mode = VFS_I(ip)->i_mode;
+
+	/*
+	 * Verify non-local format forks have a valid size. Symlinks must have
+	 * outgrown the data fork size. The same goes for non-local dirs, but
+	 * dirs grow at dirblock granularity. Perform a slightly stronger check
+	 * and require the dir is at least one dirblock in size.
+	 */
+	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
+				return __this_address;
+			break;
+		case S_IFLNK:
+			if (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))
+				return __this_address;
+			break;
+		default:
+			break;
+		}
 		return NULL;
+	}
 
 	/* Check the inline data fork if there is one. */
-	switch (VFS_I(ip)->i_mode & S_IFMT) {
+	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		return ops->verify_dir(ip);
 	case S_IFLNK:
