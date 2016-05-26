Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB3867CC5
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76802AC002
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FL6K0KVBgxM9Kapn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:57 -0700 (PDT)
Subject: [PATCH 7/7] reflink: test changing sharers of a block while keeping
	refcount the same
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:49 -0700
Message-ID: <146424226985.6278.9226931712470818344.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Ensure that we can handle the case where the refcount stays the same
even though the actual sharers changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/925     |   80 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/925.out |   69 ++++++++++++++++++++++++++++++++++++
 tests/generic/926     |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/926.out |   20 ++++++++++
 tests/generic/group   |    2 +
 5 files changed, 265 insertions(+)
 create mode 100755 tests/generic/925
 create mode 100644 tests/generic/925.out
 create mode 100755 tests/generic/926
 create mode 100644 tests/generic/926.out


diff --git a/tests/generic/925 b/tests/generic/925
new file mode 100755
index 0000000..9fa4ba9
--- /dev/null
+++ b/tests/generic/925
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test No. 925
+#
+# Share an extent amongst a bunch of files such that the refcount
+# stays the same while the rate of change of the set of owners is
+# steadily increasing.  For example, an extent of 32 blocks is owned
+# by 32 files.  At block 1, change one of the owners.  At block 2,
+# change 2 of the owners, and so on.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+    wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blocks=64
+blksz=65536
+
+echo "Initialize file"
+_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file >> $seqres.full
+
+echo "Share the file n-ways"
+seq 1 $((blocks - 1)) | while read nr; do
+	_reflink_range $testdir/file 0 $testdir/file$nr.0 0 $((nr * blksz)) >> $seqres.full
+	seq $nr $((blocks - 1)) | while read nnr; do
+		_reflink_range $testdir/file $((nnr * blksz)) $testdir/file$nr.$nnr $((nnr * blksz)) $blksz >> $seqres.full
+	done
+done
+_scratch_cycle_mount
+
+echo "Check output"
+md5sum $testdir/file $testdir/file*.0 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/925.out b/tests/generic/925.out
new file mode 100644
index 0000000..099d6d3
--- /dev/null
+++ b/tests/generic/925.out
@@ -0,0 +1,69 @@
+QA output created by 925
+Format and mount
+Initialize file
+Share the file n-ways
+Check output
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-925/file
+2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-925/file1.0
+399c239a8d72b5b2beb15565cf14f6d6  SCRATCH_MNT/test-925/file10.0
+7f783291615a5db41ba33d6c50318095  SCRATCH_MNT/test-925/file11.0
+4feff1bdae53d042e572a5e240b1183f  SCRATCH_MNT/test-925/file12.0
+ac2b0a907cd84c091c1cc36384246e42  SCRATCH_MNT/test-925/file13.0
+ff420a8abc25ff0a012638ddd9b81e6c  SCRATCH_MNT/test-925/file14.0
+3eb1751bcb7cff809df2ec376e45fe6f  SCRATCH_MNT/test-925/file15.0
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-925/file16.0
+7b0fea2a208aa4738d8b9433c7b8421d  SCRATCH_MNT/test-925/file17.0
+c6b6ec99b28741ffb3be2d7ff361ad89  SCRATCH_MNT/test-925/file18.0
+d609dcbdc972b8cff16acd74414a8dc9  SCRATCH_MNT/test-925/file19.0
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-925/file2.0
+d97ae5fdb25c4622d5a2f313460a2b96  SCRATCH_MNT/test-925/file20.0
+afae74f7a13edf57f43bab5da6e411d6  SCRATCH_MNT/test-925/file21.0
+0ed53c341d0154d68c336eaa9d05990d  SCRATCH_MNT/test-925/file22.0
+ab20d0025b58cbf9fc49e436b7d7acef  SCRATCH_MNT/test-925/file23.0
+5279106ed91359051fbdb61e87d5077d  SCRATCH_MNT/test-925/file24.0
+9a8719c84c1a42d030fc6d700046eaf5  SCRATCH_MNT/test-925/file25.0
+d9b21a065727fd8118d493f7c62e7fb2  SCRATCH_MNT/test-925/file26.0
+d74ee01c55b2474f91a3723a01c83591  SCRATCH_MNT/test-925/file27.0
+ba7202bfc4b9cda564156562d8672a3f  SCRATCH_MNT/test-925/file28.0
+1b3d697355ca662451eb12419cab8eef  SCRATCH_MNT/test-925/file29.0
+998b4ba52f2940dc515001e75926b19f  SCRATCH_MNT/test-925/file3.0
+6b2648f84c57f58786cf75ac06e37217  SCRATCH_MNT/test-925/file30.0
+c400b872b0fb3fb58920c4e570937a32  SCRATCH_MNT/test-925/file31.0
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-925/file32.0
+cac15c2eeaf1b63614469f675ec71c5f  SCRATCH_MNT/test-925/file33.0
+ebd2d819d56725bd1a2a35ababd06cad  SCRATCH_MNT/test-925/file34.0
+a26ebf37da9976dfd7c86b4271c59501  SCRATCH_MNT/test-925/file35.0
+11f61aaa1f5f726929c91c6d434edf72  SCRATCH_MNT/test-925/file36.0
+1f73d21c457843ea20048726d461648e  SCRATCH_MNT/test-925/file37.0
+9ed53cefd1548008ed1948286e471233  SCRATCH_MNT/test-925/file38.0
+af5195351947da43e7a57f69086aa7d7  SCRATCH_MNT/test-925/file39.0
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-925/file4.0
+f31ecd4106278b5fb1aeabdedd43036a  SCRATCH_MNT/test-925/file40.0
+e8a8d1a0873e25697171ebb87125d794  SCRATCH_MNT/test-925/file41.0
+5920fd86bc7be6a0ef5d7ea283e16307  SCRATCH_MNT/test-925/file42.0
+8360c3c368143821045f9b7994ab8344  SCRATCH_MNT/test-925/file43.0
+6c76a6c9e2b039c82e62d985479f73ee  SCRATCH_MNT/test-925/file44.0
+8b5c6cab2f0da5ba2d3b2d3ca205ca75  SCRATCH_MNT/test-925/file45.0
+b4ef05d705b8e99d8824d85e993bf8fa  SCRATCH_MNT/test-925/file46.0
+0db1f2d5ad692ccd8941a8bc308cdba2  SCRATCH_MNT/test-925/file47.0
+6a11a8872b36343799a15617bea78cef  SCRATCH_MNT/test-925/file48.0
+015ab57c35525eeb776308e14fe2e731  SCRATCH_MNT/test-925/file49.0
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-925/file5.0
+fbc6203955f9c6e9010f831971a073b2  SCRATCH_MNT/test-925/file50.0
+aae01cd767e508bdf2d01f647d10c4b8  SCRATCH_MNT/test-925/file51.0
+4d942a936328991bcd9821072ac0fd9e  SCRATCH_MNT/test-925/file52.0
+b77f243bb207746743aeaafbdef4203a  SCRATCH_MNT/test-925/file53.0
+9fc7f158bd2ded9df3965ef4fe2fa932  SCRATCH_MNT/test-925/file54.0
+36dff6091853c946411bc40fdae79e84  SCRATCH_MNT/test-925/file55.0
+82a2f6d28f1bff4ce7edc1a7a31b02cb  SCRATCH_MNT/test-925/file56.0
+b0d123bf023332bba783abb5b68e4c98  SCRATCH_MNT/test-925/file57.0
+26b49b145b128c0abef0f92b3ccaf1d6  SCRATCH_MNT/test-925/file58.0
+b5ef5d86d6ef15a535ee95b8069d29c9  SCRATCH_MNT/test-925/file59.0
+cd3eccbf2f0126c4141740007ba70c3f  SCRATCH_MNT/test-925/file6.0
+205cb48615014f6f2377345b62442609  SCRATCH_MNT/test-925/file60.0
+89691c001b3a3d5473081687ae519a18  SCRATCH_MNT/test-925/file61.0
+a040ce9774652bd00c3cbf493a006e00  SCRATCH_MNT/test-925/file62.0
+970b42855c15ee8caa824cd5e177759a  SCRATCH_MNT/test-925/file63.0
+eb74da58c6e4f93b4bf82a62fef4ab93  SCRATCH_MNT/test-925/file7.0
+30c2557e8302a5beb290c71520d87f42  SCRATCH_MNT/test-925/file8.0
+6dc42f5ed1007a3e20d08af71e198cdc  SCRATCH_MNT/test-925/file9.0
diff --git a/tests/generic/926 b/tests/generic/926
new file mode 100755
index 0000000..7dedc3f
--- /dev/null
+++ b/tests/generic/926
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 926
+#
+# Make sure that the reference counting mechanism can handle the case
+# where we share the first 1/4 of an extent with a file, share the
+# last 1/4 of the extent with a second file, share the first half of
+# the extent with N files, and share the second half of the extent
+# with a different set of N files.  The key point here is to test that
+# we handle the case where a refcount extent record doesn't coincide
+# exactly with the block mapping records.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+    wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blocks=64
+blksz=65536
+nr=4
+halfway=$((blocks / 2 * blksz))
+quarter=$((blocks / 4 * blksz))
+
+echo "Initialize file"
+_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file >> $seqres.full
+
+echo "Share the first half of the extent"
+seq 1 $nr | while read nr; do
+	_reflink_range $testdir/file 0 $testdir/file$nr.0 0 $halfway >> $seqres.full
+done
+
+echo "Share the last half of the extent"
+seq 1 $nr | while read nr; do
+	_reflink_range $testdir/file $halfway $testdir/file$nr.1 0 $halfway >> $seqres.full
+done
+
+echo "Share the first quarter of the extent"
+_reflink_range $testdir/file 0 $testdir/file.2 0 $quarter >> $seqres.full
+
+echo "Share the last quarter of the extent"
+_reflink_range $testdir/file $((quarter * 3)) $testdir/file.3 0 $quarter >> $seqres.full
+
+_scratch_cycle_mount
+
+echo "Check output"
+md5sum $testdir/file $testdir/file* | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/926.out b/tests/generic/926.out
new file mode 100644
index 0000000..d3e6b59
--- /dev/null
+++ b/tests/generic/926.out
@@ -0,0 +1,20 @@
+QA output created by 926
+Format and mount
+Initialize file
+Share the first half of the extent
+Share the last half of the extent
+Share the first quarter of the extent
+Share the last quarter of the extent
+Check output
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-926/file
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-926/file
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-926/file.2
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-926/file.3
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file1.0
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file1.1
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file2.0
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file2.1
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file3.0
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file3.1
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file4.0
+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-926/file4.1
diff --git a/tests/generic/group b/tests/generic/group
index 6fdf109..2bd40a1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -356,3 +356,5 @@
 351 blockdev quick rw
 923 auto quick clone
 924 auto quick clone
+925 auto quick clone
+926 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
