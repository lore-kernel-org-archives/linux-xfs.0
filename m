Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA88g5hS101472 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 02:42:05 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B9451DBA4BA
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 00:42:04 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id nB5aCEEZXowVZPIs
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:04 -0800 (PST)
Received: by mail-bw0-f53.google.com with SMTP id q10so218577bka.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:04 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] xfstests: remove duplicated  umount $scratch_dev
Date: Tue,  8 Nov 2011 12:41:55 +0400
Message-Id: <1320741715-32692-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320741715-32692-1-git-send-email-dmonakhov@openvz.org>
References: <1320741715-32692-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de

_require_scratch unmounts the SCRATCH_DEV. So it is not necessery
to do it explicitly at the first time.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 232 |    1 -
 233 |    1 -
 269 |    3 +--
 270 |    3 +--
 271 |    3 +--
 272 |    3 +--
 6 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/232 b/232
index fb4a872..2795da7 100755
--- a/232
+++ b/232
@@ -72,7 +72,6 @@ _require_scratch
 _require_quota
 _need_to_be_root
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs >> $seq.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
 chmod 777 $SCRATCH_MNT
diff --git a/233 b/233
index e6ba7ef..28e6ac7 100755
--- a/233
+++ b/233
@@ -80,7 +80,6 @@ _require_quota
 _require_user
 _need_to_be_root
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs >> $seq.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
 chmod 777 $SCRATCH_MNT
diff --git a/269 b/269
index 206492b..7e13ed9 100755
--- a/269
+++ b/269
@@ -64,10 +64,9 @@ _workout()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_scratch
 _need_to_be_root
+_require_scratch
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
 _scratch_mount
 
diff --git a/270 b/270
index e45029f..6a349b4 100755
--- a/270
+++ b/270
@@ -74,12 +74,11 @@ _workout()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_scratch
 _require_quota
 _require_user
 _need_to_be_root
+_require_scratch
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
 chmod 777 $SCRATCH_MNT
diff --git a/271 b/271
index b4e6043..58a7f91 100755
--- a/271
+++ b/271
@@ -39,10 +39,9 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs ext4
 _supported_os Linux
-_require_scratch
 _need_to_be_root
+_require_scratch
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seq.full 2>&1
 
 # -onoload and EXT4_SYNC_FL on file is important becase result in
diff --git a/272 b/272
index a35ef83..26dfa3b 100755
--- a/272
+++ b/272
@@ -83,10 +83,9 @@ chattr_opt: $chattr_opt"
 # real QA test starts here
 _supported_fs ext3 ext4
 _supported_os Linux
-_require_scratch
 _need_to_be_root
+_require_scratch
 
-umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seq.full 2>&1
 _scratch_mount
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
