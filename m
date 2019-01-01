Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012DxWg168363
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:17 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:17 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012HGpi001773
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:17 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012HGeE006227
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:16 GMT
Subject: [PATCH 04/12] xfs: track unlinked inactive inode fs summary counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:15 -0800
Message-ID: <154630903534.16693.5010387110140639381.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Set up counters to track the number of inodes and blocks that will be
freed from inactivating unlinked inodes.  We'll use this in the deferred
inactivation patch to hide the effects of deferred processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |   31 +++++++++++++++++++++++++++++-
 3 files changed, 87 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4121523659e3..9689479ae67d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1784,6 +1784,60 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/*
+ * Play some accounting tricks with deferred inactivation of unlinked inodes so
+ * that it looks like the inode got freed immediately.  The superblock
+ * maintains counts of the number of inodes, data blocks, and rt blocks that
+ * would be freed if we were to force inode inactivation.  These counts are
+ * added to the statfs free counters outside of the regular fdblocks/ifree
+ * counters.  If userspace actually demands those "free" resources we'll force
+ * an inactivation scan to free things for real.
+ *
+ * Note that we can safely skip the block accounting trickery for complicated
+ * situations (inode with blocks on both devices, inode block counts that seem
+ * wrong) since the worst that happens is that statfs resource usage decreases
+ * more slowly.
+ *
+ * Positive @direction means we're setting up the accounting trick and
+ * negative undoes it.
+ */
+static inline void
+xfs_inode_iadjust(
+	struct xfs_inode	*ip,
+	int			direction)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		iblocks;
+	int64_t			inodes = 0;
+	int64_t			dblocks = 0;
+	int64_t			rblocks = 0;
+
+	ASSERT(direction != 0);
+
+	if (VFS_I(ip)->i_nlink == 0) {
+		inodes = 1;
+
+		iblocks = max_t(int64_t, 0, ip->i_d.di_nblocks +
+					    ip->i_delayed_blks);
+		if (!XFS_IS_REALTIME_INODE(ip))
+			dblocks = iblocks;
+		else if (!XFS_IFORK_Q(ip) ||
+			 XFS_IFORK_FORMAT(ip, XFS_ATTR_FORK) ==
+					XFS_DINODE_FMT_LOCAL)
+			rblocks = iblocks;
+	}
+
+	if (direction < 0) {
+		inodes = -inodes;
+		dblocks = -dblocks;
+		rblocks = -rblocks;
+	}
+
+	percpu_counter_add(&mp->m_iinactive, inodes);
+	percpu_counter_add(&mp->m_dinactive, dblocks);
+	percpu_counter_add(&mp->m_rinactive, rblocks);
+}
+
 /*
  * Returns true if we need to update the on-disk metadata before we can free
  * the memory used by this inode.  Updates include freeing post-eof
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e344b1dfde63..ff1a94b633cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -67,6 +67,9 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	struct percpu_counter	m_iinactive;	/* inodes waiting for inactivation */
+	struct percpu_counter	m_dinactive;	/* data blocks waiting for inode inactivation */
+	struct percpu_counter	m_rinactive;	/* rt blocks waiting for inode inactivation */
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb4953cfd683..24eb35b8fe5a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1145,6 +1145,8 @@ xfs_fs_statfs(
 	uint64_t		icount;
 	uint64_t		ifree;
 	uint64_t		fdblocks;
+	uint64_t		iinactive;
+	uint64_t		binactive;
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
@@ -1158,6 +1160,7 @@ xfs_fs_statfs(
 	icount = percpu_counter_sum(&mp->m_icount);
 	ifree = percpu_counter_sum(&mp->m_ifree);
 	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	iinactive = percpu_counter_sum(&mp->m_iinactive);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -1181,7 +1184,7 @@ xfs_fs_statfs(
 					sbp->sb_icount);
 
 	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (icount - ifree);
+	ffree = statp->f_files - (icount - ifree) + iinactive;
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
 
@@ -1195,7 +1198,12 @@ xfs_fs_statfs(
 		statp->f_blocks = sbp->sb_rblocks;
 		statp->f_bavail = statp->f_bfree =
 			sbp->sb_frextents * sbp->sb_rextsize;
+		binactive = percpu_counter_sum(&mp->m_rinactive);
+	} else {
+		binactive = percpu_counter_sum(&mp->m_dinactive);
 	}
+	statp->f_bavail += binactive;
+	statp->f_bfree += binactive;
 
 	return 0;
 }
@@ -1564,8 +1572,26 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_ifree;
 
+	error = percpu_counter_init(&mp->m_iinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_fdblocks;
+
+	error = percpu_counter_init(&mp->m_dinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_iinactive;
+
+	error = percpu_counter_init(&mp->m_rinactive, 0, GFP_KERNEL);
+	if (error)
+		goto free_dinactive;
+
 	return 0;
 
+free_dinactive:
+	percpu_counter_destroy(&mp->m_dinactive);
+free_iinactive:
+	percpu_counter_destroy(&mp->m_iinactive);
+free_fdblocks:
+	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
 	percpu_counter_destroy(&mp->m_ifree);
 free_icount:
@@ -1589,6 +1615,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
+	percpu_counter_destroy(&mp->m_iinactive);
+	percpu_counter_destroy(&mp->m_dinactive);
+	percpu_counter_destroy(&mp->m_rinactive);
 }
 
 static struct xfs_mount *
