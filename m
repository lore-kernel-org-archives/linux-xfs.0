Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28091C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 19:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhLQTKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 14:10:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36714 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhLQTKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 14:10:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE29BCE2676
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC72C36AE5;
        Fri, 17 Dec 2021 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639768246;
        bh=SyQTjl8X44LJfJpqLY57qX7Ac6mPgG+pUnmtwGhMv1w=;
        h=Date:From:To:Cc:Subject:From;
        b=t272D/hu8Ily7nzpI71rgHOG7yt0KPlwDgeWLF8H9T4+7lEqKEyAsbaL6gmdjhozd
         GngJjJwWlD+flXKbHKHX/SrkILoE6kXSnWSqQp002zbM3y/qa6jdRzbSOAyuTLzaS3
         Vw6K+fa6J+xMdQQgUOUdkImJsR75tMwxK3lDCV7Xt0gXOXSKVhbTPxmgnEhg0t8nSQ
         VCzxplK3CDiRINm2Vwmo00l9T+fgi3d6u0DlNsG73KqU3Z9wQTikG18eZMXoyPJuIB
         j+ni5sfQ8D7bzlTlYEGWkGXL2bDFzciRMubKy8d2VFLs7BG+OI1BcSI67txdsr3uuw
         sDTd6XGXnt3Qw==
Date:   Fri, 17 Dec 2021 11:10:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: add configuration files for the last few LTS kernels
Message-ID: <20211217191046.GM27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some sample mkfs configuration files that capture the mkfs feature
defaults at the time of the release of the last three upstream LTS
kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/builddefs.in |    1 +
 mkfs/Makefile        |    6 +++++-
 mkfs/lts_4.19.conf   |   13 +++++++++++++
 mkfs/lts_5.10.conf   |   13 +++++++++++++
 mkfs/lts_5.15.conf   |   13 +++++++++++++
 5 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_4.19.conf
 create mode 100644 mkfs/lts_5.10.conf
 create mode 100644 mkfs/lts_5.15.conf

diff --git a/include/builddefs.in b/include/builddefs.in
index f10d1796..ca4b5fcc 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -66,6 +66,7 @@ DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
+PKG_DATA_DIR	= @datadir@/@pkg_name@
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 811ba9db..04d17fdb 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -9,19 +9,23 @@ LTCOMMAND = mkfs.xfs
 
 HFILES =
 CFILES = proto.c xfs_mkfs.c
+CFGFILES = lts_4.19.conf lts_5.10.conf lts_5.15.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
-default: depend $(LTCOMMAND)
+default: depend $(LTCOMMAND) $(CFGFILES)
 
 include $(BUILDRULES)
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_DATA_DIR)/mkfs
+	$(INSTALL) -m 644 $(CFGFILES) $(PKG_DATA_DIR)/mkfs
+
 install-dev:
 
 -include .dep
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
new file mode 100644
index 00000000..74144790
--- /dev/null
+++ b/mkfs/lts_4.19.conf
@@ -0,0 +1,13 @@
+# V5 features that were the mkfs defaults when the upstream Linux 4.19 LTS
+# kernel was released at the end of 2019.
+
+[metadata]
+bigtime=0
+crc=1
+finobt=1
+inobtcount=0
+reflink=0
+rmapbt=0
+
+[inode]
+sparse=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
new file mode 100644
index 00000000..ac00960e
--- /dev/null
+++ b/mkfs/lts_5.10.conf
@@ -0,0 +1,13 @@
+# V5 features that were the mkfs defaults when the upstream Linux 5.10 LTS
+# kernel was released at the end of 2020.
+
+[metadata]
+bigtime=0
+crc=1
+finobt=1
+inobtcount=0
+reflink=1
+rmapbt=0
+
+[inode]
+sparse=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
new file mode 100644
index 00000000..32082958
--- /dev/null
+++ b/mkfs/lts_5.15.conf
@@ -0,0 +1,13 @@
+# V5 features that were the mkfs defaults when the upstream Linux 5.15 LTS
+# kernel was released at the end of 2021.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=0
+
+[inode]
+sparse=1
