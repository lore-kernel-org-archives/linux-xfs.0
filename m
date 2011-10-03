Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93N1LOd003735 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 18:01:21 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110032301.p93N1ISR023771@stout.americas.sgi.com>
Date: Mon, 03 Oct 2011 18:01:18 -0500
Subject: [PATCH] xfstests: 261: test failures caused by bogus mtab entries
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is code in libxcmd that sets up a table of mount points and
directories that may be subject to quota enforcement.  If any entry
in the mount table (/proc/self/mounts) is inaccessible or has any
other problems, libxcmd exits.

We have encountered mtab entries that appear to be artifacts from
autoumount that, when parsed for getmntent(), return paths in the
mnt_fsname field that do not exist.  Such entries tend to have the
text " (deleted)" appended to a legitimate pathname (although the
space character is expanded to \040, as documented in getmntent(3)).

The xfs_quota command supports the ability to specify an alternate
mount table file, so this test makes use of that feature to exercise
the problem.  The test simply uses xfs_quota to print the current
set of paths, providing an alternate mount table file.  First it
does so with a copy of the current mount table (which is assumed
OK), then an extra bogus entry (very much like what has been seen
in the wild) is appended to the mount table, and runs the xfs_quota
command again.

It does this with no mount options, as well as with user, group, and
project quota options enabled.  (Given the current state of the code
however, only one of these is required.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 261     |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 261.out |    2 +
 group   |    1 
 3 files changed, 129 insertions(+)

Index: b/261
===================================================================
--- /dev/null
+++ b/261
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test No. 261
+#
+# This test exercises an issue in libxcmd where a problem with any
+# mount point or project quota directory causes the program to exit
+# complete.  The effect of this is that one cannot operate on any
+# directory, even if the problem directory is completely unrelated
+# to the directory one wants to operate on.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 SGI.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+# creator
+owner=aelder@sgi.com
+
+seq=$(basename $0)
+echo "QA output created by ${seq}"
+
+here=$(pwd)
+
+tmp=/tmp/$$
+my_mtab=${tmp}.mtab
+
+mtab=/proc/self/mounts
+if [ ! -r "${mtab}" ]; then
+    mtab=/etc/mtab
+    if [ ! -r "${mtab}" ]; then
+	echo "warning: proceeding without use of mount table" >&2
+    fi
+fi
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f ${tmp}.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+echo "Silence is golden."
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_quota
+_require_scratch
+
+# Just use the current mount table as an example mtab file.  Odds
+# are good there's nothing wrong with it.
+_setup_my_mtab() {
+	cp "${mtab}" "${my_mtab}"
+}
+
+# Any bogus entry in the mtab file is enough to trigger the problem.
+# So just append a bogus entry at the end of the private mtab file.
+# This matches an actually-observed entry in a mount table (with a
+# few characters in the paths changed to protect the innocent).
+_perturb_my_mtab() {
+	cat <<-! >> "${my_mtab}"
+		/dev/disk/by-id/scsi-3600508e000000000c329ba1d8b0c391b-part3 /tmp/autoY8qcJ9\040(deleted) xfs rw 0 0
+	!
+}
+
+_check() {
+    	if [ $# -eq 0 ]; then
+		export MOUNT_OPTIONS=""
+	elif [ $# -eq 1 ]; then
+		[ $1 = u -o $1 = g -o $1 = p ] || exit
+		export MOUNT_OPTIONS="-o${1}quota"
+	else
+	    	exit
+	fi
+
+	_qmount
+
+	# Set up a private mount table file, then try out a simple quota
+	# command to show mounts
+	_setup_my_mtab
+	echo print | xfs_quota	-t "${my_mtab}" > /dev/null || exit
+
+	# Do the same simple quota command after adding a bogus entry to the
+	# mount table.  Old code will bail on this because it has trouble
+	# with the bogus entry.
+	_perturb_my_mtab
+	echo print | xfs_quota -t "${my_mtab}" > /dev/null || exit
+}
+
+#########
+
+# Mount SCRATCH with no quota options
+_check
+
+# user quota enabled
+_check u
+
+# group quota enabled
+_check g
+
+# user quota enabled
+_check p
+
+status=0	# success, all done
+
Index: b/261.out
===================================================================
--- /dev/null
+++ b/261.out
@@ -0,0 +1,2 @@
+QA output created by 261
+Silence is golden.
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -374,3 +374,4 @@ deprecated
 258 auto quick
 259 auto quick
 260 auto quick trim
+261 auto quick quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
