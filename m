Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98934CA101A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjIEVwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbjIEVwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:24 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B5CE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:20 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-56b2e689828so2095343a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950740; x=1694555540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79TMpmZlkF+mCJe8ZyHjkEbIu4MuNFHSnZEvMD6z4/4=;
        b=JlMW4pICSvWjptbXx63b2kOw2Rkbc/rmbbAqpjJSAiZhsJzwtkxI6mTjsf72zWBNkM
         Etir/kW8RWFGzMqTxvrEl7C6EwmwZIf2uNYyRi3RfcqFeh9r7/V2ITHGsiUuiNZjBivI
         FEbUx5xj1wAY1nRvEDPt74herVqYbFDxz3dP7wQ+QITuJBtiHofGiRAHOBJFkCvFs9s2
         0qeZlvg+4Jq2aiEaVV/w4yVNucf9NHfJi0Jiu0WSbZvv0frxwS6sAkm+ynXOVRriZpW1
         YuwDmQIejgr/HlVuUohIl/p0gnzL0cWk5uh0PX05UipNkzS9XmeB1FjR6nDK0479H4A4
         dqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950740; x=1694555540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79TMpmZlkF+mCJe8ZyHjkEbIu4MuNFHSnZEvMD6z4/4=;
        b=d3gpJNjAcB2OeEpz0bR0V/QCq9vlvqOLZPSAj1EAkEa7vHi0CV8kWeYJzU663qfNEl
         3xbBpe1YZqqgoiZseP5aoSkXf5lExL+cDtl7uwfQjs/0u4k+A1ydVnvtwKxYDVVkbL1b
         OaI9n/y+TYCkxSsPxY+MyxGoR9YT47+JVIOzsl6jf6XSqPaNbPgLSbJV9qygyGe0kDKF
         UjpD8PuS2HbfJ3OGxiASrQF4rlu4zJqRxwjauhvrTsiczgv30BryngVSOSSB6p2wZymZ
         PK4KJ4sFwQ4xnawC/fszSZtPg6y0x+84qyonH/yXJp71h6n05640Iz9sI0Zviz+mX1tP
         dqvQ==
X-Gm-Message-State: AOJu0YxB/acEKqs9Qfp3F32HP0STH5NEgTkyHTxi4glYMbt/rZaLCISJ
        gck5pc7fa/gZifZ9vUmvbyFHqMoqPF63c/dtGOdrYQ==
X-Google-Smtp-Source: AGHT+IEO5PufpgLPJS+OOLB1xK0hW6w28EJwPDa/Ai2VThafJ4Lo5Pw5FNHnNpF4SqlHM54ZxRqYlw==
X-Received: by 2002:a05:6a20:138b:b0:137:d14d:79ea with SMTP id hn11-20020a056a20138b00b00137d14d79eamr13898628pzc.25.1693950740030;
        Tue, 05 Sep 2023 14:52:20 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:19 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 6/6] xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()
Date:   Tue,  5 Sep 2023 14:51:57 -0700
Message-ID: <44220273fdbc442e963bed1cfaa4707957b49326.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1693950248.git.osandov@osandov.com>
References: <cover.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

As explained in the previous commit, xfs_rtallocate_extent_near() looks
for the end of a free extent when searching backwards from the target
bitmap block. Since the previous commit, it searches from the last
bitmap block it checked to the bitmap block containing the start of the
extent.

This may still be more than necessary, since the free extent may not be
that long. We know the maximum size of the free extent from the realtime
summary. Use that to compute how many bitmap blocks we actually need to
check.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7cbf4ff35887..1a38e981acd4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -521,12 +521,29 @@ xfs_rtallocate_extent_near(
 			 * On the negative side of the starting location.
 			 */
 			else {		/* i < 0 */
+				int maxblocks;
+
 				/*
-				 * Loop backwards through the bitmap blocks from
-				 * where we last checked down to where we are
-				 * now.  There should be an extent which ends in
-				 * this bitmap block and is long enough.
+				 * Loop backwards to find the end of the extent
+				 * we found in the realtime summary.
+				 *
+				 * maxblocks is the maximum possible number of
+				 * bitmap blocks from the start of the extent to
+				 * the end of the extent.
 				 */
+				if (maxlog == 0)
+					maxblocks = 0;
+				else if (maxlog < mp->m_blkbit_log)
+					maxblocks = 1;
+				else
+					maxblocks = 2 << (maxlog - mp->m_blkbit_log);
+				/*
+				 * We need to check bbno + i + maxblocks down to
+				 * bbno + i. We already checked bbno down to
+				 * bbno + j + 1, so we don't need to check those
+				 * again.
+				 */
+				j = min(i + maxblocks, j);
 				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxavail,
-- 
2.41.0

