Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeEJTSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 15:18:45 -0400
Subject: [PATCH 4/8] xfs: scrub the data fork of the realtime inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 12:18:25 -0700
Message-ID: <152597990586.25215.6135406269069566239.stgit@magnolia>
In-Reply-To: <152597988038.25215.9276761144353662866.stgit@magnolia>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
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
 fs/xfs/scrub/rtbitmap.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 8b048f107af2..abc885dab122 100644
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
@@ -95,8 +100,35 @@ int
 xfs_scrub_rtsummary(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
+	uint				old_ilock_flags;
+	int				error = 0;
+
+	/*
+	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
+	 * rt summary ip in compliance with the rt inode locking rules.
+	 *
+	 * Since we switch sc->ip to rsumip we have to save the old ilock
+	 * flags so that we don't mix up the inode state that @sc tracks.
+	 */
+	old_ilock_flags = sc->ilock_flags;
+	sc->ip = rsumip;
+	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	/* Invoke the fork scrubber. */
+	error = xfs_scrub_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		goto out;
+
 	/* XXX: implement this some day */
-	return -ENOENT;
+	xfs_scrub_set_incomplete(sc);
+out:
+	/* Switch back to the rtbitmap inode and lock flags. */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = old_ilock_flags;
+	sc->ip = sc->mp->m_rbmip;
+	return error;
 }
 
 

