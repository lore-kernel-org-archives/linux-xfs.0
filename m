Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D45C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 003896112E
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhKNXCL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 18:02:11 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21809 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbhKNXCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 18:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1636929828; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=fi2XMXWuHZZvK1yvCxRoY3xukpimhQ//yBi6Gq51y/NepHPCmYtUWFuKgxwbyxfHcqngFyXxLJU92s0RLAQOzo9UMhPoJuzYJ+69dnZba+ncJoJtSsP3z7ykhBCpECUikXoHtANBYDX4r0xGOeJAcEpwMkoujzITZSDOM+4HNns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1636929828; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8hChGOtXni2WWa3/o0rzE2iV4kNTehWZBKo/ouEqfIk=; 
        b=dFqyIjq78byHbGdSgqy2wyhLI8rlJdCmDtJoZLUukORWZkrZDG5Rrv4HFokicpnN41UW0AR8BU8eVzuLvHlP0GfiygKxAhB6AFqKF2vK+uNxGQoDrHOuJKYzD2G5uucdvKejMjHnEhD56iUD9v9MYLOk0a9SvV4B8znA8qtaKIY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (pd9544ed8.dip0.t-ipconnect.de [217.84.78.216]) by mx.zoho.eu
        with SMTPS id 1636929826741790.2833092437069; Sun, 14 Nov 2021 23:43:46 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        Helmut Grohne <helmut@subdivi.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Message-ID: <20211114224339.20246-3-bage@debian.org>
Subject: [PATCH v2 2/4] debian: Pass --build and --host to configure
Date:   Sun, 14 Nov 2021 23:43:37 +0100
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211114224339.20246-1-bage@debian.org>
References: <20211114224339.20246-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
2.33.1


