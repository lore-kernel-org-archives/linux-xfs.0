Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6961CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbiLaBeR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLaBeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:34:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A2DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:34:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85319B81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FDC433D2;
        Sat, 31 Dec 2022 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450453;
        bh=vbWNqrHfzCegYiUJ5SjoTtHCLpvWfapNlNU19lvkd68=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GxA17hUZDTe349UIHM64PssTBfGRy33XQ5a8O1NxDybF63V7bMm9TkIUHg737nCkq
         BAdSgDUkWEuOaDpCg+8x/4AUUgoKCeP6u8QZSvajbQxZ2zpKf2pMs3CAc2ijNCKOUe
         LXjULNkoZO62lGWp26nididV2FGnrFE4mvyu5w84+gt3Rc/KF4xE63ZljNUX31SI9m
         vWWnwEAxcwtDbtlKg6lVeEUN5N3T+DRmE2FPejauis4bLFXAAR5JD2iYB8Nf+9HQ7j
         L7SNphetl+jY5w4Qv7iaHE52sUSFVxWyXVav6pHgFBJL+aeaHXIgmFiEk19KLsvYIx
         m4LqpJm5PPJGQ==
Subject: [PATCH 1/2] xfs: simplify xfs_ag_resv_free signature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:02 -0800
Message-ID: <167243868212.714306.2868193225075481960.stgit@magnolia>
In-Reply-To: <167243868195.714306.16190516279141417082.stgit@magnolia>
References: <167243868195.714306.16190516279141417082.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's not possible to fail at increasing fdblocks, so get rid of all the
error returns here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c      |    4 +---
 fs/xfs/libxfs/xfs_ag_resv.c |   22 +++++-----------------
 fs/xfs/libxfs/xfs_ag_resv.h |    2 +-
 fs/xfs/scrub/repair.c       |    5 +----
 fs/xfs/xfs_fsops.c          |   24 ++++++------------------
 fs/xfs/xfs_fsops.h          |    2 +-
 fs/xfs/xfs_super.c          |    6 +-----
 fs/xfs/xfs_trace.h          |    1 -
 8 files changed, 16 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 05d0a97e08c3..bc1fc86df322 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -887,9 +887,7 @@ xfs_ag_shrink_space(
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
 	 */
-	error = xfs_ag_resv_free(pag);
-	if (error)
-		return error;
+	xfs_ag_resv_free(pag);
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent(&args);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2e6128a25635..8723cd0d3f58 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -126,14 +126,13 @@ xfs_ag_resv_needed(
 }
 
 /* Clean out a reservation */
-static int
+static void
 __xfs_ag_resv_free(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
 	struct xfs_ag_resv		*resv;
 	xfs_extlen_t			oldresv;
-	int				error;
 
 	trace_xfs_ag_resv_free(pag, type, 0);
 
@@ -149,30 +148,19 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+	xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 	resv->ar_orig_reserved = 0;
-
-	if (error)
-		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
-	return error;
 }
 
 /* Free a per-AG reservation. */
-int
+void
 xfs_ag_resv_free(
 	struct xfs_perag		*pag)
 {
-	int				error;
-	int				err2;
-
-	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
-	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
-	if (err2 && !error)
-		error = err2;
-	return error;
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 }
 
 static int
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index b74b210008ea..ff20ed93de77 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_AG_RESV_H__
 #define	__XFS_AG_RESV_H__
 
-int xfs_ag_resv_free(struct xfs_perag *pag);
+void xfs_ag_resv_free(struct xfs_perag *pag);
 int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
 
 bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b5c5ee7f512b..1652f633f692 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -951,9 +951,7 @@ xrep_reset_perag_resv(
 	ASSERT(sc->tp);
 
 	sc->flags &= ~XREP_RESET_PERAG_RESV;
-	error = xfs_ag_resv_free(sc->sa.pag);
-	if (error)
-		goto out;
+	xfs_ag_resv_free(sc->sa.pag);
 	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
 	if (error == -ENOSPC) {
 		xfs_err(sc->mp,
@@ -962,7 +960,6 @@ xrep_reset_perag_resv(
 		error = 0;
 	}
 
-out:
 	return error;
 }
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2da86f05e0e5..8186f142864a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -201,11 +201,10 @@ xfs_growfs_data_private(
 			struct xfs_perag	*pag;
 
 			pag = xfs_perag_get(mp, id.agno);
-			error = xfs_ag_resv_free(pag);
+			xfs_ag_resv_free(pag);
 			xfs_perag_put(pag);
-			if (error)
-				return error;
 		}
+
 		/*
 		 * Reserve AG metadata blocks. ENOSPC here does not mean there
 		 * was a growfs failure, just that there still isn't space for
@@ -585,24 +584,13 @@ xfs_fs_reserve_ag_blocks(
 /*
  * Free space reserved for per-AG metadata.
  */
-int
+void
 xfs_fs_unreserve_ag_blocks(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
 	struct xfs_perag	*pag;
-	int			error = 0;
-	int			err2;
+	xfs_agnumber_t		agno;
 
-	for_each_perag(mp, agno, pag) {
-		err2 = xfs_ag_resv_free(pag);
-		if (err2 && !error)
-			error = err2;
-	}
-
-	if (error)
-		xfs_warn(mp,
-	"Error %d freeing per-AG metadata reserve pool.", error);
-
-	return error;
+	for_each_perag(mp, agno, pag)
+		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 2cffe51a31e8..dba17c404e7d 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -14,6 +14,6 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
 
 extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
-extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
+extern void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bfe93ca6eed4..e145de0bd562 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1830,11 +1830,7 @@ xfs_remount_ro(
 	xfs_inodegc_stop(mp);
 
 	/* Free the per-AG metadata reservation pool. */
-	error = xfs_fs_unreserve_ag_blocks(mp);
-	if (error) {
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
+	xfs_fs_unreserve_ag_blocks(mp);
 
 	/*
 	 * Before we sync the metadata, we need to free up the reserve block
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cfb26288394a..d0e939f5b706 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3145,7 +3145,6 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
 
-DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
 DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
 /* refcount tracepoint classes */

