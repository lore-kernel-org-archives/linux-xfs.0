Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbeBVCQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 21:16:54 -0500
Date: Wed, 21 Feb 2018 18:16:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_scrub: don't try to scan xattrs if bstat says there
 aren't any
Message-ID: <20180222021649.GB9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Only try to scan the extended attributes of a file if bstat says that
the file actually has any.  Surprisingly, this reduces the phase 5
runtime by 40% if most of the files don't have attrs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/scrub/phase5.c b/scrub/phase5.c
index 703b279..aafa036 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -259,9 +259,12 @@ xfs_scrub_connections(
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
-	moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle, bstat);
-	if (!moveon)
-		goto out;
+	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
+		moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle,
+				bstat);
+		if (!moveon)
+			goto out;
+	}
 
 	/* Open the dir, let the kernel try to reconnect it to the root. */
 	if (S_ISDIR(bstat->bs_mode)) {
