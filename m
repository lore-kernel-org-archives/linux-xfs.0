Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeAaUyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 15:54:15 -0500
Date: Wed, 31 Jan 2018 12:54:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 27/29] xfs_scrub: integrate services with systemd
Message-ID: <20180131205407.GG4849@magnolia>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
 <151736817316.32164.953271653758103738.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151736817316.32164.953271653758103738.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a systemd service unit so that we can run the online scrubber
under systemd with (somewhat) appropriate containment.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix pkgconfig autoconf thinko
v2: fix some of the debian packaging weirdness, kudos to Nathan Scott!
---
 .gitignore                       |    4 ++
 configure.ac                     |    2 +
 debian/postinst                  |    3 +
 include/builddefs.in             |    4 ++
 m4/Makefile                      |    1 
 m4/package_services.m4           |   77 ++++++++++++++++++++++++++++++++++++++
 scrub/Makefile                   |   36 +++++++++++++++++-
 scrub/xfs_scrub.c                |   32 ++++++++++++++++
 scrub/xfs_scrub@.service.in      |   20 ++++++++++
 scrub/xfs_scrub_all.cron.in      |    1 
 scrub/xfs_scrub_all.in           |   49 ++++++++++++++++++++++++
 scrub/xfs_scrub_all.service.in   |   10 +++++
 scrub/xfs_scrub_all.timer        |   11 +++++
 scrub/xfs_scrub_fail             |   26 +++++++++++++
 scrub/xfs_scrub_fail@.service.in |   10 +++++
 15 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 m4/package_services.m4
 create mode 100644 scrub/xfs_scrub@.service.in
 create mode 100644 scrub/xfs_scrub_all.cron.in
 create mode 100644 scrub/xfs_scrub_all.service.in
 create mode 100644 scrub/xfs_scrub_all.timer
 create mode 100755 scrub/xfs_scrub_fail
 create mode 100644 scrub/xfs_scrub_fail@.service.in

diff --git a/.gitignore b/.gitignore
index a3db640..d887451 100644
--- a/.gitignore
+++ b/.gitignore
@@ -69,6 +69,10 @@ cscope.*
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
+/scrub/xfs_scrub@.service
+/scrub/xfs_scrub_all
+/scrub/xfs_scrub_all.service
+/scrub/xfs_scrub_fail@.service
 
 # generated crc files
 /libxfs/crc32selftest
diff --git a/configure.ac b/configure.ac
index bb032e5..b438165 100644
--- a/configure.ac
+++ b/configure.ac
@@ -174,6 +174,8 @@ AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
+AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
+AC_CONFIG_CROND_DIR
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/debian/postinst b/debian/postinst
index d11c8d9..11693a6 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -8,6 +8,9 @@ case "${1}" in
 		then
 			update-initramfs -u
 		fi
+		if [ -x /bin/systemctl ]; then
+			/bin/systemctl daemon-reload
+		fi
 		;;
 
 	abort-upgrade|abort-remove|abort-deconfigure)
diff --git a/include/builddefs.in b/include/builddefs.in
index d44faf9..df76b2c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -127,6 +127,10 @@ HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
+HAVE_SYSTEMD = @have_systemd@
+SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
+HAVE_CROND = @have_crond@
+CROND_DIR = @crond_dir@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index 61d617e..a6d11e9 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -21,6 +21,7 @@ LSRCFILES = \
 	package_libcdev.m4 \
 	package_pthread.m4 \
 	package_sanitizer.m4 \
+	package_services.m4 \
 	package_types.m4 \
 	package_unistring.m4 \
 	package_utilies.m4 \
