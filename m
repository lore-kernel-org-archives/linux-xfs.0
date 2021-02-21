Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBA6C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C8C64E5C
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhBUJlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 04:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhBUJki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 04:40:38 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5957C06178A
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n10so11662643wmq.0
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EkgiXYJSBRBoscABPfj+qDKd9iefDt6ktBlRuoxLCAE=;
        b=Ur98X+ZrI9Qvpf4SpiAq4dGl37X397mVngU3yECWTDyIasKW9FKXk6WPzWzJTsVuQu
         cJEBI1IiDIMecvxWBIaoul6tNms5cQmuTNqNfja/80Me/6SH/fXUu+SMw+cs0UHk28VV
         Y7G6IixmqSueC+2h38URrPslAF4oT207N5G2sVnY/umGgD+M+tcJEacbN54WJcJrD5ru
         IXKUD0wAXXIbUxAyFp5hIbGDmtGwIBug9jL+1J9DfxweOjKfFA9YSrjzuSeUty59PAR0
         btZDGu7c9KypC0PlPl9IAb2N01ToTRmfs0NleLXv70UiXYVVW2YzWAH9tkowtWxiZ4es
         b+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EkgiXYJSBRBoscABPfj+qDKd9iefDt6ktBlRuoxLCAE=;
        b=rL9MdiRMuemOcNiAvTqAuxefvZTLAiIlgXvlRd8oyxaItlcYor5IFq+fDFdgOcmHWO
         rglO26pK3jp05nry42UrcUUWuC5zKnxIvpxVo0J7Qy1WJFE+IXDNbIxYQNwQNKVE9RS8
         yvMeFAyF55gxgognxupNg3EjpAycaRR+CWmZexYl5gKQKVUpgQ5W83Astsgr0pynLagN
         EON/GAY6RDCNEk2XDg/HRKSBB3cSQiLJ57UTmUXdcnSPDHbl8NlaW8w7nS9Sat9DWyl8
         XR+XYTldcAMzF6JEjeg5ITGsO5UEcwQ4wADHtmiOPrP290Wkii2MgFaifmsVBUhWehaX
         Udhg==
X-Gm-Message-State: AOAM530IoGtZRTgtFPGA5nFXCRw9xjLp5ZTH1Ce3jUCyQ69pzmm5eETo
        gwMjQOAwNdGrwwGiKRkAXYzvniIPfkda8g==
X-Google-Smtp-Source: ABdhPJxR2sdhzEHfeiptTvH6rMc3ZGdjJTTlRcTZ1+0ODyM9z1esbLnbMDKxJ/cR4fKdhPWNSP8aTg==
X-Received: by 2002:a1c:7501:: with SMTP id o1mr14926191wmc.105.1613900396575;
        Sun, 21 Feb 2021 01:39:56 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id 7sm11273845wmi.27.2021.02.21.01.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 01:39:56 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH v2 2/2] debian: Build-depend on libinih-dev with udeb package
Date:   Sun, 21 Feb 2021 10:39:46 +0100
Message-Id: <20210221093946.3473-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210221093946.3473-1-bastiangermann@fishpost.de>
References: <20210221093946.3473-1-bastiangermann@fishpost.de>
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
index 679fbf03..8738ab90 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -3,6 +3,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
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

