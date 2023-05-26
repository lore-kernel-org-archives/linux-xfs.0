Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8277C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEZA5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjEZA5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE23719C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28FC4614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87483C433EF;
        Fri, 26 May 2023 00:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062638;
        bh=mwLkswMJYS9WSGD+A+ptBqkZ+tP/ohSdTAd1bspOlJE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kXYy2ZW+JpzguLHW5HCQsHT02jeenXCLgCyZE3GiNBFD5xi6ucNYpp+9X9KLag3a6
         8wX45dUrmOpl39ary6PGYHXWbAu7IgqjA8RsgJp6WIZ32gfUjHV20+EQ/WytCEDrqm
         qtQ+cMLMsXmNsXHi9Ei33IE7fqJtWSI2sGLvl+4qA4MKMsjpdqPlLL3pEQsL7X96Ei
         clcuwr2QOzAkqujzmn539/aMFKfxrLBYdeY5m9hvhqDlsmeyZInFq1eqvJKnvS0ZKR
         J9yJ3uU2fsZc1Mopi/5eui7GFK5Attms4093i0xLI6D+1FCY7QhTRSjsVoLMB4oedf
         tFHnW22wPVKyA==
Date:   Thu, 25 May 2023 17:57:18 -0700
Subject: [PATCH 1/7] xfs: stagger the starting AG of scrub iscans to reduce
 contention
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059856.3731102.10943785519968698066.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059833.3731102.13017065640910413459.stgit@frogsfrogsfrogs>
References: <168506059833.3731102.13017065640910413459.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Online directory and parent repairs on parent-pointer equipped
filesystems have shown that starting a large number of parallel iscans
causes a lot of AGI buffer contention.  Try to reduce this by making it
so that iscans scan wrap around the end of the filesystem, and using a
rotor to stagger where each scanner begins.  Surprisingly, this boosts
CPU utilization (on the author's test machines) from effectively
single-threaded to 160%.  Not great, but see the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/iscan.c |   87 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/iscan.h |    7 ++++
 fs/xfs/scrub/trace.h |    7 +++-
 3 files changed, 89 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 29feee70f69a..cbd98d55415c 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -183,10 +183,24 @@ xchk_iscan_move_cursor(
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
+	xfs_ino_t		cursor, visited;
+
+	BUILD_BUG_ON(XFS_MAXINUMBER == NULLFSINO);
+
+	/*
+	 * Special-case ino == 0 here so that we never set visited_ino to
+	 * NULLFSINO when wrapping around EOFS, for that will let through all
+	 * live updates.
+	 */
+	cursor = XFS_AGINO_TO_INO(mp, agno, agino);
+	if (cursor == 0)
+		visited = XFS_MAXINUMBER;
+	else
+		visited = cursor - 1;
 
 	mutex_lock(&iscan->lock);
-	iscan->cursor_ino = XFS_AGINO_TO_INO(mp, agno, agino);
-	iscan->__visited_ino = iscan->cursor_ino - 1;
+	iscan->cursor_ino = cursor;
+	iscan->__visited_ino = visited;
 	trace_xchk_iscan_move_cursor(iscan);
 	mutex_unlock(&iscan->lock);
 }
@@ -270,12 +284,13 @@ xchk_iscan_advance(
 		 * Did not find any more inodes in this AG, move on to the next
 		 * AG.
 		 */
-		xchk_iscan_move_cursor(iscan, ++agno, 0);
+		agno = (agno + 1) % mp->m_sb.sb_agcount;
+		xchk_iscan_move_cursor(iscan, agno, 0);
 		xfs_trans_brelse(sc->tp, agi_bp);
 		xfs_perag_put(pag);
 
 		trace_xchk_iscan_advance_ag(iscan);
-	} while (agno < mp->m_sb.sb_agcount);
+	} while (iscan->cursor_ino != iscan->scan_start_ino);
 
 	xchk_iscan_finish(iscan);
 	return 0;
@@ -433,6 +448,23 @@ xchk_iscan_teardown(
 	mutex_destroy(&iscan->lock);
 }
 
