Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FB8C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kumumHMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F75C433C7;
	Sun, 31 Dec 2023 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063531;
	bh=dWLIKyWGFE6q96TXtE8POk7r8/fNSKbSV2qzhZjjR8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kumumHMRBLzvA/avDmG/c7Fru53QOckCZnYi6vMkWKcBvYOft5H7QfejJXPeuZwIS
	 ePBh7ELDRsJdEz0BdVkhDWy+by3Xwc+MW1aKIbjTbUWkQJ5AmrourbLKnm9btzZFeE
	 M52j2wIElSpesfdUPeqpDZiSYPlDTGiUXSxp00NgQSsp79SpS0Pbif2np+ogsTb6Vk
	 0oUrtrn+OgV2+1V2agdElgwLj5LKh3iA9/GtIE3WneFRCtQN2aL3ER8tDvWp5/9KYT
	 SCEn2QeD6B8ZkhtNTY6gFCD4TujsGOouR4AWTYyz1B881DhwuEu/qHld7d8DpI0LVF
	 biF8TsUpYAiEw==
Date: Sun, 31 Dec 2023 14:58:51 -0800
Subject: [PATCH 6/6] xfs_scrub_all: failure reporting for the xfs_scrub_all
 job
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003057.1801496.18372212760015454598.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
References: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a failure reporting service for when xfs_scrub_all fails.  This
shouldn't happen often, but let's report anyways.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                      |    1 
 scrub/xfs_scrub_all.service.in      |    1 
 scrub/xfs_scrub_all_fail.service.in |   71 +++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail.in             |   35 ++++++++++++++---
 4 files changed, 101 insertions(+), 7 deletions(-)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in


diff --git a/scrub/Makefile b/scrub/Makefile
index 7bd3a355478..7e14d82ad66 100644
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
index 7cfe3a1bc42..2165494e64a 100644
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
index 00000000000..53479db8477
--- /dev/null
+++ b/scrub/xfs_scrub_all_fail.service.in
@@ -0,0 +1,71 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata Check for All Filesystems Failure Reporting
+Documentation=man:xfs_scrub_all(8)
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub_all
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# Make the entire filesystem readonly and /home inaccessible.
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
index ff5f20b45d8..5665f83f325 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -5,14 +5,13 @@
 # Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
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
 Content-Transfer-Encoding: 8bit
@@ -38,5 +39,25 @@ Please do not reply to this mesage.
 
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

