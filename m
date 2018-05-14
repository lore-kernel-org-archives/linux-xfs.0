Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4160 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750748AbeENETM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 00:19:12 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fI4x0-0002vX-DN
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fI4x0-0002xn-Br
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: factor the ag length extension code into libxfs
Date: Mon, 14 May 2018 14:19:04 +1000
Message-Id: <20180514041904.11140-11-david@fromorbit.com>
In-Reply-To: <20180514041904.11140-1-david@fromorbit.com>
References: <20180514041904.11140-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Growfs currently manually codes the extension of the last AG in a
filesytem during the growfs process. Factor that out of the growfs
code and move it into libxfs along with teh rest of the AG header
modification code.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  7 ++++-
 fs/xfs/xfs_fsops.c     | 58 ++--------------------------------------
 3 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5baa22c07095..9345802c99f7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -16,6 +16,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
@@ -402,3 +403,62 @@ xfs_ag_init_headers(
 	}
 	return error;
 }
+
+/*
+ * Extent the AG indicated by the @id by the length passed in
+ */
+int
+xfs_ag_extend_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_extlen_t		len)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_buf		*bp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	int			error;
+
+	/*
+	 * Change the agi length.
+	 */
+	error = xfs_ialloc_read_agi(mp, tp, id->agno, &bp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(bp);
+	be32_add_cpu(&agi->agi_length, len);
+	ASSERT(id->agno == mp->m_sb.sb_agcount - 1 ||
+	       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
+	xfs_ialloc_log_agi(tp, bp, XFS_AGI_LENGTH);
+
+	/*
+	 * Change agf length.
+	 */
+	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &bp);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(bp);
+	be32_add_cpu(&agf->agf_length, len);
+	ASSERT(agf->agf_length == agi->agi_length);
+	xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
+
+	/*
+	 * Free the new space.
+	 *
+	 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
+	 * this doesn't actually exist in the rmap btree.
+	 */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
+	error = xfs_rmap_free(tp, bp, id->agno,
+				be32_to_cpu(agf->agf_length) - len,
+				len, &oinfo);
+	if (error)
+		return error;
+
+	return  xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, id->agno,
+					be32_to_cpu(agf->agf_length) - len),
+				len, &oinfo, XFS_AG_RESV_NONE);
+}
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 69f2fd4be0ea..412702e23f61 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -7,6 +7,9 @@
 #ifndef __LIBXFS_AG_H
 #define __LIBXFS_AG_H 1
 
+struct xfs_mount;
+struct xfs_trans;
+
 struct aghdr_init_data {
 	/* per ag data */
 	xfs_agblock_t		agno;		/* ag to init */
@@ -20,6 +23,8 @@ struct aghdr_init_data {
 	xfs_btnum_t		type;		/* type of btree root block */
 };
 
-int xfs_ag_init_headers( struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
+			struct aghdr_init_data *id, xfs_extlen_t len);
 
 #endif /* __LIBXFS_AG_H */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c5087b79bcea..bc7ef18da243 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -27,16 +27,12 @@
 #include "xfs_trans.h"
 #include "xfs_error.h"
 #include "xfs_btree.h"
-#include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_rmap_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_fsops.h"
 #include "xfs_trans_space.h"
 #include "xfs_rtalloc.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-#include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
@@ -48,8 +44,6 @@ xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
-	xfs_agf_t		*agf;
-	xfs_agi_t		*agi;
 	xfs_buf_t		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
@@ -132,57 +126,9 @@ xfs_growfs_data_private(
 
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
-	/*
-	 * There are new blocks in the old last a.g.
-	 */
+	/* If there are new blocks in the old last AG, extend it. */
 	if (new) {
-		struct xfs_owner_info	oinfo;
-
-		/*
-		 * Change the agi length.
-		 */
-		error = xfs_ialloc_read_agi(mp, tp, id.agno, &bp);
-		if (error)
-			goto out_trans_cancel;
-
-		ASSERT(bp);
-		agi = XFS_BUF_TO_AGI(bp);
-		be32_add_cpu(&agi->agi_length, new);
-		ASSERT(nagcount == oagcount ||
-		       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
-		xfs_ialloc_log_agi(tp, bp, XFS_AGI_LENGTH);
-
-		/*
-		 * Change agf length.
-		 */
-		error = xfs_alloc_read_agf(mp, tp, id.agno, 0, &bp);
-		if (error)
-			goto out_trans_cancel;
-
-		ASSERT(bp);
-		agf = XFS_BUF_TO_AGF(bp);
-		be32_add_cpu(&agf->agf_length, new);
-		ASSERT(be32_to_cpu(agf->agf_length) ==
-		       be32_to_cpu(agi->agi_length));
-
-		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
-
-		/*
-		 * Free the new space.
-		 *
-		 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
-		 * this doesn't actually exist in the rmap btree.
-		 */
-		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
-		error = xfs_rmap_free(tp, bp, id.agno,
-				be32_to_cpu(agf->agf_length) - new,
-				new, &oinfo);
-		if (error)
-			goto out_trans_cancel;
-		error = xfs_free_extent(tp,
-				XFS_AGB_TO_FSB(mp, id.agno,
-					be32_to_cpu(agf->agf_length) - new),
-				new, &oinfo, XFS_AG_RESV_NONE);
+		error = xfs_ag_extend_space(mp, tp, &id, new);
 		if (error)
 			goto out_trans_cancel;
 	}
-- 
2.17.0

