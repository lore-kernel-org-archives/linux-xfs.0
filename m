Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9C2C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18C820637
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:26:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsIdCsj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgBWN0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:26:48 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40875 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgBWN0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:26:48 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so7483606iop.7
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leNHS3BGRZFQqGmHaMruKsZt+HXvGP3zsjECZyHvNfI=;
        b=TsIdCsj8W/+JOVrDP5deM+MsBW0cDkLib46Xi465D0r5VS/VxeSXHNaAe89X7mN/HA
         4oo6KUkTtQscQZ4yvfpb0dHSraG3Lp3pB1jxig9Flzh9b4yS6KkTDwqZzuxDRay44zY9
         mFca3mL4vJ4Cig0zAJDzIhdKbLEsyIDA+S1L3HyZLSmXAg/1SITNJ/WWnGkOn70QDpFE
         D/wq7drkgeZStGg6UwuNzDVLS3S2JsbiZaOCGtYyY0birTF3KAvi2V+YM2koBBlTNOu5
         r6xo06tbxcnysS/S79LXQiR9N5jNwddCDfefHSTu9FT0AdPVmuUrFRJ79bZMWM43tPbN
         ttew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leNHS3BGRZFQqGmHaMruKsZt+HXvGP3zsjECZyHvNfI=;
        b=X6IUZuwAWBRZU4vuoHvyaP9E9mW4MRHL8YOQofvyocOnCpQw+0YpppyqcsX5pFw3jU
         k6Je6bxQDW4P2UTxHTXys9SHFSrdm8ZTOn02jyyJzEpRT2rXzCoRT15u6WmiGLFMtVAV
         cASsbJikKYPUPMuaDk53HYy0KSyb6/aHKT6V+xtuWst+yNOJbz1GntEy3pZsjAPr7SBa
         PbxrpYsvgPUQ11+V7FLDRgbNpNvSrizeDDtzcLlOVLzEWQdIzWcDcWltGbaE48sPAejk
         9pySv5a2CREC5GOCDCS3auRrApnb3y1wcUVwg5JRjP6c0+WM7XBFCW1meUNC8bndvisx
         FepQ==
X-Gm-Message-State: APjAAAUC7X18rBg+ThRZ2KaMjxTuPboQp9DT1G06drY+4dZBjnDo5yG/
        wkGHE9tBD2Dtmyazk/YwlfwMf12L5yRCp8DqKQ3wZ2zB
X-Google-Smtp-Source: APXvYqwtAO4R5nw+dnAidcFLgXRhrvfSpMtL/7fev72EYmtjTUoWKmOWKHyJMtySqhV4ZS8aI8DYJl+qdXcdnOX4a0E=
X-Received: by 2002:a02:cdd9:: with SMTP id m25mr43363422jap.123.1582464407053;
 Sun, 23 Feb 2020 05:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-17-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-17-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:26:36 +0200
Message-ID: <CAOQ4uxhyz28N18tHUQpX_-RkYKip4go5MsuHmc5FJXxBZDM4nQ@mail.gmail.com>
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
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
> Delayed attribute mechanics make frequent use of goto statements.  We can use this
> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
> conditions, we can invert the if logic and jump to the goto. This helps to reduce
> indentation and simplify things.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks better IMO and doesn't change logic.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 29 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 30a16fe..dd935ff 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>  }
>
>  /*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_fmt_needs_update(
> +       struct xfs_inode    *dp)
> +{
> +       return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +             (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +             dp->i_d.di_anextents == 0);
> +}
> +
> +/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>         }
>
>         /*
> -        * If the attribute list is non-existent or a shortform list,
> -        * upgrade it to a single-leaf-block attribute list.
> +        * If the attribute list is already in leaf format, jump straight to
> +        * leaf handling.  Otherwise, try to add the attribute to the shortform
> +        * list; if there's no room then convert the list to leaf format and try
> +        * again.
>          */
> -       if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> -           (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -            dp->i_d.di_anextents == 0)) {
> +       if (!xfs_attr_fmt_needs_update(dp))
> +               goto add_leaf;
>
> -               /*
> -                * Try to add the attr to the attribute list in the inode.
> -                */
> -               error = xfs_attr_try_sf_addname(dp, args);
> +       /*
> +        * Try to add the attr to the attribute list in the inode.
> +        */
> +       error = xfs_attr_try_sf_addname(dp, args);
>
> -               /* Should only be 0, -EEXIST or ENOSPC */
> -               if (error != -ENOSPC)
> -                       return error;
> +       /* Should only be 0, -EEXIST or ENOSPC */
> +       if (error != -ENOSPC)
> +               return error;
>
> -               /*
> -                * It won't fit in the shortform, transform to a leaf block.
> -                * GROT: another possible req'mt for a double-split btree op.
> -                */
> -               error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -               if (error)
> -                       return error;
> +       /*
> +        * It won't fit in the shortform, transform to a leaf block.
> +        * GROT: another possible req'mt for a double-split btree op.
> +        */
> +       error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +       if (error)
> +               return error;
>
> -               /*
> -                * Prevent the leaf buffer from being unlocked so that a
> -                * concurrent AIL push cannot grab the half-baked leaf
> -                * buffer and run into problems with the write verifier.
> -                */
> -               xfs_trans_bhold(args->trans, *leaf_bp);
> -               args->dac.flags |= XFS_DAC_FINISH_TRANS;
> -               args->dac.dela_state = XFS_DAS_ADD_LEAF;
> -               return -EAGAIN;
> -       }
> +       /*
> +        * Prevent the leaf buffer from being unlocked so that a
> +        * concurrent AIL push cannot grab the half-baked leaf
> +        * buffer and run into problems with the write verifier.
> +        */
> +       xfs_trans_bhold(args->trans, *leaf_bp);
> +       args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +       args->dac.dela_state = XFS_DAS_ADD_LEAF;
> +       return -EAGAIN;
>
>  add_leaf:
>
> --
> 2.7.4
>
