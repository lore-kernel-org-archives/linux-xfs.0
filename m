Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlLVd024850
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:45 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2eudq605x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNvKGA012344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:21 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNvK2w017923
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:20 GMT
Subject: [PATCH 09/15] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:57:17 -0800
Message-ID: <151320943733.30154.16906441736291178660.stgit@magnolia>
In-Reply-To: <151320938254.30154.1046660005648421683.stgit@magnolia>
References: <151320938254.30154.1046660005648421683.stgit@magnolia>
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
index 6241475..c7bfa20 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -428,6 +428,7 @@ xfs_scrub_agf_xref(
 	struct xfs_btree_cur		**pcur;
 	xfs_agblock_t			bno;
 	xfs_extlen_t			blocks;
+	int				have;
 	int				error;
 
 	bno = XFS_AGF_BLOCK(mp);
@@ -449,6 +450,31 @@ xfs_scrub_agf_xref(
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

