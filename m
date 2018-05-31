Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49136 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755704AbeEaQeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:34:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VGW0Ic069265
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2j9ev87tpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGYB87025170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:11 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGYBiu013266
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:34:11 GMT
Subject: [PATCH 4/4] xfs: fix xfs_rtalloc_rec units
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 May 2018 09:34:09 -0700
Message-ID: <152778444915.6891.6242045520033580515.stgit@magnolia>
In-Reply-To: <152778442467.6891.15278589749191666547.stgit@magnolia>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

All the realtime allocation functions deal with space on the rtdev in
units of realtime extents.  However, struct xfs_rtalloc_rec confusingly
uses the word 'block' in the name, even though they're really extents.

Fix the naming problem and fix all the unit handling problems in the two
existing users.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   26 +++++++++++++-------------
 fs/xfs/scrub/rtbitmap.c      |   12 ++++++++----
 fs/xfs/xfs_fsmap.c           |   13 +++++++------
 fs/xfs/xfs_rtalloc.h         |    9 +++++++--
 4 files changed, 35 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1855182c11ec..369eeb7a52ec 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1036,17 +1036,17 @@ xfs_rtalloc_query_range(
 	int				is_free;
 	int				error = 0;
 
-	if (low_rec->ar_startblock > high_rec->ar_startblock)
+	if (low_rec->ar_startext > high_rec->ar_startext)
 		return -EINVAL;
-	if (low_rec->ar_startblock >= mp->m_sb.sb_rextents ||
-	    low_rec->ar_startblock == high_rec->ar_startblock)
+	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
+	    low_rec->ar_startext == high_rec->ar_startext)
 		return 0;
-	if (high_rec->ar_startblock >= mp->m_sb.sb_rextents)
-		high_rec->ar_startblock = mp->m_sb.sb_rextents - 1;
+	if (high_rec->ar_startext >= mp->m_sb.sb_rextents)
+		high_rec->ar_startext = mp->m_sb.sb_rextents - 1;
 
 	/* Iterate the bitmap, looking for discrepancies. */
-	rtstart = low_rec->ar_startblock;
-	rem = high_rec->ar_startblock - rtstart;
+	rtstart = low_rec->ar_startext;
+	rem = high_rec->ar_startext - rtstart;
 	while (rem) {
 		/* Is the first block free? */
 		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
@@ -1056,13 +1056,13 @@ xfs_rtalloc_query_range(
 
 		/* How long does the extent go for? */
 		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startblock - 1, &rtend);
+				high_rec->ar_startext - 1, &rtend);
 		if (error)
 			break;
 
 		if (is_free) {
-			rec.ar_startblock = rtstart;
-			rec.ar_blockcount = rtend - rtstart + 1;
+			rec.ar_startext = rtstart;
+			rec.ar_extcount = rtend - rtstart + 1;
 
 			error = fn(tp, &rec, priv);
 			if (error)
@@ -1085,9 +1085,9 @@ xfs_rtalloc_query_all(
 {
 	struct xfs_rtalloc_rec		keys[2];
 
-	keys[0].ar_startblock = 0;
-	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rextents - 1;
-	keys[0].ar_blockcount = keys[1].ar_blockcount = 0;
+	keys[0].ar_startext = 0;
+	keys[1].ar_startext = tp->t_mountp->m_sb.sb_rextents - 1;
+	keys[0].ar_extcount = keys[1].ar_extcount = 0;
 
 	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
 }
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 0fa3ef5c83b8..177d77878b0d 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -66,11 +66,15 @@ xfs_scrub_rtbitmap_rec(
 	void				*priv)
 {
 	struct xfs_scrub_context	*sc = priv;
+	xfs_rtblock_t			startblock;
+	xfs_rtblock_t			blockcount;
 
-	if (rec->ar_startblock + rec->ar_blockcount <= rec->ar_startblock ||
-	    !xfs_verify_rtbno(sc->mp, rec->ar_startblock) ||
-	    !xfs_verify_rtbno(sc->mp, rec->ar_startblock +
-			rec->ar_blockcount - 1))
+	startblock = rec->ar_startext * tp->t_mountp->m_sb.sb_rextsize;
+	blockcount = rec->ar_extcount * tp->t_mountp->m_sb.sb_rextsize;
+
+	if (startblock + blockcount <= startblock ||
+	    !xfs_verify_rtbno(sc->mp, startblock) ||
+	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 43cfc07996a4..92ce0e94085a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -465,10 +465,9 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	struct xfs_rmap_irec		irec;
 	xfs_daddr_t			rec_daddr;
 
-	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
-
-	irec.rm_startblock = rec->ar_startblock;
-	irec.rm_blockcount = rec->ar_blockcount;
+	irec.rm_startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
+	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
+	irec.rm_blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
 	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
@@ -534,8 +533,10 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 
 	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
 
-	alow.ar_startblock = info->low.rm_startblock;
-	ahigh.ar_startblock = info->high.rm_startblock;
+	alow.ar_startext = info->low.rm_startblock;
+	ahigh.ar_startext = info->high.rm_startblock;
+	do_div(alow.ar_startext, tp->t_mountp->m_sb.sb_rextsize);
+	do_div(ahigh.ar_startext, tp->t_mountp->m_sb.sb_rextsize);
 	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index dfee3c991155..52632ab727f7 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -23,9 +23,14 @@
 struct xfs_mount;
 struct xfs_trans;
 
+/*
+ * XXX: Most of the realtime allocation functions deal in units of realtime
+ * extents, not realtime blocks.  This looks funny when paired with the type
+ * name and screams for a larger cleanup.
+ */
 struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startblock;
-	xfs_rtblock_t		ar_blockcount;
+	xfs_rtblock_t		ar_startext;
+	xfs_rtblock_t		ar_extcount;
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(

