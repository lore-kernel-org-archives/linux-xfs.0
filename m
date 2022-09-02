Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C4FECAAD2
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 00:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbiIBAof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 20:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiIBAoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 20:44:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5426FA1D25;
        Thu,  1 Sep 2022 17:44:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v5so375975plo.9;
        Thu, 01 Sep 2022 17:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=E4nPos8j2trGdUyNjY0PKnLHeXxwvnp6sv+OTLgAl0E=;
        b=ZL+ic6+jtFRwUSWCyFZ2r0dFS98Dt65vIvpwBTpMG5BctwnH85/Ne74xvRV9iqN9dT
         C/bP26kue9DaniJ304Xv6VC5T7+OgMOGN07eVk0/7DABR+H6IAP6EHvm/gMJTVWsyBhp
         SkcgckUzhCNwAS66Dha+k67adeTTXbyRDJEbATOETPwPfKEPrk4nOy7RdVndpqUYgRX7
         zdLns7e/t+VYh6oXfVuUuaEg1EGTHq+fbvxlvirMoODjo0i402TgcZ0YahkmSK07wdfU
         YOt1leJWOZoeqlLmq/Aul6qqla2oNUwbVxKS9nIvIWuiHTWh9xiWcqMoeuOxMgFZXmaC
         V91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=E4nPos8j2trGdUyNjY0PKnLHeXxwvnp6sv+OTLgAl0E=;
        b=nytFezD8qqhWYN/IbY9t4FvuEb+piw7wYP0ootJNoHq1NYerIGemZARmMJPS3suozZ
         HKgOi53LHQoZFUnES9/RDrAeuDfV9xNRUkEjA8WEU8SVOt6OcG1TXrI58rVClMHpj4/1
         BRQ2XaYshhYhPY4HiMlmH9AvoCcIhpN2MqiPe5ATW57HfUTxhBzDxxEAAuJ9m1nmirlQ
         S8jn3sJquo6SwEMFbl4r+lHUNmDxRzBUi2lJUp7lRSUvuwK0PDGCMV6UvMz+cpIpDayg
         ta6lE+IEXJJoTaLLMFnJkBhD46n5UWF3VSKFVG6torZaXU/UmafzMiO1keQIHxhH0VPB
         mV5Q==
X-Gm-Message-State: ACgBeo0kNUi7VVIYK69Px9JvAf0qn4pzyjJ3FHzmYTwCKFMQrDNTeP6t
        ySnjUhG7XAhtZdRpRzFWC7Ix/AWgqWXo7577OziUgVpy
X-Google-Smtp-Source: AA6agR5hXCu83Oz9Z5/QKhKKAbnSHRBdja8QIfTPeYoGU2AIDP6s5EJa9wbs3VzbMmBO4ddCSqxxBlENKjrc1xraFQ4=
X-Received: by 2002:a17:902:bd05:b0:172:ae77:1eea with SMTP id
 p5-20020a170902bd0500b00172ae771eeamr32943662pls.158.1662079472802; Thu, 01
 Sep 2022 17:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220901143459.3883118-1-zlang@kernel.org>
In-Reply-To: <20220901143459.3883118-1-zlang@kernel.org>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri, 2 Sep 2022 08:44:21 +0800
Message-ID: <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
Subject: Re: [PATCH v3] generic: new test to verify selinux label of whiteout inode
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 1, 2022 at 10:47 PM Zorro Lang <zlang@kernel.org> wrote:
>
> A but on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
       ^ bug
> apply an selinux label. That's quite different with other fs (e.g.
> ext4, tmpfs).
>
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>
> V1 -> V2:
> 1) Add "whiteout" group
> 2) Add commit ID which fix that bug
> 3) Rebase to latest fstests for-next branch
>
> V2 -> V3:
> Rebase to latest fstests for-next branch again
>
> Thanks,
> Zorro
>
>  tests/generic/695     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/695.out |  2 ++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/generic/695
>  create mode 100644 tests/generic/695.out
>
> diff --git a/tests/generic/695 b/tests/generic/695
> new file mode 100755
> index 00000000..f04d4b3d
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
> +       label=`_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p'`

Just curious, why `` instead of $() ? I see the latter is preferred in
many articles.

Regards~

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
> +label1=`get_selinux_label $SCRATCH_MNT/f1`
> +label2=`get_selinux_label $SCRATCH_MNT/f2`
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
