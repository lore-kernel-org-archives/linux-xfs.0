Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F9qodE082274 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 04:52:50 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEF5E3C8B6F
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 02:55:26 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id RGM0F4W3JHn3MN5B for <xfs@oss.sgi.com>;
	Tue, 15 Jun 2010 02:55:26 -0700 (PDT)
Date: Tue, 15 Jun 2010 11:55:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Message-ID: <20100615095505.GB3347@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <4C0FD43D.3040803@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> Jan Kara wrote:
> > Run fsx (and also several fsx threads in parallel) and verify that
> > quota accounting is correct after they finish.
> 
> Jan, I'm having trouble with this one on XFS for some reason, with our 
> RHEL6 kernel and quota-3.17...
  OK, attached is an improvement to the XFSQA tests after which all quota
tests pass for XFS just fine.
  The second patch is just minor general improvement of _require_scratch
macro.
  Could they be added to XFSQA repository? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--yEPQxsgoJgBvi8ip
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Provide-generic-function-for-checking-quota-usage.patch"

>From 5f184d21e781f1b14365c356e6c80030964aaaf7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 10 Jun 2010 12:49:11 +0200
Subject: [PATCH 1/2] Provide generic function for checking quota usage

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


--yEPQxsgoJgBvi8ip
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Add-test-for-correct-SCRATCH_MNT-into-_require_scrat.patch"

>From d72c11b63aa22c920b460a71d4384c2f39be6513 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Jun 2010 10:54:12 +0200
Subject: [PATCH 2/2] Add test for correct $SCRATCH_MNT into _require_scratch

---
 common.rc |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 6bf1e12..72997f9 100644
--- a/common.rc
+++ b/common.rc
@@ -703,6 +703,10 @@ _require_scratch()
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
+		if [ ! -d "$SCRATCH_MNT" ]
+		then
+		     _notrun "this test requires a valid \$SCRATCH_MNT"
+		fi
 		 ;;
     esac
 
-- 
1.6.4.2


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--yEPQxsgoJgBvi8ip--
