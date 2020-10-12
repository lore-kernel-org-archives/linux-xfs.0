Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE146C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 15:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56C620870
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 15:00:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vQY1QSk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgJLPA1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 11:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbgJLPA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 11:00:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E000CC0613D0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 08:00:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i2so14513626pgh.7
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 08:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okVO61kmDG3lGanOtcU7VOePmB793Xx++Y968ZzmSDo=;
        b=vQY1QSk0u2Foe8ekcN8Rs28QxNSrive4TJe595ZmyuQJOTyhfbwJhLLQYKia4cnvJu
         kOY1DQLVVvmwlP2Cx7FPzdesdqSrGIEQrOgKhSK4ZV9jiuk4Zqhe8FWiyEgCymJYMa/c
         WOwo42n1eOYkXe+eVeg1NPU4+g3Zg7QKYutaci6dUNvKEJ2JaIUy+WOFIrBvg9qF1KNU
         iLMHOmlMcWJLbTZP52vpZdMAptAvJMIHJTSryKrgNZ2c6Lio2c0YRvpPD2AYBAIgghDr
         zFl1hZE/R6X1fygtzqmi4asNA13M5nKExWZl+JmVgar+OE4Wvw8EXYUJ3UHRhuhgAbuf
         SkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okVO61kmDG3lGanOtcU7VOePmB793Xx++Y968ZzmSDo=;
        b=SOM3gK59ib4i9aAo7HWbHcGYdRxaq3mk6+jVeolgUgmAYlQtDr/dRs70JqrmatFLoh
         IA2QElk/UBJcM4r2F0F3TJMUFlOSxjJT4GTv858+EwoQ1JA+zVKVdg99s1D+cf+y7Bom
         MuvKf28IoDYNFWcC3W0BGKri8yulsBBhp778hSyVcuVAi6wW7HhatPYRYfTlkjJxREs1
         WGNBTEdJa4IXLbxb2iXwLDAeetWnIE7GASoCQ4LJwERyrDO39QHnMEf4/GMUFV/1uVgL
         +6kDZHawqABsgtsy9oagRYbMxdDrdqfTn1GjRL9Aqv/aGIvYAmW0v1YWCSrSAA9/w0yz
         Uzig==
X-Gm-Message-State: AOAM531um5HWFYjXjUmJCBPHCcrR3coiOMnuGEERAnV04h5Vy9uwusZd
        jZXeYTmCwwzih0RLu4lqJpGYDHyiY+w=
X-Google-Smtp-Source: ABdhPJxlFKWE7CDzilu4ENwNcvjc7Vj8hyRleNyqxIqOXvL55OczrwRcRNwOcSEQrzUGjzuv0Yd3Xg==
X-Received: by 2002:aa7:8b03:0:b029:152:a364:5084 with SMTP id f3-20020aa78b030000b0290152a3645084mr23131641pfd.29.1602514826349;
        Mon, 12 Oct 2020 08:00:26 -0700 (PDT)
Received: from garuda.localnet ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id p62sm5539559pfb.180.2020.10.12.08.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 08:00:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/2] xfs: test running growfs on the realtime volume
Date:   Mon, 12 Oct 2020 20:30:18 +0530
Message-ID: <2767161.PFxSFv7ODN@garuda>
In-Reply-To: <20201010175059.GC6559@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <20201010175059.GC6559@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 10 October 2020 11:20:59 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we can run growfs to expand the realtime volume without
> it blowing up.  This is a regression test for the following patches:
> 
> xfs: Set xfs_buf type flag when growing summary/bitmap files
> xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
> xfs: fix realtime bitmap/summary file truncation when growing rt volume
> xfs: make xfs_growfs_rt update secondary superblocks
> xfs: annotate grabbing the realtime bitmap/summary locks in growfs
> 
> Because the xfs maintainer realized that no, we have no tests for this
> particular piece of functionality.
>

The test looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/916     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/916.out |   10 ++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 93 insertions(+)
>  create mode 100755 tests/xfs/916
>  create mode 100644 tests/xfs/916.out
> 
> diff --git a/tests/xfs/916 b/tests/xfs/916
> new file mode 100755
> index 00000000..cde00314
> --- /dev/null
> +++ b/tests/xfs/916
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 916
> +#
> +# Tests xfs_growfs on the realtime volume to make sure none of it blows up.
> +# This is a regression test for the following patches:
> +#
> +# xfs: Set xfs_buf type flag when growing summary/bitmap files
> +# xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
> +# xfs: fix realtime bitmap/summary file truncation when growing rt volume
> +# xfs: make xfs_growfs_rt update secondary superblocks
> +# xfs: annotate grabbing the realtime bitmap/summary locks in growfs
> +#
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
> +	_scratch_unmount >> $seqres.full 2>&1
> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +# Note that we don't _require_realtime because we synthesize a rt volume
> +# below.
> +_require_scratch_nocheck
> +_require_no_large_scratch_dev
> +
> +echo "Create fake rt volume"
> +truncate -s 400m $TEST_DIR/$seq.rtvol
> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +echo "Format and mount 100m rt volume"
> +export USE_EXTERNAL=yes
> +export SCRATCH_RTDEV=$rtdev
> +_scratch_mkfs -r size=100m > $seqres.full
> +_scratch_mount || _notrun "Could not mount scratch with synthetic rt volume"
> +
> +testdir=$SCRATCH_MNT/test-$seq
> +mkdir $testdir
> +
> +echo "Check rt volume stats"
> +$XFS_IO_PROG -c 'chattr +t' $testdir
> +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> +before=$(stat -f -c '%b' $testdir)
> +
> +echo "Create some files"
> +_pwrite_byte 0x61 0 1m $testdir/original >> $seqres.full
> +
> +echo "Grow fs"
> +$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
> +_scratch_cycle_mount
> +
> +echo "Recheck 400m rt volume stats"
> +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> +after=$(stat -f -c '%b' $testdir)
> +_within_tolerance "rt volume size" $after $((before * 4)) 5% -v
> +
> +echo "Create more copies to make sure the bitmap really works"
> +cp -p $testdir/original $testdir/copy3
> +
> +echo "Check filesystem"
> +_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/916.out b/tests/xfs/916.out
> new file mode 100644
> index 00000000..55f2356a
> --- /dev/null
> +++ b/tests/xfs/916.out
> @@ -0,0 +1,10 @@
> +QA output created by 916
> +Create fake rt volume
> +Format and mount 100m rt volume
> +Check rt volume stats
> +Create some files
> +Grow fs
> +Recheck 400m rt volume stats
> +rt volume size is in range
> +Create more copies to make sure the bitmap really works
> +Check filesystem
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c75d2b99..74a29bc0 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -528,3 +528,4 @@
>  910 auto quick inobtcount
>  911 auto quick bigtime
>  915 auto quick quota
> +916 auto quick realtime growfs
> 


-- 
chandan



