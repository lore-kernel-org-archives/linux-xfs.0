Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:42781 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbeGMKQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 06:16:22 -0400
Received: by mail-yb0-f195.google.com with SMTP id c10-v6so10793269ybf.9
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 03:02:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180713091831.30250-1-cmaiolino@redhat.com>
References: <20180713091831.30250-1-cmaiolino@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Jul 2018 13:02:24 +0300
Message-ID: <CAOQ4uxjUGAGhPAL6EOZ_SmpfKyTL8Sty2Yd7NdAEBM-PQPP1tQ@mail.gmail.com>
Subject: Re: [PATCH] libxfs: Fix a couple of sparse complaints
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 13, 2018 at 12:18 PM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> No significant changes, just silence a couple of sparse errors.
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.h | 2 +-
>  fs/xfs/libxfs/xfs_ialloc.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 4619b554ee90..dc953fc84b2f 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -28,7 +28,7 @@ xfs_ag_resv_rmapbt_alloc(
>         struct xfs_mount        *mp,
>         xfs_agnumber_t          agno)
>  {
> -       struct xfs_alloc_arg    args = {0};
> +       struct xfs_alloc_arg    args = { NULL };

Could you use args = {} instead.

There was a bunch of conversions for such initializes with:
https://lwn.net/Articles/723997/

But regardless, NULL adds no information for compiler.

Thanks,
Amir.
