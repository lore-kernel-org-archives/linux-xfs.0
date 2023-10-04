Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796A1E8FDC5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjJDATz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjJDATy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:54 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB60A7
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:51 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-59f82ad1e09so19144207b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378790; x=1696983590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=orpevTBpd5HdlWyCjMm8CLKabpO07CfDvOiUXOti3eg=;
        b=zJif1m+sn5fmN40LeEfLl/NODAhPh5A1C6ZplJfDtFr+yzTV9Xby8ybs0BJVsF+N4z
         5OUh+fqV65gPCTgmhNhM3pg8ExeeOt7J8wrXiWT92bgkbl7RMucP7KC3eSaGcBfsFBxk
         Qn8wyyX/DEybWEGfJsnp+8rXV0xPi7Xatzs0+V0Ayd6Ac17SWeNBALEhqzFDg7oFgYJw
         sGXmXfCp/bqVWhJFEntEOyqOxZ4E20RyT1q6dyZQpmpE9Youz9lQYfkPlhHuPPp7l5oD
         Z0sZ7/CsTqPhnIS061g3DOmRw3JiCG9GgNZ4pvv3KfYFtJqCSkIVfaaNr27IKNwGfs9m
         E2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378790; x=1696983590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orpevTBpd5HdlWyCjMm8CLKabpO07CfDvOiUXOti3eg=;
        b=YGXioEquU0/STXsJiJbQP756OcPepGnpx6dJ2q/XE4blyoWCvB4rY+NrbUZqHr/0NN
         yw0ucbSUFkONdD/KWI8S491YRmFqyaIT9EGgOCRPajQy+607lAsbf3+6WpXqz39nkqRE
         M0g0RddHFs9YgTmoOBM6aNttDaLKB7ECWn8oCNA6QRtovO8KKNqv5R/+EUBtuLg7yy4Q
         r5Ni0xr5Gl6ZHZyIuM5LrGsbKy/hzHHMwzX/r4mobMy6c9rS6PqFYnSce3k3NP2+h97w
         qbnkS67lCnLv02M+iK/1kToK+lt5v67oqwKUdf4Pk4PYqQ9/c42ympaEhfGcvaAei7a4
         1mkA==
X-Gm-Message-State: AOJu0YzBZIJg1VyJ+xx76GKovfgQJ7rNeSP9N790MS2XKYISBPDcF+Pq
        pEtke8IptIoeFKmcDOPuGNe2coP6lmE4hIkb67Y=
X-Google-Smtp-Source: AGHT+IFKMFoC1KizM+q/wUs/vwAkFBd3bazl4T9u9Gf/YzbPjfwDyMYZV+gJj7zE18xQqtVGM6NbHA==
X-Received: by 2002:a0d:f003:0:b0:59b:4f2d:231 with SMTP id z3-20020a0df003000000b0059b4f2d0231mr1029749ywe.45.1696378790363;
        Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id g6-20020a63be46000000b0058923252c22sm1738358pgo.15.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpc9-0097N0-2w;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001Tr1-2lqA;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 1/9] xfs: split xfs_bmap_btalloc_at_eof()
Date:   Wed,  4 Oct 2023 11:19:35 +1100
Message-Id: <20231004001943.349265-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This function is really implementing two policies. The first is
trying to create contiguous extents at file extension. Failing that,
it attempts to perform aligned allocation. These are really two
separate policies, and it is further complicated by filestream
allocation having different aligned allocation constraints than
the normal bmap allocation.

Split xfs_bmap_btalloc_at_eof() into two parts so we can start to
align the two different allocator policies more closely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 147 +++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..e14671414afb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3451,81 +3451,81 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 #endif
 
