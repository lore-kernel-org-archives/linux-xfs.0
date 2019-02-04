Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55042 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfBDR7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 12:59:45 -0500
Subject: [PATCH 05/10] xfs: strengthen AGI unlinked inode bucket pointer
 checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 09:59:33 -0800
Message-ID: <154930317330.31814.2673560545093876161.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Strengthen our checking of the AGI unlinked pointers when we start to
use them for updating the metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8c4a1d198de8..9c17ae95b18f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1938,6 +1938,7 @@ xfs_iunlink(
 	struct xfs_buf		*agibp;
 	struct xfs_buf		*ibp;
 	struct xfs_perag	*pag;
+	xfs_agino_t		next_agino;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
@@ -1954,13 +1955,18 @@ xfs_iunlink(
 	agi = XFS_BUF_TO_AGI(agibp);
 
 	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the pointer isn't garbage and that this inode
+	 * isn't already on the list.
 	 */
-	ASSERT(agi->agi_unlinked[bucket_index]);
-	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (next_agino == agino ||
+	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+		error = -EFSCORRUPTED;
+		return error;
+	}
 
-	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
+	if (next_agino != NULLAGINO) {
 		/*
 		 * There is already another inode in the bucket we need
 		 * to add ourselves to.  Add us at the front of the list.
@@ -2030,18 +2036,18 @@ xfs_iunlink_remove(
 	agi = XFS_BUF_TO_AGI(agibp);
 
 	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the head pointer isn't garbage.
 	 */
-	if (!xfs_verify_agino(mp, agno,
-			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(mp, agno, next_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
-	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
+	if (next_agino == agino) {
 		/*
 		 * We're at the head of the list.  Get the inode's on-disk
 		 * buffer to see if there is anyone after us on the list.
@@ -2083,7 +2089,6 @@ xfs_iunlink_remove(
 		/*
 		 * We need to search the list for the inode being freed.
 		 */
-		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 		last_ibp = NULL;
 		while (next_agino != agino) {
 			struct xfs_imap	imap;
