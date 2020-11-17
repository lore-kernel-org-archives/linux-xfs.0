Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C02C56202
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7D22225E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BypRNQap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgKQOax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgKQOax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:30:53 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A974C0613CF;
        Tue, 17 Nov 2020 06:30:52 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so17354355pfm.13;
        Tue, 17 Nov 2020 06:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/MxiEK5AdLlNupMf/+OEaWxPWsxapPv38Nw98J1R/4=;
        b=BypRNQapfo9TgKYFy73NutYkDscw5JzsLZG/bJZZbGq+aWFPfdvWYRtsFdnW4jDnNy
         Sl1qiaivVpuQ+baJ0FLIKTLdrOPtDFOXk3KCyEgT01RchqQBQzD9gJVyNcn879pLNFA/
         8OrId8eYADEKvKjfQntGACESW8drF5uiapUv1Bage2fzFPoumtWp63uGNTH8SVTWSzWc
         3up7yUNDvOnhs1MeUw4EwLB+3o0Ae1j+9fRq83kGCqk6mbTgWvcdlvka8ZfJybrvDYIK
         OyF80M6J2bvvB6FQMaciKKIdf5FijDjvu4NuVpBLCADnYB4rtoyUhDGn/TICaBLVe44U
         fYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v/MxiEK5AdLlNupMf/+OEaWxPWsxapPv38Nw98J1R/4=;
        b=LfAeKe8DikYvSI544tyBMq1abXM3vMvcE6xILLQh7OWIzm8dt6A6TK86avY+Z6AJFm
         tgW6nIeekNZGIXphPrKH6TskvSTJk4yMCI8GLGLaP9V673LqBjrT1jUBshSsofdQSLd9
         kIIjdmFD+mmce7dZM3ZLyoKGPoq122AKCj/UuLSDU7Wj/NB3Z4jDjRif3oJfuZOJ7Ml0
         x4dUQSwvmJQLGB8nVG2My8iOID5Jh6ZgY0uzLySCxsrBqTORPiC/x0RHfSCNe4Seq33L
         hGinpgiPiSnWC4Cvhj3PsmGH9pweZL7mx0qEtj0MhZZxs706sqCHoETyoJZv6stVlnGM
         fv7g==
X-Gm-Message-State: AOAM532KtnAdTWvjal7YUoSDBTmWO88uG0YZNIgSmWqJoFWxwY9aP4Wr
        CtECLkUFi5u76l+xhqdQlLp5Vtgn+RE=
X-Google-Smtp-Source: ABdhPJyi3Njj97GZDYNAtddkWG0rQSCrc39Ta7NJEE93kx+RHImZWXsxcI5u9q/T5x1bwuE00/MosA==
X-Received: by 2002:a63:ca0a:: with SMTP id n10mr3739866pgi.326.1605623451670;
        Tue, 17 Nov 2020 06:30:51 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id a18sm14565566pfa.151.2020.11.17.06.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:30:51 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 17 Nov 2020 20:00:48 +0530
Message-ID: <1791734.G9uDVue0vK@garuda>
In-Reply-To: <20201114003440.GF9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-6-chandanrlinux@gmail.com> <20201114003440.GF9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 6:04:40 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:56:57PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when adding/removing xattrs.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/525     | 154 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/525.out |  16 +++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 171 insertions(+)
> >  create mode 100755 tests/xfs/525
> >  create mode 100644 tests/xfs/525.out
> > 
> > diff --git a/tests/xfs/525 b/tests/xfs/525
> > new file mode 100755
> > index 00000000..1d5d6e7c
> > --- /dev/null
> > +++ b/tests/xfs/525
> > @@ -0,0 +1,154 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 525
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# Adding/removing xattrs.
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
> > +. ./common/attr
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_attrs
> > +_require_xfs_debug
> > +_require_test_program "punch-alternating"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +
> > +attr_set()
> > +{
> > +	echo "* Set xattrs"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	testfile=$SCRATCH_MNT/testfile
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
> > +	echo "Create xattrs"
> > +
> > +	attr_len=$(uuidgen | wc -c)
> > +	nr_attrs=$((bsize * 20 / attr_len))
> > +	for i in $(seq 1 $nr_attrs); do
> > +		$SETFATTR_PROG -n "trusted.""$(uuidgen)" $testfile \
> 
> Does this test require UUIDs in the attr names?  Why wouldn't
> $(printf "%037d" $i) suffice for this purpose?

You are right. I can replace executing uuidgen with calls to printf.

> 
> Though if you insist upon using uuids, please call $UUIDGEN_PROG per
> fstest custom.
> 
> > +			 >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify uquota inode's extent count"
> 
> Huh?  I thought we were testing file attrs?

Sorry, I will fix that.

> 
> > +	nextents=$(_scratch_get_iext_count $testino attr || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +}
> > +
> > +attr_remove()
> > +{
> > +	echo "* Remove xattrs"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	naextents=0
> > +	last=""
> > +
> > +	attr_len=$(uuidgen | wc -c)
> > +	nr_attrs=$((bsize / attr_len))
> > +
> > +	echo "Create initial xattr extents"
> > +	while (( $naextents < 4 )); do
> > +		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +		for i in $(seq 1 $nr_attrs); do
> > +			last="trusted.""$(uuidgen)"
> > +			$SETFATTR_PROG -n $last $testfile
> > +		done
> > +
> > +		_scratch_unmount >> $seqres.full
> > +
> > +		naextents=$(_scratch_get_iext_count $testino attr || \
> > +				_fail "Unable to obtain inode fork's extent count")
> > +
> > +		_scratch_mount >> $seqres.full
> > +	done
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Remove xattr to trigger -EFBIG"
> > +	$SETFATTR_PROG -x "$last" $testfile >> $seqres.full 2>&1
> > +	if [[ $? == 0 ]]; then
> > +		echo "Xattr removal succeeded; Should have failed "
> 
> So at this point the user has a file for which he can't ever remove the
> xattrs for fear of overflowing naextents.  The only way to clear this is
> to delete the file, so shouldn't you be testing that this succeeds?

Ok. I will add that. However there is another issue here. I think it would better
suited to discuss that w.r.t XFS_IEXT_DIR_MANIP_CNT tests (i.e. patch 6).

> 
> --D
> 
> > +		exit 1
> > +	fi
> > +}
> > +
> > +attr_set
> > +attr_remove
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/525.out b/tests/xfs/525.out
> > new file mode 100644
> > index 00000000..cc40e6e2
> > --- /dev/null
> > +++ b/tests/xfs/525.out
> > @@ -0,0 +1,16 @@
> > +QA output created by 525
> > +* Set xattrs
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Create xattrs
> > +Verify uquota inode's extent count
> > +* Remove xattrs
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Create initial xattr extents
> > +Inject reduce_max_iextents error tag
> > +Remove xattr to trigger -EFBIG
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 3fa38c36..bd38aff0 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -522,3 +522,4 @@
> >  522 auto quick quota
> >  523 auto quick realtime growfs
> >  524 auto quick punch zero insert collapse
> > +525 auto quick attr
> 


-- 
chandan



