Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43546 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfEZOuI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 10:50:08 -0400
Date: Sun, 26 May 2019 22:49:58 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH ] xfs: basic testing of new xfs_spaceman health command
Message-ID: <20190526144958.GQ15846@desktop>
References: <155839149301.62876.7233006456381129816.stgit@magnolia>
 <155839150130.62876.6329606122510578337.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155839150130.62876.6329606122510578337.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, May 20, 2019 at 03:31:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Basic tests to make sure xfs_spaceman health command works properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs        |    7 ++++
>  tests/xfs/742     |   52 +++++++++++++++++++++++++++++++++
>  tests/xfs/742.out |    2 +
>  tests/xfs/743     |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/743.out |    4 +++
>  tests/xfs/group   |    2 +
>  6 files changed, 151 insertions(+)
>  create mode 100755 tests/xfs/742
>  create mode 100644 tests/xfs/742.out
>  create mode 100755 tests/xfs/743
>  create mode 100644 tests/xfs/743.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 42f02ff7..f8dafc6c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -773,7 +773,12 @@ _require_xfs_spaceman_command()
>  	_require_command "$XFS_SPACEMAN_PROG" "xfs_spaceman"
>  
>  	testfile=$TEST_DIR/$$.xfs_spaceman
> +	touch $testfile
>  	case $command in
> +	"health")
> +		testio=`$XFS_SPACEMAN_PROG -c "health $param" $TEST_DIR 2>&1`
> +		param_checked=1
> +		;;
>  	*)
>  		testio=`$XFS_SPACEMAN_PROG -c "help $command" $TEST_DIR 2>&1`
>  	esac
> @@ -787,6 +792,8 @@ _require_xfs_spaceman_command()
>  		_notrun "xfs_spaceman $command failed (old kernel/wrong fs/bad args?)"
>  	echo $testio | grep -q "foreign file active" && \
>  		_notrun "xfs_spaceman $command not supported on $FSTYP"
> +	echo $testio | grep -q "Inappropriate ioctl for device" && \
> +		_notrun "xfs_spaceman $command support is missing (missing ioctl?)"
>  	echo $testio | grep -q "Function not implemented" && \
>  		_notrun "xfs_spaceman $command support is missing (missing syscall?)"
>  
> diff --git a/tests/xfs/742 b/tests/xfs/742
> new file mode 100755
> index 00000000..2529c40a
> --- /dev/null
> +++ b/tests/xfs/742
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 742
> +#
> +# Ensure all xfs_spaceman commands are documented.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_command "$XFS_SPACEMAN_PROG" "xfs_spaceman"
> +_require_command "$MAN_PROG" man
> +
> +echo "Silence is golden"
> +
> +MANPAGE=$($MAN_PROG --path xfs_spaceman)
> +
> +case "$MANPAGE" in
> +*.gz|*.z\|*.Z)	CAT=zcat;;
> +*.bz2)		CAT=bzcat;;
> +*.xz)		CAT=xzcat;;
> +*)		CAT=cat;;
> +esac
> +_require_command `which $CAT` $CAT
> +
> +for COMMAND in `$XFS_SPACEMAN_PROG -c help $TEST_DIR | awk '{print $1}' | grep -v "^Use"`; do
> +  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
> +	echo "$COMMAND not documented in the xfs_spaceman manpage"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/742.out b/tests/xfs/742.out
> new file mode 100644
> index 00000000..ef4f23cd
> --- /dev/null
> +++ b/tests/xfs/742.out
> @@ -0,0 +1,2 @@
> +QA output created by 742
> +Silence is golden
> diff --git a/tests/xfs/743 b/tests/xfs/743
> new file mode 100755
> index 00000000..d0b7b3b0
> --- /dev/null
> +++ b/tests/xfs/743
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 743
> +#
> +# Basic tests of the xfs_spaceman health command.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/fuzzy
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_scrub
> +_require_xfs_spaceman_command "health"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $tmp.mkfs

I redirected both stdout and stderr to $seqres.full.

> +_scratch_mount
> +
> +# Haven't checked anything, it should tell us to run scrub
> +$XFS_SPACEMAN_PROG -c "health" $SCRATCH_MNT
> +
> +echo "Silence is golden"

This test doesn't need it, I updated the .out file as well.

Thanks,
Eryu

> +
> +# Run scrub to collect health info.
> +_scratch_scrub -n >> $seqres.full
> +
> +query() {
> +	$XFS_SPACEMAN_PROG -c "$@" $SCRATCH_MNT | tee -a $seqres.full
> +}
> +
> +query_health() {
> +	query "$@" | grep -q ": ok$"
> +}
> +
> +query_sick() {
> +	query "$@" | grep -q ": unhealthy$"
> +}
> +
> +# Let's see if we get at least one healthy rating for each health reporting
> +# group.
> +query_health "health -f" || \
> +	echo "Didn't see a single healthy fs metadata?"
> +
> +query_health "health -a 0" || \
> +	echo "Didn't see a single healthy ag metadata?"
> +
> +query_health "health $SCRATCH_MNT" || \
> +	echo "Didn't see a single healthy file metadata?"
> +
> +# Unmount, corrupt filesystem
> +_scratch_unmount
> +_scratch_xfs_db -x -c 'sb 1' -c 'fuzz -d magicnum random' >> $seqres.full
> +
> +# Now let's see what the AG report says
> +_scratch_mount
> +_scratch_scrub -n >> $seqres.full 2>&1
> +query_sick "health -a 1" || \
> +	echo "Didn't see the expected unhealthy metadata?"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/743.out b/tests/xfs/743.out
> new file mode 100644
> index 00000000..85232e52
> --- /dev/null
> +++ b/tests/xfs/743.out
> @@ -0,0 +1,4 @@
> +QA output created by 743
> +Health status has not been collected for this filesystem.
> +Please run xfs_scrub(8) to remedy this situation.
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c8620d72..5a4ef4bf 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -502,3 +502,5 @@
>  502 auto quick unlink
>  503 auto copy metadump
>  739 auto quick mkfs label
> +742 auto quick spaceman
> +743 auto quick health
> 
