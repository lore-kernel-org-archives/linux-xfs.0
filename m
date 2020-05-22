Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EEDC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14386207FB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xsxbz4/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgEVHld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 03:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgEVHld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 03:41:33 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF9C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:41:33 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id 4so9837776ilg.1
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etGwsrNdc96w4KKXCIFVLlVeZjT26Y0TJko8CtPBz7o=;
        b=Xsxbz4/6Pw61mLVBop5P0t+amShteZU/3v4lbSN49Xw6dNTFWYNagdBYNsiURu4uN8
         aiN3Y3VP8ROEXSy65PFkK3MkdlYzxZMs6MTiyfZFygy9lnIjkpMWdhjtuOF198X/InEY
         9XdniRUrAGzXwNNHr2FziMyjKajLkY+b7z+BA20KlgqIKcCCR0IWHg+taCik46nsfP2q
         JZtcAfxcEEmodD65dIsdX/ztU8h8pxcolmmioIpcf0xmAd2Y3IGNMYD+nEtJaHhCArMi
         zLFNQo63GxipjaTq7Xy366CdUrtFmyuTWOqz4iam1ZmrdaNO75ibPL0Xjbz5Dxzcgz3B
         SzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etGwsrNdc96w4KKXCIFVLlVeZjT26Y0TJko8CtPBz7o=;
        b=IxJPYCm1ok9XljoOugqXZyk6sdSQOoEJcZOycY4l5j3X2bYmM0h4oCBlZ7z5mFYWtx
         d6YPBSthvD8Lw85m+Nl78nI0lrDJZEIydrBdPkig3j8BEOF2ma+bznonMCJ8R+EWYzD6
         Ipy0fQR2TftKenk4L6e3t+kqGKJ24/OuBLVg+YoK9hEv1iHYS8YX7KiMSiCKjTKCRSJt
         /li4shj6xDsC9AqmjbFX3ZLk34SoGdMAPtLFEi6A4Lvl2qkY80WQD3ML+osDzHD4Mm50
         ATsuXa4px+ST8exkaOikX1TVo33whaA1yTpFrO6prVjYhLngBN8d5x5zV3kA0jDW6TZQ
         LpKQ==
X-Gm-Message-State: AOAM530F/fAJGB7lsuqFG3pzQlEi9aKFPsH01c6b+FjGtaCOEt1G200h
        9O4VwjTEtFqiQZTFlJuT5SLP2NYAmfjUbV9zR60=
X-Google-Smtp-Source: ABdhPJw6RchKqUKbVdHZ5XV8btkRoYTHe96hjy+EGK9ouAhYpaChpzL/LRaDmTW7PSk1hapDaTWvT6ArbXTAoZ4bdbU=
X-Received: by 2002:a92:4015:: with SMTP id n21mr4532725ila.137.1590133292485;
 Fri, 22 May 2020 00:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-6-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-6-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 10:41:21 +0300
