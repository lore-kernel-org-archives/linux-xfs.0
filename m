Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36604 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbdK2B0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:26:23 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1QMTO021789
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1QL3d017408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:21 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1QKi9013326
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:21 GMT
Subject: [PATCH 09/16] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:26:19 -0800
Message-ID: <151191877982.8553.13534722533248012131.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
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
 fs/xfs/scrub/agheader.c |   26 ++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6b622a0..37dde37 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -445,6 +445,7 @@ xfs_scrub_agf_xref(
 	struct xfs_btree_cur		**pcur;
 	xfs_agblock_t			bno;
 	xfs_extlen_t			blocks;
+	int				have;
 	int				error;
 
 	bno = XFS_AGF_BLOCK(mp);
@@ -466,6 +467,31 @@ xfs_scrub_agf_xref(
 			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
+	/* Cross-reference with the cntbt. */
+	pcur = &sc->sa.cnt_cur;
+	while (*pcur) {
+		xfs_agblock_t		agbno;
+
+		/* Any freespace at all? */
+		error = xfs_alloc_lookup_le(*pcur, 0, -1U, &have);
+		if (!xfs_scrub_should_xref(sc, &error, pcur))
+			break;
+		if (!have) {
+			if (agf->agf_freeblks != be32_to_cpu(0))
+				xfs_scrub_block_xref_set_corrupt(sc,
+						sc->sa.agf_bp);
+			break;
+		}
+
+		/* Check agf_longest */
+		error = xfs_alloc_get_rec(*pcur, &agbno, &blocks, &have);
+		if (!xfs_scrub_should_xref(sc, &error, pcur))
+			break;
+		if (!have || blocks != be32_to_cpu(agf->agf_longest))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		break;
+	}
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 3d6f8cc..9a28e3d 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -57,6 +58,42 @@ xfs_scrub_allocbt_xref(
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
 {
+	struct xfs_btree_cur		**pcur;
+	struct xfs_scrub_ag		*psa = &sc->sa;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				has_otherrec;
+	int				error;
+
+	/*
+	 * Ensure there's a corresponding cntbt/bnobt record matching
+	 * this bnobt/cntbt record, respectively.
+	 */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		pcur = &psa->cnt_cur;
+	else
+		pcur = &psa->bno_cur;
+	while (*pcur) {
+		error = xfs_alloc_lookup_le(*pcur, bno, len, &has_otherrec);
+		if (!xfs_scrub_should_xref(sc, &error, pcur))
+			break;
+		if (!has_otherrec) {
+			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+			break;
+		}
+
+		error = xfs_alloc_get_rec(*pcur, &fbno, &flen, &has_otherrec);
+		if (!xfs_scrub_should_xref(sc, &error, pcur))
+			break;
+		if (!has_otherrec) {
+			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+			break;
+		}
+
+		if (fbno != bno || flen != len)
+			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		break;
+	}
 }
 
 /* Scrub a bnobt/cntbt record. */

