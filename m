Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEE310F9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302112; cv=none; b=R+wGdCOLK3spB/1ov/fMmRBkBgbwO6qWI5+d5jKFNEIGobo0B2zhe78PpR2i2/yv6eSipjBbadnjnv+hTaC94gi17xjSrVXkMs6+Thjz1uxBj+d/zHlsjGAPr8snpsIqJYKGkDmmFS/6SrqpQJfEiLTBD9SO5rksi6A21MqhoZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302112; c=relaxed/simple;
	bh=KUxKz/Lq5pRVQQLoL4Zxq78HJXTDSvI77lLaoPK1jWM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/nUTFLXDZjjgKwh4tA5DQMdCFHR3KLWrSUyZ7nPdc9yU7nyXO6zH40psNkg/9tUw3GRIsy4rwixrhtbQeqLZK/MqyUefr+z+sO3WecauVriuHb/5OTSe0eYMNc/52VWK67LJqqWuFfYFISaSBRXmaJLi/SaYveCqD8xOa3oDd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8rTZzGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8rTZzGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12690C32786;
	Tue, 30 Jul 2024 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302112;
	bh=KUxKz/Lq5pRVQQLoL4Zxq78HJXTDSvI77lLaoPK1jWM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t8rTZzGoz/V5qT89uI0kScU4rPAsECi/Ne7e+Jpwurn2xe5uydl2hd7l7lsLUTBSP
	 MOrA4QL/awMEgfWTWgackvTCX0GWGswTVWEALeHAzkFYhlih9RVNdqdrQTUXaXHSIa
	 wKMdcGsIZb7qWzgQY22s8Ap/aBPvUfN8dylRkly1FdXqZ2OXxjCUZaJCjCVfJbmXJV
	 wwJafimZs3v4sO6TdmVauDLwynFixJSov5ra2VbV2NzA2kn9/QlDAEFYaONIoUxUCe
	 qEX3kiOhcNLjWSr0fWQysScgX9jJhU/kB81dd01ATHqmbZXV7m4X+aenF3WKXziClS
	 vvMWFrdaX/DHQ==
Date: Mon, 29 Jul 2024 18:15:11 -0700
Subject: [PATCH 3/6] xfs_scrub_all: support metadata+media scans of all
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849292.1350165.4310944468823799093.stgit@frogsfrogsfrogs>
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

Add the necessary systemd services and control bits so that
xfs_scrub_all can kick off a metadata+media scan of a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_scrub_all.8               |    5 +-
 scrub/Makefile                         |    4 +
 scrub/xfs_scrub_all.in                 |   27 +++++++--
 scrub/xfs_scrub_fail.in                |   13 +++-
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |  100 ++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 ++++++++++++++++++++++++
 7 files changed, 214 insertions(+), 13 deletions(-)
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in


diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
index 74548802e..86a9b3ece 100644
--- a/man/man8/xfs_scrub_all.8
+++ b/man/man8/xfs_scrub_all.8
@@ -4,7 +4,7 @@ xfs_scrub_all \- scrub all mounted XFS filesystems
 .SH SYNOPSIS
 .B xfs_scrub_all
 [
-.B \-hV
+.B \-hxV
 ]
 .SH DESCRIPTION
 .B xfs_scrub_all
@@ -21,6 +21,9 @@ the same device simultaneously.
 .B \-h
 Display help.
 .TP
+.B \-x
+Read all file data extents to look for disk errors.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH EXIT CODE
diff --git a/scrub/Makefile b/scrub/Makefile
index 2050fe28f..5567ec061 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -9,6 +9,7 @@ include $(builddefs)
 SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
 scrub_svcname=xfs_scrub@.service
+scrub_media_svcname=xfs_scrub_media@.service
 
 ifeq ($(SCRUB_PREREQS),yes)
 LTCOMMAND = xfs_scrub
@@ -22,6 +23,8 @@ INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
 	$(scrub_svcname) \
 	xfs_scrub_fail@.service \
+	$(scrub_media_svcname) \
+	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
 	xfs_scrub_all.timer \
 	system-xfs_scrub.slice
@@ -113,6 +116,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index fc7a2e637..c1fd10986 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -19,6 +19,7 @@ from io import TextIOWrapper
 
 retcode = 0
 terminate = False
+scrub_media = False
 
 def DEVNULL():
 	'''Return /dev/null in subprocess writable format.'''
@@ -88,11 +89,15 @@ def run_killable(cmd, stdout, killfuncs):
 # systemd doesn't like unit instance names with slashes in them, so it
 # replaces them with dashes when it invokes the service.  Filesystem paths
 # need a special --path argument so that dashes do not get mangled.
-def path_to_serviceunit(path):
+def path_to_serviceunit(path, scrub_media):
 	'''Convert a pathname into a systemd service unit name.'''
 
-	cmd = ['systemd-escape', '--template', '@scrub_svcname@',
-	       '--path', path]
+	if scrub_media:
+		svcname = '@scrub_media_svcname@'
+	else:
+		svcname = '@scrub_svcname@'
+	cmd = ['systemd-escape', '--template', svcname, '--path', path]
+
 	try:
 		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
 		proc.wait()
@@ -153,7 +158,9 @@ def systemctl_start(unitname, killfuncs):
 
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
-	global retcode, terminate
+	global retcode
+	global terminate
+	global scrub_media
 
 	print("Scrubbing %s..." % mnt)
 	sys.stdout.flush()
