Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6CDC35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C48208C3
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/Syddto"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgBWMUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 07:20:45 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37558 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBWMUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 07:20:44 -0500
Received: by mail-io1-f66.google.com with SMTP id k24so7402179ioc.4
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 04:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZkcdff2mnFo+jrwTNOGdCmvbLh5lW/jrhmYgrUzPx8=;
        b=Q/SyddtosZs25bRhXekb2CpOWVIC0K5yw59jNYrSEDA/s2XQPPd9W/MPVVONXLbicr
         kH+z2AKu6lj9OadrQVPEgvXIxnNeHR6yWY8NhT6v9nc6JvloKej1AZZlj6Es3U9Bm74a
         rsdrzh0q1mtKHPnw584tuBVZckdLUwRmj8Q0xvryXG54cQYVfS7UDSTUUw4SGFYCs0Kp
         73DLIkOs9i9k0tqOEbyErrmUZ1LwQaIDN+OZqNGvXUPk7F0pRsZlV0iZ9E8KapzEcBWK
         I6pS2PtC/eWILb+8jGxOpxWPL9Yct2nY7/fNlgLTqzTE5OtOir85cQknM2PSlDJazj+g
         zmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZkcdff2mnFo+jrwTNOGdCmvbLh5lW/jrhmYgrUzPx8=;
        b=KDzITG1TX/8SBaoU/Z6V1Cwg+xgcfRylZE0Wee4NyNxZ+sehCZ7eaZEkMJ/YYmGubO
         Bs9VJRf3xRmJ4PJ9b/9f7nd/W0DareN+R2CwcmsQxA2zNQAQCah4DEUmUJ1bMpkipWhV
         e/UubhtCiBimNb1XpnPv+FUmCLOQ1A+fMbWFLRv9huZ/g3XlYg4zUtpYQq2ACAFkxfJ4
         PTyqu7gUxHwuzRwVyjy3ZOzGF1ZB4KUMedUuVLT5MjZYa0RM2OYxeJRO2AVND6Bhf9Pu
         gzrtZ7EIBhoxgb9CgsKAg3ePMIFfWC4d9ZkqnW+wI73atk1kupjXTfvYm+HE7WXiRzTd
         FWlA==
X-Gm-Message-State: APjAAAX+nXXTvEb+WsgLbKRWby++bKVU40dOUZiAFCvzJLJC6uU9c633
        sQxVzS9Q6zdRznwaIseM27MekkQ8IraOIFtI/iBoBFVY
X-Google-Smtp-Source: APXvYqyB0rjYUPU8BFPfB9S4chRt9BNp/G+Y/yghqyYDDUqHCSLVd/2vEex9pPgUwgTxORdI9FA0p2gXQ19Pqs+CtGY=
X-Received: by 2002:a02:cdd9:: with SMTP id m25mr43069778jap.123.1582460443786;
 Sun, 23 Feb 2020 04:20:43 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-4-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-4-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 14:20:32 +0200
Message-ID: <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
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
> From: Allison Henderson <allison.henderson@oracle.com>
>
> This patch adds a new functions to check for the existence of an attribute.
> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> Common code that appears in existing attr add and remove functions have been
> factored out to help reduce the appearance of duplicated code.  We will need these
> routines later for delayed attributes since delayed operations cannot return error
> codes.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>  4 files changed, 188 insertions(+), 98 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9acdb23..2255060 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> +                                struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>
> @@ -310,6 +313,37 @@ xfs_attr_set_args(
>  }
>
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not

This is a very silly return value for a function named has_attr in my taste.
I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
IMO this change looks like a very good opportunity to change that internal
API:

xfs_has_attr?

0: NO
1: YES (or stay with the syscall standard of -ENOATTR)
<0: error

> + */
> +int
> +xfs_has_attr(
> +       struct xfs_da_args      *args)
> +{
> +       struct xfs_inode        *dp = args->dp;
> +       struct xfs_buf          *bp = NULL;
> +       int                     error;
> +
> +       if (!xfs_inode_hasattr(dp))
> +               return -ENOATTR;
> +
> +       if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +               ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +               return xfs_attr_sf_findname(args, NULL, NULL);
> +       }
> +
> +       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +               error = xfs_attr_leaf_hasname(args, &bp);
> +
> +               if (bp)
> +                       xfs_trans_brelse(args->trans, bp);
> +
> +               return error;
> +       }
> +
> +       return xfs_attr_node_hasname(args, NULL);
> +}
> +
> +/*
>   * Remove the attribute specified in @args.
>   */
>  int
> @@ -583,26 +617,20 @@ STATIC int
>  xfs_attr_leaf_addname(
>         struct xfs_da_args      *args)
>  {
> -       struct xfs_inode        *dp;
>         struct xfs_buf          *bp;
>         int                     retval, error, forkoff;
> +       struct xfs_inode        *dp = args->dp;
>
>         trace_xfs_attr_leaf_addname(args);
>
>         /*
> -        * Read the (only) block in the attribute list in.
> -        */
> -       dp = args->dp;
> -       args->blkno = 0;
> -       error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -       if (error)
> -               return error;
> -
> -       /*
>          * Look up the given attribute in the leaf block.  Figure out if
>          * the given flags produce an error or call for an atomic rename.
>          */
> -       retval = xfs_attr3_leaf_lookup_int(bp, args);
> +       retval = xfs_attr_leaf_hasname(args, &bp);
> +       if (retval != -ENOATTR && retval != -EEXIST)
> +               return retval;
> +
>         if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {

Example of how sane code (in my taste) would look like:

       retval = xfs_attr_leaf_hasname(args, &bp);
       if (retval < 0)
               return retval;

        if ((args->name.type & ATTR_REPLACE) && !retval) {
                 xfs_trans_brelse(args->trans, bp);
                 return -ENOATTR;
        } else if (retval) {
                if (args->flags & ATTR_CREATE) {        /* pure create op */
                        xfs_trans_brelse(args->trans, bp);
                        return -EEXIST;
               }

Thanks,
Amir.
