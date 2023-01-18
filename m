Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8476C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjARWs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjARWsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11F15399A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k13so632508plg.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezIOhhBHSVSN11A4M+HFNIDRMu+m9Sh8NwY5jIIUTmA=;
        b=gXYbCe3/vIfs2Skxdmzzy9QnTRwDkrZtSHCwpFKBg+atYe32mt5YFqUTNHYCdTLOGq
         4+r06Tm3OQP/oAvJ7En+RB1PKT/UZ0PtRo8IxNHq6uxXaFiOvSuGJf+7/SNobqjOEgQp
         HLVwb+tprGokbiQzA+SsNysu/PwufUuvkjB/WT1pGRuFsObB9R82ZZvV+HnjKwcIw6+C
         UUa1oSTxBsQr0CfIoo6OfV2PhPWuLDpjwzTZNORxPnAyUGveCy8OkSKB1lUSpp8t3WSY
         LsR1VXX7eymWbeFJ4/g+7R0aD078aRBGz1LeUaSWw3qcRximIqn61qvtEtok4qmRoOuV
         zaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezIOhhBHSVSN11A4M+HFNIDRMu+m9Sh8NwY5jIIUTmA=;
        b=ax+ABJECvEWRY7dpath4EOuO73yJV6Mg4sKiQwG5lfoKXImb/msOfD9TmkEHzq0IFK
         ystJhZ43AAQ0aklMs07JhR3a2hI9ysDHEL78xOh3ucBYMOp3lK4BPyLwqhPY1K7UbkMC
         JvQZpJN0fo76LXU8dKFBsObfNnwPqHkJaTMDKGG3peYwVHCQIp73Esxudk5AwNOYdqGu
         KzPtH8aElVHBEeW8UF7xw+hyJqHFhKRjnxKLCkrdKvQEFEF1yu/VRAs/7hSddu6EFSMK
         5mNymEnb7RgwYrOKIjYb6fFdvxCr1BDktgnoCn+TvTpEfv296iPMFJSzU/shnMj4e2VH
         ETgQ==
X-Gm-Message-State: AFqh2kpzcTYFBCM5FZgFk656TQlRUqrKjgiO+04lR+sBVKuDVwmSrpPt
        5AxHq20OtPmWb6mC0Iu43zCN8Qzn4L634Fo1
X-Google-Smtp-Source: AMrXdXsvMt0My6J3/jPQm+qM1jTd+Dejy4IBN939TbX9+YiBn4KFObTCFryonnP+BHvQcRMK+l4FhA==
X-Received: by 2002:a05:6a21:3946:b0:b8:8153:50fc with SMTP id ac6-20020a056a21394600b000b8815350fcmr9033620pzc.41.1674082102379;
        Wed, 18 Jan 2023 14:48:22 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q25-20020a631f59000000b004cffa8c0227sm2149163pgm.23.2023.01.18.14.48.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:48:21 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYZ-V1
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFo-37
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 41/42] xfs: return a referenced perag from filestreams allocator
Date:   Thu, 19 Jan 2023 09:45:04 +1100
Message-Id: <20230118224505.1964941-42-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the filestreams AG selection tracks active perags, we need
to return an active perag to the core allocator code. This is
because the file allocation the filestreams code will run are AG
specific allocations and so need to pin the AG until the allocations
complete.

We cannot rely on the filestreams item reference to do this - the
filestreams association can be torn down at any time, hence we
need to have a separate reference for the allocation process to pin
the AG after it has been selected.

