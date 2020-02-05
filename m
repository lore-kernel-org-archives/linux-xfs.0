Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EABC3524F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8C7321741
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cp2Zmdm1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgBEGfR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 01:35:17 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34766 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgBEGfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 01:35:16 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so901283iof.1;
        Tue, 04 Feb 2020 22:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2W/TQUS2r3/q1tQU8U4tb9k4OFU4GnATVNsAlJ6eoSo=;
        b=Cp2Zmdm1LNXBVV6ZQw6XAgoCeYO4F/VL+PZMkzeu0h0clY+JckTyFE22rT6+0Q0fhj
         SdF5MNIrI7gEMjZyg7IPNxEiqFXTdtMShs49p64gnSYnSvQCOkFgbzhVMwplXeOr1iwd
         7w48dBajCnM0E7j5QxMlD/gRXwDzWUzu5Tt1y/xGmMfg2XSyLQmMFK02teuf+Dk85i7q
         sjA7IBIwp6CF4SJICiOuWagYfXcaKjcYNzasowRPTGnGjqqBmVmIuHmksPhBqf6Pn2hr
         mLVHCRFMWBoGoZTaLea5n2F8Qh4nUP7BGRp1acM/kiwJFukjMaOczfgERVtwBCSKudkN
         6yYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2W/TQUS2r3/q1tQU8U4tb9k4OFU4GnATVNsAlJ6eoSo=;
        b=TuYN2Y4Ze1VXEBMjcG5VowGFBC2HbHDB/qkXexmHwzyG2RwSc3RlohTOdp40zhVU9L
         uyav2lv4c3fiOmLVjUrWWoogKUGaGGkI8OuRaTiZIZoRWeWWt/hyAt5ub1A0TEUZyXFM
         kZAXJO6u09R8hMmdO5MHi0H4mCDveK3E+9FTSFxYDC7eqGOCHD3QARwa/TwJESBzIiNL
         nNd+EBSkRJwC/flHZzN4GjxA3hot5WPSsGwt4ZdYiXnM08EXVyfqbX40w5nXWSDJH4Rq
         1rxYWFgxPCkLk5HiZnvvjEMSSl6zdYQH0dp5c4QOQ+APj+eEs9Yj7vQPjHHemhnqFXZ5
         ou4g==
X-Gm-Message-State: APjAAAWCNAXVSkBtrfoNzrd0nsSBO+8x1Nm1QATKAHN9JPw3OBUpfbUD
        4oj+3pbhoWi2ulVTfCOuXHvsZArQ+e3XZxclO0w=
X-Google-Smtp-Source: APXvYqwhuovg4oyH0u5e/JySsRezJvoRXfkDd2Ro+HQk3YMsephL5vt4JshyXfF8KwxrcKPx36UoWH6u4qeq+myks8c=
X-Received: by 2002:a6b:f214:: with SMTP id q20mr28089826ioh.137.1580884516151;
 Tue, 04 Feb 2020 22:35:16 -0800 (PST)
MIME-Version: 1.0
References: <158086094707.1990521.17646841467136148296.stgit@magnolia> <158086095320.1990521.15734406558551927388.stgit@magnolia>
In-Reply-To: <158086095320.1990521.15734406558551927388.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 5 Feb 2020 08:35:05 +0200
Message-ID: <CAOQ4uxjYZGAMXy+PVpyCr9+hiWt7BrmruLgsG7s2w7Z-4pfpAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: refactor calls to xfs_admin
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 5, 2020 at 2:02 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create a helper to run xfs_admin on the scratch device, then refactor
> all tests to use it.

all tests... heh overstatement :)

Maybe say something about how logdev is needed as argument and
supported only since recent v5.4 xfsprogs.
Does older xfsprogs cope well with the extra argument?

Thanks,
Amir.

>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/config |    1 +
>  common/xfs    |    8 ++++++++
>  tests/xfs/287 |    2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
>
> diff --git a/common/config b/common/config
> index 9a9c7760..1116cb99 100644
> --- a/common/config
> +++ b/common/config
> @@ -154,6 +154,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
>  export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
>  export XFS_REPAIR_PROG="$(type -P xfs_repair)"
>  export XFS_DB_PROG="$(type -P xfs_db)"
> +export XFS_ADMIN_PROG="$(type -P xfs_admin)"
>  export XFS_GROWFS_PROG=$(type -P xfs_growfs)
>  export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
>  export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
> diff --git a/common/xfs b/common/xfs
> index 706ddf85..d9a9784f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -218,6 +218,14 @@ _scratch_xfs_db()
>         $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>  }
>
> +_scratch_xfs_admin()
> +{
> +       local options=("$SCRATCH_DEV")
> +       [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +               options+=("$SCRATCH_LOGDEV")
> +       $XFS_ADMIN_PROG "$@" "${options[@]}"
> +}
> +
>  _scratch_xfs_logprint()
>  {
>         SCRATCH_OPTIONS=""
> diff --git a/tests/xfs/287 b/tests/xfs/287
> index 8dc754a5..f77ed2f1 100755
> --- a/tests/xfs/287
> +++ b/tests/xfs/287
> @@ -70,7 +70,7 @@ $XFS_IO_PROG -r -c "lsproj" $dir/32bit
>  _scratch_unmount
>
>  # Now, enable projid32bit support by xfs_admin
> -xfs_admin -p $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_admin failed"
> +_scratch_xfs_admin -p >> $seqres.full 2>&1 || _fail "xfs_admin failed"
>
>  # Now mount the fs, 32bit project quotas shall be supported, now
>  _qmount_option "pquota"
>
