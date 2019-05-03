Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfECA5e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 May 2019 20:57:34 -0400
Date: Thu, 2 May 2019 17:57:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: enable reflink and rmap by default
Message-ID: <20190503005717.GO5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable reflink and reverse mapping by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0862621a..3874f7dd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2021,14 +2021,14 @@ _("sparse inodes not supported without CRC support\n"));
 		}
 		cli->sb_feat.spinodes = false;
 
-		if (cli->sb_feat.rmapbt) {
+		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
 			fprintf(stderr,
 _("rmapbt not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.rmapbt = false;
 
-		if (cli->sb_feat.reflink) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
@@ -3934,8 +3934,8 @@ main(
 			.dirftype = true,
 			.finobt = true,
 			.spinodes = true,
-			.rmapbt = false,
-			.reflink = false,
+			.rmapbt = true,
+			.reflink = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
