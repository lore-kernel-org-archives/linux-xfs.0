Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7D4C63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7257122267
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OfxCPMns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKNAiC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:38:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNAiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:38:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0XxDY033564;
        Sat, 14 Nov 2020 00:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a0WLGSbfzFGN7QeNoJOAFK2yjvF2Ww7YOvIDSMbITYs=;
 b=OfxCPMnsJAttPL+K2B9f8iXdPRD2wWKhRM92GCNDgeXxllqW+stHz8JvOzr/HU8le4Jw
 b2Oe2zgz/L8CvTSo2Kt3afWlJ9qwGI3JNxv/JlD44WfzBmTXaNSkvI2MDQ7i03FlLbL4
 NBP0svWDlEyFxts9gOv9beKMHbwT+V3z1nVaqar5bV67a1HAmJmkO42CITy9vjQasHVc
 x8CHoiVuvjHDEjL+DIqHVY+qqp2kLJ2UTglfwCaNqhLKLPGF2gTis1fEqWCB78NQuCBk
 /N6dSIRdDWuLxVdla7t9Tff3ZMyO7jrz2Ay5jgaZjLYwo9vT4ouoggMZXxl4MzdJ5QPQ +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhmcrmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:37:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0ZZSZ107708;
        Sat, 14 Nov 2020 00:37:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34p55u03ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:37:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE0buXu009396;
        Sat, 14 Nov 2020 00:37:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:37:55 -0800
