Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D43AC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjEZAof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjEZAof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2677612E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF87A64BE0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2C4C433EF;
        Fri, 26 May 2023 00:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061873;
        bh=LgKaEv3yQEsA29q5yHD5QVtJ/H7Zwqtb7O1kgqO9I9A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DRPqFjMovEm0IW5ghfQfAC1TCrHLY5ZlLBo5epgQgLhMj0RSdV/ZD+9z/4+QDYFHd
         uBtvsNOALpuGtfQBRQUHTddsxJjp4EWgBEohqcqzoTbMaJBB5wyJpBgy1Igt5CtkIH
         PRVH3sB6BFfzoiAgw1JmppdvkyN0dNqibDB+u8r+mNmsnkR5f1xO9Zl7bX+nNr05pi
         CuOirmPk1PjG3IJYDII8EbRGIJJeYuocZiVR9M/tUJYxdcjWXyuQY15ob6ifJz8/Z1
         BIadR0/1J+O4aStLj5VZPOvurhxnH0yLjwUjIkfJCvU8P5O71A2jPikqEmLHBs9kNT
         wGfojt+rgEjNA==
Date:   Thu, 25 May 2023 17:44:32 -0700
Subject: [PATCH 6/9] xfs: rearrange xrep_reap_block to make future code flow
 easier
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055703.3728180.7446040903727951043.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rearrange the logic inside xrep_reap_block to make it more obvious that
crosslinked metadata blocks are handled differently.  Add a couple of
tracepoints so that we can tell what's going on at the end of a btree
rebuild operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    6 +++---
 fs/xfs/scrub/reap.c            |   19 ++++++++++++++-----
 fs/xfs/scrub/trace.h           |   17 ++++++++---------
 3 files changed, 25 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index c902a5dee57f..b8d28cfec286 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -646,13 +646,13 @@ xrep_agfl_fill(
 	xfs_fsblock_t		fsbno = start;
 	int			error;
 
+	trace_xrep_agfl_insert(sc->sa.pag, XFS_FSB_TO_AGBNO(sc->mp, start),
+			len);
+
 	while (fsbno < start + len && af->fl_off < af->flcount)
 		af->agfl_bno[af->fl_off++] =
 				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
 
-	trace_xrep_agfl_insert(sc->mp, sc->sa.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(sc->mp, start), len);
-
 	error = xbitmap_set(&af->used_extents, start, fsbno - 1);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index e9839f3905e7..30e61315feb0 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -175,8 +175,6 @@ xrep_reap_block(
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
 
-	trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
-
 	/* We don't support reaping file extents yet. */
 	if (sc->ip != NULL || sc->sa.pag->pag_agno != agno) {
 		ASSERT(0);
@@ -206,10 +204,21 @@ xrep_reap_block(
 	 * to run xfs_repair.
 	 */
 	if (has_other_rmap) {
+		trace_xrep_dispose_unmap_extent(sc->sa.pag, agbno, 1);
+
 		error = xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
 				1, rs->oinfo);
-	} else if (rs->resv == XFS_AG_RESV_AGFL) {
-		xrep_block_reap_binval(sc, fsbno);
+		if (error)
+			return error;
+
+		goto roll_out;
+	}
+
+	trace_xrep_dispose_free_extent(sc->sa.pag, agbno, 1);
+
+	xrep_block_reap_binval(sc, fsbno);
+
+	if (rs->resv == XFS_AG_RESV_AGFL) {
 		error = xrep_put_freelist(sc, agbno);
 	} else {
 		/*
@@ -219,7 +228,6 @@ xrep_reap_block(
 		 * every 100 or so EFIs so that we don't exceed the log
 		 * reservation.
 		 */
-		xrep_block_reap_binval(sc, fsbno);
 		__xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo, true);
 		rs->deferred++;
 		need_roll = rs->deferred > 100;
@@ -227,6 +235,7 @@ xrep_reap_block(
 	if (error || !need_roll)
 		return error;
 
+roll_out:
 	rs->deferred = 0;
 	return xrep_roll_ag_trans(sc);
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9c8c7dd0f262..71bfab3d2d29 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -729,9 +729,8 @@ TRACE_EVENT(xchk_refcount_incorrect,
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
 DECLARE_EVENT_CLASS(xrep_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(pag, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -739,8 +738,8 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -752,10 +751,10 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 );
 #define DEFINE_REPAIR_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
-DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_btree_extent);
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(pag, agbno, len))
+DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_unmap_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_free_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_rmap_class,

