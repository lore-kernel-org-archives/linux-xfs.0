Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50F4C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80BE229EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbhAJDbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbhAJDbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:03 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE05CC0617A5
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c79so8860243pfc.2
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5kFpmp/fOA8CTCegvBQNEGv0i+BdgucZ7JkzQebLYZU=;
        b=YJYXahcM/a0vEZpnezHv52trOWMdnasUhmCTI9nHncqJ7SSecTJoUJBgY1gH7JbpeY
         5FNW1ngIblfrTFCjynNqNCL0EaK7Sr/xCM8SF0YGGo6YdfvE4sdogTzymHhzbHJf1DKL
         Ey3yJhdoLgek/pcXDVvCihv/pZxnRZLbjdVNHBA8tbIhaT5Z75mHq/4YL8OfZtZRD9kS
         sU9KT6PGHj08evOTy+dNk1Ik5XCwyZPC+cuu4Iyxs144e4mwYAboBYzZwEaV3DSgRVQ8
         da1RcsmZxSotcyZbUXjaxg2R/amWPCdEjreTTcX4ONyvMPC4qNqL06/HOMxHBzPznMLF
         z4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5kFpmp/fOA8CTCegvBQNEGv0i+BdgucZ7JkzQebLYZU=;
        b=FHsLMxq7Lx8FNes5oli99f7cflIimIen6UEq+XGX45DUddWczKxNsM91KM7QpnOjzW
         xTpUAp859dDvtAHSOIto0gv0knR0tC7PnaoKWoQKbd5dejQen0JQhFq7GGueIjQqh8Yp
         Pvc4mRomDf3ILUBKuGZ35bn1KM0BLXQfLRFgoydp7nn2qIU6SdahOwTjhO8LW1PFZDq6
         n7OC8U7rlUnXckSoipr1dwvG+/ZbhrLZn7G19BA58BM1Yl7eNuWtQSnvSlxT3HtuXAE6
         ZdigcSkPwXwEPYxejj6Ayl6qjRSMn4iQm0pxg2fr/NlqOzNOrhgfnmEAvHw8fyDQgHbN
         6OPA==
X-Gm-Message-State: AOAM531Sz/iAHOTV3AT+wIwO6EWkRvRHQW6N4gGbIJCo0kDyU/SDYGSN
        9WmCzw8eGAuO7EA/9qKYS9bvQ4pqC8Ik1Q==
X-Google-Smtp-Source: ABdhPJwcWKdrvB9RWttAfN6nYS2iB5u4955NhHBRhuemIwv4omP60+XWSiAUAxTXXz7qavhlFs8iGA==
X-Received: by 2002:a63:f608:: with SMTP id m8mr13779998pgh.11.1610249393322;
        Sat, 09 Jan 2021 19:29:53 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:52 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 05/16] xfs: Check for extent overflow when removing dir entries
Date:   Sun, 10 Jan 2021 08:59:17 +0530
Message-Id: <20210110032928.3120861-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry removal must always succeed; Hence XFS does the
following during low disk space scenario:
1. Data/Free blocks linger until a future remove operation.
2. Dabtree blocks would be swapped with the last block in the leaf space
   and then the new last block will be unmapped.

This facility is reused during low inode extent count scenario i.e. this
commit causes xfs_bmap_del_extent_real() to return -ENOSPC error code so
that the above mentioned behaviour is exercised causing no change to the
directory's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 32aeacf6f055..94063ac1d085 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5151,6 +5151,23 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC is returned since a directory entry
+		 * remove operation must not fail due to low extent count
+		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * by letting the corresponding empty Data/Free blocks to linger
+		 * until a future remove operation. Dabtree blocks would be
+		 * swapped with the last block in the leaf space and then the
+		 * new last block will be unmapped.
+		 */
+		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
+		if (error == -ENOSPC) {
+			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
+				whichfork == XFS_DATA_FORK);
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-- 
2.29.2

