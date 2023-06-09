Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9ACC7EE37
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 01:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjFIBul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 21:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbjFIBuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 21:50:40 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E71BF0;
        Thu,  8 Jun 2023 18:50:38 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-565de553de1so19117327b3.0;
        Thu, 08 Jun 2023 18:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686275438; x=1688867438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PrEVhcdWvGMzkrCkSBgTh4Cw707KJXm+MPnJmxcEkE=;
        b=at1XlIxto6bCYneLO1oRzUZa4vbKvxCANlIJO71p4YzjVt6UF/47baxsmpUlVYdmN/
         +8+wYJkVwodY4o526p5OOZdJSXrYLqq6z3PT6FRxpOVHuCvcvSFEcxG4SpX8dcjiCAcA
         HwrNl3YHVxYzOK7Gr18XIweaPdeHKctwR1vad+VxkCQc/oZRvq11I214SIz7zwMIi+NQ
         bMiLovkflFP6up/5JMMocytiHnCj0a8OLg0x31Tc+U5BXdvKsE/H60pUVGiwpDtNzrzu
         +Tq0o/P4vxC69Hqf8Givq9mBzEReQEEawIYYVRBBbWJF35+/5CtiYnuZpAcYNADVZUWY
         jQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686275438; x=1688867438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PrEVhcdWvGMzkrCkSBgTh4Cw707KJXm+MPnJmxcEkE=;
        b=ds1wxz9i3pU+qH6L5MWlvBcXrF0bT4xt7v77WDnUPjk2SaYg4TVdRO96+3GH8VSSGT
         8QwNWMREY5X4phCXvQ0BUX/T4YOxrJkS92Lvp6oku+GEFPkO+1saaw7G4gzYOywUiKnf
         QOASp0mDPaRwLBdLQKk9L6j6M1+tNtjB6VZjXYGh+zu7iAGJhUFekV1C6+ur1vPqCLun
         oE38QAeDj09ZHb4vS9fWOIB1g1DlbVlaDD++kzUixywlp/nfNvtpNK0DHrvgbk3blFuv
         yOrcSHa5m1SoK5xLlNQhqEtZainKFiQ0C8nxsHL3bsNm9zmVsmroX7GKa/NgEIV3pN2K
         S2tQ==
X-Gm-Message-State: AC+VfDw2NDDFLOfW+4JF79Gqe24d+auN/SoZ1f0LteHkNa2DFc+fLR8L
        /GXtmjIiySuKHGtarmUMFpBlfFbMXz9kTAeXVVBJW3wY
X-Google-Smtp-Source: ACHHUZ4mBu+RxK+bH13tCMdVJdQul+IdNAiaqpKjZe9BNG9G8Gk4K5jolHl7CaVE+oLy8OXwei/zMBYOWVnr2L4QMvs=
X-Received: by 2002:a0d:df09:0:b0:568:b105:751 with SMTP id
 i9-20020a0ddf09000000b00568b1050751mr1710274ywe.2.1686275437733; Thu, 08 Jun
 2023 18:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230531064024.1737213-1-ddouwsma@redhat.com> <20230531064024.1737213-2-ddouwsma@redhat.com>
In-Reply-To: <20230531064024.1737213-2-ddouwsma@redhat.com>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri, 9 Jun 2023 09:50:26 +0800
Message-ID: <CADJHv_v-YUrpT3MA8+2HcWb3B03V87ZQ2b0_pKR+LcAE4-9WUg@mail.gmail.com>
Subject: Re: [PATCH v4] xfstests: add test for xfs_repair progress reporting
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding fstests

On Wed, May 31, 2023 at 2:50=E2=80=AFPM Donald Douwsma <ddouwsma@redhat.com=
> wrote:
>
> Confirm that xfs_repair reports on its progress if -o ag_stride is
> enabled.
>
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Ack.

Thanks,
> ---
> Changes since v3
> - Rebase after tests/xfs/groups removal (tools/convert-group), drop _supp=
orted_os
> - Shorten the delay, remove superfluous dm-delay parameters
> Changes since v2:
> - Fix cleanup handling and function naming
> - Added to auto group
> Changes since v1:
> - Use _scratch_xfs_repair
> - Filter only repair output
> - Make the filter more tolerant of whitespace and plurals
> - Take golden output from 'xfs_repair: fix progress reporting'
>
>  tests/xfs/999     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out | 15 +++++++++++
>  2 files changed, 81 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
>
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..9e799f66
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 521
> +#
> +# Test xfs_repair's progress reporting
> +#
> +. ./common/preamble
> +_begin_fstest auto repair
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +       _cleanup_delay > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/dmdelay
> +. ./common/populate
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +_require_dm_target delay
> +
> +# Filter output specific to the formatters in xfs_repair/progress.c
> +# Ideally we'd like to see hits on anything that matches
> +# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> +filter_repair()
> +{
> +       sed -nre '
> +       s/[0-9]+/#/g;
> +       s/^\s+/ /g;
> +       s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> +       /#:#:#:/p
> +       '
> +}
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +
> +echo "Introduce a dmdelay"
> +_init_delay
> +DELAY_MS=3D38
> +
> +# Introduce a read I/O delay
> +# The default in common/dmdelay is a bit too agressive
> +BLK_DEV_SIZE=3D`blockdev --getsz $SCRATCH_DEV`
> +DELAY_TABLE_RDELAY=3D"0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
> +_load_delay_table $DELAY_READ
> +
> +echo "Run repair"
> +SCRATCH_DEV=3D$DELAY_DEV _scratch_xfs_repair -o ag_stride=3D4 -t 1 2>&1 =
|
> +        tee -a $seqres.full > $tmp.repair
> +
> +cat $tmp.repair | filter_repair | sort -u
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..e27534d8
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,15 @@
> +QA output created by 999
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time {progres}
> + - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minut=
e
> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes don=
e
> + - #:#:#: process known inodes and inode discovery - # of # inodes done
> + - #:#:#: process newly discovered inodes - # of # allocation groups don=
e
> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> + - #:#:#: setting up duplicate extent list - # of # allocation groups do=
ne
> + - #:#:#: verify and correct link counts - # of # allocation groups done
> + - #:#:#: zeroing log - # of # blocks done
> --
> 2.39.3
>
