Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3EA329E0E
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 15:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81363304059
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 13:56:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 8mIHEntypUpwW2fE for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 13:56:44 -0700 (PDT)
Message-Id: <20131025205559.690510798@suse.com>
Date: Fri, 25 Oct 2013 16:52:48 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 2/3] [PATCH 2/3] xfstests: add test for sysfs publication of
	btrfs info
References: <20131025205246.269327744@suse.com>
Content-Disposition: inline;
	filename=0002-xfstests-add-test-for-sysfs-publication-of-btrfs-inf.patch
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
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>

This tests the sysfs publishing for btrfs allocation and device
membership info under a number of different layouts, similar to the
btrfs replace test. We test the allocation files only for existence and
that they contain numerical values. We test the device membership
by mapping the devices used to create the file system to sysfs paths
and matching them against the paths used for the device membership
symlinks.

Since this is a new feature, it passes on kernels without
a /sys/fs/btrfs/<fsid> directory.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 common/config       |   1 +
 tests/btrfs/101     | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/101.out |   2 +
 3 files changed, 191 insertions(+)
 create mode 100755 tests/btrfs/101
 create mode 100644 tests/btrfs/101.out

diff --git a/common/config b/common/config
index 20c5b09..5f9e2e8 100644
--- a/common/config
+++ b/common/config
@@ -208,6 +208,7 @@ case "$HOSTOS" in
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
         export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
+        export UDEVADM_PROG="`set_prog_path udevadm`"
         export BTRFS_SHOW_SUPER_PROG="`set_prog_path btrfs-show-super`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
diff --git a/tests/btrfs/101 b/tests/btrfs/101
new file mode 100755
index 0000000..9a2834b
--- /dev/null
+++ b/tests/btrfs/101
@@ -0,0 +1,188 @@
+#! /bin/bash
+# FS QA Test No. btrfs/101
+#
+# Test of the btrfs sysfs publishing
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 SUSE.  All rights reserved.
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
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_require_scratch
+_require_scratch_dev_pool
+_require_command $UDEVADM_PROG udevadm
+
+rm -f $seqres.full
+rm -f $tmp.tmp
+
+fsid() {
+	$BTRFS_UTIL_PROG filesystem show $1|awk '/uuid:/ {print $NF}'
+}
+
+check_file() {
+	local file=$1
+	base="$(echo "$file" | sed -e 's#/sys/fs/btrfs/[0-9a-f-][0-9a-f-]*/##')"
+	if [ ! -f "$file" ]; then
+		echo "$base missing."
+		return 0
+	else
+		value="$(cat $file)"
+		if [ -n "$(echo $value | tr -d 0-9)" ]; then
+			echo "ERROR: $base: numerical value expected (got $value)"
+			return 0
+		fi
+	fi
+	return 1
+}
+
+check_chunk() {
+	path=$1
+	mkfs_options=$2
+	error=false
+
+	chunktype=$(basename $path)
+	if [ ! -d "$path" ]; then
+		echo "No $chunktype directory."
+		exit 1
+	fi
+
+	for file in bytes_may_use bytes_pinned bytes_reserved bytes_used \
+		    disk_total flags total_bytes total_bytes_pinned; do
+		if check_file "$path/$file"; then
+			error=true
+		fi
+	done
+
+	if [ "$chunktype" = "data" -o "$chunktype" = "mixed" ]; then
+		opt="-d"
+	elif [ "$chunktype" = "metadata" -o "$chunktype" = "system" ]; then
+		opt="-m"
+	fi
+
+	profile=$(echo $mkfs_options | sed -e "s/.*$opt \([[:alnum:]]*\).*/\1/")
+	if [ ! -d "$path/$profile" ]; then
+		echo "No $profile dir for $chunktype"
+		exit 1
+	fi
+
+	for file in total_bytes used_bytes; do
+		if check_file $path/$profile/$file; then
+			error=true
+		fi
+	done
+
+	$error && exit 1
+}
+
+check_dev_link() {
+	local dev=$1
+	DEV="/sys/$($UDEVADM_PROG info --query=path $dev)"
+	DEV="$(readlink -f $DEV)"
+	found=false
+	for link in $sysfs_base/devices/*; do
+		LINK="$(readlink -f $link)"
+		if [ "$LINK" = "$DEV" ]; then
+			found=true
+			break
+		fi
+	done
+	if ! $found; then
+		echo "Symlink for $dev missing in $sysfs_base/devices"
+		return 1
+	fi
+	return 0
+}
+
+workout()
+{
+	local mkfs_options="$1"
+	local num_devs4raid="$2"
+	local fssize
+
+	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt $num_devs4raid ]; then
+		echo "Skip workout $1 $2 $3 $4"
+		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL, required: $num_devs4raid"
+		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
+		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL, required: $num_devs4raid" >> $seqres.full
+		return 0
+	fi
+
+	used_devs=$(echo $SCRATCH_DEV_POOL|tr '\t' ' '| cut -d ' ' -f 1-$num_devs4raid)
+
+	_scratch_mkfs $mkfs_options $used_devs >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+	_scratch_mount
+
+	# Check allocation
+	sysfs_base="/sys/fs/btrfs/$(fsid $SCRATCH_DEV)"
+
+	# Feature isn't present for testing
+	if [ ! -d "$sysfs_base" ]; then
+		echo "Skipping sysfs test: $sysfs_base not found." >> $seqres.full
+		return
+	fi
+
+	mixed=false
+	case "$mkfs_options" in
+	*-M*)
+		mixed=true;
+		;;
+	esac
+
+	check_chunk "$sysfs_base/allocation/system" "$mkfs_options"
+	if $mixed; then
+		check_chunk "$sysfs_base/allocation/mixed" "$mkfs_options"
+	else
+		check_chunk "$sysfs_base/allocation/data" "$mkfs_options"
+		check_chunk "$sysfs_base/allocation/metadata" "$mkfs_options"
+	fi
+
+	for dev in $used_devs; do
+		check_dev_link $dev || exit 1
+	done
+
+	umount $SCRATCH_MNT > /dev/null 2>&1
+}
+
+workout "-m single -d single" 1
+workout "-m single -d single -M" 1
+workout "-m dup -d single" 1
+workout "-m dup -d dup -M" 1
+workout "-m raid0 -d raid0" 2
+workout "-m raid1 -d raid1" 2
+workout "-m raid5 -d raid5" 2
+workout "-m raid6 -d raid6" 3
+workout "-m raid10 -d raid10" 4
+
+echo "Silence is golden."
+status=0
+exit
diff --git a/tests/btrfs/101.out b/tests/btrfs/101.out
new file mode 100644
index 0000000..e651a91
--- /dev/null
+++ b/tests/btrfs/101.out
@@ -0,0 +1,2 @@
+QA output created by 101
+Silence is golden
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
