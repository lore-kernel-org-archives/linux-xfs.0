Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25417C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEZB50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjEZB5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:57:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0515189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6843D64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F64C433EF;
        Fri, 26 May 2023 01:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066243;
        bh=LCj2IDeKlvugG9YhsfqGJ9m1GiK+L9WPdD4awCDSyNQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qHQHMgfbkP8LNfwlk35Js44i8kNkZJj6KM2ye5ZQgaaOpBYHqLhT2IWptIqmw8sct
         NK2FUA0EPMnGQ6xm37R/IRhlYAPI86GDkh0uiyk9mC+GUXNsv0nxYQfKK5kQUl5mRq
         5kGF2F9JEyKO29wLGADcHj39pcvoDLyLKsvh5+gc66HHpvBKGd8QisueZgYSA8Aup/
         Z86aSmiodaEQ7WZQPQuoujmMkV4lS1HWqd6rhm+jMFABLqdXhfWT8xjwUevfLR9e4L
         LZ3Uz11zjy/jdwKl9tD/WfA4lJSOVJuPHl/PAuqFI94uDkbfc+rtv+rkTFSC9V1IWv
         3zN2/ahN85M5Q==
Date:   Thu, 25 May 2023 18:57:23 -0700
Subject: [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once per
 month
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074920.3746274.13660165662502702078.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074851.3746274.9049178062160647823.stgit@frogsfrogsfrogs>
References: <168506074851.3746274.9049178062160647823.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_scrub_all background service to trigger an automatic scan
of all file data once per month.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                 |    8 +++++++-
 scrub/xfs_scrub_all.cron.in    |    2 +-
 scrub/xfs_scrub_all.service.in |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 669d7505d52..e4dd8bb3342 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -115,6 +115,9 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+# Automatically trigger a media scan once per month
+XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
+
 LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
@@ -151,11 +154,14 @@ install: $(INSTALL_SCRUB)
 		   -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
 		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
 		   -e "s|@pkg_name@|$(PKG_NAME)|g" \
+		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
 		   < $< > $@
 
 %.cron: %.cron.in $(builddefs)
 	@echo "    [SED]    $@"
-	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
+		   < $< > $@
 
 install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
index 08c8678cfb3..667f1b81cf0 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -3,4 +3,4 @@
 # Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 #
-10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index bcbd5173e56..cfec827ff27 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -12,7 +12,7 @@ After=paths.target multi-user.target network.target network-online.target system
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub_all
+ExecStart=@sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
 SyslogIdentifier=xfs_scrub_all
 
 # Create the service underneath the scrub background service slice so that we

