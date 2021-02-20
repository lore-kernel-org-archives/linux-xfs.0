Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC18C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 742CC64EDE
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBTMRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 07:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhBTMRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 07:17:07 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F75BC06178C
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 7so13595915wrz.0
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F2DRvrSRjAyLCa6AsAsNK6ud//X8DK/YA2y+MiIgJvU=;
        b=OWqCz1nU9khnzof/08xZgQPIB+96Gjj6ofT88ZUYqjYGolPROxCJHxyTGixPFU0TbO
         FbVb2P7qWevak9pZ2GzktKORlEsJJoQ0IkSwlf0UZLoObDQV4bsmK3b440yeQsVt0eeR
         WfyfKY2qvqhjcDl+yq1BCpWaRBkHD9hB/8gDWEoG5U8N5gbK3QSKQ++zTjVebr2AHUDz
         b/Cnk4dvFmsTyYIzsF15rlbQ/nN3hxrDZMgih5kTsiFNqM4TuPr0lIg+wQG/iCckLcG2
         AGiJVKbQysbnebryXf3hXskqQpzlC6IjnBHcBVKGmCt9VhQ73fLOktdf803P0s6HGHCs
         9EMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2DRvrSRjAyLCa6AsAsNK6ud//X8DK/YA2y+MiIgJvU=;
        b=uPluAPelU9Pop5kuI/dKUxF3gdxYyyWHGr5QMaIbhpWvadieijxNZ2qzXke9a4fRKB
         cA7XiNvXxdNX/KHck+sH6OMImi698CW5lyNzm93c8QD8UuSMolJ0RBWO8TfdCmPJqurf
         dMc+wA94U8Jn+V7QQZBVDpr4kyqB0y3qMzGzF4/3tr5bDlVdCa2OLDOp6jrY5gtFmMZ6
         pXmgT5jskZ1BJXA8WbLE+p1d/+GkmRC1FnGRim+3+6kY2mcn2aq1IDYeKewYcjkvix+t
         TG7el4h8ED0Nv76PUxFIenQIYLuyxbTlb8V+z4DkzqtlhZ6cPeti8VwpWouTaYVTMawG
         f9mQ==
X-Gm-Message-State: AOAM530r41At5uy/ZsfOUvnSpc863kpcJUoOIuMAZ775xuY7ST41y79j
        km/0o/LMVPaFqol0C2WfqK2X0MGPMjT6Eg==
X-Google-Smtp-Source: ABdhPJzmFSZhctPlhsg9MaUkE8KWD75EIbtcWHc9wvPNk5MFcJ99TjYemfcpadI3gD793M0ygJBYHA==
X-Received: by 2002:adf:f54a:: with SMTP id j10mr13379595wrp.55.1613823386208;
        Sat, 20 Feb 2021 04:16:26 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id h13sm18708286wrv.20.2021.02.20.04.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 04:16:25 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 4/4] debian: Build-depend on libinih-dev with udeb package
Date:   Sat, 20 Feb 2021 13:16:09 +0100
Message-Id: <20210220121610.3982-5-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210220121610.3982-1-bastiangermann@fishpost.de>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The first libinih Debian package version with udeb binary package is 53-1.
Debian bug #981662 documents the need for it:
xfsprogs-udeb depends on libinih1, not libinih1-udeb

Link: https://bugs.debian.org/981662
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 3 +++
 debian/control   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index 6cc9926b..1879485d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -7,6 +7,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
   [ Steve Langasek ]
   * Regenerate config.guess using debhelper
 
+  [ Bastian Germann ]
+  * Build-depend on libinih-dev with udeb package
+
  -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
 
 xfsprogs (5.10.0-3) unstable; urgency=medium
diff --git a/debian/control b/debian/control
index 1da8093d..e4ec897c 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
+Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
-- 
2.30.1