This means there is some perag juggling in allocation failure
fallback paths as they will do all AG scans in the case the AG
specific allocation fails. Hence we need to track the perag
reference that the filestream allocator returned to make sure we
don't leak it on repeated allocation failure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 +++++++++++-----
 fs/xfs/xfs_filestream.c  | 93 ++++++++++++++++++++++++----------------
 2 files changed, 84 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 098b46f3f3e3..7f56002b545d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3427,6 +3427,7 @@ xfs_bmap_btalloc_at_eof(
 	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
+	struct xfs_perag	*caller_pag = args->pag;
 	int			error;
 
 	/*
@@ -3454,9 +3455,11 @@ xfs_bmap_btalloc_at_eof(
 		else
 			args->minalignslop = 0;
 
-		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+		if (!caller_pag)
+			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
 		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-		xfs_perag_put(args->pag);
+		if (!caller_pag)
+			xfs_perag_put(args->pag);
 		if (error)
 			return error;
 
@@ -3482,10 +3485,13 @@ xfs_bmap_btalloc_at_eof(
 		args->minalignslop = 0;
 	}
 
-	if (ag_only)
+	if (ag_only) {
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	else
+	} else {
+		args->pag = NULL;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+		args->pag = caller_pag;
+	}
 	if (error)
 		return error;
 
@@ -3544,12 +3550,13 @@ xfs_bmap_btalloc_filestreams(
 	int			stripe_align)
 {
 	xfs_extlen_t		blen = 0;
-	int			error;
+	int			error = 0;
 
 
 	error = xfs_filestream_select_ag(ap, args, &blen);
 	if (error)
 		return error;
+	ASSERT(args->pag);
 
 	/*
 	 * If we are in low space mode, then optimal allocation will fail so
@@ -3558,22 +3565,31 @@ xfs_bmap_btalloc_filestreams(
 	 */
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		args->minlen = ap->minlen;
+		ASSERT(args->fsbno == NULLFSBLOCK);
 		goto out_low_space;
 	}
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
-	if (ap->aeof) {
+	if (ap->aeof)
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
 				true);
-		if (error || args->fsbno != NULLFSBLOCK)
-			return error;
-	}
 
