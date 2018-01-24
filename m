Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932251AbeAXXxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 18:53:41 -0500
Subject: [PATCH 3/5] generic/403: don't spew '$GETFATTR_PROG: Killed'
 messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 24 Jan 2018 15:53:35 -0800
Message-ID: <151683801556.17051.2037237512407215800.stgit@magnolia>
In-Reply-To: <151683799705.17051.9987269343206294671.stgit@magnolia>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use a runfile presence check to control the background getfattr loop
instead of using kill -9.  This helps us to avoid the problem that
the controlling bash will print a process killed message, which wrecks
the golden output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/403 |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/generic/403 b/tests/generic/403
index 17897ff..18fd1e5 100755
--- a/tests/generic/403
+++ b/tests/generic/403
@@ -61,7 +61,9 @@ touch $SCRATCH_MNT/file
 $SETFATTR_PROG -n trusted.small -v a $SCRATCH_MNT/file
 
 # start a background getxattr loop for the existing xattr
-while [ true ]; do
+runfile="$tmp.getfattr"
+touch $runfile
+while [ -e $runfile ]; do
 	$GETFATTR_PROG --absolute-names -n trusted.small $SCRATCH_MNT/file \
 		> /dev/null || break
 done &
@@ -75,7 +77,7 @@ for i in $(seq 0 99); do
 	$SETFATTR_PROG -x trusted.big $SCRATCH_MNT/file
 done
 
-kill -9 $getfattr_pid > /dev/null 2>&1
+rm -rf $runfile
 wait > /dev/null 2>&1
 
 echo Silence is golden

