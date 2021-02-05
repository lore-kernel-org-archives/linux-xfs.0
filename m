Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED105C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67C064FBA
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhBESw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhBESwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 13:52:34 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8F3C0613D6
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 12:34:19 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c127so6898530wmf.5
        for <linux-xfs@vger.kernel.org>; Fri, 05 Feb 2021 12:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2wITas3L0UmLsayIgFDG/aAEa/oMfa8h+CU1qshOJ88=;
        b=enYm7Wbaa5B7+XoW7y5Gez4WSoTHqk3Mw6LDr/5pfqcPYPmF2wxucHOI7SPq6QznaY
         zEYXQblRWqThDFX+JvdFj39dxrq5b2mJ/4y+TQXotwLDa13cigCZXhzGSfkKvQ+yGtQ8
         oNJ1x7Kva6bUNNsaznRXLYjsgS6LYKjYu+v0OR1V10Q5ViBGt0sxbE9UeC9eb0Pd1WWA
         HH4PBg4xEta00cEzDr0z0M9vjllkF1vTCZ6MQc7RzQXEXjpbSiBnY2+SjG+L3jB8LVgy
         MiMrOHkfFxAUMgK/2i4gaUaeuS/Y7DDL9M0nAnpBoDrifrIzuUX/N/LBW0M4TQRdNEwN
         MT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2wITas3L0UmLsayIgFDG/aAEa/oMfa8h+CU1qshOJ88=;
        b=QJ+Qn7RRL/p5wExgWKWpX2xpKlOr1vqJKd2qDmgBtqAlH5ytdM0xSlTQiVBGgUPOmC
         b/a99DGhj6EIQvgbJxnK7WwYWN2PkAgK3oTEHtp3YvGL0h+RElmPb57r9TQ1WVJsIMrY
         DLKRLKEklIcfvuGpuAILraZBTjri3S2/frfvFFoSsZF4v7iJhXwFCPf9BgC5s5e3WSvh
         0hLn6t1ZI15vzGMW9+cwl0FORORJ2wkkFnFyIUuUejEekNy1i8kiK4FM++QoyxuuR8Ub
         CY6fPGKTsO+fCXsiGDCoJQ3yZmClynuVq++n1Xag/uQTnpgymm/NH4K7QJwHWoP20b4s
         DheQ==
X-Gm-Message-State: AOAM530XEE5UCdNTYkEahsobvrrOxYTzq/3VZ55dcTte1tW2Kn95tK2q
        Gh6APM4QKmOslmVxFzlAa7p5t15WQyw6ZMAVwV8=
X-Google-Smtp-Source: ABdhPJylqLXvvROjFrch2s0nFcVoVpxmzwnrteMMu1fSSBJEXq0iF/rnVVe/PV9CbyB7+Pq8mNSTCQ==
X-Received: by 2002:a05:600c:154c:: with SMTP id f12mr5142630wmg.40.1612557257799;
        Fri, 05 Feb 2021 12:34:17 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id j14sm15664985wrd.36.2021.02.05.12.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:34:17 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 2/3] debian: Only build for Linux
Date:   Fri,  5 Feb 2021 21:34:04 +0100
Message-Id: <20210205203405.1955-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205203405.1955-1-bastiangermann@fishpost.de>
References: <20210205203405.1955-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use architecture linux-any to exclude kfreebsd and hurd from building
the package. Those will always fail.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/changelog | 1 +
 debian/control   | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/debian/changelog b/debian/changelog
index 7b0120c2..2da58f30 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,6 +1,7 @@
 xfsprogs (5.10.0-3) unstable; urgency=medium
 
   * Drop unused dh-python from Build-Depends (Closes: #981361)
+  * Only build for Linux
 
  -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
 
diff --git a/debian/control b/debian/control
index 8975bd13..1da8093d 100644
--- a/debian/control
+++ b/debian/control
@@ -13,7 +13,7 @@ Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
 Replaces: xfsdump (<< 3.0.0)
-Architecture: any
+Architecture: linux-any
 Description: Utilities for managing the XFS filesystem
  A set of commands to use the XFS filesystem, including mkfs.xfs.
  .
@@ -31,7 +31,7 @@ Package: xfslibs-dev
 Section: libdevel
 Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
 Breaks: xfsprogs (<< 3.0.0)
-Architecture: any
+Architecture: linux-any
 Description: XFS filesystem-specific static libraries and headers
  xfslibs-dev contains the libraries and header files needed to
  develop XFS filesystem-specific programs.
@@ -49,7 +49,7 @@ Description: XFS filesystem-specific static libraries and headers
 Package: xfsprogs-udeb
 Package-Type: udeb
 Section: debian-installer
-Architecture: any
+Architecture: linux-any
 Depends: ${shlibs:Depends}, ${misc:Depends}
 Description: A stripped-down version of xfsprogs, for debian-installer
  This package is an xfsprogs package built for reduced size, so that it
-- 
2.30.0

