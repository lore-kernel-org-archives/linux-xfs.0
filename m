Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfBFQ5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 11:57:33 -0500
Subject: [PATCH 7/9] xfs: refactor inode update in iunlink_remove
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 06 Feb 2019 08:55:23 -0800
Message-ID: <154947212327.22369.14496539831290124356.stgit@magnolia>
In-Reply-To: <154947207759.22369.11575570374120223292.stgit@magnolia>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_iunlink_remove we have two identical calls to
xfs_iunlink_update_inode, so move it out of the if statement to simplify
the code some more.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 161d8da459aa..aeca536e3e75 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2188,6 +2188,7 @@ xfs_iunlink_remove(
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
+	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
@@ -2201,23 +2202,23 @@ xfs_iunlink_remove(
 	 * Get the index into the agi hash table for the list this inode will
 	 * go on.  Make sure the head pointer isn't garbage.
 	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(mp, agno, next_agino)) {
+	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(mp, agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
 		return -EFSCORRUPTED;
 	}
 
-	if (next_agino == agino) {
-		/*
-		 * We're at the head of the list.  Get the inode's on-disk
-		 * buffer to see if there is anyone after us on the list.
-		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
-				&next_agino);
-		if (error)
-			return error;
+	/*
+	 * Set our inode's next_unlinked pointer to NULL and then return
+	 * the old pointer value so that we can update whatever was previous
+	 * to us in the list to point to whatever was next in the list.
+	 */
+	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
+	if (error)
+		return error;
 
+	if (head_agino == agino) {
 		/* Point the head of the list to the next unlinked inode. */
 		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
 				next_agino);
@@ -2228,20 +2229,11 @@ xfs_iunlink_remove(
 		xfs_agino_t	prev_agino;
 
 		/* We need to search the list for the inode being freed. */
-		error = xfs_iunlink_map_prev(tp, agno, next_agino, agino,
+		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
 				&prev_agino, &imap, &last_dip, &last_ibp);
 		if (error)
 			return error;
 
-		/*
-		 * Now last_ibp points to the buffer previous to us on the
-		 * unlinked list.  Pull us from the list.
-		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
-				&next_agino);
-		if (error)
-			return error;
-
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
 				last_dip, &imap, next_agino);
