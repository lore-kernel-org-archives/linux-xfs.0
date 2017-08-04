Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34004 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:58 -0400
Subject: [PATCH 21/22] xfs_scrub: create a script to scrub all xfs
 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:52 -0700
Message-ID: <150180539238.18784.10569656672872096606.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an xfs_scrub_all command to find all XFS filesystems
and run an online scrub against them all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/control           |    3 +
 debian/rules             |    1 
 man/man8/xfs_scrub_all.8 |   32 ++++++++++
 scrub/Makefile           |   15 ++++
 scrub/xfs_scrub_all.in   |  154 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 201 insertions(+), 4 deletions(-)
 create mode 100644 man/man8/xfs_scrub_all.8
 create mode 100644 scrub/xfs_scrub_all.in


diff --git a/debian/control b/debian/control
index c255ae6..30602cb 100644
--- a/debian/control
+++ b/debian/control
@@ -3,12 +3,13 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libunistring-dev
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libunistring-dev, dh-python
 Standards-Version: 3.9.1
 Homepage: http://xfs.org/
 
 Package: xfsprogs
 Depends: ${shlibs:Depends}, ${misc:Depends}
+Recommends: ${python3:Depends}, util-linux
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
diff --git a/debian/rules b/debian/rules
index c673380..a870944 100755
--- a/debian/rules
+++ b/debian/rules
@@ -76,6 +76,7 @@ binary-arch: checkroot built
 	$(pkgdi)  $(MAKE) -C debian install-d-i
 	$(pkgme)  $(MAKE) dist
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
+	dh_python3
 	dh_installdocs
 	dh_installchangelogs
 	dh_strip
diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8
new file mode 100644
index 0000000..5e1420b
--- /dev/null
+++ b/man/man8/xfs_scrub_all.8
@@ -0,0 +1,32 @@
+.TH xfs_scrub_all 8
+.SH NAME
+xfs_scrub_all \- scrub all mounted XFS filesystems
+.SH SYNOPSIS
+.B xfs_scrub_all
+.SH DESCRIPTION
+.B xfs_scrub_all
+attempts to read and check all the metadata on all mounted XFS filesystems.
+The online scrub is performed via the
+.B xfs_scrub
+tool, either by running it directly or by using systemd to start it
+in a restricted fashion.
+Mounted filesystems are mapped to physical storage devices so that scrub
+operations can be run in parallel so long as no two scrubbers access
+the same device simultaneously.
+.SH EXIT CODE
+The exit code returned by
+.B xfs_scrub_all
+is the sum of the following conditions:
+.br
+\	0\	\-\ No errors
+.br
+\	4\	\-\ File system errors left uncorrected
+.br
+\	8\	\-\ Operational error
+.br
+\	16\	\-\ Usage or syntax error
+.TP
+These are the same error codes returned by xfs_scrub.
+.br
+.SH SEE ALSO
+.BR xfs_scrub (8).
diff --git a/scrub/Makefile b/scrub/Makefile
index 5b3e522..9db4a5d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -13,6 +13,8 @@ SCRUB_PREREQS=$(PKG_PLATFORM)$(HAVE_OPENAT)$(HAVE_FSTATAT)
 ifeq ($(SCRUB_PREREQS),linuxyesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
+XFS_SCRUB_ALL_PROG = xfs_scrub_all
+XFS_SCRUB_ARGS = -n
 endif	# scrub_prereqs
 
 HFILES = \
@@ -83,17 +85,24 @@ ifeq ($(HAVE_ATTR_ROOT),yes)
 LCFLAGS += -DHAVE_ATTR_ROOT
 endif
 
-default: depend $(LTCOMMAND)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG)
+
+xfs_scrub_all: xfs_scrub_all.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
+		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
+	$(Q)chmod a+x $@
 
 unicrash.o xfs.o: $(TOPDIR)/include/builddefs
 
 include $(BUILDRULES)
 
-install: default $(INSTALL_SCRUB)
+install: $(INSTALL_SCRUB)
 