Message-ID: <CAOQ4uxgBbRNTpmj9j3C6cZL2Ldj6h6L=Ft26Cef2-iKoX1KXsw@mail.gmail.com>
Subject: Re: [PATCH 05/24] xfs: mark log recovery buffers for completion
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Log recovery has it's own buffer write completion handler for
> buffers that it directly recovers. Convert these to direct calls by
> flagging these buffers as being log recovery buffers. The flag will
> get cleared by the log recovery IO completion routine, so it will
> never leak out of log recovery.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c                | 10 ++++++++++
>  fs/xfs/xfs_buf.h                |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   |  5 ++---
>  fs/xfs/xfs_dquot_item_recover.c |  2 +-
>  fs/xfs/xfs_inode_item_recover.c |  2 +-
>  fs/xfs/xfs_log_recover.c        |  5 ++---
>  6 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 77d40eb4a11db..b89685ce8519d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_log_recover.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
> @@ -1207,6 +1208,15 @@ xfs_buf_ioend(
>         if (read)
>                 goto out_finish;
>
> +       /*
> +        * If this is a log recovery buffer, we aren't doing transactional IO
> +        * yet so we need to let it handle IO completions.
> +        */
> +       if (bp->b_flags & _XBF_LOGRCVY) {
> +               xlog_recover_iodone(bp);
> +               return;
> +       }
> +
>         /* inodes always have a callback on write */
>         if (bp->b_flags & _XBF_INODES) {
>                 xfs_buf_inode_iodone(bp);

This turns out to be a "static calls" pattern.
I think it would look nicer as a switch statement on
(bp->b_flags & _XBF_BUFFER_TYPE_MASK)
It would be also nicer to document near flag definition
that the type flags are mutually exclusive.

> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index cbde44ecb3963..c5fe4c48c9080 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -33,6 +33,7 @@
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES     (1 << 16)/* inode buffer */
>  #define _XBF_DQUOTS     (1 << 17)/* dquot buffer */
> +#define _XBF_LOGRCVY    (1 << 18)/* log recovery buffer */
>
>  /* flags used only internally */
>  #define _XBF_PAGES      (1 << 20)/* backed by refcounted pages */
> @@ -57,6 +58,7 @@ typedef unsigned int xfs_buf_flags_t;
>         { XBF_WRITE_FAIL,       "WRITE_FAIL" }, \
>         { _XBF_INODES,          "INODES" }, \
>         { _XBF_DQUOTS,          "DQUOTS" }, \
> +       { _XBF_LOGRCVY,         "LOG_RECOVERY" }, \
>         { _XBF_PAGES,           "PAGES" }, \
>         { _XBF_KMEM,            "KMEM" }, \
>         { _XBF_DELWRI_Q,        "DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 04faa7310c4f0..bfd50daa16606 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -419,8 +419,7 @@ xlog_recover_validate_buf_type(
>         if (bp->b_ops) {
>                 struct xfs_buf_log_item *bip;
>
> -               ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
> -               bp->b_iodone = xlog_recover_iodone;
> +               bp->b_flags |= _XBF_LOGRCVY;
>                 xfs_buf_item_init(bp, mp);
>                 bip = bp->b_log_item;
>                 bip->bli_item.li_lsn = current_lsn;
> @@ -963,7 +962,7 @@ xlog_recover_buf_commit_pass2(
>                 error = xfs_bwrite(bp);
>         } else {
>                 ASSERT(bp->b_mount == mp);
> -               bp->b_iodone = xlog_recover_iodone;
> +               bp->b_flags |= _XBF_LOGRCVY;
>                 xfs_buf_delwri_queue(bp, buffer_list);
>         }
>
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 3400be4c88f08..a0a4b089e0cdd 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -153,7 +153,7 @@ xlog_recover_dquot_commit_pass2(
>
>         ASSERT(dq_f->qlf_size == 2);
>         ASSERT(bp->b_mount == mp);
> -       bp->b_iodone = xlog_recover_iodone;
> +       bp->b_flags |= _XBF_LOGRCVY;
>         xfs_buf_delwri_queue(bp, buffer_list);
>
>  out_release:
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index dc3e26ff16c90..b67f1b7c5b65f 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -376,7 +376,7 @@ xlog_recover_inode_commit_pass2(
>         xfs_dinode_calc_crc(log->l_mp, dip);
>
>         ASSERT(bp->b_mount == mp);
> -       bp->b_iodone = xlog_recover_iodone;
> +       bp->b_flags |= _XBF_LOGRCVY;
>         xfs_buf_delwri_queue(bp, buffer_list);
>
>  out_release:
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a..0aa823aeafca9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -287,9 +287,8 @@ xlog_recover_iodone(
>         if (bp->b_log_item)
>                 xfs_buf_item_relse(bp);
>         ASSERT(bp->b_log_item == NULL);
> -
> -       bp->b_iodone = NULL;
> -       xfs_buf_ioend(bp);
> +       bp->b_flags &= ~_XBF_LOGRCVY;
> +       xfs_buf_ioend_finish(bp);


For someone like me who does not know all the assumptions
about buffers, why is this fag leak prevention needed for log recovery
buffers and not for inode/dquote buffers?

Wouldn't it be better to have:
       bp->b_flags &= ~_XBF_BUFFER_TYPE_MASK;

inside xfs_buf_ioend_finish()?

For not changing logic by rearranging code:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
