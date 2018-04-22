Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755794AbeDVPIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:08:25 -0400
Subject: [PATCH 05/10] xfs: scrub the data fork of the realtime inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:08:04 -0700
Message-ID: <152440968477.30048.7531450130937990125.stgit@magnolia>
In-Reply-To: <152440964593.30048.15577210457233332459.stgit@magnolia>
References: <152440964593.30048.15577210457233332459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

The realtime bitmap and summary inodes live on the metadata device, so
we can scrub their data forks with the regular scrubbers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 8b048f1..b2b4dff 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -82,6 +82,11 @@ xfs_scrub_rtbitmap(
 {
 	int				error;
 
+	/* Invoke the fork scrubber. */
+	error = xfs_scrub_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
 	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_rec, sc);
 	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
@@ -95,8 +100,27 @@ int
 xfs_scrub_rtsummary(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
+	int				error = 0;
+
+	/*
+	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
+	 * rt summary ip in compliance with the rt inode locking rules.
+	 */
+	xfs_ilock(rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+
+	/* Invoke the fork scrubber. */
+	sc->ip = rsumip;
+	error = xfs_scrub_metadata_inode_forks(sc);
+	sc->ip = sc->mp->m_rbmip;
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		goto out;
+
 	/* XXX: implement this some day */
-	return -ENOENT;
+	xfs_scrub_set_incomplete(sc);
+out:
+	xfs_iunlock(rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	return error;
 }
 
 

