Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06920C5519F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2AC9221E2
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sPqW5Se0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgKQOMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgKQOMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:12:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E9AC0613CF;
        Tue, 17 Nov 2020 06:12:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d3so10294276plo.4;
        Tue, 17 Nov 2020 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MH8fSRL5bJGRjidI/eAD+b9im03gd+V8l/nYDMqI3Xg=;
        b=sPqW5Se0Yh2cjZmIJnXpnOjlE6JR4n3L55kZUitYPgYlUUtKCLqVwc7N1PsfT3DxQy
         M5cMmgCl0tDs8zHaNr/PbqSGrBLdBVxl92EU1zp1BOME7PO2t+/4xtVoXtoOxe0ukdKV
         5u+ZKL6XYj21bBnSbMREDYnB2x1zUWvQq13C4NE368wGdF7VTfrReFEXqRxdnK5vY7bR
         kkzz3AqGfEz68Or6tnHEhWAiO19S7eGTXI/S08eiKydNuuGTSb9FO5YvBH7v3hbSPgmB
         BkJK/9CJMSYRnPHCbKGZL0NPstXBL4DN9DAzZaGv82VFNPybyDxsihj5cMkf1DcEErGW
         FULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MH8fSRL5bJGRjidI/eAD+b9im03gd+V8l/nYDMqI3Xg=;
        b=B9ZC+cm/oy4n+QGjbk+CQgC4yz9Gh4X1HmuNQ0AM9HDR2d/Pd5X3+nzChaB/WoImVY
         IJLWv+G56o/7qK5MinYQ8ZTtpYwQ914OzUG8yUAPizo7svn1jjNaTQ6d3DmKcJpnJHAQ
         Sii1bMSoQJsttFHVTvUu1N6DJV1HLeKZG0FmfcwIw3DdoK77npRh1R9qoySWHn761vGV
         gxanXPSZxrL+++RXNd8ROxhl9ozqB+8m15eW4OvK4Fe+91KcQI9JwA9zJZRngBfC1r9l
         qpkvQitsxtm9aDKcjlrbK2g6yRSyCXLb9MueDZ7//TFZoSPxU7qkCj1rIVS1rDg7IoNB
         MKqg==
X-Gm-Message-State: AOAM532ki6xCKRImtIE1F+dDE8p4xb4Q76pPU5Qli1ctGrYg14sD0Atg
        dtR5mzDG85o1CByx5FYtjIC0qRQ48Is=
X-Google-Smtp-Source: ABdhPJxZIwbE3MLb0wICCGsKdhnGtW/UmlOIORNXVhypbtoqZXZLrVhSp4FVlnSNtNsy7IolbWUg5g==
X-Received: by 2002:a17:90a:7341:: with SMTP id j1mr4615112pjs.78.1605622369205;
        Tue, 17 Nov 2020 06:12:49 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id t21sm3150862pjr.42.2020.11.17.06.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:12:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Tue, 17 Nov 2020 19:42:45 +0530
