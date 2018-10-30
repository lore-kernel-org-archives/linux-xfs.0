Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43824 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbeJaC6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:58:46 -0400
Date: Tue, 30 Oct 2018 11:04:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: don't error out on dirs with a single leafn block
Message-ID: <20181030180411.GN4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In process_node_dir2, we need to distinguish between a directory with a
single leafn block (yes, they exist) having no interior da nodes, and a
directory with a da tree that incorrectly points to dablk 0.  If we
happened to fill out any part of the da cursor then we have a da btree
with garbage in it; otherwise, we have a single leafn block.

This was found by repair repeatedly rebuilding a directory containing a
single leafn block.

Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dir2.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 3c010f50..8dd021a0 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1247,11 +1247,22 @@ process_node_dir2(
 		return 1;
 
 	/*
-	 * Directories with a root marked XFS_DIR2_LEAFN_MAGIC are corrupt
+	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC.
+	 *
+	 * Be careful here: If any level of the da cursor was filled out then
+	 * the directory has a da btree containing an invalid before pointer to
+	 * dblock 0, and we should move on to rebuilding the directory.  If no
+	 * levels in the da cursor got filled out, then we just have a single
+	 * leafn block and we're done.
 	 */
 	if (bno == 0) {
-		err_release_da_cursor(mp, &da_cursor, 0);
-		return 1;
+		if (da_cursor.active > 0) {
+			err_release_da_cursor(mp, &da_cursor, 0);
+			return 1;
+		} else {
+			release_da_cursor(mp, &da_cursor, 0);
+			return 0;
+		}
 	} else {
 		/*
 		 * Now pass cursor and bno into leaf-block processing routine.
