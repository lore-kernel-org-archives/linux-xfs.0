Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965894AbeF1OMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 10:12:16 -0400
Date: Thu, 28 Jun 2018 07:12:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: test bad character in xfs_db field list selector
 string
Message-ID: <20180628141201.GA5703@magnolia>
References: <20180627165957.12892-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180627165957.12892-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:59:57AM +0800, Zorro Lang wrote:
> Bad characters likes tailing asterisk, slash or quote in xfs_db
> field string can trigger a xfs_db crash. This bug has been fixed
> by xfsprogs "945e47e2 xfs_db: fix crash when field list selector
> string has trailing slash".
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Could've sworn I had a test that did this, but ... clearly not. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/450     | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/450.out |  7 +++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/xfs/450
>  create mode 100644 tests/xfs/450.out
> 
> diff --git a/tests/xfs/450 b/tests/xfs/450
> new file mode 100755
> index 00000000..73b0cad8
> --- /dev/null
> +++ b/tests/xfs/450
> @@ -0,0 +1,49 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 450
> +#
> +# Test xfs_db by bad character in field list selector string. The issue
> +# has been fixed by xfsprogs 945e47e2.
> +#
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
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs_xfs >> $seqres.full 2>&1
> +inum=`_scratch_xfs_get_metadata_field rootino "sb 0"`
> +
> +echo "= check bad character * ="
> +_scratch_xfs_db -c "inode $inum" -c "print core.*"
> +echo "= check bad character trailing slash ="
> +_scratch_xfs_db -c "inode $inum" -c "print core.\\"
> +echo "= check missing closing quote ="
> +_scratch_xfs_db -c "inode $inum" -c "print core.\""
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/450.out b/tests/xfs/450.out
> new file mode 100644
> index 00000000..dab51786
> --- /dev/null
> +++ b/tests/xfs/450.out
> @@ -0,0 +1,7 @@
> +QA output created by 450
> += check bad character * =
> +bad character in field *
> += check bad character trailing slash =
> +bad character in field \
> += check missing closing quote =
> +missing closing quote 
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 932ab909..4d8e0b30 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -447,3 +447,4 @@
>  447 auto mount
>  448 auto quick fuzzers
>  449 auto quick
> +450 auto db
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