-	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+	if (!error && args->fsbno == NULLFSBLOCK)
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+
+out_low_space:
+	/*
+	 * We are now done with the perag reference for the filestreams
+	 * association provided by xfs_filestream_select_ag(). Release it now as
+	 * we've either succeeded, had a fatal error or we are out of space and
+	 * need to do a full filesystem scan for free space which will take it's
+	 * own references.
+	 */
+	xfs_perag_rele(args->pag);
+	args->pag = NULL;
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
-out_low_space:
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 81aebe3e09ba..523a3b8b5754 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -53,8 +53,9 @@ xfs_fstrm_free_func(
  */
 static int
 xfs_filestream_pick_ag(
+	struct xfs_alloc_arg	*args,
 	struct xfs_inode	*ip,
-	xfs_agnumber_t		*agp,
+	xfs_agnumber_t		start_agno,
 	int			flags,
 	xfs_extlen_t		*longest)
 {
@@ -64,7 +65,6 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
 	xfs_extlen_t		free = 0, minfree, maxfree = 0;
-	xfs_agnumber_t		start_agno = *agp;
 	xfs_agnumber_t		agno;
 	int			err, trylock;
 
@@ -73,8 +73,6 @@ xfs_filestream_pick_ag(
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
-	*agp = NULLAGNUMBER;
-
 	/* For the first pass, don't sleep trying to init the per-AG. */
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
@@ -89,7 +87,7 @@ xfs_filestream_pick_ag(
 				break;
 			/* Couldn't lock the AGF, skip this AG. */
 			err = 0;
-			goto next_ag;
+			continue;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -146,16 +144,19 @@ xfs_filestream_pick_ag(
 		/*
 		 * No unassociated AGs are available, so select the AG with the
 		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, return NULLAGNUMBER.
+		 * another filestream. It none suit, just use whatever AG we can
+		 * grab.
 		 */
 		if (!max_pag) {
-			*agp = NULLAGNUMBER;
-			trace_xfs_filestream_pick(ip, NULL, free);
-			return 0;
+			for_each_perag_wrap(mp, start_agno, agno, pag)
+				break;
+			atomic_inc(&pag->pagf_fstrms);
+			*longest = 0;
+		} else {
+			pag = max_pag;
+			free = maxfree;
+			atomic_inc(&pag->pagf_fstrms);
 		}
-		pag = max_pag;
-		free = maxfree;
-		atomic_inc(&pag->pagf_fstrms);
 	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
 	}
@@ -167,16 +168,29 @@ xfs_filestream_pick_ag(
 	if (!item)
 		goto out_put_ag;
 
+
+	/*
+	 * We are going to use this perag now, so take another ref to it for the
+	 * allocation context returned to the caller. If we raced to create and
+	 * insert the filestreams item into the MRU (-EEXIST), then we still
+	 * keep this reference but free the item reference we gained above. On
+	 * any other failure, we have to drop both.
+	 */
+	atomic_inc(&pag->pag_active_ref);
 	item->pag = pag;
+	args->pag = pag;
 
 	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
-		if (err == -EEXIST)
+		if (err == -EEXIST) {
 			err = 0;
+		} else {
+			xfs_perag_rele(args->pag);
+			args->pag = NULL;
+		}
 		goto out_free_item;
 	}
 
-	*agp = pag->pag_agno;
 	return 0;
 
 out_free_item:
@@ -236,7 +250,14 @@ xfs_filestream_select_ag_mru(
 	if (!mru)
 		goto out_default_agno;
 
+	/*
+	 * Grab the pag and take an extra active reference for the caller whilst
+	 * the mru item cannot go away. This means we'll pin the perag with
+	 * the reference we get here even if the filestreams association is torn
+	 * down immediately after we mark the lookup as done.
+	 */
 	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
+	atomic_inc(&pag->pag_active_ref);
 	xfs_mru_cache_done(mp->m_filestream);
 
 	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
@@ -246,6 +267,8 @@ xfs_filestream_select_ag_mru(
 
 	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 	if (error) {
+		/* We aren't going to use this perag */
+		xfs_perag_rele(pag);
 		if (error != -EAGAIN)
 			return error;
 		*blen = 0;
@@ -253,12 +276,18 @@ xfs_filestream_select_ag_mru(
 
 	/*
 	 * We are done if there's still enough contiguous free space to succeed.
+	 * If there is very little free space before we start a filestreams
+	 * allocation, we're almost guaranteed to fail to find a better AG with
+	 * larger free space available so we don't even try.
 	 */
 	*agno = pag->pag_agno;
-	if (*blen >= args->maxlen)
+	if (*blen >= args->maxlen || (ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
+		args->pag = pag;
 		return 0;
+	}
 
 	/* Changing parent AG association now, so remove the existing one. */
+	xfs_perag_rele(pag);
 	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
 	if (mru) {
 		struct xfs_fstrm_item *item =
@@ -297,46 +326,38 @@ xfs_filestream_select_ag(
 	struct xfs_inode	*pip = NULL;
 	xfs_agnumber_t		agno;
 	int			flags = 0;
-	int			error;
+	int			error = 0;
 
 	args->total = ap->total;
 	*blen = 0;
 
 	pip = xfs_filestream_get_parent(ap->ip);
 	if (!pip) {
-		agno = 0;
-		goto out_select;
+		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+		return 0;
 	}
 
 	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
-	if (error || *blen >= args->maxlen)
+	if (error)
 		goto out_rele;
-
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-	xfs_bmap_adjacent(ap);
-
-	/*
-	 * If there is very little free space before we start a filestreams
-	 * allocation, we're almost guaranteed to fail to find a better AG with
-	 * larger free space available so we don't even try.
-	 */
+	if (*blen >= args->maxlen)
+		goto out_select;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		goto out_select;
 
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
+	*blen = ap->length;
 	if (ap->datatype & XFS_ALLOC_USERDATA)
 		flags |= XFS_PICK_USERDATA;
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		flags |= XFS_PICK_LOWSPACE;
 
-	*blen = ap->length;
-	error = xfs_filestream_pick_ag(pip, &agno, flags, blen);
-	if (agno == NULLAGNUMBER) {
-		agno = 0;
-		*blen = 0;
-	}
-
+	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
+	if (error)
+		goto out_rele;
 out_select:
-	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
+	ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
 out_rele:
 	xfs_irele(pip);
 	return error;
-- 
2.39.0

