Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4B3C35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0059320675
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:30:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9HbsOpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWMaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 07:30:17 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39947 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBWMaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 07:30:17 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so7405459iop.7
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 04:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLinzWobyoiT5rO/uEPkAiWkmmIU5iMPfnS0XhlMg0A=;
        b=L9HbsOpb90rwHWNmUOUrICjz5osYyophsV2d5dKrSYOCMAJacg32xjc+Dz/BFJFQMT
         KgX6w+HOgwtzwk91aTP86kFVR2nVFL4BHil3r2Q5xYWcTd+ZuslhR8X0WkCPuACX9QL+
         eyc5VdLetisJf9MX64uN2yXD+82r/Kokn4OhLV37u0+oRkEItALMdiIgfRvtxdqgjH7J
         HIMhWGVKGGcKxYaTP8I/1rNE1XU6+09PJt4L0XtSJwVjnDlGJRk5ywVt0Zy0z62s2U2Q
         9yaqtMd1SH5exQVnKzuOTBteCMZ6YBshTV/zio32noeRznu8GhzyPHGntTBZZvVajrtD
         dtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLinzWobyoiT5rO/uEPkAiWkmmIU5iMPfnS0XhlMg0A=;
        b=JKsScA9WvY8IoAATEWrJE4BoM/DS2/kHvSEjBipCDEs/NRnR27A0PjZ9a9cfLPVlrm
         mDhtXkjDodxXuXdskNRK0Pslk1JBc0lhpNKekO7EkbMprbyJ5U24urJC6rC4ziI2lOI5
         DJWcDFnLBZWd9RyxXUEEF/Cx0hWZl2zk5Zjm2AO808kedRdVpJVT99CVjZGGBsaAk/oS
         S2hc4xw5EzEYKF/7fsWH02V/kmul5kqkTlszmVV17Mzw30U53oVIg8ixHiAKTPxdqD7t
         Jnx8gB+p/wjeA+MHn6K8eZRXjEvBebvVlOhXl+RYRBCMoN5xoJKZ+13SKVtNRtBhfHGD
         SyzA==
X-Gm-Message-State: APjAAAWSYsbCpbWAMblkEBXvxF3Hr04KCMG0CQ5y7OPUjjABU5/pxCSW
        ggKHORrW5J95UBTpaKIQcvrW5GRSDWbL7jIWX48=
X-Google-Smtp-Source: APXvYqydk6z8sR+u9cQpsvscWIZSVMkgb2olLVfr4+6KjpxQQoAH67PCNsBb2mK/RAJ9j9Ll1KE1dFM/MHGZGvhzNVY=
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr45288267iop.9.1582461016322;
 Sun, 23 Feb 2020 04:30:16 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-7-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-7-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 14:30:05 +0200
Message-ID: <CAOQ4uxjsQSzcTWWvybT2DAkE=DPoek-hGqL0zPZt8EO6oLUdJw@mail.gmail.com>
Subject: Re: [PATCH v7 06/19] xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
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
> Since delayed operations cannot roll transactions, factor up the transaction
> handling into the calling function

I am not a native English speaker, so not sure what the correct phrase is,
but I'm pretty sure its not factor up, nor factor out???

>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  7 +------
>  2 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a2f812f..cf0cba7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -739,6 +739,13 @@ xfs_attr_leaf_addname(
>                 error = xfs_attr3_leaf_flipflags(args);
>                 if (error)
>                         return error;
> +               /*
> +                * Commit the flag value change and start the next trans in
> +                * series.
> +                */
> +               error = xfs_trans_roll_inode(&args->trans, args->dp);
> +               if (error)
> +                       return error;
>
>                 /*
>                  * Dismantle the "old" attribute/value pair by removing
> @@ -1081,6 +1088,13 @@ xfs_attr_node_addname(
>                 error = xfs_attr3_leaf_flipflags(args);
>                 if (error)
>                         goto out;
> +               /*
> +                * Commit the flag value change and start the next trans in
> +                * series
> +                */
> +               error = xfs_trans_roll_inode(&args->trans, args->dp);
> +               if (error)
> +                       goto out;
>
>                 /*
>                  * Dismantle the "old" attribute/value pair by removing
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9d6b68c..d691509 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2973,10 +2973,5 @@ xfs_attr3_leaf_flipflags(
>                          XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>         }
>
> -       /*
> -        * Commit the flag value change and start the next trans in series.
> -        */
> -       error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
> -       return error;
> +       return 0;
>  }
> --
> 2.7.4
>
