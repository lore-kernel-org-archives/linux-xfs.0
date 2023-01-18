Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDE5C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjARWsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjARWr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:47:56 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B38F66CD1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:40 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g68so85438pgc.11
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTV2m8LVZXzVgCdOKGIm8DM9aCk7NltTbgw3MjhF0rc=;
        b=wavsYH5nuYh7brk+KntZDmU3nkQx0vPKZRC8E0jRmIRbbSicMlYmYdY0V5pRO5Oi6o
         Mt1Ph0f/ZjH+HH7BSmhYt2MOvaTyWokxF/EHFXeS/ZZWayirk+qzHpCo382Z4pHw8q8e
         PO5Yybk+4Jl2GM+J8h9PNJz0tHmupTMbrLQuHNaaGfdpwraaP9pC4c2sgWMiXBhCGi4A
         KLXXNe2jxlryBwCczWokXkXC3i7q/8m5QxkMTs6ZSu6S2b9dumoSKzjaN0jnCWHHorma
         Pb49UiHle9fQhNOF1qTFgoG/uZ5m6F+Xen8/sAs9T8Rlg6i9t0gZsuap89gklmIg40Lx
         YV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oTV2m8LVZXzVgCdOKGIm8DM9aCk7NltTbgw3MjhF0rc=;
        b=3FTmL3lOyjB7kpxuM8IvtHUCRz7gyuV6CFziiQTXAKrY2hqrjnvUYbhUQ9b9Fvth2Q
         BHauCwa8cT4rjcWHfbLg8HXPLDHAf8ebBl2RtUXVom/Ra7ItkFTsZPdcVpmPXa/FXuul
         yJlmAabIlfE6yUY7hQwShMVu6KELG3ulqOJ7AhF52xgUKEv1o2z2tyeOnseIods+RCYW
         0GbSnCbJm94ubBUbYDM83DVqVqb3PyKiBVqqYaEgHJcpMnh0OsEyg/pWIvgyx6W7iWRV
         roXKUfC+k74zue2v7J5W4wBlqDP0W5cMgB3mpw2iEOu4WjMwKY/N+8r4JDVZY5SOyj6Z
         g0FQ==
X-Gm-Message-State: AFqh2koV1w/q2K0Yx3xOkpjV03O9L3CwVGufyIiFwez4npYX/vp22qYk
        JqQ2jirXyP5O/g9MclsfJS+JI1sN80UcH7KZ
X-Google-Smtp-Source: AMrXdXtQST9GPCgCPppjh4lt9Bcis5H7BgXmR0qsFsrxQC9Q9d7CUkZmrkYZGhnbePNCLKcn4fOAGA==
X-Received: by 2002:a05:6a00:180d:b0:58d:c694:9a9e with SMTP id y13-20020a056a00180d00b0058dc6949a9emr10994160pfa.18.1674082059170;
        Wed, 18 Jan 2023 14:47:39 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79f85000000b0058bbdaaa5e4sm8164696pfr.162.2023.01.18.14.47.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:38 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iY3-Ku
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEv-25
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 30/42] xfs: factor out filestreams from xfs_bmap_btalloc_nullfb
Date:   Thu, 19 Jan 2023 09:44:53 +1100
Message-Id: <20230118224505.1964941-31-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's many if (filestreams) {} else {} branches in this function.
Split it out into a filestreams specific function so that we can
then work directly on cleaning up the filestreams code without
impacting the rest of the allocation algorithms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 167 ++++++++++++++++++++++-----------------
 1 file changed, 96 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ba74aea034b0..7ae08b44e4d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3234,8 +3234,8 @@ xfs_bmap_btalloc_select_lengths(
 	return 0;
 }
 
