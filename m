Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08462C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 18:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381397AbiDTSKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiDTSKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 14:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A43F3EB94;
        Wed, 20 Apr 2022 11:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB8161ACE;
        Wed, 20 Apr 2022 18:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B8DC385A4;
        Wed, 20 Apr 2022 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650478086;
        bh=BtEavGAYaFygVq8iIGiatAQRY8CX6oossQfQE1hoHY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B6hJMiefc/J0uzwb3hwis3nfa4BiVhbuKNw9FecUuaN7pFy5tAOSzbS7mBShxOwbS
         HawPosmFaWHMQfh9DAkR/v8ghjvhbLTnulZfOAgTz/bY+Ek/Asx/sVuzyExU3Cz4I5
         5zK6/o396qNwfYvtx58jrRNmMBElIrKTy9jlcvIHedqpzO8R305trS5o08XA25sube
         H9n/LjVZv8UNbPNGkg2jP+CP26Ue2eugQ6bl7VoCvHEyo7iYFWnxF/tiaLGQeA4lyp
         uzxGfiS9BPj1OEGQTiUY4LTuVBsJE42Q4X4ELmfN4X6AdIdvQtF9BCBblulIhWu4PK
         CISLHcQaRjhJw==
Date:   Wed, 20 Apr 2022 11:08:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] fstests: test xfs swapext log replay
Message-ID: <20220420180805.GZ17025@magnolia>
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

Uhoh.  So ... did you write this as a regression test for dc1baa715bbf
and then discovered that it uncovered another problem?

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

I wonder if you could use what _scratch_xfs_populate does to create
S_IFREG.FMT_BTREE instead of open-coding it, but I bet this test
predates that... :)

Anyway, this looks fine but I want to go try it to see what happens.

--D

> +
> +# Make a data fork owner change log
> +$XFS_FSR_PROG -v -d $localfile >> $seqres.full 2>&1
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
