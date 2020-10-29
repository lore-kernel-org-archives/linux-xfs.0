Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1213C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 503FA20EDD
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7D1HDXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgJ2Kro (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgJ2Kro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:47:44 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48276C0613CF;
        Thu, 29 Oct 2020 03:47:44 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p15so2852268ioh.0;
        Thu, 29 Oct 2020 03:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QyPMaPPogkqQb6KF2TH3tLk+B1WhML+QEizmrtFJ/dM=;
        b=g7D1HDXGMyHBc4LeReS0HP0JSFXVmCBvuGD1efJHYHYQ+2T68diKETjQE+oXgAodiK
         vlQmkmoJrpT7AxipqCamL3Xe/PSQSSzest2D0cPSWT3pzVuTLffeqhnRDnMhypCeNWVR
         7vxhF+Iz1IPcb2AgvHI8O1dPilVaOfVdYFOn9ISoaB2kJGSwCYn9vdryBAvr8rgUFeQE
         B9+SsfzcP0bpHLGxn08ttyCKJbKeqb5CzqgfbOs/bhtOod5eT7Kry9v15RNDxcw+2Gy/
         DzhkaUaorO4UWe0P95XHcqbDtP4sh3tUkuJOuPwUXxO1xrjQkxwMB480Ozzmd/+FTZcu
         H7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QyPMaPPogkqQb6KF2TH3tLk+B1WhML+QEizmrtFJ/dM=;
        b=uWUBbf4rQYDvWxXEETVaEgurXefHnPbEPSrbm+3EZGP9Ly/ra6qeobaqDxOPXbUHzv
         IMwVrkNFYTXpSUoz7zfuFwd0k/Y7c6m8XOh50rm1Zf/olw9Zf9KEeViNC3WxtEp9QvqH
         nJyTIpMX1WnUcfF9ssQrx1xnOr3lFN4N60LIKlzhbwrOLC36BhrSULVdG4NtMP5TnLeu
         a6VYbVNzRpLy2Km7a8MbX1W5A2zWGz13S3AZeAK/U6lxJL+AEinP621ZrtqhS5oHRio2
         YcoexM995DJsqbR/bmEP6luqSNSnQ3r6d8bxEf6jVax/8tXHfa1LHNzWzq8qbAq/+6ZI
         8WFA==
X-Gm-Message-State: AOAM532UbQAPq6aOZNoB94/Q/zFvEzwdiqnYtTTbkTxkPOd4MJJqHJXD
        JyzaKTscK3zGJyGV5j88Spdr8odkw6D2An0C5tUh0lKq
X-Google-Smtp-Source: ABdhPJwO+wo/3BRTdDKYArok9uHqb/8k6N6P7Gk+D3j3zr7Tfjhuqky4qcXywk8rrg0DsVoANh27iSlyJwu/KgHraOs=
X-Received: by 2002:a05:6638:1351:: with SMTP id u17mr3008733jad.120.1603968463421;
 Thu, 29 Oct 2020 03:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia> <160382545348.1203848.12227735405144915534.stgit@magnolia>
In-Reply-To: <160382545348.1203848.12227735405144915534.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 12:47:32 +0200
Message-ID: <CAOQ4uxhNpej-U-7NjA1VuU3OH=ttT7npwYrzODqThdta5Qka1A@mail.gmail.com>
Subject: Re: [PATCH 3/4] xfs: detect time limits from filesystem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 10:24 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Teach fstests to extract timestamp limits of a filesystem using the new
> xfs_db timelimit command.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc         |    2 +-
>  common/xfs        |   14 ++++++++++++++
>  tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/911.out |   15 +++++++++++++++
>  tests/xfs/group   |    1 +
>  5 files changed, 75 insertions(+), 1 deletion(-)
>  create mode 100755 tests/xfs/911
>  create mode 100644 tests/xfs/911.out
>
>
> diff --git a/common/rc b/common/rc
> index 41f93047..162d957a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2029,7 +2029,7 @@ _filesystem_timestamp_range()
>                 echo "0 $u32max"
>                 ;;
>         xfs)
> -               echo "$s32min $s32max"
> +               _xfs_timestamp_range "$device"
>                 ;;
>         btrfs)
>                 echo "$s64min $s64max"
> diff --git a/common/xfs b/common/xfs
> index e548a0a1..19ccee03 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -994,3 +994,17 @@ _require_xfs_scratch_inobtcount()
>                 _notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
>         _scratch_unmount
>  }
> +
> +_xfs_timestamp_range()
> +{
> +       local use_db=0
> +       local dbprog="$XFS_DB_PROG $device"
> +       test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
> +
> +       $dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
> +       if [ $use_db -eq 0 ]; then
> +               echo "-$((1<<31)) $(((1<<31)-1))"

This embodies an assumption that the tested filesystem does not have
bigtime enabled if xfs_db tool is not uptodate.
Maybe it makes sense, but it may be safer to return "-1 -1" and not_run
generic/402 if xfs_db is not uptodate, perhaps with an extra message
hinting the user to upgrade xfs_db.

Thanks,
Amir.
