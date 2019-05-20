Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfETXSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:18:07 -0400
Subject: [PATCH 12/12] mkfs: enable reflink by default
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:18:00 -0700
Message-ID: <155839428076.68606.9379127257564633311.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Data block sharing (a.k.a. reflink) has been stable for a while, so turn
it on by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8f84536e..afed46d0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2015,7 +2015,7 @@ _("rmapbt not supported without CRC support\n"));
 		}
 		cli->sb_feat.rmapbt = false;
 
-		if (cli->sb_feat.reflink) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
@@ -3900,7 +3900,7 @@ main(
 			.finobt = true,
 			.spinodes = true,
 			.rmapbt = false,
-			.reflink = false,
+			.reflink = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
