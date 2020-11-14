Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4EBC63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2471C22268
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XiSN7ly4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKNAer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:34:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKNAer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:34:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0Yjvk025412;
        Sat, 14 Nov 2020 00:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Dj+BsQekoRShoV0OGc3xSdgxBWcx9Hf7ED8SHFJ56RA=;
 b=XiSN7ly4XAgMi017wTplqkdcso+9orvHw35IwndBO0KtBJO5cdOxOXdX2UsNrQePtB02
 oag8WJu/GcWrstiiZLTCE2nOqSoo++ixZZzD2+hmceqGJOkJ2pABzPMe5shfBdz+lkCq
 IUd7wIcbXLbDdhlywz2GLqKVBsXuhdUZ3hHbH9rIc/r5GUqzqLbckV20jwdPR6hNOgfk
 kGsaqVW2n+/axU3v7tS14AuD0lhTAXP4Ab6ZrlUGoMV8e8rTtlAsnsZRfWxJlNs9Ti0w
 ovCK3YBJ0VXQZUxfZpE/Cnh8wnP4TWaDE7Flepg58R1xVSYuN7nQ1G6TcYNJ8N6RcjiW 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rag06f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:34:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0AJhv132623;
        Sat, 14 Nov 2020 00:34:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34t4bs96b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:34:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0Yhs1029090;
        Sat, 14 Nov 2020 00:34:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:34:42 -0800
Date:   Fri, 13 Nov 2020 16:34:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20201114003440.GF9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-6-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=5 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:56:57PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing xattrs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/525     | 154 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/525.out |  16 +++++
>  tests/xfs/group   |   1 +
>  3 files changed, 171 insertions(+)
>  create mode 100755 tests/xfs/525
>  create mode 100644 tests/xfs/525.out
> 
> diff --git a/tests/xfs/525 b/tests/xfs/525
> new file mode 100755
> index 00000000..1d5d6e7c
> --- /dev/null
> +++ b/tests/xfs/525
> @@ -0,0 +1,154 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 525
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# Adding/removing xattrs.
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
> +. ./common/attr
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_attrs
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +attr_set()
> +{
> +	echo "* Set xattrs"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
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
> +	echo "Create xattrs"
> +
> +	attr_len=$(uuidgen | wc -c)
> +	nr_attrs=$((bsize * 20 / attr_len))
> +	for i in $(seq 1 $nr_attrs); do
> +		$SETFATTR_PROG -n "trusted.""$(uuidgen)" $testfile \

Does this test require UUIDs in the attr names?  Why wouldn't
$(printf "%037d" $i) suffice for this purpose?

Though if you insist upon using uuids, please call $UUIDGEN_PROG per
fstest custom.

> +			 >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify uquota inode's extent count"

Huh?  I thought we were testing file attrs?

> +	nextents=$(_scratch_get_iext_count $testino attr || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +attr_remove()
> +{
> +	echo "* Remove xattrs"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
> +	sync
> +
> +	echo "Create fragmented filesystem"
> +	$here/src/punch-alternating $testfile >> $seqres.full
> +	sync
> +
> +	testino=$(stat -c "%i" $testfile)
> +
> +	naextents=0
> +	last=""
> +
> +	attr_len=$(uuidgen | wc -c)
> +	nr_attrs=$((bsize / attr_len))
> +
> +	echo "Create initial xattr extents"
> +	while (( $naextents < 4 )); do
> +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> +
> +		for i in $(seq 1 $nr_attrs); do
> +			last="trusted.""$(uuidgen)"
> +			$SETFATTR_PROG -n $last $testfile
> +		done
> +
> +		_scratch_unmount >> $seqres.full
> +
> +		naextents=$(_scratch_get_iext_count $testino attr || \
> +				_fail "Unable to obtain inode fork's extent count")
> +
> +		_scratch_mount >> $seqres.full
> +	done
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Remove xattr to trigger -EFBIG"
> +	$SETFATTR_PROG -x "$last" $testfile >> $seqres.full 2>&1
> +	if [[ $? == 0 ]]; then
> +		echo "Xattr removal succeeded; Should have failed "

So at this point the user has a file for which he can't ever remove the
xattrs for fear of overflowing naextents.  The only way to clear this is
to delete the file, so shouldn't you be testing that this succeeds?

--D

> +		exit 1
> +	fi
> +}
> +
> +attr_set
> +attr_remove
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/525.out b/tests/xfs/525.out
> new file mode 100644
> index 00000000..cc40e6e2
> --- /dev/null
> +++ b/tests/xfs/525.out
> @@ -0,0 +1,16 @@
> +QA output created by 525
> +* Set xattrs
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Create xattrs
> +Verify uquota inode's extent count
> +* Remove xattrs
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Create initial xattr extents
> +Inject reduce_max_iextents error tag
> +Remove xattr to trigger -EFBIG
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 3fa38c36..bd38aff0 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -522,3 +522,4 @@
>  522 auto quick quota
>  523 auto quick realtime growfs
>  524 auto quick punch zero insert collapse
> +525 auto quick attr
> -- 
> 2.28.0
> 
