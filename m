Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976F2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574F264DA3
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhBDJiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbhBDJiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:38:01 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9805DC0613ED;
        Thu,  4 Feb 2021 01:37:20 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j2so1730521pgl.0;
        Thu, 04 Feb 2021 01:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/5gkl3c38UWDg0xBgpx8jwGAewr67S+ojSojrag3j4U=;
        b=GzhYxzGnyfLairtegqtesyDQ1unFAeFuGhHpo61FajZUY1VlFw5nFULPBa3jZxJpx1
         D80rPIqr4ORiaYb3wuJLbn0Yah2og5T1/7/ocRD6XlL2MNFpwaSFRFQ7Ff28v8gWloYG
         EIusGBOxxbrg2kvu0NXNEQzMN/FCZRxPZFgDMErEiU4Xlah5W+d2DbJqFT7zZBUlhIsy
         fPbT7VjfuklOvGlYHS/HGovP0K3ULA5aRYbfIBtAP86UeCiBqVCWbDJNpn1mf78fwAJV
         ReO0dALhGmRaLO1MFg/yGVaUhAgOa1+EKhEug8xHr218/j8FONoKOc4Jj5YLrR4vgQmQ
         zjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/5gkl3c38UWDg0xBgpx8jwGAewr67S+ojSojrag3j4U=;
        b=oiYTvysECaOmqA+XOHkP1MKhCtkwRVIP1RewJL8uQJmYBohSaP8Lw3Dy6bftUX0NzE
         WYGhWmVFvLzr7nSjRvY1YproHKmACYPPh+LpTd0gQE62zsLd3tPiUlZCJAhDTzgfOkD1
         AadF+2eW2L+V82Y0JMiTscENxc/ZpcNo4h2amO9GbGGSuW9AFHXnb/Z5oiwYqzcf8j9g
         5Uq0dmIzLDFG5ljmJexcmH9iVMtSVjUKpQ/QG/XDhMrSMsz9xkzoOjV71+TvPULp2zGk
         YsqEGOxps4kScCLXqoIK9U/ndd8XvCCc4qztU3OGjsTEIPUnXjjxy4C3Bv7KrvaXAKfw
         qM+Q==
X-Gm-Message-State: AOAM531n3x1dGeGqRwWpsMlIq5dJHhPzOfv73Z/LzmZ4F+zFyAt6v8Q4
        XAJoRSXJvWYWO5TWNguYF0BT4wEs4Dw=
X-Google-Smtp-Source: ABdhPJyUcR9k5jQghWJ/cTx0fLtcgqjAE8dm1Fk1wFYPtOn5IA3QJxfgt/j82/7eF5SMcSCXXfctAg==
X-Received: by 2002:a63:5a1b:: with SMTP id o27mr7914733pgb.452.1612431440110;
        Thu, 04 Feb 2021 01:37:20 -0800 (PST)
Received: from garuda ([122.167.153.206])
        by smtp.gmail.com with ESMTPSA id t17sm5408562pgk.25.2021.02.04.01.37.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 01:37:19 -0800 (PST)
References: <20210202194158.GR7193@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test a regression in dquot type checking
In-reply-to: <20210202194158.GR7193@magnolia>
Date:   Thu, 04 Feb 2021 15:07:16 +0530
Message-ID: <87sg6cw4vn.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Feb 2021 at 01:11, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> This is a regression test for incorrect ondisk dquot type checking that
> was introduced in Linux 5.9.  The bug is that we can no longer switch a
> V4 filesystem from having group quotas to having project quotas (or vice
> versa) without logging corruption errors.  That is a valid use case, so
> add a regression test to ensure this can be done.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

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


-- 
chandan
