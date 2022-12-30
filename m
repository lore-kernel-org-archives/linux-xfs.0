Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59470C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbiLaAh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:37:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385281E3EE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:37:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE8FB81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4349C433EF;
        Sat, 31 Dec 2022 00:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447074;
        bh=OYF411aDwhrerbL/KzsHSyKtmRfHsiezEiuWUEIq9Uw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cr3ORys/t3AE0r/+6wxCauYI/V+PVuqMubClgJ25MrXqmp2lzXyMPDl7D9hWpAm1L
         dDsEwHLEnrtv1GxftlsfIhVbnaWWPcuANaXQC67B0sNrwG/7OdmxdGZjOP7uOi1PKQ
         UOX6z4BK2Ji2fJKaE7iD39Fpz7aBIAxIp5K6ugVelqz3dys0kMyKX+ZseHV+MfKjrn
         gY5erF7JHD9k57R3OjszrtB4q7ZwaiS9sQBWU3xnYKm5o76IHqF4BQYzmAWtAdcseh
         ixwSebIERttQy5TZ2tHfMkOI4/7DmLoyIyspBG9FtAXo9obsJqmOjXSx6dp2jQVURs
         ClwMG2G0xFr+Q==
Subject: [PATCH 3/4] xfs_scrub_all: trigger automatic media scans once per
 month
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871831.718563.8824972404105654601.stgit@magnolia>
In-Reply-To: <167243871794.718563.17643569431631339696.stgit@magnolia>
References: <167243871794.718563.17643569431631339696.stgit@magnolia>
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
index f773995dcd7..7434ac0ce4e 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -110,6 +110,9 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+# Automatically trigger a media scan once per month
+XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
+
 LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
@@ -135,11 +138,14 @@ install: $(INSTALL_SCRUB)
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
index 0ef97cc0ca8..d55d2ad2d89 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -3,4 +3,4 @@
 # Copyright (C) 2018 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 #
-10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 4938404ee95..e831ad58eb8 100644
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

