Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387638AbeKWEyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:54:22 -0500
Date: Thu, 22 Nov 2018 10:13:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 2/6] xfs_repair: don't error out on dirs with a single
 leafn block
Message-ID: <20181122181346.GW6792@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181072709.3727.17020900125846885320.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154181072709.3727.17020900125846885320.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In process_node_dir2, we need to distinguish between a directory with a
single leafn block (yes, they exist) having no interior da nodes, and a
directory with a da tree that incorrectly points to dablk 0.  If we
happened to fill out any part of the da cursor then we have a da btree
with garbage in it; otherwise, we have a single leafn block.

This was found by repair repeatedly rebuilding a directory containing a
single leafn block (xfs/495).

Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: now that the regression test has landed, mention that in the
changelog
---
 repair/dir2.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index ba5763ed..e67ec590 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1243,10 +1243,21 @@ process_node_dir2(
 
 	/*
 	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
+	 *
+	 * Be careful here: If any level of the da cursor was filled out then
+	 * the directory has a da btree containing an invalid before pointer to
+	 * dblock 0, and we should move on to rebuilding the directory.  If no
+	 * levels in the da cursor got filled out, then we just have a single
+	 * leafn block and we're done.
 	 */
 	if (bno == 0) {
-		release_da_cursor(mp, &da_cursor, 0);
-		return 0;
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