diff --git a/m4/package_services.m4 b/m4/package_services.m4
new file mode 100644
index 0000000..f2d888a
--- /dev/null
+++ b/m4/package_services.m4
@@ -0,0 +1,77 @@
+#
+# Figure out where to put systemd service units
+#
+AC_DEFUN([AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR],
+[
+	AC_REQUIRE([PKG_PROG_PKG_CONFIG])
+	AC_ARG_WITH([systemd_unit_dir],
+	  [AS_HELP_STRING([--with-systemd-unit-dir@<:@=DIR@:>@],
+		[Install systemd system units into DIR.])],
+	  [],
+	  [with_systemd_unit_dir=yes])
+	AS_IF([test "x${with_systemd_unit_dir}" != "xno"],
+	  [
+		AS_IF([test "x${with_systemd_unit_dir}" = "xyes"],
+		  [
+			PKG_CHECK_MODULES([systemd], [systemd],
+			  [
+				with_systemd_unit_dir="$($PKG_CONFIG --variable=systemdsystemunitdir systemd)"
+			  ], [
+				with_systemd_unit_dir=""
+			  ])
+			m4_pattern_allow([^PKG_(MAJOR|MINOR|BUILD|REVISION)$])
+		  ])
+		AC_MSG_CHECKING([for systemd system unit dir])
+		systemd_system_unit_dir="${with_systemd_unit_dir}"
+		AS_IF([test -n "${systemd_system_unit_dir}"],
+		  [
+			AC_MSG_RESULT(${systemd_system_unit_dir})
+			have_systemd="yes"
+		  ],
+		  [
+			AC_MSG_RESULT(no)
+			have_systemd="no"
+		  ])
+	  ],
+	  [
+		have_systemd="disabled"
+	  ])
+	AC_SUBST(have_systemd)
+	AC_SUBST(systemd_system_unit_dir)
+])
+
+#
+# Figure out where to install crontabs
+#
+AC_DEFUN([AC_CONFIG_CROND_DIR],
+[
+	AC_ARG_WITH([crond_dir],
+	  [AS_HELP_STRING([--with-crond-dir@<:@=DIR@:>@],
+		[Install system crontabs into DIR.])],
+	  [],
+	  [with_crond_dir=yes])
+	AS_IF([test "x${with_crond_dir}" != "xno"],
+	  [
+		AS_IF([test "x${with_crond_dir}" = "xyes"],
+		  [
+			AS_IF([test -d "/etc/cron.d"],
+			  [with_crond_dir="/etc/cron.d"])
+		  ])
+		AC_MSG_CHECKING([for system crontab dir])
+		crond_dir="${with_crond_dir}"
+		AS_IF([test -n "${crond_dir}"],
+		  [
+			AC_MSG_RESULT(${crond_dir})
+			have_crond="yes"
+		  ],
+		  [
+			AC_MSG_RESULT(no)
+			have_crond="no"
+		  ])
+	  ],
+	  [
+		have_crond="disabled"
+	  ])
+	AC_SUBST(have_crond)
+	AC_SUBST(crond_dir)
+])
diff --git a/scrub/Makefile b/scrub/Makefile
index ca6dab0..0632794 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -15,6 +15,19 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_ARGS = -b -n
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALL_SCRUB += install-systemd
+SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
+endif
+ifeq ($(HAVE_CROND),yes)
+INSTALL_SCRUB += install-crond
+CRONTABS = xfs_scrub_all.cron
+OPTIONAL_TARGETS += $(CRONTABS)
+# Don't enable the crontab by default for now
+CROND_DIR = $(PKG_LIB_DIR)/$(PKG_NAME)
+endif
+
 endif	# scrub_prereqs
 
 HFILES = \
@@ -84,7 +97,7 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
-default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
 
 xfs_scrub_all: xfs_scrub_all.in
 	@echo "    [SED]    $@"
@@ -98,6 +111,27 @@ include $(BUILDRULES)
 
 install: $(INSTALL_SCRUB)
 
