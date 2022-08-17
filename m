Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DF4C28B2B
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiHQA4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbiHQA4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CF380343
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t22so11170301pjy.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=WDb9aEZliPejuLd3dSdvbkRV1lWv2feqDEDVspFqbTw=;
        b=VGvt+8ztohvM9a0HJFADDi/nWAKzRqtcSmAfpcN7megMu8ByEfID6OU/Ik+hvgZrsQ
         FfqbX+WmkVBoTVZbqU7eTZtlXUuIVchBXwgHJRunJ+PQwqCTDBZzv8BiSHZCdKtFl6sy
         s6CaGmCE0uGSGqYE9zz+Zf60SjHhvlUsGKWrHhFE+Ci+goySasuEJuC7MFlHh0TejUH0
         sqnVWkjEYS0l08P8QS02bbPg+25tHRfVPkqOlt76A5z4qmo/Jn1GyVE1xH8iq5azPYMl
         WegMyezljdKWZKRy0Ex8LTP9Wduqi5QVZZ5NYv+oFrWE2F5wYZTLTNRUl6/jjl7kK3Lg
         Xh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=WDb9aEZliPejuLd3dSdvbkRV1lWv2feqDEDVspFqbTw=;
        b=F1EDSERysL+mlf4GowAZ2XnFNNWDLnPYOcSafF0pv3SbrRmAulMLgHS5BaYx5Hp9yf
         QOc7J3M5dxNidnm6h6l/kPlnWIJ47jfJ5dJxgN/vcBmEWjqvs/28eV5uK9SNkU5oigMF
         f8RFl099N6xxiR1cOuacaDcf9uWI/2oa4nALCuhSEzC6c5gkMLqBhWFeK0rbJ+6ZL9ps
         JL63p6K+YuEGmLi5Enyp5sR3VI1Frv5OBpHzH+Rms+wWPip6PYFp+qApIU7lCzIsaI0a
         hhv1k2l5+MbR7fQ4lnJFAljqmh+3ytZY7mgICAXJG4H2HTj4rHBi07sG1/MkKJGAK0Ms
         h//Q==
X-Gm-Message-State: ACgBeo3nYa4HCqgt/Mfz8IvzL07OA0hpMtPoIY119k/+HPwXVxT7jylQ
        WVnQamoRTYEH8ju/sRqHEtLmhaJHlNDk0w==
X-Google-Smtp-Source: AA6agR5ySuOIQa6i9JseWTKGk1SvAnsx3Y2XJudq/n6POA8O7fae5wAtUc1JtD9a2aVld4eTjB9q7A==
X-Received: by 2002:a17:90a:c402:b0:1f7:75ce:1206 with SMTP id i2-20020a17090ac40200b001f775ce1206mr1240039pjt.68.1660697794111;
        Tue, 16 Aug 2022 17:56:34 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:33 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 7/9] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Tue, 16 Aug 2022 17:56:08 -0700
Message-Id: <20220817005610.3170067-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit f650df7171b882dca737ddbbeb414100b31f16af ]

The filestream AG selection loop uses pagf data to aid in AG
selection, which depends on pagf initialization. If the in-core
structure is not initialized, the caller invokes the AGF read path
to do so and carries on. If another task enters the loop and finds
a pagf init already in progress, the AGF read returns -EAGAIN and
the task continues the loop. This does not increment the current ag
index, however, which means the task spins on the current AGF buffer
until unlocked.

If the AGF read I/O submitted by the initial task happens to be
delayed for whatever reason, this results in soft lockup warnings
via the spinning task. This is reproduced by xfs/170. To avoid this
problem, fix the AGF trylock failure path to properly iterate to the
next AG. If a task iterates all AGs without making progress, the
trylock behavior is dropped in favor of blocking locks and thus a
soft lockup is no longer possible.

Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6a3ce0f6dc9e..be9bcf8a1f99 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
-- 
2.37.1.595.g718a3a8f04-goog

