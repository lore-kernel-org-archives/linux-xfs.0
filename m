Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDFDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiLaAh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:37:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026091EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71701CE1ABD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3E2C433EF;
        Sat, 31 Dec 2022 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447043;
        bh=r29if4Ljae8OPUh65xNYDgnCQ04CQ46UN1Goty8J5Cg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eypipV32RQf7jsg9okKxDrmA7CfLsg1Mskm/ZYCce6etT1+LavZiXJkFYLKg9z3mw
         HLgUpOKXiSCe7qBbznMr4vbQOGdM9aLLb9ff7nk7CL/H1MXSApJmzcXuwOW0A+GRK1
         npra2va9BnWdswXzjf7qZONO5rlLzNVEJg6p2MTbFeNcywM3g3PDnWqGzKQ4vdt4Yf
         18sWCbGQGjMse+udBe3cS6FTLwVOvZOzUVxYf/ytgUOPOdttYsv+aNMyN/eai84XE+
         seMwxxexmn7aLXFJPprc+d4V2gUSPqdjn6duf9TNV2MdDYWf21ZfBQ8ISXyOwMM15C
         lJMeB6Xk1QsIg==
Subject: [PATCH 1/4] xfs_scrub_all: support metadata+media scans of all
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871808.718563.8496649193632369381.stgit@magnolia>
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

Add the necessary systemd services and control bits so that
xfs_scrub_all can kick off a metadata+media scan of a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_scrub_all.8               |    5 +-
 scrub/Makefile                         |    2 +
 scrub/xfs_scrub_all.in                 |   27 ++++++++--
 scrub/xfs_scrub_fail                   |   13 +++--
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |   90 ++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 +++++++++++++++++++++++++++
 7 files changed, 204 insertions(+), 11 deletions(-)
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in


diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
index 74548802eda..86a9b3eced2 100644
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
index 1c36621b400..f65148e5469 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,6 +18,8 @@ INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
 	xfs_scrub@.service \
 	xfs_scrub_fail@.service \
+	xfs_scrub_media@.service \
+	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
 	xfs_scrub_all.timer \
 	system-xfs_scrub.slice
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 3e0c48acb39..eeb52b651b5 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -18,6 +18,7 @@ from io import TextIOWrapper
 
 retcode = 0
 terminate = False
+scrub_media = False
 
 def DEVNULL():
 	'''Return /dev/null in subprocess writable format.'''
@@ -111,6 +112,17 @@ def systemd_escape(path):
 	except:
 		return path
 
+def scrub_unitname(mnt):
+	'''Return the systemd service name.'''
+	global scrub_media
+
+	if mnt != '*':
+		mnt = systemd_escape(mnt)
+
+	if scrub_media:
+		return 'xfs_scrub_media@%s' % mnt
+	return 'xfs_scrub@%s' % mnt
+
 def systemctl_stop(unitname):
 	'''Stop a systemd unit.'''
 	cmd = ['systemctl', 'stop', unitname]
@@ -163,7 +175,7 @@ def systemctl_start(unitname, killfuncs):
 
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
-	global retcode, terminate
+	global retcode, terminate, scrub_media
 
 	print("Scrubbing %s..." % mnt)
 	sys.stdout.flush()
@@ -173,7 +185,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		unitname = 'xfs_scrub@%s' % systemd_escape(mnt)
+		unitname = scrub_unitname(mnt)
 		ret = systemctl_start(unitname, killfuncs)
 		if ret == 0 or ret == 1:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
@@ -187,6 +199,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		# Invoke xfs_scrub manually
 		cmd = ['@sbindir@/xfs_scrub']
 		cmd += '@scrub_args@'.split()
+		if scrub_media:
+			cmd += '-x'
 		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs, \
 				lambda proc: proc.terminate())
@@ -213,26 +227,31 @@ def main():
 		a = (mnt, cond, running_devs, devs, killfuncs)
 		thr = threading.Thread(target = run_scrub, args = a)
 		thr.start()
-	global retcode, terminate
+	global retcode, terminate, scrub_media
 
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
 
 	# Tail the journal if we ourselves aren't a service...
 	journalthread = None
 	if 'SERVICE_MODE' not in os.environ:
 		try:
+			unitname = scrub_unitname('*')
 			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
-					'-f', '-u', 'xfs_scrub@*', '-o', \
+					'-f', '-u', unitname, '-o', \
 					'cat']
 			journalthread = subprocess.Popen(cmd)
 		except:
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index fbe30cbc4c6..58c50abe963 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
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
 
@@ -48,12 +51,12 @@ mntpoint_esc="$(escape_path "${mntpoint}")"
 
 (cat << ENDL
 To: $1
-From: <xfs_scrub@${hostname}>
-Subject: xfs_scrub failure on ${mntpoint}
+From: <${service}@${hostname}>
+Subject: ${service} failure on ${mntpoint}
 
-So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
+So sorry, the automatic ${service} of ${mntpoint} on ${hostname} failed.
 
 A log of what happened follows:
 ENDL
-systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint_esc}") | "${mailer}" -t -i
+systemctl status --full --lines 4294967295 "${service}@${mntpoint_esc}") | "${mailer}" -t -i
 exit "${PIPESTATUS[1]}"
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 2c36c47ab02..cba194bad2d 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -10,7 +10,7 @@ Documentation=man:xfs_scrub(8)
 [Service]
 Type=oneshot
 Environment=EMAIL_ADDR=root
-ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %I
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub %I
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
diff --git a/scrub/xfs_scrub_media@.service.in b/scrub/xfs_scrub_media@.service.in
new file mode 100644
index 00000000000..d2b991856df
--- /dev/null
+++ b/scrub/xfs_scrub_media@.service.in
@@ -0,0 +1,90 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata and Media Check for %I
+OnFailure=xfs_scrub_media_fail@%i.service
+Documentation=man:xfs_scrub(8)
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+Environment=SERVICE_MOUNTPOINT=/tmp/scrub
+ExecStart=@sbindir@/xfs_scrub @scrub_args@ -x %I
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
+BindPaths=/%I:/tmp/scrub:norbind
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
index 00000000000..e6c45e72f20
--- /dev/null
+++ b/scrub/xfs_scrub_media_fail@.service.in
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Online XFS Metadata and Media Check Failure Reporting for %I
+Documentation=man:xfs_scrub(8)
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" xfs_scrub_media %I
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

