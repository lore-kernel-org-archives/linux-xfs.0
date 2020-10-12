Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA967C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 08:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5044520714
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 08:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZvgalvRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgJLIeG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 04:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLIeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 04:34:06 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0B4C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 01:34:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f19so12836581pfj.11
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 01:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B3ZehuPQnj27DHRIhJNgdNY5XEBj2DFD9A/auxDQKds=;
        b=ZvgalvRNcIynh8V04fa23/xmKlbE9SrwZXADEgAn7Cut8hSrz+2jrJNPMWSbxcx9q8
         yoq/VxC89I+3iLQgxELl+I7WhnR7K+DRyEV/B1WeG5NAtzT7FyVkf05+60/z372793O7
         Pn7Rwywl/rrReFsgoO32OKwKcUd/TA7o0sdxjBgG1pU0IvcK5CJl3hdw0WEZxRgFmlPY
         YSLjh2/ms1e/Td+0YjlZQ6hBNLFstXKdQf54H+U2rEEYbIhKywnhU5oTPP2G/GvYDKbK
         avx3Azydf/T4uTh46bEZi3i/a9zdU1z/H4dDEbT7dSgZYFLLnHwdOHasT1RhtYW3QR+w
         04pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3ZehuPQnj27DHRIhJNgdNY5XEBj2DFD9A/auxDQKds=;
        b=gO/rlB69sSGCISL/cIvGjeUA3cmC9bZ9351XFON8tfWKTtKEJV+xyY/jwQrRMTZDAB
         3sUzyd9XzXv/SdePm+UqKww9z1kJp2KSi01mt4O2Ei6ZqsroHU4MuPgYaY41hEWfgt1+
         rSsHdj3ASr73X2ave/7WUdQ4d1aNV8Z25GAp8Smw9OzjtW62OPHmuqxp7DS0DHbz0NyF
         fsecBkzexiSB+zQctmaBaXfJJjxIASLpPAqOZeUsYyPiOLsVKwmjAmdT7cg45BLYqeu0
         b88wm0i2RzDRAvASXIkP5yKEb2ZKDgtYurwW8RmFntu5hlG1++kRJHKRREQ4/iiHAL+h
         UPPg==
X-Gm-Message-State: AOAM530FyWritCvw+0gKI9ZhvE42/BwrT/1a33IhkeW+ZpmWb6GLZMex
        tKS1DiBYtXV36C46amneFaQ=
X-Google-Smtp-Source: ABdhPJz+waeJEFRiZ6k0sWKLjY5FOJuLM2E5n8dFBklse0GHs4LpZ2jToRMwJ0q27YW415NZh7+HhQ==
X-Received: by 2002:a63:4f5e:: with SMTP id p30mr12230624pgl.6.1602491645846;
        Mon, 12 Oct 2020 01:34:05 -0700 (PDT)
Received: from garuda.localnet ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id q8sm19384459pfl.100.2020.10.12.01.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 01:34:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/2] xfs: test rtalloc alignment and math errors
Date:   Mon, 12 Oct 2020 14:03:57 +0530
Message-ID: <3176897.ncsJDD4Lff@garuda>
In-Reply-To: <20201010175032.GB6559@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <20201010175032.GB6559@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 10 October 2020 11:20:32 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of regression tests for "xfs: make sure the rt allocator
> doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
> finsert operations are aligned to rt extent size".
>

