Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVm0P255486 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:48 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2003256FA41
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iwNSAvpRWBwal0eG for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:46 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfstests: use preallocation for ag-wiper
Date: Mon, 21 Nov 2011 22:31:24 +1100
Message-Id: <1321875088-30801-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To enable sane testing of large scale filesystems, the --large-fs
test option uses xfs_db magic to mark AGs full without doing any IO.
This leaves only a small amount of free space left in the filesystem
to stress the high AGs of the filesystem rather than the low AGs.

This method requires us to have special filesystem check options to
avoid free space checking in xfs_check, and we cannot current run
xfs_repair on such a filesystem at all. As it is, free space
checking on xfs_check does not scale, so we still need to avoid this
checking regardless of how we fill the filesystem.

We can acheive exactly the same fill behaviour by preallocating a
single large file in the filesystem immediately after creating it.
This is a filesystem independent manner of filling the filesystem,
and allows us to do large filesystem testing on more than just XFS.

Further, this preallocation method effectively adds a new "very
large file" test. It also enables us to run an unmodified xfs_repair
or filesystem specific fsck program to check the filesystem for
sanity, so we can now do full sanity checking of such large
filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/common.rc b/common.rc
index 455886d..34467ec 100644
--- a/common.rc
+++ b/common.rc
@@ -276,6 +276,47 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+
+_setup_large_xfs_fs()
+{
+	fs_size=$1
+	local tmp_dir=/tmp/
+
+	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
+	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ] && return 0
+
+	# calculate the size of the file we need to allocate.
+	# Default free space in the FS is 50GB, but you can specify more via
+	# SCRATCH_DEV_EMPTY_SPACE
+	file_size=$(($fs_size - 50*1024*1024*1024))
+	file_size=$(($file_size - $SCRATCH_DEV_EMPTY_SPACE))
+
+	# mount the filesystem, create the file, unmount it
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
+	xfs_io -F -f \
+		-c "truncate $file_size" \
+		-c "falloc -k 0 $file_size" \
+		$SCRATCH_MNT/.use_space 2>&1 > /dev/null
+	status=$?
+	umount $SCRATCH_MNT
+	if [ $status -ne 0 ]; then
+		echo "large file prealloc failed"
+		cat $tmp_dir/mnt.err >&2
+		return $status
+	fi
+	return 0
+}
+
 _scratch_mkfs_xfs()
 {
     # extra mkfs options can be added by tests
@@ -305,16 +346,23 @@ _scratch_mkfs_xfs()
         mkfs_status=$?
     fi
 
+    if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
+	# manually parse the mkfs output to get the fs size in bytes
+	local fs_size
+	fs_size=`cat $tmp_dir.mkfsstd | perl -ne '
+	    if (/^data\s+=\s+bsize=(\d+)\s+blocks=(\d+)/) {
+		my $size = $1 * $2;
+		print STDOUT "$size\n";
+	    }'`
+	_setup_large_xfs_fs $fs_size
+	mkfs_status=$?
+    fi
+
     # output stored mkfs output
     cat $tmp_dir.mkfserr >&2
     cat $tmp_dir.mkfsstd
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
-    if [ "$LARGE_SCRATCH_DEV" = yes ]; then
-        [ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
-        ./tools/ag-wipe -q -r $SCRATCH_DEV_EMPTY_SPACE $SCRATCH_DEV
-    fi
-
     return $mkfs_status
 }
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
