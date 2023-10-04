Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A108CE8FDC7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjJDAT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbjJDATz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7533C8E
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2774f6943b1so1145726a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378791; x=1696983591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67pte+ybmkSTNBJ3mvuTyj3R1AK0jwg+8CMXUhT6XKE=;
        b=HxM/eGv/v4wHIUG8JY3H5hEOfiaNToJikCPFWxNWjlNsdAhrDNl4kH9wP/p17q9wNi
         dTJS/KUnFloGiwZGwJI7dHz5PjJ7fqO7XFrExRZ4C24DSdawVPpFBMw9Sc7PFvrCLnKH
         5NBEkK727bJj9yB3tebMuNi1nkUnb25t/+LnqyeI86DzCYocc1sdm5ePf6Z9HuZuUKbT
         ajpIx5BZUJaZenTCZ6fNEbThUShon8tp9WqdYUmNlpSN3xHx7hqEr2+APMBzVqSk3+DS
         57Wf/jyYijygY67ERHI92NtXl7GTiIIyjrPdeSt6Lvk6UayNFuUzG3HkwxsLTHk+Tsjm
         AvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378791; x=1696983591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67pte+ybmkSTNBJ3mvuTyj3R1AK0jwg+8CMXUhT6XKE=;
        b=rqXRT1glDXyw92C3m5OCMQIwwGpQ9p7I8PVNylRT+1/zRQsp4i3JBfVqB7D7fP6HdN
         OaQA2NpBY5PVUkbS+MnaxyKv7uY/kMqJNQXlpTKYaM8OII6HOolvxE+klzQw4xiD6vlz
         NLXylipoHLsy9zcg+NQECJvBwsNST4KXvjowpFnmuGYL7rpClJqRCZ/JUcY4LkULckff
         KD6keclJkh/oXEYf8A87hqJ7ebwpiuliBs3JBNjNsA8VFB7WfDqvQkbe2ioIg4kbBpI2
         1Yldkq9h2g/8LooqhxLdUVIKVPX08riZlnqRKjnZBW2wcGsEsy9CrxI4KY07HRukAcEX
         pXmg==
X-Gm-Message-State: AOJu0YyH4E5L1r71y+/e7nPI/jYI46VUXxSc3V39ZB5v1vyvJL2y+JOV
        4CAYCVKykMUHy0sKc9pkQgRQJCF3Vyi8km3PHrI=
X-Google-Smtp-Source: AGHT+IE/g2Kf38wXYzkT6hafFOhXqjGsmRqmCotE8kgkRS3XSCR1n40jWMDhpOi8ce9yNzR1hQjUdg==
X-Received: by 2002:a17:90a:b114:b0:25b:c454:a366 with SMTP id z20-20020a17090ab11400b0025bc454a366mr878142pjq.5.1696378790848;
        Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id iq21-20020a17090afb5500b0027b0bfa3be1sm42312pjb.11.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097NA-09;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001TrD-3IBg;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 4/9] xfs: push the perag outwards in initial allocation
Date:   Wed,  4 Oct 2023 11:19:38 +1100
Message-Id: <20231004001943.349265-5-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In xfs_bmap_btalloc_best_length(), we first select the best length
to allocate by scanning all the AGs to check free space and
contiguous extents. From this, we effectively select a target AG,
but we don't take a perag reference anywhere. We only take a perag
reference when we actually go to do an allocation. This means we
end up calling xfs_bmap_btalloc_at_eof() from different places, one
with a perag reference and one without, and so it has to manage
grabbing the perag reference if necessary.

We should be grabbing this perag reference when we determine the
first AG with a suitable extent in it in
xfs_bmap_btalloc_select_lengths(), rather than determining that
there is some AG tha has a suitable contiguous extent in it and then
trying maxlen allocations from  the start AG and failing until we
finally hit the AG that has that maxlen extent in it.

We also need to pass the stripe alignment blocks needed to
xfs_bmap_btalloc_select_lengths() so that this is taken into account
when we scan the AGs for an appropriate contiguous extent size.

At this point, we want the near and exact block allocation
algorithms to take the AG they operate in from args->pag rather than
from the the target block number. The high level callers have
already all selected an AG and grabbed a perag, so the "agno"
portion of the target is no longer relevant and may, in fact, be
stale. i.e. the caller should set up args->pag to points to the AG
that we want to allocate from so that we don't end up in the
situation where the target fsbno points to a different AG and we
attempt an allocation on a AG that we don't hold a perag reference
to.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 96 ++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ee1c1415c67a..3c250c89f42e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3224,10 +3224,26 @@ xfs_bmap_select_minlen(
 	return args->maxlen;
 }
 
+/*
+ * Find the first AG with sufficient contiguous free space to allocate the
+ * entire extent and return with a reference held to that perag in args->pag.
+ * This takes into account stripe alignment rounding for the extent as well, so
+ * we don't end selecting an AG that gets rejected multiple times trying to do
+ * aligned allocation in AGs that don't quite have enough contiguous free space
+ * for aligned allocation to succed.
+ *
+ * If no maxlen contiguous extent can be found, just grab the perag for the AG
+ * that matches the target (startag) and let the allocation routines iterate to
+ * find the best candidate themselves.
+ *
+ * This function also sets the minimum and maximum lengths acceptable for
+ * optimal allocation in this context.
+ */
 static int
 xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
