Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9644C636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBIWSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBIWSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:40 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEDB68AF3
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:38 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v18-20020a17090ae99200b00230f079dcd9so6727998pjy.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXVI6oKAPThf0wSiSnMht0N69W8A74r3lsZbcS5UkSY=;
        b=7O38VE/DDF+AiBruc53wK/0MwFUKWuND1W471g9anTdx1YwJ3U+SCfrgk6wPnEwENn
         DgOyAT/TT1axR1gCCcxCFbhuueSuEQx8NRfDM/U09OhwROQ8R3McMuJtuAv/hv/xGcCS
         HiXY41My5kwpJq4nU1FqX4bnYbM3Dk9VGZcAdttmL3Nk6+E/0dxgTXGUjNZAM6JNjdsA
         VzzVzC7Co9k8PmbC3ZNOX0tq9xZr22mn6vDSw4o++lMaJf6EatkqSeg32O6eNGIppk8R
         cp/9ObNRO2MxRQaYjd96EqgY4k5LuLHc0AQzVH2iJpA/49DpCGkjkMrdY/onrE0JSNMD
         LQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eXVI6oKAPThf0wSiSnMht0N69W8A74r3lsZbcS5UkSY=;
        b=8NTT7ht+QHQFZGH4oBbmnAj4vZyQVkctZIEk+8NNh0D6BgUc8bqUbKyTBqCxgaeN87
         p35jvim3BK5lxZx8iDIt/feHHA3Sg6qLkxBqK21oIs/RZtFS6CXhYZ3HIHmfJzNn5EUI
         1Jg3KsGrFM/hvqq/VYdrfgT6JqP2XUC8jk8R0qDLaQDaFSzrHLh98Y/SuVbDCkhGzWxX
         /NE8lMfXV678Zr1z4sNzPLcTgMBTWJIk5CKT8qi3uo2OgR30yCk5sMlXl9t9bCf7WFa+
         W5ySTejuoj0dbRNTT/0Vf27GPluz2pKuI3+QEy2q6AelkVwpyREg0pRuMLMrHJTPAvVt
         yx+g==
X-Gm-Message-State: AO0yUKWivz4qvNUCc/cG9mLSj02qmVNnJFJElG0lQ3SczJQmL78T/sOF
        NEtUc8/yZFgh+GHaX3qTUFbjU5eWTNjgfPHN
X-Google-Smtp-Source: AK7set8MplcpPpf5JcBC808A0kjzkAljaxHgXAcJ4tr4NS7F10ZwJvNQ4mGvLu/DbX5eKqnhAY4wHg==
X-Received: by 2002:a05:6a20:d04f:b0:bc:c663:41b6 with SMTP id hv15-20020a056a20d04f00b000bcc66341b6mr12143235pzb.28.1675981118424;
        Thu, 09 Feb 2023 14:18:38 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id x5-20020a654145000000b004a737a6e62fsm1754488pgp.14.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVS-E0
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNb-1M
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/42] xfs: use xfs_alloc_vextent_start_bno() where appropriate
Date:   Fri, 10 Feb 2023 09:18:04 +1100
Message-Id: <20230209221825.3722244-22-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change obvious callers of single AG allocation to use
xfs_alloc_vextent_start_bno(). Callers no long need to specify
XFS_ALLOCTYPE_START_BNO, and so the type can be driven inward and
removed.

While doing this, also pass the allocation target fsb as a parameter
rather than encoding it in args->fsbno.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 24 ++++++++++---------
 fs/xfs/libxfs/xfs_alloc.h      | 13 ++++++++--
 fs/xfs/libxfs/xfs_bmap.c       | 43 ++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_bmap_btree.c |  9 ++-----
 4 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index bd77e645398b..008b3622b286 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3189,7 +3189,6 @@ xfs_alloc_vextent_check_args(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
 
-	args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
 
 	/*
@@ -3345,7 +3344,7 @@ xfs_alloc_vextent_iterate_ags(
 		trace_xfs_alloc_vextent_loopfailed(args);
 
 		if (args->agno == start_agno &&
-		    args->otype == XFS_ALLOCTYPE_START_BNO)
+		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 
 		/*
@@ -3373,7 +3372,7 @@ xfs_alloc_vextent_iterate_ags(
 			}
 
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
+			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
 				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 			}
@@ -3396,18 +3395,22 @@ xfs_alloc_vextent_iterate_ags(
  * otherwise will wrap back to the start AG and run a second blocking pass to
  * the end of the filesystem.
  */
-static int
+int
 xfs_alloc_vextent_start_ag(
 	struct xfs_alloc_arg	*args,
-	xfs_agnumber_t		minimum_agno)
+	xfs_fsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		minimum_agno = 0;
 	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args, args->fsbno);
+	if (args->tp->t_highest_agno != NULLAGNUMBER)
+		minimum_agno = args->tp->t_highest_agno;
+
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3416,14 +3419,15 @@ xfs_alloc_vextent_start_ag(
 
 	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
 	    xfs_is_inode32(mp)) {
-		args->fsbno = XFS_AGB_TO_FSB(mp,
+		target = XFS_AGB_TO_FSB(mp,
 				((mp->m_agfrotor / rotorstep) %
 				mp->m_sb.sb_agcount), 0);
 		bump_rotor = 1;
 	}
-	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->fsbno = target;
 
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
 			XFS_ALLOC_FLAG_TRYLOCK);
