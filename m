Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751553AbeCWOh2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Mar 2018 10:37:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0AEB14068051
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 14:37:28 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2 v6] fsck.xfs: allow forced repairs using xfs_repair
Date: Fri, 23 Mar 2018 15:33:13 +0100
Message-Id: <20180323143313.31277-1-jtulak@redhat.com>
In-Reply-To: <20180316170720.44227-1-jtulak@redhat.com>
References: <20180316170720.44227-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
run on every unclean shutdown. However, sometimes it may happen that the
root filesystem really requires the usage of xfs_repair and then it is a
hassle. This patch makes the situation a bit easier by detecting forced
checks (/forcefsck or fsck.mode=force) and invoking xfs_repair.

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
Changelog:
v6:
- update exit code 3->4
- avoid hardcoding xfs_repair path
- rename $BIN->$xfs_repair
- remove mounted check - xfs_repair does it on its own
- small manpage edit
- better explanation in the comment
v5:
- Change the message for xfs_repair code 2
v4:
- man page changes
v3:
- too quick with fixing in v2... add line at the end of the file
v2:
- return the "exit 0" at the end

v1:
- test for xfs_repair binary
- run only in non-interactive session
- translate xfs_repair return codes to fsck ones
- run only if the filesystem is not mounted
- add manpage update
---
 fsck/xfs_fsck.sh    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/fsck.xfs.8 |  7 +++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index e52969e4..c9fc3eb3 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -3,11 +3,35 @@
 # Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
 
+NAME=$0
+
+# get the right return code for fsck
+function repair2fsck_code() {
+	case $1 in
+	0)  return 0 # everything is ok
+		;;
+	1)  echo "$NAME error: xfs_repair could not fix the filesystem." 1>&2
+		return 4 # errors left uncorrected
+		;;
+	2)  echo "$NAME error: The filesystem log is dirty, mount it to recover" \
+		     "the log. If that fails, refer to the section DIRTY LOGS in the" \
+		     "xfs_repair manual page." 1>&2
+		return 4 # dirty log, don't do anything and let the user solve it
+		;;
+	4)  return 1 # The fs has been fixed
+		;;
+	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
+		return 4 # something went wrong with xfs_repair
+	esac
+}
+
 AUTO=false
-while getopts ":aApy" c
+FORCE=false
+while getopts ":aApyf" c
 do
 	case $c in
 	a|A|p|y)	AUTO=true;;
+	f)      	FORCE=true;;
 	esac
 done
 eval DEV=\${$#}
@@ -15,6 +39,37 @@ if [ ! -e $DEV ]; then
 	echo "$0: $DEV does not exist"
 	exit 8
 fi
+
+# The flag -f is added by systemd/init scripts when /forcefsck file is present
+# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
+# this check, user has to explicitly require a forced fsck.
+# But first of all, test if it is a non-interactive session.
+# Invoking xfs_repair via fsck.xfs is only intended to happen via initscripts.
+# Normal administrative filesystem repairs should always invoke xfs_repair
+# directly.
+#
+# Use multiple methods to capture most of the cases:
+# The case for *i* and -n "$PS1" are commonly suggested in bash manual
+# and the -t 0 test checks stdin
+case $- in
+	*i*) FORCE=false ;;
+esac
+if [ -n "$PS1" -o -t 0 ]; then
+	FORCE=false
+fi
+
+if $FORCE; then
+	XFS_REPAIR=`command -v xfs_repair`
+	if [ ! -x "$XFS_REPAIR" ] ; then
+		echo "$NAME error: xfs_repair was not found!" 1>&2
+		exit 4
+	fi
+
+	$XFS_REPAIR -e $DEV
+	repair2fsck_code $?
+	exit $?
+fi
+
 if $AUTO; then
 	echo "$0: XFS file system."
 else
diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
index ace7252d..a51baf7c 100644
--- a/man/man8/fsck.xfs.8
+++ b/man/man8/fsck.xfs.8
@@ -21,6 +21,13 @@ If you wish to check the consistency of an XFS filesystem,
 or repair a damaged or corrupt XFS filesystem,
 see
 .BR xfs_repair (8).
+.PP
+However, the system administrator can force
+.B fsck.xfs
+to run
+.BR xfs_repair (8)
+at boot time by creating a /forcefsck file or booting the system with
+"fsck.mode=force" on the kernel command line.
 .
 .SH FILES
 .IR /etc/fstab .
-- 
2.16.2

