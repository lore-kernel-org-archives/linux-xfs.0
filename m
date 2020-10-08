Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA2BC43467
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 08:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A31521927
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 08:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D14W/QhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgJHIM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 04:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgJHIM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 04:12:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0A7C061755;
        Thu,  8 Oct 2020 01:12:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so3614927pgb.10;
        Thu, 08 Oct 2020 01:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VWf/EpVuPrj9F0aLYoRElMXs9Pj1xpKtUoU+xv2Xfkk=;
        b=D14W/QhPRljAdmvPgT7VJfW9/eaUHuHWNuLGpBw1CDCP54NlOr2UlLKRS/pnqhFKGy
         RrPO84ddpOR6rxhsM5v4nzcUZuGDBV73t9xzJsoGBhz3gHt1uNgIqLm8sPJNctKNPQD+
         nS/wDmWTE0SMKeCi2wtEE0B9IHBHfjNaH0OyHprN+l9UL2AffTqQbEghDnZl6NZE31vf
         e9AbW7hKv3zwwnXYnlwOQwWykJSI0oop6TsLGuJ5JwJ9FQqVELWrHzV3d9n6CEg4dMZg
         PJueCazXnhTfZtEF8JTNBIA8wmatt816ZOs6y+AVh2dxrJe3gaUrxjkXl/EOG8HGg1yg
         kDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VWf/EpVuPrj9F0aLYoRElMXs9Pj1xpKtUoU+xv2Xfkk=;
        b=d7dubuISa9K5cq93FlhRDlp4GYxwRUmHbcKWn30Rlb6GKLzhN6X/ae96ej9l5CCY31
         3bMzM3IU2vu7084GYrD75wXZRTZNQm/6g+Qs8qexJk5RrAzmCz3B8V2ovjmtJjTH65Wa
         JssJ8tPWwrbET8pIOlkvofVkOU4DSdDdPKbS4zJGc7K+/LvI08iwj5miC+mhkMCcaRzn
         i5Yu6+6BCVkEuh9iLMf5cPR5a2oMS/q2JqfCxkst3SQ+eHw3qoL3FabDHxbabBoEoasb
         hxbT/eOlymI7s5PrOTK+ChJ6vnyyJzcFlIXmiXZgOzvMRaPLo5XhDGbbrwGvh/rcRE6D
         XbVA==
X-Gm-Message-State: AOAM530uQG2IMQbRaEwkGai9iFb8rYTHeqZt5v0oTxgGUc5HVe+HFc7p
        W5i+oKluMVgkl3qxGtF4QhNOjOmLXM0=
X-Google-Smtp-Source: ABdhPJxSLH5720pD63ZC4oDVp/dP2ktMrVZFKLjdH3hVoWnl6tN9g/pz82GXgVYUdE74DxPT2eYgtA==
X-Received: by 2002:a17:90a:3846:: with SMTP id l6mr6893146pjf.189.1602144775647;
        Thu, 08 Oct 2020 01:12:55 -0700 (PDT)
Received: from garuda.localnet ([122.171.164.182])
        by smtp.gmail.com with ESMTPSA id p22sm5660303pju.48.2020.10.08.01.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 01:12:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com,
        fstests <fstests@vger.kernel.org>, guaneryu@gmail.com
Subject: Re: [RFC PATCH 3/2] xfstest: test running growfs on the realtime volume
Date:   Thu, 08 Oct 2020 13:42:47 +0530
Message-ID: <3221768.e1Acje3bZ6@garuda>
In-Reply-To: <20201008035957.GJ6540@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia> <20201008035957.GJ6540@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 8 October 2020 9:29:57 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we can run growfs to expand the realtime volume without
> it blowing up.  This is a regression test for the following patches:
> 
> xfs: Set xfs_buf type flag when growing summary/bitmap files
> xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
> xfs: fix realtime bitmap/summary file truncation when growing rt volume
> xfs: make xfs_growfs_rt update secondary superblocks
> 
> Because the xfs maintainer realized that no, we have no tests for this
> particular piece of functionality.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Eryu,
We could ignore https://www.spinics.net/lists/linux-xfs/msg44948.html since
the current patch is a superset of the test scenarios verified there.

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/916     |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/916.out |   10 +++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/916
>  create mode 100644 tests/xfs/916.out
> 
> diff --git a/tests/xfs/916 b/tests/xfs/916
> new file mode 100755
> index 00000000..c2484376
> --- /dev/null
> +++ b/tests/xfs/916
> @@ -0,0 +1,81 @@
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
> index ef375397..4e58b5cc 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -549,6 +549,7 @@
>  910 auto quick inobtcount
>  911 auto quick bigtime
>  915 auto quick quota
> +916 auto quick realtime growfs
>  1202 auto quick swapext
>  1208 auto quick swapext
>  1500 dangerous_fuzzers dangerous_bothrepair
> 


-- 
chandan



