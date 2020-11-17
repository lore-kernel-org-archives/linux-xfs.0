Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3541C63697
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9818522240
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPnaUXTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgKQOuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbgKQOuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:50:20 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DDDC0617A6;
        Tue, 17 Nov 2020 06:50:20 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q10so17449695pfn.0;
        Tue, 17 Nov 2020 06:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E2S0mKa8ktexPwdVbg9Dk9E+QnhZkHe7cvXbICVNvIo=;
        b=kPnaUXTouENZ5OoGMinyYpIgMbXS+7+c0hZhjEE9kM6H/UMHno8bPlV4BZjTDnwjul
         VyZPMNPOlX9MSAL39YW3vYy5oimlzLvt0WDXnrVt5K5CGWCV11WE6VOWpTMBf1BvpEdG
         KyCNjBdC5t3b3RMlJ6oxqZNzrSXB9M5aiXq7XMMLG57aKzrmrWYagjBHJokTM/ZvNUcB
         vSmn7xWjomtDhIDMMIeCvCFv7wfz7jUFc40mdC1aWwjx8mWdUtUxTXljIHUKOn/Ycid0
         3K79Xd8K4H1rvK5IkH9D5/MmMh8OnpiKPomZKaquA6Ag0hRYecH+T1a4g+TdOjR6F2+/
         IUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E2S0mKa8ktexPwdVbg9Dk9E+QnhZkHe7cvXbICVNvIo=;
        b=Ap7/t+wdPT/7i57GLQRxOSpYhWLLBLDnkB+lDODlqRbS4WI8YETTKZmaETVRHlpxAV
         Z7Xz4Mw4sTZ7/1rNciTnkXiAfL7FG/RtfZQ4ZgBWDYnMwpGfGJVsiLX43DzliA8k7Dfq
         J2fYezQQ7bQhaMO0IxnQEPZ+VHVuIS5wYqjdGfqN456O54YD9fqJ56oEZIyCaORLE5sN
         SRAhzVwY/013EfE0tiUoQGlMEQ4mrO3+99GH5dELzDi1oJdMldqSlYipJ6Q7LBAHIRCS
         OMwp4/Os5yRRrNjJgzWm4AO2IVGuSxAXlC2a6HKFQf4IkRkCO/bBE4dZzQL4e4NKAA4O
         L93g==
X-Gm-Message-State: AOAM530WknyxOCB4Gd+gPMtFBQ9zhBYSw+3OdBtzZM5CGzCEqc6nIZUT
        uZYDIQp7drgu0neQCN3bwqc=
X-Google-Smtp-Source: ABdhPJzYue9JM0thnL4eg4T+Q9AaT0X8ETgahm/XP9oFAVSAKxqv0R63Kv2Pj8ZgC7KWxMDdZ5D2gw==
X-Received: by 2002:aa7:8586:0:b029:18c:3aa6:b8bb with SMTP id w6-20020aa785860000b029018c3aa6b8bbmr18455611pfn.39.1605624620049;
        Tue, 17 Nov 2020 06:50:20 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id s15sm13038636pfd.33.2020.11.17.06.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:50:19 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: Check for extent overflow when adding/removing dir entries
