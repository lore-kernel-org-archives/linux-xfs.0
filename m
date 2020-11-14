Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA46DC63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89A8D22265
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k0ZFxSBo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKNAjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:39:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34882 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKNAjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:39:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0XxZS033567;
        Sat, 14 Nov 2020 00:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=azqucnU68VoFKmg2HyZfWXnaENCBNFxn4ZheL5y+v7A=;
 b=k0ZFxSBojmq3FDYscAzVLdx8YOqeOIQO4e5Hqtwp1BUDS2eBop5TPkPfURFTs+3sRSa/
 q0IHTancsPAfMwgjPdA6v7tgcnWurNVjupfVZaGRZCpQuYhfbA3qcSqjRm6A32Sm4HB6
 eCG/eX9qH5B+Os/PiPwRE45B8Y055HyQJyTxIBRy/j9Z/QoEhVD70msNzGGA8fcSf5Lp
 MWOFZqx+XUghzJhN/8bDDF0Qems4mBSm13l+8UZ3Eg3Q58Y6LP6JhKASu7i8cFrSwrMq
 FRxyMHlJSElS2nzbShyDQLwHp7VHULGU1owIc1Dz7IUKb7Mc8YmSz1dmsB0qx6bGGXj4 XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhmcrnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:39:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0ZOHQ107238;
        Sat, 14 Nov 2020 00:39:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55u04nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:39:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE0dJsS016916;
        Sat, 14 Nov 2020 00:39:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:39:19 -0800
Date:   Fri, 13 Nov 2020 16:39:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: Check for extent overflow when writing to
 unwritten extent
Message-ID: <20201114003918.GH9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-8-chandanrlinux@gmail.com>
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

On Fri, Nov 13, 2020 at 04:56:59PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to an unwritten extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/527     | 125 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/527.out |  13 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 139 insertions(+)
>  create mode 100755 tests/xfs/527
>  create mode 100644 tests/xfs/527.out
> 
> diff --git a/tests/xfs/527 b/tests/xfs/527
> new file mode 100755
> index 00000000..f040aee4
> --- /dev/null
> +++ b/tests/xfs/527
> @@ -0,0 +1,125 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 527
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to an unwritten extent.
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
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +buffered_write_to_unwritten_extent()

This is nearly the same as the directio write test; could you combine
them into a single function so we have fewer functions to maintain?

--D

> +{
> +	echo "* Buffered write to unwritten extent"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	testfile=${SCRATCH_MNT}/testfile
> +
> +	nr_blks=15
> +
> +	echo "Fallocate $nr_blks blocks"
> +	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
> +
> +	echo "Buffered write to every other block of fallocated space"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile \
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
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +direct_write_to_unwritten_extent()
> +{
> +	echo "* Direct I/O write to unwritten extent"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	testfile=${SCRATCH_MNT}/testfile
> +
> +	nr_blks=15
> +
> +	echo "Fallocate $nr_blks blocks"
> +	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
> +
> +	echo "Direct I/O write to every other block of fallocated space"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		xfs_io -f -d -c "pwrite $((i * bsize)) $bsize" $testfile \
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
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +buffered_write_to_unwritten_extent
> +direct_write_to_unwritten_extent
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/527.out b/tests/xfs/527.out
> new file mode 100644
> index 00000000..6aa5e9ed
> --- /dev/null
> +++ b/tests/xfs/527.out
> @@ -0,0 +1,13 @@
> +QA output created by 527
> +* Buffered write to unwritten extent
> +Format and mount fs
> +Fallocate 15 blocks
> +Inject reduce_max_iextents error tag
> +Buffered write to every other block of fallocated space
> +Verify $testfile's extent count
> +* Direct I/O write to unwritten extent
> +Format and mount fs
> +Fallocate 15 blocks
> +Inject reduce_max_iextents error tag
> +Direct I/O write to every other block of fallocated space
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index d089797b..627813fe 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -524,3 +524,4 @@
>  524 auto quick punch zero insert collapse
>  525 auto quick attr
>  526 auto quick dir hardlink symlink
> +527 auto quick
> -- 
> 2.28.0
> 
