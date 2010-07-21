Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LGmaOU087735 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 11:48:36 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA0791211EB3
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 09:51:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CFbGDpTP6Ex1awuv for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 09:51:36 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] Provide generic function for checking quota usage
Date: Wed, 21 Jul 2010 18:50:51 +0200
Message-Id: <1279731052-30631-2-git-send-email-jack@suse.cz>
In-Reply-To: <1279731052-30631-1-git-send-email-jack@suse.cz>
References: <1279731052-30631-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

Provide generic function _check_quota_usage for checking whether quota usage
matches the space used and use it in proper tests.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 231          |   18 +++---------------
 231.out      |    6 ++++++
 232          |   14 +-------------
 232.out      |    2 ++
 233          |   14 +-------------
 233.out      |    2 ++
 common.quota |   36 ++++++++++++++++++++++++++++++++++++
 7 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/231 b/231
index ebbe11e..e499c9a 100755
--- a/231
+++ b/231
@@ -49,18 +49,6 @@ s,$SCRATCH_DEV,[SCR_DEV],;
         print;"
 }
 
-check_usage()
-{
-	quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
-		>$tmp.orig
-	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
-		>$tmp.checked
-	quotaon -u -g $SCRATCH_MNT 2>/dev/null
-	diff $tmp.orig $tmp.checked
-}
-
 _fsx()
 {
 	tasks=$1
@@ -104,7 +92,7 @@ if ! _fsx 1; then
 	exit
 fi
 
-if ! check_usage; then
+if ! _check_quota_usage; then
 	umount $SCRATCH_DEV 2>/dev/null
 	status=1
 	exit
@@ -116,7 +104,7 @@ if ! _fsx 4; then
 	exit
 fi
 
-if ! check_usage; then
+if ! _check_quota_usage; then
 	umount $SCRATCH_DEV 2>/dev/null
 	status=1
 	exit
@@ -130,7 +118,7 @@ if ! _fsx 1; then
 	exit
 fi
 
-if ! check_usage; then
+if ! _check_quota_usage; then
 	umount $SCRATCH_DEV 2>/dev/null
 	status=1
 	exit
diff --git a/231.out b/231.out
index 2f2d072..ef264a9 100644
--- a/231.out
+++ b/231.out
@@ -1,10 +1,16 @@
 QA output created by 231
 === FSX Standard Mode, Memory Mapping, 1 Tasks ===
 All operations completed A-OK!
+Comparing user usage
+Comparing group usage
 === FSX Standard Mode, Memory Mapping, 4 Tasks ===
 All operations completed A-OK!
 All operations completed A-OK!
 All operations completed A-OK!
 All operations completed A-OK!
+Comparing user usage
+Comparing group usage
 === FSX Standard Mode, Memory Mapping, 1 Tasks ===
 All operations completed A-OK!
+Comparing user usage
+Comparing group usage
diff --git a/232 b/232
index cf4d25a..d5f99bd 100755
--- a/232
+++ b/232
@@ -46,18 +46,6 @@ s,$SCRATCH_DEV,[SCR_DEV],;
         print;"
 }
 
-check_usage()
-{
-	quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
-		sort >$tmp.orig
-	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
-		sort >$tmp.checked
-	quotaon -u -g $SCRATCH_MNT 2>/dev/null
-	diff $tmp.orig $tmp.checked
-}
-
 _filter_num()
 {
 	tee -a $here/$seq.full |\
@@ -104,7 +92,7 @@ if ! _fsstress; then
 	exit
 fi
 
-if ! check_usage; then
+if ! _check_quota_usage; then
 	umount $SCRATCH_DEV 2>/dev/null
 	status=1
 	exit
diff --git a/232.out b/232.out
index 744192e..ef82a89 100644
--- a/232.out
+++ b/232.out
@@ -4,3 +4,5 @@ Testing fsstress
 
 fsstress -n 2000 -d outdir -p 7
 seed = S
+Comparing user usage
+Comparing group usage
diff --git a/233 b/233
index b967e0d..5060931 100755
--- a/233
+++ b/233
@@ -50,18 +50,6 @@ s,$SCRATCH_DEV,[SCR_DEV],;
         print;"
 }
 
-check_usage()
-{
-	quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
-		sort >$tmp.orig
-	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
-	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
-		sort >$tmp.checked
-	quotaon -u -g $SCRATCH_MNT 2>/dev/null
-	diff $tmp.orig $tmp.checked
-}
-
 _filter_num()
 {
 	tee -a $here/$seq.full |\
@@ -113,7 +101,7 @@ if ! _fsstress; then
 	exit
 fi
 
-if ! check_usage; then
+if ! _check_quota_usage; then
 	umount $SCRATCH_DEV 2>/dev/null
 	status=1
 	exit
diff --git a/233.out b/233.out
index 208910d..fa36ca3 100644
--- a/233.out
+++ b/233.out
@@ -4,3 +4,5 @@ Testing fsstress
 
 fsstress -z -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 -n 5000 -d outdir -p 7
 seed = S
+Comparing user usage
+Comparing group usage
diff --git a/common.quota b/common.quota
index d32e285..655e34d 100644
--- a/common.quota
+++ b/common.quota
@@ -211,5 +211,41 @@ _qmount_option()
 	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seq.full
 }
 
+_check_quota_usage()
+{
+	# Sync to get delalloc to disk
+	sync
+	VFS_QUOTA=0
+	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP = "reiserfs" ]; then
+		VFS_QUOTA=1
+		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
+	fi
+	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.user.orig
+	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.group.orig
+	if [ $VFS_QUOTA -eq 1 ]; then
+		quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+	else
+		# use XFS method to force quotacheck
+		mount -o remount,noquota $SCRATCH_DEV
+		mount -o remount,usrquota,grpquota $SCRATCH_DEV
+	fi
+	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.user.checked
+	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.group.checked
+	if [ $VFS_QUOTA -eq 1 ]; then
+		quotaon -u -g $SCRATCH_MNT 2>/dev/null
+	fi
+	{
+		echo "Comparing user usage"
+		diff $tmp.user.orig $tmp.user.checked
+	} && {
+		echo "Comparing group usage"
+		diff $tmp.group.orig $tmp.group.checked
+	}
+}
+
 # make sure this script returns success
 /bin/true
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
