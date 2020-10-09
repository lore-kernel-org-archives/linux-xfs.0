Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB30C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 10:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A932226B
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 10:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxQdRbjU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgJIKFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbgJIKFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 06:05:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50E4C0613D2;
        Fri,  9 Oct 2020 03:05:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r21so3431933pgj.5;
        Fri, 09 Oct 2020 03:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w8MN9mQeDv9MLLcLgA18vAILXxCgnJ6op4AKN3XdeL4=;
        b=SxQdRbjUKBUyKvs68wDihtGbhmhV/rHK1S9qgtD7wHe0zo9oJBjwueWOzgGNAZs7qO
         gu/Z0ZziYGlkIRgwF0y/cseX8rG6OoZx0vOyUgMW9o8mlpg5WBRBdyzhFrAcn9tw/E6f
         oqLT0OKE0VagiuYSg55af0r758w9ilUGGWkqgQNaJMqym2bZ0Za+e4fdNmW0ajfEmswx
         U+R3jDR+0Ka7m8nWzD94TAFT+qOV8nxl4rTLfbH494HBAPUGFt7PMc9Rq5G5oERB3hmm
         x7254rUcaczhmF6hHdQzlFAP8rUkPNpippzDz6FexwEduKB3UOw9XeS/6QIBvmPgGGrm
         ydiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w8MN9mQeDv9MLLcLgA18vAILXxCgnJ6op4AKN3XdeL4=;
        b=JY/PUKu+KiQrjw6hxKGnbgEgp8sgxylm/Zb3hDevJg0Sgr1sVqmKQsxmhTmV3vFu6y
         Fd0DygNbcRKxyqFT7jMlcOSV1RB+3OkOVQqa8L4ZX+u7pKOEjo9RIyYiALF542jIkkXp
         KOT+28hSON5O7aDl2dtXXVqbgNo8onwfc9S0TmDTgWOCHWxEOVfh9APWgLkKin0YEi1e
         7Qm/LDCpOsXzTbWPkVr595dsvHUCKZtVEJpmRUowkkIQbS7w4RTjJ++1G82HxCeORjOS
         0KEDQ+mnhiVqry/xU1B95g437gDab6Ad+g6Xe3K5R+gY2XoiQ46Hk4/kCaC57hcxZwnU
         3dTQ==
X-Gm-Message-State: AOAM531xVPlZcOK5Wh+KO3SI3okK+sb0xaDQdQ8sck9M3D0lYp3CMJrR
        Qc0WjqQIdPi4JwAg/Aa31wjoZJGjN2U=
X-Google-Smtp-Source: ABdhPJzTM47wIg89Th/5j2hQ9KbgI2fCDbl6tW8xSWSl+EOamNotbWqZp12Ih+4KO6LYVsPRoQgpaw==
X-Received: by 2002:a63:fd03:: with SMTP id d3mr2741166pgh.201.1602237905205;
        Fri, 09 Oct 2020 03:05:05 -0700 (PDT)
Received: from garuda.localnet ([122.171.36.77])
        by smtp.gmail.com with ESMTPSA id z8sm10087862pgr.70.2020.10.09.03.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 03:05:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 4/3] xfstest: test running growfs on the realtime volume
Date:   Fri, 09 Oct 2020 15:35:00 +0530
Message-ID: <2693784.TsUWXn8cSo@garuda>
In-Reply-To: <20201008150551.GM6540@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia> <20201008150551.GM6540@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 8 October 2020 8:35:51 PM IST Darrick J. Wong wrote:
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

Looks good to me.

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



