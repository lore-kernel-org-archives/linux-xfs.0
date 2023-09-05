Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4477FCA1016
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbjIEVwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbjIEVwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A406ECE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso1622428a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950739; x=1694555539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEqLIpuNMCskzVKQK7VQqkaYGYOSYB2Qgvo+9csrHMI=;
        b=z50Ps5Wpnvt9FX194Q5J0Q/YYI8DvW9Z/k+N4YaS25yFHR3hupzdg5Mm/gVeGcRVWb
         DoEVx4VrqTcIegnxf6zGWe1r1hFrwe4zDbnemJHx+jFAu7GwTYo+GdsnzyWNzVJ8suCe
         J89UZKl4DIxUFonou4+i4NdFpbnPYppT7a9h2DVHKrKWrcd1ic6Ls6Vwpzd94dDcRmbS
         LONPQP+PeWjLnKZ2SjOHMnHgazt9qBZROJX+N/kwNKv2ZAj5tJWA8jKRels696NvRBNx
         4ZOdMm8ZLzyYUeSOPDWLloxgGOJJW2OU2twydKDPg3yfNkBvNJeFteysnM/FDUgyyxJw
         fVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950739; x=1694555539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEqLIpuNMCskzVKQK7VQqkaYGYOSYB2Qgvo+9csrHMI=;
        b=QWRs0AfBpnNTwX3G2c5kxf6KREGG4b5Ok10eLc8Ev3MQJC5GImXMTaDBUd+/OuHPJz
         4ObmZwVgEhJUKheQnWegMkFTYYQgh6/lI7HvO7f9wanXO/0Y8pyWIKxrzgVoqAqoOg57
         Y0afzaMuthuOeSAJNcBKAD3Zq1TYVtHqV071EjF3iZkzX2NDz27ISh35kSaH3SIATcSv
         zjxOzDdvk+6uoBssfMc0XI0sJ0iqh0eLwGpFHAGLW3tZS6awqNVsjBliJDOZFuZYrSBR
         VevAgarFusnJ/vQzRveWt6vJSiCbs7pjk1D/I4GponW/r6ugQ50qiGv57KVibHbOBEMb
         SwHw==
X-Gm-Message-State: AOJu0Yz6DN2F+bSXijyYaBYJYK6rrPrhouIsX/kAfdDYhdmbLDHkq4TL
        veUmC9Eb6yDrUvIQZJiJFbhe7S/ErCyyagZA2+UNrw==
X-Google-Smtp-Source: AGHT+IEWvm1x7UXYV0VivzFFOzrhX5PpORV6ucHOIWmotNXWCSGyLPSmgZwQug+woy+di8rHOeQaiA==
X-Received: by 2002:a05:6a20:8401:b0:149:9b2f:a79d with SMTP id c1-20020a056a20840100b001499b2fa79dmr16225906pzd.6.1693950738861;
        Tue, 05 Sep 2023 14:52:18 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:18 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 5/6] xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
Date:   Tue,  5 Sep 2023 14:51:56 -0700
Message-ID: <86972d508f56b562e1e2dc728a5b22209b56eba6.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1693950248.git.osandov@osandov.com>
References: <cover.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() tries to find a free extent as close to a
target bitmap block given by bbno as possible, which may be before or
after bbno. Searching backwards has a complication: the realtime summary
accounts for free space _starting_ in a bitmap block, but not straddling
or ending in a bitmap block. So, when the negative search finds a free
extent in the realtime summary, in order to end up closer to the target,
it looks for the end of the free extent. For example, if bbno - 2 has a
free extent, then it will check bbno - 1, then bbno - 2. But then if
bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
again, and then bbno - 3. This results in a quadratic loop, which is
completely pointless since the repeated checks won't find anything new.

Fix it by remembering where we last checked up to and continue from
there. This also obviates the need for a check of the realtime summary.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 50 +++++---------------------------------------
 1 file changed, 5 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 24c517595ded..7cbf4ff35887 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -471,6 +471,7 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = XFS_BITTOBLOCK(mp, bno);
 	i = 0;
+	j = -1;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
 	/*
@@ -522,31 +523,11 @@ xfs_rtallocate_extent_near(
 			else {		/* i < 0 */
 				/*
 				 * Loop backwards through the bitmap blocks from
-				 * the starting point-1 up to where we are now.
-				 * There should be an extent which ends in this
-				 * bitmap block and is long enough.
+				 * where we last checked down to where we are
+				 * now.  There should be an extent which ends in
+				 * this bitmap block and is long enough.
 				 */
-				for (j = -1; j > i; j--) {
-					/*
-					 * Grab the summary information for
-					 * this bitmap block.
-					 */
-					error = xfs_rtany_summary(mp, tp,
-						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rtbufc, &maxlog);
-					if (error) {
-						return error;
-					}
-					/*
-					 * If there's no extent given in the
-					 * summary that means the extent we
-					 * found must carry over from an
-					 * earlier block.  If there is an
-					 * extent given, we've already tried
-					 * that allocation, don't do it again.
-					 */
-					if (maxlog >= 0)
-						continue;
+				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxavail,
 						len, &n, rtbufc, prod, &r);
@@ -561,27 +542,6 @@ xfs_rtallocate_extent_near(
 						return 0;
 					}
 				}
-				/*
-				 * There weren't intervening bitmap blocks
-				 * with a long enough extent, or the
-				 * allocation didn't work for some reason
-				 * (i.e. it's a little * too short).
-				 * Try to allocate from the summary block
-				 * that we found.
-				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxavail, len, &n,
-					rtbufc, prod, &r);
-				if (error) {
-					return error;
-				}
-				/*
-				 * If it works, return the extent.
-				 */
-				if (r != NULLRTBLOCK) {
-					*rtblock = r;
-					return 0;
-				}
 			}
 		}
 		/*
-- 
2.41.0

