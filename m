Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54706 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Ek2p168823
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pnxedxas4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012JdrX009457
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:40 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Jddx007045
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:39 GMT
Subject: [PATCH 06/22] xfs: refactor kernel-specific parts of xfs_ialloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:38 -0800
Message-ID: <154630917828.18437.11659667761358440410.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the kernel-specific parts of xfs_ialloc into a separate function in
preparation for hoisting xfs_ialloc to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 403eb8fa2f1f..b635d43caeed 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -621,6 +621,32 @@ xfs_lookup(
 	return error;
 }
 
+/* Return an exclusive ILOCK'd in-core inode. */
+static int
+xfs_ialloc_iget(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp)
+{
+	return xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, ipp);
+}
+
+/* Propagate platform-specific inode properties into the new child. */
+static void
+xfs_ialloc_platform_init(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		*ip)
+{
+	struct timespec64		tv;
+
+	tv = current_time(VFS_I(ip));
+	VFS_I(ip)->i_mtime = tv;
+	VFS_I(ip)->i_atime = tv;
+	VFS_I(ip)->i_ctime = tv;
+}
+
 /*
  * Allocate an inode on disk and return a copy of its in-core version.
  * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
@@ -666,7 +692,6 @@ xfs_ialloc(
 	xfs_ino_t			ino;
 	uint				flags;
 	int				error;
-	struct timespec64		tv;
 
 	/*
 	 * Call the space management code to pick
@@ -699,8 +724,7 @@ xfs_ialloc(
 	 * This is because we're setting fields here we need
 	 * to prevent others from looking at until we're done.
 	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
+	error = xfs_ialloc_iget(mp, tp, ino, &ip);
 	if (error)
 		return error;
 	ASSERT(ip != NULL);
@@ -741,10 +765,12 @@ xfs_ialloc(
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	tv = current_time(inode);
-	inode->i_mtime = tv;
-	inode->i_atime = tv;
-	inode->i_ctime = tv;
+	inode->i_mtime.tv_sec = 0;
+	inode->i_mtime.tv_nsec = 0;
+	inode->i_atime.tv_sec = 0;
+	inode->i_atime.tv_nsec = 0;
+	inode->i_ctime.tv_sec = 0;
+	inode->i_ctime.tv_nsec = 0;
 
 	ip->i_d.di_extsize = 0;
 	ip->i_d.di_dmevmask = 0;
@@ -755,10 +781,11 @@ xfs_ialloc(
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+		ip->i_d.di_crtime.t_sec = 0;
+		ip->i_d.di_crtime.t_nsec = 0;
 	}
 
+	xfs_ialloc_platform_init(tp, args, ip);
 
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
