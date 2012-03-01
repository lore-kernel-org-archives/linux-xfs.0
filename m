Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21NRMnS205591 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 17:27:22 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MQT1NNkcGqeme0dX for
	<xfs@oss.sgi.com>; Thu, 01 Mar 2012 15:27:16 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q21NREI5008510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 18:27:16 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q21NRDAj009217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 18:27:14 -0500
Message-ID: <4F5005D1.6040208@redhat.com>
Date: Thu, 01 Mar 2012 17:27:13 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 279: test mkfs with various sector sizes & alignments
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
To: xfs-oss <xfs@oss.sgi.com>

This test uses the scsi_debug module to test mkfs against
various physical & logical sector sizes, and with aligned
and unaligned devices.

Check out the scenarios in the test, I think I have the right
outcomes specified...

Hope it's not looking too hacky.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/279 b/279
new file mode 100755
index 0000000..b7ad622
--- /dev/null
+++ b/279
@@ -0,0 +1,115 @@
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
+status=0	# failure is the default!
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
+_get_sector_size()
+{
+	xfs_db -c "sb 0" -c "p sectsize" $SCSI_DEBUG_DEV | awk '{print $3}'
+}
+
+_wipe_device()
+{
+	device=$1
+	dd if=/dev/zero of=$device bs=4k count=1 &> /dev/null
+}
+
+_check_mkfs()
+{
+	echo "===================" | tee -a $seq.full
+	echo "mkfs with opts: $@" | sed -e "s/\/dev\/sd./DEVICE/" | tee -a $seq.full
+	mkfs.xfs $@ >> $seq.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "Failed." | tee -a $seq.full
+		return
+	fi
+	echo "Passed." | tee -a $seq.full
+	echo -n "Got sector size: " | tee -a $seq.full
+	_get_sector_size | tee -a $seq.full
+	device=`echo $@ | awk '{print $NF}'`
+	_wipe_device $device
+}
+
+# === 4k physical 512b logical aligned
+echo "===================" | tee -a $seq.full
+echo "4k physical 512b logical aligned" | tee -a $seq.full
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
+# sector size should default to 4k
+_check_mkfs "" $SCSI_DEBUG_DEV
+# blocksize smaller than physical sectorsize should revert to logical sectorsize
+_put_scsi_debug_dev
+
+
+# === 4k physical 512b logical unaligned
+echo "===================" | tee -a $seq.full
+echo "4k physical 512b logical unaligned" | tee -a $seq.full
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
+# should fail on misalignment
+_check_mkfs "" $SCSI_DEBUG_DEV
+# should fall back to logical sector size with force
+_check_mkfs -f $SCSI_DEBUG_DEV
+# with 4k sector specified should fail without force
+_check_mkfs -s size=4096 $SCSI_DEBUG_DEV
+# with 4k sector specified should fall back to logical sector size with force
+_check_mkfs -s size=4096 -f $SCSI_DEBUG_DEV
+_put_scsi_debug_dev
+
+# === hard 4k physical / 4k logical
+echo "===================" | tee -a $seq.full
+echo "hard 4k physical / 4k logical" | tee -a $seq.full
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
+# block size smaller than sector size should fail 
+_check_mkfs -b size=2048 $SCSI_DEBUG_DEV
+# sector size smaller than physical sector size should fail
+_check_mkfs -s size=512 $SCSI_DEBUG_DEV
+_put_scsi_debug_dev
+
+exit
diff --git a/279.out b/279.out
new file mode 100644
index 0000000..f7734e0
--- /dev/null
+++ b/279.out
@@ -0,0 +1,31 @@
+QA output created by 279
+===================
+4k physical 512b logical aligned
+===================
+mkfs with opts:  DEVICE
+Passed.
+Got sector size: 4096
+===================
+4k physical 512b logical unaligned
+===================
+mkfs with opts:  DEVICE
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
