Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6DCC35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 11:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57B1D20658
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 11:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBdhXs63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgBWLy3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 06:54:29 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:44312 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWLy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 06:54:29 -0500
Received: by mail-il1-f193.google.com with SMTP id s85so5408325ill.11
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 03:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9nQf+haooVNbpA0r7uFVZ/PR4XBUUytUXN+hzccPXw=;
        b=fBdhXs63TFhaKpecHHsKe4IHKsETbXuLdr92WzpVmyUqvv2HFRBsBrWu2Tz3iWs+p9
         h9ySBfnnjauvWg6HxmJnK0SVCj5w0IGXpQ6cOaDoj+K9geJfyVUct3L0fXv7ytwU5SFw
         dmuGPYXb3jdWMiVw+UC20PhCDN0tkcEGe2my18/TtCs5uGwYRAuI+cL6+JljpCR5WZWX
         EqHHs8h+K4gJ1jStnQy71w8rk4scejNKAQwp60f4WwnpO2wa5ZJOyUTmyf4Ntn+I74wn
         1LSYekj7gXCpCSBz7WI5/c19Eq+y/nrEwLK3s2aAa0m3hZfMLQFWX5PUqW/vr5M71Cp2
         kuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9nQf+haooVNbpA0r7uFVZ/PR4XBUUytUXN+hzccPXw=;
        b=cmErB6Yn/m5gA3FGQlQAy91EotAM3PTE4L5YkMtNN4dIgXZBgz52kptzaRvEqfWyAJ
         uOcZ08aFeoeHHV0MNraigd8SOrhCM9kSDq8QM1TP/8RpWegTh9rej4pc2ZxlRHOO1+Y3
         lK0yE7WwzNq2d/E1QnQs8Ecq83w2h9TP29iuxcm+3fh8Pa2z5Qncu2j1U1qMhpfLwZgj
         bYqU2oXAyYQ9i3BQriDh2AtAnihxifMS5M+igMmxKVCV+Cl0tfpHImDjsD/UycxeR6RQ
         VlsChOT5fHjpTV+YuDQl8hOeGe1y5llSiAGESQWAetWrTqrsRT9Brxp05YQwS2+gF9sc
         bwzw==
X-Gm-Message-State: APjAAAXOL2MyRM29usNb0MzScsH2oC9zD18YVsH1RMDy9OHfoFhBKqaG
        2EM6tXfeJ1/4JpcS1JI/9wSV4N1GGgclfAKyS/M7IrOh
X-Google-Smtp-Source: APXvYqx3j4yiF3XIBB3uDabcY0jHJx6AMpH91LonpOH84nfL4xOweYdTy4e71n6WOsxxpIHW6T+kSUtgP188Rw1f0/I=
X-Received: by 2002:a92:8656:: with SMTP id g83mr53065431ild.9.1582458867352;
 Sun, 23 Feb 2020 03:54:27 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-3-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-3-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 13:54:15 +0200
Message-ID: <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
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
> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
> members.  This helps to clean up the xfs_da_args structure and make it more uniform
> with the new xfs_name parameter being passed around.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
>  fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>  fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>  fs/xfs/scrub/attr.c             |  12 ++---
>  fs/xfs/xfs_trace.h              |  20 ++++----
>  12 files changed, 130 insertions(+), 123 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6717f47..9acdb23 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>         args->geo = dp->i_mount->m_attr_geo;
>         args->whichfork = XFS_ATTR_FORK;
>         args->dp = dp;
> -       args->flags = flags;
> -       args->name = name->name;
> -       args->namelen = name->len;
> -       if (args->namelen >= MAXNAMELEN)
> +       memcpy(&args->name, name, sizeof(struct xfs_name));

Maybe xfs_name_copy and xfs_name_equal are in order?

>
> +       /* Use name now stored in args */
> +       name = &args.name;
> +

It seem that the context of these comments be clear in the future.

>         args.value = value;
>         args.valuelen = valuelen;
>         args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> @@ -372,7 +374,7 @@ xfs_attr_set(
>          */
>         if (XFS_IFORK_Q(dp) == 0) {
>                 int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -                       XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
> +                       XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
>
>                 error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
>                 if (error)
> @@ -457,6 +459,9 @@ xfs_attr_remove(
>         if (error)
>                 return error;
>
> +       /* Use name now stored in args */
> +       name = &args.name;
> +
>         /*
>          * we have no control over the attribute names that userspace passes us
>          * to remove, so we have to allow the name lookup prior to attribute
> @@ -532,10 +537,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>         trace_xfs_attr_sf_addname(args);
>
>         retval = xfs_attr_shortform_lookup(args);
> -       if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +       if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>                 return retval;
>         } else if (retval == -EEXIST) {
> -               if (args->flags & ATTR_CREATE)
> +               if (args->name.type & ATTR_CREATE)
>                         return retval;
>                 retval = xfs_attr_shortform_remove(args);
>                 if (retval)
> @@ -545,15 +550,15 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>                  * that the leaf format add routine won't trip over the attr
>                  * not being around.
>                  */
> -               args->flags &= ~ATTR_REPLACE;
> +               args->name.type &= ~ATTR_REPLACE;


This doesn't look good it looks like a hack.

Even if want to avoid growing struct xfs_name we can store two shorts instead
of overloading int type with flags.
type doesn't even need more than a single byte, because XFS_DIR3_FT_WHT
is not used and will never be used on-disk.

Thanks,
Amir.
