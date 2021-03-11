Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AF5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 07:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F13D64DF2
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 07:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCKH7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 02:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhCKH6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 02:58:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF4FC061574;
        Wed, 10 Mar 2021 23:58:36 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1318371pjb.0;
        Wed, 10 Mar 2021 23:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TD+6E4zSr3bf3+qAx+ehlqCsv3enMzoHz10/eUKDDOA=;
        b=IM2r6aeUv2taycOcu2FbtCZ8bFIQnTqTlfwU0yNpS3YyVZCAawa2ZhqU+mVZlNMIhj
         3kUHkGJsowSIqyG8LDUf45OKJIB0S8+ddgnQBWzvsXy+/mlqbqUWOOx6KMFvM+DqZG01
         F9b1w4HIAxPgM/KoBFQjHVk36eJuSKXVpHNR8oX+rH2dFfKJL4TKYK/uMSjs4iFvX8MD
         2twn7C1RhrsnRKvkDiXr7OZmTwfLDpj1WSQsaPB6Y9l6vYKpdedTHkZcSMfP+M/NKajk
         dznHTYXc2i2aSzChtQfnxofw8KrHML4hxuL9ZMSdrTJZlrFPqWLIiXRSb5J31MsGoxBy
         d+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TD+6E4zSr3bf3+qAx+ehlqCsv3enMzoHz10/eUKDDOA=;
        b=N47kFQnwqblFZ7HrOoZmwc8Xjxa3rGGqkAV2ojcWSngNFZjng7KKqlv656yr1JazPK
         IyAMNd4by4NX+FoLQEnV7VqRNmj9TfrczMWtII01tXXxZGLFxaPFyqjjsE2q9tDjxXIF
         864fLZ9inOsR8ZIsXjjQcCNPCoJ6JBox9kw/I07aI8oopxKIIbUg3mCuBq8jFWx4Nl3E
         ciYL8Q9Gesis2F2WGu4fp2MNK6Un3wj5644HrAxR+coPB11ewk1pPzlq0RBK5nVrcDM5
         m6YksCfegwllN7kVZ+e0BmPLiP9Ia4Scy6YBXlvjqVn6XdkKrUdxrqsv2UZsh1rWc6AR
         oY2A==
X-Gm-Message-State: AOAM531VhmQjam7GpgQ/pyTspcxE8aZPCCv55EDNxYDYbH62RRf8tl52
        ArB7LjbHUA3ngpokCWtx6Ns=
X-Google-Smtp-Source: ABdhPJzQE59I/zb4S7X0mAXw9I8/qgZ2nqqfFgWUd5qxvQcCw3QacpWr+qDe6+e7AOkpiSr9w5Kv7w==
X-Received: by 2002:a17:90a:3ec3:: with SMTP id k61mr7573385pjc.125.1615449515643;
        Wed, 10 Mar 2021 23:58:35 -0800 (PST)
Received: from garuda ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id i2sm1465892pgs.82.2021.03.10.23.58.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 23:58:35 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526482015.1214319.6227125326960502859.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 03/10] xfs: test rtalloc alignment and math errors
In-reply-to: <161526482015.1214319.6227125326960502859.stgit@magnolia>
Date:   Thu, 11 Mar 2021 13:28:32 +0530
Message-ID: <87mtvaceaf.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a couple of regression tests for "xfs: make sure the rt allocator
> doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
> finsert operations are aligned to rt extent size".
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/759     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/759.out |    2 +
>  tests/xfs/760     |   68 ++++++++++++++++++++++++++++++++++++
>  tests/xfs/760.out |    9 +++++
>  tests/xfs/group   |    2 +
>  5 files changed, 181 insertions(+)
>  create mode 100755 tests/xfs/759
>  create mode 100644 tests/xfs/759.out
>  create mode 100755 tests/xfs/760
>  create mode 100644 tests/xfs/760.out
>
>
> diff --git a/tests/xfs/759 b/tests/xfs/759
> new file mode 100755
> index 00000000..8558fe30
> --- /dev/null
> +++ b/tests/xfs/759
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 759
> +#
> +# This is a regression test for commit 2a6ca4baed62 ("xfs: make sure the rt
> +# allocator doesn't run off the end") which fixes an overflow error in the
> +# _near realtime allocator.  If the rt bitmap ends exactly at the end of a
> +# block and the number of rt extents is large enough to allow an allocation
> +# request larger than the maximum extent size, it's possible that during a
> +# large allocation request, the allocator will fail to constrain maxlen on the
> +# second run through the loop, and the rt bitmap range check will run right off
> +# the end of the rtbitmap file.  When this happens, xfs triggers a verifier
> +# error and returns EFSCORRUPTED.
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

Shouldn't the multiplier be RT extent size rather than FS block size?

> +# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.

i.e The bits in one rt bitmap block map (NBBY * blksz * rextsize) bytes of an
rt device. Hence to have the bitmap end at a fs block boundary the
corresponding rt device size should be a multiple of this product. Is my
understanding correct?

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

--
chandan
