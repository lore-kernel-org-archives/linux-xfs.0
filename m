Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44451 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbeCWF0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 01:26:16 -0400
Date: Fri, 23 Mar 2018 13:26:06 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3] xfs: test agfl reset on bad list wrapping
Message-ID: <20180323052540.GZ30836@localhost.localdomain>
References: <20180321165716.GB4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321165716.GB4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Wed, Mar 21, 2018 at 09:57:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> From the kernel patch that this test examines ("xfs: detect agfl count
> corruption and reset agfl"):
> 
> "The struct xfs_agfl v5 header was originally introduced with
> unexpected padding that caused the AGFL to operate with one less
> slot than intended. The header has since been packed, but the fix
> left an incompatibility for users who upgrade from an old kernel
> with the unpacked header to a newer kernel with the packed header
> while the AGFL happens to wrap around the end. The newer kernel
> recognizes one extra slot at the physical end of the AGFL that the
> previous kernel did not. The new kernel will eventually attempt to
> allocate a block from that slot, which contains invalid data, and
> cause a crash.
> 
> "This condition can be detected by comparing the active range of the
> AGFL to the count. While this detects a padding mismatch, it can
> also trigger false positives for unrelated flcount corruption. Since
> we cannot distinguish a size mismatch due to padding from unrelated
> corruption, we can't trust the AGFL enough to simply repopulate the
> empty slot.
> 
> "Instead, avoid unnecessarily complex detection logic and and use a
> solution that can handle any form of flcount corruption that slips
> through read verifiers: distrust the entire AGFL and reset it to an
> empty state. Any valid blocks within the AGFL are intentionally
> leaked. This requires xfs_repair to rectify (which was already
> necessary based on the state the AGFL was found in). The reset
> mitigates the side effect of the padding mismatch problem from a
> filesystem crash to a free space accounting inconsistency."
> 
> This test exercises the reset code by mutating a fresh filesystem to
> contain an agfl with various list configurations of correctly wrapped,
> incorrectly wrapped, not wrapped, and actually corrupt free lists; then
> checks the success of the reset operation by fragmenting the free space
> btrees to exercise the agfl.  Kernels without this reset fix will shut
> down the filesystem with corruption errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: use fallocate instead of dd write, more factoring of common code
> v2: remove unncessary umounts, refactor long lines into helpers
> ---
>  common/rc         |   23 ++++-
>  tests/xfs/709     |  258 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/709.out |   13 +++
>  tests/xfs/group   |    1 
>  4 files changed, 293 insertions(+), 2 deletions(-)
>  create mode 100755 tests/xfs/709
>  create mode 100644 tests/xfs/709.out
> 
> diff --git a/common/rc b/common/rc
> index 2c29d55..f7eb72d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3440,6 +3440,26 @@ _get_device_size()
>  	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
>  }
>  
> +# Make sure we actually have dmesg checking set up.
> +_require_check_dmesg() {
> +	test -w /dev/kmsg || \
> +		_notrun "Test requires writable /dev/kmsg."
> +}
> +
> +# Return the dmesg log since the start of this test.  Caller must ensure that
> +# /dev/kmsg was writable when the test was started so that we can find the
> +# beginning of this test's log messages; _require_check_dmesg does this.
> +_dmesg_since_test_start() {
> +	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> +		tac
> +}
> +
> +# check dmesg log for a specific string, subject to the same requirements as
> +# _dmesg_since_test_start.
> +_check_dmesg_for() {
> +	_dmesg_since_test_start | egrep -q "$1"
> +}
> +
>  # check dmesg log for WARNING/Oops/etc.
>  _check_dmesg()
>  {
> @@ -3455,8 +3475,7 @@ _check_dmesg()
>  
>  	# search the dmesg log of last run of $seqnum for possible failures
>  	# use sed \cregexpc address type, since $seqnum contains "/"

The comments about sed usage probably should go to
_dmesg_since_test_start() too.

> -	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> -		tac | $filter >$seqres.dmesg
> +	_dmesg_since_test_start | $filter >$seqres.dmesg
>  	egrep -q -e "kernel BUG at" \
>  	     -e "WARNING:" \
>  	     -e "BUG:" \
> diff --git a/tests/xfs/709 b/tests/xfs/709
> new file mode 100755
> index 0000000..78cefe5
> --- /dev/null
> +++ b/tests/xfs/709
> @@ -0,0 +1,258 @@
> +#! /bin/bash
> +# FS QA Test No. 709
> +#
> +# Make sure XFS can fix a v5 AGFL that wraps over the last block.
> +# Refer to commit 96f859d52bcb ("libxfs: pack the agfl header structure so
> +# XFS_AGFL_SIZE is correct") for details on the original on-disk format error
> +# and the patch "xfs: detect agfl count corruption and reset agfl") for details
> +# about the fix.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2018 Oracle, Inc.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1
> +trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +rm -f $seqres.full
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_check_dmesg
> +_require_scratch
> +_require_test_program "punch-alternating"
> +
> +# This is only a v5 filesystem problem
> +_require_scratch_xfs_crc
> +
> +mount_loop() {
> +	if ! _try_scratch_mount >> $seqres.full 2>&1; then
> +		echo "scratch mount failed" >> $seqres.full
> +		return
> +	fi
> +
> +	# Trigger agfl fixing by fragmenting free space enough to cause
> +	# a bnobt split
> +	blksz=$(_get_file_block_size ${SCRATCH_MNT})
> +	bno_maxrecs=$(( blksz / 8 ))
> +	filesz=$((bno_maxrecs * 3 * blksz))
> +	rm -rf $SCRATCH_MNT/a
> +	$XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/a

And I noticed test failure with patch "xfs: detect agfl count corruption
and reset agfl" applied on top of 4.16-rc5 kernel. Looks like we should
dump xfs_io output to $seqres.full, as in v2 patch

dd if=/dev/zero of=$SCRATCH_MNT/a bs=8192k >> $seqres.full 2>&1

--- tests/xfs/709.out   2018-03-23 12:45:16.831011711 +0800
+++ /root/workspace/xfstests/results//xfs_4k_crc/xfs/709.out.bad        2018-03-23 13:12:10.083980820 +0800
@@ -7,6 +7,7 @@
 TEST good_start
 TEST good_wrap
 TEST bad_start
+fallocate: Structure needs cleaning
 ASSERT flfirst < good_agfl_size - 1
 ASSERT flfirst < fllast
 TEST no_move

> +	test -e $SCRATCH_MNT/a && ./src/punch-alternating $SCRATCH_MNT/a
> +	rm -rf $SCRATCH_MNT/a
> +
> +	_scratch_unmount 2>&1 | _filter_scratch
> +}
> +
> +dump_ag0() {
> +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p'
> +}
> +
> +runtest() {
> +	cmd="$1"
> +
> +	# Format filesystem
> +	echo "TEST $cmd" | tee /dev/ttyprintk

What's the purpose of writing to /dev/ttyprintk? I don't see how it's
used in the test.

Thanks,
Eryu
