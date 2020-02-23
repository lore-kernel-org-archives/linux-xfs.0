Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200C3C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 09:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E44208C3
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 09:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XZNX12hT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWJec (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 04:34:32 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34718 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWJec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 04:34:32 -0500
Received: by mail-il1-f193.google.com with SMTP id l4so5309455ilj.1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 01:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8/eTOPcIj24SMREvH/oNSk2ETljqQnETpVjgtzyX0dA=;
        b=XZNX12hTuUCM5wSB0DQlW77grrJkzCqDU1/eQjlLrqfeDn0T1AUIqBVuLo3McnOIBP
         /w9H1W1m/ZfLiTScdpoW9AR97mGRLY5XqDk3KXWi3RUhupYtEJgVbog9vXAKIdBk4cA4
         v7OQa1eGYBit93JHZ00tdsxCl7eDFIEJUVGl7TOZeENFm8hPdkeztYMRAecEzx+u7McY
         GKNOJmMrtujkR/1+BED9tAK/lpHe5rdbPqvTZerPfMtQgJOI4OSYIegawVCsZyBBwLP8
         qkKYoy+2gkfdK8TKO5Ver7sQsm2unIqRLNN0OumCnQQ5Hfy8gfuBewtSwSzP2wpc8RDX
         ky2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8/eTOPcIj24SMREvH/oNSk2ETljqQnETpVjgtzyX0dA=;
        b=LuCBx4316I/OrkVx+bSi2Lgz3rsTTA6dGErdLq0LaRaKWnmFTs/rQV8wtCO1hzBwHK
         3HiAgOM73TbAus8o57ZdhFFrcS8RVQqk+/0pFaqUnv3Qkq1uyy0D+G0USkyct59TKyku
         5/rprDoekeaVq8W5tihAnmOHfA0pzXUFYv0bik+RXb+RiIVt8PZ/Z676UDgQjMduW52v
         dJ35huyMbqLEFQ+OtLTh/hwPFWd1QtDPWS/YPrFTx/gX3pDgjjNgGUqDDMJlVnWfkEmn
         IASepEEx6Z1afGCONge43seChMY1dxCQlQoyKKzRZDiu8++XZBQzFuYq1oXwtTPl5pLB
         FYyw==
X-Gm-Message-State: APjAAAV2RKyNWlWiqf6jNTUFIjdor3aZUhLqLC9OoqQ9lbgUZH+hTtxB
        dAzce65IVdklW8eamawELdptzlNipFt30EO1FPfmDPtV
X-Google-Smtp-Source: APXvYqwFRH72s2KAmn44KUnFP8EEwUe1TJ690BKdLMIAcHvDaoDPQp5EFfd8A2t6gy5wuUFWtXxhx4SH6IhtfAjzqSc=
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr52717627ilg.137.1582450471424;
 Sun, 23 Feb 2020 01:34:31 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-2-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-2-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 11:34:20 +0200
Message-ID: <CAOQ4uxhmsq9aDPPofS=UPrfcate=h-Jj_Qp95_7-N8_WuDCBTw@mail.gmail.com>
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct xfs_name
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
> This patch replaces the attribute name and length parameters with a single struct
> xfs_name parameter.  This helps to clean up the numbers of parameters being passed
> around and pre-simplifies the code some.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

I realize I am joining very late with lots of reviewed-by already applied,
so unless I find anything big, please regard my comments and possible
future improvements for the extended series rather than objections to this
pretty much baked patch set.

[...]

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d42de92..28c07c9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
>  {
>         unsigned char           *kbuf;
>         int                     error = -EFAULT;
> -       size_t                  namelen;
> +       struct xfs_name         xname;
> +
> +       xfs_name_init(&xname, name);
>
>         if (*len > XFS_XATTR_SIZE_MAX)
>                 return -EINVAL;
> @@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
>         if (!kbuf)
>                 return -ENOMEM;
>
> -       namelen = strlen(name);
> -       error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -                            flags);
> +       error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
>         if (error)
>                 goto out_kfree;
>
> @@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
>  {
>         unsigned char           *kbuf;
>         int                     error;
> -       size_t                  namelen;
> +       struct xfs_name         xname;
> +
> +       xfs_name_init(&xname, name);
>
>         if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>                 return -EPERM;
> @@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
>         if (IS_ERR(kbuf))
>                 return PTR_ERR(kbuf);
>
> -       namelen = strlen(name);
> -       error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> +       error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>         if (!error)
>                 xfs_forget_acl(inode, name, flags);
>         kfree(kbuf);
> @@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
>         uint32_t                flags)
>  {
>         int                     error;
> -       size_t                  namelen;
> +       struct xfs_name         xname;
> +
> +       xfs_name_init(&xname, name);
>
>         if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>                 return -EPERM;
> -       namelen = strlen(name);
> -       error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
> +
> +       error = xfs_attr_remove(XFS_I(inode), &xname, flags);
>         if (!error)
>                 xfs_forget_acl(inode, name, flags);
>         return error;


A struct inititializer macro would have been nice, so code like this:

+       struct xfs_name         xname;
+
+       xfs_name_init(&xname, name);

Would become:
+       struct xfs_name         xname = XFS_NAME_STR_INIT(name);

As a matter of fact, in most of the cases a named local variable is
not needed at
all and the code could be written with an anonymous local struct variable macro:

+       error = xfs_attr_remove(XFS_I(inode), XFS_NAME_STR(name), flags);

Thanks,
Amir.
