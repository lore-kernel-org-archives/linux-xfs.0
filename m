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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455B5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 05:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED61164DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 05:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhA1FWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhA1FWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 00:22:11 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484FEC061573
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 21:21:31 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o7so3551053pgl.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 21:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYnbTUahMV9XJ/cK0m8mFmo4pJLhH2KktC702ivrF9Q=;
        b=cCqeJmbVKllvfHpjw0Ap71oZuqdLi9ar1WOGQ/qwl3dX0yanbuuEFMcL7hJVV0l0pe
         vYqotpnlIcTbe3fgMPtv1PswCQqhM/wlILcNReYUEVeillV2pLHsgqi8S+rd0gG/s0GA
         dEnCX+4OOfZ6CJdllRuP7wxtOm0fE7wfRV4JKtnoyAdx1UCtLSDH+/ypx7QQg6zEiLEN
         blXMJQA328UDl30F+/UyfiV0XjyEZ7RsUB6VTO1fDT/Xzc4iojF1QmlPt6eXpxZL17Rk
         k8SBtkVhr/xK/lOI3mIRvHt6QKUtOOWYZcZWRSDc+9n5H5vcQOJtm+O9MO7R65gxrhFh
         nyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYnbTUahMV9XJ/cK0m8mFmo4pJLhH2KktC702ivrF9Q=;
        b=ol3P7bjmCgsommAt78WKGUUuzW9po6w8l8KVON2L8s9OYFzQ1R5n3unXzfWGHrCGLx
         nBxjj5H+vObl10AKW8fOfhaPwsOQQcGxwLuKG/NfQSZUq73GIw9WUVikbQcqTnOnZyud
         VwteEDfpOB5MJfwlYzuzg0Y/UTd9DjW2heYWI07tpkv0zuyyNBnnZjt4GuQlBTNzc2ea
         gpQU7jcmsEueRnOpqj9Up/eKqiSDCLvvyoWoiRyEztlOR1AoMGdQZmZOqJyNPWW6W92P
         udtVY+fktjPGkzF2LDWLpl2AdEQX6hI3yo0KC4R2M3Kuc3S4bSxK1C/HKp/NLddLdRGC
         Pv9A==
X-Gm-Message-State: AOAM531DNhc/KR8yyP5n+NMQG0C62BO7Nt8/whpFK3iwtY3H8INtIAro
        tuAaI6lpvG5y3hnzSzCK11xRrC+inoE=
X-Google-Smtp-Source: ABdhPJyuM21LWgytM/iXGYsT92Gk/NyMEQEml69I7JwGu/rdLWSwDZj/k2d4565cEY6Zxidq14lr1w==
X-Received: by 2002:a62:2f07:0:b029:1bb:5f75:f985 with SMTP id v7-20020a622f070000b02901bb5f75f985mr13794275pfv.76.1611811290628;
        Wed, 27 Jan 2021 21:21:30 -0800 (PST)
Received: from localhost.localdomain ([171.61.79.186])
        by smtp.gmail.com with ESMTPSA id k32sm3551406pjc.36.2021.01.27.21.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 21:21:30 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, sandeen@sandeen.net,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH V2] xfsprogs: xfs_fsr: Verify bulkstat version information in qsort's cmp()
Date:   Thu, 28 Jan 2021 10:50:58 +0530
Message-Id: <20210128052058.30328-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a check to verify that correct bulkstat structures are
being processed by qsort's cmp() function.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
V1 -> V2:
   1. Include XFS_BULKSTAT_VERSION_V1 as a possible bulkstat version
      number. 
   2. Fix coding style issue.
   
 fsr/xfs_fsr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b885395e..6cf8bfb7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -582,8 +582,15 @@ fsrall_cleanup(int timeout)
 static int
 cmp(const void *s1, const void *s2)
 {
-	return( ((struct xfs_bulkstat *)s2)->bs_extents -
-	        ((struct xfs_bulkstat *)s1)->bs_extents);
+	const struct xfs_bulkstat	*bs1 = s1;
+	const struct xfs_bulkstat	*bs2 = s2;
+
+	ASSERT((bs1->bs_version == XFS_BULKSTAT_VERSION_V1 &&
+		bs2->bs_version == XFS_BULKSTAT_VERSION_V1) ||
+		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
+		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
+
+	return (bs2->bs_extents - bs1->bs_extents);
 }
 
 /*
-- 
2.29.2