+%.service: %.service.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
+		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
+		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
+		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
+
+%.cron: %.cron.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" < $< > $@
+
+install-systemd: default $(SYSTEMD_SERVICES)
+	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
+	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_DIR)/$(PKG_NAME)
+
+install-crond: default $(CRONTABS)
+	$(INSTALL) -m 755 -d $(CROND_DIR)
+	$(INSTALL) -m 644 $(CRONTABS) $(CROND_DIR)
+
 install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 47e1381..5ab557d 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -118,6 +118,10 @@
  * XFS_SCRUB_NO_SCSI_VERIFY	-- disable SCSI VERIFY (if present)
  * XFS_SCRUB_PHASE		-- run only this scrub phase
  * XFS_SCRUB_THREADS		-- start exactly this number of threads
+ *
+ * Available even in non-debug mode:
+ * SERVICE_MODE			-- compress all error codes to 1 for LSB
+ *				   service action compliance
  */
 
 /* Program name; needed for libfrog error reports. */
@@ -154,6 +158,12 @@ bool				want_fstrim = true;
 bool				stderr_isatty;
 bool				stdout_isatty;
 
+/*
+ * If we are running as a service, we need to be careful about what
+ * error codes we return to the calling process.
+ */
+static bool			is_service;
+
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
 #define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
@@ -624,6 +634,9 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (stdout_isatty && !progress_fp)
 		progress_fp = fdopen(1, "w+");
 
+	if (getenv("SERVICE_MODE"))
+		is_service = true;
+
 	/* Find the mount record for the passed-in argument. */
 	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
@@ -729,5 +742,24 @@ _("%s: %llu warnings found.\n"),
 	free(ctx.blkdev);
 	free(ctx.mntpoint);
 
+	/*
+	 * If we're being run as a service, the return code must fit the LSB
+	 * init script action error guidelines, which is to say that we
+	 * compress all errors to 1 ("generic or unspecified error", LSB 5.0
+	 * section 22.2) and hope the admin will scan the log for what
+	 * actually happened.
+	 *
+	 * We have to sleep 2 seconds here because journald uses the pid to
+	 * connect our log messages to the systemd service.  This is critical
+	 * for capturing all the log messages if the scrub fails, because the
+	 * fail service uses the service name to gather log messages for the
+	 * error report.
+	 */
+	if (is_service) {
+		sleep(2);
+		if (ret != SCRUB_RET_SUCCESS)
+			return 1;
+	}
+
 	return ret;
 }
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
new file mode 100644
index 0000000..c14f813
--- /dev/null
+++ b/scrub/xfs_scrub@.service.in
@@ -0,0 +1,20 @@
+[Unit]
+Description=Online XFS Metadata Check for %I
+OnFailure=xfs_scrub_fail@%i.service
+Documentation=man:xfs_scrub(8)
+
+[Service]
+Type=oneshot
+WorkingDirectory=%I
+PrivateNetwork=true
+ProtectSystem=full
+ProtectHome=read-only
+PrivateTmp=yes
+AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+NoNewPrivileges=yes
+User=nobody
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+Environment=SERVICE_MODE=1
+ExecStart=@sbindir@/xfs_scrub @scrub_args@ %I
+SyslogIdentifier=%N
diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
new file mode 100644
index 0000000..3dea929
--- /dev/null
+++ b/scrub/xfs_scrub_all.cron.in
@@ -0,0 +1 @@
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 7738644..fff05da 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -25,10 +25,19 @@ import json
 import threading
 import time
 import sys
+import os
 
 retcode = 0
 terminate = False
 
+def DEVNULL():
+	'''Return /dev/null in subprocess writable format.'''
+	try:
+		from subprocess import DEVNULL
+		return DEVNULL
+	except ImportError:
+		return open(os.devnull, 'wb')
+
 def find_mounts():
 	'''Map mountpoints to physical disks.'''
 
@@ -55,6 +64,13 @@ def find_mounts():
 				fs[mnt] = set([lastdisk])
 	return fs
 
