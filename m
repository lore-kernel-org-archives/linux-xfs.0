Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899CDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 09:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AD94619B9
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 09:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhCaJuC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhCaJtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 05:49:45 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7678DC061574;
        Wed, 31 Mar 2021 02:49:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id x17so19484431iog.2;
        Wed, 31 Mar 2021 02:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aaJMZy3b3Zf4CYTDyQY8Itb9A5kuWPvR2INVbpLL+6U=;
        b=OEvfLH+LglD42VvIe9vBy6o5BpqBQJCqDAtDAADfuGp9wTvHzwm/ZMHxUhZW6WELNN
         N5YSdgxZq/i6R6XMHgX4lsi4Aicc8HTuyJqrM31SiXS+sgmuoqfYhaVUK5++O66KlAQA
         o8OGRpBKj7OXldhSGpQmw0vbdWNIKD8VH21v7J/p/CvKKFbXrVGm+FtQV5cywe2WRLcb
         UVbYYIY0Pra/s5GvMRdx9WON8cC4loLMuFgOkPE68QVgqgY9SuzYES1QJqkJMfxLkCYn
         ENtNMdTTZXsXLarf8McajnD8TO01pk0e3tL+r44G3jmhXLEEve6VcMcRjut4dQM0aBLO
         8Vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaJMZy3b3Zf4CYTDyQY8Itb9A5kuWPvR2INVbpLL+6U=;
        b=gZ/afqb+5IOSRXxkldHHAq1X+xtTXC09Q+fy80eZNwRL6iraAcG49ZoIkvUO+jdiKX
         LlB2P/R+qY16cYFXNdEjOKWTqbr9EscAYA52vhPx4OAt2U2DSEDcxqYr4HThQNUXbtbc
         9SNDXGSs17hZuWj0R/7NTD+96HYxjC4zWhLML1mr9GpCVk1Mx1/TqLsRqoU1F6P2ptcb
         rXepa6wsJcpUHhL7QofYJHOpD5d8NQGkJWRfAz7qX/KKdSPRQKbZtUVkq9frX9f+EKNj
         +Dxsidvst20OjBnOJxQt5WeLdVyTsxWmu03A1FSbWbgc3fnraGfeGU1WS13p3N9AybuY
         43IQ==
X-Gm-Message-State: AOAM530ABOqOGRazDPP/HCX61cv96cilzhx78Al8l+ayabZfArWjXVpG
        nQkqKTigJzVu5IUoGv0uHl/tjj20F88DZgm8/jc=
X-Google-Smtp-Source: ABdhPJx6UVr5FP579yj2K7KlaZnfqPvFjUNRD5mz1tvyfb8s0DK0x5Xjtsd9nqEeFU3xonTPop/m7RSd9A6du3BhPpQ=
X-Received: by 2002:a02:ccb2:: with SMTP id t18mr2198223jap.123.1617184184808;
 Wed, 31 Mar 2021 02:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <161715291588.2703979.11541640936666929011.stgit@magnolia> <161715293790.2703979.8248551223530213245.stgit@magnolia>
In-Reply-To: <161715293790.2703979.8248551223530213245.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 31 Mar 2021 12:49:32 +0300
Message-ID: <CAOQ4uxgCzwxv1xYYM-k-gsHnkyWxU_KzjTHRS3RyJf775R06SQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 4:11 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Test that we can upgrade an existing filesystem to use bigtime.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   13 +++++
>  tests/xfs/908     |   97 +++++++++++++++++++++++++++++++++++
>  tests/xfs/908.out |   20 +++++++
>  tests/xfs/909     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/909.out |    6 ++
>  tests/xfs/group   |    2 +
>  6 files changed, 287 insertions(+)
>  create mode 100755 tests/xfs/908
>  create mode 100644 tests/xfs/908.out
>  create mode 100755 tests/xfs/909
>  create mode 100644 tests/xfs/909.out
>
>
> diff --git a/common/xfs b/common/xfs
> index 37658788..c430b3ac 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1152,3 +1152,16 @@ _xfs_timestamp_range()
>                         awk '{printf("%s %s", $1, $2);}'
>         fi
>  }
> +
> +_require_xfs_scratch_bigtime()
> +{
> +       _require_scratch
> +
> +       _scratch_mkfs -m bigtime=1 &>/dev/null || \
> +               _notrun "mkfs.xfs doesn't have bigtime feature"
> +       _try_scratch_mount || \
> +               _notrun "bigtime not supported by scratch filesystem type: $FSTYP"
> +       $XFS_INFO_PROG "$SCRATCH_MNT" | grep -q "bigtime=1" || \
> +               _notrun "bigtime feature not advertised on mount?"
> +       _scratch_unmount
> +}
> diff --git a/tests/xfs/908 b/tests/xfs/908
> new file mode 100755
> index 00000000..1ad3131a
> --- /dev/null
> +++ b/tests/xfs/908
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 908
> +#
> +# Check that we can upgrade a filesystem to support bigtime and that inode
> +# timestamps work properly after the upgrade.
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
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_scratch_bigtime
> +_require_xfs_repair_upgrade bigtime
> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +       _notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Make sure we can't upgrade a V4 filesystem
> +_scratch_mkfs -m crc=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +
> +# Make sure we're required to specify a feature status
> +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime 2>> $seqres.full
> +
> +# Can we add bigtime and inobtcount at the same time?
> +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime=1,inobtcount=1 2>> $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/a
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/b
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo before upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +# Modify one of the timestamps to stretch beyond 2038
> +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> +
> +echo after upgrade:

There is an oddity in the output.
The text says "after upgrade" but the timestampt of b has changed because
it is really "after upgrade and stretch". Did you mean to print to output
"after upgrade" and then again "after upgrade and stretch"?

Thanks,
Amir.
