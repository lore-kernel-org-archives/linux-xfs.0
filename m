Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE5DC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjARWpW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A161D4A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so49746pjb.4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Wk19nqjItmb7/nEJAS5MYPkA5nXbup5O1XuVw11F1k=;
        b=QqeBT803qiNQhdgXUBJKL4dnWBe8OX/wiz+LhC7hyau42oPv7BLKH4J1qEyuLfakjQ
         KtgIkA3OAETQXg37Um2LAqEngRzXDSsiHfjlXHXY+PgP+JZjMw2hOh3CvN9jPEXDIlyK
         Ozl+h+nhqY5eIHijlTX+iBtvPPTsjfKsyJTk2NuiVR2jpotSb/VesHs1vGMwlyUXN8Br
         WKdfLo1o/3rK7MSvjCb3XFKZ+wF2GHv4BRJy1Ah1tEdBb6x3Tq1I7ll2saPLN4Zlrjjm
         EoPmCTZMnSQMfOXor+dRy7tijgW+RQTOPZFVZeOlDo0Mm2ZdbLqE2Hd9oBgqhLa+V1P7
         OG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Wk19nqjItmb7/nEJAS5MYPkA5nXbup5O1XuVw11F1k=;
        b=pHC0/tXDrMCcwcOj4wB/WHYzVdIGpVMvfJ0eDVVmRBhfkMYtCDGFBKu4+a2DU2f4pK
         IdALqaPP6jf0ov3ObLObsHPbs3WCDZolyyHi9Gx0ZW9p00FjC46y4Gd11m+gLIgG7GTs
         q48TZAGS3+X+ud/sGUSC9HsMN85GsozUOGmdCQMVmgPLCTTum426JS7ACw/Y6cFgx6wA
         Jt28iOk7OJu0bU/PRl62Ob8oD85/tdFqILdhVxm6ioegTQ9rCscQonUytT/6SeMyzcKb
         NW+6IX6C9J1FEQbJbtHry0wylhM9HIYqJ5Q6K43yqSds+N6W7bbIkicTXn7xWgexFstq
         6DTA==
X-Gm-Message-State: AFqh2kpWYjbe7RSasoosMuNMXPOwQhc13Wn84/rA/5cDWxjM+HeULhql
        7cULt6y1AKRNjyvTpRKfScHhVouuFJ3XKrId
