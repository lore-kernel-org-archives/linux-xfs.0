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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F506C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB072207FB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZnFWm0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgEVHp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgEVHp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 03:45:28 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B07C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:45:28 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id n11so9835496ilj.4
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aUuUoTRbbwDNFv9BXTvqdNNJ2rsJxKdDeElf0ukBGT4=;
        b=ZZnFWm0QsH6BxPyT5ZHRgpF2rkOvISvNTlRS0tqYVGEWEj2J7Ua4Cg8SzRIyB0rk6I
         EtRSXk4jjeglzlsh5TSQSaCKkZApHLCCvVGXXTG0pxGMPmzJjzCxuOAAfo4beeFtQVtb
         VWB8hTfx0U6CKnkgLbuRX1L3K4bMakrf9sup/15/kJWwrVjlh/LjdwgZj4RP+qLWoDkC
         gkVzvDtrgjrCrairR+/ShkjR0K6WRgZf6xT8u+lF3mVn15FVDHHX0iaxyFjEOV8gB5BX
         G3b7vrE7ICY7VodxtTzgAxPHUGX6ftXkS7LM3GOcbXUmjY757LU37dD3QqCG0DDf6w10
         U6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aUuUoTRbbwDNFv9BXTvqdNNJ2rsJxKdDeElf0ukBGT4=;
        b=fdkTLMJiFq6nlyzwIgzQDLLnErwrvzSndAopdymeD+3IM4rrtV8GQYSA+tavRJxKeQ
         0Dzr3QEZA0e3WZ0+b530VFxi2gWBFeIH/xm1viIunZCrKPQoyUGB20tZfBFScgh0Qybj
         RYp0Soxx5gkV5EYrzOr0CzY+ZBuwsoyLZmTez2rYya5UdPJoQwDa8FNaKsjzBnu4Iwak
         CL+ujcYuwv/gzjrubTTRM4lm63lN8nZO/9AsKDdn6vCBz+0kewAnxOLCDEdxFsg6+Isv
         t2/SqzdlUYKTavaiF95/Xm2SVl9qIMlxmWCpS/hd9r/Prc8nreZXG45oaBYaxW+QOUND
         VLtg==
X-Gm-Message-State: AOAM532/cafSRTaHWbrECbE+Kab0/76DxbKFrsiSkEQSz6lZj5wUMdYb
        erxc4fLaczvWABW55wl2wtAml+vmM8/GgKyDRnc=
X-Google-Smtp-Source: ABdhPJwEbE2HNJG7EyyiWkRYW1khWXib1AaPTxfZtlspE0EQz90k19tZBAh8UsJL9rFDH6AFdcJ6Y+GjVPQv6Pypq2E=
X-Received: by 2002:a92:99cf:: with SMTP id t76mr12513363ilk.9.1590133527329;
 Fri, 22 May 2020 00:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-4-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-4-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 10:45:16 +0300
Message-ID: <CAOQ4uxiVMSHN8wmqpExZ9UvHEhopUAoYJTrbD_HwfSo9J39Mmw@mail.gmail.com>
Subject: Re: [PATCH 03/24] xfs: mark inode buffers in cache
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
> Inode buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
>
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       | 18 +++++++++++++-----
>  fs/xfs/xfs_buf.h       | 39 ++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_buf_item.c  | 42 +++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_inode.c     |  2 +-
>  fs/xfs/xfs_trans_buf.c |  3 +++
>  6 files changed, 75 insertions(+), 30 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9c2fbb6bbf89d..6105b97028d6a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,8 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>
> @@ -1202,12 +1204,18 @@ xfs_buf_ioend(
>                 bp->b_flags |= XBF_DONE;
>         }
>
> -       if (bp->b_iodone)
> +       /* inodes always have a callback on write */
> +       if (!read && (bp->b_flags & _XBF_INODES)) {
> +               xfs_buf_inode_iodone(bp);
> +               return;
> +       }
> +
> +       if (bp->b_iodone) {
>                 (*(bp->b_iodone))(bp);
> -       else if (bp->b_flags & XBF_ASYNC)
> -               xfs_buf_relse(bp);
> -       else
> -               complete(&bp->b_iowait);
> +               return;
> +       }
> +
> +       xfs_buf_ioend_finish(bp);
>  }
>
>  static void
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 050c53b739e24..b3e5d653d09f1 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -30,15 +30,19 @@
>  #define XBF_STALE       (1 << 6) /* buffer has been staled, do not find it */
>  #define XBF_WRITE_FAIL  (1 << 7) /* async writes have failed on this buffer */
>
> -/* flags used only as arguments to access routines */
> -#define XBF_TRYLOCK     (1 << 16)/* lock requested, but do not wait */
> -#define XBF_UNMAPPED    (1 << 17)/* do not map the buffer */
> +/* buffer type flags for write callbacks */
> +#define _XBF_INODES     (1 << 16)/* inode buffer */

As I wrote on review of another type flag, best add a definition
of XBF_BUFFER_TYPE_MASK and document that buffer type
flags are mutually exclusive, maybe even ASSERT it in some
places.

For not changing logic by rearranging code:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