-install-scrub:
+install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_ROOT_SBIN_DIR)
 
 install-dev:
 
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
new file mode 100644
index 0000000..1abcef6
--- /dev/null
+++ b/scrub/xfs_scrub_all.in
@@ -0,0 +1,154 @@
+#!/usr/bin/env python3
+
+# Run online scrubbers in parallel, but avoid thrashing.
+#
+# Copyright (C) 2017 Oracle.  All rights reserved.
+#
+# Author: Darrick J. Wong <darrick.wong@oracle.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+
+import subprocess
+import json
+import threading
+import time
+import sys
+
+retcode = 0
+terminate = False
+
+def find_mounts():
+	'''Map mountpoints to physical disks.'''
+
+	fs = {}
+	cmd=['lsblk', '-o', 'KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
+	result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
+	result.wait()
+	if result.returncode != 0:
+		return fs
+	sarray = [x.decode('utf-8') for x in result.stdout.readlines()]
+	output = ' '.join(sarray)
+	bdevdata = json.loads(output)
+	# The lsblk output had better be in disks-then-partitions order
+	for bdev in bdevdata['blockdevices']:
+		if bdev['type'] == 'disk':
+			lastdisk = bdev['kname']
+		if bdev['fstype'] == 'xfs':
+			mnt = bdev['mountpoint']
+			if mnt is None:
+				continue
+			if mnt in fs:
+				fs[mnt].add(lastdisk)
+			else:
+				fs[mnt] = set([lastdisk])
+	return fs
+
+def run_killable(cmd, stdout, killfuncs, kill_fn):
+	'''Run a killable program.  Returns program retcode or -1 if we can't start it.'''
+	try:
+		proc = subprocess.Popen(cmd, stdout = stdout)
+		real_kill_fn = lambda: kill_fn(proc)
+		killfuncs.add(real_kill_fn)
+		proc.wait()
+		try:
+			killfuncs.remove(real_kill_fn)
+		except:
+			pass
+		return proc.returncode
+	except:
+		return -1
+
+def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
+	'''Run a scrub process.'''
+	global retcode, terminate
+
+	print("Scrubbing %s..." % mnt)
+	sys.stdout.flush()
+
+	try:
+		if terminate:
+			return
+
+		# Invoke xfs_scrub manually
+		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
+		ret = run_killable(cmd, None, killfuncs, \
+				lambda proc: proc.terminate())
+		if ret >= 0:
+			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+			sys.stdout.flush()
+			retcode |= ret
+			return
+
+		if terminate:
+			return
+
+		print("Unable to start scrub tool.")
+		sys.stdout.flush()
+	finally:
+		running_devs -= mntdevs
+		cond.acquire()
+		cond.notify()
+		cond.release()
+
+def main():
+	'''Find mounts, schedule scrub runs.'''
+	def thr(mnt, devs):
+		a = (mnt, cond, running_devs, devs, killfuncs)
+		thr = threading.Thread(target = run_scrub, args = a)
+		thr.start()
+	global retcode, terminate
+
+	fs = find_mounts()
+
+	# Schedule scrub jobs...
+	running_devs = set()
+	killfuncs = set()
+	cond = threading.Condition()
+	while len(fs) > 0:
+		if len(running_devs) == 0:
+			mnt, devs = fs.popitem()
+			running_devs.update(devs)
+			thr(mnt, devs)
+		poppers = set()
+		for mnt in fs:
+			devs = fs[mnt]
+			can_run = True
+			for dev in devs:
+				if dev in running_devs:
+					can_run = False
+					break
+			if can_run:
+				running_devs.update(devs)
+				poppers.add(mnt)
+				thr(mnt, devs)
+		for p in poppers:
+			fs.pop(p)
+		cond.acquire()
+		try:
+			cond.wait()
+		except KeyboardInterrupt:
+			terminate = True
+			print("Terminating...")
+			sys.stdout.flush()
+			while len(killfuncs) > 0:
+				fn = killfuncs.pop()
+				fn()
+			fs = []
+		cond.release()
+
+	sys.exit(retcode)
+
+if __name__ == '__main__':
+	main()

