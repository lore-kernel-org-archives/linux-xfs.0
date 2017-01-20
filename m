Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29391 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753383AbdATU0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 15:26:20 -0500
Subject: [PATCH 5/5] xfs_repair: trash dirattr btrees that cycle to the root
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 20 Jan 2017 12:25:47 -0800
Message-ID: <148494394775.5256.15878832693432189642.stgit@birch.djwong.org>
In-Reply-To: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If xfs_repair detects a dir/attr btree that cycles back to the root, the
tree should be cleared and/or rebuilt instead of simply aborting the
repair program.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index b855a10..37a821b 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -763,7 +763,12 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		 * 0 is the root block and no block
 		 * pointer can point to the root block of the btree
 		 */
-		ASSERT(da_bno != 0);
+		if (da_bno == 0) {
+			do_warn(
+	_("btree cycle detected in attribute fork for inode %" PRIu64 "\n"),
+				ino);
+			goto error_out;
+		}
 
 		if (dev_bno == NULLFSBLOCK) {
 			do_warn(

