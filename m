Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161161AbeCATNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:13:38 -0500
Subject: [PATCH 06/16] xfs_scrub: don't try to scan xattrs if bstat says
 there aren't any
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:13:32 -0800
Message-ID: <151993161291.22223.12229177976202068960.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Only try to scan the extended attributes of a file if bstat says that
the file actually has any.  Surprisingly, this reduces the phase 5
runtime by 40% if most of the files don't have attrs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 0ef6339..8e0a1be 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -256,9 +256,12 @@ xfs_scrub_connections(
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

