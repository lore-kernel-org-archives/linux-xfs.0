Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HEtYr2189253 for <xfs@oss.sgi.com>; Tue, 17 May 2011 09:55:35 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD2E945DA4E
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:55:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QDY3ycJ8RJpCZZXu for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 07:55:33 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 719EA890B6
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 16:55:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfstests: Improve test 219 to work with all filesystems
Date: Tue, 17 May 2011 16:55:04 +0200
Message-Id: <1305644104-612-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Different filesystems account different amount of metadata in quota. Thus it is
impractical to check for a particular amount of space occupied by a file
because there is no right value. Change the test to verify whether the amount
of space before quotacheck and after quotacheck is the same as other quota
tests do.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 219          |    4 +---
 219.out      |   18 ++----------------
 common.quota |   52 ++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/219 b/219
index 836d703..7c22dac 100755
--- a/219
+++ b/219
@@ -76,9 +76,7 @@ test_accounting()
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
-
-	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
+	_check_quota_usage
 }
 
 # real QA test starts here
diff --git a/219.out b/219.out
index fadfafc..7a86b94 100644
--- a/219.out
+++ b/219.out
@@ -22,14 +22,7 @@ QA output created by 219
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for user quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
-                        Block limits                File limits
-User            used    soft    hard  grace    used  soft  hard  grace
-----------------------------------------------------------------------
-#1        --     144       0       0              3     0     0       
-
-
+Comparing user usage
 
 ### test group accounting
 
@@ -53,11 +46,4 @@ User            used    soft    hard  grace    used  soft  hard  grace
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for group quotas on device SCRATCH_DEV
-Block grace time: 7days; Inode grace time: 7days
-                        Block limits                File limits
-Group           used    soft    hard  grace    used  soft  hard  grace
-----------------------------------------------------------------------
-#2        --     144       0       0              3     0     0       
-
-
+Comparing group usage
diff --git a/common.quota b/common.quota
index 3c87ce1..9cb9304 100644
--- a/common.quota
+++ b/common.quota
@@ -236,36 +236,60 @@ _check_quota_usage()
 {
 	# Sync to get delalloc to disk
 	sync
+	USRQUOTA=0
+	GRPQUOTA=0
+	QMNTOPT=""
+	if echo $MOUNT_OPTIONS | grep -E "uquota|usrquota|uqnoenforce" &>/dev/null; then
+		USRQUOTA=1
+		QMNTOPT=",usrquota"
+	fi
+	if echo $MOUNT_OPTIONS | grep -E "gquota|grpquota|gqnoenforce" &>/dev/null; then
+		GRPQUOTA=1
+		QMNTOPT=$QMNTOPT",grpquota"
+	fi
 	VFS_QUOTA=0
 	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP = "reiserfs" ]; then
 		VFS_QUOTA=1
 		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
 	fi
-	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-		sort >$tmp.user.orig
-	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-		sort >$tmp.group.orig
+	if [ $USRQUOTA == 1 ]; then
+		repquota -u -n $SCRATCH_MNT  | grep -v "^#0" |
+			_filter_scratch | sort >$tmp.user.orig
+	fi
+	if [ $GRPQUOTA == 1 ]; then
+		repquota -g -n $SCRATCH_MNT  | grep -v "^#0" |
+			_filter_scratch | sort >$tmp.group.orig
+	fi
 	if [ $VFS_QUOTA -eq 1 ]; then
 		quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 	else
 		# use XFS method to force quotacheck
 		mount -o remount,noquota $SCRATCH_DEV
-		mount -o remount,usrquota,grpquota $SCRATCH_DEV
+		mount -o remount$QMNTOPT $SCRATCH_DEV
+	fi
+	if [ $USRQUOTA == 1 ]; then
+		repquota -u -n $SCRATCH_MNT  | grep -v "^#0" |
+			_filter_scratch | sort >$tmp.user.checked
+	fi
+	if [ $GRPQUOTA == 1 ]; then
+		repquota -g -n $SCRATCH_MNT  | grep -v "^#0" |
+			_filter_scratch | sort >$tmp.group.checked
 	fi
-	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-		sort >$tmp.user.checked
-	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
-		sort >$tmp.group.checked
 	if [ $VFS_QUOTA -eq 1 ]; then
 		quotaon -u -g $SCRATCH_MNT 2>/dev/null
 	fi
-	{
+	if [ $USRQUOTA == 1 ]; then
 		echo "Comparing user usage"
-		diff $tmp.user.orig $tmp.user.checked
-	} && {
+		if ! diff $tmp.user.orig $tmp.user.checked; then
+			return 1
+		fi
+	fi
+	if [ $GRPQUOTA == 1 ]; then
 		echo "Comparing group usage"
-		diff $tmp.group.orig $tmp.group.checked
-	}
+		if ! diff $tmp.group.orig $tmp.group.checked; then
+			return 1
+		fi
+	fi
 }
 
 # make sure this script returns success
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
