Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47082 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfDPATz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:19:55 -0400
Subject: [PATCH 3/5] xfs: hoist the already_fixed variable to the scrub
 context
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Apr 2019 17:19:49 -0700
Message-ID: <155537398946.27935.9233257960413346572.stgit@magnolia>
In-Reply-To: <155537397092.27935.16073573221774618735.stgit@magnolia>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we no longer memset the scrub context, we can move the
already_fixed variable into the scrub context's state flags instead of
passing around pointers to separate stack variables.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |    5 ++---
 fs/xfs/scrub/repair.h |    5 ++---
 fs/xfs/scrub/scrub.c  |    6 +++---
 fs/xfs/scrub/scrub.h  |    5 +++--
 4 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c093939fe35a..5e7e36cdf3d5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -46,8 +46,7 @@
 int
 xrep_attempt(
 	struct xfs_inode	*ip,
-	struct xfs_scrub	*sc,
-	bool			*fixed)
+	struct xfs_scrub	*sc)
 {
 	int			error = 0;
 
@@ -66,7 +65,7 @@ xrep_attempt(
 		 * scrub so that we can tell userspace if we fixed the problem.
 		 */
 		sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
-		*fixed = true;
+		sc->flags |= XREP_ALREADY_FIXED;
 		return -EAGAIN;
 	case -EDEADLOCK:
 	case -EAGAIN:
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index d990314eb08b..60c61d7052a8 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -15,7 +15,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 /* Repair helpers */
 
-int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc, bool *fixed);
+int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
@@ -64,8 +64,7 @@ int xrep_agi(struct xfs_scrub *sc);
 
 static inline int xrep_attempt(
 	struct xfs_inode	*ip,
-	struct xfs_scrub	*sc,
-	bool			*fixed)
+	struct xfs_scrub	*sc)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6e18a1178e26..02d278b7d20b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -476,7 +476,6 @@ xfs_scrub_metadata(
 		},
 	};
 	struct xfs_mount		*mp = ip->i_mount;
-	bool				already_fixed = false;
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
@@ -521,7 +520,8 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
-	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
+	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    !(sc.flags & XREP_ALREADY_FIXED)) {
 		bool needs_fix;
 
 		/* Let debug users force us into the repair routines. */
@@ -544,7 +544,7 @@ xfs_scrub_metadata(
 		 * If it's broken, userspace wants us to fix it, and we haven't
 		 * already tried to fix it, then attempt a repair.
 		 */
-		error = xrep_attempt(ip, &sc, &already_fixed);
+		error = xrep_attempt(ip, &sc);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 60359e7de930..1b23bf141438 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -63,16 +63,17 @@ struct xfs_scrub {
 	void				*buf;
 	uint				ilock_flags;
 
-	/* See the XCHK state flags below. */
+	/* See the XCHK/XREP state flags below. */
 	unsigned int			flags;
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
 
-/* XCHK state flags */
+/* XCHK/XREP state flags */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
+#define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
