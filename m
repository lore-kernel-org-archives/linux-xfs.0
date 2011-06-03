Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53JExXW029655 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 14:14:59 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB9DE13470D5
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 12:14:58 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id 51ZgablKLlZBkYdl for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 12:14:58 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p53IwGZ1001995
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 12:58:16 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p53JEoEZ056772 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 13:14:51 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p53DEnmv029532
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 07:14:49 -0600
Message-ID: <4DE932A9.7040007@linux.vnet.ibm.com>
Date: Fri, 03 Jun 2011 12:14:49 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Fwd: [XFSTEST Add Fallocate Punch Hole Tests 3/3 v4] Add ENOSPC Hole
	Punch Test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>



-------- Original Message --------
Subject: [XFSTEST Add Fallocate Punch Hole Tests 3/3 v4] Add ENOSPC Hole 
Punch Test
Date: Wed, 25 May 2011 19:34:44 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs-oss <xfs@oss.sgi.com>

This patch adds a test to 252 that tests that a hole can be punched even 
when the
disk is full.  Reserved blocks should be used to allow a punch hole to 
proceed even
when there is not enough blocks to further fragment the file. To test 
this, the
file system is fragmented by punching holes in regular intervals and filling
the file system between punches. This will eventually force the file 
system to use
reserved blocks to proceed with the punch hole operation.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100755 100755 5efa243... b5204fe... M	252
:100644 100644 ddf63b0... fc6123c... M	common.punch
  252          |   12 +++++++
  common.punch |   95 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/252 b/252
index 5efa243..b5204fe 100755
--- a/252
+++ b/252
@@ -49,6 +49,7 @@ _supported_os Linux

  _require_xfs_io_falloc_punch
  _require_xfs_io_fiemap
+_require_scratch

  testfile=$TEST_DIR/252.$$

@@ -64,4 +65,15 @@ _test_generic_punch -k falloc fpunch fpunch fiemap 
_filter_fiemap $testfile -F
  # Delayed allocation multi punch hole tests
  _test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap 
$testfile -F

+# Test full filesystem hole punching.
+# Make a small file system to fill
+umount $SCRATCH_DEV &> /dev/null
+_scratch_mkfs_sized $(( 1024 * 1024 * 1024 )) &> /dev/null
+_scratch_mount
+# Test must be able to write files with non-root permissions
+chmod 777 $SCRATCH_MNT
+
+block_size=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+_test_full_fs_punch $(( $block_size * 2 )) $block_size 500 
$SCRATCH_MNT/252.$$
+
  status=0 ; exit
diff --git a/common.punch b/common.punch
index ddf63b0..fc6123c 100644
--- a/common.punch
+++ b/common.punch
@@ -481,5 +481,100 @@ _test_generic_punch()
  		-c "$zero_cmd 128 128" \
  		-c "$map_cmd -v" $testfile | $filter_cmd
  	[ $? -ne 0 ] && die_now
+}
+
+# _fill_fs()
+#
+# Fills a file system by repeatedly creating files in the given folder
+# starting with the given file size.  Files are reduced in size when
+# they can no longer fit untill no more files can be created.
+#
+# This routine is used by _test_full_fs_punch to test that a hole may
+# still be punched when the disk is full by borrowing reserved blocks.
+# All files are created as a non root user to prevent reserved blocks
+# from being consumed.
+#
+_fill_fs() {
+	local file_size=$1
+	local dir=$2
+	local file_count=1
+
+	if [ $# -ne 2 ]
+	then
+	    echo "USAGE: $0 filesize dir"
+	    exit 1
+	fi
+
+	mkdir -p $dir &> /dev/null
+	if [[ $? != 0 ]] ; then
+		return 0
+	fi
+	chmod 777 $dir
+
+	rc=0
+	while [ $file_size -gt 0 -a $rc == 0 ]
+	do
+		# This part must not be done as root or
+		# reserved blocks will be consumed
+		sudo -u nobody $XFS_IO_PROG -F -f -c "pwrite  0 $file_size" 
$dir/$file_count.bin &> /dev/null
+		rc=$?
+
+		# If there was no room to make the file,
+		# and the file size can still be made smaller,
+		# then divide it in half, and keep going
+		if [ $file_size -gt 1 -a $rc != 0 ]
+		then
+			file_size=$(( $file_size / 2 ))
+			rc=0
+		fi
+		file_count=$(( $file_count + 1 ))
+
+	done
+}

+# _test_full_fs_punch()
+#
+# This function will test that a hole may be punched
+# even when the file system is full.  Reserved blocks
+# should be used to allow a punch hole to proceed even
+# when there is not enough blocks to further fragment the
+# file. To test this, this function will fragment the file
+# system by punching holes in regular intervals and filling
+# the file system between punches.
+#
+_test_full_fs_punch()
+{
+	hole_len=$1      # The length of the holes to punch
+	hole_interval=$2 # The interval between the holes
+	iterations=$3    # The number of holes to punch
+	file_name=$4     # File to punch holes in
+	file_len=$(( $(( $hole_len + $hole_interval )) * $iterations ))
+	path=`dirname $file_name`
+	hole_offset=0
+
+	rm -f $file_name &> /dev/null
+
+	$XFS_IO_PROG -F -f -c "pwrite 0 $file_len" \
+		-c "fsync" $file_name &> /dev/null
+	chmod 666 $file_name
+
+	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill
+
+	for (( i=0; i<$iterations; i++ ))
+	do
+		# This part must not be done as root in order to
+		# test that reserved blocks are used when needed
+		sudo -u nobody $XFS_IO_PROG -F -f -c "fpunch $hole_offset $hole_len" 
$file_name
+		rc=$?
+		if [[ $? != 0 ]] ; then
+			echo Punch hole failed
+			break
+		fi
+
+		hole_offset=$(( $hole_offset + $hole_len + $hole_interval ))
+
+		_fill_fs $hole_len $path/fill.$i
+
+	done
  }
+
-- 
1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
