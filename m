Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EB6C25B0E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbiHQA4d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbiHQA4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD02580523
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t3so2832240ply.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=XkVWiVO/xUKGLRxCEo9Yy4GghuXBXo3Nu7XpnuB8y9I=;
        b=L9AkGs2tb3pZo2Z67s/7PC4BR0daGeRUI/2eFHnASHpow6cKW2qN9RTXxV+LdDijFb
         LBi3F2Ou3DoRzckAnodrTs6rdCVt/aA/iIAtZ6qGp+zBfRzkGHVq0ZtPVZR0dSL5yADs
         4Rh0Tzd/d4V9PyMtZ1tfl+h3xsZ9HqbV0CXB8Anaxjf7U+SutOmMFXSeGDInbjVXacr1
         6mwx0m4OWA03uAtMbuwnaG2pewaY3Z3AHBCfQz3cAB+L9nbWUani1rsfTLW0G1zk1gRk
         DeNLWYD+5zzIIeIiLa/TQxX7u2pIIP91j3CDS+xW0al0CCiiGNRGAnBNV76AyRfDxYQG
         iZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=XkVWiVO/xUKGLRxCEo9Yy4GghuXBXo3Nu7XpnuB8y9I=;
        b=anXxiVbWTX9aXIBa9jwBIILBPrmeroM0xIMxhTh9oSlAykswwwiUEwKDi+4s5CP/5f
         uT4N28NnEt+zrCV9iAguO+PziMe6DrHAkZQDGyDvFjfxEn9UtD2JV0q+rlU2VnP+LWeA
         oDWKgpySMpvN5DXtWcbRRnBz8Opw3PbSDIfXZfccsm0JZ7J8czrQIc0ddmEvtCT+SLe6
         GpcNRmxeqJbAR3Lae+ryO8JQHgCQ/HYK3oq0ULxllqgOI68f0WCFYtk4F1BpmjMQSeay
         A3gdMSb1c3CaR2vumdiNa9dV4JisUy0UES8iNcxlZiSW/GljnvG2HSHpZoGR9yHzMVMe
         hEPQ==
X-Gm-Message-State: ACgBeo0852OuWGCmRecR8tjxWdUzbExqU5LoJ7e3z4tNCNJF0Vxk9B3D
        6f20+2kKvj4eCfguSwEexebzVCYy703C6A==
X-Google-Smtp-Source: AA6agR7BCIaGnS10g154yxIKdd/VFAlgF+xd32CeXBmF8pIpdLRjrTI0xyTiytpwtQNwxAviZl+P/w==
X-Received: by 2002:a17:902:6b0c:b0:171:325a:364e with SMTP id o12-20020a1709026b0c00b00171325a364emr24021786plk.150.1660697791175;
        Tue, 16 Aug 2022 17:56:31 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:30 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 4/9] xfs: remove infinite loop when reserving free block pool
Date:   Tue, 16 Aug 2022 17:56:05 -0700
Message-Id: <20220817005610.3170067-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc ]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_fsops.c | 50 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 710e857bb825..3c6d9d6836ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -430,46 +430,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
+	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
-- 
2.37.1.595.g718a3a8f04-goog

