Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0027BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiLaAiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiLaAiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:38:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2B81E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A58B81E08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD06C433EF;
        Sat, 31 Dec 2022 00:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447090;
        bh=y+KQKroufgYQjwLEgOY3uqll077LBKS3Bmuz4IdOyuQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LRp5V/mGd/pLr1WUm8wkSvFoc8oiMGg+NyHfMeWT0pssY6kpJmm2Xg3h+h+mzuDu+
         uO2BvtAzX5Rzua1oSueTG3c1X0WeV5+uUyOJDEv5xxiZi+tm7sdHYp1Npu/Wfg3CEq
         oa6XxeWoG5oWTLY3Io6/CN5WV5CTk/Bki6tN1d23A3NYAcKPMZVnyMsl8d6KI3Q01D
         m4MEJp6wFJ2Csgef1r8XgC3KgoB9Ios8uwW56N37r9vp0OAwaUUG8vcRYejpVS+KcI
         MaKOFCVI5X1fIvLcr4YWCg3bES247JV3mjL8M3R49OgPApvct1j6scAf3nMIhOixLm
         lsDX+Za/Uf3ww==
Subject: [PATCH 4/4] xfs_scrub_all: failure reporting for the xfs_scrub_all
 job
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871844.718563.13357729046234850218.stgit@magnolia>
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

Create a failure reporting service for when xfs_scrub_all fails.  This
shouldn't happen often, but let's report anyways.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                      |    1 +
 scrub/xfs_scrub_all.service.in      |    1 +
 scrub/xfs_scrub_all_fail.service.in |   67 +++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail                |   33 ++++++++++++++---
 4 files changed, 96 insertions(+), 6 deletions(-)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in


diff --git a/scrub/Makefile b/scrub/Makefile
index 7434ac0ce4e..f2d0c1aa0bf 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -21,6 +21,7 @@ SYSTEMD_SERVICES=\
 	xfs_scrub_media@.service \
 	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
+	xfs_scrub_all_fail.service \
 	xfs_scrub_all.timer \
 	system-xfs_scrub.slice
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index e831ad58eb8..c11d6a96037 100644
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
index 00000000000..002d05b67de
--- /dev/null
+++ b/scrub/xfs_scrub_all_fail.service.in
@@ -0,0 +1,67 @@
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
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index 58c50abe963..0739a00dec9 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -5,14 +5,13 @@
 # Copyright (C) 2018 Oracle.  All Rights Reserved.
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
@@ -47,10 +46,12 @@ escape_path() {
 	echo "-$(systemd-escape --path "${mntpoint}")"
 }
 
-mntpoint_esc="$(escape_path "${mntpoint}")"
+fail_mail_mntpoint() {
+	local mntpoint_esc
 
-(cat << ENDL
-To: $1
+	mntpoint_esc="$(escape_path "${mntpoint}")"
+	cat << ENDL
+To: ${recipient}
 From: <${service}@${hostname}>
 Subject: ${service} failure on ${mntpoint}
 
@@ -58,5 +59,25 @@ So sorry, the automatic ${service} of ${mntpoint} on ${hostname} failed.
 
 A log of what happened follows:
 ENDL
-systemctl status --full --lines 4294967295 "${service}@${mntpoint_esc}") | "${mailer}" -t -i
+	systemctl status --full --lines 4294967295 "${service}@${mntpoint_esc}"
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

