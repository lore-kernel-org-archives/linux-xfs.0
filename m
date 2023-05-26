Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF83BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZB5m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjEZB5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B01E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F32AF61295
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F67CC433EF;
        Fri, 26 May 2023 01:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066259;
        bh=Zh9DWeLlmjy0R1ee9K+kAYbt1FbMRXgnBVZ/PyYRzKw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=at5+8PDsfBAHAfKePwLFJHS02gleV7UpNF00+eZGT1ybVnPDvjT9dL/igxTr7JiGZ
         EtGhOgDBDydSoWFg1br2lZNNpWfTRccmo3I62kR/KlsBXVpNUCcT5NQVOLFvcre9wP
         MO5CyMzDGBSbWv4b8wEfnoSFb94s9/dXJD3dUUi9SClPTB+dIa0Bh2URfpBFeofepA
         2IUAmooLZm+PD6bCVFat1h5CPKh/Sy4+VQ6NFtQZ7u40jRo57or9rZu2lKJp+lCYcr
         yp7TGEijDm36vknVf3ccQ8EJwe84C6CG/rLhmKi7uz9fqG1aNuae+C0V8HdXrgRNdH
         5y5mGM1dPIH3w==
Date:   Thu, 25 May 2023 18:57:39 -0700
Subject: [PATCH 6/6] xfs_scrub_all: failure reporting for the xfs_scrub_all
 job
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074933.3746274.5520541142884420906.stgit@frogsfrogsfrogs>
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

Create a failure reporting service for when xfs_scrub_all fails.  This
shouldn't happen often, but let's report anyways.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                      |    1 
 scrub/xfs_scrub_all.service.in      |    1 
 scrub/xfs_scrub_all_fail.service.in |   72 +++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail.in             |   35 ++++++++++++++---
 4 files changed, 102 insertions(+), 7 deletions(-)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in


diff --git a/scrub/Makefile b/scrub/Makefile
index e4dd8bb3342..e2a8be2c441 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -26,6 +26,7 @@ SYSTEMD_SERVICES=\
 	$(scrub_media_svcname) \
 	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
+	xfs_scrub_all_fail.service \
 	xfs_scrub_all.timer \
 	system-xfs_scrub.slice
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index cfec827ff27..191e6708c73 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -5,6 +5,7 @@
 
 [Unit]
 Description=Online XFS Metadata Check for All Filesystems
+OnFailure=xfs_scrub_all_fail.service
 ConditionACPower=true
 Documentation=man:xfs_scrub_all(8)
 After=paths.target multi-user.target network.target network-online.target systemd-networkd.service NetworkManager.service connman.service
diff --git a/scrub/xfs_scrub_all_fail.service.in b/scrub/xfs_scrub_all_fail.service.in
new file mode 100644
index 00000000000..3b02d251ed8
--- /dev/null
+++ b/scrub/xfs_scrub_all_fail.service.in
@@ -0,0 +1,72 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata Check for All Filesystems Failure Reporting
+Documentation=man:xfs_scrub_all(8)
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub_all
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# Make the entire filesystem readonly and /home inaccessible, then bind mount
+# the filesystem we're supposed to be checking into our private /tmp dir.
+ProtectSystem=full
+ProtectHome=yes
+PrivateTmp=true
+RestrictSUIDSGID=true
+
+# Emailing reports requires network access, but not the ability to change the
+# hostname.
+ProtectHostname=true
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Can't hide /proc because journalctl needs it to find various pieces of log
+# information
+#ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and only enough to get things going
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+SystemCallFilter=~@mount
+
+# xfs_scrub needs these privileges to run, and no others
+CapabilityBoundingSet=
+NoNewPrivileges=true
+
+# Failure reporting shouldn't create world-readable files
+UMask=0077
+
+# Clean up any IPC objects when this unit stops
+RemoveIPC=true
+
+# No access to hardware device files
+PrivateDevices=true
+ProtectClock=true
diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index eed1af50da7..1258b1cca54 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -5,14 +5,13 @@
 # Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 
-# Email logs of failed xfs_scrub unit runs
+# Email logs of failed xfs_scrub and xfs_scrub_all unit runs
 
 recipient="$1"
 test -z "${recipient}" && exit 0
 service="$2"
 test -z "${service}" && exit 0
 mntpoint="$3"
-test -z "${mntpoint}" && exit 0
 
 hostname="$(hostname -f 2>/dev/null)"
 test -z "${hostname}" && hostname="${HOSTNAME}"
@@ -23,11 +22,13 @@ if [ ! -x "${mailer}" ]; then
 	exit 1
 fi
 
-# Turn the mountpoint into a properly escaped systemd instance name
-scrub_svc="$(systemd-escape --template "${service}@.service" --path "${mntpoint}")"
+fail_mail_mntpoint() {
+	local scrub_svc
 
-(cat << ENDL
-To: $1
+	# Turn the mountpoint into a properly escaped systemd instance name
+	scrub_svc="$(systemd-escape --template "${service}@.service" --path "${mntpoint}")"
+	cat << ENDL
+To: ${recipient}
 From: <${service}@${hostname}>
 Subject: ${service} failure on ${mntpoint}
 
@@ -35,5 +36,25 @@ So sorry, the automatic ${service} of ${mntpoint} on ${hostname} failed.
 
 A log of what happened follows:
 ENDL
-systemctl status --full --lines 4294967295 "${scrub_svc}") | "${mailer}" -t -i
+	systemctl status --full --lines 4294967295 "${scrub_svc}"
+}
+
+fail_mail() {
+	cat << ENDL
+To: ${recipient}
+From: <${service}@${hostname}>
+Subject: ${service} failure
+
+So sorry, the automatic ${service} on ${hostname} failed.
+
+A log of what happened follows:
+ENDL
+	systemctl status --full --lines 4294967295 "${service}"
+}
+
+if [ -n "${mntpoint}" ]; then
+	fail_mail_mntpoint | "${mailer}" -t -i
+else
+	fail_mail | "${mailer}" -t -i
+fi
 exit "${PIPESTATUS[1]}"