Date:   Tue, 17 Nov 2020 20:20:16 +0530
Message-ID: <2288604.9QACzlcG6Y@garuda>
In-Reply-To: <20201114003754.GG9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-7-chandanrlinux@gmail.com> <20201114003754.GG9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 6:07:54 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:56:58PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when adding/removing directory entries.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/526     | 360 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/526.out |  47 ++++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 408 insertions(+)
> >  create mode 100755 tests/xfs/526
> >  create mode 100644 tests/xfs/526.out
> > 
> > diff --git a/tests/xfs/526 b/tests/xfs/526
> > new file mode 100755
> > index 00000000..39cfbcf8
> > --- /dev/null
> > +++ b/tests/xfs/526
> > @@ -0,0 +1,360 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 526
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# adding/removing directory entries.
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_debug
> > +_require_test_program "punch-alternating"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +
> > +_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> > +. $tmp.mkfs
> > +
> > +dir_entry_create()
> > +{
> > +	echo "* Create directory entries"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> 
> Same questions as I've had for all the other tests -- why is it critical to
> reformat between each test?  Why is it necessary to encode uuids in the
> attr/dir names?

I will replace uuids with output from printf.

However w.r.t not reformatting the filesystem between each test, we need to
look into one issue that occurs when executing either of dir_entry_rename_src
and dir_entry_remove tests. Please see dir_entry_remove below for an
explanation.

> 
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Inject bmap_alloc_minlen_extent error tag"
> > +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +	echo "Create directory entries"
> > +	dent_len=$(uuidgen | wc -c)
> 
> Also, it'll explode the directories faster if you use maximal length
> names (255) instead of uuids (37).
> 
> The same applies to the xattr tests in the previous patch.

Thanks for the suggestion. I will implement it in the next version of the
patchset.

> 
> > +	nr_dents=$((dbsize * 20 / dent_len))
> > +	for i in $(seq 1 $nr_dents); do
> > +		touch $SCRATCH_MNT/$(uuidgen) >> $seqres.full 2>&1 || break
> > +	done
> > +
> > +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify directory's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $dirino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +dir_entry_rename_dst()
> > +{
> > +	echo "* Rename: Populate destination directory"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Inject bmap_alloc_minlen_extent error tag"
> > +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +	dstdir=$SCRATCH_MNT/dstdir
> > +	mkdir $dstdir
> > +
> > +	dent_len=$(uuidgen | wc -c)
> > +	nr_dents=$((dirbsize * 20 / dent_len))
> > +
> > +	echo "Populate \$dstdir by mv-ing new directory entries"
> > +	for i in $(seq 1 $nr_dents); do
> > +		file=${SCRATCH_MNT}/$(uuidgen)
> > +		touch $file || break
> > +		mv $file $dstdir >> $seqres.full 2>&1 || break
> > +	done
> > +
> > +	dirino=$(stat -c "%i" $dstdir)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$dstdir's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $dirino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +dir_entry_rename_src()
> > +{
> > +	echo "* Rename: Populate source directory and mv one entry to destination directory"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	srcdir=${SCRATCH_MNT}/srcdir
> > +	dstdir=${SCRATCH_MNT}/dstdir
> > +
> > +	mkdir $srcdir $dstdir
> > +
> > +	dirino=$(stat -c "%i" $srcdir)
> > +
> > +	dent_len=$(uuidgen | wc -c)
> > +	nr_dents=$((dirbsize / dent_len))
> > +	nextents=0
> > +	last=""
> > +
> > +	echo "Populate \$srcdir with atleast 4 extents"
> > +	while (( $nextents < 4 )); do
> > +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +		for i in $(seq 1 $nr_dents); do
> > +			last=${srcdir}/$(uuidgen)
> > +			touch $last || break
> > +		done
> > +
> > +		_scratch_unmount >> $seqres.full
> > +
> > +		nextents=$(_scratch_get_iext_count $dirino data || \
> > +				_fail "Unable to obtain inode fork's extent count")
> > +
> > +		_scratch_mount >> $seqres.full
> > +	done
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Move an entry from \$srcdir to trigger -EFBIG"
> > +	mv $last $dstdir >> $seqres.full 2>&1
> > +	if [[ $? == 0 ]]; then
> > +		echo "Moving from \$srcdir to \$dstdir succeeded; Should have failed"
> > +	fi
> > +
> > +	_scratch_unmount >> $seqres.full
> > +}
> > +
> > +dir_entry_create_hard_links()
> > +{
> > +	echo "* Create multiple hard links to a single file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Inject bmap_alloc_minlen_extent error tag"
> > +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +	dent_len=$(uuidgen | wc -c)
> > +	nr_dents=$((dirbsize * 20 / dent_len))
> > +
> > +	echo "Create multiple hardlinks"
> > +	for i in $(seq 1 $nr_dents); do
> > +		ln $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break
> > +	done
> > +
> > +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify directory's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $dirino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +dir_entry_create_symlinks()
> > +{
> > +	echo "* Create multiple symbolic links to a single file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Inject bmap_alloc_minlen_extent error tag"
> > +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +	dent_len=$(uuidgen | wc -c)
> > +	nr_dents=$((dirbsize * 20 / dent_len))
> > +
> > +	echo "Create multiple symbolic links"
> > +	for i in $(seq 1 $nr_dents); do
> > +		ln -s $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break;
> > +	done
> > +
> > +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify directory's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $dirino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +dir_entry_remove()
> > +{
> > +	echo "* Populate a directory and remove one entry"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	dirino=$(stat -c "%i" $SCRATCH_MNT)
> > +
> > +	dent_len=$(uuidgen | wc -c)
> > +	nr_dents=$((dirbsize / dent_len))
> > +	nextents=0
> > +	last=""
> > +
> > +	echo "Populate directory with atleast 4 extents"
> > +	while (( $nextents < 4 )); do
> > +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +		for i in $(seq 1 $nr_dents); do
> > +			last=${SCRATCH_MNT}/$(uuidgen)
> > +			touch $last || break
> > +		done
> > +
> > +		_scratch_unmount >> $seqres.full
> > +
> > +		nextents=$(_scratch_get_iext_count $dirino data || \
> > +				_fail "Unable to obtain inode fork's extent count")
> > +
> > +		_scratch_mount >> $seqres.full
> > +	done
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Remove an entry from directory to trigger -EFBIG"
> > +	rm $last >> $seqres.full 2>&1
> > +	if [[ $? == 0 ]]; then
> > +		echo "Removing file succeeded; Should have failed"
> > +	fi
> > +
> > +	_scratch_unmount >> $seqres.full
> > +}

In the above function we create a directory with atleast 4 extents and this is
executed without the pseudo max extent limits enabled. Later the function
injects reduce_max_iextents error tag and since 4 + (XFS_DA_NODE_MAXDEPTH + 1
+ 1) = 4 + (5 + 1 + 1) = 11 > 10 (pseudo max limit) the directory entry remove
operation execute later would fail. This also would mean that the parent
directory cannot be deleted with the error tag enabled. This scenario would
not occur in production work load since the extent count limit is always
enabled as against enabling it at a later stage as is being done in this test.

This is different from the attr_remove() test from patch 5 where it is
possible to remove the file even though the corresponding xattr cannot be
removed.

Hence, I could either unmount and mount the filesystem so that the parent
directory can be removed or I could create the filesystem anew.

> > +
> > +# Filesystems with directory block size greater than one FSB will not be tested,
> > +# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
> > +# count) = 14" is greater than the pseudo max extent count limit of 10.
> > +# Extending the pseudo max limit won't help either.  Consider the case where 1
> > +# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
> > +# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
> > +if (( $dbsize != $dirbsize )); then
> > +	_notrun "FSB size ($dbsize) and directory block size ($dirbsize) do not match"
> 
> Heh, I had wondered about that.  Good that you caught this here!
> 
> --D
> 
> > +fi
> > +
> > +dir_entry_create
> > +dir_entry_rename_dst
> > +dir_entry_rename_src
> > +dir_entry_create_hard_links
> > +dir_entry_create_symlinks
> > +dir_entry_remove
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/526.out b/tests/xfs/526.out
> > new file mode 100644
> > index 00000000..21f77cd8
> > --- /dev/null
> > +++ b/tests/xfs/526.out
> > @@ -0,0 +1,47 @@
> > +QA output created by 526
> > +* Create directory entries
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Create directory entries
> > +Verify directory's extent count
> > +* Rename: Populate destination directory
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Populate $dstdir by mv-ing new directory entries
> > +Verify $dstdir's extent count
> > +* Rename: Populate source directory and mv one entry to destination directory
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Populate $srcdir with atleast 4 extents
> > +Inject reduce_max_iextents error tag
> > +Move an entry from $srcdir to trigger -EFBIG
> > +* Create multiple hard links to a single file
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Create multiple hardlinks
> > +Verify directory's extent count
> > +* Create multiple symbolic links to a single file
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Create multiple symbolic links
> > +Verify directory's extent count
> > +* Populate a directory and remove one entry
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Populate directory with atleast 4 extents
> > +Inject reduce_max_iextents error tag
> > +Remove an entry from directory to trigger -EFBIG
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index bd38aff0..d089797b 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -523,3 +523,4 @@
> >  523 auto quick realtime growfs
> >  524 auto quick punch zero insert collapse
> >  525 auto quick attr
> > +526 auto quick dir hardlink symlink
> 


-- 
chandan



