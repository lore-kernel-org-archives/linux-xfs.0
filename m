Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeCTDIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 23:08:49 -0400
Subject: [PATCH 4/4] mkfs: enable sparse inodes by default
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Mar 2018 20:08:44 -0700
Message-ID: <152151532462.18312.14450864420601203976.stgit@magnolia>
In-Reply-To: <152151529988.18312.2660325658864402943.stgit@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the sparse inode feature by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1ca6a2d..78d0ce5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1996,7 +1996,7 @@ _("finobt not supported without CRC support\n"));
 		}
 		cli->sb_feat.finobt = false;
 
-		if (cli->sb_feat.spinodes) {
+		if (cli->sb_feat.spinodes && cli_opt_set(&iopts, I_SPINODES)) {
 			fprintf(stderr,
 _("sparse inodes not supported without CRC support\n"));
 			usage();
@@ -3811,7 +3811,7 @@ main(
 			.crcs_enabled = true,
 			.dirftype = true,
 			.finobt = true,
-			.spinodes = false,
+			.spinodes = true,
 			.rmapbt = false,
 			.reflink = false,
 			.parent_pointers = false,