-STATIC int
-xfs_bmap_btalloc_filestreams(
+static int
+xfs_bmap_btalloc_filestreams_select_lengths(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*blen)
@@ -3576,54 +3576,109 @@ xfs_bmap_btalloc_at_eof(
 	return 0;
 }
 
+/*
+ * We have failed multiple allocation attempts so now are in a low space
+ * allocation situation. Try a locality first full filesystem minimum length
+ * allocation whilst still maintaining necessary total block reservation
+ * requirements.
+ *
+ * If that fails, we are now critically low on space, so perform a last resort
+ * allocation attempt: no reserve, no locality, blocking, minimum length, full
+ * filesystem free space scan. We also indicate to future allocations in this
+ * transaction that we are critically low on space so they don't waste time on
+ * allocation modes that are unlikely to succeed.
+ */
 static int
-xfs_bmap_btalloc_best_length(
+xfs_bmap_btalloc_low_space(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	int			error;
+
+	if (args->minlen > ap->minlen) {
+		args->minlen = ap->minlen;
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+		if (error || args->fsbno != NULLFSBLOCK)
+			return error;
+	}
+
+	/* Last ditch attempt before failure is declared. */
+	args->total = ap->minlen;
+	error = xfs_alloc_vextent_first_ag(args, 0);
+	if (error)
+		return error;
+	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
+	return 0;
+}
+
+static int
+xfs_bmap_btalloc_filestreams(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
 {
-	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		agno = xfs_filestream_lookup_ag(ap->ip);
 	xfs_extlen_t		blen = 0;
-	bool			is_filestream = false;
 	int			error;
 
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
-		is_filestream = true;
+	/* Determine the initial block number we will target for allocation. */
+	if (agno == NULLAGNUMBER)
+		agno = 0;
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
+	xfs_bmap_adjacent(ap);
 
 	/*
-	 * Determine the initial block number we will target for allocation.
+	 * If there is very little free space before we start a
+	 * filestreams allocation, we're almost guaranteed to fail to
+	 * find an AG with enough contiguous free space to succeed, so
+	 * just go straight to the low space algorithm.
 	 */
-	if (is_filestream) {
-		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
-		if (agno == NULLAGNUMBER)
-			agno = 0;
-		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-	} else {
-		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		args->minlen = ap->minlen;
+		return xfs_bmap_btalloc_low_space(ap, args);
 	}
-	xfs_bmap_adjacent(ap);
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	if (is_filestream) {
-		/*
-		 * If there is very little free space before we start a
-		 * filestreams allocation, we're almost guaranteed to fail to
-		 * find an AG with enough contiguous free space to succeed, so
-		 * just go straight to the low space algorithm.
-		 */
-		if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-			args->minlen = ap->minlen;
-			goto critically_low_space;
-		}
-		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
-	} else {
-		error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
+	error = xfs_bmap_btalloc_filestreams_select_lengths(ap, args, &blen);
+	if (error)
+		return error;
+
+	if (ap->aeof) {
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
+				true);
+		if (error || args->fsbno != NULLFSBLOCK)
+			return error;
 	}
+
+	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
+	if (error || args->fsbno != NULLFSBLOCK)
+		return error;
+
+	return xfs_bmap_btalloc_low_space(ap, args);
+}
+
+static int
+xfs_bmap_btalloc_best_length(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	xfs_extlen_t		blen = 0;
+	int			error;
+
+	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
+	xfs_bmap_adjacent(ap);
+
+	/*
+	 * Search for an allocation group with a single extent large enough for
+	 * the request.  If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
 	if (error)
 		return error;
 
@@ -3635,50 +3690,16 @@ xfs_bmap_btalloc_best_length(
 	 */
 	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
-				is_filestream);
-		if (error)
+				false);
+		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
-		if (args->fsbno != NULLFSBLOCK)
-			return 0;
 	}
 
-	if (is_filestream)
-		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	else
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-	if (error)
+	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
+	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
-
-	/*
-	 * Try a locality first full filesystem minimum length allocation whilst
-	 * still maintaining necessary total block reservation requirements.
-	 */
-	if (args->minlen > ap->minlen) {
-		args->minlen = ap->minlen;
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-		if (error)
-			return error;
-	}
-	if (args->fsbno != NULLFSBLOCK)
-		return 0;
 
-	/*
-	 * We are now critically low on space, so this is a last resort
-	 * allocation attempt: no reserve, no locality, blocking, minimum
-	 * length, full filesystem free space scan. We also indicate to future
-	 * allocations in this transaction that we are critically low on space
-	 * so they don't waste time on allocation modes that are unlikely to
-	 * succeed.
-	 */
-critically_low_space:
-	args->total = ap->minlen;
-	error = xfs_alloc_vextent_first_ag(args, 0);
-	if (error)
-		return error;
-	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
-	return 0;
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
 static int
@@ -3712,7 +3733,11 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
-	error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
+	else
+		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
 	if (error)
 		return error;
 
-- 
2.39.0

