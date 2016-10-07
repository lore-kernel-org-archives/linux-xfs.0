Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45465 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753440AbcJGXHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:38 -0400
Subject: [PATCH 1/7] xfs: rework refcount cow recovery error handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:25 -0700
Message-ID: <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

The error handling in xfs_refcount_recover_cow_leftovers is confused
and can potentially leak memory, so rework it to release resources
correctly on error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 56bfef1..87f00df 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1643,7 +1643,7 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	if (error)
-		goto out_error;
+		goto out_cursor;
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_buf_relse(agbp);
 
@@ -1675,26 +1675,22 @@ xfs_refcount_recover_cow_leftovers(
 
 		error = xfs_trans_commit(tp);
 		if (error)
-			goto out_cancel;
+			goto out_free;
 	}
-	goto out_free;
+	return 0;
 
 out_defer:
 	xfs_defer_cancel(&dfops);
-out_cancel:
 	xfs_trans_cancel(tp);
-
+	goto out_free;
+out_cursor:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_buf_relse(agbp);
 out_free:
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		list_del(&rr->rr_list);
 		kmem_free(rr);
 	}
-
-	return error;
-
-out_error:
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_buf_relse(agbp);
 	return error;
 }

