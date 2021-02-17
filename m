Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13DEC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Feb 2021 22:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CBF61494
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Feb 2021 22:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhBQW1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 17:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhBQW1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Feb 2021 17:27:40 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9963EC061574
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 14:27:00 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p21so3751396pgl.12
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 14:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=892G3qKDpz/5gRCzV0/+a3FQcJ0YSGO+MCpBh5ooPEU=;
        b=dJgZjO2lR3aAW1KhB5+C00IIIBI/vGU6hugyRbRGn5c+IHiRHRiEJCo4fV9EYeX1bX
         OnG6Vs4AyI8Q/6LIrcq5sw72iaFi7tBYLsIZzJrH1usePdVTfUGMQwMFJalHOWvhdIvL
         KmxB7vtac9J9lWdlRf1EAgOPcB6bFJd4JcJ9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=892G3qKDpz/5gRCzV0/+a3FQcJ0YSGO+MCpBh5ooPEU=;
        b=gQ9zn2BrGWDi4RnKmrYFx7/ofSNs5HBfubdoHrwDkACkVFd36G7VNQHwVBjFdd5sJU
         4DnJx23W50vJ3vea3wgWGgZo439VPuk5BnRTvEFKXk+s0hrdKzeP+fyLlONyZrztGueT
         5KNZZPhLrjZ+eftX5xoYAQ/CSqB2LZxiSQKdIsVDqrz3UyP9auCS6n5yC8mf4CNgpMmj
         wE0ThSY48A0QBJ/U1oqaASISVhtp5RLwBbttlveeB4s0n8w8LhP9Pz94AqwhZ0qIkrqm
         CO2V9n3S20ST6bMhEW3gy2nSoSCCAbSGpN9/uoURXJk74zrQ61TGH7yQrMx3YuotEdCW
         yllw==
X-Gm-Message-State: AOAM533YcjIEGCiUoj+ZZ6ViV1IgxIZQKD3d2HjV+OfPpJV/Fvars3Xb
        do1gwyISUB5tV9lA/Z0C0yu4fvoSirvS3pm5
X-Google-Smtp-Source: ABdhPJzV9PLDnFU1a58nKDKiPsXDT24pi1Mr/DKUbml8PhEY5qKGxZ8uTSmMWa0JUOPBGgLDgBu6HA==
X-Received: by 2002:a63:d502:: with SMTP id c2mr1259893pgg.353.1613600819996;
        Wed, 17 Feb 2021 14:26:59 -0800 (PST)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id b25sm3442803pfp.26.2021.02.17.14.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:26:59 -0800 (PST)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
        id 2BC7E251A6F5; Wed, 17 Feb 2021 14:26:58 -0800 (PST)
From:   Markus Mayer <mmayer@broadcom.com>
To:     Linux XFS <linux-xfs@vger.kernel.org>
Cc:     Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH v2] include/buildrules: substitute ".o" for ".lo" only at the very end
Date:   Wed, 17 Feb 2021 14:26:56 -0800
Message-Id: <20210217222656.1762426-1-mmayer@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To prevent issues when the ".o" extension appears in a directory path,
ensure that the ".o" -> ".lo" substitution is only performed for the
file extension immediately preceeding the ":" of a makefile rule.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---

Change since v1:
    - reworked the regex as suggested by David
      https://www.spinics.net/lists/linux-xfs/msg49712.html

 include/buildrules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildrules b/include/buildrules
index 7a139ff07de8..f6663615d278 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -133,7 +133,7 @@ rmltdep:
 	$(Q)rm -f .ltdep
 
 .ltdep: $(CFILES) $(HFILES)
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o: ,\1.lo: ,' > .ltdep
 
 depend: rmdep .dep
 
-- 
2.25.1

