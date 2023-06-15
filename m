Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3A9EB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 01:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbjFOBmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbjFOBmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 21:42:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A6CEC
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6667a2c1ab3so783440b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686793334; x=1689385334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHNNtvZvApIEtSZH9jx/J6VSPZi6k2X6ff6YOORCcZc=;
        b=NUWd+/2pF9UG/gMxxMLo6BSQlpP/re/flAZ7vMMJfdezu+WVeK4qZaB0cqXewa643t
         eSokWQxEzOLJXS2jcymASCD0TT2gFiJ6JGVqgcAnpvSSTv4j9e3vp1eTb//2hLd501L+
         b7q9JFRWDRuxTzsHJEKFqbNF4anbQ0sC5OZHCNf9Ay4Sv+K6WbLvdkdGfMf0x3sJVcfC
         GFQiATUKRZ4QuhAgvrvlda3U8a14Q0TxEEqOlxuzlUV0754SrfM2ek8BfYGIDzbZpUJs
         14Pl5P6H2tJPv8MyWXQB4XjMldCe6Dtl+WcB0reAFQhwStUD9XxxWfyewSfZggRu88SA
         rL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793334; x=1689385334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHNNtvZvApIEtSZH9jx/J6VSPZi6k2X6ff6YOORCcZc=;
        b=lDGzifuc+jhumDl/ZicHIvqwklmRMVQtNzinHjJx5GEfZZhS4me+MQxZy9lhqhPvdF
         M7GqA1q3zQ2Upacj1Wcu69JuACSN8qBn+sf6PuPVMGgUGr/mhYxh7pyea6LJNJJJnXr9
         Xt8ofk2t8d/lYZp5Cq1hzSBP9VndcpDj/UPICBisSVXcV5aULvGuOPvUPuLh9rBgT2kC
         qU1jXO2+L0v6da0bhOzZ8/zlDdg+Wjse4uNrJeFia9Yj/8fWGgehZAOZK1x0kNT994d7
         8iynPlCQKCq+ZMrlN+hakF58AY6smEqIpPUxXWndOXqO1DfHScOf97GCZDbnxHsHKu0P
         83tQ==
X-Gm-Message-State: AC+VfDxb5vAHJe8iTR2q5sLq/60gpCqh2Ti+BlPc1n1UoVBJCv1OhTTs
        jdgWsHvmg8y6unKg2E7yFm/bYeLl6pXkHdiJ5Gs=
X-Google-Smtp-Source: ACHHUZ499V3sw2ne5KvqZ/VLO/ecz2qk5q7ne8niImgsIpV4HSDtbuwfiNNHRpTvQZ6GIUbTJgwg5A==
X-Received: by 2002:a05:6a00:8cc:b0:64f:4019:ec5b with SMTP id s12-20020a056a0008cc00b0064f4019ec5bmr4758990pfu.7.1686793334488;
        Wed, 14 Jun 2023 18:42:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id x1-20020a056a00270100b005a8173829d5sm5517821pfv.66.2023.06.14.18.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:42:13 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q9c01-00BtRd-2v;
        Thu, 15 Jun 2023 11:42:09 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q9c01-00Dklv-1s;
        Thu, 15 Jun 2023 11:42:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     chandanrlinux@gmail.com, wen.gang.wang@oracle.com
