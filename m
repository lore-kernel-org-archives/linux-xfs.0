Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08ADC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 05:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E05F24654
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 05:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oPincBTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgKRFUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRFUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 00:20:32 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E45DC0613D4;
        Tue, 17 Nov 2020 21:20:32 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r18so391255pgu.6;
        Tue, 17 Nov 2020 21:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cARqbmOO91vL1XxfEcvkrmTq9dWd19N6vMcgUeYZFL0=;
        b=oPincBTNd90BX6RLH1tlUjE0ZtaUzvBtKkfRgM2phgImGM5aGDF2oCMjdRGEZl+Id4
         ug5weCjFXXhVO/GYglFnt7tP1UdNZC/7QFB0iBCiUC1Hon7XhHnwgNto6ulYB8CH/cW2
         UvPK4T8TIFVxJEQcdw1eAG6DvQ3Nndsrx4WR0D4q1ktARHEMKeJF98C0fT9ZIi0c705u
         FGra7bF3ZQr03I66UXJPfWlEy4yAkpMi/alPq43MK1RR0yQIM44N00cwc2HXNixdGmNt
         wjieu0tlMmEfr0hKKFCc8oD3HpTzXFdQJU825wuRCm8O0QETi3K5MpfZmjvGO3HVG1IV
         Wsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cARqbmOO91vL1XxfEcvkrmTq9dWd19N6vMcgUeYZFL0=;
        b=AtxPCB21iMBoSHGBdQ4kGkX9uIlbefbStumbM0fN+DavgNFOrdTtKpRM9wFZF1pBIG
         LBrnBO1iTYRPXAWKVOOOK+xmuh1bDY/oR+Qhk/rkgrvOc9bBVMABZNuxQVCfib4lZjtT
         GQ9Li3nCipTI7QdUa9+Ir01K/+QUa9v1F+E/QY6d3BkxfQT4p55klua5h1RbCrgisuQm
         z+1WZKKIsr5M8kIpkWdRCvLPQIv5QXWM+EIoAqHYHc+4VPvCLPKTrjjI6WMB6QQHmWPb
         evMNdhTgujxFd0MOemb//SyabOCf8piAzqrE3PVeaP1XLHTUFGm5TFaX5hq5Yiu3mGEb
         v80A==
X-Gm-Message-State: AOAM532j+ZzpC/9ikiJIUanBHro3+oB3eVU8MRS1HJZvA2G9WkKPGI6n
        laRdT9IKq3hoJYSiejPxiJHmcujhE3Y=
X-Google-Smtp-Source: ABdhPJwlSkkeED52NP/+wrTk9a7n3uLfzDyHdMNhb7zwS4EZYNaG/t3oscaD/PABupYsxk0zg/6VWQ==
X-Received: by 2002:a63:7703:: with SMTP id s3mr6907298pgc.9.1605676832099;
        Tue, 17 Nov 2020 21:20:32 -0800 (PST)
Received: from garuda.localnet ([122.166.88.26])
        by smtp.gmail.com with ESMTPSA id r6sm23053375pfh.166.2020.11.17.21.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 21:20:31 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Wed, 18 Nov 2020 10:50:28 +0530
Message-ID: <3004185.drFshOy15W@garuda>
In-Reply-To: <20201114004232.GI9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-9-chandanrlinux@gmail.com> <20201114004232.GI9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 6:12:32 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:57:00PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when writing to a shared extent.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/528     | 87 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/528.out |  8 +++++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 96 insertions(+)
> >  create mode 100755 tests/xfs/528
> >  create mode 100644 tests/xfs/528.out
> > 
> > diff --git a/tests/xfs/528 b/tests/xfs/528
> > new file mode 100755
> > index 00000000..0d39f05e
> > --- /dev/null
> > +++ b/tests/xfs/528
> > @@ -0,0 +1,87 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 528
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# writing to a shared extent.
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
> > +. ./common/reflink
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_scratch_reflink
> > +_require_xfs_debug
> > +_require_xfs_io_command "reflink"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +
> > +echo "* Write to shared extent"
> > +
> > +echo "Format and mount fs"
> > +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +bsize=$(_get_block_size $SCRATCH_MNT)
> 
> Now that we're playing with regular files again -- should this be
> _get_file_block_size ?  I think the same question applies to patches 2,
> 3, and 4, and perhaps the next one too.
> 
> (Note that regular files can have cluster sizes that aren't the same as
> the fs block size if I set MKFS_OPTIONS="-d rtinherit=1 -r extsize=64k".)

Patch 2 computes the size of the rt volume as a function of the bitmap
inode. The data associated with bitmap inode is stored in the regular
filesystem space. Hence filesystem block size is the appropriate choice here.
The same applies to quota inode extent count overflow test.

The test included in the next patch requires reflink to be enabled. Hence
filesystem block size is the correct choice.

For the other tests that you have mentioned and also for the fstress test I
will use _get_file_block_size().

> 
> --D
> 
> > +
> > +srcfile=${SCRATCH_MNT}/srcfile
> > +dstfile=${SCRATCH_MNT}/dstfile
> > +
> > +nr_blks=15
> > +
> > +echo "Create a \$srcfile having an extent of length $nr_blks blocks"
> > +xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> > +       -c fsync $srcfile  >> $seqres.full
> > +
> > +echo "Share the extent with \$dstfile"
> > +xfs_io -f -c "reflink $srcfile" $dstfile >> $seqres.full
> > +
> > +echo "Inject reduce_max_iextents error tag"
> > +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +echo "Buffered write to every other block of \$dstfile's shared extent"
> > +for i in $(seq 1 2 $((nr_blks - 1))); do
> > +	xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $dstfile \
> > +	       >> $seqres.full 2>&1
> > +	[[ $? != 0 ]] && break
> > +done
> > +
> > +ino=$(stat -c "%i" $dstfile)
> > +
> > +_scratch_unmount >> $seqres.full
> > +
> > +echo "Verify \$dstfile's extent count"
> > +
> > +nextents=$(_scratch_get_iext_count $ino data || \
> > +		_fail "Unable to obtain inode fork's extent count")
> > +if (( $nextents > 10 )); then
> > +	echo "Extent count overflow check failed: nextents = $nextents"
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > + 
> > diff --git a/tests/xfs/528.out b/tests/xfs/528.out
> > new file mode 100644
> > index 00000000..8666488b
> > --- /dev/null
> > +++ b/tests/xfs/528.out
> > @@ -0,0 +1,8 @@
> > +QA output created by 528
> > +* Write to shared extent
> > +Format and mount fs
> > +Create a $srcfile having an extent of length 15 blocks
> > +Share the extent with $dstfile
> > +Inject reduce_max_iextents error tag
> > +Buffered write to every other block of $dstfile's shared extent
> > +Verify $dstfile's extent count
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 627813fe..c85aac6b 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -525,3 +525,4 @@
> >  525 auto quick attr
> >  526 auto quick dir hardlink symlink
> >  527 auto quick
> > +528 auto quick reflink
> 


-- 
chandan



