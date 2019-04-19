Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51144 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:21:21 -0400
Subject: [PATCH 3/5] xfs: allow scrubbers to pause background reclaim
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:21:17 -0700
Message-ID: <155563327720.112668.11514675530007162880.stgit@magnolia>
In-Reply-To: <155563325882.112668.3605935077532891922.stgit@magnolia>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

The forthcoming summary counter patch races with regular filesystem
activity to compute rough expected values for the counters.  This design
was chosen to avoid having to freeze the entire filesystem to check the
counters, but while that's running we'd prefer to minimize background
reclamation activity to reduce the perturbations to the incore free
block count.  Therefore, provide a way for scrubbers to disable
background posteof and cowblock reclamation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   18 ++++++++++++++++++
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/scrub.c  |    2 ++
 fs/xfs/scrub/scrub.h  |    1 +
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7076d5c98151..7d7e91a7bb86 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -894,3 +894,21 @@ xchk_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
+
+/* Pause background reaping of resources. */
+void
+xchk_stop_reaping(
+	struct xfs_scrub	*sc)
+{
+	sc->flags |= XCHK_REAPING_DISABLED;
+	xfs_stop_block_reaping(sc->mp);
+}
+
+/* Restart background reaping of resources. */
+void
+xchk_start_reaping(
+	struct xfs_scrub	*sc)
+{
+	xfs_start_block_reaping(sc->mp);
+	sc->flags &= ~XCHK_REAPING_DISABLED;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e26a430bd466..84900bfad852 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -137,5 +137,7 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+void xchk_stop_reaping(struct xfs_scrub *sc);
+void xchk_start_reaping(struct xfs_scrub *sc);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 93b0f075a4d3..ce13c1c366db 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -187,6 +187,8 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->flags & XCHK_REAPING_DISABLED)
+		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1b280f8f185a..01986ed364db 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -80,6 +80,7 @@ struct xfs_scrub {
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
+#define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
