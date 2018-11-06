Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:32:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA6406RB173834
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:56 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2nh4aqjpxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA648sAv014113
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:55 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA648s4q011004
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:54 GMT
Subject: [PATCH 7/8] xfs: rename xchk_iallocbt_check_freemask
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:53 -0800
Message-ID: <154147733302.32496.14353755611959314260.stgit@magnolia>
In-Reply-To: <154147728649.32496.4515247239602322709.stgit@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the name of xchk_iallocbt_check_freemask so that it represents
what the function actually does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 645b248faa80..10c3aaefc2a3 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -305,9 +305,13 @@ xchk_iallocbt_check_cluster(
 	return error;
 }
 
-/* Make sure the free mask is consistent with what the inodes think. */
+/*
+ * For all the inode clusters that could map to this inobt record, make sure
+ * that the holemask makes sense and that the allocation status of each inode
+ * matches the freemask.
+ */
 STATIC int
-xchk_iallocbt_check_freemask(
+xchk_iallocbt_check_clusters(
 	struct xchk_btree		*bs,
 	struct xchk_iallocbt		*iabt,
 	struct xfs_inobt_rec_incore	*irec)
@@ -315,6 +319,13 @@ xchk_iallocbt_check_freemask(
 	unsigned int			chunk_ioff;
 	int				error = 0;
 
+	/*
+	 * For the common case where this inobt record maps to multiple inode
+	 * clusters this will call _check_cluster for each cluster.
+	 *
+	 * For the case that multiple inobt records map to a single cluster,
+	 * this will call _check_cluster once.
+	 */
 	for (chunk_ioff = 0;
 	     chunk_ioff < XFS_INODES_PER_CHUNK;
 	     chunk_ioff += iabt->inodes_per_cluster) {
@@ -461,7 +472,7 @@ xchk_iallocbt_rec(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 check_freemask:
-	error = xchk_iallocbt_check_freemask(bs, iabt, &irec);
+	error = xchk_iallocbt_check_clusters(bs, iabt, &irec);
 	if (error)
 		goto out;
 
