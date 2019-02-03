Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45078 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfBCJPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Feb 2019 04:15:04 -0500
Date: Sun, 3 Feb 2019 17:14:55 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 4/4] generic: check for reasonable inode creation time
Message-ID: <20190203091455.GO2713@desktop>
References: <154877863279.9277.4463697450629081138.stgit@magnolia>
 <154877865178.9277.5385935769005684086.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154877865178.9277.5385935769005684086.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jan 29, 2019 at 08:17:31AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If statx returns inode creation time (aka btime), check it to make sure
> that the filesystem is setting a creation time that's reasonably close
> to when it creates a file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/709     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/709.out |    2 ++
>  tests/generic/group   |    1 +
>  3 files changed, 64 insertions(+)
>  create mode 100755 tests/generic/709
>  create mode 100644 tests/generic/709.out
> 
> 
> diff --git a/tests/generic/709 b/tests/generic/709
> new file mode 100755
> index 00000000..724a16a8
> --- /dev/null
> +++ b/tests/generic/709
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 709
> +#
> +# Check that statx btime (aka creation time) is plausibly close to when
> +# we created a file.  A bug caught during code review of xfs patches revealed
> +# that there weren't any sanity checks of the btime values.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +testfile=$TEST_DIR/$seq.txt
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $testfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/attr
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_xfs_io_command "statx" "-r"

testfile is in $TEST_DIR, needs _require_test here.

> +
> +rm -f $seqres.full
> +rm -f $testfile
> +
> +# Create a file and the time we created it
> +now=$(date +%s)
> +touch $testfile
> +
> +# Does statx return results with the BTIME flag set in the result mask?
> +STATX_BTIME=0x800
> +$XFS_IO_PROG -c "statx -F -r -m $STATX_BTIME" $testfile > $tmp.statx
> +cat $tmp.statx >> $seqres.full
> +
> +result_mask=$(grep 'stat.mask =' $tmp.statx | cut -d ' ' -f 3)
> +test -n "$result_mask" || _notrun "did not see stat.mask in output"
> +
> +test "$(( result_mask & STATX_BTIME ))" -ne 0 || \
> +	_notrun "statx did not return btime"

We have a _require_btime helper now, I think that's sufficient.

> +
> +# Make sure the reported btime is within 5 seconds of the time we recorded
> +# just prior to creating the file.
> +btime=$(grep 'stat.btime.tv_sec =' $tmp.statx | cut -d ' ' -f 3)

And the btime timestamp could be retrieved like

btime=$(date +%s -d "$($XFS_IO_PROG -c "statx -v" $testfile | grep btime | cut -d= -f2)"

so we don't have to check the statx masks?

Thanks,
Eryu

> +test -n "$btime" || echo "error: did not see btime in output??"
> +
> +_within_tolerance "btime" "$btime" "$now" 0 5 -v
> +
> +status=0
> +exit
> diff --git a/tests/generic/709.out b/tests/generic/709.out
> new file mode 100644
> index 00000000..d8495ace
> --- /dev/null
> +++ b/tests/generic/709.out
> @@ -0,0 +1,2 @@
> +QA output created by 709
> +btime is in range
> diff --git a/tests/generic/group b/tests/generic/group
> index 6f5f28d8..9ce608c0 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -527,3 +527,4 @@
>  522 soak long_rw
>  523 auto quick attr
>  524 auto quick
> +709 auto quick
> 
