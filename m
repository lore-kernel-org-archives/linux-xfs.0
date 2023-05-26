Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A36CC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEZB4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZB4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77228E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13CFF64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71559C433EF;
        Fri, 26 May 2023 01:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066181;
        bh=wmgo6Gzm0OxXzwS0N5zsYlTB+OJBDMLiwNHXhWh/mik=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JzOEAaQb08MtrYVquKfssvFwKLyVpxM4CND7R2cJ9jVCpra4vPzCsHNjBgZvyKbal
         fc6yK3T/Hhpb5r6aYRGv/Nz89YTMfusuVIbJ2N9FVTyXCzX1nhs8/Zj2im2pw/2JPl
         H0uOrRXyUBTpRb0EcJNHzkELxiFVjPFkKWUydxt3AW5gnI/86l568GqD15pny/Qf5c
         DEAoQZHr0bL4PhOktUc5HvNOMWOKtvr2YzxG+3W2ATx0e8vdy6zDpXrxfl2zuIkb0F
         JCcrtL+RK2mEyHnkWUTrQduUz0QpqWgmlijsh20WUsaXXnWeqXlcET0eBpDGBgIzom
         0GlsU2/yrImYw==
Date:   Thu, 25 May 2023 18:56:20 -0700
Subject: [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd services
 in service mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074866.3746274.3051483707414050700.stgit@frogsfrogsfrogs>
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

Since the per-mount xfs_scrub@.service definition includes a bunch of
resource usage constraints, we no longer want to use those services if
xfs_scrub_all is being run directly by the sysadmin (aka not in service
mode) on the presumption that sysadmins want answers as quickly as
possible.

Therefore, only try to call the systemd service from xfs_scrub_all if
SERVICE_MODE is set in the environment.  If reaching out to systemd
fails and we're in service mode, we still want to run xfs_scrub
directly.  Split the makefile variables as necessary so that we only
pass -b to xfs_scrub in service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile              |    5 ++++-
 scrub/xfs_scrub@.service.in |    2 +-
 scrub/xfs_scrub_all.in      |   11 ++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index db2b94feb12..f631fd6d70f 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -15,7 +15,8 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
-XFS_SCRUB_ARGS = -b -n
+XFS_SCRUB_ARGS = -n
+XFS_SCRUB_SERVICE_ARGS = -b
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -120,6 +121,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
@@ -139,6 +141,7 @@ install: $(INSTALL_SCRUB)
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
 		   -e "s|@pkg_name@|$(PKG_NAME)|g" \
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index e306216bb91..ef869379789 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -17,7 +17,7 @@ ConditionCapability=CAP_SYS_RAWIO
 Type=oneshot
 Environment=SERVICE_MODE=1
 Environment=SERVICE_MOUNTPOINT=/tmp/scrub
-ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
+ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ @scrub_args@ %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 11189c3ee10..f2b06fb8f7d 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -162,9 +162,10 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if terminate:
 			return
 
-		# Try it the systemd way
+		# Run per-mount systemd xfs_scrub service only if we ourselves
+		# are running as a systemd service.
 		unitname = path_to_serviceunit(path)
-		if unitname is not None:
+		if unitname is not None and 'SERVICE_MODE' in os.environ:
 			ret = systemctl_start(unitname, killfuncs)
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
@@ -175,8 +176,12 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			if terminate:
 				return
 
-		# Invoke xfs_scrub manually
+		# Invoke xfs_scrub manually if we're running in the foreground.
+		# We also permit this if we're running as a cronjob where
+		# systemd services are unavailable.
 		cmd = ['@sbindir@/xfs_scrub']
+		if 'SERVICE_MODE' in os.environ:
+			cmd += '@scrub_service_args@'.split()
 		cmd += '@scrub_args@'.split()
 		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs)

