Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A742CC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjBIWSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjBIWSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D115968AF8
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id mi9so3402579pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW6QoxTaVad+xIWNo2f9kj81F2R3zRpFtevl80nQBKU=;
        b=CXvfy4jGKFHTwMDeSu7+MmcATc5zZQMayrmelmiw/MpXid1XWfwbH55sxl1I7GnAwE
         ZUUcptip5bPBHMTqHcBAAN4KVw+MhtAJmDSCbve0YD4RUqULtt7rSbfblRKbhelpGeyZ
         xmfIqBtQpqsHqe/Asv2fFotXVgcGKsbHiZ4ytQJmfMlwHmyDCu36wIHimLy1KGOcNYC3
         s0f4r0UShT1lDwcEWZzcznnAmnmTAwvAhJDlBWSUeCgcsBwCko2t2OIa8oiGgpryq7B0
         JlajHTqWmcF83sR9px/YUBmz4oYlqdc/m0gji+Nm7qjTJWNkrYhXrHJg34iqrJ/SoGia
         NrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lW6QoxTaVad+xIWNo2f9kj81F2R3zRpFtevl80nQBKU=;
        b=C5d+vqw/9IsvpH7jG1MQJC1bbTZTgRVmeh8cW/434viE2WDJXlI2tT48F+tEPhH3Q6
         /WJkHK/5cSqMF2WvcGF8nXEkSyB5w0XWDVitACV8kHDrvKkjSURPuwMsCRRzOy400zjt
         wmy3z2x/acZwXz6cQTdCCqtzseYbw3cJLpg+AQjHuaGcGVKs6OfGDjVQHlbKCg076y66
         IwOrjn0G2oedv14ZlS6mWEmKWS0WcPU7X/MtwEk2oc+4V74oLWZH5cgkNBTBZUabl0qW
         0kvRerF0BQbweFpD/tRhWnG3XXJ2lZjnQDs6JlqrCQUf98ah6ja7OxpQnBviPKlE3f82
         UtmA==
X-Gm-Message-State: AO0yUKUxF3SNs6lr+AEtt7ygabhFOli7/EYb4co4GnxhG64v5Dn5E78n
        +rP37nVA6h+5xkTSn2fOcrkGnV2ZepmV+uts
X-Google-Smtp-Source: AK7set+OqNplL39HUGYlBfeHnHb+q1vDZjPS3cu3uDZlg2L+mx0P4l3dgRkeYLf3BzwGUMZmRrnulA==
X-Received: by 2002:a17:903:284:b0:198:def1:62cc with SMTP id j4-20020a170903028400b00198def162ccmr12491206plr.2.1675981117854;
        Thu, 09 Feb 2023 14:18:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id ju1-20020a170903428100b00194c82c2a7bsm1983136plb.224.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVV-Et
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNg-1S
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/42] xfs: introduce xfs_alloc_vextent_near_bno()
Date:   Fri, 10 Feb 2023 09:18:05 +1100
Message-Id: <20230209221825.3722244-23-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The remaining callers of xfs_alloc_vextent() are all doing NEAR_BNO
allocations. We can replace that function with a new
xfs_alloc_vextent_near_bno() function that does this explicitly.

We also multiplex NEAR_BNO allocations through
xfs_alloc_vextent_this_ag via args->type. Replace all of these with
direct calls to xfs_alloc_vextent_near_bno(), too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 50 ++++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h          | 14 ++++-----
 fs/xfs/libxfs/xfs_bmap.c           |  6 ++--
 fs/xfs/libxfs/xfs_ialloc.c         | 27 ++++++----------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  5 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |  7 ++---
 6 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 008b3622b286..85e3b65286ac 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3479,35 +3479,47 @@ xfs_alloc_vextent_first_ag(
 }
 
 /*
- * Allocate an extent (variable-size).
- * Depending on the allocation type, we either look in a single allocation
- * group or loop over the allocation groups to find the result.
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
  */
 int
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)
+xfs_alloc_vextent_near_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_fsblock_t		target)
 {
+	struct xfs_mount	*mp = args->mp;
+	bool			need_pag = !args->pag;
 	xfs_agnumber_t		minimum_agno = 0;
 	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
 		minimum_agno = args->tp->t_highest_agno;
 
-	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		args->pag = xfs_perag_get(args->mp,
-				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-		error = xfs_alloc_vextent_this_ag(args);
+	error = xfs_alloc_vextent_check_args(args, target);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	if (minimum_agno > args->agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		return 0;
+	}
+
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if (need_pag)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+	error = xfs_alloc_ag_vextent(args);
+	if (need_pag)
 		xfs_perag_put(args->pag);
-		break;
-	default:
-		error = -EFSCORRUPTED;
-		ASSERT(0);
-		break;
-	}
-	return error;
+	if (error)
+		return error;
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+	return 0;
 }
 
 /* Ensure that the freelist is at full capacity. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 80e2c16f4cde..45a428e770f0 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -113,19 +113,19 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
-/*
- * Allocate an extent (variable-size).
- */
-int				/* error */
-xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args);	/* allocation argument structure */
-
 /*
  * Allocate an extent in the specific AG defined by args->fsbno. If there is no
  * space in that AG, then the allocation will fail.
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
+ */
+int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
+		xfs_fsblock_t target);
+
 /*
  * Best effort full filesystem allocation scan.
  *
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 94826f35fdae..da5809d3d004 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3246,7 +3246,6 @@ xfs_bmap_btalloc_filestreams(
 	int			notinit = 0;
 	int			error;
 
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
 	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
@@ -3565,7 +3564,7 @@ xfs_bmap_btalloc_at_eof(
 	}
 
 	if (ag_only)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
@@ -3612,7 +3611,6 @@ xfs_bmap_btalloc_best_length(
 		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 	}
 	xfs_bmap_adjacent(ap);
-	args->fsbno = ap->blkno;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
@@ -3653,7 +3651,7 @@ xfs_bmap_btalloc_best_length(
 	}
 
 	if (is_filestream)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 74ad88853a8c..b85f038de9e3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -717,23 +717,17 @@ xfs_ialloc_ag_alloc(
 			isaligned = 1;
 		} else
 			args.alignment = igeo->cluster_align;
-		/*
-		 * Need to figure out where to allocate the inode blocks.
-		 * Ideally they should be spaced out through the a.g.
-		 * For now, just allocate blocks up front.
-		 */
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.prod = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
 		args.minleft = igeo->inobt_maxlevels;
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -743,11 +737,11 @@ xfs_ialloc_ag_alloc(
 	 * alignment.
 	 */
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = igeo->cluster_align;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
+		if (error)
 			return error;
 	}
 
@@ -759,9 +753,6 @@ xfs_ialloc_ag_alloc(
 	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
@@ -783,7 +774,9 @@ xfs_ialloc_ag_alloc(
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fa6cd2502970..9b28211d5a4c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -105,14 +105,13 @@ __xfs_inobt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index a980fb18bde2..f3b860970b26 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -68,14 +68,13 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
+					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-- 
2.39.0