@@ -164,7 +171,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 
 		# Run per-mount systemd xfs_scrub service only if we ourselves
 		# are running as a systemd service.
-		unitname = path_to_serviceunit(path)
+		unitname = path_to_serviceunit(path, scrub_media)
 		if unitname is not None and 'SERVICE_MODE' in os.environ:
 			ret = systemctl_start(unitname, killfuncs)
 			if ret == 0 or ret == 1:
@@ -183,6 +190,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if 'SERVICE_MODE' in os.environ:
 			cmd += '@scrub_service_args@'.split()
 		cmd += '@scrub_args@'.split()
+		if scrub_media:
+			cmd += '-x'
 		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs)
 		if ret >= 0:
@@ -247,18 +256,24 @@ def main():
 		a = (mnt, cond, running_devs, devs, killfuncs)
 		thr = threading.Thread(target = run_scrub, args = a)
 		thr.start()
-	global retcode, terminate
+	global retcode
+	global terminate
+	global scrub_media
 
 	parser = argparse.ArgumentParser( \
 			description = "Scrub all mounted XFS filesystems.")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
+	parser.add_argument("-x", help = "Scrub file data after filesystem metadata.", \
+			action = "store_true")
 	args = parser.parse_args()
 
 	if args.V:
 		print("xfs_scrub_all version @pkg_version@")
 		sys.exit(0)
 
+	scrub_media = args.x
+
 	fs = find_mounts()
 
 	# Schedule scrub jobs...
diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index 9437b0327..e420917f6 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -9,8 +9,11 @@
 
 recipient="$1"
 test -z "${recipient}" && exit 0
-mntpoint="$2"
+service="$2"
+test -z "${service}" && exit 0
+mntpoint="$3"
 test -z "${mntpoint}" && exit 0
+
 hostname="$(hostname -f 2>/dev/null)"
 test -z "${hostname}" && hostname="${HOSTNAME}"
 
@@ -21,16 +24,16 @@ if [ ! -x "${mailer}" ]; then
 fi
 
 # Turn the mountpoint into a properly escaped systemd instance name
-scrub_svc="$(systemd-escape --template "@scrub_svcname@" --path "${mntpoint}")"
+scrub_svc="$(systemd-escape --template "${service}@.service" --path "${mntpoint}")"
 
 (cat << ENDL
 To: $1
-From: <xfs_scrub@${hostname}>
-Subject: xfs_scrub failure on ${mntpoint}
+From: <${service}@${hostname}>
+Subject: ${service} failure on ${mntpoint}
 Content-Transfer-Encoding: 8bit
 Content-Type: text/plain; charset=UTF-8
 
-So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
+So sorry, the automatic ${service} of ${mntpoint} on ${hostname} failed.
 Please do not reply to this mesage.
 
 A log of what happened follows:
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 2c879afd6..16077888d 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -10,7 +10,7 @@ Documentation=man:xfs_scrub(8)
 [Service]
 Type=oneshot
 Environment=EMAIL_ADDR=root
-ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" %f
+ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub %f
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
diff --git a/scrub/xfs_scrub_media@.service.in b/scrub/xfs_scrub_media@.service.in
new file mode 100644
index 000000000..e670748ce
--- /dev/null
+++ b/scrub/xfs_scrub_media@.service.in
@@ -0,0 +1,100 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata and Media Check for %f
+OnFailure=xfs_scrub_media_fail@%i.service
+Documentation=man:xfs_scrub(8)
+
+# Explicitly require the capabilities that this program needs
+ConditionCapability=CAP_SYS_ADMIN
+ConditionCapability=CAP_FOWNER
+ConditionCapability=CAP_DAC_OVERRIDE
+ConditionCapability=CAP_DAC_READ_SEARCH
+ConditionCapability=CAP_SYS_RAWIO
+
+# Must be a mountpoint
+ConditionPathIsMountPoint=%f
+RequiresMountsFor=%f
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ @scrub_args@ -M /tmp/scrub/ -x %f
+SyslogIdentifier=%N
+
+# Run scrub with minimal CPU and IO priority so that nothing else will starve.
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+CPUAccounting=true
+Nice=19
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Dynamically create a user that isn't root
+DynamicUser=true
+
+# Make the entire filesystem readonly and /home inaccessible, then bind mount
+# the filesystem we're supposed to be checking into our private /tmp dir.
+# 'norbind' means that we don't bind anything under that original mount.
+ProtectSystem=strict
+ProtectHome=yes
+PrivateTmp=true
+BindPaths=%f:/tmp/scrub:norbind
+
+# Don't let scrub complain about paths in /etc/projects that have been hidden
+# by our sandboxing.  scrub doesn't care about project ids anyway.
+InaccessiblePaths=-/etc/projects
+
+# No network access
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=none
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
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
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+NoNewPrivileges=true
+
+# xfs_scrub doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
+DeviceAllow=block-*
diff --git a/scrub/xfs_scrub_media_fail@.service.in b/scrub/xfs_scrub_media_fail@.service.in
new file mode 100644
index 000000000..97c0e0907
--- /dev/null
+++ b/scrub/xfs_scrub_media_fail@.service.in
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata and Media Check Failure Reporting for %f
+Documentation=man:xfs_scrub(8)
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub_media %f
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
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

