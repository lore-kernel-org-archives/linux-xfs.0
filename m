Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8eHoc001475 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:17 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tGqpSmMBDIK2D3m9 for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJc2-00013z-2U
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJc1-0003v1-UE
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfstests: enable large fs testing on ext4
Date: Thu, 26 Jul 2012 18:39:47 +1000
Message-Id: <1343291989-14987-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that setting up large filesystem testing on sparse loopback
devices uses a generic method for filling the filesystem, extent
support to ext4 filesystems.

ext4 is slightly more complex to fill as it does not support files
larger than 16TB. Hence a slightly more complex method of using
multiple smaller files to fill the space is necessary.

WARNING: be prepeared for ext4 to take forever to prepare large
filesystems as allocation of large amounts of space (especially as
it approaches ENOSPC) is can take minutes rather than milliseconds

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/common.rc b/common.rc
index df47e2a..1c3c605 100644
--- a/common.rc
+++ b/common.rc
@@ -366,6 +366,93 @@ _scratch_mkfs_xfs()
     return $mkfs_status
 }
 
+_setup_large_ext4_fs()
+{
+	fs_size=$1
+	local tmp_dir=/tmp/
+
+	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
+	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
+
+	# Default free space in the FS is 50GB, but you can specify more via
+	# SCRATCH_DEV_EMPTY_SPACE
+	space_to_consume=$(($fs_size - 50*1024*1024*1024 - $SCRATCH_DEV_EMPTY_SPACE))
+
+	# mount the filesystem and create 16TB - 4KB files until we consume
+	# all the necessary space.
+	_scratch_mount 2>&1 >$tmp_dir/mnt.err
+	local status=$?
+	if [ $status -ne 0 ]; then
+		echo "mount failed"
+		cat $tmp_dir/mnt.err >&2
+		rm -f $tmp_dir/mnt.err
+		return $status
+	fi
+	rm -f $tmp_dir/mnt.err
+
+	file_size=$((16*1024*1024*1024*1024 - 4096))
+	nfiles=0
+	while [ $space_to_consume -gt $file_size ]; do
+
+		xfs_io -F -f \
+			-c "truncate $file_size" \
+			-c "falloc -k 0 $file_size" \
+			$SCRATCH_MNT/.use_space.$nfiles 2>&1
+		status=$?
+		if [ $status -ne 0 ]; then
+			break;
+		fi
+
+		space_to_consume=$(( $space_to_consume - $file_size ))
+		nfiles=$(($nfiles + 1))
+	done
+
+	# consume the remaining space.
+	if [ $space_to_consume -gt 0 ]; then
+		xfs_io -F -f \
+			-c "truncate $space_to_consume" \
+			-c "falloc -k 0 $space_to_consume" \
+			$SCRATCH_MNT/.use_space.$nfiles 2>&1
+		status=$?
+	fi
+
+	umount $SCRATCH_MNT
+	if [ $status -ne 0 ]; then
+		echo "large file prealloc failed"
+		cat $tmp_dir/mnt.err >&2
+		return $status
+	fi
+	return 0
+}
+_scratch_mkfs_ext4()
+{
+	local tmp_dir=/tmp/
+
+	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
+			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
+	local mkfs_status=$?
+
+	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
+		# manually parse the mkfs output to get the fs size in bytes
+		fs_size=`cat $tmp_dir.mkfsstd | awk ' \
+			/^Block size/ { split($2, a, "="); bs = a[2] ; } \
+			/ inodes, / { blks = $3 } \
+			/reserved for the super user/ { resv = $1 } \
+			END { fssize = bs * blks - resv; print fssize }'`
+
+		_setup_large_ext4_fs $fs_size
+		mkfs_status=$?
+	fi
+
+	# output stored mkfs output
+	cat $tmp_dir.mkfserr >&2
+	cat $tmp_dir.mkfsstd
+	rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
+
+	return $mkfs_status
+}
+
 _scratch_mkfs()
 {
     case $FSTYP in
@@ -381,6 +468,9 @@ _scratch_mkfs()
     btrfs)
         $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
+    ext4)
+	_scratch_mkfs_ext4 $*
+	;;
     *)
 	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
