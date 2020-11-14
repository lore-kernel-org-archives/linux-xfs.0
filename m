Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7E7C55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90CC2224D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xoNKg+dX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgKNAY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:24:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNAY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:24:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0E1Wa176024;
        Sat, 14 Nov 2020 00:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xOsScRDmLuqLpTLRuhZQEqHcAMUb1dXiJjvMH616auo=;
 b=xoNKg+dXIg+oQ/eSiPTu4E5Oa8dtHUTl2EFXM56cjCUyc5ixbyPpMhIIlLUhin4AbVYO
 g3KM3zv8rA71Zy3l4nzovij+gCYbkYG+vivX+76xg5R/HikpgWsvZ071+uqVrxoEBlbJ
 I6zuvKvBp5aeefCZApNEjpD95qvkRnpXW6xFzGKTgCbtRtIjNvPkVLDSi3/lL0KArG2h
 wfcQ2zG+xR0dKiQ6OlM8IYaVOq11HdZIxLiYS0iVCvYFH9cYetVs3OmH+MtkuKE0xT0o
 tCbff6l0EetV5vM45PWsvwicpYd+NWISGuq/7tfQ9fpyr2IBaU/J6/nDIb9UZxcxCl78 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhmcr3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:24:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0AIuJ132483;
        Sat, 14 Nov 2020 00:24:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34t4bs8t5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:24:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0OLMp020341;
        Sat, 14 Nov 2020 00:24:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:24:21 -0800
Date:   Fri, 13 Nov 2020 16:24:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20201114002420.GD9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-3-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=5 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:56:54PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding a single extent while there's no possibility of
> splitting an existing mapping (limited to non-realtime files).
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/522     | 214 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/522.out |  24 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 239 insertions(+)
>  create mode 100755 tests/xfs/522
>  create mode 100644 tests/xfs/522.out
> 
> diff --git a/tests/xfs/522 b/tests/xfs/522
> new file mode 100755
> index 00000000..a54fe136
> --- /dev/null
> +++ b/tests/xfs/522
> @@ -0,0 +1,214 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 522
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding a single extent while there's no possibility of splitting an existing
> +# mapping (limited to non-realtime files).
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
> +. ./common/filter
> +. ./common/quota
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_quota
> +_require_xfs_debug
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +delalloc_to_written_extent()
> +{
> +	echo "* Delalloc to written extent conversion"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	nr_blks=$((15 * 2))
> +
> +	echo "Create fragmented file"
> +	for i in $(seq 0 2 $((nr_blks - 1))); do
> +		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1
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
> +			   _fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +falloc_unwritten_extent()
> +{
> +	echo "* Fallocate of unwritten extents"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	nr_blks=$((15 * 2))
> +
> +	echo "Fallocate fragmented file"
> +	for i in $(seq 0 2 $((nr_blks - 1))); do
> +		xfs_io -f -c "falloc $((i * bsize)) $bsize" $testfile >> $seqres.full 2>&1
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
> +			   _fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +quota_inode_extend()
> +{
> +	echo "* Extend quota inodes"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount -o uquota >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)
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
> +	nr_blks=20
> +
> +	# This is a rough calculation; It doesn't take block headers into
> +	# consideration.
> +	# gdb -batch vmlinux -ex 'print sizeof(struct xfs_disk_dquot)'
> +	# $1 = 104
> +	nr_quotas_per_block=$((bsize / 104))

That's sizeof(xfs_dqblk_t) you want, and it's 136 bytes long.

> +	nr_quotas=$((nr_quotas_per_block * nr_blks))
> +
> +	echo "Extend uquota file"
> +	for i in $(seq 0 $nr_quotas); do

You only have to initialize the first dquot in a dquot file block in
order to allocate the whole block, so you could speed this up with
"seq 0 $nr_quotas_per_block $nr_quotas".

> +		chown $i $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify uquota inode's extent count"
> +	uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
> +	uquotino=${uquotino##uquotino = }
> +
> +	nextents=$(_scratch_get_iext_count $uquotino data || \
> +			   _fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +directio_write()
> +{
> +	echo "* Directio write"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	nr_blks=$((15 * 2))
> +
> +	echo "Create fragmented file via directio writes"
> +	for i in $(seq 0 2 $((nr_blks - 1))); do
> +		xfs_io -d -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1

$XFS_IO_PROG -d -f -s -c "pwrite ..." $testfile

"-s" is an undocumented flag that makes the writes synchronous.

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

$XFS_IO_PROG -c 'stat' $testfile | grep nextents ?

> +			   _fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +}
> +
> +delalloc_to_written_extent
> +falloc_unwritten_extent
> +quota_inode_extend
> +directio_write

I wonder if these should be separate tests, since they each format the
scratch fs?  Or could you format the scratch fs once and test four
different files?

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/522.out b/tests/xfs/522.out
> new file mode 100644
> index 00000000..98791aae
> --- /dev/null
> +++ b/tests/xfs/522.out
> @@ -0,0 +1,24 @@
> +QA output created by 522
> +* Delalloc to written extent conversion
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +Create fragmented file
> +Verify $testfile's extent count
> +* Fallocate of unwritten extents
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +Fallocate fragmented file
> +Verify $testfile's extent count
> +* Extend quota inodes
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Extend uquota file
> +Verify uquota inode's extent count
> +* Directio write
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +Create fragmented file via directio writes
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b89c0a4e..1831f0b5 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -519,3 +519,4 @@
>  519 auto quick reflink
>  520 auto quick reflink
>  521 auto quick realtime growfs
> +522 auto quick quota
> -- 
> 2.28.0
> 
