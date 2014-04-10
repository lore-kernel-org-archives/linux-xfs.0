Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D32057F82
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:36:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B847E304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 10:36:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WEjevtU65ltWDZWX for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 10:36:00 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: Add -s option to run only specified sections
Date: Thu, 10 Apr 2014 19:35:52 +0200
Message-Id: <1397151352-6614-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

This commit adds -s option which allows you to specify only certain
sections from the config file to be run. The '-s' argument can be
specified multiple times to allow multiple sections to be run.

The options are still carried between section, that includes the
sections which are not going to be run.

Update README.config-sections as well.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 README.config-sections | 30 ++++++++++++++++++++++++++++++
 check                  | 16 +++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/README.config-sections b/README.config-sections
index 2849fd5..865ca93 100644
--- a/README.config-sections
+++ b/README.config-sections
@@ -57,6 +57,36 @@ system.
 
 You can also force the file system recreation by specifying RECREATE_TEST_DEV.
 
+Run specified section only
+--------------------------
+
+Specifying '-s' argument with section name will run only the section
+specified. The '-s' argument can be specified multiple times to allow multiple
+sections to be run.
+
+The options are still carried between section, that includes the sections
+which are not going to be run. So you can do something like
+
+[ext4]
+TEST_DEV=/dev/sda1
+TEST_DIR=/mnt/test
+SCRATCH_DEV=/dev/sdb1
+SCRATCH_MNT=/mnt/test1
+FSTYP=ext4
+
+[xfs]
+FSTYP=xfs
+
+[btrfs]
+FSTYP=btrfs
+
+
+and run
+
+./check -s xfs -s btrfs
+
+to check xfs and btrfs only. All the devices and mounts are still going to
+be parsed from the section [ext4].
 
 Example
 -------
diff --git a/check b/check
index 09d753b..e7ace63 100755
--- a/check
+++ b/check
@@ -75,6 +75,7 @@ check options
     -T			output timestamps
     -r			randomize test order
     --large-fs		optimise scratch device for large filesystems
+    -s section		run only specified section from config file
 
 testlist options
     -g group[,group...]	include tests from these groups
@@ -221,7 +222,7 @@ while [ $# -gt 0 ]; do
 			done
 		done
 		;;
-
+	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
 	-l)	diff="diff" ;;
 	-udiff)	diff="$diff -u" ;;
 
@@ -389,6 +390,19 @@ for section in $HOST_OPTIONS_SECTIONS; do
 	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
 	get_next_config $section
 
+	# Do we need to run only some sections ?
+	if [ ! -z "$RUN_SECTION" ]; then
+		skip=true
+		for s in $RUN_SECTION; do
+			if [ $section == $s ]; then
+				skip=false
+			fi
+		done
+		if $skip; then
+			continue
+		fi
+	fi
+
 	mkdir -p $RESULT_BASE
 	if [ ! -d $RESULT_BASE ]; then
 		echo "failed to create results directory $RESULT_BASE"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
