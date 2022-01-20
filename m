Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43CEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbiATAW5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345184AbiATAWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA0C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B0BDB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FAC004E1;
        Thu, 20 Jan 2022 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638172;
        bh=Dc8ve2scfog4hV8f25LNfSrsLrHW6tsPazjIssIOh5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=opwhh+dlo2kJbNGAy1H0rK8vrXbfW9ZABArtCI1X21QaSTzg3+LoTYWPDcawIBxN5
         PoH1WrKvMvbH+PcQTjMTUVHFx5b7j3hiHk/eXoxdgTgDasFF/cANOx2j39PLHr9UTo
         Q1MGJa617QDP18QMCZT0jH4eRjno66lZkvkjcsuPfUjzKP4ZQlmYeQyNFYJ3RrQZXo
         Z63MDZBYdgGleo4SmCyjphpT62vj33voE85hKemB83MOS/x3jEav9rfQtjk4QKfQAy
         CXsw7VzZu9SzWknyAd0X65PZJao9R7Jzxewzf5O2fXQrDOjYFEajt1fRx5XYG/aCtm
         ZSVLee6ge0yxQ==
Subject: [PATCH 14/17] mkfs: add configuration files for the last few LTS
 kernels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:51 -0800
Message-ID: <164263817182.863810.7895612450948355646.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some sample mkfs configuration files that capture the mkfs feature
defaults at the time of the release of the last four upstream LTS
kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 9d0b0800..0bb36431 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -56,6 +56,8 @@ DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
+PKG_DATA_DIR	= @datadir@/@pkg_name@
+MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 9f6a4fad..0aaf9d06 100644
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
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
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
 

