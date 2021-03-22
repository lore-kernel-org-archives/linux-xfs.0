Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41CDC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 17:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2E96197F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 17:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCVR5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhCVR4x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 13:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 094BD6196E;
        Mon, 22 Mar 2021 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616435813;
        bh=tjvSPrg08ec2wbCrKBieeI1VLAYfvCBICZo2EnttIf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j9740ByHv2QOQioL4OZEnsO/iBG2WWeLi9rvi9zIHuVjQQEwoAvci8hy0zMVE0vZX
         zh8iQ9qtIK0zFXEeWnAySk0ZOeDMlNCKftUYaN9Lk4MZizoHZjjRwJxVvX6mIcIlsd
         pdH+WDOSI+HT5YwcqSds8T9Xb11nlMroIrCZkdnmQVRw2wvlxR+mqrH7gi5l4l22fC
         EOOycTRzvRMXi7MbcKlwAbDJlZaKBc5l/a294Rgi/bCdTpsJhahgURXhMHFzOl7WpT
         h7tZ+4hKYtTlbaRt9w0LLcztypjk9VvOM8tp0kjE2XrJx8PONSpqttNvOmtztyJf59
         zfKmXU9QARKYQ==
Date:   Mon, 22 Mar 2021 10:56:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing
 realtime bitmap/summary inodes
Message-ID: <20210322175652.GG1670408@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309050124.23797-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:31:16AM +0530, Chandan Babu R wrote:
> Verify that XFS does not cause realtime bitmap/summary inode fork's
> extent count to overflow when growing the realtime volume associated
> with a filesystem.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Soo... I discovered that this test doesn't pass with multiblock
directories:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 alder-mtr00 5.12.0-rc4-xfsx #rc4 SMP PREEMPT Mon Mar 22 10:03:45 PDT 2021
MKFS_OPTIONS  -- -f -b size=1024, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

