Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17939 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdHKHLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:04 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7B3hD018802
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7B38j030760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:03 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7B7B3xS020559
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:03 GMT
Subject: [PATCH 08/16] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:02 -0700
Message-ID: <150243546244.29473.10901627724772771482.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   21 +++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   31 +++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 17d4b4e..7e7ad5f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -442,6 +442,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	int				have;
 	int				level;
 	int				error = 0;
 
@@ -544,6 +545,26 @@ xfs_scrub_agf(
 		break;
 	}
 
+	/* Cross-reference with the cntbt. */
+	while (psa->cnt_cur) {
+		error = xfs_alloc_lookup_le(psa->cnt_cur, 0, -1U, &have);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->cnt_cur))
+			break;
+		if (!have) {
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					agf->agf_freeblks == be32_to_cpu(0));
+			break;
+		}
+
+		error = xfs_alloc_get_rec(psa->cnt_cur, &agbno, &blocks, &have);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->cnt_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+				!have ||
+				blocks == be32_to_cpu(agf->agf_longest));
+		break;
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index f0e2386..eec27ce 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -58,9 +59,14 @@ xfs_scrub_allocbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_btree_cur		**xcur;
+	struct xfs_scrub_ag		*psa;
 	unsigned long long		rec_end;
+	xfs_agblock_t			fbno;
 	xfs_agblock_t			bno;
+	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	int				has_otherrec;
 	int				error = 0;
 
 	bno = be32_to_cpu(rec->alloc.ar_startblock);
@@ -75,6 +81,31 @@ xfs_scrub_allocbt_helper(
 			rec_end <= mp->m_sb.sb_agblocks &&
 			rec_end <= be32_to_cpu(agf->agf_length));
 
+	psa = &bs->sc->sa;
+	/*
+	 * Ensure there's a corresponding cntbt/bnobt record matching
+	 * this bnobt/cntbt record, respectively.
+	 */
+	xcur = bs->cur == psa->bno_cur ? &psa->cnt_cur : &psa->bno_cur;
+	while (*xcur) {
+		error = xfs_alloc_lookup_le(*xcur, bno, len, &has_otherrec);
+		if (!xfs_scrub_should_xref(bs->sc, &error, xcur) ||
+		    !xfs_scrub_btree_xref_check_ok(bs->sc, *xcur, 0,
+				has_otherrec))
+			break;
+
+		error = xfs_alloc_get_rec(*xcur, &fbno, &flen,
+				&has_otherrec);
+		if (!xfs_scrub_should_xref(bs->sc, &error, xcur) ||
+		    !xfs_scrub_btree_xref_check_ok(bs->sc, *xcur, 0,
+				has_otherrec))
+			break;
+
+		xfs_scrub_btree_xref_check_ok(bs->sc, *xcur, 0,
+				fbno == bno && flen == len);
+		break;
+	}
+
 	return error;
 }
 