-/*
- * If we are not low on available data blocks and we are allocating at
- * EOF, optimise allocation for contiguous file extension and/or stripe
- * alignment of the new extent.
- *
- * NOTE: ap->aeof is only set if the allocation length is >= the
- * stripe unit and the allocation offset is at the end of file.
- */
+ /*
+ * Attempt contiguous allocation for file extension.
+  */
+ static int
+ xfs_bmap_btalloc_at_eof(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		blen,
+	int			stripe_align)
+{
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_perag        *caller_pag = args->pag;
+	xfs_extlen_t		nextminlen = 0;
+	int			error;
+
+	/*
+	 * Compute the minlen+alignment for the next case.  Set slop so
+	 * that the value of minlen+alignment+slop doesn't go up between
+	 * the calls.
+	 */
+	args->alignment = 1;
+	if (blen > stripe_align && blen <= args->maxlen)
+		nextminlen = blen - stripe_align;
+	else
+		nextminlen = args->minlen;
+	if (nextminlen + stripe_align > args->minlen + 1)
+		args->minalignslop = nextminlen + stripe_align -
+				args->minlen - 1;
+	else
+		args->minalignslop = 0;
+
+	if (!caller_pag)
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+	error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
+	if (!caller_pag) {
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
+	if (error)
+		return error;
+
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+	/*
+	 * Exact allocation failed. Reset to try an aligned allocation
+	 * according to the original allocation specification.
+	 */
+	args->minlen = nextminlen;
+	return 0;
+}
+
 static int
-xfs_bmap_btalloc_at_eof(
+xfs_bmap_btalloc_aligned(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
 	int			stripe_align,
 	bool			ag_only)
 {
-	struct xfs_mount	*mp = args->mp;
-	struct xfs_perag	*caller_pag = args->pag;
+	struct xfs_perag        *caller_pag = args->pag;
 	int			error;
 
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * If we failed an exact EOF allocation already, stripe
+	 * alignment will have already been taken into account in
+	 * args->minlen. Hence we only adjust minlen to try to preserve
+	 * alignment if no slop has been reserved for alignment
 	 */
-	if (ap->offset) {
-		xfs_extlen_t	nextminlen = 0;
-
-		/*
-		 * Compute the minlen+alignment for the next case.  Set slop so
-		 * that the value of minlen+alignment+slop doesn't go up between
-		 * the calls.
-		 */
-		args->alignment = 1;
-		if (blen > stripe_align && blen <= args->maxlen)
-			nextminlen = blen - stripe_align;
-		else
-			nextminlen = args->minlen;
-		if (nextminlen + stripe_align > args->minlen + 1)
-			args->minalignslop = nextminlen + stripe_align -
-					args->minlen - 1;
-		else
-			args->minalignslop = 0;
-
-		if (!caller_pag)
-			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
-		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
-		if (!caller_pag) {
-			xfs_perag_put(args->pag);
-			args->pag = NULL;
-		}
-		if (error)
-			return error;
-
-		if (args->fsbno != NULLFSBLOCK)
-			return 0;
-		/*
-		 * Exact allocation failed. Reset to try an aligned allocation
-		 * according to the original allocation specification.
-		 */
-		args->alignment = stripe_align;
-		args->minlen = nextminlen;
-		args->minalignslop = 0;
-	} else {
-		/*
-		 * Adjust minlen to try and preserve alignment if we
-		 * can't guarantee an aligned maxlen extent.
-		 */
-		args->alignment = stripe_align;
-		if (blen > args->alignment &&
-		    blen <= args->maxlen + args->alignment)
-			args->minlen = blen - args->alignment;
-		args->minalignslop = 0;
+	if (args->minalignslop == 0) {
+		if (blen > stripe_align &&
+		    blen <= args->maxlen + stripe_align)
+			args->minlen = blen - stripe_align;
 	}
+	args->alignment = stripe_align;
+	args->minalignslop = 0;
 
 	if (ag_only) {
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
@@ -3612,8 +3612,14 @@ xfs_bmap_btalloc_filestreams(
 	}
 
 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
+	if (ap->aeof && ap->offset)
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
+
+	if (error || args->fsbno != NULLFSBLOCK)
+		goto out_low_space;
+
 	if (ap->aeof)
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
+		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
 				true);
 
 	if (!error && args->fsbno == NULLFSBLOCK)
@@ -3662,13 +3668,20 @@ xfs_bmap_btalloc_best_length(
 	 * optimal or even aligned allocations in this case, so don't waste time
 	 * trying.
 	 */
-	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
-		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
-				false);
+	if (ap->aeof && ap->offset && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
 		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
 	}
 
+	/* attempt aligned allocation for new EOF extents */
+	if (ap->aeof)
+		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
+				false);
+	if (error || args->fsbno != NULLFSBLOCK)
+		return error;
+
+	/* attempt unaligned allocation */
 	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
-- 
2.40.1

