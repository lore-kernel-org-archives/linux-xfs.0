Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28121 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933280AbdCVNHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 09:07:37 -0400
Date: Wed, 22 Mar 2017 09:06:24 -0400
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] reflink: test adjacency of reflinked blocks
Message-ID: <20170322130624.GB5738@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798517790.25833.2585159479268361866.stgit@birch.djwong.org>
 <6511f176-ee8e-09d8-d955-8aed36abaa29@cn.fujitsu.com>
 <20170321142352.GA5722@birch.djwong.org>
 <b8f0aa4d-4d5e-7fe0-84db-bba0b9597bc5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8f0aa4d-4d5e-7fe0-84db-bba0b9597bc5@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Mar 22, 2017 at 04:13:16PM +0800, Qu Wenruo wrote:
> 
> 
> At 03/21/2017 10:23 PM, Darrick J. Wong wrote:
> >On Tue, Mar 21, 2017 at 03:14:36PM +0800, Qu Wenruo wrote:
> >>Hi Darrick
> >>
> >>At 02/25/2017 09:12 AM, Darrick J. Wong wrote:
> >>>From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>>If we reflink a file with N blocks to another file one block at a time,
> >>>does the destination file end up with the same number of extents as the
> >>>source file?  In other words, does the filesystem succeed at combining
> >>>adjacent mappings into a maximal extents?
> >>
> >>Btrfs can't pass the test since it doesn't merge such mapping, not only the
> >>fiemap result, but also on-disk extents.
> >
> >Weirdly, I observed that if you unmount and remount the btrfs it
> >actually /will/ merge the extents.
> 
> I tried that, but it's even more weird, after remount, fiemap still return
> split ones.
> But if call fiemap again after about 1 second, it reports one single large
> extent.
> (if calling 2nd fiemap just after 1st one, 2nd one will still return split
> extent map)
> 
> While on disk, the extents are split indeed.

That's .... weirder than I was expecting.

> So it's a btrfs bug then.
> 
> >
> >>IIRC ocfs also merges it, so I wonder if this is a documented behavior to
> >>merge any extent maps that are adjacent.
> >
> >Generally, yes you'd expect that two logically and physically contiguous
> >extents to be merged together.  That might change a bit for compressed
> >or encrypted extents.
> >
> >>Further more, if a fs has a limit on extent size on disk, e.g 128M.
> >>But 2 file extents are also adjacent on disk, then should fiemap return a
> >>large 256M map or just 2 adjacent 128M maps?
> >
> >It's up to the fs, really... XFS will merge the extent records (up to
> >maximum extent size) and then unmerge the shared/not-shared FIEMAP
> >records for accurate shared extent reporting.
> 
> BTW, are XFS extents on disk are merged when doing reflink, or just merge
> the extent record at fiemap time?

Extents are always merged at the earliest possible time.

> Further more, is there any tool like btrfs-debug-tree to show *every* btree
> block and its content data?
> I am very interested in XFS on-disk and runtime implementation.

You can step through them manually with xfs_db, but there's no way to
dump a btree.  Hmm, that would be useful, I'll suggest implementing that.

--D

