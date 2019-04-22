Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVPpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 11:45:05 -0400
Subject: [PATCH 02/10] xfs_info: use findmnt to handle mounted block devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 22 Apr 2019 08:45:02 -0700
Message-ID: <155594790268.115924.87682432738525436.stgit@magnolia>
In-Reply-To: <155594788997.115924.16224143537288136652.stgit@magnolia>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use findmnt to determine if the passed-in argument is associated with a
mount point, and if so, use spaceman to query the mounted filesystem.
If the user passed in a file, try to find out if it's a loop mounted
live filesystem and if so query the live filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/control       |    2 +-
 spaceman/xfs_info.sh |   22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)


diff --git a/debian/control b/debian/control
index f4f807b0..0b3205f5 100644
--- a/debian/control
+++ b/debian/control
@@ -8,7 +8,7 @@ Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
 Package: xfsprogs
-Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any
+Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any, util-linux
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
index ecf17f61..1bf6d2c3 100755
--- a/spaceman/xfs_info.sh
+++ b/spaceman/xfs_info.sh
@@ -7,6 +7,14 @@
 OPTS=""
 USAGE="Usage: xfs_info [-V] [-t mtab] [mountpoint|device|file]"
 
+# Try to find a loop device associated with a file.  We only want to return
+# one loopdev (multiple loop devices can attach to a single file) so we grab
+# the last line and return it if it's actually a block device.
+try_find_loop_dev_for_file() {
+	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
+	test -b "$x" && echo "$x"
+}
+
 while getopts "t:V" c
 do
 	case $c in
@@ -24,11 +32,19 @@ set -- extra "$@"
 shift $OPTIND
 case $# in
 	1)
-		if [ -b "$1" ] || [ -f "$1" ]; then
-			xfs_db -p xfs_info -c "info" $OPTS "$1"
+		arg="$1"
+
+		# See if we can map the arg to a loop device
+		loopdev="$(try_find_loop_dev_for_file "${arg}")"
+		test -n "${loopdev}" && arg="${loopdev}"
+
+		# If we find a mountpoint for the device, do a live query;
+		# otherwise try reading the fs with xfs_db.
+		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
+			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
 			status=$?
 		else
-			xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
+			xfs_db -p xfs_info -c "info" $OPTS "${arg}"
 			status=$?
 		fi
 		;;
