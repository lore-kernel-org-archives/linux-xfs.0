Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbeEOUrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 16:47:41 -0400
Date: Tue, 15 May 2018 13:47:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: change xfs_update_secondary_supers to use
 xfS_sb_read_secondary
Message-ID: <20180515204721.GM4933@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new helper to read secondary superblocks instead of opencoding
it ourselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsops.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 056a76689197..40c131ebf772 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -191,18 +191,15 @@ xfs_growfs_data_private(
  */
 int
 xfs_update_secondary_supers(
-	xfs_mount_t		*mp)
+	struct xfs_mount	*mp)
 {
-	int			error, saved_error;
+	struct xfs_buf		*bp;
 	xfs_agnumber_t		agno;
-	xfs_buf_t		*bp;
+	int			error, saved_error;
 
 	error = saved_error = 0;
 
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
-		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-			  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -210,6 +207,7 @@ xfs_update_secondary_supers(
 		 * superblocks un-updated than updated, and xfs_repair may
 		 * pick them over the properly-updated primary.
 		 */
+		error = xfs_sb_read_secondary(mp, NULL, agno, &bp);
 		if (error) {
 			xfs_warn(mp,
 		"error %d reading secondary superblock for ag %d",
