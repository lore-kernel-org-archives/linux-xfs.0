Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbfBDR7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 12:59:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x14HnKiB033325
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qd9ar6ppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 17:59:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x14HxAxh024220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:10 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x14Hx9Tu024120
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:10 GMT
Subject: [PATCH 01/10] xfs: clean up iunlink functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 09:59:03 -0800
Message-ID: <154930314303.31814.5572163514956583050.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
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
 fs/xfs/xfs_inode.c |   79 +++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8bf02be0003..2367cdfcd90b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1892,26 +1892,24 @@ xfs_inactive(
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
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			offset;
+	int			error;
 
 	ASSERT(VFS_I(ip)->i_mode != 0);
 
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
-	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
 		return error;
 	agi = XFS_BUF_TO_AGI(agibp);
@@ -1920,9 +1918,6 @@ xfs_iunlink(
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
 	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	ASSERT(agi->agi_unlinked[bucket_index]);
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
 
@@ -1969,45 +1964,35 @@ xfs_iunlink(
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
-
-	mp = tp->t_mountp;
-	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*ibp;
+	struct xfs_buf		*last_ibp;
+	struct xfs_dinode	*last_dip = NULL;
+	xfs_ino_t		next_ino;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		next_agino;
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			offset;
+	int			last_offset = 0;
+	int			error;
 
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
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
