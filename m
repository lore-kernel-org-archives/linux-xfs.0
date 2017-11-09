Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30917 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdKIFCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 00:02:40 -0500
Date: Wed, 8 Nov 2017 21:02:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/5] xfs: check the uniqueness of the AGFL entries
Message-ID: <20171109050235.GJ26910@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001660786.26786.14027251894350460924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001660786.26786.14027251894350460924.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we don't list a block twice in the agfl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: various review cleanups
---
 fs/xfs/scrub/agheader.c |   56 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 5495aa5..489f985 100644
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
@@ -484,20 +489,38 @@ xfs_scrub_agfl_block(
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
 	xfs_agnumber_t			agno;
+	unsigned int			agflcount;
+	unsigned int			i;
 	int				error;
 
 	agno = sc->sa.agno = sc->sm->sm_agno;
@@ -508,8 +531,37 @@ xfs_scrub_agfl(
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
 
+	/* Allocate buffer to ensure uniqueness of AGFL entries. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agflcount = be32_to_cpu(agf->agf_flcount);
+	if (agflcount > XFS_AGFL_SIZE(sc->mp)) {
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		goto out;
+	}
+	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
+			KM_SLEEP | KM_NOFS);
+	if (!sai.entries) {
+		error = -ENOMEM;
+		goto out;
+	}
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