Subject: [PATCH 1/3] xfs: pass alloc flags through to xfs_extent_busy_flush()
Date:   Thu, 15 Jun 2023 11:41:59 +1000
Message-Id: <20230615014201.3171380-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615014201.3171380-1-david@fromorbit.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To avoid blocking in xfs_extent_busy_flush() when freeing extents
and the only busy extents are held by the current transaction, we
need to pass the XFS_ALLOC_FLAG_FREEING flag context all the way
into xfs_extent_busy_flush().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_alloc.h |  2 +-
 fs/xfs/xfs_extent_busy.c  |  3 +-
 fs/xfs/xfs_extent_busy.h  |  2 +-
 4 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c20fe99405d8..11bd0a1756a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
  */
 STATIC int
 xfs_alloc_ag_vextent_near(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	uint32_t		alloc_flags)
 {
 	struct xfs_alloc_cur	acur = {};
 	int			error;		/* error code */
@@ -1612,7 +1613,7 @@ xfs_alloc_ag_vextent_near(
 		if (acur.busy) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag,
-					      acur.busy_gen);
+					      acur.busy_gen, alloc_flags);
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
@@ -1635,21 +1636,22 @@ xfs_alloc_ag_vextent_near(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int				/* error */
+static int
 xfs_alloc_ag_vextent_size(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args,
+	uint32_t		alloc_flags)
 {
-	struct xfs_agf	*agf = args->agbp->b_addr;
-	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
-	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
-	int		error;		/* error result */
-	xfs_agblock_t	fbno;		/* start of found freespace */
-	xfs_extlen_t	flen;		/* length of found freespace */
-	int		i;		/* temp status variable */
-	xfs_agblock_t	rbno;		/* returned block number */
-	xfs_extlen_t	rlen;		/* length of returned extent */
-	bool		busy;
-	unsigned	busy_gen;
+	struct xfs_agf		*agf = args->agbp->b_addr;
+	struct xfs_btree_cur	*bno_cur;
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;		/* start of found freespace */
+	xfs_extlen_t		flen;		/* length of found freespace */
+	xfs_agblock_t		rbno;		/* returned block number */
+	xfs_extlen_t		rlen;		/* length of returned extent */
+	bool			busy;
+	unsigned		busy_gen;
+	int			error;
+	int			i;
 
 restart:
 	/*
@@ -1717,8 +1719,8 @@ xfs_alloc_ag_vextent_size(
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
-				xfs_extent_busy_flush(args->mp,
-							args->pag, busy_gen);
+				xfs_extent_busy_flush(args->mp, args->pag,
+						busy_gen, alloc_flags);
 				goto restart;
 			}
 		}
@@ -1802,7 +1804,8 @@ xfs_alloc_ag_vextent_size(
 		if (busy) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
+			xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
+					alloc_flags);
 			goto restart;
 		}
 		goto out_nominleft;
@@ -2568,7 +2571,7 @@ xfs_exact_minlen_extent_available(
 int			/* error */
 xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	int			flags)	/* XFS_ALLOC_FLAG_... */
+	uint32_t		alloc_flags)
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag = args->pag;
@@ -2584,7 +2587,7 @@ xfs_alloc_fix_freelist(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	if (!xfs_perag_initialised_agf(pag)) {
-		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2600,13 +2603,13 @@ xfs_alloc_fix_freelist(
 	 */
 	if (xfs_perag_prefers_metadata(pag) &&
 	    (args->datatype & XFS_ALLOC_USERDATA) &&
-	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
-		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+	    (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)) {
+		ASSERT(!(alloc_flags & XFS_ALLOC_FLAG_FREEING));
 		goto out_agbp_relse;
 	}
 
 	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, flags |
+	if (!xfs_alloc_space_available(args, need, alloc_flags |
 			XFS_ALLOC_FLAG_CHECK))
 		goto out_agbp_relse;
 
@@ -2615,7 +2618,7 @@ xfs_alloc_fix_freelist(
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
 	if (!agbp) {
-		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2630,7 +2633,7 @@ xfs_alloc_fix_freelist(
 
 	/* If there isn't enough total space or single-extent, reject it. */
 	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, flags))
+	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
 #ifdef DEBUG
@@ -2668,11 +2671,12 @@ xfs_alloc_fix_freelist(
 	 */
 	memset(&targs, 0, sizeof(targs));
 	/* struct copy below */
-	if (flags & XFS_ALLOC_FLAG_NORMAP)
+	if (alloc_flags & XFS_ALLOC_FLAG_NORMAP)
 		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	else
 		targs.oinfo = XFS_RMAP_OINFO_AG;
-	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
+	while (!(alloc_flags & XFS_ALLOC_FLAG_NOSHRINK) &&
+			pag->pagf_flcount > need) {
 		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
@@ -2700,7 +2704,7 @@ xfs_alloc_fix_freelist(
 		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
-		error = xfs_alloc_ag_vextent_size(&targs);
+		error = xfs_alloc_ag_vextent_size(&targs, alloc_flags);
 		if (error)
 			goto out_agflbp_relse;
 
@@ -2710,7 +2714,7 @@ xfs_alloc_fix_freelist(
 		 * on a completely full ag.
 		 */
 		if (targs.agbno == NULLAGBLOCK) {
-			if (flags & XFS_ALLOC_FLAG_FREEING)
+			if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
 				break;
 			goto out_agflbp_relse;
 		}
@@ -3226,7 +3230,7 @@ xfs_alloc_vextent_check_args(
 static int
 xfs_alloc_vextent_prepare_ag(
 	struct xfs_alloc_arg	*args,
-	uint32_t		flags)
+	uint32_t		alloc_flags)
 {
 	bool			need_pag = !args->pag;
 	int			error;
@@ -3235,7 +3239,7 @@ xfs_alloc_vextent_prepare_ag(
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
 	args->agbp = NULL;
-	error = xfs_alloc_fix_freelist(args, flags);
+	error = xfs_alloc_fix_freelist(args, alloc_flags);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
 		if (need_pag)
@@ -3357,6 +3361,7 @@ xfs_alloc_vextent_this_ag(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
+	uint32_t		alloc_flags = 0;
 	int			error;
 
 	ASSERT(args->pag != NULL);
@@ -3375,9 +3380,9 @@ xfs_alloc_vextent_this_ag(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args, 0);
+	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_size(args);
+		error = xfs_alloc_ag_vextent_size(args, alloc_flags);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
@@ -3406,20 +3411,20 @@ xfs_alloc_vextent_iterate_ags(
 	xfs_agnumber_t		minimum_agno,
 	xfs_agnumber_t		start_agno,
 	xfs_agblock_t		target_agbno,
-	uint32_t		flags)
+	uint32_t		alloc_flags)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		restart_agno = minimum_agno;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	if (flags & XFS_ALLOC_FLAG_TRYLOCK)
+	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)
 		restart_agno = 0;
 restart:
 	for_each_perag_wrap_range(mp, start_agno, restart_agno,
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
-		error = xfs_alloc_vextent_prepare_ag(args, flags);
+		error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 		if (error)
 			break;
 		if (!args->agbp) {
@@ -3433,10 +3438,10 @@ xfs_alloc_vextent_iterate_ags(
 		 */
 		if (args->agno == start_agno && target_agbno) {
 			args->agbno = target_agbno;
-			error = xfs_alloc_ag_vextent_near(args);
+			error = xfs_alloc_ag_vextent_near(args, alloc_flags);
 		} else {
 			args->agbno = 0;
-			error = xfs_alloc_ag_vextent_size(args);
+			error = xfs_alloc_ag_vextent_size(args, alloc_flags);
 		}
 		break;
 	}
@@ -3453,8 +3458,8 @@ xfs_alloc_vextent_iterate_ags(
 	 * constraining flags by the caller, drop them and retry the allocation
 	 * without any constraints being set.
 	 */
-	if (flags) {
-		flags = 0;
+	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK) {
+		alloc_flags &= ~XFS_ALLOC_FLAG_TRYLOCK;
 		restart_agno = minimum_agno;
 		goto restart;
 	}
@@ -3482,6 +3487,7 @@ xfs_alloc_vextent_start_ag(
 	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
+	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
 	int			error;
 
 	ASSERT(args->pag == NULL);
@@ -3508,7 +3514,7 @@ xfs_alloc_vextent_start_ag(
 
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), XFS_ALLOC_FLAG_TRYLOCK);
+			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
 
 	if (bump_rotor) {
 		if (args->agno == start_agno)
@@ -3535,6 +3541,7 @@ xfs_alloc_vextent_first_ag(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	xfs_agnumber_t		start_agno;
+	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
 	int			error;
 
 	ASSERT(args->pag == NULL);
@@ -3553,7 +3560,7 @@ xfs_alloc_vextent_first_ag(
 
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), 0);
+			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
@@ -3606,6 +3613,7 @@ xfs_alloc_vextent_near_bno(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	bool			needs_perag = args->pag == NULL;
+	uint32_t		alloc_flags = 0;
 	int			error;
 
 	if (!needs_perag)
@@ -3626,9 +3634,9 @@ xfs_alloc_vextent_near_bno(
 	if (needs_perag)
 		args->pag = xfs_perag_grab(mp, args->agno);
 
-	error = xfs_alloc_vextent_prepare_ag(args, 0);
+	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_near(args);
+		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 85ac470be0da..d1aa7c63eafe 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -195,7 +195,7 @@ int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf **bpp);
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
-int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
+int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, uint32_t alloc_flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index f3d328e4a440..874798949625 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -571,7 +571,8 @@ void
 xfs_extent_busy_flush(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	unsigned		busy_gen)
+	unsigned		busy_gen,
+	unsigned int		flags)
 {
 	DEFINE_WAIT		(wait);
 	int			error;
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 4a118131059f..79ef5a2d7758 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -53,7 +53,7 @@ xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
 
 void
 xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
-	unsigned busy_gen);
+	unsigned busy_gen, unsigned int flags);
 
 void
 xfs_extent_busy_wait_all(struct xfs_mount *mp);
-- 
2.40.1

