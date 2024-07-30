Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6580010F7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302159; cv=none; b=hXz2l34qOO6XQW7qjV3KxaT/3sTuF0Qs4OHKb1upsaI/ihuzc7UJ1wsNnHT5h1FYFKcnobKLAkZ7NW5S4ATX1LKePT7VTT+NEpvT2hxsyHQPIJI7bFCLoN+9VjuxqBmwQ0iag0wPXahQP47OApZwO18p7rS7AD1DoB05n05jC1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302159; c=relaxed/simple;
	bh=r7dKhAbCplgUcJAFoZFwoIDAJP6rc0yzpg/vuCm35R8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1ssBAIm7OLlRftjaBmpwpGFjqB5gvzN7TWXhGjBnDPb2jFtZUOA52eJEK+AxSm71l2Or27N52ZmVPwZGMI34ibd2tmVqWHQ8MCodMDaPoGZ/WWqez498qyKqrGf9nykeFuaSM3eUdNDWdro4cIyCv7ThP0NUT/KjXn88RUAvwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWeQmg8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWeQmg8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFA9C32786;
	Tue, 30 Jul 2024 01:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302159;
	bh=r7dKhAbCplgUcJAFoZFwoIDAJP6rc0yzpg/vuCm35R8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fWeQmg8CYeCSFCoBaPS7lNTZOjBdpF13H39+uDIF4h37FhAzsbHsFyIX2bF4fIzDm
	 HlZ6AgWaPZ1DytUdYD05iNT1aVulNmJf102ywxaeA1N8bfNDHDn9zYVzOisG+6N4mT
	 z4KPJi9fee1ksuFCYjCrFMTrZf+TXMwpiceEAntmOZDnQpXjkfJzPEHBUe4Co/Gzxb
	 V/2rMC2StYKl9LBTwT30zmMpRsc0VnRcLXr/PwSXccAuNIMXn9cVi1kapUk8z/8xir
	 Kx5dVpT/oihnD9G+BUdFUj9h4cBuALQwObmIOdbLChb2tIwsLuwPXIJHbjG98KdVC9
	 UOgqrv96x8iTQ==
Date: Mon, 29 Jul 2024 18:15:58 -0700
Subject: [PATCH 6/6] xfs_scrub_all: failure reporting for the xfs_scrub_all
 job
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849338.1350165.672580690717705898.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
References: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile                      |    1 
 scrub/xfs_scrub_all.service.in      |    1 
 scrub/xfs_scrub_all_fail.service.in |   71 +++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail.in             |   35 ++++++++++++++---
 4 files changed, 101 insertions(+), 7 deletions(-)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in


diff --git a/scrub/Makefile b/scrub/Makefile
index 0e09ed127..7e6882450 100644
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
index 8ed682989..b86b787d2 100644
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
index 000000000..53479db84
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
index e420917f6..089b438f0 100755
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

