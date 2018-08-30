Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeH3WhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:37:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UIXhOL154875
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:43 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2m2xhu6f5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIXaew030308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:36 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIXaBk013345
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:36 GMT
Subject: [PATCH 18/18] xfs: cross-reference the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:33:34 -0700
Message-ID: <153565401479.32612.6994922368754344692.stgit@magnolia>
In-Reply-To: <153565389576.32612.11057291402738397706.stgit@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
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
 fs/xfs/scrub/bmap.c     |   10 ++++++++++
 fs/xfs/scrub/common.c   |   22 ++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    1 +
 fs/xfs/scrub/rmap.c     |   16 ++++++++--------
 fs/xfs/scrub/rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |   12 ++++++------
 6 files changed, 77 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b62845d016d2..2a7eff7a9b96 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -249,11 +249,21 @@ xchk_bmap_rt_extent_xref(
 	struct xfs_btree_cur	*cur,
 	struct xfs_bmbt_irec	*irec)
 {
+	int				error;
+
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
+	error = xchk_rt_init(info->sc, &info->sc->sa);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		return;
+
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
+	xchk_bmap_xref_rmap(info, irec, irec->br_startblock);
+
+	xchk_ag_free(info->sc, &info->sc->sa);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index d0f9b53a7ceb..204b572d0ce4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -32,6 +32,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -574,6 +575,27 @@ xchk_perag_get(
 		sa->pag = xfs_perag_get(mp, sa->agno);
 }
 
+/*
+ * For scrubbing a realtime file, grab the rtrmapt.  We follow the same
+ * resource release rules as xfs_scrub_ag_init.
+ */
+int
+xchk_rt_init(
+	struct xfs_scrub	*sc,
+	struct xchk_ag			*sa)
+{
+	memset(sa, 0, sizeof(*sa));
+	sa->agno = NULLAGNUMBER;
+	if (xfs_sb_version_hasrmapbt(&sc->mp->m_sb)) {
+		ASSERT(xfs_isilocked(sc->mp->m_rrmapip,
+				XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
+		sa->rmap_cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp,
+				sc->mp->m_rrmapip);
+	}
+
+	return 0;
+}
+
 /* Per-scrubber setup functions */
 
 /*
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6bccffddc832..4fcc2ccd2401 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -113,6 +113,7 @@ xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+int xchk_rt_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 32dc329e5411..32df9ed77b74 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -189,8 +189,8 @@ xchk_rmapbt(
 static inline void
 xchk_xref_check_owner(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	struct xfs_owner_info	*oinfo,
 	bool			should_have_rmap)
 {
@@ -212,8 +212,8 @@ xchk_xref_check_owner(
 void
 xchk_xref_is_owned_by(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, true);
@@ -223,8 +223,8 @@ xchk_xref_is_owned_by(
 void
 xchk_xref_is_not_owned_by(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, false);
@@ -234,8 +234,8 @@ xchk_xref_is_not_owned_by(
 void
 xchk_xref_has_no_owner(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len)
 {
 	bool			has_rmap;
 	int			error;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 665d4bbb17cc..08041fc51fa1 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -15,12 +15,16 @@
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
@@ -39,11 +43,31 @@ xchk_setup_rt(
 	sc->ip = sc->mp->m_rbmip;
 	xfs_ilock(sc->ip, sc->ilock_flags);
 
+	if (xfs_sb_version_hasrmapbt(&sc->mp->m_sb)) {
+		unsigned int	lockmode = XFS_ILOCK_EXCL;
+
+		xfs_ilock(sc->mp->m_rrmapip, lockmode);
+		xfs_trans_ijoin(sc->tp, sc->mp->m_rrmapip, lockmode);
+	}
+
 	return 0;
 }
 
 /* Realtime bitmap. */
 
+/* Cross-reference rtbitmap entries with other metadata. */
+STATIC void
+xchk_rtbitmap_xref(
+	struct xfs_scrub	*sc,
+	xfs_rtblock_t		startblock,
+	xfs_rtblock_t		blockcount)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	xchk_xref_has_no_owner(sc, startblock, blockcount);
+}
+
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xchk_rtbitmap_rec(
@@ -62,6 +86,8 @@ xchk_rtbitmap_rec(
 	    !xfs_verify_rtbno(sc->mp, startblock) ||
 	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	xchk_rtbitmap_xref(sc, startblock, blockcount);
 	return 0;
 }
 
@@ -77,6 +103,10 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
+	error = xchk_rt_init(sc, &sc->sa);
+	if (error)
+		return error;
+
 	error = xfs_rtalloc_query_all(sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 470785292b46..87eed5bc6c80 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -135,12 +135,12 @@ void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
 void xchk_xref_is_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
-void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo);
-void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo);
-void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len);
+void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo);
+void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo);
+void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len);
 void xchk_xref_is_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
 		xfs_extlen_t len);
 void xchk_xref_is_not_shared(struct xfs_scrub *sc, xfs_agblock_t bno,
