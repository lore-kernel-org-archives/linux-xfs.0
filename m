Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E36C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE6E3206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1gDHgxk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:18:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:18:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ES7G112764
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=EbZcn0+SaU+rIVZOoxR4sku6Aq+eZCoUVZjGVd1Ucao=;
 b=K1gDHgxk1I3mo8jEiA8xIlPFeXjFApPgP7XIVQJWVICgTDeUgMhMztajcTib2Vt1qma3
 1O6tZk7ao6nwMmJOlpjLYUIt9S0PXWRLVO65waly/l9bHyPEFW1UdnLJn5hhpC7cG5ZQ
 zq2Ct0rdKTNtxvN1kkFGyu/1gFQMUtuH+yj7jDOus9H8IJYDLKVbS/D+pPMHWjiGXcms
 LfaPFuoOC1Oi6LAOj9GiKh/UgHsgnwQqyDu90Nso49TS7r4lkEvUZzxlMIpYnKVPfkSE
 0hi/EvWso14JKNPn/pX2iwB59PaLwZcN89iqni+sG5RIkxUMKCSLOugRiJz/3k+7sZza 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I8hp056927
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfgrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:28 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011IRmB002502
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:27 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:18:26 -0800
Subject: [PATCH 20/21] xfs: cross-reference the realtime rmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:18:24 -0800
Message-ID: <157784150436.1368137.11808268402223488090.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're scrubbing the realtime metadata, cross-reference
the rtrmapt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c     |   19 +++++++++++++++++++
 fs/xfs/scrub/common.c   |   22 ++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    1 +
 fs/xfs/scrub/rmap.c     |   16 ++++++++--------
 fs/xfs/scrub/rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |   12 ++++++------
 6 files changed, 86 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 8bb81caf0c6b..f70525293955 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -241,8 +241,27 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	struct xfs_mount	*mp = info->sc->mp;
+	int			error;
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	if (mp->m_rrmapip)
+		xfs_ilock(mp->m_rrmapip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+
+	error = xchk_rt_init(info->sc, &info->sc->sa);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		goto out_unlock;
+
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
+	xchk_bmap_xref_rmap(info, irec, irec->br_startblock);
+
+	xchk_ag_free(info->sc, &info->sc->sa);
+out_unlock:
+	if (mp->m_rrmapip)
+		xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_EXCL);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 68fa5ab8c52b..8cda752fad67 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -584,6 +585,27 @@ xchk_perag_get(
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
index 6e0ae69fc109..6e432c04fdf4 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -121,6 +121,7 @@ xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+int xchk_rt_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index b50604b7f87d..4580061ca862 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -177,8 +177,8 @@ xchk_rmapbt(
 static inline void
 xchk_xref_check_owner(
 	struct xfs_scrub		*sc,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	bool				should_have_rmap)
 {
@@ -200,8 +200,8 @@ xchk_xref_check_owner(
 void
 xchk_xref_is_owned_by(
 	struct xfs_scrub		*sc,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, true);
@@ -211,8 +211,8 @@ xchk_xref_is_owned_by(
 void
 xchk_xref_is_not_owned_by(
 	struct xfs_scrub		*sc,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, false);
@@ -222,8 +222,8 @@ xchk_xref_is_not_owned_by(
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
index 6cbd3f6413e0..ca17df198cb2 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -9,12 +9,16 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/btree.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -32,11 +36,31 @@ xchk_setup_rt(
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
@@ -55,6 +79,8 @@ xchk_rtbitmap_rec(
 	    !xfs_verify_rtbno(sc->mp, startblock) ||
 	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	xchk_rtbitmap_xref(sc, startblock, blockcount);
 	return 0;
 }
 
@@ -70,6 +96,10 @@ xchk_rtbitmap(
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
index fb5f0f371cd8..6c435341ad68 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -152,12 +152,12 @@ void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
 void xchk_xref_is_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
-void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
-void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
-void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len);
+void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo);
+void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo);
+void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_fsblock_t bno,
+		xfs_filblks_t len);
 void xchk_xref_is_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
 		xfs_extlen_t len);
 void xchk_xref_is_not_shared(struct xfs_scrub *sc, xfs_agblock_t bno,

