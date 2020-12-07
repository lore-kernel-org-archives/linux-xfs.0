Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2256CC1B087
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 11:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D75862336F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 11:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgLGLlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 06:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgLGLlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 06:41:52 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F2FC0613D4;
        Mon,  7 Dec 2020 03:41:12 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id g18so8684509pgk.1;
        Mon, 07 Dec 2020 03:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6zSVjtY1d9QALf7Z3xafnrnUyNcyTc7ZED1RIPazjEI=;
        b=KxwUY1pPb0NY86JdyT6q5w1gHjaBb1YoY11kxscYF/JFZnmMFJ/3yFbu1Ajoc1ZTH1
         nkypYvmgxYnCinz1YiEgu3RtEa1yc+JOrrtccu0M9D/WK+USkFjlSAApYoeFMLSdNV6F
         pMoTl2T9Z4GF2exfrpvcOaD/rTLj1LukbXuZqNgWQlhrhzLfgQuiC5reYQj7Fu0J6VQu
         Mu55MxZKrBUJD0mjVOMFr0EoeoQY/Hxu4PDiKRuDmxe8xsBfNDsy1X4qlSSMuR1sjvAg
         mQF8YkfRHWS04JWCLRpcEskGTxp6oE9/Us+584eNRC+c2sVxSfhYbmjUiR99eIvlGuK5
         YOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6zSVjtY1d9QALf7Z3xafnrnUyNcyTc7ZED1RIPazjEI=;
        b=WHVzwU9lZhuT2pTvO6VaiEhwqSz3QxtNFK5gSsfbifUDwW6xVxjoHZKbAf0pap0Vji
         kZpdsoxYOTnXbCLOm6YzeqPT1AjInBgOKmo0lLQ96oldiftiPBGseoL6FaBDfDQH7az6
         oKxN0a0GfwWKrAyy0g/vp5Byza5/R1uG0B3wctGOrxLv/3AtshvleG82iiJZSjSKtR9Z
         +Ipv0lOKb66DORmVu5tFpUcnYbAh+Ggt3KiPLYORK/Wwvuz1vciF/uzuXfkxjJMkZssm
         TChpIX7/0aUHm0z755wsvE41/NxhWVpBra9N1GWkkiVxvVVabjerc16w3Fh2lU2Miois
         oHhg==
X-Gm-Message-State: AOAM5300EZVv1hw6dughSpCD4lf6f8xuFSqmpyzqEEGfXfR2AvmunNdT
        7M2iVtuZyAhPDcuTXJ+YY1euvHV3Wg==
X-Google-Smtp-Source: ABdhPJxR74EyYf3Tj+iR51lak5YJkseWhVEZDrHiUSA9VbSCSYrX/ojLzV/cYaEfdvE0ba3aXcXyMQ==
X-Received: by 2002:a65:5949:: with SMTP id g9mr18267968pgu.52.1607341271339;
        Mon, 07 Dec 2020 03:41:11 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id q35sm10503888pjh.38.2020.12.07.03.41.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 03:41:10 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     fstests@vger.kernel.org
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs/513: fix the regression caused by mount option uqnoenforce
Date:   Mon,  7 Dec 2020 19:41:05 +0800
Message-Id: <1607341265-24200-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The mount options uqnoenforce and qnoenforce no longer cause 'usrquota'
to be emitted in /proc/mounts, so there is a regression in xfs/513. Fix
it by using proper output option uqnoenforce.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 tests/xfs/513     | 4 ++--
 tests/xfs/513.out | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/513 b/tests/xfs/513
index dfb25a8b..9045dbb5 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -302,8 +302,8 @@ do_test "" pass "usrquota" "false"
 do_test "-o uquota" pass "usrquota" "true"
 do_test "-o usrquota" pass "usrquota" "true"
 do_test "-o quota" pass "usrquota" "true"
-do_test "-o uqnoenforce" pass "usrquota" "true"
-do_test "-o qnoenforce" pass "usrquota" "true"
+do_test "-o uqnoenforce" pass "uqnoenforce" "true"
+do_test "-o qnoenforce" pass "uqnoenforce" "true"
 
 # Test gquota/grpquota/gqnoenforce
 do_test "" pass "grpquota" "false"
diff --git a/tests/xfs/513.out b/tests/xfs/513.out
index 6681a7e8..eec8155d 100644
--- a/tests/xfs/513.out
+++ b/tests/xfs/513.out
@@ -76,8 +76,8 @@ TEST: "" "pass" "usrquota" "false"
 TEST: "-o uquota" "pass" "usrquota" "true"
 TEST: "-o usrquota" "pass" "usrquota" "true"
 TEST: "-o quota" "pass" "usrquota" "true"
-TEST: "-o uqnoenforce" "pass" "usrquota" "true"
-TEST: "-o qnoenforce" "pass" "usrquota" "true"
+TEST: "-o uqnoenforce" "pass" "uqnoenforce" "true"
+TEST: "-o qnoenforce" "pass" "uqnoenforce" "true"
 TEST: "" "pass" "grpquota" "false"
 TEST: "-o gquota" "pass" "grpquota" "true"
 TEST: "-o grpquota" "pass" "grpquota" "true"
-- 
2.20.0

