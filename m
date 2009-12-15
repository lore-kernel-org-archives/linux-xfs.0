Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF6B5iD210809 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 00:11:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB0DFF65E2
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:11:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	PqBLsPUTSsQTICzB for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 22:11:42 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10086294-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:41:40 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKQdH-0001lB-Fl
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:39 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKQcy-0000cz-6j
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] XFS: Convert filestreams code to use per-ag get/put
	routines
Date: Tue, 15 Dec 2009 17:11:14 +1100
Message-Id: <1260857477-2368-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1260857477-2368-1-git-send-email-david@fromorbit.com>
References: <1260857477-2368-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_filestream.c |   19 ++++++++++++-------
 fs/xfs/xfs_filestream.h |   27 ++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a631e14..e61f2aa 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -140,6 +140,7 @@ _xfs_filestream_pick_ag(
 	int		flags,
 	xfs_extlen_t	minlen)
 {
+	int		streams, max_streams;
 	int		err, trylock, nscan;
 	xfs_extlen_t	longest, free, minfree, maxfree = 0;
 	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
@@ -155,15 +156,15 @@ _xfs_filestream_pick_ag(
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
 	for (nscan = 0; 1; nscan++) {
-
-		TRACE_AG_SCAN(mp, ag, xfs_filestream_peek_ag(mp, ag));
-
-		pag = mp->m_perag + ag;
+		pag = xfs_perag_get(mp, ag);
+		TRACE_AG_SCAN(mp, ag, atomic_read(&pag->pagf_fstrms));
 
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
-			if (err && !trylock)
+			if (err && !trylock) {
+				xfs_perag_put(pag);
 				return err;
+			}
 		}
 
 		/* Might fail sometimes during the 1st pass with trylock set. */
@@ -173,6 +174,7 @@ _xfs_filestream_pick_ag(
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
+			max_streams = atomic_read(&pag->pagf_fstrms);
 			max_ag = ag;
 		}
 
@@ -195,6 +197,8 @@ _xfs_filestream_pick_ag(
 
 			/* Break out, retaining the reference on the AG. */
 			free = pag->pagf_freeblks;
+			streams = atomic_read(&pag->pagf_fstrms);
+			xfs_perag_put(pag);
 			*agp = ag;
 			break;
 		}
@@ -202,6 +206,7 @@ _xfs_filestream_pick_ag(
 		/* Drop the reference on this AG, it's not usable. */
 		xfs_filestream_put_ag(mp, ag);
 next_ag:
+		xfs_perag_put(pag);
 		/* Move to the next AG, wrapping to AG 0 if necessary. */
 		if (++ag >= mp->m_sb.sb_agcount)
 			ag = 0;
@@ -229,6 +234,7 @@ next_ag:
 		if (max_ag != NULLAGNUMBER) {
 			xfs_filestream_get_ag(mp, max_ag);
 			TRACE_AG_PICK1(mp, max_ag, maxfree);
+			streams = max_streams;
 			free = maxfree;
 			*agp = max_ag;
 			break;
@@ -240,8 +246,7 @@ next_ag:
 		return 0;
 	}
 
-	TRACE_AG_PICK2(mp, startag, *agp, xfs_filestream_peek_ag(mp, *agp),
-			free, nscan, flags);
+	TRACE_AG_PICK2(mp, startag, *agp, streams, free, nscan, flags);
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 4aba67c..58378b2 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -79,12 +79,21 @@ extern ktrace_t *xfs_filestreams_trace_buf;
  * the cache that reference per-ag array elements that have since been
  * reallocated.
  */
+/*
+ * xfs_filestream_peek_ag is only used in tracing code
+ */
 static inline int
 xfs_filestream_peek_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
 {
-	return atomic_read(&mp->m_perag[agno].pagf_fstrms);
+	struct xfs_perag *pag;
+	int		ret;
+
+	pag = xfs_perag_get(mp, agno);
+	ret = atomic_read(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+	return ret;
 }
 
 static inline int
@@ -92,7 +101,13 @@ xfs_filestream_get_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
 {
-	return atomic_inc_return(&mp->m_perag[agno].pagf_fstrms);
+	struct xfs_perag *pag;
+	int		ret;
+
+	pag = xfs_perag_get(mp, agno);
+	ret = atomic_inc_return(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+	return ret;
 }
 
 static inline int
@@ -100,7 +115,13 @@ xfs_filestream_put_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
 {
-	return atomic_dec_return(&mp->m_perag[agno].pagf_fstrms);
+	struct xfs_perag *pag;
+	int		ret;
+
+	pag = xfs_perag_get(mp, agno);
+	ret = atomic_dec_return(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+	return ret;
 }
 
 /* allocation selection flags */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
