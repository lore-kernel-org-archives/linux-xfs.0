Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:22 -0400
Subject: [PATCH 05/11] xfs_repair: treat zero da btree pointers as corruption
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:03 -0700
Message-ID: <152401962320.13319.5253154840968934837.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a da btree pointer is zero (i.e. the beginning of the fork) report
this as a corrupt tree to the caller instead of telling it that
everything is good.  Fixes assertion errors when fuzzing
nbtree[0].before to zero in xfs/394.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dir2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index 73dff90..47ece00 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1238,8 +1238,8 @@ process_node_dir2(
 	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
 	 */
 	if (bno == 0) {
-		release_da_cursor(mp, &da_cursor, 0);
-		return 0;
+		err_release_da_cursor(mp, &da_cursor, 0);
+		return 1;
 	} else {
 		/*
 		 * Now pass cursor and bno into leaf-block processing routine.

