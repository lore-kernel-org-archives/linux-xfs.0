Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6073CA101B
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbjIEVwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjIEVwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40882CE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68a3082c771so241833b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950736; x=1694555536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jxdl504b6OUUpCoNagLG2sKHjuN8zj5QS9kt1kG5Fhw=;
        b=gUSjSYHxDDGkGBuHMsE17xLDu0z9pGP/tVT3fIo6F4cLTk2Hd5mNe8BViO95KVhnuU
         BjNY7rGD8x8XeI945+N2VIOzYJGs0lpwioZHwKkrW3AoNjFPzZU9lylAJmZQNK6+mxGB
         X9lSmn+lrJOjgpEZNG7OJicg7fl4X+JxpFuzk6ejz2bm48A51dWujDhxMzhj2RzC8UF9
         fsuXYVS+mkKxw2sAo4PDEQxoSR6owxj5Zt/TZwa8+OdUcx2YhR4kuvC6aLtAM2IQ/imj
         CXUkfo1sTlD3kwFAz7W1qubxuj0chFcI/dDfINDWhEiuBDesnokFXyVKfWMJ827xRBQT
         SZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950736; x=1694555536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jxdl504b6OUUpCoNagLG2sKHjuN8zj5QS9kt1kG5Fhw=;
        b=Qy5JFWE3SFZHn3Z5gXPaAI3hZ+jpE6PzJCjENiyInRnsCw54Gh9OSdJy2yxVnh/ADc
         YDTxVG1EIE5aMrAlliehtDsgiNII7iBlkEbYrtvISoW1/jF3UXBa9PhmwTchoAYdigmK
         7hxLrc//eWYYOB73cWaMPXauwZc9MRXA8ZMcqGbqu7U1shHdao6oXqd8qRQ8N5kLcB72
         NlUd84+ACSJV6CTb1WOydoK1IvQNHvLFkiEOG7ec52mVknpfxitqDyz8E0yoTQ6djb8l
         HG0byvVE2AcIUp0ZLKbWmHC7sNfKdxnD/K4hsMrjQn9Cty9Ya6SjANjMK6dgNrW4Q6Ja
         u++g==
X-Gm-Message-State: AOJu0YysgHRyBK1lQezJSIxRvCynbsz8yHUC3QQz0rMnd1koj9J+nK2A
        NZwhqhs+s9Is/JWjTrb3w7+GR5Fszx1rGk1vzeaTfQ==
X-Google-Smtp-Source: AGHT+IE/q+j9kB2b/tk6dZTn+3G7aKvVGxlfvi09LiaENK7TdCiDrqNKJy0QiPTBV1h7zo8Qh3B1xQ==
X-Received: by 2002:a05:6a00:cc3:b0:68e:2623:cdb with SMTP id b3-20020a056a000cc300b0068e26230cdbmr3616194pfv.17.1693950736455;
        Tue, 05 Sep 2023 14:52:16 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:15 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 3/6] xfs: return maximum free size from xfs_rtany_summary()
Date:   Tue,  5 Sep 2023 14:51:54 -0700
Message-ID: <2ccd484a974c2cb1f310555c588029462fee769d.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1693950248.git.osandov@osandov.com>
References: <cover.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Instead of only returning whether there is any free space, return the
maximum size, which is fast thanks to the previous commit. This will be
used by two upcoming optimizations.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fe94c5c90ba8..13fa0ce91376 100644
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
@@ -430,7 +430,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
-	int		any;		/* any useful extents from summary */
+	int		maxlog;		/* maximum useful extent from summary */
 	xfs_rtblock_t	bbno;		/* bitmap block number */
 	int		error;		/* error value */
 	int		i;		/* bitmap block offset (loop control) */
@@ -482,7 +482,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
-			bbno + i, rtbufc, &any);
+			bbno + i, rtbufc, &maxlog);
 		if (error) {
 			return error;
 		}
@@ -490,7 +490,7 @@ xfs_rtallocate_extent_near(
 		 * If there are any useful extents starting here, try
 		 * allocating one.
 		 */
-		if (any) {
+		if (maxlog >= 0) {
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -530,7 +530,7 @@ xfs_rtallocate_extent_near(
 					 */
 					error = xfs_rtany_summary(mp, tp,
 						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rtbufc, &any);
+						bbno + j, rtbufc, &maxlog);
 					if (error) {
 						return error;
 					}
@@ -542,7 +542,7 @@ xfs_rtallocate_extent_near(
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

