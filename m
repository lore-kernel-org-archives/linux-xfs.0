Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16C2C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Dec 2021 00:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhLRAUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:20:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49416 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLRAUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 19:20:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25968B82B2B
        for <linux-xfs@vger.kernel.org>; Sat, 18 Dec 2021 00:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB859C36AE5;
        Sat, 18 Dec 2021 00:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639786852;
        bh=M/1SgclBtbUvjPekK6rr4i7lEHRPTLhBgkAEqzWPoFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijh4s1bz2Z6SISMftTAay/KCev0WkXbvquUmWgUz9KFB1zlEzXFjoDsllLGfsc8RX
         gkxhtsC6SUNCingLyxPbLVsXzl1YaEj+8d9VYnejLOf6nsF4iFvye+liCf6OOHz49n
         fGfpNe3Mtpm0ObFOqT3XPQoD6ffvuZUQYgQPCyGycjue9QHkzgGc3xVsGN0lHrYFEa
         Wjh3okl6KiK2uo2I52dWcoeAWi9oxNSsIjU6nDn5jM3YFB52SF3lxUXpnlFuWL+vG+
         Y4pL7acaiwFYRlFxJj0jJLUO3gRkzcG+GrxGSUQ4zpF4N34wvtKJP0R+iK6OC0Fb+L
         H97DTWvKq5Zow==
Date:   Fri, 17 Dec 2021 16:20:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v3 3/3] mkfs: add configuration files for the last few LTS
 kernels
Message-ID: <20211218002051.GU27664@magnolia>
References: <20211218001616.GB27676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218001616.GB27676@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some sample mkfs configuration files that capture the mkfs feature
defaults at the time of the release of the last four upstream LTS
kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v3: make it easier to substitute the mkfs config dir with a single
variable
v2: add missing config file for 5.4 kernel
---
 include/builddefs.in |    2 ++
 mkfs/Makefile        |   10 +++++++++-
 mkfs/lts_4.19.conf   |   13 +++++++++++++
 mkfs/lts_5.10.conf   |   13 +++++++++++++
 mkfs/lts_5.15.conf   |   13 +++++++++++++
 mkfs/lts_5.4.conf    |   13 +++++++++++++
 mkfs/xfs_mkfs.c      |    4 ++++
 7 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_4.19.conf
 create mode 100644 mkfs/lts_5.10.conf
 create mode 100644 mkfs/lts_5.15.conf
 create mode 100644 mkfs/lts_5.4.conf

diff --git a/include/builddefs.in b/include/builddefs.in
index f10d1796..0d3a4d17 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -66,6 +66,8 @@ DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
+PKG_DATA_DIR	= @datadir@/@pkg_name@
+MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 811ba9db..009f6742 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -9,19 +9,27 @@ LTCOMMAND = mkfs.xfs
 
 HFILES =
 CFILES = proto.c xfs_mkfs.c
+CFGFILES = \
+	lts_4.19.conf \
+	lts_5.4.conf \
+	lts_5.10.conf \
+	lts_5.15.conf
 
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
+	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
+	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
+
 install-dev:
 
 -include .dep
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
new file mode 100644
index 00000000..d21fcb7e
--- /dev/null
+++ b/mkfs/lts_4.19.conf
@@ -0,0 +1,13 @@
+# V5 features that were the mkfs defaults when the upstream Linux 4.19 LTS
+# kernel was released at the end of 2018.
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
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
new file mode 100644
index 00000000..dd60b9f1
--- /dev/null
+++ b/mkfs/lts_5.4.conf
@@ -0,0 +1,13 @@
+# V5 features that were the mkfs defaults when the upstream Linux 5.4 LTS
+# kernel was released at the end of 2019.
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
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fcad6b55..af536a8a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3875,6 +3875,10 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = false,
+			/*
+			 * When we decide to enable a new feature by default,
+			 * please remember to update the mkfs conf files.
+			 */
 		},
 	};
 
