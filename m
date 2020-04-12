Return-Path: <SRS0=xS0A=54=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6776FC2BA2B
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Apr 2020 08:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C769206E9
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Apr 2020 08:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLIUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 04:20:45 -0400
Received: from buxtehude.debian.org ([209.87.16.39]:38290 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgDLIUp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Apr 2020 04:20:45 -0400
X-Greylist: delayed 701 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2020 04:20:44 EDT
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1jNXfr-0006Ab-56; Sun, 12 Apr 2020 08:09:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#695875: [PATCH] Build with libedit rather than readline (Closes: #695875)
Reply-To: bage@linutronix.de, 695875@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 695875
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: patch
References: <20121213212730.25675.16201.reportbug@localhost>
X-Debian-PR-Source: xfsprogs
Received: via spool by 695875-submit@bugs.debian.org id=B695875.158667864921624
          (code B ref 695875); Sun, 12 Apr 2020 08:09:02 +0000
Received: (at 695875) by bugs.debian.org; 12 Apr 2020 08:04:09 +0000
Received: from galois.linutronix.de ([2a0a:51c0:0:12e:550::1]:40973)
        by buxtehude.debian.org with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.92)
        (envelope-from <bage@linutronix.de>)
        id 1jNXb6-0005cZ-Vo
        for 695875@bugs.debian.org; Sun, 12 Apr 2020 08:04:09 +0000
Received: from x4db90481.dyn.telefonica.de ([77.185.4.129] helo=adam.fritz.box)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <bage@linutronix.de>)
        id 1jNXH2-0007mt-2C; Sun, 12 Apr 2020 09:43:28 +0200
From:   bage@linutronix.de
To:     695875@bugs.debian.org
Cc:     Bastian Germann <bage@linutronix.de>
Date:   Sun, 12 Apr 2020 09:42:46 +0200
Message-Id: <20200412074246.29577-1-bage@linutronix.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
X-Greylist: delayed 1236 seconds by postgrey-1.36 at buxtehude; Sun, 12 Apr 2020 08:04:08 UTC
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

---
 debian/control | 2 +-
 debian/rules   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debian/control b/debian/control
index 0b3205f..ddd1785 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/debian/rules b/debian/rules
index e8509fb..7304222 100755
--- a/debian/rules
+++ b/debian/rules
@@ -25,7 +25,7 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 diopts  = $(options) \
 	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 checkdir = test -f debian/rules
-- 
2.25.1
