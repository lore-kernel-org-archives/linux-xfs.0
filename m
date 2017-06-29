Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751602AbdF2JgR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 05:36:17 -0400
Date: Thu, 29 Jun 2017 17:36:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 5/8] reflink: test unlinking a huge extent with a lot of
 refcount adjustments
Message-ID: <20170629093614.GO23360@eguan.usersys.redhat.com>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <149808226863.8924.5799576767468365376.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808226863.8924.5799576767468365376.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jun 21, 2017 at 02:57:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Test a regression in XFS where we blow out a transaction reservation if
> we create a big file, share every other block, and delete the first
> file.  There's nothing particularly fs-specific about this stress test,
> so put it in generic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This test took me 3019s to finish with v4.12-rc7 kernel, and another
host "hung" at "Delete file1" (it had been more than 1 hour, and I lost
my patience and hard-reboot the host). Are they expected results?

If the bug is still existed in latest upstream kernel, I tend to merge
it after the fix landing in linus tree. If v4.12-rc7 doesn't suffer from
this bug, the test time should be reduced.

And another minor nit below.

> ---
>  tests/generic/931     |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/931.out |    6 +++
>  tests/generic/group   |    1 +
>  3 files changed, 101 insertions(+)
>  create mode 100755 tests/generic/931
>  create mode 100644 tests/generic/931.out
> 
> 
> diff --git a/tests/generic/931 b/tests/generic/931
> new file mode 100755
> index 0000000..afadf81
> --- /dev/null
> +++ b/tests/generic/931
> @@ -0,0 +1,94 @@
> +#! /bin/bash
> +# FS QA Test No. 931
> +#
> +# See how well we handle deleting a file with a million refcount extents.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +
> +seq=`basename "$0"`
> +seqres="$RESULT_DIR/$seq"
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -rf "$tmp".* $testdir/file1

'rm -rf' looks a bit scary, and we're only deleting regular files not
directories, 'rm -f' should be sufficient.

Thanks,
Eryu

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_os Linux
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_test_program "punch-alternating"
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount >> "$seqres.full" 2>&1
> +
> +testdir="$SCRATCH_MNT/test-$seq"
> +mkdir "$testdir"
> +
> +# Setup for one million blocks, but we'll accept stress testing down to
> +# 2^17 blocks... that should be plenty for anyone.
> +fnr=20
> +free_blocks=$(stat -f -c '%a' "$testdir")
> +blksz=$(_get_block_size "$testdir")
> +space_avail=$((free_blocks * blksz))
> +calc_space() {
> +	blocks_needed=$(( 2 ** (fnr + 1) ))
> +	space_needed=$((blocks_needed * blksz * 5 / 4))
> +}
> +calc_space
> +while test $space_needed -gt $space_avail; do
> +	fnr=$((fnr - 1))
> +	calc_space
> +done
> +test $fnr -lt 17 && _notrun "Insufficient space for stress test; would only create $blocks_needed extents ($space_needed/$space_avail blocks)."
> +
> +echo "Create a many-block file"
> +echo "creating $blocks_needed blocks..." >> "$seqres.full"
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 0 $((2 ** (fnr + 1) * blksz))" "$testdir/file1" >> "$seqres.full"
> +
> +echo "Reflinking file"
> +_cp_reflink $testdir/file1 $testdir/file2
> +
> +echo "Punch file2"
> +echo "Punching file2..." >> "$seqres.full"
> +"$here/src/punch-alternating" "$testdir/file2" >> "$seqres.full"
> +echo "...done" >> "$seqres.full"
> +_scratch_cycle_mount
> +
> +echo "Delete file1"
> +rm -rf $testdir/file1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/931.out b/tests/generic/931.out
> new file mode 100644
> index 0000000..c7b724e
> --- /dev/null
> +++ b/tests/generic/931.out
> @@ -0,0 +1,6 @@
> +QA output created by 931
> +Format and mount
> +Create a many-block file
> +Reflinking file
> +Punch file2
> +Delete file1
> diff --git a/tests/generic/group b/tests/generic/group
> index ab1e9d3..b0d1844 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -443,3 +443,4 @@
>  438 auto
>  439 auto quick punch
>  440 auto quick encrypt
> +931 auto quick clone
> 
