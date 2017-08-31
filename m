Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36452 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdHaUfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:35:33 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKZWM8023809
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZVK1024598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:32 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKZVuD024980
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:31 GMT
Subject: [PATCH 19/19] xfs: cross-reference the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:35:29 -0700
Message-ID: <150421172922.17458.14523757193599771602.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're scrubbing the realtime metadata, cross-reference
the rtrmapt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c     |   12 ++++++++++
 fs/xfs/scrub/rtbitmap.c |   54 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 438a8b6..d93b53f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_refcount.h"
@@ -314,6 +315,7 @@ xfs_scrub_bmap_extent(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				is_free = false;
+	int				lockmode = 0;
 	int				error = 0;
 
 	if (cur)
@@ -405,6 +407,14 @@ xfs_scrub_bmap_extent(
 					!has_inodes);
 	}
 
+	if (info->is_rt && xfs_sb_version_hasrtrmapbt(&mp->m_sb)) {
+		/* Set up the rtrmapbt cross-reference. */
+		lockmode = XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP;
+		xfs_ilock(mp->m_rrmapip, lockmode);
+		sa.rmap_cur = xfs_rtrmapbt_init_cursor(mp, info->sc->tp,
+				mp->m_rrmapip);
+	}
+
 	/* Cross-reference with rmapbt. */
 	if (sa.rmap_cur)
 		xfs_scrub_bmap_xref_rmap(info, &sa, irec, bno);
@@ -417,6 +427,8 @@ xfs_scrub_bmap_extent(
 		xfs_scrub_bmap_xref_refc(info, &sa, irec, bno);
 
 	xfs_scrub_ag_free(info->sc, &sa);
+	if (lockmode)
+		xfs_iunlock(mp->m_rrmapip, lockmode);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
 	return error;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index e15f8f3..9b7fded 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -29,12 +29,16 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/btree.h"
 #include "scrub/trace.h"
 
 /* Set us up with the realtime metadata locked. */
@@ -54,6 +58,12 @@ xfs_scrub_setup_rt(
 	if (error)
 		return error;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(mp->m_rrmapip, lockmode);
+		xfs_trans_ijoin(sc->tp, mp->m_rrmapip, lockmode);
+	}
+
 	lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
 	xfs_ilock(mp->m_rbmip, lockmode);
 	xfs_trans_ijoin(sc->tp, mp->m_rbmip, lockmode);
@@ -63,6 +73,11 @@ xfs_scrub_setup_rt(
 
 /* Realtime bitmap. */
 
+struct xfs_scrub_rtbitmap_info {
+	struct xfs_btree_cur		*cur;
+	struct xfs_scrub_context	*sc;
+};
+
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xfs_scrub_rtbitmap_helper(
@@ -70,7 +85,32 @@ xfs_scrub_rtbitmap_helper(
 	struct xfs_rtalloc_rec		*rec,
 	void				*priv)
 {
-	return 0;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_scrub_rtbitmap_info	*sri = priv;
+	struct xfs_scrub_context	*sc = sri->sc;
+	struct xfs_buf			*bp;
+	xfs_rtblock_t			block;
+	bool				has_rmap;
+	int				error;
+
+	if (!sri->cur)
+		return 0;
+
+	/* Find the buffer for error reporting. */
+	block = XFS_BITTOBLOCK(mp, rec->ar_startblock);
+	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	if (!xfs_scrub_op_ok(sc, 0, 0, &error))
+		goto out;
+
+	/* Cross-reference the rtrmapbt. */
+	error = xfs_rmap_has_record(sri->cur, rec->ar_startblock,
+			rec->ar_blockcount, &has_rmap);
+	if (xfs_scrub_should_xref(sc, &error, &sri->cur))
+		xfs_scrub_btree_xref_check_ok(sc, sri->cur, 0, !has_rmap);
+
+	xfs_trans_brelse(sc->tp, bp);
+out:
+	return error;
 }
 
 /* Scrub the realtime bitmap. */
@@ -78,13 +118,23 @@ int
 xfs_scrub_rtbitmap(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_rtbitmap_info	sri;
 	int				error;
 
-	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_helper, NULL);
+	sri.sc = sc;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		sri.cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, mp->m_rrmapip);
+	else
+		sri.cur = NULL;
+
+	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_helper, &sri);
 	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 
 out:
+	if (sri.cur)
+		xfs_btree_del_cursor(sri.cur, XFS_BTREE_ERROR);
 	return error;
 }
 

