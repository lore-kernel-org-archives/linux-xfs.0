Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44304 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbeFYEBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jun 2018 00:01:00 -0400
Date: Mon, 25 Jun 2018 12:00:54 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 3/4] generic: mread past eof shows nonzero contents
Message-ID: <20180625040054.GO2780@desktop>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
 <152960596951.26479.121617216998011751.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960596951.26479.121617216998011751.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 21, 2018 at 11:32:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain sequences of generic/127 invocations complain about being able
> to mread nonzero contents past eof.  Replicate that here as a regression
> test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/708     |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/708.out |    2 ++
>  tests/generic/group   |    1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/generic/708
>  create mode 100644 tests/generic/708.out
> 
> 
> diff --git a/tests/generic/708 b/tests/generic/708
> new file mode 100755
> index 00000000..d380053f
> --- /dev/null
> +++ b/tests/generic/708
> @@ -0,0 +1,54 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 708
> +#
> +# Test a specific sequence of fsx operations that causes an mmap read past
> +# eof to return nonzero contents.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
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
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +cat >> $tmp.fsxops << ENDL
> +fallocate 0x77e2 0x5f06 0x269a2 keep_size
> +mapwrite 0x2e7fc 0x42ba 0x3f989
> +write 0x67a9 0x714e 0x3f989
> +write 0x39f96 0x185a 0x3f989
> +collapse_range 0x36000 0x8000 0x3f989
> +mapread 0x74c0 0x1bb3 0x3e2d0
> +truncate 0x0 0x8aa2 0x3e2d0
> +zero_range 0x1265 0x783d 0x8aa2
> +mapread 0x7bd8 0xeca 0x8aa2
> +ENDL
> +
> +victim=$SCRATCH_MNT/a
> +touch $victim
> +$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output

This fails when $FSTYP doesn't support fallocate and the related flags,
e.g. ext2 fails as

 QA output created by 708
 +main: filesystem does not support fallocate mode 0, disabling!
 +main: filesystem does not support fallocate mode FALLOC_FL_KEEP_SIZE, disabling!
 +main: filesystem does not support fallocate mode FALLOC_FL_ZERO_RANGE, disabling!
 +main: filesystem does not support fallocate mode FALLOC_FL_COLLAPSE_RANGE, disabling!
 +main: filesystem does not support fallocate mode FALLOC_FL_INSERT_RANGE, disabling!
  Silence is golden

The messages are just informative, I throw stderr to $tmp.output too on
commit.

Thanks,
Eryu

> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/708.out b/tests/generic/708.out
> new file mode 100644
> index 00000000..33c478ad
> --- /dev/null
> +++ b/tests/generic/708.out
> @@ -0,0 +1,2 @@
> +QA output created by 708
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 83a6fdab..1a1a0a6e 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -501,3 +501,4 @@
>  496 auto quick swap
>  497 auto quick swap collapse
>  498 auto quick log
> +708 auto quick rw collapse
> 
