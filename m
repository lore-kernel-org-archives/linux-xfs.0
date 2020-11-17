Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AD5C56202
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE55221EB
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7oT2bNS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgKQO0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgKQO0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:26:37 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F35C0613CF;
        Tue, 17 Nov 2020 06:26:37 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so16157326pgi.8;
        Tue, 17 Nov 2020 06:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPWWJt3sXhprYrUf9McFEc9zw/hY+TI5zslo0flrClM=;
        b=a7oT2bNSOuykC5mJXk6GfAFtHhNZ/a/HXjGYzmMFBdi1YAHkTDgUy/dmmJzMvljz6U
         gtPEnfKoICW/+p0MjY3UxPbCp92EwHWLyY0p96zoZfAPAl4sWBBW14lOqffWHB0sk2oK
         zwGUDAPlu413HRxPM5PpggKWYkpH7EeqPp2z6HnDx0B1ecnGOx0Nc3QxmL22W690fZ/v
         w2SnFbNWzq7MEFqOzNiETe0IyHZGDEXYpuRyxYtmAnNoVg38HLQcdNCZ52UsxImGf/F7
         63MUfeR+1a98Byb2EY/f3mo3/cjKiXstzqMzze5VN3RtNwuOv943oAGLBSq41qVFlnxD
         Pnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPWWJt3sXhprYrUf9McFEc9zw/hY+TI5zslo0flrClM=;
        b=O7hnKhf5ZrmIwa9Fi31SSL1bGSK/ydPvhrkfkep/Q35ohHOoamUBx6sW+dtadwBB1b
         BfV5mjd1ZME2NdfqZ+rWFgRsM3peb0F+L2Wuq1oQiaO3ZzYIiGCZ0Qz8NkKABEN4EJSW
         iHgkNHjrh8OYCrC/xc2ZP168F3fgVlnKjpNisgTJujEHwD9NXTbNfK5vicsMAsy/JrZF
         l321iwN8hvHAzhJQF1alMaMx7JlA+3f5H0eOHmKubJThVYhW10jnMXBs1pngz5yl0pca
         0IdSoIDenJMt2MAZ1rASxP9i02MLCUcPiH6S/9jLUfrWwssmieZSQdziHNQkEEL1dw1y
         bZaQ==
X-Gm-Message-State: AOAM5309THeIKS5fzykpavEJlT1PxPz8KOtU2rYxck2l+H1GN9j1P/pn
        VrJ/ObS64WabtbsVjBXIXjg=
X-Google-Smtp-Source: ABdhPJyfnLQtEXu9OkN8IMx3Wsup1yxIfAX9MYlq1bm2+jR7MZriUiDnIRYpU69Sx4ShUP/Wl1CDRQ==
X-Received: by 2002:a63:c43:: with SMTP id 3mr3864693pgm.222.1605623196660;
        Tue, 17 Nov 2020 06:26:36 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id u4sm3449580pjg.55.2020.11.17.06.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:26:35 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: Check for extent overflow when punching a hole
Date:   Tue, 17 Nov 2020 19:56:33 +0530
Message-ID: <2562134.oBXMZB41vJ@garuda>
In-Reply-To: <20201114002812.GE9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-5-chandanrlinux@gmail.com> <20201114002812.GE9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 5:58:12 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:56:56PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when punching out an extent.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/524     | 210 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/524.out |  25 ++++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 236 insertions(+)
> >  create mode 100755 tests/xfs/524
> >  create mode 100644 tests/xfs/524.out
> > 
> > diff --git a/tests/xfs/524 b/tests/xfs/524
> > new file mode 100755
> > index 00000000..9e140c99
> > --- /dev/null
> > +++ b/tests/xfs/524
> > @@ -0,0 +1,210 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 524
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# punching out an extent.
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
> > +_require_xfs_io_command "finsert"
> > +_require_xfs_io_command "fcollapse"
> > +_require_xfs_io_command "fzero"
> 
> For completeness, should this also be testing funshare?

