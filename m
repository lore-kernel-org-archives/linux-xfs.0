Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbfAHUgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:36:33 -0500
Subject: [PATCH 4/5] xfs: check directory name validity
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:36:29 -0800
Message-ID: <154697978966.2839.8800976099907580396.stgit@magnolia>
In-Reply-To: <154697976479.2839.3584921201780682011.stgit@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Check directory entry names for invalid characters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    1 +
 fs/xfs/scrub/dir.c       |    6 ++++++
 3 files changed, 24 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 229152cd1a24..156ce95c9c45 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -703,3 +703,20 @@ xfs_dir2_shrink_inode(
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	return 0;
 }
+
+/* Returns true if the directory entry name is valid. */
+bool
+xfs_dir2_namecheck(
+	const void	*name,
+	size_t		length)
+{
+	/*
+	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
+	 * out, so use >= for the length check.
+	 */
+	if (length >= MAXNAMELEN)
+		return false;
+
+	/* There shouldn't be any slashes or nulls here */
+	return !memchr(name, '/', length) && !memchr(name, 0, length);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c3e3f6b813d8..f54244779492 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -326,5 +326,6 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
 void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
+bool xfs_dir2_namecheck(const void *name, size_t length);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index cd3e4d768a18..a38a22785a1a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -129,6 +129,12 @@ xchk_dir_actor(
 		goto out;
 	}
 
+	/* Does this name make sense? */
+	if (!xfs_dir2_namecheck(name, namelen)) {
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		goto out;
+	}
+
 	if (!strncmp(".", name, namelen)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
