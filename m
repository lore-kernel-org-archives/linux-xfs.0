Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38179 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbcJJGL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 02:11:27 -0400
Date: Sun, 9 Oct 2016 23:11:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/7] xfs: rework refcount cow recovery error handling
Message-ID: <20161010061122.GC5619@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

The error handling in xfs_refcount_recover_cow_leftovers is confused
and can potentially leak memory, so rework it to release resources
correctly on error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 56bfef1..955b1d9 100644
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
 	goto out_free;
 
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
