Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628D3D27E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178122; cv=none; b=e+a4jjPFMWy6RLeOVLoCr1bvBW/ZeAlmoQhSQCjs+Uy5iSJBgNNEXtuHL5H9QQEioHsG9aU65HHNptGF1XYRcpsEK3iVZgRBLenaNn6I1ttQdnz690J7hLzLk3jI7NWarWBYplKEORi55ZoOoPNPesrUJ2aJoPsFeWs8utBA1wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178122; c=relaxed/simple;
	bh=AjBPzi0UcU8CEdU4/po9dqHKD9Ou5Bc4KoL+5q93mvc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hu59aa0rMkar7LWlVCVYOn1x1vRYlbKYjwBDKIfJt7fBl22Xfwsp/R9RFv3IraoAADc7G7w3jbdXcaUS5y0TYMzKwKX1n0BzIwJO2bTNfz7/UYi3fQA5iuPGq0vH3QLFcNpLWMg1V6sYi7ZbHBwB3hFfvsTvXMzhDn0rv+EvbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5lnoLas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5lnoLas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D300BC4CEE7;
	Thu, 23 Oct 2025 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178121;
	bh=AjBPzi0UcU8CEdU4/po9dqHKD9Ou5Bc4KoL+5q93mvc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l5lnoLas/v2sYrLOzxvV4AUUZRqXm6NkiQ7WGub0E9Hq5yqSDtu/JYNph9ESKd2KD
	 KjkjjiC0Wd0DkvQ6bsLvqGibkBgBmCZ+60RCIEJJp+JEomCZRaofsONH2BNHH3Qyp0
	 +Ui3ZN1pQo70BY3lOZPnj7IiG0mOqejtW+nNyEZ7IjmqJnuAyItg0SscsdMm4gWHtF
	 UeyA7BjPlM4f5Da+bLh7byFTrs/uU/hyNZG8xmvqknPaqZyTXbpU50XjK0qdiSIHy+
	 iCJbaKLGE8ev0G1BUZgXk7pdX5XA4EtlTHVAL4KDMksOduqXia/IFl2nKasHRfES6g
	 eFMCnOIYTdgag==
Date: Wed, 22 Oct 2025 17:08:41 -0700
Subject: [PATCH 12/26] xfs_healer: create daemon to listen for health events
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747693.1028044.9583394524555647160.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
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
Eventually this will be used to self-heal filesystems in real time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 Makefile                |    5 +
 configure.ac            |    6 +
 healer/Makefile         |   34 ++++
 healer/xfs_healer.py.in |  368 +++++++++++++++++++++++++++++++++++++++++++++++
 include/builddefs.in    |    1 
 5 files changed, 414 insertions(+)
 create mode 100644 healer/Makefile
 create mode 100644 healer/xfs_healer.py.in


diff --git a/Makefile b/Makefile
index c73aa391bc5f43..6056723b21348a 100644
--- a/Makefile
+++ b/Makefile
@@ -69,6 +69,10 @@ ifeq ("$(ENABLE_SCRUB)","yes")
 TOOL_SUBDIRS += scrub
 endif
 
+ifeq ("$(ENABLE_SCRUB)","yes")
+TOOL_SUBDIRS += healer
+endif
+
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
@@ -100,6 +104,7 @@ mkfs: libxcmd
 spaceman: libxcmd libhandle
 scrub: libhandle libxcmd
 rtcp: libfrog
+healer:
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/configure.ac b/configure.ac
index 1f6c11e5e78ebb..369cdd1696380a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -110,6 +110,12 @@ AC_ARG_ENABLE(libicu,
 [  --enable-libicu=[yes/no]  Enable Unicode name scanning in xfs_scrub (libicu) [default=probe]],,
 	enable_libicu=probe)
 
