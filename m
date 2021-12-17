Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ACEC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 20:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhLQUg0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 15:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhLQUg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 15:36:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38550C061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 12:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCAD623BB
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 20:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23565C36AE5;
        Fri, 17 Dec 2021 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639773385;
        bh=8AjM+07mKaicpVXMQCOeu+fP3ZjBu9mffkh02wllE1s=;
        h=Date:From:To:Cc:Subject:From;
        b=ZZqsAkAunupg5sNOKxGu1at2d3qtCKaBpUI/3lPLu0ssFovnrtz51+dw7uksTBsAT
         leLbwhiATkyCzKXL4kzcjUaax++yTPahStcs/DMAo7haaTmpQt8XtRFo4wGr3KNbCI
         AitLFdW4nwLCuG3JUUFi7nNG6xlzbOo5Zp0ZUoiCb2ory9MGI7wkS08C3xkfdUqcKo
         cGkkOaP4EBR8QMBhQoPOPKGz3jlRp7XJqBgoW5zHSliS4q7aIESw9QbjqTZUl1nWY3
         FwtdUMYq/9r44rxb4lYEasoM53iNaMkukrG4mWnFSn8Gn9qm4hoqP0Rt2kIVZ6PwGh
         ZKKKSvlmT3TgQ==
Date:   Fri, 17 Dec 2021 12:36:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] mkfs: add configuration files for the last few LTS kernels
Message-ID: <20211217203624.GP27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some sample mkfs configuration files that capture the mkfs feature
defaults at the time of the release of the last four upstream LTS
kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: add a config for 5.4, and remind people to update the config files
when turning on a feature by default
---
 include/builddefs.in |    1 +
 mkfs/Makefile        |   10 +++++++++-
 mkfs/lts_4.19.conf   |   13 +++++++++++++
 mkfs/lts_5.10.conf   |   13 +++++++++++++
 mkfs/lts_5.15.conf   |   13 +++++++++++++
 mkfs/lts_5.4.conf    |   13 +++++++++++++
 mkfs/xfs_mkfs.c      |    4 ++++
 7 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_4.19.conf
 create mode 100644 mkfs/lts_5.10.conf
 create mode 100644 mkfs/lts_5.15.conf
 create mode 100644 mkfs/lts_5.4.conf

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
index 811ba9db..1b866e3a 100644
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
+	$(INSTALL) -m 755 -d $(PKG_DATA_DIR)/mkfs
+	$(INSTALL) -m 644 $(CFGFILES) $(PKG_DATA_DIR)/mkfs
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
 
