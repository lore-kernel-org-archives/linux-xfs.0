Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749D0EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjFTVc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjFTVc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3F4170F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6686ef86110so1839181b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296745; x=1689888745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/SOgPg4HXQxCqVyHH/RFKnhs54sjw+CDmLCig4qZxM=;
        b=bTnItDmeZ63NjsrsKmRSDz7akZTQoeKWuJdeAXAJrqcBBII2oPKFeTnypbJVkUe63u
         qn3p42RCrNDHckhvs6VDo8pVmMmwoLFOsM/z0x6y5of7G+/VdXwZNj4Z81sACiorNb1t
         Bb1XGVZeDh5yMyT2hpX9uxrUxmIrEPc47SBxz4SXVtP6jOeyvC+tH7NG47zkrtdTrUD9
         XNq05Ca3Hn7H8aE01bzKGzYgYc4+w/8hOFrUOieaVoiRGBGS1DVuiJTsG89LZtqOD51w
         VVK3VSmG2r9/JHCFRJKd6QTVDzvMDiME1mxC9mPEuoBPQds7STW7RmpZrEw6JGSiS69b
         aJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296745; x=1689888745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/SOgPg4HXQxCqVyHH/RFKnhs54sjw+CDmLCig4qZxM=;
        b=WE7RPXHjkXQ7G8RESqa5pxpkhqErdK+49+qv2WgtLqfWeLHV3Jog0sSC/sp1Ha7nEX
         G2jfXBgFCZI3+gLqNho7X4MdSXB2oHjuJ0tVp6HeXXbWWo4nO4PnphlRZtmKEjmIfukq
         2XpKHH1GMB/niBPZfnTQCOiaTiq6UpYH+ccjZ3tOmXdWUtq+pS8Y/WqdK7nCfpu7tyCg
         BNFEs16XGj9xKDYMhyJBQ071vU4u+lQcuxlJnvndXilkfAoGKWsauR4iloxM7u+SxY5s
         m8CzsqVGxA3lRFpVIQDiyYs54sUc1ykn76cnq3BVi26kAbGBpP1jogrY5gY7FqGiqbD5
         FItg==
X-Gm-Message-State: AC+VfDwJOOZEVM0r0M9npmAyGbDOI0SJnBwMB2cVTEQf3gW0F1JM67hY
        WTiROZhfAnLp1beQtPkU59Ryh6J7/uKGCWKlyMs=
X-Google-Smtp-Source: ACHHUZ59GOfqQGAKuUNFtVbDKAUhbQKlxHZGPbgM8Qh/v7Yt5uoYhggQfRB79nbMoCdyhwc5QCMAVw==
X-Received: by 2002:a05:6a00:b8f:b0:666:5fc4:36b1 with SMTP id g15-20020a056a000b8f00b006665fc436b1mr10864290pfj.26.1687296744951;
        Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 3/6] xfs: return maximum free size from xfs_rtany_summary()
Date:   Tue, 20 Jun 2023 14:32:13 -0700
Message-ID: <d3d0aad4dbf6999c5fe07d89d63ea6cfabee3ff4.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Instead of only returning whether there is any free space, return the
maximum size, which is fast thanks to the previous commit. This will be
used by two upcoming optimizations.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d3c76532d20e..ba7d42e0090f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -50,7 +50,7 @@ xfs_rtany_summary(
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
-	int		*stat)		/* out: any good extents here? */
+	int		*maxlog)	/* out: maximum log2 extent size free */
 {
 	int		error;		/* error value */
 	int		log;		/* loop counter, log2 of ext. size */
@@ -60,7 +60,7 @@ xfs_rtany_summary(
 	if (mp->m_rsum_cache) {
 		high = min(high, mp->m_rsum_cache[bbno] - 1);
 		if (low > high) {
-			*stat = 0;
+			*maxlog = -1;
 			return 0;
 		}
 	}
@@ -80,14 +80,14 @@ xfs_rtany_summary(
 		 * If there are any, return success.
 		 */
 		if (sum) {
-			*stat = 1;
+			*maxlog = log;
 			goto out;
 		}
 	}
 	/*
 	 * Found nothing, return failure.
 	 */
-	*stat = 0;
+	*maxlog = -1;
 out:
 	/* There were no extents at levels > log. */
 	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
@@ -427,7 +427,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
-	int		any;		/* any useful extents from summary */
+	int		maxlog;		/* maximum useful extent from summary */
 	xfs_rtblock_t	bbno;		/* bitmap block number */
 	int		error;		/* error value */
 	int		i;		/* bitmap block offset (loop control) */
@@ -479,7 +479,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
-			bbno + i, rtbufc, &any);
+			bbno + i, rtbufc, &maxlog);
 		if (error) {
 			return error;
 		}
@@ -487,7 +487,7 @@ xfs_rtallocate_extent_near(
 		 * If there are any useful extents starting here, try
 		 * allocating one.
 		 */
-		if (any) {
+		if (maxlog >= 0) {
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -527,7 +527,7 @@ xfs_rtallocate_extent_near(
 					 */
 					error = xfs_rtany_summary(mp, tp,
 						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rtbufc, &any);
+						bbno + j, rtbufc, &maxlog);
 					if (error) {
 						return error;
 					}
@@ -539,7 +539,7 @@ xfs_rtallocate_extent_near(
 					 * extent given, we've already tried
 					 * that allocation, don't do it again.
 					 */
-					if (any)
+					if (maxlog >= 0)
 						continue;
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxlen,
-- 
2.41.0