+def kill_systemd(unit, proc):
+	'''Kill systemd unit.'''
+	proc.terminate()
+	cmd=['systemctl', 'stop', unit]
+	x = subprocess.Popen(cmd)
+	x.wait()
+
 def run_killable(cmd, stdout, killfuncs, kill_fn):
 	'''Run a killable program.  Returns program retcode or -1 if we can't start it.'''
 	try:
@@ -81,6 +97,19 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if terminate:
 			return
 
+		# Try it the systemd way
+		cmd=['systemctl', 'start', 'xfs_scrub@%s' % mnt]
+		ret = run_killable(cmd, DEVNULL(), killfuncs, \
+				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
+		if ret == 0 or ret == 1:
+			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+			sys.stdout.flush()
+			retcode |= ret
+			return
+
+		if terminate:
+			return
+
 		# Invoke xfs_scrub manually
 		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
 		ret = run_killable(cmd, None, killfuncs, \
@@ -112,6 +141,17 @@ def main():
 
 	fs = find_mounts()
 
+	# Tail the journal if we ourselves aren't a service...
+	journalthread = None
+	if 'SERVICE_MODE' not in os.environ:
+		try:
+			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
+					'-f', '-u', 'xfs_scrub@*', '-o', \
+					'cat']
+			journalthread = subprocess.Popen(cmd)
+		except:
+			pass
+
 	# Schedule scrub jobs...
 	running_devs = set()
 	killfuncs = set()
@@ -148,6 +188,15 @@ def main():
 			fs = []
 		cond.release()
 
+	if journalthread is not None:
+		journalthread.terminate()
+
+	# See the service mode comments in xfs_scrub.c for why we do this.
+	if 'SERVICE_MODE' in os.environ:
+		time.sleep(2)
+		if retcode != 0:
+			retcode = 1
+
 	sys.exit(retcode)
 
 if __name__ == '__main__':
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
new file mode 100644
index 0000000..66f82fc
--- /dev/null
+++ b/scrub/xfs_scrub_all.service.in
@@ -0,0 +1,10 @@
+[Unit]
+Description=Online XFS Metadata Check for All Filesystems
+ConditionACPower=true
+Documentation=man:xfs_scrub_all(8)
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+ExecStart=@sbindir@/xfs_scrub_all
+SyslogIdentifier=xfs_scrub_all
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer
new file mode 100644
index 0000000..2e4a33b
--- /dev/null
+++ b/scrub/xfs_scrub_all.timer
@@ -0,0 +1,11 @@
+[Unit]
+Description=Periodic XFS Online Metadata Check for All Filesystems
+
+[Timer]
+# Run on Sunday at 3:10am, to avoid running afoul of DST changes
+OnCalendar=Sun *-*-* 03:10:00
+RandomizedDelaySec=60
+Persistent=true
+
+[Install]
+WantedBy=timers.target
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
new file mode 100755
index 0000000..36dd50e
--- /dev/null
+++ b/scrub/xfs_scrub_fail
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# Email logs of failed xfs_scrub unit runs
+
+mailer=/usr/sbin/sendmail
+recipient="$1"
+test -z "${recipient}" && exit 0
+mntpoint="$2"
+test -z "${mntpoint}" && exit 0
+hostname="$(hostname -f 2>/dev/null)"
+test -z "${hostname}" && hostname="${HOSTNAME}"
+if [ ! -x "${mailer}" ]; then
+	echo "${mailer}: Mailer program not found."
+	exit 1
+fi
+
+(cat << ENDL
+To: $1
+From: <xfs_scrub@${hostname}>
+Subject: xfs_scrub failure on ${mntpoint}
+
+So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
+
+A log of what happened follows:
+ENDL
+systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint}") | "${mailer}" -t -i
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
new file mode 100644
index 0000000..785f881
--- /dev/null
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -0,0 +1,10 @@
+[Unit]
+Description=Online XFS Metadata Check Failure Reporting for %I
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %I
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal
