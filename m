Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6511DC433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B76C64F8C
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBEAcS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhBEAcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 19:32:18 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12CBC06178A
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 16:31:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bl23so8830494ejb.5
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 16:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1jjfd5hTUT+5Xs1r/YQMWZaJju+m+Y2iKFEQ6dRH+T0=;
        b=0wM0dA89J9A8HfeHCuNBC8VWKeGig4T1b1ZimhZni6CRac4QYeLkp7Y9qQpVhg7hoh
         xlf2XXTLcaKobT/7s7Jq571niHPeJnwssHeTUyulZW1eK5aARRSG2Yj9KxTrjkFlmWse
         vJiRIA03rJ/2SiV3FRQgpk+4gRg11HNlLom4gWPHdi+U+R+eQioM5fHYUsPLp+TZehXI
         sK0CEOUDjbY5PS2gipwNLt1lO/WHqyNX7WZK4zjIw8kaRumUbN88LWsGg4h88OYftTOR
         ACavGjBFjt+VUm+MkglK+esyf9tztfRZhsVcJOcvsaf0NfMGPIo21e15q7ulkA9r/low
         Ro0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1jjfd5hTUT+5Xs1r/YQMWZaJju+m+Y2iKFEQ6dRH+T0=;
        b=m7oHje1jFBIMMM7ohxnqZK0jvBmkImob8YlSqU7hCZAOH2VX4xlduOfSoCbEYFq5sP
         wDRTyYdbQD7IEgB6vMVKYOErHf2XHOVD8S87/KK4ShHUx86pBExOmOugIDhbWY9PiN70
         61w1pGLODPbpCsOnoPtzYtTWkc/YiyhgWNGE0Q8fJ10sQsPrJduQqVQPAeBZUTfYGwX0
         +4stKzm45gr29fqZWG0SkOFrHGizYTbIV7tErqjNO4SjUd3Inn/t1pIMjwGqO0aqtM/V
         WBA7rJgKH/SY+GDmOjpsuFOYSIV0usKht7HQbecHXMDnrgbcWmxEtnq1k7bGS811PRrs
         ADmw==
X-Gm-Message-State: AOAM530zEUN1YE9eNgw1b5e52KRZbBwq+o5wSBzwMIMqAQ/IT1mHZnGB
        KRn6o/hJ4jyHaYCbgAOa3hQrtDXx7zbKzVNn
X-Google-Smtp-Source: ABdhPJw4fBmbWvTRv5Q/EofSgZxPtiCSi9T83Koo4R18kTEuNT5pY7JgYDEv8BYcM3feCzxSa1G5zg==
X-Received: by 2002:a17:906:9bf8:: with SMTP id de56mr1525401ejc.425.1612485096507;
        Thu, 04 Feb 2021 16:31:36 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id o10sm3202222eju.89.2021.02.04.16.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:31:36 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 2/3] debian: Only build for Linux
Date:   Fri,  5 Feb 2021 01:31:24 +0100
Message-Id: <20210205003125.24463-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205003125.24463-1-bastiangermann@fishpost.de>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use architecture linux-any to exclude kfreebsd and hurd from building
the package. Those will always fail.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
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

