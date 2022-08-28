Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC26C0502F
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiH1Mqh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH1Mqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132773A485;
        Sun, 28 Aug 2022 05:46:36 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay12so3035868wmb.1;
        Sun, 28 Aug 2022 05:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0DP2J2v+ugvsFOzrB/1jYykF9jBGuJcfo1ru3XQns8Q=;
        b=Wg+Am12rKbPWfdVVjPGqGuBBwQRJA23M2sIPODSi6MGBLLRfWAKpb6xznxPR6ikbFu
         oE+YAUwr+zzT66rpLNj23RQIY4eGrQesKih2ZSGYojPszGpQ3/jnPiiHDcqR4MuGLNq2
         C6x+TB1GcjokXTayvPqQHJ2RTgRoai1uJalvPbqEcoOSR6TcpL9ypD9TgTWGSUFEeEzF
         Tmn1jf0mC8raHicFCeZfJIHG9/8UUoEOig8/XAHBiH3WOmORo8Zr7K53Cetld9xkuKbG
         VSzeX0g7YxzCwrEnr+zOkzyxpv8M95M5KNSYSBX24RhTEUDKPV5gAlN8xrbakQi7PwmF
         UVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0DP2J2v+ugvsFOzrB/1jYykF9jBGuJcfo1ru3XQns8Q=;
        b=YQIYesusKf0kUaXUI7Wfu9mshOox+kD4epPDJd5z+K/M5nP+QeFcsuSdydDzigcPId
         e+BuylURudKXkb7ihuR4UeGNu7RBGpM8LTg7YKI+D8bufyteB9s24wA545mCb9vuW4fN
         fYhqbjEtJWt19zrOgwNiWKXWJl/TJyKEOqZ8uRK45glP5bgM5CZg1XKufIyrabz+1LeE
         R1hBBQJIFNSsxfBmQTt6PDJnv1rxgv0Em0TkbWPp59XkPK1inkaj2Ihfgtox6aU560CP
         GpaUQmalZdTBFperN+prPk8A7gH+JXi8RhvxX2Sm31+xx4Zzrb/EWyZKFxRu/l/D73Ql
         t33Q==
X-Gm-Message-State: ACgBeo219Zmsnhci+yKeOUiymrU6ovjw5oLvfRJLly268V8ydIunR9A2
        dKxGsF0EARxKes3+KxVoYTFcG3oaOkU=
X-Google-Smtp-Source: AA6agR4Cajkmg6jB/CV53fsS1jwJ6v4LOVaKrDbdGBXtoid6LvPy8xcvMZLgMyLMMoMURIYuPOIpGg==
X-Received: by 2002:a1c:f20d:0:b0:3a8:4176:139b with SMTP id s13-20020a1cf20d000000b003a84176139bmr1687304wmc.177.1661690794610;
        Sun, 28 Aug 2022 05:46:34 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 5/7] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Sun, 28 Aug 2022 15:46:12 +0300
Message-Id: <20220828124614.2190592-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit bc37e4fb5cac2925b2e286b1f1d4fc2b519f7d92 upstream.

This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.

XFS quota has had the concept of a "quota warning limit" since
the earliest Irix implementation, but a mechanism for incrementing
the warning counter was never implemented, as documented in the
xfs_quota(8) man page. We do know from the historical archive that
it was never incremented at runtime during quota reservation
operations.

With this commit, the warning counter quickly increments for every
allocation attempt after the user has crossed a quote soft
limit threshold, and this in turn transitions the user to hard
quota failures, rendering soft quota thresholds and timers useless.
This was reported as a regression by users.

Because the intended behavior of this warning counter has never been
understood or documented, and the result of this change is a regression
in soft quota functionality, revert this commit to make soft quota
limits and timers operable again.

Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_trans_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fe45b0c3970c..288ea38c43ad 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -615,7 +615,6 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
-- 
2.25.1

