Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44656 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfEUTa6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:30:58 -0400
Subject: [PATCH 12/12 V2] mkfs: enable reflink by default
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839428076.68606.9379127257564633311.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1f5f641c-b6f8-2067-8224-7350f0f51034@sandeen.net>
Date: Tue, 21 May 2019 14:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <155839428076.68606.9379127257564633311.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Data block sharing (a.k.a. reflink) has been stable for a while, so turn
it on by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sandeen: update comments & man page]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c..78b1501 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -231,7 +231,7 @@ available for the data forks of regular files.
 .IP
 By default,
 .B mkfs.xfs
-will not create reference count btrees and therefore will not enable the
+will create reference count btrees and therefore will enable the
 reflink feature.  This feature is only available for filesystems created with
 the (default)
 .B \-m crc=1
@@ -239,6 +239,13 @@ option set. When the option
 .B \-m crc=0
 is used, the reference count btree feature is not supported and reflink is
 disabled.
+.IP
+Note: the filesystem DAX mount option (
+.B \-o dax
+) is incompatible with
+reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
+.B \-m reflink=0
+option to mkfs.xfs to disable the reflink feature.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0910664..ddb25ec 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1973,15 +1973,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
 			usage();
 		}
 
-	} else {
+	} else {	/* !crcs_enabled */
 		/*
-		 * The kernel doesn't currently support crc=0,finobt=1
-		 * filesystems. If crcs are not enabled and the user has not
-		 * explicitly turned finobt on, then silently turn it off to
-		 * avoid an unnecessary warning.
+		 * The kernel doesn't support crc=0,finobt=1 filesystems.
+		 * If crcs are not enabled and the user has not explicitly
+		 * turned finobt on, then silently turn it off to avoid an
+		 * unnecessary warning.
 		 * If the user explicitly tried to use crc=0,finobt=1,
 		 * then issue an error.
-		 * The same is also for sparse inodes.
+		 * The same is also true for sparse inodes and reflink.
 		 */
 		if (cli->sb_feat.finobt && cli_opt_set(&mopts, M_FINOBT)) {
 			fprintf(stderr,
@@ -2004,7 +2004,7 @@ _("rmapbt not supported without CRC support\n"));
 		}
 		cli->sb_feat.rmapbt = false;
 
-		if (cli->sb_feat.reflink) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
@@ -3876,7 +3876,7 @@ main(
 			.finobt = true,
 			.spinodes = true,
 			.rmapbt = false,
-			.reflink = false,
+			.reflink = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
