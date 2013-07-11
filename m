Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1145B7F54
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EEAE5304081
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f7S53qjNHONgD21N for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:18 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcHmx027019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:17 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 05/10 v2] xfstests: Allow to re-read configuration
Date: Thu, 11 Jul 2013 12:38:00 +0200
Message-Id: <1373539085-8577-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com

Move configuration initialization into a function so we can re-read it
without the need to reinclude the common/config file which would be
ugly. This is in preparation for adding support for sections into config
files.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/config | 104 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 49 deletions(-)

diff --git a/common/config b/common/config
index 1679acf..34c99e1 100644
--- a/common/config
+++ b/common/config
@@ -214,64 +214,70 @@ esac
 
 known_hosts()
 {
-  [ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
-
-  [ -f /etc/xfsqa.config ]             && . /etc/xfsqa.config
-  [ -f $HOST_CONFIG_DIR/$HOST ]        && . $HOST_CONFIG_DIR/$HOST
-  [ -f $HOST_CONFIG_DIR/$HOST.config ] && . $HOST_CONFIG_DIR/$HOST.config
-
-  #  Mandatory Config values.
-  MC=""
-  [ -z "$EMAIL" ]          && MC="$MC EMAIL"
-  [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
-  [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
-
-  if [ -n "$MC" ]; then
-    echo "Warning: need to define parameters for host $HOST"
-    echo "       or set variables:"
-    echo "       $MC"
-    exit 1
-  fi
+	[ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
+
+	[ -f /etc/xfsqa.config ]             && export HOST_OPTIONS=/etc/xfsqa.config
+	[ -f $HOST_CONFIG_DIR/$HOST ]        && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST
+	[ -f $HOST_CONFIG_DIR/$HOST.config ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST.config
 }
 
-if [ -f "$HOST_OPTIONS" ]; then
-    . "$HOST_OPTIONS"
-else
-    known_hosts
+if [ ! -f "$HOST_OPTIONS" ]; then
+	known_hosts
 fi
 
-echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
-    exit 1
+if [ -f "$HOST_OPTIONS" ]; then
+	. $HOST_OPTIONS
 fi
 
-if [ ! -d "$TEST_DIR" ]; then
-    echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
-    exit 1
-fi
+get_next_config() {
+	#  Mandatory Config values.
+	MC=""
+	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
+	[ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
+	[ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
+
+	if [ -n "$MC" ]; then
+		echo "Warning: need to define parameters for host $HOST"
+		echo "       or set variables:"
+		echo "       $MC"
+		exit 1
+	fi
 
-# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
-# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
-if [ ! -z "$SCRATCH_DEV_POOL" ]; then
-    if [ ! -z "$SCRATCH_DEV" ]; then
-        echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
-        exit 1
-    fi
-    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
-    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
-fi
+	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
+		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+		exit 1
+	fi
 
-echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-    echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
-    exit 1
-fi
+	if [ ! -d "$TEST_DIR" ]; then
+		echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
+		exit 1
+	fi
 
-if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
-    echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
-    exit 1
-fi
+	# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
+	# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
+	if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+		if [ ! -z "$SCRATCH_DEV" ]; then
+			echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
+			exit 1
+		fi
+		SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+		SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
+	fi
+
+	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
+	if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
+		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
+		exit 1
+	fi
+
+	if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
+		echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
+		exit 1
+	fi
+}
+
+get_next_config
 
 # make sure this script returns success
 /bin/true
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
