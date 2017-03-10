Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22192 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755050AbdCJXZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:25:47 -0500
Subject: [PATCH 9/9] xfs_scrub: integrate services with systemd
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:25:41 -0800
Message-ID: <148918834114.8311.4698303987559106316.stgit@birch.djwong.org>
In-Reply-To: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
References: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a systemd service unit so that we can run the online scrubber
under systemd with (somewhat) appropriate containment.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac                     |   15 +++++++++++++
 include/builddefs.in             |    3 +++
 scrub/Makefile                   |   21 +++++++++++++++++-
 scrub/scrub.c                    |   20 +++++++++++++++++
 scrub/xfs_scrub@.service.in      |   18 ++++++++++++++++
 scrub/xfs_scrub_all.in           |   44 ++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub_all.service.in   |    8 +++++++
 scrub/xfs_scrub_all.timer        |   11 ++++++++++
 scrub/xfs_scrub_fail             |   26 ++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   10 +++++++++
 10 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 scrub/xfs_scrub@.service.in
 create mode 100644 scrub/xfs_scrub_all.service.in
 create mode 100644 scrub/xfs_scrub_all.timer
 create mode 100755 scrub/xfs_scrub_fail
 create mode 100644 scrub/xfs_scrub_fail@.service.in


diff --git a/configure.ac b/configure.ac
index ccd7460..e89aea0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,6 +103,21 @@ esac
 AC_SUBST([root_sbindir])
 AC_SUBST([root_libdir])
 
+# Where do systemd services go?
+pkg_systemdsystemunitdir="$(pkg-config --variable=systemdsystemunitdir systemd 2>/dev/null)"
+case "${pkg_systemdsystemunitdir}" in
+"")
+	systemdsystemunitdir=""
+	have_systemd=no
+	;;
+*)
+	systemdsystemunitdir="${pkg_systemdsystemunitdir}"
+	have_systemd=yes
+	;;
+esac
+AC_SUBST([have_systemd])
+AC_SUBST([systemdsystemunitdir])
+
 # Find localized files.  Don't descend into any "dot directories"
 # (like .git or .pc from quilt).  Strangely, the "-print" argument
 # to "find" is required, to avoid including such directories in the
diff --git a/include/builddefs.in b/include/builddefs.in
index 9d478d3..d99c402 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -123,6 +123,9 @@ HAVE_OPENAT = @have_openat@
 HAVE_SYNCFS = @have_syncfs@
 HAVE_FSTATAT = @have_fstatat@
 
+HAVE_SYSTEMD = @have_systemd@
+SYSTEMDSYSTEMUNITDIR = @systemdsystemunitdir@
+
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
diff --git a/scrub/Makefile b/scrub/Makefile
index 78e119f..d34e3d4 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -12,6 +12,12 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_ARGS = -Tvn
+
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALL_SCRUB += install-systemd
+SYSTEMDSERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+endif
+
 endif	# scrub_prereqs
 
 HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h xfs_ioctl.h
@@ -38,7 +44,7 @@ ifeq ($(HAVE_SYNCFS),yes)
 LCFLAGS += -DHAVE_SYNCFS
 endif
 
-default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(SYSTEMDSERVICES)
 
 xfs_scrub_all: xfs_scrub_all.in
 	@echo "    [SED]    $@"
@@ -50,6 +56,19 @@ include $(BUILDRULES)
 
 install: $(INSTALL_SCRUB)
 
+%.service: %.service.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_ROOT_SBIN_DIR)|g" \
+		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
+		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
+		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
+
+install-systemd: default
+	$(INSTALL) -m 755 -d $(SYSTEMDSYSTEMUNITDIR)
+	$(INSTALL) -m 644 $(SYSTEMDSERVICES) $(SYSTEMDSYSTEMUNITDIR)
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_DIR)/$(PKG_NAME)
+
 install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
diff --git a/scrub/scrub.c b/scrub/scrub.c
index a363ac1..0b6a11d 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -44,6 +44,7 @@ bool				dumpcore;
 bool				display_rusage;
 long				page_size;
 int				nr_threads = -1;
+bool				is_service;
 enum errors_action		error_action = ERRORS_CONTINUE;
 static unsigned long		max_errors;
 
@@ -830,6 +831,9 @@ _("Only one of the options -n or -y may be specified.\n"));
 
 	ctx.mntpoint = argv[optind];
 
+	if (getenv("SERVICE_MODE"))
+		is_service = true;
+
 	/* Find the mount record for the passed-in argument. */
 
 	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
@@ -957,5 +961,21 @@ _("%s: %lu warnings found.\n"),
 	free(ctx.mntpoint);
 	free(ctx.mnt_type);
 end:
+	/*
+	 * If we're running as a service, bump return code up by 16 to
+	 * avoid conflicting with service return codes.
+	 */
+	if (is_service) {
+		/*
+		 * journald queries /proc as part of taking in log
+		 * messages; it uses this information to associate the
+		 * message with systemd units, etc.  This races with
+		 * process exit, so delay that a couple of seconds so
+		 * that we capture the summary outputs in the job log.
+		 */
+		sleep(2);
+		if (ret)
+			ret += 16;
+	}
 	return ret;
 }
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
new file mode 100644
index 0000000..6b6992d
--- /dev/null
+++ b/scrub/xfs_scrub@.service.in
@@ -0,0 +1,18 @@
+[Unit]
+Description=Online XFS Metadata Check for %I
+OnFailure=xfs_scrub_fail@%i.service
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
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 2215720..81e0cc2 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -25,6 +25,7 @@ import json
 import threading
 import time
 import sys
+import os
 
 retcode = 0
 terminate = False
@@ -53,6 +54,13 @@ def find_mounts():
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
@@ -78,6 +86,20 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if terminate:
 			return
 
+		# Try it the systemd way
+		cmd=['systemctl', 'start', 'xfs_scrub@%s' % mnt]
+		ret = run_killable(cmd, subprocess.DEVNULL, killfuncs, \
+				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
+		if ret == 0 or (ret >= 16 and ret <= 32):
+			if ret != 0:
+				ret -= 16
+			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+			retcode |= ret
+			return
+
+		if terminate:
+			return
+
 		# Invoke xfs_scrub manually
 		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
 		ret = run_killable(cmd, None, killfuncs, \
@@ -107,6 +129,17 @@ def main():
 
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
@@ -142,6 +175,17 @@ def main():
 			fs = []
 		cond.release()
 
+	if journalthread is not None:
+		journalthread.terminate()
+
+	# journald queries /proc as part of taking in log
+	# messages; it uses this information to associate the
+	# message with systemd units, etc.  This races with
+	# process exit, so delay that a couple of seconds so
+	# that we capture the summary outputs in the job log.
+	if 'SERVICE_MODE' in os.environ:
+		time.sleep(2)
+
 	sys.exit(retcode)
 
 if __name__ == '__main__':
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
new file mode 100644
index 0000000..15b0af9
--- /dev/null
+++ b/scrub/xfs_scrub_all.service.in
@@ -0,0 +1,8 @@
+[Unit]
+Description=Online XFS Metadata Check for All Filesystems
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+ConditionACPower=true
+ExecStart=@sbindir@/xfs_scrub_all
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer
new file mode 100644
index 0000000..efc13a6
--- /dev/null
+++ b/scrub/xfs_scrub_all.timer
@@ -0,0 +1,11 @@
+[Unit]
+Description=Periodic XFS Online Metadata Check for All Filesystems
+
+[Timer]
+# Run on Sunday at 2am
+OnCalendar=Sun *-*-* 02:00:00
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

