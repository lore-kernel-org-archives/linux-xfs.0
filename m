Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF8AC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84EAD207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9H9V895"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHROpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:45:54 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D70C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:45:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so14380902ilm.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mjt+8TZR7TO7FOdKstQ/Eblk6z6+DsLiurJicGiPgU4=;
        b=X9H9V895fsUx7ZoNoe+dIQ6K4LYlGhvB+gd4YnuTQmV6v7QsFy0RchvLgHt8swvzM3
         +zSypzXhwvA9dFVq3n9+Fgur7pITLmATkAJa02OXdGaXvlDw8PfWk8cQcpaHtyr/glkj
         WvIZJC3BCldQfQAsa74NH5fEXa05mdqPHX8mdMpe4F0oJHTqBIEWA27RRgcynLvOM+Mf
         2MOaT+0S224eOQVIFRSBiX/bhQC5iX1rfYXP62HwVeeBABQGLStwPm03mqHNKh+3P5T6
         +FFWyrHTEbOHcoB7M33o0mTVxw/5OeifrG06fOfOVx/A9BzBAcZdi74ju5ZDG79KVP2z
         VhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mjt+8TZR7TO7FOdKstQ/Eblk6z6+DsLiurJicGiPgU4=;
        b=q3jzWEaGjBT3HuQRRGE+3kWKEmz2qjYpLj7b5yGxkZSqmk2T77vv4DSfZPOASI3QZy
         G6vkgcVPsLF613usUodhlJmr64HqQQs+7fg6HxLLMvIC8u1/QDwJc7mMeDpug0NsmxvH
         IAZkwj+s0w2p91TLI6RmriERuGFdT6w+zjhS7LAidPxalUmyPjwy7svd5In4Ij3vD4X0
         R/XCslyUmJZjYn+wg4JFIPQCaKvHd1wOE+UcoDN/Dtkg4qMoXC432WPi3qtbw8V6HCx2
         x2fTeDkyzVc+He+0lo4hfmc+MNM6t++VDZmO6J+XdDypJxKKtyNov3voNBBb+ET+xWE6
         MwGA==
X-Gm-Message-State: AOAM531gxGLu9Rpc/goToUf4ojDw9lWWLwjG1MThMbwGpGWSbACy2aYg
        /PHmHHJaxHrgz43WsQEdhw1xOpKe4jiOc1szzqGtJs3y9tA=
X-Google-Smtp-Source: ABdhPJxl3aaLmwwRjfId0LeJuTZb1vjeWyWxFf65qrFDACOJOLTFteNagAEldACfSTKQ89fwIf0OpNi718t2kei5rHI=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr18791199ilj.137.1597761952169;
 Tue, 18 Aug 2020 07:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770524797.3958786.6498012041319904192.stgit@magnolia>
In-Reply-To: <159770524797.3958786.6498012041319904192.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:45:41 +0300
Message-ID: <CAOQ4uxgL9cUm3wqbSgRnRC-uOpDAJ4_KaZA+3CUx5rLDLaY19A@mail.gmail.com>
Subject: Re: [PATCH 18/18] mkfs: format bigtime filesystems
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Allow formatting with large timestamps.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Other than one comment below...

> ---
>  man/man8/mkfs.xfs.8 |   16 ++++++++++++++++
>  mkfs/xfs_mkfs.c     |   24 +++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
>
>
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 082f3ab6c063..7434b9f2b4cd 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -154,6 +154,22 @@ valid
>  are:
>  .RS 1.2i
>  .TP
> +.BI bigtime= value
> +This option enables filesystems that can handle inode timestamps from December
> +1901 to July 2486, and quota timer expirations from January 1970 to July 2486.
> +The value is either 0 to disable the feature, or 1 to enable large timestamps.
> +.IP
> +If this feature is not enabled, the filesystem can only handle timestamps from
> +December 1901 to January 2038, and quota timers from January 1970 to February
> +2106.
> +.IP
> +By default,
> +.B mkfs.xfs
> +will not enable this feature.
> +If the option
> +.B \-m crc=0
> +is used, the large timestamp feature is not supported and is disabled.
> +.TP
>  .BI crc= value
>  This is used to create a filesystem which maintains and checks CRC information
>  in all metadata objects on disk. The value is either 0 to disable the feature,
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 037246effd70..f9f78a020092 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -120,6 +120,7 @@ enum {
>         M_RMAPBT,
>         M_REFLINK,
>         M_INOBTCNT,
> +       M_BIGTIME,
>         M_MAX_OPTS,
>  };
>
> @@ -667,6 +668,7 @@ static struct opt_params mopts = {
>                 [M_RMAPBT] = "rmapbt",
>                 [M_REFLINK] = "reflink",
>                 [M_INOBTCNT] = "inobtcount",
> +               [M_BIGTIME] = "bigtime",
>         },
>         .subopt_params = {
>                 { .index = M_CRC,
> @@ -703,6 +705,12 @@ static struct opt_params mopts = {
>                   .maxval = 1,
>                   .defaultval = 1,
>                 },
> +               { .index = M_BIGTIME,
> +                 .conflicts = { { NULL, LAST_CONFLICT } },
> +                 .minval = 0,
> +                 .maxval = 1,
> +                 .defaultval = 1,

                 .defaultval = 0 ?

Thanks,
Amir.