@@ -3498,8 +3502,6 @@ xfs_alloc_vextent(
 		error = xfs_alloc_vextent_this_ag(args);
 		xfs_perag_put(args->pag);
 		break;
-	case XFS_ALLOCTYPE_START_BNO:
-		return xfs_alloc_vextent_start_ag(args, minimum_agno);
 	default:
 		error = -EFSCORRUPTED;
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 9be46f493340..80e2c16f4cde 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -20,7 +20,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
-#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
 #define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
 
@@ -29,7 +28,6 @@ typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
-	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
 	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
 
@@ -128,6 +126,17 @@ xfs_alloc_vextent(
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Best effort full filesystem allocation scan.
+ *
+ * Locality aware allocation will be attempted in the initial AG, but on failure
+ * non-localised attempts will be made. The AGs are constrained by previous
+ * allocations in the current transaction. Two passes will be made - the first
+ * non-blocking, the second blocking.
+ */
+int xfs_alloc_vextent_start_ag(struct xfs_alloc_arg *args,
+		xfs_fsblock_t target);
+
 /*
  * Iterate from the AG indicated from args->fsbno through to the end of the
  * filesystem attempting blocking allocation. This is for use in last
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index efca40fea8f1..94826f35fdae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -646,12 +646,11 @@ xfs_bmap_extents_to_btree(
 	args.mp = mp;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 
-	args.type = XFS_ALLOCTYPE_START_BNO;
-	args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args,
+				XFS_INO_TO_FSB(mp, ip->i_ino));
 	if (error)
 		goto out_root_realloc;
 
@@ -792,15 +791,15 @@ xfs_bmap_local_to_extents(
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+
 	/*
 	 * Allocate a block.  We know we need only one, since the
 	 * file currently fits in an inode.
 	 */
-	args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-	args.type = XFS_ALLOCTYPE_START_BNO;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args,
+			XFS_INO_TO_FSB(args.mp, ip->i_ino));
 	if (error)
 		goto done;
 
@@ -3208,7 +3207,6 @@ xfs_bmap_btalloc_select_lengths(
 	int			notinit = 0;
 	int			error = 0;
 
-	args->type = XFS_ALLOCTYPE_START_BNO;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		args->total = ap->minlen;
 		args->minlen = ap->minlen;
@@ -3500,7 +3498,8 @@ xfs_bmap_btalloc_at_eof(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
-	int			stripe_align)
+	int			stripe_align,
+	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_alloctype_t		atype;
@@ -3565,7 +3564,10 @@ xfs_bmap_btalloc_at_eof(
 		args->minalignslop = 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (ag_only)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3591,13 +3593,17 @@ xfs_bmap_btalloc_best_length(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		blen = 0;
+	bool			is_filestream = false;
 	int			error;
 
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		is_filestream = true;
+
 	/*
 	 * Determine the initial block number we will target for allocation.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip)) {
+	if (is_filestream) {
 		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
 		if (agno == NULLAGNUMBER)
 			agno = 0;
@@ -3613,8 +3619,7 @@ xfs_bmap_btalloc_best_length(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip)) {
+	if (is_filestream) {
 		/*
 		 * If there is very little free space before we start a
 		 * filestreams allocation, we're almost guaranteed to fail to
@@ -3639,14 +3644,18 @@ xfs_bmap_btalloc_best_length(
 	 * trying.
 	 */
 	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
+				is_filestream);
 		if (error)
 			return error;
 		if (args->fsbno != NULLFSBLOCK)
 			return 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (is_filestream)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 	if (args->fsbno != NULLFSBLOCK)
@@ -3658,9 +3667,7 @@ xfs_bmap_btalloc_best_length(
 	 */
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
-		args->type = XFS_ALLOCTYPE_START_BNO;
-		args->fsbno = ap->blkno;
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d42c1a1da1fc..b8ad95050c9b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -214,9 +214,6 @@ xfs_bmbt_alloc_block(
 	if (!args.wasdel && args.tp->t_blk_res == 0)
 		return -ENOSPC;
 
-	args.fsbno = be64_to_cpu(start->l);
-	args.type = XFS_ALLOCTYPE_START_BNO;
-
 	/*
 	 * If we are coming here from something like unwritten extent
 	 * conversion, there has been no data extent allocation already done, so
@@ -227,7 +224,7 @@ xfs_bmbt_alloc_block(
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
 					cur->bc_ino.whichfork);
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
 	if (error)
 		return error;
 
@@ -237,10 +234,8 @@ xfs_bmbt_alloc_block(
 		 * a full btree split.  Try again and if
 		 * successful activate the lowspace algorithm.
 		 */
-		args.fsbno = 0;
 		args.minleft = 0;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args, 0);
 		if (error)
 			return error;
 		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
-- 
2.39.0

