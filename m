Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0132CC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8391206ED
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aPjwtCtd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgBWNys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:54:48 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38344 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWNys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:54:48 -0500
Received: by mail-il1-f195.google.com with SMTP id f5so5567518ilq.5
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57RUQai9irDxFEYblVqR6F3q4B9qqIGnoeC6vw+k+Lg=;
        b=aPjwtCtdWSutp2oTViEMG7gc2Pofy7FpzKTq037dWHTKXwDYZVRf2W3muDsnyvtSwJ
         TnIr/ffgxyJY8PArsW3VdGkf7yhjy4FBym7oSBK4vV3uybCAbu2dfijg1ch0WSLNv1pr
         33MbOvoqSVYl8veq2vmSLXDGZq1Aw49ppx1xl/gy4DAodaBnlm5Ghay5NmeF4Hmoi9ER
         IzHrYfOCG+CfcryCYeX72ItXJcSPaCzpmg9c/iWSPV0Q4x0n5/3FmtzCoAzyWTzAXV00
         KHdPTjSXR9whovB0a9Ps0Na3Y2klnr0dlCwlNt7fma/KjxVcgeXzYY9PJNGBoC0zrEA6
         reuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57RUQai9irDxFEYblVqR6F3q4B9qqIGnoeC6vw+k+Lg=;
        b=f+HD+eVo0R9YbaXQR5oo1KB91Zc6bfdcCaENjTGPnlvqUHq58MxL/bnkSuZUadQpO+
         LNaWv2l86spocrFmHBKWP3Frt6Wj0q6cHgS5oj7wnBLcL6nzn3cmG7TVpmqX08j8TBbH
         +dM56Ds2bFy6ZeaTDwZKHHx0IcEHQCxBbLC9IfC0mJaxmOtALGuXH52EGQQ18hWBfEGb
         lRiz7N7GmxOrTfHpo/m5rNOm/598Bba1f2M9I/oI2Q2isJosAtAUW/cIRoRhLDxembRa
         MzlDpI6E54RLcWTXNM8dLqTKMjtX1oqu+HSFfnVhtkH3uPae+IISnXjFW9iJY1gGFacA
         ec5Q==
X-Gm-Message-State: APjAAAXzThutFplNWcqrH+NIp22IhI1pJ1jEui+YDf2oYBKPpVvBop/x
        8rEbNszEoh/rQdvIuQ/SQzE8SjnfGOaOq+GtzyTkbFig
X-Google-Smtp-Source: APXvYqwt+r3zIIt8cowg/qNeXmq9VBmF7icTXuysYo+M7uwLiUF7Sz+Nx86R8huIFHihdmC8JkhkDAb2IQYdZSt1MxI=
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr51309855ili.72.1582466087376;
 Sun, 23 Feb 2020 05:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-20-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-20-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:54:36 +0200
Message-ID: <CAOQ4uxiOE0h6g0ausoxJ2N9ZABh1SDLgt=Cu4Kfn2G7fmnJDHw@mail.gmail.com>
Subject: Re: [PATCH v7 19/19] xfs: Remove xfs_attr_rmtval_remove
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
> xfs_attr_rmtval_remove is no longer used.  Clear it out now
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Patch 12/19 add a new function similar to this one called
xfs_attr_rmtval_unmap() and now this function is removed.
I wonder if it wouldn't have been simpler to keep the original function
name and change its behavior to that of xfs_attr_rmtval_unmap().

Unless the function name change makes the logic change more clear
for the future users???

>  fs/xfs/libxfs/xfs_attr_remote.c | 42 -----------------------------------------
>  fs/xfs/xfs_trace.h              |  1 -
>  2 files changed, 43 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a0e79db..0cc0ec1 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -734,48 +734,6 @@ xfs_attr_rmtval_invalidate(
>  }
>
>  /*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
> -int
> -xfs_attr_rmtval_remove(
> -       struct xfs_da_args      *args)
> -{
> -       xfs_dablk_t             lblkno;
> -       int                     blkcnt;
> -       int                     error = 0;
> -       int                     done = 0;
> -
> -       trace_xfs_attr_rmtval_remove(args);
> -
> -       error = xfs_attr_rmtval_invalidate(args);
> -       if (error)
> -               return error;
> -       /*
> -        * Keep de-allocating extents until the remote-value region is gone.
> -        */
> -       lblkno = args->rmtblkno;
> -       blkcnt = args->rmtblkcnt;
> -       while (!done) {
> -               error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -                                   XFS_BMAPI_ATTRFORK, 1, &done);
> -               if (error)
> -                       return error;
> -               error = xfs_defer_finish(&args->trans);
> -               if (error)
> -                       return error;
> -
> -               /*
> -                * Close out trans and start the next one in the chain.
> -                */
> -               error = xfs_trans_roll_inode(&args->trans, args->dp);
> -               if (error)
> -                       return error;
> -       }
> -       return 0;
> -}
> -
> -/*
>   * Remove the value associated with an attribute by deleting the out-of-line
>   * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>   * transaction and recall the function
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 159b8af..bf9a683 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1775,7 +1775,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>
>  #define DEFINE_DA_EVENT(name) \
>  DEFINE_EVENT(xfs_da_class, name, \
> --
> 2.7.4
>
