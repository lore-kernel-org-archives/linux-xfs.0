Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F07C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbiHQA4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiHQA4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F380343
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t3so2832256ply.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=fyIIT2N5PL09XzfXBhsbErymud8ro3KUs2QXSQi1HNY=;
        b=qDj5sZuBy+JpHHx2I2ZcwgK9wnOVgSwSTVJjrcSvBer0eTf2uQvz2O6A6VLeCgj0t2
         WoNNVi37PM6/tP/eFcUa2WvhI29IBYTBUIoh69/T5X0S8lhS7eYHPFsj8IgUQgXKaPGc
         jLnufhGpqx1SUEmsoV/lXqxszVio7HSeTVL953EHB1RFtnn8TtL5qzVDUCzAyRMX7nF1
         SC4VB9WcIpnnQ3lJQYVc1XYzDn7uEFz0+aNuUUT09KPGbMk2WcsbKv622c+mcD9binBE
         0PcEi+nfGFEr+rjSZACgv7T7a6oDGrUjf5doCOk65h7NbwsjbAVTpXX9SqkpWqJ8Xupb
         dRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=fyIIT2N5PL09XzfXBhsbErymud8ro3KUs2QXSQi1HNY=;
        b=C7z19kJA0vM22MdUNNAh6s6ltOCyegcFN92ldTFMjU11gq0UaCbEC+7Yev8U6KWrS9
         4FuPfbuUkLmnQveMnpRSrUuejkNBo2VNFH0OzsyOTkyecqsHIpkAlSfJL9BfeBbvZkwt
         2Cq6LFBOTfYlzfrU4OEXu6/H+7EExrP6ZEzes7t6GLabO013Pq3iN9pi8/Cf9ETlU+EM
         I14beWVMBoDnkeCTFyoSwt9GJtjQLKUzCHD3q8tqmDcQTxdGHGSoyrdN37HaPT3RpK3E
         PB0vl98dS7ffGWCtH13c2ws80VdFkwyn85L7O2qNkV/Gi+x7CAEXeVcV/HZh/sGqMWLA
         bynA==
X-Gm-Message-State: ACgBeo0EEnBfPROaES/vThdJ3HrqS+WkNJiHsfbOsK0pVvpZpSxoMt2Y
        ewrH4puAHz2yxlx5OWaomG9WrCzIVVsp/w==
X-Google-Smtp-Source: AA6agR7RuYI2mZGDycLpola7DpVxaFWb4wr2eKFLcu+dZVtPjYfZ84iopATj+Vg7EplyszfGq1Ka2A==
X-Received: by 2002:a17:903:2286:b0:16f:8f52:c952 with SMTP id b6-20020a170903228600b0016f8f52c952mr24735091plh.126.1660697791989;
        Tue, 16 Aug 2022 17:56:31 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:31 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 5/9] xfs: always succeed at setting the reserve pool size
Date:   Tue, 16 Aug 2022 17:56:06 -0700
Message-Id: <20220817005610.3170067-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 0baa2657dc4d79202148be79a3dc36c35f425060 ]

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_fsops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3c6d9d6836ef..5c2bea1e12a8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,11 +434,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -455,10 +458,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {
-- 
2.37.1.595.g718a3a8f04-goog

