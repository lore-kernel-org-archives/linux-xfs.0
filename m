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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B9EC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAE661426
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhDUGTS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 02:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUGTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 02:19:17 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646FCC06174A;
        Tue, 20 Apr 2021 23:18:45 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j12so20144894ils.4;
        Tue, 20 Apr 2021 23:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JoarQnwiLyzbBVFubYATTbTlrhxjF4WctSTPB+u8NAM=;
        b=pB4Sa71By8v0wEZ8Tqc8hpn/mY/X3tDPNJqVnWruV1jPNn4X7RZ8VwyhUtFHQAyr8s
         l6IDL8+DoLEK9jhUh6w0KRPXhSguIhL5SQKuqqZ9946p32Yb4fywroXh+AI+q8HIA5HQ
         rInpusoAQG7/a9ny3QniP6aJZxNBRSgdWJvdyccmje1eCpiAYmE4UvOrhOp26v5VoGQM
         vWhkpfqcroHoIMDd3AD8wJeb+m+czXCozkynJEOKi22HdYaJWc4m5C4nicEd0+y7E4Bn
         8tqvzkLKmyEoTVu44J/zSJKifIOvznAm/DoLxlJ10i5oo+LOaX8N7tI0FzM59mE/GJqj
         tUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JoarQnwiLyzbBVFubYATTbTlrhxjF4WctSTPB+u8NAM=;
        b=JLgh4/1Kgc/bZqrlODWS/ehULLxWDysWMBd92keUA52wmmV8J3/38BLq4BMEsb/rGF
         Z+fPmTvhdqHS8EDboXTxBXFKqoWBkOwGn4aXeJw2VmfQ1mcoYP52swj/l2SQ98h1qbgM
         z/DVg2V0nhNyg8V8G0zKtFl9m4azC01U3wTSexJTFIRrM+B+FlHa4zxZRZHxpeGVQN9C
         Nd9BDBIj5rjvZnO2R3cNMX6bZU3zUTNJaIk5iwta62VrGp1yIfhg6/eUzg/JeBCNsbjz
         6OY1JItjI6MtcUR5lHyIQ57WKlxF0fa6AgVH2H5M0J7dNdtnCKsH9E0Lq9SFaGGfBh/j
         kYHQ==
X-Gm-Message-State: AOAM532UXePZLC49unDWzLobSb3M3I83QHFbTuxzCa41AJMOrA2rDQrw
        UmCGPih+dQk77tu0t/1m8ckof03QBrWAcUa0Yj8=
X-Google-Smtp-Source: ABdhPJx6EM3FIvwBJfjp5/qkh3vz7qdr/zYldP6SL1KjiCaA+41Tn5L9wPiBpq6d4W6uE3rJhGQdMd9lDDvKNd/l0ws=
X-Received: by 2002:a92:de0c:: with SMTP id x12mr25543772ilm.275.1618985924828;
 Tue, 20 Apr 2021 23:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <161896458140.776452.9583732658582318883.stgit@magnolia> <161896460627.776452.15178871770338402214.stgit@magnolia>
In-Reply-To: <161896460627.776452.15178871770338402214.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Apr 2021 09:18:33 +0300
Message-ID: <CAOQ4uxi8Bh8OYS-D6u=+U=uEdaO3EkoHce_rg6-0dyHQhG-sfw@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 3:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Test that we can upgrade an existing filesystem to use bigtime.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   16 ++++++
>  tests/xfs/908     |  117 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/908.out |   29 ++++++++++
>  tests/xfs/909     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/909.out |    6 ++
>  tests/xfs/group   |    2 +
>  6 files changed, 319 insertions(+)
>  create mode 100755 tests/xfs/908
>  create mode 100644 tests/xfs/908.out
>  create mode 100755 tests/xfs/909
>  create mode 100644 tests/xfs/909.out
>
>
> diff --git a/common/xfs b/common/xfs
> index cb6a1978..253a31e5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1184,3 +1184,19 @@ _xfs_timestamp_range()
>                         awk '{printf("%s %s", $1, $2);}'
>         fi
>  }
> +
> +# Require that the scratch device exists, that mkfs can format with bigtime
> +# enabled, that the kernel can mount such a filesystem, and that xfs_info
> +# advertises the presence of that feature.
> +_require_scratch_xfs_bigtime()
> +{
> +       _require_scratch
> +
> +       _scratch_mkfs -m bigtime=1 &>/dev/null || \
> +               _notrun "mkfs.xfs doesn't support bigtime feature"
> +       _try_scratch_mount || \
> +               _notrun "kernel doesn't support xfs bigtime feature"
> +       $XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "bigtime=1" || \
> +               _notrun "bigtime feature not advertised on mount?"
> +       _scratch_unmount
> +}
> diff --git a/tests/xfs/908 b/tests/xfs/908
> new file mode 100755
> index 00000000..004a8563
> --- /dev/null
> +++ b/tests/xfs/908
> @@ -0,0 +1,117 @@
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
> +_require_scratch_xfs_bigtime
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
> +echo after upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# Bump one of the timestamps but stay under 2038
> +touch -d 'Jan 10 19:19:19 UTC 1999' $SCRATCH_MNT/a
> +
> +echo after upgrade and bump:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the bumped timestamp survive the remount?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade, bump, and remount:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# Modify the other timestamp to stretch beyond 2038
> +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> +
> +echo after upgrade and extension:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the timestamp survive the remount?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade, extension, and remount:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/908.out b/tests/xfs/908.out
> new file mode 100644
> index 00000000..5e05854d
> --- /dev/null
> +++ b/tests/xfs/908.out
> @@ -0,0 +1,29 @@
> +QA output created by 908
> +Running xfs_repair to upgrade filesystem.
> +Large timestamp feature only supported on V5 filesystems.
> +FEATURES: BIGTIME:NO
> +Running xfs_repair to upgrade filesystem.
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Adding large timestamp support to filesystem.
> +before upgrade:
> +915909559
> +915909559
> +Running xfs_repair to upgrade filesystem.
> +Adding large timestamp support to filesystem.
> +FEATURES: BIGTIME:YES
> +after upgrade:
> +915909559
> +915909559
> +after upgrade and bump:
> +915995959
> +915909559
> +after upgrade, bump, and remount:
> +915995959
> +915909559

Did you design those following days timestamps to look so cool? ;-)

> +after upgrade and extension:
> +915995959
> +7956915742
> +after upgrade, extension, and remount:
> +915995959
> +7956915742

Consider this test reviewed-by-me
I'd like more eyes on the quota grace period test, so not providing
a reviewed-by tag for the entire patch.

Thanks,
Amir.
