Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfCAX2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NSoO6127312
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:50 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtsa56q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSlXn023020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:47 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSlV7021411
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:47 GMT
Subject: [PATCH 18/23] xfs_info: use findmnt to handle mounted block devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:45 -0800
Message-ID: <155148292592.16677.1870426029411000280.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
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
