Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46602 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbfANJap (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 04:30:45 -0500
Date: Mon, 14 Jan 2019 17:30:36 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] tests/generic: test writepage cached mapping validity
Message-ID: <20190114093036.GH2713@desktop>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111133124.31879-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111133124.31879-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jan 11, 2019 at 08:31:24AM -0500, Brian Foster wrote:
> XFS has a bug where page writeback can end up sending data to the
> wrong location due to a stale, cached file mapping. Add a test to
> trigger this problem by racing background writeback with a
> truncate/rewrite of the final page of the file.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This is a resend of an old post[1] that never quite made it upstream. It
> wasn't a big deal at the time because we didn't really have a proper fix
> for the problem. I'm resending now because there is a proposed fix[2].

Thanks for the resending!

> 
> I've verified that this still reproduces the problem and no longer fails
> with the fix applied (in hundreds of iters). Note that reproduction may
> require many iterations. It took me anywhere from 5 to 30 or so on the
> box I tested, which I think is reasonable for the tradeoff of a fairly
> quick test. There was some discussion on the original post around making
> the test run longer for a more reliable reproducer, but I'm not sure how
> valuable that is given this is a targeted regression test. Thoughts
> appreciated.

It took me around 5 iterations to hit the corruption, I think it's fine.

But a couple of things changed over the years :)

> 
> Brian
> 
> [1] https://marc.info/?l=fstests&m=150902929900510&w=2
> [2] https://marc.info/?l=linux-xfs&m=154721212321112&w=2
> 
>  tests/generic/999     | 94 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  2 +
>  tests/generic/group   |  1 +
>  3 files changed, 97 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..9e56a1e0
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,94 @@
> +#! /bin/bash
> +# FS QA Test 999
> +#
> +# Test XFS page writeback code for races with the cached file mapping. XFS
> +# caches the file -> block mapping for a full extent once it is initially looked
> +# up. The cached mapping is used for all subsequent pages in the same writeback
> +# cycle that cover the associated extent. Under certain conditions, it is
> +# possible for concurrent operations on the file to invalidate the cached
> +# mapping without the knowledge of writeback. Writeback ends up sending I/O to a
> +# partly stale mapping and potentially leaving delalloc blocks in the current
> +# mapping unconverted.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
                   ^^^^ 2019?
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

And please change this to SPDX-License-Identifier.

> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_test_program "feature"

_require_xfs_io_command "sync_range"

> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount || _fail "mount failed"

_scratch_mount will _fail the test on failure now :)

> +
> +file=$SCRATCH_MNT/file
> +filesize=$((1024 * 1024 * 32))
> +pagesize=`src/feature -s`
> +truncsize=$((filesize - pagesize))
> +
> +for i in $(seq 0 15); do
> +	# Truncate the file and fsync to persist the final size on-disk. This is
> +	# required so the subsequent truncate will not wait on writeback.
> +	$XFS_IO_PROG -fc "truncate 0" $file
> +	$XFS_IO_PROG -c "truncate $filesize" -c fsync $file
> +
> +	# create a small enough delalloc extent to likely be contiguous
> +	$XFS_IO_PROG -c "pwrite 0 $filesize" $file >> $seqres.full 2>&1
> +
> +	# Start writeback and a racing truncate and rewrite of the final page.
> +	$XFS_IO_PROG -c "sync_range -w 0 0" $file &
> +	sync_pid=$!
> +	$XFS_IO_PROG -c "truncate $truncsize" \
> +		     -c "pwrite $truncsize $pagesize" $file >> $seqres.full 2>&1
> +
> +	# If the test fails, the most likely outcome is an sb_fdblocks mismatch
> +	# and/or an associated delalloc assert failure on inode reclaim. Cycle
> +	# the mount to trigger detection.
> +	wait $sync_pid
> +	_scratch_cycle_mount || _fail "mount failed"

And _scratch_cycle_mount will exit the test on failure as well.

Thanks,
Eryu

> +done
> +
> +echo Silence is golden
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..3b276ca8
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index ea5aa7aa..ce165981 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -525,3 +525,4 @@
>  520 auto quick log
>  521 soak long_rw
>  522 soak long_rw
> +999 auto quick
> -- 
> 2.17.2
> 
