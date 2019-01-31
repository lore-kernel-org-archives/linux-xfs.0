Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfAaXST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:18:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNEAIQ047137
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:17 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2q8g6rkja7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNIGNC031739
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:16 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VNIGe2029451
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:16 GMT
Subject: [PATCH 4/8] xfs: strengthen AGI unlinked inode bucket pointer checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:18:15 -0800
Message-ID: <154897669539.26065.18123748779523685840.stgit@magnolia>
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

Strengthen our checking of the AGI unlinked pointers when we start to
use them for updating the metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3c33136b21ef..4ddda3f3255f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1942,6 +1942,7 @@ xfs_iunlink(
 	struct xfs_buf		*ibp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
+	xfs_agino_t		next_agino;
 	xfs_agino_t		agino;
 	short			bucket_index;
 	int			offset;
@@ -1966,13 +1967,19 @@ xfs_iunlink(
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
+	    (next_agino != NULLAGINO &&
+	     !xfs_verify_agino(mp, agno, next_agino))) {
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 
-	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
+	if (next_agino != NULLAGINO) {
 		/*
 		 * There is already another inode in the bucket we need
 		 * to add ourselves to.  Add us at the front of the list.
@@ -2054,18 +2061,18 @@ xfs_iunlink_remove(
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
 		goto out_unlock;
 	}
 
-	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
+	if (next_agino == agino) {
 		/*
 		 * We're at the head of the list.  Get the inode's on-disk
 		 * buffer to see if there is anyone after us on the list.
@@ -2107,7 +2114,6 @@ xfs_iunlink_remove(
 		/*
 		 * We need to search the list for the inode being freed.
 		 */
-		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 		last_ibp = NULL;
 		while (next_agino != agino) {
 			struct xfs_imap	imap;