Message-ID: <3700185.tfMkUDfmLI@garuda>
In-Reply-To: <20201114002420.GD9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-3-chandanrlinux@gmail.com> <20201114002420.GD9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 5:54:20 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:56:54PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when adding a single extent while there's no possibility of
> > splitting an existing mapping (limited to non-realtime files).
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/522     | 214 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/522.out |  24 ++++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 239 insertions(+)
> >  create mode 100755 tests/xfs/522
> >  create mode 100644 tests/xfs/522.out
> > 
> > diff --git a/tests/xfs/522 b/tests/xfs/522
> > new file mode 100755
> > index 00000000..a54fe136
> > --- /dev/null
> > +++ b/tests/xfs/522
> > @@ -0,0 +1,214 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 522
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# adding a single extent while there's no possibility of splitting an existing
> > +# mapping (limited to non-realtime files).
> > +
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
> > +. ./common/quota
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_quota
> > +_require_xfs_debug
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +
> > +delalloc_to_written_extent()
> > +{
> > +	echo "* Delalloc to written extent conversion"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	nr_blks=$((15 * 2))
> > +
> > +	echo "Create fragmented file"
> > +	for i in $(seq 0 2 $((nr_blks - 1))); do
> > +		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> > +			   _fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +falloc_unwritten_extent()
> > +{
> > +	echo "* Fallocate of unwritten extents"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	nr_blks=$((15 * 2))
> > +
> > +	echo "Fallocate fragmented file"
> > +	for i in $(seq 0 2 $((nr_blks - 1))); do
> > +		xfs_io -f -c "falloc $((i * bsize)) $bsize" $testfile >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> > +			   _fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +quota_inode_extend()
> > +{
> > +	echo "* Extend quota inodes"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount -o uquota >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
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
> > +	nr_blks=20
> > +
> > +	# This is a rough calculation; It doesn't take block headers into
> > +	# consideration.
> > +	# gdb -batch vmlinux -ex 'print sizeof(struct xfs_disk_dquot)'
> > +	# $1 = 104
> > +	nr_quotas_per_block=$((bsize / 104))
> 
> That's sizeof(xfs_dqblk_t) you want, and it's 136 bytes long.

Ah ok. I had missed that. Thanks for pointing that out.

> 
> > +	nr_quotas=$((nr_quotas_per_block * nr_blks))
> > +
> > +	echo "Extend uquota file"
> > +	for i in $(seq 0 $nr_quotas); do
> 
> You only have to initialize the first dquot in a dquot file block in
> order to allocate the whole block, so you could speed this up with
> "seq 0 $nr_quotas_per_block $nr_quotas".

Ok. Thanks for the suggestion.

> 
> > +		chown $i $testfile >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify uquota inode's extent count"
> > +	uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
> > +	uquotino=${uquotino##uquotino = }
> > +
> > +	nextents=$(_scratch_get_iext_count $uquotino data || \
> > +			   _fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +directio_write()
> > +{
> > +	echo "* Directio write"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	nr_blks=$((15 * 2))
> > +
> > +	echo "Create fragmented file via directio writes"
> > +	for i in $(seq 0 2 $((nr_blks - 1))); do
> > +		xfs_io -d -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1
> 
> $XFS_IO_PROG -d -f -s -c "pwrite ..." $testfile
> 
> "-s" is an undocumented flag that makes the writes synchronous.

Ok. I will fix that.

> 
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> 
> $XFS_IO_PROG -c 'stat' $testfile | grep nextents ?

I agree. I will replace the above with xfs_io's stat command. But for special
inodes like quota and realtime bitmap and summary inodes we would still
require the helper function to obtain the extent count.

> 
> > +			   _fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +delalloc_to_written_extent
> > +falloc_unwritten_extent
> > +quota_inode_extend
> > +directio_write
> 
> I wonder if these should be separate tests, since they each format the
> scratch fs?  Or could you format the scratch fs once and test four
> different files?

Quota inode test is the only one which requires bmap_alloc_minlen_extent
 error tag. Other tests here have the following pattern,
 - mkfs and mount fs
 - Fragment fs space
 - Inject reduce_max_iextents error tag
 - Work on a test file
   Here we allocate individual blocks.
 - Umount
 - Check inode fork extent count.
So we can have just one mkfs/mount overall by removing the testfile created by
each test and also quota inode test can be moved to the last so that
bmap_alloc_minlen_extent error tag can be applied only to that test.
 
> 
> --D
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/522.out b/tests/xfs/522.out
> > new file mode 100644
> > index 00000000..98791aae
> > --- /dev/null
> > +++ b/tests/xfs/522.out
> > @@ -0,0 +1,24 @@
> > +QA output created by 522
> > +* Delalloc to written extent conversion
> > +Format and mount fs
> > +Inject reduce_max_iextents error tag
> > +Create fragmented file
> > +Verify $testfile's extent count
> > +* Fallocate of unwritten extents
> > +Format and mount fs
> > +Inject reduce_max_iextents error tag
> > +Fallocate fragmented file
> > +Verify $testfile's extent count
> > +* Extend quota inodes
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Extend uquota file
> > +Verify uquota inode's extent count
> > +* Directio write
> > +Format and mount fs
> > +Inject reduce_max_iextents error tag
> > +Create fragmented file via directio writes
> > +Verify $testfile's extent count
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index b89c0a4e..1831f0b5 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -519,3 +519,4 @@
> >  519 auto quick reflink
> >  520 auto quick reflink
> >  521 auto quick realtime growfs
> > +522 auto quick quota
> 


-- 
chandan



