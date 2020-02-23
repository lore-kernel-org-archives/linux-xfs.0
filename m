Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3B2C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81647206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q6cOw94F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgBWNp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:45:27 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33877 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWNp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:45:27 -0500
Received: by mail-il1-f196.google.com with SMTP id l4so5565630ilj.1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Caf0GikM43kMq3FnWJqLE/MxuEHJx123zXWtHbjksM=;
        b=q6cOw94FF41A6T9vMjSivr6t70gRl9l3vY+iNOe63A3D856nzdlE14uXVZTJq4EsTy
         qL7+8dp1Rm1UV2ycEt1O2YLjiPWVMrWeuEC0hGbEnbkMwl9VqkmGV2uoF0+8zAzA13qj
         Lxpb4p82+rtg0/HTkhRAZ9cN4oT5XQy3h3v/iNgcfLLFafia/j/c90uxVXbwy5mzFNA/
         vjNd0qliuWmeiUQ6Sxx9Scq25CrjTkR6gqBTfhGOFiV1MH8jWCBadGWBOn0hC68ljg+q
         Dew7VgS+akYNHSm+rDjnpGD8Aa1S4xRyhO53Up4NRs7T5AbwihrHjZ2d3D6XPG2wB3oo
         PLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Caf0GikM43kMq3FnWJqLE/MxuEHJx123zXWtHbjksM=;
        b=d8i9AUNk+3FIE8AZ1O0/LLLAB7ZFJKt/7AuMqZssB3CpLE3c0nNKo5dfRjVYulXdhe
         RTPlspRUJcxwtgghhgv7bzHjcXlQqGduoI+DMLTSStSzOOl39UtEXqs4otvcKwmOVUQv
         Ga1gV4vXpTizj6qXt/fGrfTcyTLsMQpfo7aQBAhfM01ZicOo3nkaH5sdkMkhOsno925W
         dj0Xshv/yEB8eEErtFXCndMu63JPP4WHXS9Wskmj0s3fuN32RThvzczaW4B+PowzNw1h
         AfcU4PJ7bSa450RsXUVTdBzp241FIXiKEm6R3UJ1P3M9t9SVIzU16cXDHL0UF8igY370
         uGBg==
X-Gm-Message-State: APjAAAV25QRtvKeEv7LmCoDY4XNlbBN9pdOWCU2DSKbZPEhl5dgtZHjI
        o6BkCBhJC+R7w7fUqdjtTk/3P5NKXfKQ/7NX+zg=
X-Google-Smtp-Source: APXvYqyM92/4Jdc9ISd1eX63zeiem32TcRGYmCEpL2hzK7Et73kvaHk3OIjDE93FAto4AEaBmHtxHPjhHr7DrHehZ5E=
X-Received: by 2002:a92:d5c3:: with SMTP id d3mr50205273ilq.250.1582465524312;
 Sun, 23 Feb 2020 05:45:24 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-19-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-19-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:45:13 +0200
Message-ID: <CAOQ4uxiFmMUuTi0P6UTdoa+VB9Ru8kqU2Psj9B+iCEbWX21U2w@mail.gmail.com>
Subject: Re: [PATCH v7 18/19] xfs: Add remote block helper functions
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
<allison.henderson@oracle.com> wrote:
>
> This patch adds two new helper functions xfs_attr_store_rmt_blk and
> xfs_attr_restore_rmt_blk. These two helpers assist to remove redunant code

Typo: redunant

> associated with storing and retrieving remote blocks during the attr set operations.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b9728d1..f88be36 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -786,6 +786,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>
> +/* Store info about a remote block */
> +STATIC void
> +xfs_attr_store_rmt_blk(
> +       struct xfs_da_args      *args)
> +{
> +       args->blkno2 = args->blkno;
> +       args->index2 = args->index;
> +       args->rmtblkno2 = args->rmtblkno;
> +       args->rmtblkcnt2 = args->rmtblkcnt;
> +       args->rmtvaluelen2 = args->rmtvaluelen;
> +}
> +
> +/* Set stored info about a remote block */
> +STATIC void
> +xfs_attr_restore_rmt_blk(
> +       struct xfs_da_args      *args)
> +{
> +       args->blkno = args->blkno2;
> +       args->index = args->index2;
> +       args->rmtblkno = args->rmtblkno2;
> +       args->rmtblkcnt = args->rmtblkcnt2;
> +       args->rmtvaluelen = args->rmtvaluelen2;
> +}
> +
>  /*
>   * Tries to add an attribute to an inode in leaf form
>   *
> @@ -824,11 +848,7 @@ xfs_attr_leaf_try_add(
>
>                 /* save the attribute state for later removal*/
>                 args->op_flags |= XFS_DA_OP_RENAME;     /* an atomic rename */
> -               args->blkno2 = args->blkno;             /* set 2nd entry info*/
> -               args->index2 = args->index;
> -               args->rmtblkno2 = args->rmtblkno;
> -               args->rmtblkcnt2 = args->rmtblkcnt;
> -               args->rmtvaluelen2 = args->rmtvaluelen;
> +               xfs_attr_store_rmt_blk(args);

I believe the common naming pattern in the kernel for the helper to match
with xx_restore of state is xxx_save (and not xxx_store).

Otherwise, cleanup looks good and doesn't change logic.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
