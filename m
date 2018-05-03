Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECSGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I10LM035701
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:41 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2hmhmfty7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:06:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6eBG005699
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:40 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6dYx027665
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:39 GMT
Subject: [PATCH 07/12] xfs: scrub the data fork of the realtime inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:38 -0700
Message-ID: <152537079876.16676.9808685459752163487.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The realtime bitmap and summary inodes live on the metadata device, so
we can scrub their data forks with the regular scrubbers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 8b048f107af2..b2b4dff2660d 100644
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
 
 

