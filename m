Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4DAC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B2CA2075E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fzbms95A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHRGQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 02:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgHRGQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 02:16:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA8DC061389;
        Mon, 17 Aug 2020 23:16:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so20089569ioe.5;
        Mon, 17 Aug 2020 23:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wX5l5fWiRv/scGbr9LXATXAyYwy0PIHFLJ5vxXRUvlw=;
        b=Fzbms95AwV4cjbiqWwYKVrySDybK1lK7CmDrStjV4eKtJbsYGCzC6cWsmceAk95VHQ
         TqriT+VkAJwhP32DizVdpJDNmdWKpn+lBr6C2l7v9ohBWyg5/eENZK/VseS3x/LduuEC
         e2LN+uBVIegLzp+D5W8bIaBUavXCMejL2s9k9o7VcYUJHrjo3IuB/pXbbDMv7mfOhUvo
         opz34kd5cqRvUNdqOe+HMQCy8IfkRTD6opT8cGCdsASZMDHEj6gxIvhwjJ9RQCv+wCzp
         gEFjSaJTS/y7LSvHeZ7kIF4H1N4x1cXxzFaoZRKzXfBNcOeDRgxiJHr1Gl+Iyq/6ZqZr
         svmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wX5l5fWiRv/scGbr9LXATXAyYwy0PIHFLJ5vxXRUvlw=;
        b=anpxvhkXntPdnIH9K53dgVBRyAiD0dkadB+c4EXIOGuSLquQmD23tA5g2vzm2/KITx
         IuxAnCDzv35syECK9GGSumvKbaqYfYPCBkK17iB4CP3fGWuEGkhgHXM7tYbDlaAlLMMN
         4vz84JCv11jVa1WgqayfrmtL+uocRD/p/pcOewC5mzmogYWpSjfTIuU2HPJ09Haf2PHU
         DskivRus9OFBed9U29tyuUL3JxxLeSPU19UY0Gc0EDU3082aOYujEZs+sti0HB5nePpI
         zZJYbuxoga3b1DnwZyq72RyGhid5LCuAQAWxBOZ4iitrCbeqwB+EIGfUYQZesgYcbmB4
         pWxw==
X-Gm-Message-State: AOAM530g29mMVNjLfWWYJq+GCoOeDpDSH6rlLXPAdpWxhVhm4dlBuRCo
        o19AuxFt7Gtp0tl49HzqA0VtmFYItXkwK4nCUDM=
X-Google-Smtp-Source: ABdhPJzlBbx6jbkTn9ZCiMt7UGxCaoD/9X2NsGthGHq4SLI8vnDNO9J5RMcZhdYrT1lH/5M5wsBsuK4Wl9xtzkqmCYE=
X-Received: by 2002:a05:6602:1405:: with SMTP id t5mr7868751iov.72.1597731392183;
 Mon, 17 Aug 2020 23:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <159770525400.3960575.11977829712550002800.stgit@magnolia> <159770527916.3960575.1560206777561534458.stgit@magnolia>
In-Reply-To: <159770527916.3960575.1560206777561534458.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 09:16:21 +0300
Message-ID: <CAOQ4uxg9MG8N=hF++y=RtXLo7Up0wM3uF=tC3HW8c2ivWsjqCA@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Test that we can upgrade an existing filesystem to use bigtime.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs        |   16 +++++++++++
>  tests/xfs/908     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/908.out |    3 ++
>  tests/xfs/909     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/909.out |   12 ++++++++
>  tests/xfs/group   |    2 +
>  6 files changed, 184 insertions(+)
>  create mode 100755 tests/xfs/908
>  create mode 100644 tests/xfs/908.out
>  create mode 100755 tests/xfs/909
>  create mode 100644 tests/xfs/909.out
>
>
> diff --git a/common/xfs b/common/xfs
> index 252a5c0d..c0735a51 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -985,3 +985,19 @@ _xfs_timestamp_range()
>                 $dbprog -f -c 'timelimit --compact' | awk '{printf("%s %s", $1, $2);}'
>         fi
>  }
> +
> +_require_xfs_mkfs_bigtime()
> +{
> +       _scratch_mkfs_xfs_supported -m bigtime=1 >/dev/null 2>&1 \
> +          || _notrun "mkfs.xfs doesn't have bigtime feature"
> +}
> +
> +_require_xfs_scratch_bigtime()
> +{
> +       _require_scratch
> +
> +       _scratch_mkfs -m bigtime=1 > /dev/null
> +       _try_scratch_mount || \
> +               _notrun "bigtime not supported by scratch filesystem type: $FSTYP"
> +       _scratch_unmount
> +}
> diff --git a/tests/xfs/908 b/tests/xfs/908
> new file mode 100755
> index 00000000..e313e14b
> --- /dev/null
> +++ b/tests/xfs/908
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
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
> +_supported_os Linux
> +_require_xfs_mkfs_crc
> +_require_xfs_mkfs_bigtime
> +_require_xfs_scratch_bigtime
> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +       _notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +touch $SCRATCH_MNT/a
> +touch $SCRATCH_MNT/b
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime >> $seqres.full
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +# Modify some timestamps
> +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the timestamp survive?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +

Darrick,

These tests look great, but I wonder.
generic/402 has more test coverage than above.
It tests several data points and it tests them with and without mount cycle.

With your current tests, bigtime will enjoy this test coverage only if
the entire
run is configured with custom XFS_MKFS_OPTIONS or when bigtime
becomes default for mkfs.

Do you think we should have a temporary clone of generic/402 for xfs which
enables bigtime for the time being?

Thanks,
Amir.
