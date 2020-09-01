Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBCDC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E04206EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:19:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RwUGH06O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgIAOSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgIAOQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:16:45 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37404C061258;
        Tue,  1 Sep 2020 07:08:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w3so1273837ilh.5;
        Tue, 01 Sep 2020 07:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=td0ICH2xNq/CHmD71me9EyhcsICT9Kh4ztqwaFSKtRI=;
        b=RwUGH06OcU4La3EK0xzsNLfoIvDvnse+yg0P4rwlruB3KnVWUlCSQBGnaP2m28Bsa+
         zzssF32v40X2xkYSeis1Kg0qANnECLljIv1R0u/2UJ2xWKbErzy7WH71Hqwguf2u3KmG
         MX/Rro3QB4KUBvryHorpA7+ak3R3xLtb0xFrUGudHKpwzEObAdSIVDL1YT7qCqry55Bq
         lF3uUserOX+A0Z5ejx1A8NTkP9GbL05mJVG5owYXRLVQoJDVQnIiL57P/lqZHgyau93d
         4leZbhVLUPjYAs5TtLCpthKvKjQ9hAEcGCZ5Kl6N3h7Hfdy/gTgaXp8KTNqZOq2qcLD9
         4T5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=td0ICH2xNq/CHmD71me9EyhcsICT9Kh4ztqwaFSKtRI=;
        b=ew9W5oaFvG0ISAhYoww4ksQhkp9GNAZLGcJDbYaR+kG9pmh4rdAA1+cZN+cEUvq4FS
         +BqEE/aXUsYywf/+V3fnG3OLoOdbTZs+nUDuR7Y1I3XuBfncW55Kthm4gwHv0CRHuBgq
         FKe53hAILqt5BUbDBMjDTohvybhDosuslPGrXugWPXBIroHKqhroJLttcMkWwBbOvGUz
         RY9aaAWadFe8Vj/EBNl8kbaR/GHALhxp+6523PGy6Py0fRTM+HqDzc7YQFA0CemF2Uee
         MLwZNL9tXk3Y3DqTGR0IBz1TjEmRpqGNZGA9eTxw0fChinMx8FO7agHySLzsYA0BqSUY
         ZsXg==
X-Gm-Message-State: AOAM530sTjxnf3ISrbadZcpMAPa2BhydVyafTDo1ZRL9PyHszLpp5zZG
        zc1mrt6ERn9TDUjbVMP3xPcKKEuytzioyRuZkQo=
X-Google-Smtp-Source: ABdhPJwPtb/6O5gixQFSOYIJQtvlD4OGSyFzlmNc7mvdx/m3W25Y1ydrHW7nbIYEx++fsYtxIi5j2u7nwsHlv+o52xk=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr1444630ilj.137.1598969318525;
 Tue, 01 Sep 2020 07:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200901134728.185353-1-bfoster@redhat.com> <20200901134728.185353-4-bfoster@redhat.com>
In-Reply-To: <20200901134728.185353-4-bfoster@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 17:08:27 +0300
Message-ID: <CAOQ4uxhKGUkyEYUsyH=X4YD6EJmu+_FbHhoL+ZtarXqU0NfNkw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] generic/470: use thin volume for dmlogwrites
 target device
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 1, 2020 at 4:48 PM Brian Foster <bfoster@redhat.com> wrote:
>
> dmlogwrites support for XFS depends on discard zeroing support of
> the intended target device. Update the test to use a thin volume and
> allow it to run consistently and reliably on XFS.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>  tests/generic/470 | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/tests/generic/470 b/tests/generic/470
> index fd6da563..c77499a2 100755
> --- a/tests/generic/470
> +++ b/tests/generic/470
> @@ -20,12 +20,14 @@ _cleanup()
>  {
>         cd /
>         _log_writes_cleanup
> +       _dmthin_cleanup
>         rm -f $tmp.*
>  }
>
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/dmthin
>  . ./common/dmlogwrites
>
>  # remove previous $seqres.full before test
> @@ -34,12 +36,21 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs generic
>  _supported_os Linux
> -_require_scratch
> +_require_scratch_nocheck
>  _require_log_writes_dax_mountopt "dax"
> +_require_dm_target thin-pool
>  _require_xfs_io_command "mmap" "-S"
>  _require_xfs_io_command "log_writes"
>
> -_log_writes_init $SCRATCH_DEV
> +devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +csize=$((1024*64 / 512))                # 64k cluster size
> +lowspace=$((1024*1024 / 512))           # 1m low space threshold
> +
> +# Use a thin device to provide deterministic discard behavior. Discards are used
> +# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
> +_dmthin_init $devsize $devsize $csize $lowspace
> +
> +_log_writes_init $DMTHIN_VOL_DEV
>  _log_writes_mkfs >> $seqres.full 2>&1
>  _log_writes_mount -o dax
>
> @@ -52,14 +63,14 @@ $XFS_IO_PROG -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
>  # Unmount the scratch dir and tear down the log writes target
>  _log_writes_unmount
>  _log_writes_remove
> -_check_scratch_fs
> +_dmthin_check_fs
>
>  # destroy previous filesystem so we can be sure our rebuild works
> -_scratch_mkfs >> $seqres.full 2>&1
> +_mkfs_dev $DMTHIN_VOL_DEV >> $seqres.full 2>&1
>
>  # check pre-unmap state
> -_log_writes_replay_log preunmap $SCRATCH_DEV
> -_scratch_mount
> +_log_writes_replay_log preunmap $DMTHIN_VOL_DEV
> +_dmthin_mount
>
>  # We should see $SCRATCH_MNT/test as having 1 MiB in block allocations
>  du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
> --
> 2.25.4
>
