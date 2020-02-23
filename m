Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262A0C35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED62A20637
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+T1+psz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWNWm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:22:42 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46785 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgBWNWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:22:42 -0500
Received: by mail-il1-f193.google.com with SMTP id t17so5493516ilm.13
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IW9hWTBsV0/lqj6cAcRAdo4UJD0RJNx/j/uhU1FjvR8=;
        b=W+T1+pszDRuQfSOmw+HgvQjYjVftnUTlSNJiL77gpifyu8sOitIoIPAqi0WNA/MKcl
         2ITewdrXSyDUoyzhqBUDBsdxyUtEV5HVWmhINXwgZPhT9SRsVdaNfgvUSIXK01GIMgTH
         sWUTWjvjWzhME5KZD5aaqVCTjDZ4wvIDycdwlwis5RO37FD9moUdu80vPyeMI7rCgJYq
         1B3V9fjz1EzaDM9Z+Iw/ZZxc6t77CnrHCbMq+YuCOy3MTEgzBUf2pkK2iQpKwAafUbIf
         KujbYuhEGsIqk9lv0MAcMbyO8k96spmO2tb1dwkyCbaoq8nan8uvpejOrWFjg8i2GOpU
         OUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IW9hWTBsV0/lqj6cAcRAdo4UJD0RJNx/j/uhU1FjvR8=;
        b=EQcLOWPOFVz9eWxzYvxSK7AruQIr4v2Cc4IPsKQRgeh3TSfDyp0QaG5EUu9i9V1+6/
         +lcQzpoXgDKeS/TaxyuCcsYNZ2gGPaN9sbzlzXOiTbJ7N4YkD6UN+lxXZjsQSaXadKWh
         aQ8IlZA4X+BdpeOPsUOVZPx3bqupgs3UYL4eykagwtS1vs0QO44FjcSsTxceD23Nv/Bj
         M8Du9SKu3LTLhVsVIap0f/QVjovYuqywKcbTzUSSVnkJ/7E9eWHAHinDlNSLbig1HimD
         HZgm1lzX9bxWP3UkzmyJ+E48JWR9VB6VOYNPg6KXVYjh6xSWStU1RRVyvVqrhHVysCd2
         N/pw==
X-Gm-Message-State: APjAAAXGKIEkYun++LJvLu0L1Lvf1mfclTluysL02yFC20t3nLeXWn0l
        jdM887/EnMNsKXB8VYZsLM6RzAWVUffBD9Eezax0rGXS
X-Google-Smtp-Source: APXvYqzRajikonmDqyws3BSSqtjwyWU4lencQOPYjmVNwrEHX+OdG5riFpIWCU4Tb1qKQt4xjc+EqduElHEwpjgeXfU=
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr51157628ili.72.1582464161731;
 Sun, 23 Feb 2020 05:22:41 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-16-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-16-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:22:30 +0200
Message-ID: <CAOQ4uxhyhoKwBejwi96BM1EWgsFC7918S_ydY4c9MFEmML7iKQ@mail.gmail.com>
Subject: Re: [PATCH v7 15/19] xfs: Add helper function xfs_attr_node_shrink
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
> This patch adds a new helper function xfs_attr_node_shrink used to shrink an
> attr name into an inode if it is small enough.  This helps to modularize
> the greater calling function xfs_attr_node_removename.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 66 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 40 insertions(+), 26 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4b788f2..30a16fe 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1366,6 +1366,43 @@ xfs_attr_node_addname(
>  }
>
>  /*
> + * Shrink an attribute from leaf to shortform
> + */
> +STATIC int
> +xfs_attr_node_shrink(
> +       struct xfs_da_args      *args,
> +       struct xfs_da_state     *state)
> +{
> +       struct xfs_inode        *dp = args->dp;
> +       int                     error, forkoff;
> +       struct xfs_buf          *bp;
> +
> +       /*
> +        * Have to get rid of the copy of this dabuf in the state.
> +        */
> +       ASSERT(state->path.active == 1);
> +       ASSERT(state->path.blk[0].bp);
> +       state->path.blk[0].bp = NULL;
> +
> +       error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +       if (error)
> +               return error;
> +
> +       forkoff = xfs_attr_shortform_allfit(bp, dp);
> +       if (forkoff) {
> +               error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +               /* bp is gone due to xfs_da_shrink_inode */
> +               if (error)
> +                       return error;
> +
> +               args->dac.flags |= XFS_DAC_FINISH_TRANS;

Why did xfs_defer_finish(&args->trans); turn into the above?

Are you testing reviewers alertness? ;-)
Please keep logic preserving patches separate from logic change patches.

Thanks,
Amir.

> +       } else
> +               xfs_trans_brelse(args->trans, bp);
> +
> +       return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1383,8 +1420,7 @@ xfs_attr_node_removename(
>  {
>         struct xfs_da_state     *state;
>         struct xfs_da_state_blk *blk;
> -       struct xfs_buf          *bp;
> -       int                     retval, error, forkoff;
> +       int                     retval, error;
>         struct xfs_inode        *dp = args->dp;
>
>         trace_xfs_attr_node_removename(args);
> @@ -1493,30 +1529,8 @@ xfs_attr_node_removename(
>         /*
>          * If the result is small enough, push it all into the inode.
>          */
> -       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -               /*
> -                * Have to get rid of the copy of this dabuf in the state.
> -                */
> -               ASSERT(state->path.active == 1);
> -               ASSERT(state->path.blk[0].bp);
> -               state->path.blk[0].bp = NULL;
> -
> -               error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -               if (error)
> -                       goto out;
> -
> -               if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -                       /* bp is gone due to xfs_da_shrink_inode */
> -                       if (error)
> -                               goto out;
> -                       error = xfs_defer_finish(&args->trans);
> -                       if (error)
> -                               goto out;
> -               } else
> -                       xfs_trans_brelse(args->trans, bp);
> -       }
> -       error = 0;
> +       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +               error = xfs_attr_node_shrink(args, state);
>
>  out:
>         if (state)
> --
> 2.7.4
>
