Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 129857F52
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 06:05:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01A87304043
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 04:05:34 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id y0xCqGeJtp34fGr2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 04:05:32 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] large-fs: fix large_fs space detection
Date: Tue,  9 Jul 2013 15:05:15 +0400
Message-Id: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

Currenly large_fs check compare $SCRATCH_DEV_EMPTY_SPACE and $fs_size
which is not correct because total empty size required is $SCRATCH_DEV_EMPTY_SPACE + 50Gb
This path fix space detection, so check becomes valid for all situations.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/rc |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfc..c44acea 100644
--- a/common/rc
+++ b/common/rc
@@ -306,16 +306,17 @@ _setup_large_xfs_fs()
 {
 	fs_size=$1
 	local tmp_dir=/tmp/
+	# Default free space in the FS is 50GB, but you can specify more via
+	# SCRATCH_DEV_EMPTY_SPACE
+	fs_empty_space=$((50*1024*1024*1024))
 
 	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
-	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
-	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
+	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0	
+	fs_empty_space=$((fs_empty_space + $SCRATCH_DEV_EMPTY_SPACE))
+	[ $fs_empty_space -ge $fs_size ] && return 0
 
 	# calculate the size of the file we need to allocate.
-	# Default free space in the FS is 50GB, but you can specify more via
-	# SCRATCH_DEV_EMPTY_SPACE
-	file_size=$(($fs_size - 50*1024*1024*1024))
-	file_size=$(($file_size - $SCRATCH_DEV_EMPTY_SPACE))
+	file_size=$(($fs_size - $fs_empty_space))
 
 	# mount the filesystem, create the file, unmount it
 	_scratch_mount 2>&1 >$tmp_dir/mnt.err
@@ -434,15 +435,17 @@ _setup_large_ext4_fs()
 {
 	fs_size=$1
 	local tmp_dir=/tmp/
-
-	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
-	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
-	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
-
 	# Default free space in the FS is 50GB, but you can specify more via
 	# SCRATCH_DEV_EMPTY_SPACE
-	space_to_consume=$(($fs_size - 50*1024*1024*1024 - $SCRATCH_DEV_EMPTY_SPACE))
+	fs_empty_space=$((50*1024*1024*1024))
 
+	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
+	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0	
+	fs_empty_space=$((fs_empty_space + $SCRATCH_DEV_EMPTY_SPACE))
+	[ $fs_empty_space -ge $fs_size ] && return 0
+
+	# calculate the size of the file we need to allocate.
+	space_to_consume=$(($fs_size - $fs_empty_space))
 	# mount the filesystem and create 16TB - 4KB files until we consume
 	# all the necessary space.
 	_scratch_mount 2>&1 >$tmp_dir/mnt.err
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
