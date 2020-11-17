Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC3DC5519F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 15:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 253092463C
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 15:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlhSdhvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgKQPfc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 10:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKQPfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 10:35:32 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A3DC0613CF;
        Tue, 17 Nov 2020 07:35:31 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so10409704plr.9;
        Tue, 17 Nov 2020 07:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHq74Ex0T5mYxrn9yMvO+0SgqpxuXXeonziZSB8EPw0=;
        b=UlhSdhvgVJ+1APqkPek8+JW3EvWF5vEOywutfG7PwBP2dZqG5dYzQzAAtCsEXy8HtD
         I3Rd9Iq9hgiK2npYP4aKK6Lyob5RQ/fnRmPDNHp5277lZ/Avhd61qUCiparZaIAfWXI9
         3SSp597VM0k+MOqXC3038xv9kFOdO6lwHm6GclbAitDplCfRiMD9exm4v2swDX3jiTZp
         kzFFMdjvHZ2eah8cbpn/BVCflV9RViY0cxsYV+04HQpLebU2Q8HrKPrEPrQwHriR6DJ4
         gy5vrqTckDWufOeszRaTOiY3ijksY/TVaJgBUFQI3u4okLVbvjnaSvAAuhRWdW/yeDGy
         Fwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHq74Ex0T5mYxrn9yMvO+0SgqpxuXXeonziZSB8EPw0=;
        b=EzFOr3eY+ArBW9DCucIxw3+b4tYZG7JgE7kXIUkuX7EcQuN9fgr/nH10pWQ6kbQ50p
         ufzHEXZ669crUY7erSZSQvsySGjH++p58mXgS1k3OxC3SqZfwEMa/zc+E91LHTvExB72
         TVgsc6hlW85umPfpAQ65oPOpyBNUIPYHWV7x7WqRj6Be8COmXY7D/kDnBMCQP1NqfgYe
         sb1z0AKqdtie7Wl4dBEQ/Fk5wBzLXRFUxQoAu7JprRYliXx2t1CMzLKhdwO4mkCRi+Ei
         oo2NSlIAhBdqFxtwszXnQGXU7gmq4HKOvMSu2PRoZL4e+6x0h6+x2tFQp19x35VsCDcA
         yS8g==
X-Gm-Message-State: AOAM530ezVkmmeB5eOsuZ8syV32MUZbgnldfcUn4ldh47ER2xzbU32wX
        eeJPlyM2We7o+r01ilcSCrYhkVRJjvA=
X-Google-Smtp-Source: ABdhPJwDksf/Hpp3Hc1/RYDxEsdRgJgR59bqBK85Ut8vnQVJXemciH05r2kifOHdUVPvYQnU0UC9fw==
X-Received: by 2002:a17:902:8206:b029:d8:de70:7f7a with SMTP id x6-20020a1709028206b02900d8de707f7amr14898136pln.39.1605627330632;
        Tue, 17 Nov 2020 07:35:30 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id w6sm18256511pgr.71.2020.11.17.07.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 07:35:30 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: Check for extent overflow when swapping extents
Date:   Tue, 17 Nov 2020 21:05:25 +0530
Message-ID: <5877518.Y88ADI1sEr@garuda>
In-Reply-To: <20201114000835.GA9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-11-chandanrlinux@gmail.com> <20201114000835.GA9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 5:38:35 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:57:02PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when swapping forks across two files.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/530     | 115 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/530.out |  13 ++++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 129 insertions(+)
> >  create mode 100755 tests/xfs/530
> >  create mode 100644 tests/xfs/530.out
> > 
> > diff --git a/tests/xfs/530 b/tests/xfs/530
> > new file mode 100755
> > index 00000000..fccc6de7
> > --- /dev/null
> > +++ b/tests/xfs/530
> > @@ -0,0 +1,115 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 530
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# swapping forks between files
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
> > +_require_xfs_scratch_rmapbt
> > +_require_xfs_io_command "fcollapse"
> > +_require_xfs_io_command "swapext"
> 
> FWIW it's going to be a while before the swapext command goes upstream.
> Right now it's a part of the atomic file range exchange patchset.