+# Enable xfs_healer build
+AC_ARG_ENABLE(healer,
+[  --enable-healer=[yes/no]  Enable build of xfs_healer utility [[default=yes]]],,
+	enable_healer=yes)
+AC_SUBST(enable_healer)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
diff --git a/healer/Makefile b/healer/Makefile
new file mode 100644
index 00000000000000..f0b3a62cd068b6
--- /dev/null
+++ b/healer/Makefile
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024-2025 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+builddefs=$(TOPDIR)/include/builddefs
+include $(builddefs)
+
+XFS_HEALER_PROG = xfs_healer.py
+INSTALL_HEALER = install-healer
+
+LDIRT = $(XFS_HEALER_PROG)
+
+default: $(XFS_HEALER_PROG)
+
+$(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
+		   -e '/@INIT_GETTEXT@/d' \
+		   < $< > $@
+	$(Q)chmod a+x $@
+
+include $(BUILDRULES)
+
+install: $(INSTALL_HEALER)
+
+install-healer: default
+	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
+	$(INSTALL) -m 755 $(XFS_HEALER_PROG) $(PKG_LIBEXEC_DIR)/xfs_healer
+
+install-dev:
+
+-include .dep
diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
new file mode 100644
index 00000000000000..507f537aea0d9a
--- /dev/null
+++ b/healer/xfs_healer.py.in
@@ -0,0 +1,368 @@
+#!/usr/bin/python3
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2025 Oracle.  All rights reserved.
+#
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Daemon to listen for and react to filesystem health events
+
+@INIT_GETTEXT@
+import sys
+import os
+import argparse
+import fcntl
+import json
+import datetime
+import errno
+import ctypes
+import pathlib
+import gc
+from concurrent.futures import ProcessPoolExecutor
+
+debug = False
+log = False
+everything = False
+debug_fast = False
+printf_prefix = ''
+
+def printlogln(*args, **kwargs):
+	'''Print a log message to stdout and flush it.'''
+	print(*args, **kwargs)
+	sys.stdout.flush()
+
+def eprintln(*args, **kwargs):
+	'''Print an error message to stderr.'''
+	print(*args, file = sys.stderr, **kwargs)
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
+				n = _("new line")
+				printlogln(f'{n}: {line}')
+			if line == '':
+				continue
+
+			lines.append(line)
+			if line == '}':
+				yield lines
+				lines = []
+		buf = mon_fp.readline()
+
+def report_event(event):
+	'''Log a monitoring event to stdout.'''
+	global printf_prefix
+
+	if event['domain'] == 'inode':
+		structures = ', '.join([_(x) for x in event['structures']])
+		status = _(event['type'])
+		printlogln(f"{printf_prefix}: {structures} {status}")
+
+	elif event['domain'] == 'perag':
+		structures = ', '.join([_(x) for x in event['structures']])
+		status = _(event['type'])
+		group = event['group']
+		agnom = _("agno")
+		printlogln(f"{printf_prefix}: {agnom} {group} {structures} {status}")
+
+	elif event['domain'] == 'fs':
+		structures = ', '.join([_(x) for x in event['structures']])
+		status = _(event['type'])
+		printlogln(f"{printf_prefix}: {structures} {status}")
+
+	elif event['domain'] == 'rtgroup':
+		structures = ', '.join([_(x) for x in event['structures']])
+		status = _(event['type'])
+		group = event['group']
+		rgnom = _("rgno")
+		printlogln(f"{printf_prefix}: {rgnom} {group} {structures} {status}")
+
+	elif event['domain'] in ('datadev', 'logdev', 'rtdev'):
+		device = _(event['domain'])
+		daddr = event['daddr']
+		bbcount = event['bbcount']
+		msg = _("media error on")
+		daddrm = _("daddr")
+		bbcountm = _("bbcount")
+		printlogln(f"{printf_prefix}: {msg} {device} {daddrm} {daddr:#x} {bbcountm} {bbcount:#x}")
+
+	elif event['domain'] == 'filerange':
+		event_type = _(event['type'])
+		pos = event['pos']
+		length = event['length']
+		posm = _("pos")
+		lenm = _("len")
+		printlogln(f"{printf_prefix}: {event_type} {posm} {pos} {lenm} {length}")
+
+def report_lost(event):
+	'''Report that the kernel lost events.'''
+	global printf_prefix
+
+	msg = _("events lost")
+	printlogln(f"{printf_prefix}: {msg}")
+
+def report_running(event):
+	'''Report that the monitor is running.'''
+	global printf_prefix
+
+	msg = _("monitoring started")
+	printlogln(f"{printf_prefix}: {msg}")
+
+def report_unmount(event):
+	'''Report that the filesystem was unmounted.'''
+	global printf_prefix
+
+	msg = _("filesystem unmounted")
+	printlogln(f"{printf_prefix}: {msg}")
+
+def report_shutdown(event):
+	'''Report an abortive shutdown of the filesystem.'''
+	global printf_prefix
+	REASONS = {
+		"meta_ioerr":		_("metadata IO error"),
+		"log_ioerr":		_("log IO error"),
+		"force_umount":		_("forced unmount"),
+		"corrupt_incore":	_("in-memory state corruption"),
+		"corrupt_ondisk":	_("ondisk metadata corruption"),
+		"device_removed":	_("device removal"),
+	}
+
+	reasons = []
+	for reason in event['reasons']:
+		if reason in REASONS:
+			reasons.append(REASONS[reason])
+		else:
+			reasons.append(reason)
+
+	some_reasons = ', '.join([_(x) for x in reasons])
+	msg = _("filesystem shut down due to")
+	printlogln(f"{printf_prefix}: {msg} {some_reasons}")
+
+def handle_event(lines):
+	'''Handle an event asynchronously.'''
+	global log
+
+	# Convert array of strings into a json object
+	try:
+		event = json.loads(''.join(lines))
+	except json.decoder.JSONDecodeError as e:
+		fromm = _("from")
+		eprintln(f"{printf_prefix}: {e} {fromm} {s}")
+		return
+
+	# Deal with reporting-only events; these should always generate log
+	# messages.
+	if event['type'] == 'lost':
+		report_lost(event)
+		return
+
+	if event['type'] == 'running':
+		report_running(event)
+		return
+
+	if event['type'] == 'unmount':
+		report_unmount(event)
+		return
+
+	if event['type'] == 'shutdown':
+		report_shutdown(event)
+		return
+
+	# Deal with everything else.
+	if log:
+		try:
+			report_event(event)
+		except Exception as e:
+			eprintln(f"event reporting: {e}")
+
+def monitor(mountpoint, event_queue, **kwargs):
+	'''Monitor the given mountpoint for health events.'''
+	global everything
+
+	def event_loop(mon_fd, event_queue):
+		# Ownership of mon_fd (and hence responsibility for closing it)
+		# is transferred to the mon_fp object.
+		with os.fdopen(mon_fd) as mon_fp:
+			nr = 0
+			for lines in health_reports(mon_fp):
+				event_queue.submit(handle_event, lines)
+
+				# Periodically run the garbage collector to
+				# constrain memory usage in the main thread.
+				# If only there was a way to submit to a queue
+				# without everything being tied up in a Future
+				if nr % 5355 == 0:
+					gc.collect()
+				nr += 1
+
+	try:
+		fd = os.open(mountpoint, os.O_RDONLY)
+	except Exception as e:
+		eprintln(f"{mountpoint}: {e}")
+		return 1
+
+	try:
+		mon_fd = open_health_monitor(fd, verbose = everything)
+	except OSError as e:
+		if e.errno == errno.ENOTTY or e.errno == errno.EOPNOTSUPP:
+			msg = _("XFS health monitoring not supported.")
+			eprintln(f"{mountpoint}: {msg}")
+		else:
+			eprintln(f"{mountpoint}: {e}")
+		return 1
+	except Exception as e:
+		eprintln(f"{mountpoint}: {e}")
+		return 1
+	finally:
+		# Close the mountpoint if opening the health monitor fails
+		os.close(fd)
+
+	try:
+		# mon_fd is consumed by this function
+		event_loop(mon_fd, event_queue)
+	except Exception as e:
+		eprintln(f"{mountpoint}: {e}")
+		return 1
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
+			description = _("Automatically heal damage to XFS filesystem metadata"))
+	parser.add_argument("-V", action = "store_true", \
+			help = _("Print version"))
+	parser.add_argument("--debug", action = "store_true", \
+			help = _("Enable debugging messages"))
+	parser.add_argument("--log", action = "store_true", \
+			help = _("Log health events to stdout"))
+	parser.add_argument("--everything", action = "store_true", \
+			help = _("Capture all events"))
+	parser.add_argument('mountpoint', default = None, nargs = '?', metavar = _('PATH'), type = pathlib.Path, \
+			help = _('XFS filesystem mountpoint to monitor'))
+	parser.add_argument('--debug-fast', action = 'store_true', \
+			help = argparse.SUPPRESS)
+	args = parser.parse_args()
+
+	if args.V:
+		vs = _("xfs_healer version")
+		pkgver = "@pkg_version@"
+		printlogln(f"{vs} {pkgver}")
+		return 0
+
+	if args.mountpoint is None:
+		parser.error(_("The following arguments are required: mountpoint"))
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
+	args.event_queue = ProcessPoolExecutor()
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
diff --git a/include/builddefs.in b/include/builddefs.in
index b38a099b7d525a..cb43029dc1f4c1 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -91,6 +91,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_SCRUB	= @enable_scrub@
+ENABLE_HEALER	= @enable_healer@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 

