Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835E4C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC1C64EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhBTMRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 07:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhBTMRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 07:17:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A803BC06178B
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:26 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id x16so9314715wmk.3
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0fb6Esx6QnjkxiIuPZWt1SG2yR5zS6XnIJh8t3L+IA=;
        b=IS17QSGsC1sm1vRgQVZTvk29tKQNU1jCA52XFNiNN7pG58R8C1HwMLIIu3H1PJVEUe
         rDqvd5pGgwvTQotRD6Lg9u8KKQ1xTa/HLJdvXqJ6sewg21CLctEdzYjZ+pWTgn7fP2OQ
         g9BqSNSaanb10mDAEshQWBSjIh0lBzY1xl68fIuOr8Qbavtg5ZcbCIKrJynciGxEZvht
         cxvPP+BbZepmnc9nIrWL5NRLaBb2Upu47NCNw/f27chmHHfd/9SC+8fLoT4xOnEXRC+e
         8s9AZUq0t4LNpxaN/4n74OV4S7XDN++hY7Mw59MW4IABGULmoPP2cdiVjHd0QFM7Qut8
         VSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0fb6Esx6QnjkxiIuPZWt1SG2yR5zS6XnIJh8t3L+IA=;
        b=mdMZWHiIJPI07ldy7UbGSP6JovQGFX+xv6WHSiUomMUgT3Mjb90maOUaxD57PMWht6
         RaH8zIOqo2OwraDhYfNqWiNZbltqzoJ2fcLnhnnJpaU1oVYFEalneDFaC9zUbaFKxek/
         9cXUIr7jLai7KipDCqZ1AcK9d68FB0fzON0OLukHjAPpuZYeif5yu7mQOvIhMpAC4YEw
         6R7tb1q8O4S2lTQ+v9aV4rxlgjeiJ0/x6dABieO2phv/a5qlPgNIU6f9RLI6xl6HE7ca
         xiBi8wsTCwH+60AlLkiNCRUSQn/mdUT0BI6aS6A0qgSPXdMpqr58m/z1qzDO/e9Txyjj
         /cDA==
X-Gm-Message-State: AOAM532LQsIeR9SS4XS4kHOqG4oViwD+UNSX5wFv8JxkoceeIqTyv6Ox
        Nq16hbqAqdKS2Vtvk3OVChcbfG7TP+ywVw==
X-Google-Smtp-Source: ABdhPJzq+lYkFPip91v5FLKZ6i9cnAblPMELaHP8pNzK8M/j6wGNBLYUgmWgCItYN9n3lUYfOXfvQg==
X-Received: by 2002:a05:600c:2291:: with SMTP id 17mr4354079wmf.169.1613823385464;
        Sat, 20 Feb 2021 04:16:25 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id h13sm18708286wrv.20.2021.02.20.04.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 04:16:24 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Steve Langasek <steve.langasek@ubuntu.com>
Subject: [PATCH 3/4] debian: Regenerate config.guess using debhelper
Date:   Sat, 20 Feb 2021 13:16:08 +0100
Message-Id: <20210220121610.3982-4-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210220121610.3982-1-bastiangermann@fishpost.de>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a change introduced in 5.10.0-2ubuntu2 with the changelog:

> xfsprogs upstream has regressed config.guess, so use
> dh_update_autotools_config.

Reported-by: Steve Langasek <steve.langasek@ubuntu.com>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 3 +++
 debian/rules     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index c77f04ab..6cc9926b 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -4,6 +4,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
   * Drop trying to create upstream distribution
   * Enable CET on amd64
 
+  [ Steve Langasek ]
+  * Regenerate config.guess using debhelper
+
  -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
 
 xfsprogs (5.10.0-3) unstable; urgency=medium
diff --git a/debian/rules b/debian/rules
index dd093f2c..1913ccb6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -49,6 +49,7 @@ config: .census
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
+	dh_update_autotools_config
 	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
 	touch .census
 
-- 
2.30.1