W.r.t "Make sure we validate realtime extent size alignment for fallocate
modes" test,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/759     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/759.out |    2 +
>  tests/xfs/760     |   66 +++++++++++++++++++++++++++++++++++
>  tests/xfs/760.out |    9 +++++
>  tests/xfs/group   |    2 +
>  5 files changed, 178 insertions(+)
>  create mode 100755 tests/xfs/759
>  create mode 100644 tests/xfs/759.out
>  create mode 100755 tests/xfs/760
>  create mode 100644 tests/xfs/760.out
> 
> diff --git a/tests/xfs/759 b/tests/xfs/759
> new file mode 100755
> index 00000000..00573786
> --- /dev/null
> +++ b/tests/xfs/759
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 759
> +#
> +# This is a regression test for an overflow error in the _near realtime
> +# allocator.  If the rt bitmap ends exactly at the end of a block and the
> +# number of rt extents is large enough to allow an allocation request larger
> +# than the maximum extent size, it's possible that during a large allocation
> +# request, the allocator will fail to constrain maxlen on the second run
> +# through the loop, and the rt bitmap range check will run right off the end of
> +# the rtbitmap file.  When this happens, xfs triggers a verifier error and
> +# returns EFSCORRUPTED.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_realtime
> +_require_test_program "punch-alternating"
> +
> +rm -f $seqres.full
> +
> +# Format filesystem to get the block size
> +_scratch_mkfs > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +blksz=$(_get_block_size $SCRATCH_MNT)
> +rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> +rextblks=$((rextsize / blksz))
> +
> +echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> +
> +_scratch_unmount
> +
> +# Format filesystem with a realtime volume whose size fits the following:
> +# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes.
> +# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.
> +
> +rtsize1=$((2097151 * blksz))
> +rtsize2=$((8 * blksz * rextsize))
> +rtsize=$(( $(blockdev --getsz $SCRATCH_RTDEV) * 512 ))
> +
> +echo "rtsize1 $rtsize1 rtsize2 $rtsize2 rtsize $rtsize" >> $seqres.full
> +
> +test $rtsize -gt $rtsize1 || \
> +	_notrun "scratch rt device too small, need $rtsize1 bytes"
> +test $rtsize -gt $rtsize2 || \
> +	_notrun "scratch rt device too small, need $rtsize2 bytes"
> +
> +rtsize=$((rtsize - (rtsize % rtsize2)))
> +
> +echo "rt size will be $rtsize" >> $seqres.full
> +
> +_scratch_mkfs -r size=$rtsize >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +# Make sure the root directory has rtinherit set so our test file will too
> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> +
> +# Allocate some stuff at the start, to force the first falloc of the ouch file
> +# to happen somewhere in the middle of the rt volume
> +$XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
> +$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
> +
> +avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
> +toobig="$((avail * 2))"
> +
> +# falloc the ouch file in the middle of the rt extent to exercise the near
> +# allocator in the last step.
> +$XFS_IO_PROG -f -c 'falloc 0 1g' "$SCRATCH_MNT/ouch"
> +
> +# Try to get the near allocator to overflow on an allocation that matches
> +# exactly one of the rtsummary size levels.  This should return ENOSPC and
> +# not EFSCORRUPTED.
> +$XFS_IO_PROG -f -c "falloc 0 ${toobig}k" "$SCRATCH_MNT/ouch"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/759.out b/tests/xfs/759.out
> new file mode 100644
> index 00000000..df693d50
> --- /dev/null
> +++ b/tests/xfs/759.out
> @@ -0,0 +1,2 @@
> +QA output created by 759
> +fallocate: No space left on device
> diff --git a/tests/xfs/760 b/tests/xfs/760
> new file mode 100755
> index 00000000..7baa346c
> --- /dev/null
> +++ b/tests/xfs/760
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 760
> +#
> +# Make sure we validate realtime extent size alignment for fallocate modes.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_realtime
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "funshare"
> +_require_xfs_io_command "fzero"
> +_require_xfs_io_command "falloc"
> +
> +rm -f $seqres.full
> +
> +# Format filesystem with a 256k realtime extent size
> +_scratch_mkfs -r extsize=256k > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +blksz=$(_get_block_size $SCRATCH_MNT)
> +rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> +rextblks=$((rextsize / blksz))
> +
> +echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> +
> +# Make sure the root directory has rtinherit set so our test file will too
> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> +
> +sz=$((rextsize * 100))
> +range="$((blksz * 3)) $blksz"
> +
> +for verb in fpunch finsert fcollapse fzero funshare falloc; do
> +	echo "test $verb"
> +	$XFS_IO_PROG -f -c "falloc 0 $sz" "$SCRATCH_MNT/b"
> +	$XFS_IO_PROG -f -c "$verb $range" "$SCRATCH_MNT/b"
> +	rm -f "$SCRATCH_MNT/b"
> +	_scratch_cycle_mount
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/760.out b/tests/xfs/760.out
> new file mode 100644
> index 00000000..3d73c6fa
> --- /dev/null
> +++ b/tests/xfs/760.out
> @@ -0,0 +1,9 @@
> +QA output created by 760
> +test fpunch
> +test finsert
> +fallocate: Invalid argument
> +test fcollapse
> +fallocate: Invalid argument
> +test fzero
> +test funshare
> +test falloc
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c3c33b64..302f5157 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -520,6 +520,8 @@
>  520 auto quick reflink
>  747 auto quick scrub
>  758 auto quick rw attr realtime
> +759 auto quick rw realtime
> +760 auto quick rw collapse punch insert zero prealloc
>  908 auto quick bigtime
>  909 auto quick bigtime quota
>  910 auto quick inobtcount
> 


-- 
chandan



