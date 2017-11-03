Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43960 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934627AbdKCBEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 21:04:53 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA314quA021406
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 3 Nov 2017 01:04:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA314qdi000412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 3 Nov 2017 01:04:52 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA314qhR019222
        for <linux-xfs@vger.kernel.org>; Fri, 3 Nov 2017 01:04:52 GMT
Date: Thu, 2 Nov 2017 18:04:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: scrub check the uniqueness of the AGFL entries
Message-ID: <20171103010451.GD4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we don't list a block twice in the agfl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 5495aa5..5aeecb8 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -476,6 +476,11 @@ xfs_scrub_agf(
 
 /* AGFL */
 
+struct xfs_scrub_agfl_info {
+	unsigned int			nr_entries;
+	xfs_agblock_t			*entries;
+};
+
 /* Scrub an AGFL block. */
 STATIC int
 xfs_scrub_agfl_block(
@@ -484,20 +489,39 @@ xfs_scrub_agfl_block(
 	void				*priv)
 {
 	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_agfl_info	*sai = priv;
 	xfs_agnumber_t			agno = sc->sa.agno;
 
-	if (!xfs_verify_agbno(mp, agno, agbno))
+	if (xfs_verify_agbno(mp, agno, agbno))
+		sai->entries[sai->nr_entries++] = agbno;
+	else
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
 
 	return 0;
 }
 
+static int
+xfs_scrub_agblock_cmp(
+	const void		*pa,
+	const void		*pb)
+{
+	const xfs_agblock_t	*a = pa;
+	const xfs_agblock_t	*b = pb;
+
+	return (int)*a - (int)*b;
+}
+
 /* Scrub the AGFL. */
 int
 xfs_scrub_agfl(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_scrub_agfl_info	sai = {0};
+	struct xfs_agf			*agf;
+	size_t				sz;
 	xfs_agnumber_t			agno;
+	unsigned int			agflcount;
+	unsigned int			i;
 	int				error;
 
 	agno = sc->sa.agno = sc->sm->sm_agno;
@@ -508,8 +532,33 @@ xfs_scrub_agfl(
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
 
+	/* Allocate buffer to ensure uniqueness of AGFL entries. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agflcount = be32_to_cpu(agf->agf_flcount);
+	sz = sizeof(xfs_agblock_t) * agflcount;
+	if (sz > sc->mp->m_sb.sb_sectsize) {
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		goto out;
+	}
+	sai.entries = kmem_zalloc(sz, KM_NOFS);
+
 	/* Check the blocks in the AGFL. */
-	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, NULL);
+	error = xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sai);
+	if (error)
+		goto out_free;
+
+	/* Sort entries, check for duplicates. */
+	sort(sai.entries, sai.nr_entries, sizeof(sai.entries[0]),
+			xfs_scrub_agblock_cmp, NULL);
+	for (i = 1; i < sai.nr_entries; i++) {
+		if (sai.entries[i] == sai.entries[i - 1]) {
+			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			break;
+		}
+	}
+
+out_free:
+	kmem_free(sai.entries);
 out:
 	return error;
 }