This script tests the limits imposed by XFS_IEXT_PUNCH_HOLE_CNT. funshare
causes xfs_reflink_end_cow_extent() to be invoked. Hence I will add that to
the script testing XFS_IEXT_REFLINK_END_COW_CNT.

> 
> > +_require_test_program "punch-alternating"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +
> > +punch_range()
> > +{
> > +	echo "* Fpunch regular file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> 
> I don't think you need a fresh format for each functional test.

Yes, you are right. We could have just one mkfs and mount followed by all test
operations.

> 
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	nr_blks=30
> > +
> > +	echo "Create \$testfile"
> > +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> > +	       -c sync $testfile  >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "fpunch alternating blocks"
> > +	$here/src/punch-alternating $testfile >> $seqres.full 2>&1
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data ||
> 
> ...and now that I keep seeing this unmount-getiextcount-mount dance, you
> probably should convert these to grab the extent count info online.

I agree. I will fix this up.

> 
> --D
> 
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +finsert_range()
> > +{
> > +	echo "* Finsert regular file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)	
> > +
> > +	nr_blks=30
> > +
> > +	echo "Create \$testfile"
> > +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> > +	       -c sync $testfile  >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Finsert at every other block offset"
> > +	for i in $(seq 1 2 $((nr_blks - 1))); do
> > +		xfs_io -f -c "finsert $((i * bsize)) $bsize" $testfile \
> > +		       >> $seqres.full 2>&1
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
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = ${nextents}"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +fcollapse_range()
> > +{
> > +	echo "* Fcollapse regular file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)	
> > +
> > +	nr_blks=30
> > +
> > +	echo "Create \$testfile"
> > +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> > +	       -c sync $testfile  >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Fcollapse at every other block offset"
> > +	for i in $(seq 1 $((nr_blks / 2 - 1))); do
> > +		xfs_io -f -c "fcollapse $((i * bsize)) $bsize" $testfile \
> > +		       >> $seqres.full 2>&1
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
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = ${nextents}"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +fzero_range()
> > +{
> > +	echo "* Fzero regular file"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	bsize=$(_get_block_size $SCRATCH_MNT)	
> > +
> > +	nr_blks=30
> > +
> > +	echo "Create \$testfile"
> > +	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> > +	       -c sync $testfile  >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Fzero at every other block offset"
> > +	for i in $(seq 1 2 $((nr_blks - 1))); do
> > +		xfs_io -f -c "fzero $((i * bsize)) $bsize" $testfile \
> > +		       >> $seqres.full 2>&1
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
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = ${nextents}"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +punch_range
> > +finsert_range
> > +fcollapse_range
> > +fzero_range
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/524.out b/tests/xfs/524.out
> > new file mode 100644
> > index 00000000..58f7d7ae
> > --- /dev/null
> > +++ b/tests/xfs/524.out
> > @@ -0,0 +1,25 @@
> > +QA output created by 524
> > +* Fpunch regular file
> > +Format and mount fs
> > +Create $testfile
> > +Inject reduce_max_iextents error tag
> > +fpunch alternating blocks
> > +Verify $testfile's extent count
> > +* Finsert regular file
> > +Format and mount fs
> > +Create $testfile
> > +Inject reduce_max_iextents error tag
> > +Finsert at every other block offset
> > +Verify $testfile's extent count
> > +* Fcollapse regular file
> > +Format and mount fs
> > +Create $testfile
> > +Inject reduce_max_iextents error tag
> > +Fcollapse at every other block offset
> > +Verify $testfile's extent count
> > +* Fzero regular file
> > +Format and mount fs
> > +Create $testfile
> > +Inject reduce_max_iextents error tag
> > +Fzero at every other block offset
> > +Verify $testfile's extent count
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 018c70ef..3fa38c36 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -521,3 +521,4 @@
> >  521 auto quick realtime growfs
> >  522 auto quick quota
> >  523 auto quick realtime growfs
> > +524 auto quick punch zero insert collapse
> 


-- 
chandan