xfs/529 - output mismatch (see /var/tmp/fstests/xfs/529.out.bad)
    --- tests/xfs/529.out       2021-03-21 11:44:09.383407733 -0700
    +++ /var/tmp/fstests/xfs/529.out.bad        2021-03-22 10:36:34.000348426 -0700
    @@ -4,12 +4,21 @@
     Inject reduce_max_iextents error tag
     Create fragmented file
     Verify $testfile's extent count
    +/opt/testfile: No such file or directory
    +/tmp/fstests/tests/xfs/529: line 72: ((: > 10 : syntax error: operand expected (error token is "> 10 ")
    +rm: cannot remove '/opt/testfile': No such file or directory
     * Fallocate unwritten extents
    ...
    (Run 'diff -u /tmp/fstests/tests/xfs/529.out /var/tmp/fstests/xfs/529.out.bad'  to see the entire diff)
Ran: xfs/529
Failures: xfs/529
Failed 1 of 1 tests

Test xfs/529 FAILED with code 1 and bad golden output:
--- /tmp/fstests/tests/xfs/529.out      2021-03-21 11:44:09.383407733 -0700
+++ /var/tmp/fstests/xfs/529.out.bad    2021-03-22 10:36:34.000348426 -0700
@@ -4,12 +4,21 @@
 Inject reduce_max_iextents error tag
 Create fragmented file
 Verify $testfile's extent count
+/opt/testfile: No such file or directory
+/tmp/fstests/tests/xfs/529: line 72: ((: > 10 : syntax error: operand expected (error token is "> 10 ")
+rm: cannot remove '/opt/testfile': No such file or directory
 * Fallocate unwritten extents
 Fallocate fragmented file
 Verify $testfile's extent count
+/opt/testfile: No such file or directory
+/tmp/fstests/tests/xfs/529: line 91: ((: > 10 : syntax error: operand expected (error token is "> 10 ")
+rm: cannot remove '/opt/testfile': No such file or directory
 * Directio write
 Create fragmented file via directio writes
 Verify $testfile's extent count
+/opt/testfile: No such file or directory
+/tmp/fstests/tests/xfs/529: line 110: ((: > 10 : syntax error: operand expected (error token is "> 10 ")
+rm: cannot remove '/opt/testfile': No such file or directory
 * Extend quota inodes
 Disable reduce_max_iextents error tag
 Consume free space

The test appears to fail because we cannot create even a single file in
the root directory.  Looking at xfs_create, I see:

	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
			XFS_IEXT_DIR_MANIP_CNT(mp));
	if (error)
		goto out_trans_cancel;

XFS_IEXT_DIR_MANIP_CNT is defined as:

	#define XFS_IEXT_DIR_MANIP_CNT(mp) \
		((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)

If one formats a filesystem with 1k blocks, the result will be a
filesystem with 4k directory blocks:

# mkfs.xfs -b size=1024 /dev/sdf -Nf
meta-data=/dev/sdf               isize=512    agcount=4, agsize=5192704 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1
         =                       metadir=0   
data     =                       bsize=1024   blocks=20770816, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=1024   blocks=10240, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Note "data bsize" is 1024, and "naming bsize" is 4096.

In the kernel, we set m_dir_geo->fsbcount = "naming bsize" /
"data bsize", or 4 in this case.  Since XFS_DA_NODE_MAXDEPTH is always
5, this macro expands to:

	(5 + 1 + 1) * (4) = 28

The reason for the test failure I think is because of this code in
xfs_iext_count_may_overflow, which is called from xfs_create on the
parent directory:

	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
		max_exts = 10;

	nr_exts = ifp->if_nextents + nr_to_add;
	if (nr_exts < ifp->if_nextents || nr_exts > max_ext)
		return -EFBIG

The second part of the if statement becomes (28 > 10) which is trivially
true, so we return -EFBIG for all attempts to create a file in a
directory.  xfs/529, in turn, cannot create $testfile because nothing
can create a file in $SCRATCH_MNT, and the test goes off the rails.

I think this can be trivially solved by changing this (and the other
tests) to ensure that the error injection is only set when we're running
a command to check if we get EFBIG.  In other words, this code in
xfs/529:

	rm $testfile

	echo "* Fallocate unwritten extents"

	echo "Fallocate fragmented file"
	for i in $(seq 0 2 $((nr_blks - 1))); do
		$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
		       >> $seqres.full 2>&1
		[[ $? != 0 ]] && break
	done

Should become:

	rm -f $testfile
	touch $testfile

	echo "* Fallocate unwritten extents"

	echo "Fallocate fragmented file"
	_scratch_inject_error reduce_max_iextents 1
	for i in $(seq 0 2 $((nr_blks - 1))); do
		$XFS_IO_PROG -c "falloc $((i * bsize)) $bsize" $testfile \
		       >> $seqres.full 2>&1
		[[ $? != 0 ]] && break
	done
	_scratch_inject_error reduce_max_iextents 0

With that patched up, xfs/529 passes on 1k block filesystems.  I suspect
the other tests in this series (xfs/531, 532, 534, and 535) are going to
need similar patching.

--D

> ---
>  tests/xfs/529     | 124 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/529.out |  11 ++++
>  tests/xfs/group   |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/xfs/529
>  create mode 100644 tests/xfs/529.out
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> new file mode 100755
> index 00000000..dd7019f5
> --- /dev/null
> +++ b/tests/xfs/529
> @@ -0,0 +1,124 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 529
> +#
> +# Verify that XFS does not cause bitmap/summary inode fork's extent count to
> +# overflow when growing an the realtime volume of the filesystem.
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
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +# Note that we don't _require_realtime because we synthesize a rt volume
> +# below.
> +_require_test
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_scratch_nocheck
> +
> +echo "* Test extending rt inodes"
> +
> +_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +echo "Create fake rt volume"
> +nr_bitmap_blks=25
> +nr_bits=$((nr_bitmap_blks * dbsize * 8))
> +
> +# Realtime extent size has to be atleast 4k in size.
> +if (( $dbsize < 4096 )); then
> +	rtextsz=4096
> +else
> +	rtextsz=$dbsize
> +fi
> +
> +rtdevsz=$((nr_bits * rtextsz))
> +truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +echo "Format and mount rt volume"
> +
> +export USE_EXTERNAL=yes
> +export SCRATCH_RTDEV=$rtdev
> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> +	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
> +_try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Grow realtime volume"
> +$XFS_GROWFS_PROG -r $SCRATCH_MNT >> $seqres.full 2>&1
> +if [[ $? == 0 ]]; then
> +	echo "Growfs succeeded; should have failed."
> +	exit 1
> +fi
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify rbmino's and rsumino's extent count"
> +for rtino in rbmino rsumino; do
> +	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
> +	echo "$rtino = $ino" >> $seqres.full
> +
> +	nextents=$(_scratch_get_iext_count $ino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +done
> +
> +echo "Check filesystem"
> +_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +losetup -d $rtdev
> +rm -f $TEST_DIR/$seq.rtvol
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> new file mode 100644
> index 00000000..4ee113a4
> --- /dev/null
> +++ b/tests/xfs/529.out
> @@ -0,0 +1,11 @@
> +QA output created by 529
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
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 2356c4a9..5dff7acb 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>  526 auto quick mkfs
>  527 auto quick quota
>  528 auto quick quota
> +529 auto quick realtime growfs
> -- 
> 2.29.2
> 
