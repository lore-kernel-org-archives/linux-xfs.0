Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD586CA1016
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjIEVwT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjIEVwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2041CE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68c0cb00fb3so2596496b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950735; x=1694555535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky2gHWUAbFI9EyfwMCFEM1par4b2kA2XwLUE/PHTTfM=;
        b=VTZXC5LrhLvE5lIkbLfEQMGSEakljwMRkz8W0BBGvib+iMGSNhKGtyN8njk6uXoUl+
         lkImxdnQWVNwvIL3N1p7tqKJtVYUUMA1M9Wphomv2EhKKbVwdMFWmjeJyFj9vlNY+hxs
         6QRfHGUNoA1PNEufdSLhP+a/7xg2zdkqOQiJLkz7D4+SfRVztG10YkDw2QkdemQn7RBa
         VfAhepHeWosE5Y6UOLz/HiVWAfPN4qtJcuxCD+Lbh5aWyaC1P2y0PtM/IjUpBnu/xqKF
         zhRMsyQRK3HaIbY32cXQ4wDr7TML9fOmrHsKPFYANl37bKlodo1KS66DpdsoxnWKx/Fv
         Qekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950735; x=1694555535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ky2gHWUAbFI9EyfwMCFEM1par4b2kA2XwLUE/PHTTfM=;
        b=QJ+7fbAI+1adOgrxYD65tWsZUFrZRHJZ8OmKcrhzMs+SBU1lVLZy47jLGF/77mtJzb
         xDHtdTxWcfnVPXG+MV7V/nCi/AoOWYcX8JgAHlPX9cS8CpR8zjoo6YrLL3Od73PFgX+v
         iXbnPVDRHWnL2PfmTXELEra4Rip/alqNTV8IJQIVsKcx3iVeJ4pWtG4YASg23cjd5LAT
         b+PNhDwOx6FsQW1fL/mMe8Wbqr6c+tLMF7J08obqDgBi5y0dERSeQ0b+uPOlZNpshWqP
         2mio2A5YpUkkJPe4/qU9bwjI+NziNmyfiAzoHGlWEjDI/bS/sLVso4nKWJHkKAPeps9J
         3EmQ==
X-Gm-Message-State: AOJu0YwAYaiYdaC1aduoTDZZ30jDNR9DUweH7F4Vy/0e9ofJPBuaevOq
        ahQ8a0IH9kjUoaKEAujtFhi2MCqJKyqyfIyC1umrpQ==
X-Google-Smtp-Source: AGHT+IFegYFzATQKQLW9m+FMHJD6SqHKXE1sgF2mtzHnEH4oDZwUPfmMXcn2hFP8lJfugRketXgrQw==
X-Received: by 2002:a05:6a00:1d08:b0:68e:27b6:c2a0 with SMTP id a8-20020a056a001d0800b0068e27b6c2a0mr1728261pfx.29.1693950734984;
        Tue, 05 Sep 2023 14:52:14 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:14 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 2/6] xfs: invert the realtime summary cache
Date:   Tue,  5 Sep 2023 14:51:53 -0700
Message-ID: <4fc64e22c4c8d21904114ef968058e9a73af7d20.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1693950248.git.osandov@osandov.com>
References: <cover.1693950248.git.osandov@osandov.com>
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

For example, if the cache contains:

{0, 4}

then there are no free extents starting in realtime bitmap block 0, and
there are no free extents larger than or equal to 2^4 blocks starting in
realtime bitmap block 1. The cache is a loose upper bound, so there may
or may not be free extents smaller than 2^4 blocks in realtime bitmap
block 1.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  6 +++---
 fs/xfs/xfs_mount.h           |  6 +++---
 fs/xfs/xfs_rtalloc.c         | 31 +++++++++++++++++++------------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 514010a9cfe1..c39d08c1a077 100644
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
index a25eece3be2b..f9d0588da585 100644
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
index ca0c4d33af5d..fe94c5c90ba8 100644
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
 
@@ -881,12 +886,14 @@ xfs_alloc_rsum_cache(
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

