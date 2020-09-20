Return-Path: <SRS0=mUkO=C5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63ABC43465
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Sep 2020 15:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C46D20897
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Sep 2020 15:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgITPv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Sep 2020 11:51:26 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:48253 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Sep 2020 11:51:25 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07454271|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0507663-0.00145358-0.94778;FP=0|0|0|0|0|-1|-1|-1;HT=e01l07447;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.IZmLs-k_1600617078;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IZmLs-k_1600617078)
          by smtp.aliyun-inc.com(10.147.41.178);
          Sun, 20 Sep 2020 23:51:19 +0800
Date:   Sun, 20 Sep 2020 23:51:18 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com
Subject: Re: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged
 with correct xfs_buf type
Message-ID: <20200920155118.GN3853@desktop>
References: <20200915054748.1765-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915054748.1765-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 11:17:48AM +0530, Chandan Babu R wrote:
> This commit adds a test to check if growing a real-time device can end
> up logging an xfs_buf with the "type" subfield of
> bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> occurs the following call trace is printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> files" is required to fix this issue.

Thanks for the patch! Also thanks to Darrick and Zorro for reviewing!

The test would crash kernel without above fix, so I'd merge it after the
fix landing upstream.

Would you please remind me when the fix is merged by replying this
thread? And perhaps with the correct commit ID updated :)

> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/260     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/260.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 56 insertions(+)
>  create mode 100755 tests/xfs/260
>  create mode 100644 tests/xfs/260.out
> 
> diff --git a/tests/xfs/260 b/tests/xfs/260
> new file mode 100755
> index 00000000..078d4a11
> --- /dev/null
> +++ b/tests/xfs/260
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 260
> +#
> +# Test to check if growing a real-time device can end up logging an xfs_buf with
> +# the "type" subfield of bip->bli_formats->blf_flags set to
> +# XFS_BLFT_UNKNOWN_BUF.
> +#
> +# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
> +# when growing summary/bitmap files".
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_realtime
> +
> +_scratch_mkfs -r size=10M  >> $seqres.full
> +
> +_scratch_mount >> $seqres.full
> +
> +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> +
> +_scratch_unmount

Any reason to do umount manually here? The test harness will umount it
after test anyway.

Thanks,
Eryu

> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> new file mode 100644
> index 00000000..18ca517c
> --- /dev/null
> +++ b/tests/xfs/260.out
> @@ -0,0 +1,2 @@
> +QA output created by 260
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..68676064 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -257,6 +257,7 @@
>  257 auto quick clone
>  258 auto quick clone
>  259 auto quick
> +260 auto quick growfs realtime
>  261 auto quick quota
>  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  263 auto quick quota
> -- 
> 2.28.0