X-Google-Smtp-Source: AMrXdXsfOS1t++iEyld62MIyDAdlYGFc8Xthg2EnTsbW7+uCR67FrKQYElb/j8OxhTuCwd8oiNr0Xw==
X-Received: by 2002:a17:902:7088:b0:192:52d7:b574 with SMTP id z8-20020a170902708800b0019252d7b574mr8647272plk.63.1674081914036;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902d2ce00b00192fe452e17sm6195719plc.162.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWm-UH
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCt-32
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/42] xfs: t_firstblock is tracking AGs not blocks
Date:   Thu, 19 Jan 2023 09:44:28 +1100
Message-Id: <20230118224505.1964941-6-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The tp->t_firstblock field is now raelly tracking the highest AG we
have locked, not the block number of the highest allocation we've
made. It's purpose is to prevent AGF locking deadlocks, so rename it
to "highest AG" and simplify the implementation to just track the
agno rather than a fsbno.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 12 +++++-------
 fs/xfs/libxfs/xfs_bmap.c       |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c |  6 +++---
 fs/xfs/xfs_bmap_util.c         |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_reflink.c           |  2 +-
 fs/xfs/xfs_trace.h             |  8 ++++----
 fs/xfs/xfs_trans.c             |  4 ++--
 fs/xfs/xfs_trans.h             |  2 +-
 9 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c2f38f595d7f..9f26a9368eeb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3169,8 +3169,8 @@ xfs_alloc_vextent(
 	mp = args->mp;
 	type = args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
-	if (args->tp->t_firstblock != NULLFSBLOCK)
-		minimum_agno = XFS_FSB_TO_AGNO(mp, args->tp->t_firstblock);
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3375,11 +3375,9 @@ xfs_alloc_vextent(
 	 * deadlocks.
 	 */
 	if (args->agbp &&
-	    (args->tp->t_firstblock == NULLFSBLOCK ||
-	     args->pag->pag_agno > minimum_agno)) {
-		args->tp->t_firstblock = XFS_AGB_TO_FSB(mp,
-					args->pag->pag_agno, 0);
-	}
+	    (args->tp->t_highest_agno == NULLAGNUMBER ||
+	     args->pag->pag_agno > minimum_agno))
+		args->tp->t_highest_agno = args->pag->pag_agno;
 	xfs_perag_put(args->pag);
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bc566aae4246..f15d45af661f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4192,7 +4192,7 @@ xfs_bmapi_minleft(
 {
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, fork);
 
-	if (tp && tp->t_firstblock != NULLFSBLOCK)
+	if (tp && tp->t_highest_agno != NULLAGNUMBER)
 		return 0;
 	if (ifp->if_format != XFS_DINODE_FMT_BTREE)
 		return 1;
@@ -6084,7 +6084,7 @@ xfs_bmap_finish_one(
 {
 	int				error = 0;
 
-	ASSERT(tp->t_firstblock == NULLFSBLOCK);
+	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 76a0f0d260a4..afd9b2d962a3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -184,11 +184,11 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*src,
 	struct xfs_btree_cur	*dst)
 {
-	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
+	ASSERT((dst->bc_tp->t_highest_agno != NULLAGNUMBER) ||
 	       (dst->bc_ino.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
 	dst->bc_ino.allocated += src->bc_ino.allocated;
-	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
+	dst->bc_tp->t_highest_agno = src->bc_tp->t_highest_agno;
 
 	src->bc_ino.allocated = 0;
 }
@@ -218,7 +218,7 @@ xfs_bmbt_alloc_block(
 	 * we have to ensure that we attempt to locate the entire set of bmbt
 	 * allocations in the same AG, as xfs_bmapi_write() would have reserved.
 	 */
-	if (cur->bc_tp->t_firstblock == NULLFSBLOCK)
+	if (cur->bc_tp->t_highest_agno == NULLAGNUMBER)
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
 					cur->bc_ino.whichfork);
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 867645b74d88..a09dd2606479 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1410,7 +1410,7 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
-			ASSERT(tp->t_firstblock == NULLFSBLOCK);
+			ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..dbe274b8065d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1367,7 +1367,7 @@ xfs_itruncate_extents_flags(
 
 	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
 	while (unmap_len > 0) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
+		ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
 				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5535778a98f9..57bf59ff4854 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -610,7 +610,7 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
+			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
 			/* Free the CoW orphan record. */
 			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 918e778fdd55..7dc57db6aa42 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1801,7 +1801,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(char, wasfromfl)
 		__field(int, resv)
 		__field(int, datatype)
-		__field(xfs_fsblock_t, firstblock)
+		__field(xfs_agnumber_t, highest_agno)
 	),
 	TP_fast_assign(
 		__entry->dev = args->mp->m_super->s_dev;
@@ -1822,12 +1822,12 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->wasfromfl = args->wasfromfl;
 		__entry->resv = args->resv;
 		__entry->datatype = args->datatype;
-		__entry->firstblock = args->tp->t_firstblock;
+		__entry->highest_agno = args->tp->t_highest_agno;
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
 		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
-		  "datatype 0x%x firstblock 0x%llx",
+		  "datatype 0x%x highest_agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1846,7 +1846,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->wasfromfl,
 		  __entry->resv,
 		  __entry->datatype,
-		  (unsigned long long)__entry->firstblock)
+		  __entry->highest_agno)
 )
 
 #define DEFINE_ALLOC_EVENT(name) \
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..53ab544e4c2c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -102,7 +102,7 @@ xfs_trans_dup(
 	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
 	INIT_LIST_HEAD(&ntp->t_dfops);
-	ntp->t_firstblock = NULLFSBLOCK;
+	ntp->t_highest_agno = NULLAGNUMBER;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(tp->t_ticket != NULL);
@@ -278,7 +278,7 @@ xfs_trans_alloc(
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
 	INIT_LIST_HEAD(&tp->t_dfops);
-	tp->t_firstblock = NULLFSBLOCK;
+	tp->t_highest_agno = NULLAGNUMBER;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 55819785941c..6e3646d524ce 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -132,7 +132,7 @@ typedef struct xfs_trans {
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
 	unsigned int		t_flags;	/* misc flags */
-	xfs_fsblock_t		t_firstblock;	/* first block allocated */
+	xfs_agnumber_t		t_highest_agno;	/* highest AGF locked */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-- 
2.39.0

