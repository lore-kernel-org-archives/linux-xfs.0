Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A887E7F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 08:57:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CDD9304071
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 06:57:51 -0700 (PDT)
Received: from bp-05.lab.msp.redhat.com (nat-pool-rdu.redhat.com
	[66.187.233.202]) by cuda.sgi.com with ESMTP id
	OsyhGBqJL24IvxW7 for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 06:57:50 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] xfstests: btrfs tests for basic informational commands
Date: Wed, 13 Mar 2013 09:57:03 -0500
Message-Id: <1363186623-1378-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org

Run basic btrfs information commands in various ways, performing
sanity tests of: filesystem show, label, sync, and device stats
(sync is included just because it's simple).  These are mostly
just smoke tests, although for example show by label & UUID
should verify that the correct fs was shown.

This also adds quite a few new filters to accomodate the output
of the new commands.

Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 313           |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 313.out       |   51 ++++++++++++++++++++++++++++++
 btrfs.filter  |   47 ++++++++++++++++++++++++++++
 common.filter |   24 ++++++++++++++
 group         |    1 +
 5 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100755 313
 create mode 100644 313.out
 create mode 100644 btrfs.filter

diff --git a/313 b/313
new file mode 100755
index 0000000..6effb0e
--- /dev/null
+++ b/313
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# run basic btrfs information commands in various ways
+# sanity tests: filesystem show, label, sync, and device stats
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+echo "== QA output created by $seq"
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
+. ./btrfs.filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool
+
+rm -f $seq.full
+
+FIRST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+LAST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $NF}'`
+TOTAL_DEVS=`echo $SCRATCH_DEV $SCRATCH_DEV_POOL | wc -w`
+LABEL=TestLabel.$seq
+
+echo "Scratch $SCRATCH_DEV First $FIRST_POOL_DEV last $LAST_POOL_DEV Total $TOTAL_DEVS" > $seq.full
+
+_scratch_mkfs $SCRATCH_DEV_POOL >> $seq.full 2>&1 || _fail "mkfs failed"
+
+# These have to be done unmounted...?
+echo "== Set filesystem label to $LABEL"
+$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL
+echo "== Get filesystem label"
+$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV
+
+echo "== Mount."
+_scratch_mount
+
+echo "== Show filesystem by label"
+$BTRFS_UTIL_PROG filesystem show $LABEL | _filter_btrfs_filesystem_show $TOTAL_DEVS
+UUID=`$BTRFS_UTIL_PROG filesystem show $LABEL | grep uuid: | awk '{print $NF}'`
+
+echo "UUID $UUID" >> $seq.full
+
+echo "== Show filesystem by UUID"
+$BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
+
+echo "== Sync filesystem"
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+
+echo "== Show device stats by mountpoint"
+$BTRFS_UTIL_PROG device stats $SCRATCH_MNT | _filter_btrfs_device_stats
+echo "== Show device stats by first/scratch dev"
+$BTRFS_UTIL_PROG device stats $SCRATCH_DEV | _filter_btrfs_device_stats
+echo "== Show device stats by second dev"
+$BTRFS_UTIL_PROG device stats $FIRST_POOL_DEV | sed -e "s,$FIRST_POOL_DEV,FIRST_POOL_DEV,g"
+echo "== Show device stats by last dev"
+$BTRFS_UTIL_PROG device stats $LAST_POOL_DEV | sed -e "s,$LAST_POOL_DEV,LAST_POOL_DEV,g"
+
+# success, all done
+status=0
+exit
diff --git a/313.out b/313.out
new file mode 100644
index 0000000..1aa59a1
--- /dev/null
+++ b/313.out
@@ -0,0 +1,51 @@
+== QA output created by 313
+== Set filesystem label to TestLabel.313
+== Get filesystem label
+TestLabel.313
+== Mount.
+== Show filesystem by label
+Label: 'TestLabel.313'  uuid: <UUID>
+	Total devices <EXACTNUM> FS bytes used <SIZE>
+	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
+== Show filesystem by UUID
+Label: 'TestLabel.313'  uuid: <EXACTUUID>
+	Total devices <EXACTNUM> FS bytes used <SIZE>
+	devid     <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
+== Sync filesystem
+FSSync 'SCRATCH_MNT'
+== Show device stats by mountpoint
+[SCRATCH_DEV].write_io_errs   <NUM>
+[SCRATCH_DEV].read_io_errs    <NUM>
+[SCRATCH_DEV].flush_io_errs   <NUM>
+[SCRATCH_DEV].corruption_errs <NUM>
+[SCRATCH_DEV].generation_errs <NUM>
+[SCRATCH_DEV].write_io_errs   <NUM>
+[SCRATCH_DEV].read_io_errs    <NUM>
+[SCRATCH_DEV].flush_io_errs   <NUM>
+[SCRATCH_DEV].corruption_errs <NUM>
+[SCRATCH_DEV].generation_errs <NUM>
+[SCRATCH_DEV].write_io_errs   <NUM>
+[SCRATCH_DEV].read_io_errs    <NUM>
+[SCRATCH_DEV].flush_io_errs   <NUM>
+[SCRATCH_DEV].corruption_errs <NUM>
+[SCRATCH_DEV].generation_errs <NUM>
+== Show device stats by first/scratch dev
+[SCRATCH_DEV].write_io_errs   <NUM>
+[SCRATCH_DEV].read_io_errs    <NUM>
+[SCRATCH_DEV].flush_io_errs   <NUM>
+[SCRATCH_DEV].corruption_errs <NUM>
+[SCRATCH_DEV].generation_errs <NUM>
+== Show device stats by second dev
+[FIRST_POOL_DEV].write_io_errs   0
+[FIRST_POOL_DEV].read_io_errs    0
+[FIRST_POOL_DEV].flush_io_errs   0
+[FIRST_POOL_DEV].corruption_errs 0
+[FIRST_POOL_DEV].generation_errs 0
+== Show device stats by last dev
+[LAST_POOL_DEV].write_io_errs   0
+[LAST_POOL_DEV].read_io_errs    0
+[LAST_POOL_DEV].flush_io_errs   0
+[LAST_POOL_DEV].corruption_errs 0
+[LAST_POOL_DEV].generation_errs 0
diff --git a/btrfs.filter b/btrfs.filter
new file mode 100644
index 0000000..4e315aa
--- /dev/null
+++ b/btrfs.filter
@@ -0,0 +1,47 @@
+# Filters for btrfs command output
+
+. ./common.filter
+
+# Some, but not all, commands emit "Btrfs <version>"
+_filter_btrfs_version()
+{
+	sed -e "s/^Btrfs.*//g"
+}
+
+_filter_devid()
+{
+	sed -e "s/\(devid\s\+\)[0-9]\+/\1 <DEVID>/g"
+}
+
+# If passed a number as first arg, filter that number of devices
+# If passed a UUID as second arg, filter that exact UUID
+_filter_btrfs_filesystem_show()
+{
+	if [ ! -z $1 ]; then
+		NUMDEVS=$1
+		NUM_SUBST="<EXACTNUM>"
+	else
+		NUMDEVS="[0-9]\+"
+		NUM_SUBST="<NUM>"
+	fi
+
+	UUID=""
+	if [ ! -z $2 ]; then
+		UUID=$2
+	fi
+
+	# the uniq collapses all device lines into 1
+	_filter_uuid $UUID | _filter_scratch | _filter_scratch_pool | \
+	_filter_size | _filter_btrfs_version | _filter_devid | \
+	sed -e "s/\(Total devices\) $NUMDEVS/\1 $NUM_SUBST/g" | \
+	uniq
+}
+
+_filter_btrfs_device_stats()
+{
+	_filter_scratch | _filter_scratch_pool | \
+	sed -e "s/[0-9]\+$/<NUM>/g"
+}
+
+# make sure this script returns success
+/bin/true
diff --git a/common.filter b/common.filter
index c854a98..4de9d3d 100644
--- a/common.filter
+++ b/common.filter
@@ -226,6 +226,13 @@ _filter_scratch()
 	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
 }
 
