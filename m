Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE78C6FA8B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiIUHKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Sep 2022 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIUHJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2022 03:09:46 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628B7832F2;
        Wed, 21 Sep 2022 00:09:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id w2so5086576pfb.0;
        Wed, 21 Sep 2022 00:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EVNWmBaqdWDxG2j2tyHGp3VW7fxSk1kOCKqU1yn/NYc=;
        b=Q9Wyr6FA5NPOU2cj4JdASgo69Lq2aHs2N/43ME1FzoUOgU0shdoCgTjWFkNvRDwBzs
         OGp7cFJS/fdn2UWLnSNemcGgTX8S8lYOCjIV2frrUuCCGioDqRubRflL/Veaio9sTWCQ
         OUSdHYhN4INhm+sLSq4IiGjUQUqaZa1WDNmkC/tIl1r/mT8RGjK7ZHsESLiF+SKNJJQQ
         vekqJfYusTZyd9zB5IYkqVcWIFjUnums0sBlXKsyozKGzK7YEi9RKx8p03IritiTvLkk
         7gc9NNMpmTr1uMwPnHj0iGV9SjfiuCI+6vhw7py+JTupvIz12Zc0eKv1YzGLPhhnOGco
         YDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EVNWmBaqdWDxG2j2tyHGp3VW7fxSk1kOCKqU1yn/NYc=;
        b=5sGYM5if5DlWfDj7B/FRmhr15K2pKpDvRi+EQFNsL1RGdwj8dSZOI2sOAuoE7W5gHh
         KWowW45bX003sKri441H9heNfvjd19hnos6Un8Xgz59w572kS62RPmfDuA5OUqHo0wJ8
         KRu4TpJcBoPI3Mdr4HNxcYox6KlUc+6bkK9l29MJx9FYotLL7b01MxxqQrehCIsK8ipU
         HeS/YiMuJIwtv9chzVDaLk+k0r+gov147xJdETQB3LXTODYKqeTB15hQrcd58af84k47
         04r87IGFDP5lZZjwhkXzYUHmj8EikdhF/dAcxx/QF5Vyqgyeagv1Micu1AYWJfT6HMbs
         k8qg==
X-Gm-Message-State: ACrzQf08awaN/XwM2agQZ2OYByXfyQb31hWXoGV6c1h4xeG8Oe2Lx9B/
        3vwhTsg5K26igthX+Mp3jA7V0I5RSnWdNMzmvrw=
X-Google-Smtp-Source: AMsMyM5Th9KE4RmHUd0kMp0a9l6vqBrYYawaTz1pNWnjqLbVnlQyjc129zCvC/v5nrJrFNZfeOrId4Z4B+ytc0lEB8E=
X-Received: by 2002:a63:c06:0:b0:439:9b18:8574 with SMTP id
 b6-20020a630c06000000b004399b188574mr23101040pgl.608.1663744143394; Wed, 21
 Sep 2022 00:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
 <20220902015018.4036984-1-zlang@kernel.org>
In-Reply-To: <20220902015018.4036984-1-zlang@kernel.org>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 21 Sep 2022 15:08:51 +0800
Message-ID: <CADJHv_tmwP-8_P+GcBf+m3TFehNRPasr3BzX0G9=Rgx3XaF4zA@mail.gmail.com>
Subject: Re: [PATCH v4] generic: new test to verify selinux label of whiteout inode
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good to me!

Regards~

On Fri, Sep 2, 2022 at 9:59 AM Zorro Lang <zlang@kernel.org> wrote:
>
> A bug on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
> apply an selinux label. That's quite different with other fs (e.g.
> ext4, tmpfs).
>
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>
> V3 -> V4:
> 1) Fix a typo
> 2) replace `` with $()
>
> V2 -> V3:
> Rebase to latest fstests for-next branch again
>
> V1 -> V2:
> 1) Add "whiteout" group
> 2) Add commit ID which fix that bug
> 3) Rebase to latest fstests for-next branch
>
> Thanks,
> Zorro
>
>
>  tests/generic/695     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/695.out |  2 ++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/generic/695
>  create mode 100644 tests/generic/695.out
>
> diff --git a/tests/generic/695 b/tests/generic/695
> new file mode 100755
> index 00000000..3f65020a
> --- /dev/null
> +++ b/tests/generic/695
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
> +#
> +# FS QA Test No. 695
> +#
> +# Verify selinux label can be kept after RENAME_WHITEOUT. This is
> +# a regression test for:
> +#   70b589a37e1a ("xfs: add selinux labels to whiteout inodes")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rename attr whiteout
> +
> +# Import common functions.
> +. ./common/attr
> +. ./common/renameat2
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_attrs
> +_require_renameat2 whiteout
> +
> +_fixed_by_kernel_commit 70b589a37e1a \
> +       xfs: add selinux labels to whiteout inodes
> +
> +get_selinux_label()
> +{
> +       local label
> +
> +       label=$(_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p')
> +       if [ ${PIPESTATUS[0]} -ne 0 -o -z "$label" ];then
> +               _fail "Fail to get selinux label: $label"
> +       fi
> +       echo $label
> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +# SELINUX_MOUNT_OPTIONS will be set in common/config if selinux is enabled
> +if [ -z "$SELINUX_MOUNT_OPTIONS" ]; then
> +       _notrun "Require selinux to be enabled"
> +fi
> +# This test need to verify selinux labels in objects, so unset this selinux
> +# mount option
> +export SELINUX_MOUNT_OPTIONS=""
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/f1
> +echo "Before RENAME_WHITEOUT" >> $seqres.full
> +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> +# Expect f1 and f2 have same label after RENAME_WHITEOUT
> +$here/src/renameat2 -w $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
> +echo "After RENAME_WHITEOUT" >> $seqres.full
> +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> +label1=$(get_selinux_label $SCRATCH_MNT/f1)
> +label2=$(get_selinux_label $SCRATCH_MNT/f2)
> +if [ "$label1" != "$label2" ];then
> +       echo "$label1 != $label2"
> +fi
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/695.out b/tests/generic/695.out
> new file mode 100644
> index 00000000..1332ff16
> --- /dev/null
> +++ b/tests/generic/695.out
> @@ -0,0 +1,2 @@
> +QA output created by 695
> +Silence is golden
> --
> 2.31.1
>
