Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E619C55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 381C822260
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rwj2m2Jp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKNApz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:45:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNApz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:45:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0YHd5033621;
        Sat, 14 Nov 2020 00:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4gcUJYJAH7C8mh7Er26HMSh4CH2GVI2wJel7n+WnL/Q=;
 b=rwj2m2JpD5CdnyZsKGLcNUNCgTYXD2Ad2iIr7oQVPPJC3T6T122BrzU9/A2quMR79CI6
 tjtKk7VMzWDvSCgr1MiemRW+sU3gf+HxCsdPyJQ2kKXL6j4yCVEV0dcEPKb4WdZBEhsv
 T0GsoFOopx743TnmDJE7/XDtQS3M0PnXycCc2UFb4jLD7e27VkkjWSLG0k53SK31TTpu
 e7mo1vaXZJR0fvI3Msn1+/eMaEbT9diOK4DGp0VBigEsGqw7X96l0kPcjgh9LJrdAaK5
 rKUzrop5in0NIRZZ4qh62ZntM8H1rDuF3+rpIz8x1Kmruxa7WrJ/pDpNrPOT1VnZS8NX hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhmcrvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:45:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0ZN0j107198;
        Sat, 14 Nov 2020 00:43:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55u0ap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:43:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0hpoO027981;
        Sat, 14 Nov 2020 00:43:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:43:51 -0800
Date:   Fri, 13 Nov 2020 16:43:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: Check for extent overflow when remapping an
 extent
Message-ID: <20201114004348.GJ9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-10-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:57:01PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when remapping extents from one file's inode fork to another.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/529     | 86 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/529.out |  8 +++++
>  tests/xfs/group   |  1 +
>  3 files changed, 95 insertions(+)
>  create mode 100755 tests/xfs/529
>  create mode 100644 tests/xfs/529.out
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> new file mode 100755
> index 00000000..a44ce199
> --- /dev/null
> +++ b/tests/xfs/529
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 529
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# remapping extents from one file's inode fork to another.
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
> +. ./common/reflink
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Reflink remap extents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +nr_blks=15
> +
> +echo "Create \$srcfile having an extent of length $nr_blks blocks"
> +xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile >> $seqres.full
> +
> +echo "Create \$dstfile having an extent of length $nr_blks blocks"
> +xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $dstfile >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +echo "Reflink every other block from \$srcfile into \$dstfile"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	xfs_io -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
> +	       $dstfile >> $seqres.full 2>&1
> +done
> +
> +ino=$(stat -c "%i" $dstfile)
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify \$dstfile's extent count"
> +
> +nextents=$(_scratch_get_iext_count $ino data ||
> +		_fail "Unable to obtain inode fork's extent count")
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +fi

Generally looks fine, though many of the comments I've made about the
other patches (mkfs size, _get_file_block_size usage, etc.) apply here
too.

--D

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> new file mode 100644
> index 00000000..687a8bd2
> --- /dev/null
> +++ b/tests/xfs/529.out
> @@ -0,0 +1,8 @@
> +QA output created by 529
> +* Reflink remap extents
> +Format and mount fs
> +Create $srcfile having an extent of length 15 blocks
> +Create $dstfile having an extent of length 15 blocks
> +Inject reduce_max_iextents error tag
> +Reflink every other block from $srcfile into $dstfile
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c85aac6b..bc3958b3 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>  526 auto quick dir hardlink symlink
>  527 auto quick
>  528 auto quick reflink
> +529 auto quick reflink
> -- 
> 2.28.0
> 
