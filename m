Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8593ACCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiGRUa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiGRUaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE32CDD2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k19so10082816pll.5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0tzSzW3nfswfRmIT2D8fQpUvcD4q8gAEkbhrIWUFuEo=;
        b=lwFGPfsEnotRYrHiJHss5JTL+M8N1PlDyBwgF67W3rH3u6dvvuTrZLt2zjxWsoyG46
         MOr5hGw4HYaQTbTT0+NrzE+0O4GQsAExIcwURQXU3mjVNnM4r24x1H6J3ElxLeVNvC4T
         Og/wuKncbXvFO9EmoAB+IzsEqpOR1+SAt5ooKmj6Zh2VqYW2Rmm6JhYKEk5jVsb2VQa5
         ZfzHiKEu46IOzvaQPJjM5PK1dhlII5eMXdJZ4FamsKQRCAkMqudXBeAPmDgCgWJ9l8pj
         bnaOOika3fRbHz6Cf7WUvbqv4Iqs+hScyT71IOQrf/l+lhuj7hTYQ4qIG4MSfai+87IN
         O75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0tzSzW3nfswfRmIT2D8fQpUvcD4q8gAEkbhrIWUFuEo=;
        b=5DvmnDcIjE1UMlKXEcYoblo99DckJDrBRGf5JbuVC2gT3Xyxc8Qc8cqIq81aaiG1Eu
         KGCWbYS8DLRrYBjMnUUAQvye3IWFiDT/LyajKApUcWyDVdUGss6sP3pRdeRM7vYNLmV0
         Cp5UKhsXL0nhs31oDKW/YuhkatN5yReevRAywdOaJ8avd3VNVbj1WteLxybicPo8GGBh
         rMFPQO5HHk/umkp/MjkBQooaOtymLorGKGJ94gSquIvsbVoNkhOvwQhfs+J/jmGHdZ6y
         4zuHxVrmJUWP1zNPyTNb9SjzPm/SgvTyRnK51M9/6piV2apBjFpdWpr/SoyovurlioIj
         Pytw==
X-Gm-Message-State: AJIora9/m03gtn2+MGdU5D6x3A207eJo8/k14js3VNfcZZGQTu2qrdbr
        XQMtI/dWhGAPOBTGzuVhtJ0dY6jACXXDyQ==
X-Google-Smtp-Source: AGRyM1tJFTsUpcGaH0nRDewbHU67j4PxcOhmmXhfVB/ADnmJ13PuHOcJfLTQSgF9qjQKHRvHbWPxcw==
X-Received: by 2002:a17:90b:2243:b0:1f0:b0a:e40c with SMTP id hk3-20020a17090b224300b001f00b0ae40cmr41502839pjb.76.1658176219661;
        Mon, 18 Jul 2022 13:30:19 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:19 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 1/9] xfs: fix maxlevels comparisons in the btree staging code
Date:   Mon, 18 Jul 2022 13:29:51 -0700
Message-Id: <20220718202959.1611129-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 78e8ec83a404d63dcc86b251f42e4ee8aff27465 ]

The btree geometry computation function has an off-by-one error in that
it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
This can result in repairs failing unnecessarily on very fragmented
filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
the per-btree type computations will make this a much more likely
occurrence.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_btree_staging.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index ac9e80152b5c..89c8a1498df1 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -724,7 +724,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
-- 
2.37.0.170.g444d1eabd0-goog

