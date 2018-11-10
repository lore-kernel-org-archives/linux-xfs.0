Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbeKJK2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 05:28:41 -0500
Subject: [PATCH 2/6] xfs_repair: don't error out on dirs with a single leafn
 block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 09 Nov 2018 16:45:27 -0800
Message-ID: <154181072709.3727.17020900125846885320.stgit@magnolia>
In-Reply-To: <154181071499.3727.3910572718199592407.stgit@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

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
