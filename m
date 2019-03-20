Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTThA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:37:00 -0400
Date: Wed, 20 Mar 2019 12:36:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 42/36] xfs_db: refactor metadump handling of multi-fsb objects
Message-ID: <20190320193658.GF1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Separate the multi-fsb object dispatch from actual dir block processing
so that we can implement symlink handling correctly as a multi-fsb file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3cce3012..83a257d0 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1911,7 +1911,7 @@ static struct bbmap mfsb_map;
 static int mfsb_length;
 
 static int
-process_multi_fsb_objects(
+process_multi_fsb_dir(
 	xfs_fileoff_t	o,
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
@@ -1921,14 +1921,6 @@ process_multi_fsb_objects(
 	char		*dp;
 	int		ret = 0;
 
-	switch (btype) {
-	case TYP_DIR2:
-		break;
-	default:
-		print_warning("bad type for multi-fsb object %d", btype);
-		return -EINVAL;
-	}
-
 	while (c > 0) {
 		unsigned int	bm_len;
 
@@ -1987,6 +1979,23 @@ process_multi_fsb_objects(
 	return ret;
 }
 
+static int
+process_multi_fsb_objects(
+	xfs_fileoff_t	o,
+	xfs_fsblock_t	s,
+	xfs_filblks_t	c,
+	typnm_t		btype,
+	xfs_fileoff_t	last)
+{
+	switch (btype) {
+	case TYP_DIR2:
+		return process_multi_fsb_dir(o, s, c, btype, last);
+	default:
+		print_warning("bad type for multi-fsb object %d", btype);
+		return -EINVAL;
+	}
+}
+
 /* inode copy routines */
 static int
 process_bmbt_reclist(