> Thanks,
> Qu
> >
> >--D
> >
> >>
> >>Thanks,
> >>Qu
> >>>
> >>>Signed-off-by: Darrick J. Wong <djwong@djwong.org>
> >>>---
> >>>tests/generic/930     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>>tests/generic/930.out |   11 +++++
> >>>tests/generic/group   |    1
> >>>3 files changed, 118 insertions(+)
> >>>create mode 100755 tests/generic/930
> >>>create mode 100644 tests/generic/930.out
> >>>
> >>>
> >>>diff --git a/tests/generic/930 b/tests/generic/930
> >>>new file mode 100755
> >>>index 0000000..15d8cbf
> >>>--- /dev/null
> >>>+++ b/tests/generic/930
> >>>@@ -0,0 +1,106 @@
> >>>+#! /bin/bash
> >>>+# FS QA Test No. 930
> >>>+#
> >>>+# Check that reflinking adjacent blocks in a file produces a single
> >>>+# block mapping extent.
> >>>+#
> >>>+#-----------------------------------------------------------------------
> >>>+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
> >>>+#
> >>>+# This program is free software; you can redistribute it and/or
> >>>+# modify it under the terms of the GNU General Public License as
> >>>+# published by the Free Software Foundation.
> >>>+#
> >>>+# This program is distributed in the hope that it would be useful,
> >>>+# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>+# GNU General Public License for more details.
> >>>+#
> >>>+# You should have received a copy of the GNU General Public License
> >>>+# along with this program; if not, write the Free Software Foundation,
> >>>+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >>>+#-----------------------------------------------------------------------
> >>>+#
> >>>+
> >>>+seq=`basename $0`
> >>>+seqres=$RESULT_DIR/$seq
> >>>+echo "QA output created by $seq"
> >>>+
> >>>+here=`pwd`
> >>>+tmp=/tmp/$$
> >>>+status=1	# failure is the default!
> >>>+trap "_cleanup; exit \$status" 0 1 2 3 7 15
> >>>+
> >>>+_cleanup()
> >>>+{
> >>>+	cd /
> >>>+	rm -rf $tmp.*
> >>>+	wait
> >>>+}
> >>>+
> >>>+# get standard environment, filters and checks
> >>>+. ./common/rc
> >>>+. ./common/filter
> >>>+. ./common/reflink
> >>>+
> >>>+# real QA test starts here
> >>>+_supported_os Linux
> >>>+_supported_fs generic
> >>>+_require_scratch_reflink
> >>>+_require_fiemap
> >>>+
> >>>+echo "Format and mount"
> >>>+_scratch_mkfs > $seqres.full 2>&1
> >>>+_scratch_mount >> $seqres.full 2>&1
> >>>+
> >>>+testdir=$SCRATCH_MNT/test-$seq
> >>>+mkdir $testdir
> >>>+
> >>>+blocks=32
> >>>+blksz=65536
> >>>+sz=$((blocks * blksz))
> >>>+
> >>>+echo "Create the original files"
> >>>+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1 >> $seqres.full
> >>>+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
> >>>+seq 0 $blksz $((sz - blksz)) | while read offset; do
> >>>+	_reflink_range $testdir/file1 $offset $testdir/file2 $offset $blksz >> $seqres.full
> >>>+done
> >>>+
> >>>+echo "Compare files"
> >>>+md5sum $testdir/file1 | _filter_scratch
> >>>+md5sum $testdir/file2 | _filter_scratch
> >>>+
> >>>+echo "Check extent counts"
> >>>+f1=$(_count_extents $testdir/file1)
> >>>+f2=$(_count_extents $testdir/file2)
> >>>+s1=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> >>>+s2=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file2 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> >>>+
> >>>+# Did the fs combine the extent mappings when we made f2?
> >>>+test $f1 -eq $f2 || echo "f1 ($f1) != f2 ($f2)"
> >>>+test $s1 -eq $s2 || echo "s1 ($s1) != s2 ($s2)"
> >>>+test $f1 -eq $s1 || echo "f1 ($f1) != s1 ($f1)"
> >>>+test $f2 -eq $s2 || echo "f2 ($f2) != s2 ($f2)"
> >>>+
> >>>+_scratch_cycle_mount
> >>>+
> >>>+echo "Compare files after remounting"
> >>>+md5sum $testdir/file1 | _filter_scratch
> >>>+md5sum $testdir/file2 | _filter_scratch
> >>>+
> >>>+echo "Check extent counts"
> >>>+f1=$(_count_extents $testdir/file1)
> >>>+f2=$(_count_extents $testdir/file2)
> >>>+s1=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> >>>+s2=$($XFS_IO_PROG -c 'fiemap -v' $testdir/file2 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$')
> >>>+
> >>>+# Are the mappings still combined?
> >>>+test $f1 -eq $f2 || echo "f1 ($f1) != f2 ($f2)"
> >>>+test $s1 -eq $s2 || echo "s1 ($s1) != s2 ($s2)"
> >>>+test $f1 -eq $s1 || echo "f1 ($f1) != s1 ($f1)"
> >>>+test $f2 -eq $s2 || echo "f2 ($f2) != s2 ($f2)"
> >>>+
> >>>+# success, all done
> >>>+status=0
> >>>+exit
> >>>diff --git a/tests/generic/930.out b/tests/generic/930.out
> >>>new file mode 100644
> >>>index 0000000..556108a
> >>>--- /dev/null
> >>>+++ b/tests/generic/930.out
> >>>@@ -0,0 +1,11 @@
> >>>+QA output created by 930
> >>>+Format and mount
> >>>+Create the original files
> >>>+Compare files
> >>>+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file1
> >>>+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file2
> >>>+Check extent counts
> >>>+Compare files after remounting
> >>>+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file1
> >>>+de89461b64701958984c95d1bfb0065a  SCRATCH_MNT/test-930/file2
> >>>+Check extent counts
> >>>diff --git a/tests/generic/group b/tests/generic/group
> >>>index d0bc47d..4b4df66 100644
> >>>--- a/tests/generic/group
> >>>+++ b/tests/generic/group
> >>>@@ -411,3 +411,4 @@
> >>>406 auto quick dangerous
> >>>407 auto quick clone metadata
> >>>408 auto quick clone dedupe metadata
> >>>+930 auto quick clone
> >>>
> >>>--
> >>>To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>>the body of a message to majordomo@vger.kernel.org
> >>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>>
> >>
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> 
