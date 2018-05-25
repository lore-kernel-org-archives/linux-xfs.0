Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:12:23 -0400
Subject: [PATCH 5/7] fsck: fix more bashisms
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:12:07 -0700
Message-ID: <152728632778.22515.10077636373761717143.stgit@magnolia>
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

command -v is a bashism, so we need to get rid of it.  The shell returns
an error code of 127 if it couldn't invoke xfs_repair, so teach
repair2fsck_code to deal with this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsck/xfs_fsck.sh |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)


diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 1916c07e..6af0f224 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -20,6 +20,10 @@ repair2fsck_code() {
 		;;
 	4)  return 1 # The fs has been fixed
 		;;
+	127)
+		echo "$NAME error: xfs_repair was not found!" 1>&2
+		return 4
+		;;
 	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
 		return 4 # something went wrong with xfs_repair
 	esac
@@ -59,13 +63,7 @@ if [ -n "$PS1" -o -t 0 ]; then
 fi
 
 if $FORCE; then
-	XFS_REPAIR=`command -v xfs_repair`
-	if [ ! -x "$XFS_REPAIR" ] ; then
-		echo "$NAME error: xfs_repair was not found!" 1>&2
-		exit 4
-	fi
-
-	$XFS_REPAIR -e $DEV
+	xfs_repair -e $DEV
 	repair2fsck_code $?
 	exit $?
 fi

