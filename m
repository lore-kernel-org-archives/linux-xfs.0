Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD429415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689035; cv=none; b=tiRmyuAezjhuVUjgbXw9d7FhHLVrwDJJifeByebOprY512i2q3gQbyyJrE7eddU8KBEbh9aSDF0mqFDtuDkwU1rLqOc5mRNTIkticc9Jeaq9W/lCKZwHX6S3NpSk043Vbotjb4/vQoWeQxWay2dRKb8nzfRUEAoI6wR80tH1yHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689035; c=relaxed/simple;
	bh=7D+6DF9jStlT8NJegArPe4LMYv9T52+D0wBi3Yu07UE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BWVFb0Kcm8gRhcpM/GR3t+dSBgGMYKFfz4OIp5GoFptFEj21fZqRt+a3lL+k7z0z0mgXPH1WuD5JFfzs/HEog+WCT/127oKogafihS7Q/Uh3AfJfBOesq3pUVdC26E/gdx/fyAG9CJ8hl3S3CeVmbvaIrErdAjN4JlQ69MsJDW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e692z9qL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e692z9qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB98C4CED2;
	Tue, 31 Dec 2024 23:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689035;
	bh=7D+6DF9jStlT8NJegArPe4LMYv9T52+D0wBi3Yu07UE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e692z9qLwkaowaeRcsnyYTXHXOVZbZSGwMjYfuBPZTXoASjv6vxW0UiV29rntrP7C
	 7RFymTL2qvQdiPvuT1ch9SvcZBF65ncQ9jbejRrQ0pJJLO0U3RtFQkH8YjHnelB2a5
	 lWTeKn7U3WzlH+CaRoUm4+uNmAo/RDRnj2eAXs3JqFNk05B7Z7zQ+6X0KiuhL7MbmD
	 SytVJSfs+VmMdM00GUAou24zTbzQaMLFhJNePfcHzmRwUfEFo17h6IDxJLxCvnKV5+
	 tBv82zqDHGW+pGFHEaSpOPGsm5pphOF8xQMLqh2mUvxh94YqpBxC16y5OYhXxNgpCS
	 aBnqO9NISgS1g==
Date: Tue, 31 Dec 2024 15:50:34 -0800
Subject: [PATCH 11/21] xfs_scrubbed: create daemon to listen for health events
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778630.2710211.3580509295160781690.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile        |   15 ++-
 scrub/xfs_scrubbed.in |  287 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 300 insertions(+), 2 deletions(-)
 create mode 100644 scrub/xfs_scrubbed.in


diff --git a/scrub/Makefile b/scrub/Makefile
index 1e1109048c2a83..bd910922ceb4bb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,6 +18,7 @@ XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
+XFS_SCRUBBED_PROG = xfs_scrubbed
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -108,9 +109,9 @@ endif
 # Automatically trigger a media scan once per month
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
 
-LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
+LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(XFS_SCRUBBED_PROG) *.service *.cron
 
-default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(XFS_SCRUBBED_PROG) $(OPTIONAL_TARGETS)
 
 xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
@@ -123,6 +124,14 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
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
@@ -165,6 +174,8 @@ install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUBBED_PROG) $(PKG_LIBEXEC_DIR)
 	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
 
 install-udev: $(UDEV_RULES)
diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
new file mode 100644
index 00000000000000..4d742a9151a082
--- /dev/null
+++ b/scrub/xfs_scrubbed.in
@@ -0,0 +1,287 @@
+#!/usr/bin/python3
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2025 Oracle.  All rights reserved.
+#
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Daemon to listen for and react to filesystem health events
+
+import sys
+import os
+import argparse
+import fcntl
+import json
+import datetime
+import errno
+import ctypes
+import gc
+from concurrent.futures import ProcessPoolExecutor
+
+debug = False
+log = False
+everything = False
+debug_fast = False
+printf_prefix = ''
+
+# ioctl encoding stuff
+_IOC_NRBITS   =  8
+_IOC_TYPEBITS =  8
+_IOC_SIZEBITS = 14
+_IOC_DIRBITS  =  2
+
+_IOC_NRMASK   = (1 << _IOC_NRBITS) - 1
+_IOC_TYPEMASK = (1 << _IOC_TYPEBITS) - 1
+_IOC_SIZEMASK = (1 << _IOC_SIZEBITS) - 1
+_IOC_DIRMASK  = (1 << _IOC_DIRBITS) - 1
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
+def _IOC(direction, type, nr, t):
+	assert direction <= _IOC_DIRMASK, direction
+	assert type <= _IOC_TYPEMASK, type
+	assert nr <= _IOC_NRMASK, nr
+
+	size = ctypes.sizeof(t)
+	assert size <= _IOC_SIZEMASK, size
+
+	return (((direction)  << _IOC_DIRSHIFT) |
+		((type) << _IOC_TYPESHIFT) |
+		((nr)   << _IOC_NRSHIFT) |
+		((size) << _IOC_SIZESHIFT))
+
+def _IOR(type, number, size):
+	return _IOC(_IOC_READ, type, number, size)
+
+def _IOW(type, number, size):
+	return _IOC(_IOC_WRITE, type, number, size)
+
+def _IOWR(type, number, size):
+	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
+
+# xfs health monitoring ioctl stuff
+XFS_HEALTH_MONITOR_FMT_JSON = 1
+XFS_HEALTH_MONITOR_VERBOSE = 1 << 0
+
+class xfs_health_monitor(ctypes.Structure):
+	_fields_ = [
+		('flags',	ctypes.c_ulonglong),
+		('format',	ctypes.c_ubyte),
+		('_pad0',	ctypes.c_ubyte * 7),
+		('_pad1',	ctypes.c_ulonglong * 2)
+	]
+assert ctypes.sizeof(xfs_health_monitor) == 32
+
+XFS_IOC_HEALTH_MONITOR = _IOW(0x58, 68, xfs_health_monitor)
+
+def open_health_monitor(fd, verbose = False):
+	'''Return a health monitoring fd.'''
+
+	arg = xfs_health_monitor()
+	arg.format = XFS_HEALTH_MONITOR_FMT_JSON
+
+	if verbose:
+		arg.flags |= XFS_HEALTH_MONITOR_VERBOSE
+
+	ret = fcntl.ioctl(fd, XFS_IOC_HEALTH_MONITOR, arg)
+	return ret
+
+# main program
+
+def health_reports(mon_fp):
+	'''Generate python objects describing health events.'''
+	global debug
+	global printf_prefix
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
+	'''Log a monitoring event to stdout.'''
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
+def handle_event(event):
+	'''Handle an event asynchronously.'''
+	def stringify_timestamp(event):
+		'''Try to convert a timestamp to something human readable.'''
+		try:
+			ts = datetime.datetime.fromtimestamp(event['time_ns'] / 1e9).astimezone()
+			event['time'] = str(ts)
+			del event['time_ns']
+		except Exception as e:
+			# Not a big deal if we can't format the timestamp, but
+			# let's yell about that loudly
+			print(f'{printf_prefix}: bad timestamp: {e}', file = sys.stderr)
+
+	global log
+
+	stringify_timestamp(event)
+	if log:
+		log_event(event)
+	if event['type'] == 'lost':
+		report_lost(event)
+	elif event['type'] == 'shutdown':
+		report_shutdown(event)
+
+def monitor(mountpoint, event_queue, **kwargs):
+	'''Monitor the given mountpoint for health events.'''
+	global everything
+
+	fd = os.open(mountpoint, os.O_RDONLY)
+	try:
+		mon_fd = open_health_monitor(fd, verbose = everything)
+	except OSError as e:
+		if e.errno != errno.ENOTTY and e.errno != errno.EOPNOTSUPP:
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
+		nr = 0
+		for e in health_reports(mon_fp):
+			event_queue.submit(handle_event, e)
+
+			# Periodically run the garbage collector to constrain
+			# memory usage in the main thread.  If only there was
+			# a way to submit to a queue without everything being
+			# tied up in a Future
+			if nr % 5355 == 0:
+				gc.collect()
+			nr += 1
+
+	return 0
+
+def main():
+	global debug
+	global log
+	global printf_prefix
+	global everything
+	global debug_fast
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
+	parser.add_argument('--debug-fast', action = 'store_true', \
+			help = argparse.SUPPRESS)
+	args = parser.parse_args()
+
+	if args.V:
+		print("xfs_scrubbed version @pkg_version@")
+		return 0
+
+	if args.mountpoint is None:
+		parser.error("the following arguments are required: mountpoint")
+		return 1
+
+	if args.debug:
+		debug = True
+	if args.log:
+		log = True
+	if args.everything:
+		everything = True
+	if args.debug_fast:
+		debug_fast = True
+
+	# Use a separate subprocess to handle the events so that the main event
+	# reading process does not block on the GIL of the event handling
+	# subprocess.  The downside is that we cannot pass function pointers
+	# and all data must be pickleable; the upside is not losing events.
+	#
+	# If the secret maximum efficiency setting is enabled, assume this is
+	# part of QA, so use all CPUs to process events.  Normally we start one
+	# background process to minimize service footprint.
+	if debug_fast:
+		args.event_queue = ProcessPoolExecutor()
+	else:
+		args.event_queue = ProcessPoolExecutor(max_workers = 1)
+
+	printf_prefix = args.mountpoint
+	ret = 0
+	try:
+		ret = monitor(**vars(args))
+	except KeyboardInterrupt:
+		# Consider SIGINT to be a clean exit.
+		pass
+
+	args.event_queue.shutdown()
+	return ret
+
+if __name__ == '__main__':
+	sys.exit(main())

