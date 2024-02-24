Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A529C625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738529; cv=none; b=NEVIUTlYtENJAKY3rvSw0y2LkTQSK80hm4Jx8WOUEX3yhVSrkZuMbgmxGcl31aVVyBbNqNPf7ACwon1TkAIc30o4Px2q2MEA1RyJpQ+G3EIuaPL7L9z4tboUg5U0AWASaASYijMYdXcl+N/lD+9SuAJeNchPlGmtiFQKVwi215E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738529; c=relaxed/simple;
	bh=giZOtI4ZoVB8UiWJKnITh6O95jAX+QjZuP0t4elluQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZzpNOLwyV/fWqxJ18NVDoubWlykKVIjYpfiSEVUCeSK45+MJbpmuTsULa27pnl3npHRBqVdCFs7gg7JOIv4uSVaWp669Cfxc11D2c670Ld1a250SmYIlRCmnkHoo2gYbr33ZU/Gj3/0FiUjMc98DFKF+ZwGuV9y4+s/4JuVRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9V4P0HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9V4P0HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35284C433C7;
	Sat, 24 Feb 2024 01:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738529;
	bh=giZOtI4ZoVB8UiWJKnITh6O95jAX+QjZuP0t4elluQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i9V4P0HRY3s0ATDhJCdT4N/A25DtWcOW9lZphUyP7TXkt9I4WBxl/Z34Zqa5xDp3v
	 sHdZMGK4KqzVOPuObFD/SihPzxyqJXmXvNfQ95GlUldK5MRHXO3EjlxxgpTr3XuVA5
	 /Dqu2j+vqh01reyGDFB9C7+04mFB8kpLNzlsWBywhvYqX5gWoW0TH+3i+Znj+aPR3C
	 DSsD2Ux4wk/yygaKqy7tUY2hwb8IWc4b/n5q7QzfbPHxQSH4J6nxdBpQQkuzE2JlFR
	 s+U3ZWKFMnRF6AQWjesZKb7Sd4RvovS/IZJ7GpP4CnW7Nl5ZlOgJP9HBsa0mnWxVEt
	 mtwLNlqxcfW8Q==
Date: Fri, 23 Feb 2024 17:35:28 -0800
Subject: [PATCH 5/7] xfs_scrubbed: create daemon to listen for health events
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836626.1902540.6213624466323713329.stgit@frogsfrogsfrogs>
In-Reply-To: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
References: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
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

Create a daemon program that can listen for and log health events.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile        |   15 +++
 scrub/xfs_scrubbed.in |  217 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 230 insertions(+), 2 deletions(-)
 create mode 100644 scrub/xfs_scrubbed.in


diff --git a/scrub/Makefile b/scrub/Makefile
index c0fc927f4278..cf112018376b 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,6 +18,7 @@ XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b
+XFS_SCRUBBED_PROG = xfs_scrubbed
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -124,9 +125,9 @@ endif
 # Automatically trigger a media scan once per month
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
 
-LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
+LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(XFS_SCRUBBED_PROG) *.service *.cron
 
-default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(XFS_SCRUBBED_PROG) $(OPTIONAL_TARGETS)
 
 xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
@@ -139,6 +140,14 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
+xfs_scrubbed: xfs_scrubbed.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   < $< > $@
+	$(Q)chmod a+x $@
+
 xfs_scrub_fail: xfs_scrub_fail.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
@@ -182,6 +191,8 @@ install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUBBED_PROG) $(PKG_LIBEXEC_DIR)
 	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
 
 install-udev: $(UDEV_RULES)
diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
new file mode 100644
index 000000000000..0c72f5c54a78
--- /dev/null
+++ b/scrub/xfs_scrubbed.in
@@ -0,0 +1,217 @@
+#!/usr/bin/python3
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (C) 2024 Oracle.  All rights reserved.
+#
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Daemon to listen for and react to filesystem health events
+
+import sys
+import os
+import argparse
+import fcntl
+import struct
+import json
+import datetime
+import errno
+
+debug = False
+log = False
+everything = False
+printf_prefix = ''
+
+# ioctl encoding stuff
+_IOC_NRBITS   =  8
+_IOC_TYPEBITS =  8
+_IOC_SIZEBITS = 14
+_IOC_DIRBITS  =  2
+
+_IOC_NRSHIFT   = 0
+_IOC_TYPESHIFT = (_IOC_NRSHIFT   + _IOC_NRBITS)
+_IOC_SIZESHIFT = (_IOC_TYPESHIFT + _IOC_TYPEBITS)
+_IOC_DIRSHIFT  = (_IOC_SIZESHIFT + _IOC_SIZEBITS)
+
+_IOC_NONE  = 0
+_IOC_WRITE = 1
+_IOC_READ  = 2
+
+def _IOC(direction, type, nr, size):
+	return (((direction)  << _IOC_DIRSHIFT) |
+		((type) << _IOC_TYPESHIFT) |
+		((nr)   << _IOC_NRSHIFT) |
+		((size) << _IOC_SIZESHIFT))
+
+def _IOR(type, number, size):
+	return _IOC(_IOC_READ, type, number, size)
+
+# xfs health monitoring ioctl stuff
+XFS_HEALTH_MONITOR_FMT_JSON = 1
+XFS_HEALTH_MONITOR_VERBOSE = 1 << 0
+xfs_health_monitor = struct.Struct('QB' + ('x' * 23))
+XFS_IOC_HEALTH_MONITOR = _IOR(0x58, 48, xfs_health_monitor.size)
+
+def open_health_monitor(fd, verbose = False):
+	'''Return a health monitoring fd.'''
+	assert xfs_health_monitor.size == 32
+
+	flags = 0
+	fmt = XFS_HEALTH_MONITOR_FMT_JSON
+
+	if verbose:
+		flags |= XFS_HEALTH_MONITOR_VERBOSE
+
+	# Create an immutable byte array representation of struct args, then
+	# pass it to the ioctl function as a mutable byte array so that the
+	# return value is the kernel fd and /not/ the post-syscall byte array
+	# contents.
+	arg = xfs_health_monitor.pack(flags, fmt)
+	ret = fcntl.ioctl(fd, XFS_IOC_HEALTH_MONITOR, bytearray(arg))
+	return ret
+
+# main program
+
+def health_reports(mon_fp):
+	'''Generate python objects describing health events.'''
+	global debug, printf_prefix
+
+	lines = []
+	buf = mon_fp.readline()
+	while buf != '':
+		for line in buf.split('\0'):
+			line = line.strip()
+			if debug:
+				print(f'new line: {line}')
+			if line == '':
+				continue
+
+			lines.append(line)
+			if not '}' in line:
+				continue
+
+			s = ''.join(lines)
+			if debug:
+				print(f'new event: {s}')
+			try:
+				yield json.loads(s)
+			except json.decoder.JSONDecodeError as e:
+				print(f"{printf_prefix}: {e} from {s}",
+						file = sys.stderr)
+				pass
+			lines = []
+		buf = mon_fp.readline()
+
+def log_event(event):
+	global printf_prefix
+
+	print(f"{printf_prefix}: {event}")
+	sys.stdout.flush()
+
+def report_lost(event):
+	'''Report that the kernel lost events.'''
+	global printf_prefix
+
+	print(f"{printf_prefix}: Events were lost.")
+	sys.stdout.flush()
+
+def report_shutdown(event):
+	'''Report an abortive shutdown of the filesystem.'''
+	global printf_prefix
+	REASONS = {
+		"meta_ioerr":		"metadata IO error",
+		"log_ioerr":		"log IO error",
+		"force_umount":		"forced unmount",
+		"corrupt_incore":	"in-memory state corruption",
+		"corrupt_ondisk":	"ondisk metadata corruption",
+		"device_removed":	"device removal",
+	}
+
+	reasons = []
+	for reason in event['reasons']:
+		if reason in REASONS:
+			reasons.append(REASONS[reason])
+		else:
+			reasons.append(reason)
+
+	print(f"{printf_prefix}: Filesystem shut down due to {', '.join(reasons)}.")
+	sys.stdout.flush()
+
+def monitor(mountpoint):
+	'''Monitor the given mountpoint for health events.'''
+	global log, everything
+
+	fd = os.open(mountpoint, os.O_RDONLY)
+	try:
+		mon_fd = open_health_monitor(fd, verbose = everything)
+	except OSError as e:
+		if e.errno != errno.ENOTTY:
+			raise e
+		print(f"{mountpoint}: XFS health monitoring not supported.",
+				file = sys.stderr)
+		return 1
+	finally:
+		# Close the mountpoint if opening the health monitor fails
+		os.close(fd)
+
+	# Ownership of mon_fd (and hence responsibility for closing it) is
+	# transferred to the mon_fp object.
+	with os.fdopen(mon_fd) as mon_fp:
+		for event in health_reports(mon_fp):
+			try:
+				ts = datetime.datetime.fromtimestamp(event['time_ns'] / 1e9).astimezone()
+				event['time'] = str(ts)
+				del event['time_ns']
+			except Exception as e:
+				print(e)
+				pass
+			if log:
+				log_event(event)
+			if event['type'] == 'lost':
+				report_lost(event)
+			elif event['type'] == 'shutdown':
+				report_shutdown(event)
+
+	return 0
+
+def main():
+	global debug, log, printf_prefix, everything
+	ret = 0
+
+	parser = argparse.ArgumentParser( \
+			description = "XFS filesystem health monitoring demon.")
+	parser.add_argument("--debug", help = "Enabling debugging messages.", \
+			action = "store_true")
+	parser.add_argument("--log", help = "Log health events to stdout.", \
+			action = "store_true")
+	parser.add_argument("--everything", help = "Capture all events.", \
+			action = "store_true")
+	parser.add_argument("-V", help = "Report version and exit.", \
+			action = "store_true")
+	parser.add_argument('mountpoint', default = None, nargs = '?',
+			help = 'XFS filesystem mountpoint to target.')
+	args = parser.parse_args()
+
+	if args.V:
+		print("xfs_scrubbed version @pkg_version@")
+		sys.exit(0)
+
+	if args.mountpoint is None:
+		parser.error("the following arguments are required: mountpoint")
+		sys.exit(1)
+
+	if args.debug:
+		debug = True
+	if args.log:
+		log = True
+	if args.everything:
+		everything = True
+
+	printf_prefix = args.mountpoint
+	try:
+		ret = monitor(args.mountpoint)
+	except KeyboardInterrupt:
+		ret = 0
+	sys.exit(ret)
+
+if __name__ == '__main__':
+	main()

