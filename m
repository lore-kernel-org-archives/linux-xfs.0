Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8B7C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA28206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEjHuihZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWNrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:47:31 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46708 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWNrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:47:31 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so7475765ioi.13
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2gHaWvkNiWezbWrPnXNqBUULjHaHGcDDd/aLBymPE0Y=;
        b=WEjHuihZJqCLhMpZWre4OtWKaRluUMztCTa9ltYC1ut6vwhj8Q0ow5TxNJJTay4he1
         w6kYwMPkPepLYvzKUZya6hWOlGGIJ+5B38b84Z8ZThR/xHz4kAMX3WAKC57fujo2bGpv
         nD5W66g0DwQJEsau9w9hVN8K1L3NpkaH/BgS4DIStmKysQTfXGnz8rqjXU3GMPfO6sC4
         rDtgcQsPLWtOjYHMsrzFYkroBlcKj2k9bzauFaZBKltg6UsT9+KjiSDA3V8BbOlsagIQ
         vQ2zjW/C+jCCiUtM1NXP9pGT4blDo8JzPfRUqtrcIqJFBnkyKqSALHC9ODMR3WozdVWj
         MixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2gHaWvkNiWezbWrPnXNqBUULjHaHGcDDd/aLBymPE0Y=;
        b=payZCsMARIUqE/ON5aiNSlTljOSSNHGtT39rCbpiOxKEX0wkwH1lCgg01Knu1paoQB
         kdwsBk3lz98HGU1g8kv0hZM+vUUX4lS13jO7vpVAZcV8/KBdOoqSV7kPCpRKmjEvxwPy
         o3CyQb0f4JYaP12sQlx4kuSpFk6/GR/XoocRKNzHK57Bw4+9mDfclLa3Fk5IU0CJ73OJ
         07we6dhDMGRrSdzkP92BmWlTCmYu4Ui3/nFphHR65sLLkyrrvcebCxdQjoR1g5ZZ2A+n
         Y9whzFwMXER212w8sIAWZeXqXQGn6E4SJQecwnFLgGTLoBETooIaWr3pIK337FIt8Kaz
         +adg==
X-Gm-Message-State: APjAAAXoYKtml1wat7qggHfDSyq/xVPDbX9lmRVz9sxIDvFWGBUX2kly
        om+OBnNaWEmf0eusUebdvRScuzdSUBuvV3q1GVg=
X-Google-Smtp-Source: APXvYqxj9qrriUmlfQQcbZsPnO0Ox1UL9n7wm3TsxSFBa5S5362ktf1oxfbRGhVTYgr9Z/WNdTYt0vABKEnTlRW2QsI=
X-Received: by 2002:a6b:d019:: with SMTP id x25mr43977133ioa.275.1582465650291;
 Sun, 23 Feb 2020 05:47:30 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-18-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-18-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:47:19 +0200
Message-ID: <CAOQ4uxh-ybRSFX4v3x6m6H0+8iC7Guoa5_tAoF1Drpw8Q5sOuw@mail.gmail.com>
Subject: Re: [PATCH v7 17/19] xfs: Add helper function xfs_attr_leaf_mark_incomplete
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
> This patch helps to simplify xfs_attr_node_removename by modularizing the code
> around the transactions into helper functions.  This will make the function easier
> to follow when we introduce delayed attributes.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Found no surprises here, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index dd935ff..b9728d1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1416,6 +1416,36 @@ xfs_attr_node_shrink(
>  }
>
>  /*
> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> + * for later deletion of the entry.
> + */
> +STATIC int
> +xfs_attr_leaf_mark_incomplete(
> +       struct xfs_da_args      *args,
> +       struct xfs_da_state     *state)
> +{
> +       int error;
> +
> +       /*
> +        * Fill in disk block numbers in the state structure
> +        * so that we can get the buffers back after we commit
> +        * several transactions in the following calls.
> +        */
> +       error = xfs_attr_fillstate(state);
> +       if (error)
> +               return error;
> +
> +       /*
> +        * Mark the attribute as INCOMPLETE
> +        */
> +       error = xfs_attr3_leaf_setflag(args);
> +       if (error)
> +               return error;
> +
> +       return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1473,20 +1503,7 @@ xfs_attr_node_removename(
>         args->dac.da_state = state;
>
>         if (args->rmtblkno > 0) {
> -               /*
> -                * Fill in disk block numbers in the state structure
> -                * so that we can get the buffers back after we commit
> -                * several transactions in the following calls.
> -                */
> -               error = xfs_attr_fillstate(state);
> -               if (error)
> -                       goto out;
> -
> -               /*
> -                * Mark the attribute as INCOMPLETE, then bunmapi() the
> -                * remote value.
> -                */
> -               error = xfs_attr3_leaf_setflag(args);
> +               error = xfs_attr_leaf_mark_incomplete(args, state);
>                 if (error)
>                         goto out;
>
> --
> 2.7.4
>
