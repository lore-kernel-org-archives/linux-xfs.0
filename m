Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2247vsM241288 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:07:57 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id mZR6Pb7oksRXdPU9 for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:07:55 -0800 (PST)
Message-ID: <4F50479B.2050609@sandeen.net>
Date: Thu, 01 Mar 2012 22:07:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests 279: test mkfs with various sector sizes &
	alignments
References: <4F5005D1.6040208@redhat.com>
In-Reply-To: <4F5005D1.6040208@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This test uses the scsi_debug module to test mkfs against
various physical & logical sector sizes, and with aligned
and unaligned devices.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Dave, I think this implements all your suggestions (in one way or
another...) except the non-modular scsi_debug.  I don't know
how to manipulate things like offset if it's built in, but
if you want to look... I don't see it.

diff --git a/279 b/279
new file mode 100755
index 0000000..dea7fa7
--- /dev/null
+++ b/279
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. 279
+#
+# Test mkfs.xfs against various types of devices with varying
+# logical & physical sector sizes and offsets.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.scsi_debug
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scsi_debug
+
+rm -f $seq.full
+
+# Remove xfs signature so -f isn't needed to re-mkfs
+_wipe_device()
+{
+	device=$1
+	dd if=/dev/zero of=$device bs=4k count=1 &>/dev/null
+}
+
+_check_mkfs()
+{
+	echo "===================" 
+	echo "mkfs with opts: $@" | sed -e "s,/dev/sd.,DEVICE,"
+	mkfs.xfs $@ 2>/dev/null > $tmp.mkfs.full
+	if [ $? -ne 0 ]; then
+		echo "Failed."
+		return
+	fi
+	echo "Passed."
+	cat $tmp.mkfs.full | _filter_mkfs >> $seq.full 2>$tmp.mkfs
+	. $tmp.mkfs
+	echo "Got sector size: $sectsz"
+	device=`echo $@ | awk '{print $NF}'`
+	_wipe_device $device
+}
+
+# === 4k physical 512b logical aligned
+(
+echo "==================="
+echo "4k physical 512b logical aligned"
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
+# sector size should default to 4k
+_check_mkfs $SCSI_DEBUG_DEV
+# blocksize smaller than physical sectorsize should revert to logical sectorsize
+_check_mkfs -b size=2048 -f $SCSI_DEBUG_DEV
+) | tee -a $seq.full
+_put_scsi_debug_dev
+
+
+# === 4k physical 512b logical unaligned
+(
+echo "===================" | tee -a $seq.full
+echo "4k physical 512b logical unaligned" | tee -a $seq.full
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
+# should fail on misalignment
+_check_mkfs $SCSI_DEBUG_DEV
+# should fall back to logical sector size with force
+_check_mkfs -f $SCSI_DEBUG_DEV
+# with 4k sector specified should fail without force
+_check_mkfs -s size=4096 $SCSI_DEBUG_DEV
+# with 4k sector specified should fall back to logical sector size with force
+_check_mkfs -s size=4096 -f $SCSI_DEBUG_DEV
+) | tee -a $seq.full
+_put_scsi_debug_dev
+
+# === hard 4k physical / 4k logical
+(
+echo "===================" | tee -a $seq.full
+echo "hard 4k physical / 4k logical" | tee -a $seq.full
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
+# block size smaller than sector size should fail 
+_check_mkfs -b size=2048 $SCSI_DEBUG_DEV
+# sector size smaller than physical sector size should fail
+_check_mkfs -s size=512 $SCSI_DEBUG_DEV
+) | tee -a $seq.full
+_put_scsi_debug_dev
+
+status=0
+exit
diff --git a/279.out b/279.out
new file mode 100644
index 0000000..5c49846
--- /dev/null
+++ b/279.out
@@ -0,0 +1,35 @@
+QA output created by 279
+===================
+4k physical 512b logical aligned
+===================
+mkfs with opts: DEVICE
+Passed.
+Got sector size: 4096
+===================
+mkfs with opts: -b size=2048 -f DEVICE
+Passed.
+Got sector size: 512
+===================
+4k physical 512b logical unaligned
+===================
+mkfs with opts: DEVICE
+Failed.
+===================
+mkfs with opts: -f DEVICE
+Passed.
+Got sector size: 512
+===================
+mkfs with opts: -s size=4096 DEVICE
+Failed.
+===================
+mkfs with opts: -s size=4096 -f DEVICE
+Passed.
+Got sector size: 4096
+===================
+hard 4k physical / 4k logical
+===================
+mkfs with opts: -b size=2048 DEVICE
+Failed.
+===================
+mkfs with opts: -s size=512 DEVICE
+Failed.
diff --git a/common.scsi_debug b/common.scsi_debug
new file mode 100644
index 0000000..9f9177c
--- /dev/null
+++ b/common.scsi_debug
@@ -0,0 +1,62 @@
+##/bin/bash
+#
+# Copyright (c) 2012 Red Hat, Inc
+# All Rights Reserved.
+#
+# Written by Eric Sandeen <sandeen@redhat.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+# Functions useful for tests on unique block devices
+#
+
+_require_scsi_debug()
+{
+	# make sure we have the module and it's not already used
+	modinfo scsi_debug 2>&1 > /dev/null || _notrun "scsi_debug module not found"
+	lsmod | grep -wq scsi_debug && _notrun "scsi_debug module in use"
+	# make sure it has the features we need
+	# logical/physical sectors plus unmap support all went in together
+	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
+}
+
+# Args: [physical sector size, [logical sector size, [unaligned(0|1), [size in megs]]]]
+_get_scsi_debug_dev()
+{
+	# Defaults to phys 512, logical 512, aligned
+	physical=${1-512}
+	logical=${2-512}
+	unaligned=${3-0}
+	size=${4-128}
+
+	phys_exp=0
+	while [ $logical -lt $physical ]; do
+		let physical=physical/2
+		let phys_exp=phys_exp+1
+	done
+	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size"
+	echo "scsi_debug options $opts" >> $seq.full
+	modprobe scsi_debug $opts
+	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
+	sleep 1
+	device=`grep -wl scsi_debug /sys/block/sd*/device/model | awk -F / '{print $4}'`
+	echo "/dev/$device"
+}
+
+_put_scsi_debug_dev()
+{
+	sleep 1
+	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
+}
diff --git a/group b/group
index 6f2d748..7a91f41 100644
--- a/group
+++ b/group
@@ -392,3 +392,4 @@ deprecated
 276 auto rw metadata
 277 auto ioctl quick metadata
 278 repair auto
+279 auto mkfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
