Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AE9EB64DB
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjFTVc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjFTVcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BD3170F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-666e5f0d60bso2373008b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296744; x=1689888744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT1zigfHSV1GnJKYRoYuLlUr1mny5O2aWJ3vK3uEwjw=;
        b=qOCwQHPddSbfdRv6noRuAqtmFp+zz33lu04fWAmTJzKYa08MmMA2BmJfB09xzZHuVG
         wwvlQUUvQ1KBlp90Dz8bpskHIshFI8vmWT3gNdlbp4vvT2UcxDWDlcHaLAB6+HipEoTt
         pY7zNloxrNaw87rrwRicJkD7Rx2jfhxGpKhyHO+mOqG8ZL2dxy0RJldFE/UXMAYP8qBj
         2FSqFnfQQFPtmlupTlznHz+g3y2+F3dW0ESLsY5Zh6ix2IB0F4TZNxG/+RiKUHJ+8dJC
         Epma/ZDByEiBOKkmDLg7wQA0lfrgo56t3XNySNbdv2PuigDyrMnpIU7W2hVCX6twBZlR
         w/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296744; x=1689888744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QT1zigfHSV1GnJKYRoYuLlUr1mny5O2aWJ3vK3uEwjw=;
        b=kRIUOLeWVflTRbfHpoVnJSkT/lfj8KbbTm5IYNNtfN4vVjqPBMwu0lsDnqtcCcqO94
         8EL9EVo/6RQdWJquWO5GSWdAlbGfLuCjVOiiA8hbaLGOfSj+q+OGkLN6mBCfbDLWHR1E
         tmgA8z03R4J3d/tNslOnxDYFxU6p+FGsFQ+Aq9yYyz34zafFT/LMND2EwVlRuv4aJmpv
         5m1M3EHJt7ACQh8eZY7rBBiolmMMA7Yb89UUhCPgxpt0H+K4diecmDBXeGBjB7gTVpDt
         4WrHuAvyxTKMVwuAxiGlj4Oe4FVytvymbAzT+jnt3Vk8BfYTgiVvFlKRjkDd8sewhDrQ
         DJ+A==
X-Gm-Message-State: AC+VfDx+x8QmMwScjclvu281Ghu1bAZyHfKiuuyboPbsRIhA/t16mTH2
        NO+bM2Mr0ojLO3BJqdvdaKIMOMve67HX1VuHNb4=
X-Google-Smtp-Source: ACHHUZ4DkoER6MsMcneSKD+VGBXlQ/9I0yePuR7vWwOHYsaPFNOdFBd6AN3GguDQ382xaxf0Ir+pZA==
X-Received: by 2002:a05:6a00:1482:b0:65e:ec60:b019 with SMTP id v2-20020a056a00148200b0065eec60b019mr10972105pfu.25.1687296743706;
        Tue, 20 Jun 2023 14:32:23 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:23 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 2/6] xfs: invert the realtime summary cache
Date:   Tue, 20 Jun 2023 14:32:12 -0700
Message-ID: <e3ae5bfc7cd4b640e83a25f001169d4ae50d797a.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
added a cache of the minimum level of the realtime summary that has any
free extents. However, it turns out that the _maximum_ level is more
useful for upcoming optimizations, and basically equivalent for the
existing usage. So, let's change the meaning of the cache to be the
maximum level + 1, or 0 if there are no free extents.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  6 +++---
 fs/xfs/xfs_mount.h           |  6 +++---
 fs/xfs/xfs_rtalloc.c         | 31 +++++++++++++++++++------------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1a832c9a412f..d9493f64adfc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -503,10 +503,10 @@ xfs_rtmodify_summary_int(
 
 		*sp += delta;
 		if (mp->m_rsum_cache) {
-			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
-				mp->m_rsum_cache[bbno]++;
-			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			if (*sp == 0 && log + 1 == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
+			if (*sp != 0 && log >= mp->m_rsum_cache[bbno])
+				mp->m_rsum_cache[bbno] = log + 1;
 		}
 		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6c09f89534d3..964541c36730 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -103,9 +103,9 @@ typedef struct xfs_mount {
 
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
-	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
-	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
-	 * inode lock.
+	 * invariant that m_rsum_cache[bbno] > the maximum i for which
+	 * rsum[i][bbno] != 0, or 0 if rsum[i][bbno] == 0 for all i.
+	 * Reads and writes are serialized by the rsumip inode lock.
 	 */
 	uint8_t			*m_rsum_cache;
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 61ef13286654..d3c76532d20e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -56,14 +56,19 @@ xfs_rtany_summary(
 	int		log;		/* loop counter, log2 of ext. size */
 	xfs_suminfo_t	sum;		/* summary data */
 
-	/* There are no extents at levels < m_rsum_cache[bbno]. */
-	if (mp->m_rsum_cache && low < mp->m_rsum_cache[bbno])
-		low = mp->m_rsum_cache[bbno];
+	/* There are no extents at levels >= m_rsum_cache[bbno]. */
+	if (mp->m_rsum_cache) {
+		high = min(high, mp->m_rsum_cache[bbno] - 1);
+		if (low > high) {
+			*stat = 0;
+			return 0;
+		}
+	}
 
 	/*
 	 * Loop over logs of extent sizes.
 	 */
-	for (log = low; log <= high; log++) {
+	for (log = high; log >= low; log--) {
 		/*
 		 * Get one summary datum.
 		 */
@@ -84,9 +89,9 @@ xfs_rtany_summary(
 	 */
 	*stat = 0;
 out:
-	/* There were no extents at levels < log. */
-	if (mp->m_rsum_cache && log > mp->m_rsum_cache[bbno])
-		mp->m_rsum_cache[bbno] = log;
+	/* There were no extents at levels > log. */
+	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
+		mp->m_rsum_cache[bbno] = log + 1;
 	return 0;
 }
 
@@ -878,12 +883,14 @@ xfs_alloc_rsum_cache(
 	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
 {
 	/*
-	 * The rsum cache is initialized to all zeroes, which is trivially a
-	 * lower bound on the minimum level with any free extents. We can
-	 * continue without the cache if it couldn't be allocated.
+	 * The rsum cache is initialized to the maximum value, which is
+	 * trivially an upper bound on the maximum level with any free extents.
+	 * We can continue without the cache if it couldn't be allocated.
 	 */
-	mp->m_rsum_cache = kvzalloc(rbmblocks, GFP_KERNEL);
-	if (!mp->m_rsum_cache)
+	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
+	if (mp->m_rsum_cache)
+		memset(mp->m_rsum_cache, -1, rbmblocks);
+	else
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 
-- 
2.41.0

