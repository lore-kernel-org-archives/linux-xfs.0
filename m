Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144BECA101A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjIEVwW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbjIEVwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9DACE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:18 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-68cbbff84f6so218034b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950738; x=1694555538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnQ58eB/la3/zo4l0I5471gJhfnDG4mtM0tDnSUJgaE=;
        b=hDVYyq6ZKL1DGvJNwbNvQvMesuhhwLYk5dT/CqylV0uIj6uWhom5Sl2310wvWEeQnW
         Z/HDDglvnNpUMR4YqsHV8zu1pguADy4jMKF2D+Dq5h+kmISbySnLVle/XyKY0qFXP5S8
         4W76sLrHfHUdcGEHUgb6cOLYXglMmdqyMhgErd80WUWu/P6DQw1310TziT8qnF/yNKb4
         Op0VyxYHhdd9MCM3BuaZiMRc9ECvsyHOMn1SxAuiK0QUFFDm+naWE1NXzVB6hljjA/dT
         Yn4+hMlpEgcUmgXJRzaVuFFCQS/kCXkw12YfdyTIdonD0rbyDEg02NOqvj17ufZKkJ93
         uWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950738; x=1694555538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnQ58eB/la3/zo4l0I5471gJhfnDG4mtM0tDnSUJgaE=;
        b=K0u8zAU2WlBsiT7lz8f9CNAnl9vOTZ8KDUxPK2s74qm6xFP0VuMK5l+e8kyM9Deu0r
         7cgkSiTWMGL4bf9gizok5qpGkHSwOQ8cYkJa39xVNb1pi4xbwa+xAvrKILrafSWYFPXz
         IIpBSjSDQXQRYCC/OhcW+chAjum3Oy7Lc9Kpg2YUo0QyHZUXNr7p9H/XnbNnxzEehk1Z
         ESCweszlpbELD8KzB+GQGQ9y64QErycx3dGi9GaI+8kfxx1MzGnI3B7VOlCCKw7cRjKy
         OIQmJhtZ9wgsT3fk4Q0/vdq5IZADhGhtfAYu45OSBZTVAvVDkixuOpwUSiNKcBXK5lR5
         s4LQ==
X-Gm-Message-State: AOJu0YxMZDF9EYLc7sk+Wyf5uGa973ZdW8775XTMRF3A6pFRugg9RqrQ
        gM6HOTjuwyAXq0ZNZ3KM+ePUyvP0MDsTzK02TH83bg==
X-Google-Smtp-Source: AGHT+IHcyqqPJBNpghoOmSEZjbjvQXNsOLaF+i3NN4JN+eri7pStxQzxjVO9d0eeoHtgWdtbdo9Kww==
X-Received: by 2002:a05:6a21:6d95:b0:152:4615:cb9e with SMTP id wl21-20020a056a216d9500b001524615cb9emr7939140pzb.13.1693950737670;
        Tue, 05 Sep 2023 14:52:17 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:17 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 4/6] xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
Date:   Tue,  5 Sep 2023 14:51:55 -0700
Message-ID: <913fd7a759f56ba07a6b7eaa3894d14842167ed8.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1693950248.git.osandov@osandov.com>
References: <cover.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() calls xfs_rtallocate_extent_block() with
the minlen and maxlen that were passed to it.
xfs_rtallocate_extent_block() then scans the bitmap block looking for a
free range of size maxlen. If there is none, it has to scan the whole
bitmap block before returning the largest range of at least size minlen.
For a fragmented realtime device and a large allocation request, it's
almost certain that this will have to search the whole bitmap block,
leading to high CPU usage.

However, the realtime summary tells us the maximum size available in the
bitmap block. We can limit the search in xfs_rtallocate_extent_block()
to that size and often stop before scanning the whole bitmap block.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 13fa0ce91376..24c517595ded 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -491,6 +491,9 @@ xfs_rtallocate_extent_near(
 		 * allocating one.
 		 */
 		if (maxlog >= 0) {
+			xfs_extlen_t maxavail =
+				min_t(xfs_rtblock_t, maxlen,
+				      (1ULL << (maxlog + 1)) - 1);
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -500,7 +503,7 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n,
+					bbno + i, minlen, maxavail, len, &n,
 					rtbufc, prod, &r);
 				if (error) {
 					return error;
@@ -545,7 +548,7 @@ xfs_rtallocate_extent_near(
 					if (maxlog >= 0)
 						continue;
 					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxlen,
+						tp, bbno + j, minlen, maxavail,
 						len, &n, rtbufc, prod, &r);
 					if (error) {
 						return error;
@@ -567,7 +570,7 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n,
+					bbno + i, minlen, maxavail, len, &n,
 					rtbufc, prod, &r);
 				if (error) {
 					return error;
-- 
2.41.0

