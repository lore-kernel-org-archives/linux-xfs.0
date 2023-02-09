Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790CEC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjBIWSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBIWSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89BA28D11
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so3732337pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dbB1rbTnaWrcSzZ3zBIabywB7zRjNiS7DfAARS5ZEmQ=;
        b=EQfWMA7v0WBGxB4Xxieu10KmIGv4BYGB4dgi0kXGQM73dd2IiKixJEuR4OCNIeOGJk
         xgzKaPDmULJe62xPUOCaWUCIQl0MJIV2Wqc6evUTXhWIVv237hqyehVjQjb3ajvGWtC5
         cfNPr1iSOzT3MqRBL1KYcB/YBJb4yve9kKljXw3OBPyeOVRpgEUvkidlr9EVSA6U2iIs
         pmuVqloLVwozJGmbpCzYG4SEdD+6cz+japOeJeZs64UQ9rlLZ6sX0IFpl2MOZb5k+Ztj
         e+SyQLtdOdVk9gGIRHkkPfDT+/u+UEzlEgjZ1quG585/06fh/lbtg+yqTmkQw2wk7vys
         ws2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbB1rbTnaWrcSzZ3zBIabywB7zRjNiS7DfAARS5ZEmQ=;
        b=ic1VMBRgMI8ITaokiFEeTmJaGbI61w7BuDZRiXwu6OsDE9E4VfRImHZpwWWQ9lAiUb
         tJRuKcA0CUyyPM5BIPz+gFLMHCmp1rCGmzGaLlFOcFTjhODlprpigINIZ2SY7BUQtMWG
         KJRW1oCdO09/akrChic8+hzK6/9E7o3oNSnaWKdGVD0WSz1B4u16Xf9QwtzjOpGsIost
         5u7zAvKrMmNHWRBUOYTF6+V8FWd/r07Kevrf1Sh6OYZkjCTnGhj4YiINsqOZCwVLrqtG
         dyEf8elwoFLGg+f4kzQOFolFKiCuzGGLFh1ekJlOwmOcwT9H52IgvDVV86ILPZRvpmjr
         xOMw==
X-Gm-Message-State: AO0yUKWkT38NJJTXlHD8Ma6M28WdVBAFv9SyRWBaOD8NQ+FvIXk5XO0V
        RLeDM7E+BFmIh1+u12slUyccf/ldc2TSJoci
X-Google-Smtp-Source: AK7set/gUMlwIFeNaj8cL53m46C32PohRXOangB3bWlCYB79ymjbYg3moHlzIgkGEAQmAvcVJG/4uA==
X-Received: by 2002:a17:902:ced1:b0:19a:593c:f385 with SMTP id d17-20020a170902ced100b0019a593cf385mr4639293plg.25.1675981113137;
        Thu, 09 Feb 2023 14:18:33 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id io16-20020a17090312d000b001960706141fsm2005164plb.149.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFL-00DOUs-VF
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:27 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFL-00FcMG-36
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/42] xfs: t_firstblock is tracking AGs not blocks
Date:   Fri, 10 Feb 2023 09:17:48 +1100
Message-Id: <20230209221825.3722244-6-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      | 12 +++++-------
 fs/xfs/libxfs/xfs_bmap.c       |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c |  6 +++---
 fs/xfs/libxfs/xfs_btree.c      |  2 +-
 fs/xfs/xfs_bmap_util.c         |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_reflink.c           |  2 +-
 fs/xfs/xfs_trace.h             |  8 ++++----
 fs/xfs/xfs_trans.c             |  4 ++--
 fs/xfs/xfs_trans.h             |  2 +-
 10 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffe6345bfafc..974b23abca60 100644
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
index 31a0738d017e..504fd69fe2c6 100644
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
@@ -6079,7 +6079,7 @@ xfs_bmap_finish_one(
 	struct xfs_bmbt_irec		*bmap = &bi->bi_bmap;
 	int				error = 0;
 
-	ASSERT(tp->t_firstblock == NULLFSBLOCK);
+	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
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
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index da8c769887fd..c4649cc624e1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2943,7 +2943,7 @@ xfs_btree_split(
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
-	    cur->bc_tp->t_firstblock == NULLFSBLOCK)
+	    cur->bc_tp->t_highest_agno == NULLAGNUMBER)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
 	args.cur = cur;
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
index adddaeb44a56..2ac98d8ddbfd 100644
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

