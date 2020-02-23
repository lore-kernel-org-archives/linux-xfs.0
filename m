Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E174BC35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8BAC20675
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXLY1/QL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWMZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 07:25:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:42734 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBWMZX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 07:25:23 -0500
Received: by mail-il1-f194.google.com with SMTP id x2so5441573ila.9
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 04:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cA+GBj5umivCC6B8WMI8MBphxg9w4aoluT2+6IrlCSM=;
        b=MXLY1/QLBYla7qaNs62NzePczufwMgLFgxjhzz4A9/KvnwhJoWUwX0/Q0nRSGDzwEd
         eanZW+UtuMwQ7yjFlnPBm4nQlruf8mnHo3m1m/TERj3lhRtDkSUO7wbWAP3m7v0YXJXR
         DBu1PCjtR2dGMYfvYHcQIAMAxfhIoSz+Qe1MyR6XwsSJB44ZT5v6XvJALuOqGzBiOktN
         2smer7/x6kvArOXOa6fE8ainG7dDjhaLUasXPbt0Bd4v+07Xn3M6hdf//tSiobYsQAEg
         dAzy49iriMOannlCfzx3RqLPtaqb+zxs5/Jv0u4apM+LEtQ3mBrLTDrXqh9ihZoTgrhk
         rEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cA+GBj5umivCC6B8WMI8MBphxg9w4aoluT2+6IrlCSM=;
        b=WccoSFSU4a4HN1S/FH7x7JV1qhGVrBV27zr23XnINYGglak6+hq7o2QAcPUGQbf2IG
         fy1mgPOyFSG3jOxMrqqoFxt7CXZRw3/F3WfpaUV09dXOHn3HhKX9vUl2kSj1eVaBuRut
         JfOZipTmDIPL9d1BldKoInCtpIToCCXZEz8GcSp6MyOXTdk/paOnJLMrHG5kCpwMDQbS
         8SCFVR6YEnafy6fvAJYL4zQ94VNNHVRUDc+f75n8Mi5iG5Gl1dlN8cs6aVAUmtMqAIR3
         gfiETxsSDIFYP9FH0zBCLHToPGcyMu+FZsHXzHKexdBZA4wru+3EuxMW1i7IFvLrUcak
         i0tQ==
X-Gm-Message-State: APjAAAXAk8J4z43g2OzE7p2bajy4SbLBIa9w3gIS0z3CklFyjhyMxM+w
        S3ttpVsQ3nQe8Hnb7f5BoID/ydmx0SnH7itzcLg=
X-Google-Smtp-Source: APXvYqznPCT/0N6Bchk13xabm0RuyyL9K8W6WT9lpTM9UpeF0uUfWjkbP1JKOLJLQ1hMBIQJpC5zcNwagWEyLR9AgRM=
X-Received: by 2002:a92:8656:: with SMTP id g83mr53242806ild.9.1582460722450;
 Sun, 23 Feb 2020 04:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-5-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-5-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 14:25:11 +0200
Message-ID: <CAOQ4uxiO-1sMa8c5YNmd8+5DQCLN8ioj3cVsUTsuzcq4saTfqQ@mail.gmail.com>
Subject: Re: [PATCH v7 04/19] xfs: Check for -ENOATTR or -EEXIST
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
> Delayed operations cannot return error codes.  So we must check for these conditions
> first before starting set or remove operations
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2255060..a2f812f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -437,6 +437,14 @@ xfs_attr_set(
>                 goto out_trans_cancel;
>
>         xfs_trans_ijoin(args.trans, dp, 0);
> +
> +       error = xfs_has_attr(&args);
> +       if (error == -EEXIST && (name->type & ATTR_CREATE))
> +               goto out_trans_cancel;
> +
> +       if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +               goto out_trans_cancel;
> +

And we do care about other errors?

Thanks,
Amir.
