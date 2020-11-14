Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB59C63777
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF5C12224D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BYxxyrkd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKNASS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:18:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgKNASS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:18:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0DvTo175975;
        Sat, 14 Nov 2020 00:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TO+115hT/TZAx/4eObE8AtzUOyYAMrdfVV0h2/nKeJ0=;
 b=BYxxyrkddVSHtm6iifRMoe2WiQgIqeyr0r3kl7D7Zj65kUvQ6lOhfjgVPT/YAhvD4FJq
 pel91yOU7RGhiFTcNGkVi8ZmLZff9CAcKHxYucyzSMSihjla4xKrT6k3ZxKWIBGHOhO7
 3nj9mJKUFizXR/zMiEuKH/PgD/a150qi0ikOGmHcl2JB8ChyK8PCex66uaz8KwQMwNeq
 jaXahGuXwxSolvcNIXwOR+bnJPaDX+wnEMjAUxQV2Ztaqk7ltq5uNUiYpqFQSkPGSbaQ
 9/jeBUziuGn9gUECcWjiWQavEQ6YvbtTUnyl1vTqqyCToKg81CEODiHGJVkJVAUJ5orx Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhmcqvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:18:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0B3lr083002;
        Sat, 14 Nov 2020 00:18:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34p5g5qfqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:18:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0IEWA021175;
        Sat, 14 Nov 2020 00:18:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:18:14 -0800
Date:   Fri, 13 Nov 2020 16:18:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20201114001813.GC9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-4-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=5 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Subject: xfs: Check for extent overflow when trivally adding a new extent

Why does patch 3 have the same subject as patch 2?  This confused
my quiltish scripts. :(

On Fri, Nov 13, 2020 at 04:56:55PM +0530, Chandan Babu R wrote:
> Verify that XFS does not cause inode fork's extent count to overflow
> when adding a single extent while there's no possibility of splitting an
> existing mapping (limited to realtime files only).
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/523     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/523.out |  18 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 195 insertions(+)
>  create mode 100755 tests/xfs/523
>  create mode 100644 tests/xfs/523.out
> 
> diff --git a/tests/xfs/523 b/tests/xfs/523
> new file mode 100755
> index 00000000..4f5b3584
> --- /dev/null
> +++ b/tests/xfs/523
> @@ -0,0 +1,176 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 523
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding a single extent while there's no possibility of splitting an existing
> +# mapping (limited to realtime files only).
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
> +	_scratch_unmount >> $seqres.full 2>&1
> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
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
> +_require_test
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_scratch_nocheck
> +
> +grow_rtinodes()
> +{
> +	echo "* Test extending rt inodes"
> +
> +	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +	. $tmp.mkfs
> +
> +	echo "Create fake rt volume"
> +	nr_bitmap_blks=25
> +	nr_bits=$((nr_bitmap_blks * dbsize * 8))
> +	rtextsz=$dbsize
> +	rtdevsz=$((nr_bits * rtextsz))
> +	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> +	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +	echo "Format and mount rt volume"
> +	export USE_EXTERNAL=yes
> +	export SCRATCH_RTDEV=$rtdev

I'm frankly wondering if it's time to just turn this into a
_scratch_synthesize_rtvol helper or something.

> +	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
> +		      -r size=2M,extsize=${rtextsz} >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1

Can you accomplish this with fallocate?  Or better yet _fill_fs()?

> +	sync
> +
> +	echo "Create fragmented filesystem"
> +	$here/src/punch-alternating $testfile >> $seqres.full
> +	sync
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Inject bmap_alloc_minlen_extent error tag"
> +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> +
> +	echo "Grow realtime volume"
> +	xfs_growfs -r $SCRATCH_MNT >> $seqres.full 2>&1

$XFS_GROWFS_PROG, not xfs_growfs

> +	if [[ $? == 0 ]]; then
> +		echo "Growfs succeeded; should have failed."
> +		exit 1
> +	fi
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify rbmino's and rsumino's extent count"
> +	for rtino in rbmino rsumino; do
> +		ino=$(_scratch_xfs_db -c sb -c "print $rtino")
> +		ino=${ino##${rtino} = }
> +		echo "$rtino = $ino" >> $seqres.full
> +
> +		nextents=$(_scratch_get_iext_count $ino data || \
> +				_fail "Unable to obtain inode fork's extent count")

Aha, you use this helper for the rt inodes too.  Ok, disregard my
comments for patch 1.

> +		if (( $nextents > 10 )); then
> +			echo "Extent count overflow check failed: nextents = $nextents"
> +			exit 1
> +		fi
> +	done
> +
> +	echo "Check filesystem"
> +	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +	losetup -d $rtdev
> +	rm -f $TEST_DIR/$seq.rtvol
> +
> +	export USE_EXTERNAL=""
> +	export SCRATCH_RTDEV=""
> +}
> +
> +rtfile_extend()
> +{
> +	echo "* Test extending an rt file"
> +
> +	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +	. $tmp.mkfs

Are these separate functionality tests?  If so, should they be in
separate test files?

> +
> +	echo "Create fake rt volume"
> +	nr_blks=$((15 * 2))
> +	rtextsz=$dbsize
> +	rtdevsz=$((2 * nr_blks * rtextsz))
> +	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> +	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +	echo "Format and mount rt volume"
> +	export USE_EXTERNAL=yes
> +	export SCRATCH_RTDEV=$rtdev
> +	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
> +		      -r size=$rtdevsz >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT

$XFS_IO_PROG, not xfs_io.

--D

> +
> +	echo "Create fragmented file on rt volume"
> +	testfile=$SCRATCH_MNT/testfile
> +	for i in $(seq 0 2 $((nr_blks - 1))); do
> +		xfs_io -Rf -c "pwrite $((i * dbsize)) $dbsize" -c fsync \
> +		       $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$testfile's extent count"
> +	nextents=$(_scratch_get_iext_count $testino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +
> +	echo "Check filesystem"
> +	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +	losetup -d $rtdev
> +	rm -f $TEST_DIR/$seq.rtvol
> +
> +	export USE_EXTERNAL=""
> +	export SCRATCH_RTDEV=""
> +}
> +
> +grow_rtinodes
> +rtfile_extend
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/523.out b/tests/xfs/523.out
> new file mode 100644
> index 00000000..16b4e0ad
> --- /dev/null
> +++ b/tests/xfs/523.out
> @@ -0,0 +1,18 @@
> +QA output created by 523
> +* Test extending rt inodes
> +Create fake rt volume
> +Format and mount rt volume
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Grow realtime volume
> +Verify rbmino's and rsumino's extent count
> +Check filesystem
> +* Test extending an rt file
> +Create fake rt volume
> +Format and mount rt volume
> +Inject reduce_max_iextents error tag
> +Create fragmented file on rt volume
> +Verify $testfile's extent count
> +Check filesystem
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 1831f0b5..018c70ef 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -520,3 +520,4 @@
>  520 auto quick reflink
>  521 auto quick realtime growfs
>  522 auto quick quota
> +523 auto quick realtime growfs
> -- 
> 2.28.0
> 
