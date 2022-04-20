Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C9DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 22:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348873AbiDTWJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiDTWJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 18:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34B61902A;
        Wed, 20 Apr 2022 15:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49676619C5;
        Wed, 20 Apr 2022 22:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F09C385A0;
        Wed, 20 Apr 2022 22:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650492418;
        bh=OdNdMzb4XhNLLN+k+g/9VKCF49+kjEFYqOhZ8WGLHok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BaJG/pOiGueVhKDwZL3TV+Kk9fdhdoZzYYdUtRuNkiehw//Ea5fLCPFWa3U+uH2M1
         VvmozQ0Chv9g9Y1be36NLFfPsJKPvGYq3TPNlxdh35viGZUKA+ToWa2ewMSZFgi0kF
         9KI3HF39wpadhGVlc4V9LhlqM0zOpAvS/+EUNztuS/56oQl0FsfF5TmxsV26ti/7d8
         tKD9OoJGN9rsFjzuOGb8LCvtpcydbpN9TeImuT6s8kgqQinzBp2YC+aU6t4WXDXblF
         Bj01iQVazNxxTceQiBKNC0L6JOSyt7m+zQHlcoUfwoYnSFKDwEmkyX2mwK8PBVdtpg
         8RUJj+Tc8mdIA==
Date:   Wed, 20 Apr 2022 15:06:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] fstests: test xfs swapext log replay
Message-ID: <20220420220657.GA17025@magnolia>
References: <20220420083653.1031631-1-zlang@redhat.com>
 <20220420083653.1031631-5-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420083653.1031631-5-zlang@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:36:53PM +0800, Zorro Lang wrote:
> If an inode had been in btree format and had a data fork owner change
> logged (XFS_ILOG_DOWNER), after changing the format to non-btree, will
> hit an ASSERT in xfs_recover_inode_owner_change() which enforces that
> if XFS_ILOG_[AD]OWNER is set.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> 3+ years past, this test is still failed on latest upstream linux kernel,
> as we talked below:
> https://patchwork.kernel.org/project/fstests/patch/20181223141721.5318-1-zlang@redhat.com/
> 
> I think it's time to bring it back to talk again. If it's a case issue, I'll fix.
> If it's a bug, means this case is good to merge.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/999     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  2 files changed, 60 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..b1d58671
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# If an inode had been in btree format and had a data fork owner change
> +# logged, after changing the format to non-btree, will hit an ASSERT or
> +# fs corruption.
> +# This case trys to cover: dc1baa715bbf ("xfs: do not log/recover swapext
> +# extent owner changes for deleted inodes")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick fsr
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +. $tmp.mkfs
> +
> +_scratch_mount
> +localfile=$SCRATCH_MNT/fragfile
> +
> +# Try to create a file with 1024 * (3 blocks + 1 hole):
> +# +----------+--------+-------+----------+--------+
> +# | 3 blocks | 1 hole |  ...  | 3 blocks | 1 hole |
> +# +----------+--------+-------+----------+--------+
> +#
> +# The number of extents we can get maybe more or less than 1024, this method
> +# just to get a btree inode format.
> +filesize=$((dbsize * 1024 * 4))
> +for i in `seq $filesize -$dbsize 0`; do
> +	if [ $((i % (3 * dbsize))) -eq 0 ]; then
> +		continue
> +	fi
> +	$XFS_IO_PROG -f -d -c "pwrite $i $dbsize" $localfile >> $seqres.full
> +done
> +
> +# Make a data fork owner change log
> +$XFS_FSR_PROG -v -d $localfile >> $seqres.full 2>&1

Hmm, so I tried this, and found that it fails (as expected) on
-mrmapbt=0 configs with my 5.18-merge branch.

Weirdly, when I tried it with my djwong-dev branch, fsr failed the
XFS_IOC_SWAPEXT with -22 (EINVAL) ... but this program doesn't detect
that, so it "passed".  I even popped all the patches off, but that
didn't change anything.... weird.  I'll keep looking.

--D

> +
> +# Truncate the file to 0, and change the inode format to extent, then shutdown
> +# the fs to keep the XFS_ILOG_DOWNER flag
> +$XFS_IO_PROG -t -x -c "pwrite 0 $dbsize" \
> +	     -c "fsync" \
> +	     -c "shutdown" $localfile >> $seqres.full
> +
> +# Cycle mount, to replay the log
> +_scratch_cycle_mount
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..3b276ca8
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> -- 
> 2.31.1
> 