Date:   Fri, 13 Nov 2020 16:37:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20201114003754.GG9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-7-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=5 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:56:58PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing directory entries.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/526     | 360 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/526.out |  47 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 408 insertions(+)
>  create mode 100755 tests/xfs/526
>  create mode 100644 tests/xfs/526.out
> 
> diff --git a/tests/xfs/526 b/tests/xfs/526
> new file mode 100755
> index 00000000..39cfbcf8
> --- /dev/null
> +++ b/tests/xfs/526
> @@ -0,0 +1,360 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 526
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding/removing directory entries.
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
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +dir_entry_create()
> +{
> +	echo "* Create directory entries"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full

Same questions as I've had for all the other tests -- why is it critical to
reformat between each test?  Why is it necessary to encode uuids in the
attr/dir names?

> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
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
> +	echo "Create directory entries"
> +	dent_len=$(uuidgen | wc -c)

Also, it'll explode the directories faster if you use maximal length
names (255) instead of uuids (37).

The same applies to the xattr tests in the previous patch.

> +	nr_dents=$((dbsize * 20 / dent_len))
> +	for i in $(seq 1 $nr_dents); do
> +		touch $SCRATCH_MNT/$(uuidgen) >> $seqres.full 2>&1 || break
> +	done
> +
> +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify directory's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $dirino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +dir_entry_rename_dst()
> +{
> +	echo "* Rename: Populate destination directory"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
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
> +	dstdir=$SCRATCH_MNT/dstdir
> +	mkdir $dstdir
> +
> +	dent_len=$(uuidgen | wc -c)
> +	nr_dents=$((dirbsize * 20 / dent_len))
> +
> +	echo "Populate \$dstdir by mv-ing new directory entries"
> +	for i in $(seq 1 $nr_dents); do
> +		file=${SCRATCH_MNT}/$(uuidgen)
> +		touch $file || break
> +		mv $file $dstdir >> $seqres.full 2>&1 || break
> +	done
> +
> +	dirino=$(stat -c "%i" $dstdir)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify \$dstdir's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $dirino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +dir_entry_rename_src()
> +{
> +	echo "* Rename: Populate source directory and mv one entry to destination directory"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> +	sync
> +
> +	echo "Create fragmented filesystem"
> +	$here/src/punch-alternating $testfile >> $seqres.full
> +	sync
> +
> +	srcdir=${SCRATCH_MNT}/srcdir
> +	dstdir=${SCRATCH_MNT}/dstdir
> +
> +	mkdir $srcdir $dstdir
> +
> +	dirino=$(stat -c "%i" $srcdir)
> +
> +	dent_len=$(uuidgen | wc -c)
> +	nr_dents=$((dirbsize / dent_len))
> +	nextents=0
> +	last=""
> +
> +	echo "Populate \$srcdir with atleast 4 extents"
> +	while (( $nextents < 4 )); do
> +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> +
> +		for i in $(seq 1 $nr_dents); do
> +			last=${srcdir}/$(uuidgen)
> +			touch $last || break
> +		done
> +
> +		_scratch_unmount >> $seqres.full
> +
> +		nextents=$(_scratch_get_iext_count $dirino data || \
> +				_fail "Unable to obtain inode fork's extent count")
> +
> +		_scratch_mount >> $seqres.full
> +	done
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Move an entry from \$srcdir to trigger -EFBIG"
> +	mv $last $dstdir >> $seqres.full 2>&1
> +	if [[ $? == 0 ]]; then
> +		echo "Moving from \$srcdir to \$dstdir succeeded; Should have failed"
> +	fi
> +
> +	_scratch_unmount >> $seqres.full
> +}
> +
> +dir_entry_create_hard_links()
> +{
> +	echo "* Create multiple hard links to a single file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
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
> +	dent_len=$(uuidgen | wc -c)
> +	nr_dents=$((dirbsize * 20 / dent_len))
> +
> +	echo "Create multiple hardlinks"
> +	for i in $(seq 1 $nr_dents); do
> +		ln $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break
> +	done
> +
> +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify directory's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $dirino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +dir_entry_create_symlinks()
> +{
> +	echo "* Create multiple symbolic links to a single file"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
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
> +	dent_len=$(uuidgen | wc -c)
> +	nr_dents=$((dirbsize * 20 / dent_len))
> +
> +	echo "Create multiple symbolic links"
> +	for i in $(seq 1 $nr_dents); do
> +		ln -s $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break;
> +	done
> +
> +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	echo "Verify directory's extent count"
> +
> +	nextents=$(_scratch_get_iext_count $dirino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +	fi
> +}
> +
> +dir_entry_remove()
> +{
> +	echo "* Populate a directory and remove one entry"
> +
> +	echo "Format and mount fs"
> +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	echo "Consume free space"
> +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> +	sync
> +
> +	echo "Create fragmented filesystem"
> +	$here/src/punch-alternating $testfile >> $seqres.full
> +	sync
> +
> +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> +
> +	dent_len=$(uuidgen | wc -c)
> +	nr_dents=$((dirbsize / dent_len))
> +	nextents=0
> +	last=""
> +
> +	echo "Populate directory with atleast 4 extents"
> +	while (( $nextents < 4 )); do
> +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> +
> +		for i in $(seq 1 $nr_dents); do
> +			last=${SCRATCH_MNT}/$(uuidgen)
> +			touch $last || break
> +		done
> +
> +		_scratch_unmount >> $seqres.full
> +
> +		nextents=$(_scratch_get_iext_count $dirino data || \
> +				_fail "Unable to obtain inode fork's extent count")
> +
> +		_scratch_mount >> $seqres.full
> +	done
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +	echo "Remove an entry from directory to trigger -EFBIG"
> +	rm $last >> $seqres.full 2>&1
> +	if [[ $? == 0 ]]; then
> +		echo "Removing file succeeded; Should have failed"
> +	fi
> +
> +	_scratch_unmount >> $seqres.full
> +}
> +
> +# Filesystems with directory block size greater than one FSB will not be tested,
> +# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
> +# count) = 14" is greater than the pseudo max extent count limit of 10.
> +# Extending the pseudo max limit won't help either.  Consider the case where 1
> +# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
> +# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
> +if (( $dbsize != $dirbsize )); then
> +	_notrun "FSB size ($dbsize) and directory block size ($dirbsize) do not match"

Heh, I had wondered about that.  Good that you caught this here!

--D

> +fi
> +
> +dir_entry_create
> +dir_entry_rename_dst
> +dir_entry_rename_src
> +dir_entry_create_hard_links
> +dir_entry_create_symlinks
> +dir_entry_remove
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/526.out b/tests/xfs/526.out
> new file mode 100644
> index 00000000..21f77cd8
> --- /dev/null
> +++ b/tests/xfs/526.out
> @@ -0,0 +1,47 @@
> +QA output created by 526
> +* Create directory entries
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Create directory entries
> +Verify directory's extent count
> +* Rename: Populate destination directory
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Populate $dstdir by mv-ing new directory entries
> +Verify $dstdir's extent count
> +* Rename: Populate source directory and mv one entry to destination directory
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Populate $srcdir with atleast 4 extents
> +Inject reduce_max_iextents error tag
> +Move an entry from $srcdir to trigger -EFBIG
> +* Create multiple hard links to a single file
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Create multiple hardlinks
> +Verify directory's extent count
> +* Create multiple symbolic links to a single file
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Create multiple symbolic links
> +Verify directory's extent count
> +* Populate a directory and remove one entry
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Populate directory with atleast 4 extents
> +Inject reduce_max_iextents error tag
> +Remove an entry from directory to trigger -EFBIG
> diff --git a/tests/xfs/group b/tests/xfs/group
> index bd38aff0..d089797b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -523,3 +523,4 @@
>  523 auto quick realtime growfs
>  524 auto quick punch zero insert collapse
>  525 auto quick attr
> +526 auto quick dir hardlink symlink
> -- 
> 2.28.0
> 
