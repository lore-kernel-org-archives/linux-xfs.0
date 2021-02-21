Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4376BC433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D97364E5C
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhBUJlC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 04:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhBUJkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 04:40:37 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49CFC061786
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:56 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v62so11634495wmg.4
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPtbN2UoDac7skpm8b04CdIa1ig68uf0ZXuSY8Hyar0=;
        b=tn2NX2VJw4VFW2Iap3UvArFbso7c1uU9a8P6OPmoPAfpG0Z3VJFqiRN2TkkKZoqGG0
         zKK/LbEw9A5lBdytWN+vmvcjp6NfStV2QI+Te4l9tQOwz2ZyZWoPoc4SmcGccS2PU7Mc
         bGqLWYxaj7tF4cNt+NQlSNVJqHweUYKnp7iG2KBQcOOWTW+ku4m2ZLJIVPmt69587dwB
         bGjkkPaJWiO+xrSlJgioF++JC5ig3TWG0NglDSjp7lJeaAqM/YqlGZZIJackrlV2eped
         3vwRC7V8LrC4Fb4y4kyDLg6vCVv+uBd+uWDFC/JJhcSvzCbCNRK6P+Mpk08scA7WNiMM
         pfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPtbN2UoDac7skpm8b04CdIa1ig68uf0ZXuSY8Hyar0=;
        b=nQlLHovxF9LW1eqbvSQ7zKcmgwuKZ/zOATQOCSWwp1hSMEH91d6tI1dX1f9Fip6wGm
         ZGliCIWyZPJxAOTVW7PC7jWuk6JtEApMqs63GFvdGfj5nLAlsrFuCdyvyd9dc01L89ZU
         KttI6Cv5L4Y7HcLCxMKPGN9cLfOL70a11Rw366+RjtQyR82XeL6ZNScb/eNtuKO/E125
         fJ5Q7W89d6HXTucoqzarbvW56GEaGaUUFJK0VUycW8cxahM/Ejz/fyLI/Y0MN+X5hoyn
         DltSqUmFFYv7Gtr7K85Es/MXSdMXg4AQK01pkJKpe52U6KC+c9lliNfXmSNxZ47pobx1
         gL+Q==
X-Gm-Message-State: AOAM533mxrxRSlO94m8jXhs4XzRH4x+Dvap77Ig0qX4V3qnO+Ha4jMUF
        Gh7ue8xcQyJU/KMGJW3l64xfohEHH5N7vg==
X-Google-Smtp-Source: ABdhPJzPD8ZWL9Yh6JOO7jrYMvzLe64q8U+1POPnMOl36zJS/TFOtiOu904e7l7lr8elEFUWK+5kgw==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr14971277wma.80.1613900395695;
        Sun, 21 Feb 2021 01:39:55 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id 7sm11273845wmi.27.2021.02.21.01.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 01:39:55 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Steve Langasek <steve.langasek@ubuntu.com>
Subject: [PATCH v2 1/2] debian: Regenerate config.guess using debhelper
Date:   Sun, 21 Feb 2021 10:39:45 +0100
Message-Id: <20210221093946.3473-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210221093946.3473-1-bastiangermann@fishpost.de>
References: <20210221093946.3473-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a change introduced in 5.10.0-2ubuntu2 with the changelog:

> xfsprogs upstream has regressed config.guess, so use
> dh_update_autotools_config.

The 5.10.0 tarball has a config.guess that breaks builds on RISC-V:
...
UNAME_MACHINE = riscv64
UNAME_RELEASE = 5.0.0+
UNAME_SYSTEM  = Linux
UNAME_VERSION = #2 SMP Sat Mar 9 22:34:53 UTC 2019
configure: error: cannot guess build type; you must specify one
make[1]: *** [Makefile:131: include/builddefs] Error 1
...

Reported-by: Steve Langasek <steve.langasek@ubuntu.com>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 7 +++++++
 debian/rules     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 5421aed6..679fbf03 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
+
+  [ Steve Langasek ]
+  * Regenerate config.guess using debhelper
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
+
 xfsprogs (5.10.0-3) unstable; urgency=medium
 
   * Drop unused dh-python from Build-Depends (Closes: #981361)
diff --git a/debian/rules b/debian/rules
index c6ca5491..fe9a1c3a 100755
--- a/debian/rules
+++ b/debian/rules
@@ -43,6 +43,7 @@ config: .census
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
+	dh_update_autotools_config
 	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
 	touch .census
 
-- 
2.30.1

