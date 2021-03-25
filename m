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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71721C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 09:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E8F619E3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 09:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYJdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 05:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCYJdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 05:33:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D14C06174A;
        Thu, 25 Mar 2021 02:33:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t18so787136pjs.3;
        Thu, 25 Mar 2021 02:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=DghIGvoJvAWU+AmtvRQJyQPHJINq7DxtjJe1w12HlJA=;
        b=q0OHqbgjkOHp+ak66k737yRGNgP6Q17NMhcfSmvhCA30Y+ajxt+gOjMynbTZP2L/xC
         FQC9/1mE98JITVremNQm+5263BueZ2yZ9sFNYLLb0eJJT34pa2HMiHNN0OlqRl/+P2P5
         gatVfetppJdxHxCzuylfPo2cNhFcPUXvQplscRqLVHyF5/fZBdZhzJkz/VqSy1Yk4Bl1
         7/YzgHeHPzMVbHnErGaOGz/SUuzeWp3a92mEPG67zxaTgpBwVo5k9hTaZ1jsIsHEyZst
         8QdXn9ghtl+jnqz4qOCbfdxCfBw8O/bens0ZNaiYKScMz7+1rkQzpFAdKCCVfrPA11tj
         niFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=DghIGvoJvAWU+AmtvRQJyQPHJINq7DxtjJe1w12HlJA=;
        b=N/SWL/3cZqYq6yqvhj51Zbfma9JZR0i6RxAeZbGuIKc2s0JewN8o+EKOgd6IxJeHWk
         WxpKac5FOg5oVTgK5GR3e6dU0CFj4qLITGmtr4FFyikR7aJST9rOlQl6FvTBiwTwGPLi
         4Twu3Lvm5upBDOqq1lPZPOjkzFeEhhr7ruH52jo6RLawmz4iTRtFKTV3sg3dAOzRJxt4
         3+Xp0Qk2TNW0iIS41GzmHc2hl+qR4VSipFo2SmpISAR9+QwuiXBStx6DF3M8h0kw0PMz
         IRai3YZETSksfUWM1DasIpGJHECDrYxqPwSvGx2R1uoQ1seljXEnGwMnhFVogkIQUhRo
         okVg==
X-Gm-Message-State: AOAM53258b2HExfW592LQd8cfd+0VBCWOpb37TSm8iWBI4fYgQU8okjV
        mIKHt3qCGHUTPbGuhKWp7i8=
X-Google-Smtp-Source: ABdhPJykjvAUXQ3ktQVSq5vkMdGXfdzu9e2jqK+XHbT8bbVfonJxnCHEozgCfdis6pGLtu6Eih3ztA==
X-Received: by 2002:a17:90b:681:: with SMTP id m1mr7736667pjz.168.1616664798040;
        Thu, 25 Mar 2021 02:33:18 -0700 (PDT)
Received: from garuda ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id f13sm4838141pfj.8.2021.03.25.02.33.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 02:33:17 -0700 (PDT)
References: <161647321880.3430916.13415014495565709258.stgit@magnolia> <161647322430.3430916.12437291741320143904.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: test the xfs_db path command
In-reply-to: <161647322430.3430916.12437291741320143904.stgit@magnolia>
Date:   Thu, 25 Mar 2021 15:03:14 +0530
Message-ID: <87mturo9wl.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a new test to make sure the xfs_db path command works the way the
> author thinks it should.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/917.out |   19 ++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 118 insertions(+)
>  create mode 100755 tests/xfs/917
>  create mode 100644 tests/xfs/917.out
>
>
> diff --git a/tests/xfs/917 b/tests/xfs/917
> new file mode 100755
> index 00000000..bf21b290
> --- /dev/null
> +++ b/tests/xfs/917
> @@ -0,0 +1,98 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 917
> +#
> +# Make sure the xfs_db path command works the way the author thinks it does.
> +# This means that it can navigate to random inodes, fails on paths that don't
> +# resolve.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_db_command "path"
> +_require_scratch
> +
> +echo "Format filesystem and populate"
> +_scratch_mkfs > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +mkdir $SCRATCH_MNT/a
> +mkdir $SCRATCH_MNT/a/b
> +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
> +ln -s -f c $SCRATCH_MNT/a/d
> +mknod $SCRATCH_MNT/a/e b 8 0
> +ln -s -f b $SCRATCH_MNT/a/f

Later in the test script, there are two checks corresponding to accessibility
of file symlink and dir symlink. However, $SCRATCH_MNT/a/d and
$SCRATCH_MNT/a/f are actually referring to non-existant files since current
working directory at the time of invocation of ln command is the xfstests
directory.

i.e. 'c' and 'b' arguments to 'ln' command above must be qualified with
$SCRATCH_MNT/a/.

> +
> +_scratch_unmount
> +
> +echo "Check xfs_db path on directories"
> +_scratch_xfs_db -c 'path /a' -c print | grep -q 'sfdir.*count.* 5$' || \
> +	echo "Did not find directory /a"
> +
> +_scratch_xfs_db -c 'path /a/b' -c print | grep -q sfdir || \
> +	echo "Did not find empty sf directory /a/b"
> +
> +echo "Check xfs_db path on files"
> +_scratch_xfs_db -c 'path /a/c' -c print | grep -q 'core.size.*61' || \
> +	echo "Did not find 61-byte file /a/c"
> +
> +echo "Check xfs_db path on file symlinks"
> +_scratch_xfs_db -c 'path /a/d' -c print | grep -q symlink || \
> +	echo "Did not find symlink /a/d"
> +
> +echo "Check xfs_db path on bdevs"
> +_scratch_xfs_db -c 'path /a/e' -c print | grep -q 'format.*dev' || \
> +	echo "Did not find bdev /a/e"
> +
> +echo "Check xfs_db path on dir symlinks"
> +_scratch_xfs_db -c 'path /a/f' -c print | grep -q symlink || \
> +	echo "Did not find symlink /a/f"

--
chandan
