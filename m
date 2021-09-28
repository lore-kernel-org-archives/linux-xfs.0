Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E061C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42461611F2
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhI1A1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhI1A1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:27:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C959C061575
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g16so54903637wrb.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ziBD856Nze7aFwTtcToCjla8YIrnLw4T4XVO4dEXdlM=;
        b=P/9+QUAmBnPt7u+/9zK6wn1V0AbwJwHh7SE65+btHNY5tE+KkZSse/QXGUJUI4jc9w
         l0UPS3He9MmBARsXrVpVjgkePLCu7YNt5IrzI/3RIBzUTb+c+ZI4i86V611L/Kw6o6PZ
         6W0n+tbrGtKl9tHf90MSkbO8L9qe22laMC4+rz7wHjNu+cXpB6n7gh4tre+No8aSUuIO
         LuuGzhRBL5M+W4CDG5rAi0AOANz8xF/AyV37hSuZBRRZipHi1ba+xUcjK7UIm+b6G6hB
         GYHBLQhZliwGEPAkFSaAH0ArAFR/UqNu38NphzCMFgOsU0EFEg4+1SlgDCdNQd0HJ/k3
         fr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ziBD856Nze7aFwTtcToCjla8YIrnLw4T4XVO4dEXdlM=;
        b=BYlXVdPn2x7RXPxwbMSfcJKQrfWokDunldKpQVuAmJ7W8T/Ecilvj4gOOZ+la6yCIy
         8usVmGoO40tdZpIGwklrIN5sJkVoBlqVWn9uufrwUsrpx85QOIfq7nPH3PX9DjC9LUD5
         oplRx1rrK9w2QM0ZmGZr5IZJ2X/CNcbGSb54SNbrty9SSiGmEdZex1bsRVgVrn2ICUcL
         CB2KHz0OJfVIM1eulbursvY/CCe9dZ7ktdbSHUgoZxv1Wtpcm5vz19sY4xdB31Cutsr8
         u1U1NaYZBM0WmAb5RDhRNGwiASq/h/LyiXn1+h848OlXJKupJgX1vCyGaGuZJ+B9msiS
         RO9Q==
X-Gm-Message-State: AOAM530L6NMG3yyPPsydf9OzqXB8H0URcM7VBFumFjsp5f7OUxAxXW93
        jtqWM4S7KpkwqJU/OHxd7GbnPRyVFCRTcnF2Ejo=
X-Google-Smtp-Source: ABdhPJx4oXQYKRZZt46pf73YoxCsGo/chNCmTLr/UHdERH+1F34GygCDtr1u4hPJq9WG2EpFKZMb6A==
X-Received: by 2002:adf:f687:: with SMTP id v7mr3111725wrp.347.1632788762902;
        Mon, 27 Sep 2021 17:26:02 -0700 (PDT)
Received: from thinkbage.fritz.box (p200300d06f1f7300176a2a162e6525fe.dip0.t-ipconnect.de. [2003:d0:6f1f:7300:176a:2a16:2e65:25fe])
        by smtp.gmail.com with ESMTPSA id p3sm4755814wrn.47.2021.09.27.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:26:02 -0700 (PDT)
From:   Bastian Germann <bastiangermann@fishpost.de>
X-Google-Original-From: Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        Helmut Grohne <helmut@subdivi.de>
Subject: [PATCH 2/3] debian: Pass --build and --host to configure
Date:   Tue, 28 Sep 2021 02:25:51 +0200
Message-Id: <20210928002552.10517-3-bage@debian.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928002552.10517-1-bage@debian.org>
References: <20210928002552.10517-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs fails to cross build because it fails to pass --host to configure.
Thus it selects the build architecture as host architecture and fails
configure, because the requested libraries are only installed for the host
architecture.

Link: https://bugs.debian.org/794158
Reported-by: Helmut Grohne <helmut@subdivi.de>
Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/changelog | 8 ++++++++
 debian/rules     | 9 +++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/debian/changelog b/debian/changelog
index 4f09e2ca..8b5c6037 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,11 @@
+xfsprogs (5.13.0-2) unstable; urgency=medium
+
+  [ Helmut Grohne ]
+  * Fix FTCBFS (Closes: #794158)
+    + Pass --build and --host to configure
+
+ -- Bastian Germann <bage@debian.org>  Tue, 28 Sep 2021 00:42:50 +0200
+
 xfsprogs (5.13.0-1) unstable; urgency=medium
 
   * New upstream release
diff --git a/debian/rules b/debian/rules
index fe9a1c3a..e12814b3 100755
--- a/debian/rules
+++ b/debian/rules
@@ -11,6 +11,9 @@ package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
 
+DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
+DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
+
 version = $(shell dpkg-parsechangelog | grep ^Version: | cut -d ' ' -f 2 | cut -d '-' -f 1)
 target ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
 udebpkg = $(bootpkg)_$(version)_$(target).udeb
@@ -23,11 +26,13 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
 pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
+configure_options = --build=$(DEB_BUILD_GNU_TYPE) --host=$(DEB_HOST_GNU_TYPE)
+
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 checkdir = test -f debian/rules
 
 build: build-arch build-indep
-- 
2.33.0