Sorry, I didn't understand your statement. I have the following from my Linux
machine,

root@debian-guest:~# /sbin/xfs_io 
xfs_io> help swapext
swapext <donorfile> -- Swap extents between files.

 Swaps extents between the open file descriptor and the supplied filename.

The above command causes the following code path to be invoked inside the
kernel (assuming rmapbt feature is enabled),
xfs_ioc_swapext() => xfs_swap_extents() => xfs_swap_extent_rmap().

> 
> Do you want me to try to speed that up?
> 
> --D
> 
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +
> > +echo "* Swap extent forks"
> > +
> > +echo "Format and mount fs"
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +srcfile=${SCRATCH_MNT}/srcfile
> > +donorfile=${SCRATCH_MNT}/donorfile
> > +
> > +echo "Create \$donorfile having an extent of length 17 blocks"
> > +xfs_io -f -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" -c fsync $donorfile \
> > +       >> $seqres.full
> > +
> > +# After the for loop the donor file will have the following extent layout
> > +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> > +echo "Fragment \$donorfile"
> > +for i in $(seq 5 10); do
> > +	start_offset=$((i * bsize))
> > +	xfs_io -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> > +done
> > +donorino=$(stat -c "%i" $donorfile)
> > +
> > +echo "Create \$srcfile having an extent of length 18 blocks"
> > +xfs_io -f -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" -c fsync $srcfile \
> > +       >> $seqres.full
> > +
> > +echo "Fragment \$srcfile"
> > +# After the for loop the src file will have the following extent layout
> > +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> > +for i in $(seq 1 7); do
> > +	start_offset=$((i * bsize))
> > +	xfs_io -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> > +done
> > +srcino=$(stat -c "%i" $srcfile)
> > +
> > +_scratch_unmount >> $seqres.full
> > +
> > +echo "Collect \$donorfile's extent count"
> > +donor_nr_exts=$(_scratch_get_iext_count $donorino data || \
> > +		_fail "Unable to obtain inode fork's extent count")
> > +
> > +echo "Collect \$srcfile's extent count"
> > +src_nr_exts=$(_scratch_get_iext_count $srcino data || \
> > +		_fail "Unable to obtain inode fork's extent count")
> > +
> > +_scratch_mount >> $seqres.full
> > +
> > +echo "Inject reduce_max_iextents error tag"
> > +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +echo "Swap \$srcfile's and \$donorfile's extent forks"
> > +xfs_io -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
> > +
> > +_scratch_unmount >> $seqres.full
> > +
> > +echo "Check for \$donorfile's extent count overflow"
> > +nextents=$(_scratch_get_iext_count $donorino data || \
> > +		_fail "Unable to obtain inode fork's extent count")
> > +if (( $nextents == $src_nr_exts )); then
> > +	echo "\$donorfile: Extent count overflow check failed"
> > +fi
> > +
> > +echo "Check for \$srcfile's extent count overflow"
> > +nextents=$(_scratch_get_iext_count $srcino data || \
> > +		_fail "Unable to obtain inode fork's extent count")
> > +if (( $nextents == $donor_nr_exts )); then
> > +	echo "\$srcfile: Extent count overflow check failed"
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/530.out b/tests/xfs/530.out
> > new file mode 100644
> > index 00000000..996af959
> > --- /dev/null
> > +++ b/tests/xfs/530.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 530
> > +* Swap extent forks
> > +Format and mount fs
> > +Create $donorfile having an extent of length 17 blocks
> > +Fragment $donorfile
> > +Create $srcfile having an extent of length 18 blocks
> > +Fragment $srcfile
> > +Collect $donorfile's extent count
> > +Collect $srcfile's extent count
> > +Inject reduce_max_iextents error tag
> > +Swap $srcfile's and $donorfile's extent forks
> > +Check for $donorfile's extent count overflow
> > +Check for $srcfile's extent count overflow
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index bc3958b3..81a15582 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -527,3 +527,4 @@
> >  527 auto quick
> >  528 auto quick reflink
> >  529 auto quick reflink
> > +530 auto quick
> 


-- 
chandan



