Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UC3ivs031790 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 07:03:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Q34syAFqu61GyTlf for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 05:03:43 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q6UC3gSm028551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 08:03:43 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH] xfstests: Don't require to set $TEST_DEV and $TEST_DIR when
	creating new script
Date: Mon, 30 Jul 2012 14:03:31 +0200
Message-Id: <1343649811-13944-1-git-send-email-tracek@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>


Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common.config |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/common.config b/common.config
index 7bed1c5..b92c025 100644
--- a/common.config
+++ b/common.config
@@ -201,9 +201,9 @@ known_hosts()

   #  Mandatory Config values.
   MC=""
-  [ -z "$EMAIL" ]          && MC="$MC EMAIL"
-  [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
-  [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
+  [ -z "$EMAIL" ]                           && MC="$MC EMAIL"
+  [ -z "$TEST_DIR" ] && [ "$iam" != "new" ] && MC="$MC TEST_DIR"
+  [ -z "$TEST_DEV" ] && [ "$iam" != "new" ] && MC="$MC TEST_DEV"

   if [ -n "$MC" ]; then
     echo "Warning: need to define parameters for host $HOST"
@@ -219,15 +219,17 @@ else
     known_hosts
 fi

-echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
-    exit 1
-fi
-
-if [ ! -d "$TEST_DIR" ]; then
-    echo "common.config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
-    exit 1
+if [ "$iam" != "new" ]; then
+	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
+	    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+	    exit 1
+	fi
+
+	if [ ! -d "$TEST_DIR" ]; then
+	    echo "common.config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
+	    exit 1
+	fi
 fi

 # a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
--
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
