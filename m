Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbeERDrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:47:37 -0400
Date: Thu, 17 May 2018 20:47:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0.5/22] xfs: grab the per-ag structure whenever relevant
Message-ID: <20180518034732.GX23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Grab and hold the per-AG data across a scrub run whenever relevant.
This helps us avoid repeated trips through rcu in the repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   17 +++++++++++++++++
 fs/xfs/scrub/common.h |    1 +
 fs/xfs/scrub/scrub.h  |    1 +
 3 files changed, 19 insertions(+)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 518bff2be0c9..d3e5adc96411 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -541,6 +541,10 @@ xfs_scrub_ag_free(
 		xfs_trans_brelse(sc->tp, sa->agi_bp);
 		sa->agi_bp = NULL;
 	}
+	if (sa->pag) {
+		xfs_perag_put(sa->pag);
+		sa->pag = NULL;
+	}
 	sa->agno = NULLAGNUMBER;
 }
 
@@ -568,6 +572,19 @@ xfs_scrub_ag_init(
 	return xfs_scrub_ag_btcur_init(sc, sa);
 }
 
+/*
+ * Grab the per-ag structure if we haven't already gotten it.  Teardown of the
+ * xfs_scrub_ag will release it for us.
+ */
+void
+xfs_scrub_perag_get(
+	struct xfs_mount	*mp,
+	struct xfs_scrub_ag	*sa)
+{
+	if (!sa->pag)
+		sa->pag = xfs_perag_get(mp, sa->agno);
+}
+
 /* Per-scrubber setup functions */
 
 /*
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index a660087b606e..fbb91a7144fd 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -123,6 +123,7 @@ xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		      struct xfs_scrub_ag *sa);
+void xfs_scrub_perag_get(struct xfs_mount *mp, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 			      struct xfs_buf **agi, struct xfs_buf **agf,
 			      struct xfs_buf **agfl);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 2f89a84a0e10..636424d5e2ee 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -51,6 +51,7 @@ struct xfs_scrub_meta_ops {
 /* Buffer pointers and btree cursors for an entire AG. */
 struct xfs_scrub_ag {
 	xfs_agnumber_t			agno;
+	struct xfs_perag		*pag;
 
 	/* AG btree roots */
 	struct xfs_buf			*agf_bp;
