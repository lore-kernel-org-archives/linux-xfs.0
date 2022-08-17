Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4000C25B0E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiHQA4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbiHQA4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C280523
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d16so10686342pll.11
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Zprllmaib3Ls51JEKLimnjC1a+vQaZilr7cJypYu1MQ=;
        b=F+lhvgLS+nrHyGPghaMnaQ25dUYJFsJRiKqCEGJNfkCOmdTgyd9l5leDHMNlPkyrd/
         24BbwL8+g1Bt+htweiWZqZw+P6Hcuv0Rv3oWyGXEAn7yUlQmXu3FRneELqKdcCi9Bfnh
         oJJcLUREgLyfxk3clepUHuRjJzNJFv1KVIr6G2NhyoiS16FTCaX9ATlmKhuaGKecAUHz
         fdBRdXiMRTyblMh6w9acQeJEXOs9Z2DDgaLu0DRc1AR6Mx2CMbqRfTDcPyNQ6M5915gA
         aAdd8uHz6XVtjYmwPSKNJdvUP5cGAxHmrNgz0+y2JBAbB0p1F2dbdschJj90cC44NB77
         3Wkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Zprllmaib3Ls51JEKLimnjC1a+vQaZilr7cJypYu1MQ=;
        b=adzSst7i1cAr4XT2v6Nqqd2SAclJI22DcqoBI4MmRm60E4BDeXO1+UKkqLSdT0l2PT
         FHCwseiSscHni0I64AzlwYIpX2lOzRfL8yxw/uwcd37Owv1/SqhJlrI62pA6C2R2fV80
         COrxvcCMCE2X0O+PK94AD3tQ7TbwMT98GO/ctfBNadqanmSqYOX7kLSrvspBl/eVxwUe
         ShGb1I4eCE5dMotcnjVIDd65DiXUCz6LwRjAmUg7t3jCEFB0Vjx6DW7Cb4Rz+xEr8rao
         h7R3wsF1teqO28nJFCAu8jbVNZqFN+Z9uc+IR16RnOqzUsahZCXqNbaNZNmljsZzWrkp
         xOog==
X-Gm-Message-State: ACgBeo1fLuLzuUKy5OBtRevcPH2BAtJCtegYW9vqfAB+XY444g9JTScM
        MsxXU8YTumdDAUxowL7VzuWeMYxLL1bU7w==
X-Google-Smtp-Source: AA6agR72G509fqcetF5eA2TJwQKPsLbvMQNtMxGNt6zAq3JJjm+5xmqHA1MrJpYJvFv4+9mb/quFyA==
X-Received: by 2002:a17:902:e890:b0:170:c2f:cb4d with SMTP id w16-20020a170902e89000b001700c2fcb4dmr24365280plg.114.1660697792809;
        Tue, 16 Aug 2022 17:56:32 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:32 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 6/9] xfs: fix overfilling of reserve pool
Date:   Tue, 16 Aug 2022 17:56:07 -0700
Message-Id: <20220817005610.3170067-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec ]

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5c2bea1e12a8..5b5b68affe66 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -448,18 +448,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {
-- 
2.37.1.595.g718a3a8f04-goog

