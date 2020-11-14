Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51A9C63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ADA72225B
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ILDYUtlc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKNA2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:28:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKNA2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:28:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0E25l167440;
        Sat, 14 Nov 2020 00:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=z/iSe4V4xX1sXCzMxlgb3QqM2CxqPXVlXnJN8F93/Ug=;
 b=ILDYUtlcZxdvu7H3/8GF1WbU/IxbPrAwxwS2dpuC7+fy2wMKLL/SL6KTjHead2RUerWz
 8M46RkxluRsfe8GXAWXhGi7cRD+D1UWIIWLNgGoirXAHZDeXihryXPjDLYk1FgMUE1px
 90vICP9vDRS4N1NO+4b8z4YsIOJ6hAZJN7lZ3hutBiXUJFjUKsjjBtuDW33PA/++te3X
 al5NvTxg+4/0HPH1VEI4FyRM+cLC6a+WqVs8GnGMME1sjT0asmYjGZuYQvnYNyDVBVnf
 eMKKzXGHy0CxYHpI7a53ODzaJe3U4XiQKzcDByBqGlthYgM8kBYm/NE5hCo8hdGD3jo2 tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3bcyqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:28:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0BOfU056951;
        Sat, 14 Nov 2020 00:28:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55tyq6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:28:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0SEud026523;
        Sat, 14 Nov 2020 00:28:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:28:13 -0800
Date:   Fri, 13 Nov 2020 16:28:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: Check for extent overflow when punching a hole
Message-ID: <20201114002812.GE9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-5-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:56:56PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when punching out an extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/524     | 210 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/524.out |  25 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 236 insertions(+)
>  create mode 100755 tests/xfs/524
>  create mode 100644 tests/xfs/524.out
> 
> diff --git a/tests/xfs/524 b/tests/xfs/524
> new file mode 100755
> index 00000000..9e140c99
> --- /dev/null
> +++ b/tests/xfs/524
> @@ -0,0 +1,210 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 524
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# punching out an extent.
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
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "fzero"

For completeness, should this also be testing funshare?

> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +punch_range()
> +{
> +	echo "* Fpunch regular file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full

I don't think you need a fresh format for each functional test.

> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	nr_blks=30
> +
> +	echo "Create \$testfile"
> +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +	       -c sync $testfile  >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "fpunch alternating blocks"
> +	$here/src/punch-alternating $testfile >> $seqres.full 2>&1
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $testino data ||

...and now that I keep seeing this unmount-getiextcount-mount dance, you
probably should convert these to grab the extent count info online.

--D

> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +finsert_range()
> +{
> +	echo "* Finsert regular file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)	
> +
> +	nr_blks=30
> +
> +	echo "Create \$testfile"
> +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +	       -c sync $testfile  >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Finsert at every other block offset"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		xfs_io -f -c "finsert $((i * bsize)) $bsize" $testfile \
> +		       >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $testino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = ${nextents}"
> +		exit 1
> +	fi
> +}
> +
> +fcollapse_range()
> +{
> +	echo "* Fcollapse regular file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)	
> +
> +	nr_blks=30
> +
> +	echo "Create \$testfile"
> +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +	       -c sync $testfile  >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Fcollapse at every other block offset"
> +	for i in $(seq 1 $((nr_blks / 2 - 1))); do
> +		xfs_io -f -c "fcollapse $((i * bsize)) $bsize" $testfile \
> +		       >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $testino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = ${nextents}"
> +		exit 1
> +	fi
> +}
> +
> +fzero_range()
> +{
> +	echo "* Fzero regular file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)	
> +
> +	nr_blks=30
> +
> +	echo "Create \$testfile"
> +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +	       -c sync $testfile  >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Fzero at every other block offset"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		xfs_io -f -c "fzero $((i * bsize)) $bsize" $testfile \
> +		       >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $testino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = ${nextents}"
> +		exit 1
> +	fi
> +}
> +
> +punch_range
> +finsert_range
> +fcollapse_range
> +fzero_range
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/524.out b/tests/xfs/524.out
> new file mode 100644
> index 00000000..58f7d7ae
> --- /dev/null
> +++ b/tests/xfs/524.out
> @@ -0,0 +1,25 @@
> +QA output created by 524
> +* Fpunch regular file
> +Format and mount fs
> +Create $testfile
> +Inject reduce_max_iextents error tag
> +fpunch alternating blocks
> +Verify $testfile's extent count
> +* Finsert regular file
> +Format and mount fs
> +Create $testfile
> +Inject reduce_max_iextents error tag
> +Finsert at every other block offset
> +Verify $testfile's extent count
> +* Fcollapse regular file
> +Format and mount fs
> +Create $testfile
> +Inject reduce_max_iextents error tag
> +Fcollapse at every other block offset
> +Verify $testfile's extent count
> +* Fzero regular file
> +Format and mount fs
> +Create $testfile
> +Inject reduce_max_iextents error tag
> +Fzero at every other block offset
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 018c70ef..3fa38c36 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -521,3 +521,4 @@
>  521 auto quick realtime growfs
>  522 auto quick quota
>  523 auto quick realtime growfs
> +524 auto quick punch zero insert collapse
> -- 
> 2.28.0
> 
