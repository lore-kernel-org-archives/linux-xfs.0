Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34578 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdKGBDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:03:30 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA713Tec030200
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA713Tce008989
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:29 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA713SRp016385
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:28 GMT
Subject: [PATCH 1/5] xfs: check the uniqueness of the AGFL entries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:27 -0800
Message-ID: <151001660786.26786.14027251894350460924.stgit@magnolia>
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we don't list a block twice in the agfl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 5495aa5..a7d514b 100644
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
+	struct xfs_scrub_agfl_info	sai = { 0 };
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

