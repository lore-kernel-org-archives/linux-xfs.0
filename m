Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfCNVGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:14 -0400
Subject: [PATCH 22/36] xfs_info: use findmnt to handle mounted block devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:06:05 -0700
Message-ID: <155259756550.31886.4299958077869009509.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/control       |    2 +-
 spaceman/xfs_info.sh |   14 +++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)


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
index ecf17f61..70978164 100755
--- a/spaceman/xfs_info.sh
+++ b/spaceman/xfs_info.sh
@@ -24,11 +24,19 @@ set -- extra "$@"
 shift $OPTIND
 case $# in
 	1)
-		if [ -b "$1" ] || [ -f "$1" ]; then
-			xfs_db -p xfs_info -c "info" $OPTS "$1"
+		arg="$1"
+
+		# See if we can map the arg to a loop device
+		loopdev="$(losetup -n -O NAME -j "${arg}" 2> /dev/null)"
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