+# Turn any device in the scratch pool into SCRATCH_DEV
+_filter_scratch_pool()
+{
+	FILTER_STRINGS=`echo $SCRATCH_DEV_POOL | sed -e 's/\s\+/\\\|/g'`
+	sed -e "s,$FILTER_STRINGS,SCRATCH_DEV,g"
+}
+
 _filter_spaces()
 {
        sed -e 's/ [ ]*/ /g'
@@ -238,5 +245,22 @@ _filter_ln()
 	    -e "s,failed to create,creating,"
 }
 
+# If given an arg, filter *that* UUID string
+# Otherwise look for something that looks like a generic UUID
+_filter_uuid()
+{
+	if [ ! -z $1 ]; then
+		sed -e "s/\(uuid:\) $UUID/\1 <EXACTUUID>/i"
+	else
+		sed -e "s/\(uuid:\) *[0-9a-f-][0-9a-f-]*/\1 <UUID>/i"
+	fi
+}
+
+# Filter out sizes like 6.14MB etc
+_filter_size()
+{
+	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][b]\?/<SIZE>/ig"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/group b/group
index 8096968..fcbdfb6 100644
--- a/group
+++ b/group
@@ -429,3 +429,4 @@ stress
 303 aio dangerous ioctl rw stress
 304 aio dangerous ioctl rw stress
 305 aio dangerous enospc rw stress
+313 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
