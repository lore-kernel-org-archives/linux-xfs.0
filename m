Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfAaXSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:18:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNEIfF047228
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2q8g6rkj93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:58 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNHwDi018023
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:58 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VNHvM4003873
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:57 GMT
Subject: [PATCH 1/8] xfs: clean up iunlink functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:17:56 -0800
Message-ID: <154897667679.26065.17995098675615600714.stgit@magnolia>
In-Reply-To: <154897667054.26065.13164381203002725289.stgit@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some indentation issues with the iunlink functions and reorganize
the tops of the functions to be identical.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   77 +++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8bf02be0003..d18354517320 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1892,26 +1892,32 @@ xfs_inactive(
  */
 STATIC int
 xfs_iunlink(
-	struct xfs_trans *tp,
-	struct xfs_inode *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t	*mp = tp->t_mountp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agino_t	agino;
-	short		bucket_index;
-	int		offset;
-	int		error;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*ibp;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	short			bucket_index;
+	int			offset;
+	int			error;
 
 	ASSERT(VFS_I(ip)->i_mode != 0);
+	ASSERT(xfs_verify_ino(mp, ip->i_ino));
+
+	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
 	 */
-	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
+	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
 		return error;
 	agi = XFS_BUF_TO_AGI(agibp);
@@ -1920,9 +1926,6 @@ xfs_iunlink(
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
 	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	ASSERT(agi->agi_unlinked[bucket_index]);
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
 
@@ -1969,26 +1972,31 @@ xfs_iunlink(
  */
 STATIC int
 xfs_iunlink_remove(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
-	xfs_ino_t	next_ino;
-	xfs_mount_t	*mp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agnumber_t	agno;
-	xfs_agino_t	agino;
-	xfs_agino_t	next_agino;
-	xfs_buf_t	*last_ibp;
-	xfs_dinode_t	*last_dip = NULL;
-	short		bucket_index;
-	int		offset, last_offset = 0;
-	int		error;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*ibp;
+	struct xfs_buf		*last_ibp;
+	struct xfs_dinode	*last_dip = NULL;
+	xfs_ino_t		next_ino;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	xfs_agino_t		next_agino;
+	short			bucket_index;
+	int			offset;
+	int			last_offset = 0;
+	int			error;
+
+	if (!xfs_verify_ino(mp, ip->i_ino))
+		return -EFSCORRUPTED;
 
-	mp = tp->t_mountp;
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
@@ -1997,17 +2005,12 @@ xfs_iunlink_remove(
 	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
 		return error;
-
 	agi = XFS_BUF_TO_AGI(agibp);
 
 	/*
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
 	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	if (!xfs_verify_agino(mp, agno, agino))
-		return -EFSCORRUPTED;
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	if (!xfs_verify_agino(mp, agno,
 			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