+/* Pick an AG from which to start a scan. */
+static inline xfs_ino_t
+xchk_iscan_rotor(
+	struct xfs_mount	*mp)
+{
+	static atomic_t		agi_rotor;
+	unsigned int		r = atomic_inc_return(&agi_rotor) - 1;
+
+	/*
+	 * Rotoring *backwards* through the AGs, so we add one here before
+	 * subtracting from the agcount to arrive at an AG number.
+	 */
+	r = (r % mp->m_sb.sb_agcount) + 1;
+
+	return XFS_AGINO_TO_INO(mp, mp->m_sb.sb_agcount - r, 0);
+}
+
 /*
  * Set ourselves up to start an inode scan.  If the @iget_timeout and
  * @iget_retry_delay parameters are set, the scan will try to iget each inode
@@ -447,15 +479,20 @@ xchk_iscan_start(
 	unsigned int		iget_retry_delay,
 	struct xchk_iscan	*iscan)
 {
+	xfs_ino_t		start_ino;
+
+	start_ino = xchk_iscan_rotor(sc->mp);
+
 	iscan->sc = sc;
 	clear_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
 	iscan->iget_timeout = iget_timeout;
 	iscan->iget_retry_delay = iget_retry_delay;
-	iscan->__visited_ino = 0;
-	iscan->cursor_ino = 0;
+	iscan->__visited_ino = start_ino;
+	iscan->cursor_ino = start_ino;
+	iscan->scan_start_ino = start_ino;
 	mutex_init(&iscan->lock);
 
-	trace_xchk_iscan_start(iscan);
+	trace_xchk_iscan_start(iscan, start_ino);
 }
 
 /*
@@ -484,15 +521,45 @@ xchk_iscan_want_live_update(
 	struct xchk_iscan	*iscan,
 	xfs_ino_t		ino)
 {
-        bool			ret;
+        bool			ret = false;
 
 	if (xchk_iscan_aborted(iscan))
 		return false;
 
 	mutex_lock(&iscan->lock);
+
 	trace_xchk_iscan_want_live_update(iscan, ino);
-	ret = iscan->__visited_ino >= ino;
+
+	/* Scan is finished, caller should receive all updates. */
+	if (iscan->__visited_ino == NULLFSINO) {
+		ret = true;
+		goto unlock;
+	}
+
+	/*
+	 * The visited cursor hasn't yet wrapped around the end of the FS.  If
+	 * @ino is inside the starred range, the caller should receive updates:
+	 *
+	 * 0 ------------ S ************ V ------------ EOFS
+	 */
+	if (iscan->scan_start_ino <= iscan->__visited_ino) {
+		if (ino >= iscan->scan_start_ino &&
+		    ino <= iscan->__visited_ino)
+			ret = true;
+
+		goto unlock;
+	}
+
+	/*
+	 * The visited cursor wrapped around the end of the FS.  If @ino is
+	 * inside the starred range, the caller should receive updates:
+	 *
+	 * 0 ************ V ------------ S ************ EOFS
+	 */
+	if (ino >= iscan->scan_start_ino || ino <= iscan->__visited_ino)
+		ret = true;
+
+unlock:
 	mutex_unlock(&iscan->lock);
-
 	return ret;
 }
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 5285ec43533e..d62aded8c3f6 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -12,6 +12,13 @@ struct xchk_iscan {
 	/* Lock to protect the scan cursor. */
 	struct mutex		lock;
 
+	/*
+	 * This is the first inode in the inumber address space that we
+	 * examined.  When the scan wraps around back to here, the scan is
+	 * finished.
+	 */
+	xfs_ino_t		scan_start_ino;
+
 	/* This is the inode that will be examined next. */
 	xfs_ino_t		cursor_ino;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7f3f9b7be458..b70f34e5c9bf 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1050,25 +1050,27 @@ DEFINE_EVENT(xchk_iscan_class, name, \
 DEFINE_ISCAN_EVENT(xchk_iscan_move_cursor);
 DEFINE_ISCAN_EVENT(xchk_iscan_visit);
 DEFINE_ISCAN_EVENT(xchk_iscan_advance_ag);
-DEFINE_ISCAN_EVENT(xchk_iscan_start);
 
 DECLARE_EVENT_CLASS(xchk_iscan_ino_class,
 	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino),
 	TP_ARGS(iscan, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_ino_t, startino)
 		__field(xfs_ino_t, cursor)
 		__field(xfs_ino_t, visited)
 		__field(xfs_ino_t, ino)
 	),
 	TP_fast_assign(
 		__entry->dev = iscan->sc->mp->m_super->s_dev;
+		__entry->startino = iscan->scan_start_ino;
 		__entry->cursor = iscan->cursor_ino;
 		__entry->visited = iscan->__visited_ino;
 		__entry->ino = ino;
 	),
-	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx ino 0x%llx",
+	TP_printk("dev %d:%d iscan start 0x%llx cursor 0x%llx visited 0x%llx ino 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->startino,
 		  __entry->cursor,
 		  __entry->visited,
 		  __entry->ino)
@@ -1078,6 +1080,7 @@ DEFINE_EVENT(xchk_iscan_ino_class, name, \
 	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino), \
 	TP_ARGS(iscan, ino))
 DEFINE_ISCAN_INO_EVENT(xchk_iscan_want_live_update);
+DEFINE_ISCAN_INO_EVENT(xchk_iscan_start);
 
 TRACE_EVENT(xchk_iscan_iget,
 	TP_PROTO(struct xchk_iscan *iscan, int error),

