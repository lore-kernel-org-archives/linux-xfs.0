Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60026C43381
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 15:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31D1264E2E
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 15:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBGPPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 10:15:38 -0500
Received: from out20-26.mail.aliyun.com ([115.124.20.26]:49851 "EHLO
        out20-26.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBGPPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Feb 2021 10:15:35 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07472572|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0371598-0.000497299-0.962343;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.JWS0h7R_1612710879;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JWS0h7R_1612710879)
          by smtp.aliyun-inc.com(10.147.41.143);
          Sun, 07 Feb 2021 23:14:39 +0800
Date:   Sun, 7 Feb 2021 23:14:39 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test a regression in dquot type checking
Message-ID: <20210207151439.GG2350@desktop>
References: <20210202194158.GR7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202194158.GR7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 11:41:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for incorrect ondisk dquot type checking that
> was introduced in Linux 5.9.  The bug is that we can no longer switch a
> V4 filesystem from having group quotas to having project quotas (or vice
> versa) without logging corruption errors.  That is a valid use case, so
> add a regression test to ensure this can be done.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/766     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/766.out |    5 ++++
>  tests/xfs/group   |    1 +
>  3 files changed, 69 insertions(+)
>  create mode 100755 tests/xfs/766
>  create mode 100644 tests/xfs/766.out
> 
> diff --git a/tests/xfs/766 b/tests/xfs/766
> new file mode 100755
> index 00000000..55bc03af
> --- /dev/null
> +++ b/tests/xfs/766
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 766
> +#
> +# Regression test for incorrect validation of ondisk dquot type flags when
> +# we're switching between group and project quotas while mounting a V4
> +# filesystem.  This test doesn't actually force the creation of a V4 fs because
> +# even V5 filesystems ought to be able to switch between the two without
> +# triggering corruption errors.
> +#
> +# The appropriate XFS patch is:
> +# xfs: fix incorrect root dquot corruption error when switching group/project
> +# quota types
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
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_debug
> +_require_quota
> +_require_scratch

Also need _require_check_dmesg

> +
> +rm -f $seqres.full
> +
> +echo "Format filesystem" | tee -a $seqres.full
> +_scratch_mkfs > $seqres.full
> +
> +echo "Mount with project quota" | tee -a $seqres.full
> +_qmount_option 'prjquota'
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +echo "Mount with group quota" | tee -a $seqres.full
> +_qmount_option 'grpquota'
> +_qmount
> +$here/src/feature -G $SCRATCH_DEV || echo "group quota didn't mount?"
> +
> +echo "Check dmesg for corruption"
> +_check_dmesg_for corruption && \
> +	echo "should not have seen corruption messages"

I'd do the following to print the dmesg in question as well, so we know
what is actually failing the test.

_dmesg_since_test_start | grep corruption

A failure will look like

    --- tests/xfs/527.out       2021-02-07 23:00:46.679485872 +0800
    +++ /root/workspace/xfstests/results//xfs_4k/xfs/527.out.bad        2021-02-07 23:10:16.745371039 +0800
    @@ -3,3 +3,5 @@
     Mount with project quota
     Mount with group quota
     Check dmesg for corruption
    +[1211043.882535] XFS (dm-5): Metadata corruption detected at xfs_dquot_from_disk+0x1b4/0x1f0 [xfs], quota 0
    +[1211043.890173] XFS (dm-5): Metadata corruption detected at xfs_dquot_from_disk+0x1b4/0x1f0 [xfs], quota 0
    ...

I'll fix both on commit.

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/766.out b/tests/xfs/766.out
> new file mode 100644
> index 00000000..18bd99f0
> --- /dev/null
> +++ b/tests/xfs/766.out
> @@ -0,0 +1,5 @@
> +QA output created by 766
> +Format filesystem
> +Mount with project quota
> +Mount with group quota
> +Check dmesg for corruption
> diff --git a/tests/xfs/group b/tests/xfs/group
> index fb78b0d7..cdca04b5 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -545,6 +545,7 @@
>  763 auto quick rw realtime
>  764 auto quick repair
>  765 auto quick quota
> +766 auto quick quota
>  908 auto quick bigtime
>  909 auto quick bigtime quota
>  910 auto quick inobtcount