+	int			stripe_align,
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = args->mp;
@@ -3235,26 +3251,24 @@ xfs_bmap_btalloc_select_lengths(
 	xfs_agnumber_t		agno, startag;
 	xfs_agnumber_t		max_blen_agno;
 	xfs_extlen_t		max_blen = 0;
-	int			error = 0;
-
-	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-		args->total = ap->minlen;
-		args->minlen = ap->minlen;
-		return 0;
-	}
 
+	ASSERT(args->pag == NULL);
 	args->total = ap->total;
+
 	startag = XFS_FSB_TO_AGNO(mp, ap->blkno);
 	if (startag == NULLAGNUMBER)
 		startag = 0;
 
 	*blen = 0;
+	max_blen_agno = startag;
 	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		if (error && error != -EAGAIN)
-			break;
-		error = 0;
-		if (*blen >= args->maxlen) {
+		int error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+
+		if (error && error != -EAGAIN) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+		if (*blen >= args->maxlen + stripe_align) {
 			/*
 			 * We are going to target a different AG than the
 			 * incoming target, so we need to reset the target and
@@ -3264,6 +3278,7 @@ xfs_bmap_btalloc_select_lengths(
 				ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 				ap->aeof = false;
 			}
+			args->pag = pag;
 			break;
 		}
 		if (*blen > max_blen) {
@@ -3271,19 +3286,19 @@ xfs_bmap_btalloc_select_lengths(
 			max_blen_agno = agno;
 		}
 	}
-	if (pag)
-		xfs_perag_rele(pag);
 
-	if (max_blen > *blen) {
+	if (max_blen >= *blen) {
+		ASSERT(args->pag == NULL);
 		if (max_blen_agno != startag) {
 			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
 			ap->aeof = false;
 		}
 		*blen = max_blen;
+		args->pag = xfs_perag_grab(mp, max_blen_agno);
 	}
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
-	return error;
+	return 0;
 }
 
 /* Update all inode and quota accounting for the allocation we just did. */
@@ -3485,8 +3500,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 	xfs_extlen_t		blen,
 	int			stripe_align)
 {
-	struct xfs_mount	*mp = args->mp;
-	struct xfs_perag        *caller_pag = args->pag;
 	xfs_extlen_t		nextminlen = 0;
 	int			error;
 
@@ -3506,13 +3519,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	else
 		args->minalignslop = 0;
 
-	if (!caller_pag)
-		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
 	error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-	if (!caller_pag) {
-		xfs_perag_put(args->pag);
-		args->pag = NULL;
-	}
 	if (error)
 		return error;
 
@@ -3677,6 +3684,17 @@ xfs_bmap_btalloc_best_length(
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
 	xfs_bmap_adjacent(ap);
 
+	/*
+	 * If we are in low space mode, then optimal allocation will fail so
+	 * prepare for minimal allocation and run the low space algorithm
+	 * immediately.
+	 */
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		args->minlen = ap->minlen;
+		ASSERT(args->fsbno == NULLFSBLOCK);
+		return xfs_bmap_btalloc_low_space(ap, args);
+	}
+
 	/*
 	 * We only use stripe alignment for EOF allocations. Hence if it isn't
 	 * an EOF allocation, clear the stripe alignment. This allows us to
@@ -3692,22 +3710,32 @@ xfs_bmap_btalloc_best_length(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
+	error = xfs_bmap_btalloc_select_lengths(ap, args, stripe_align, &blen);
 	if (error)
 		return error;
+	ASSERT(args->pag);
 
-	/*
-	 * Don't attempt optimal EOF allocation if previous allocations barely
-	 * succeeded due to being near ENOSPC. It is highly unlikely we'll get
-	 * optimal or even aligned allocations in this case, so don't waste time
-	 * trying.
-	 */
-	if (ap->aeof && ap->offset && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
+	if (ap->aeof && ap->offset) {
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
-		if (error || args->fsbno != NULLFSBLOCK)
-			return error;
 	}
 
+	/*
+	 * We are now done with the perag reference for the optimal allocation
+	 * association provided by xfs_bmap_btalloc_select_lengths(). Release it
+	 * now as we've either succeeded, had a fatal error or we are out of
+	 * space and need to do a full filesystem scan for free space which will
+	 * take it's own references.
+	 *
+	 * XXX: now that xfs_bmap_btalloc_select_lengths() selects an AG with
+	 * enough contiguous free space in it for an aligned allocation, we
+	 * can change the aligned allocation at EOF to just be a single AG
+	 * allocation.
+	 */
+	xfs_perag_rele(args->pag);
+	args->pag = NULL;
+	if (error || args->fsbno != NULLFSBLOCK)
+		return error;
+
 	/* attempt aligned allocation for new EOF extents */
 	if (stripe_align)
 		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
-- 
2.40.1

