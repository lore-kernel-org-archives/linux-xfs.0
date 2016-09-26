Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33145 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935875AbcIZNtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 09:49:20 -0400
Received: by mail-pa0-f68.google.com with SMTP id oz2so8831917pac.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2016 06:49:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160924040022.GO2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040022.GO2356@ZenIV.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Sep 2016 15:49:16 +0200
Message-ID: <CAELBmZBt_J6bcwseaDwvc0j7LJh8tKtXoBbkSb1LVnkOSYW5jg@mail.gmail.com>
Subject: Re: [PATCH 06/12] new helper: add_to_pipe()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Sep 24, 2016 at 6:00 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> single-buffer analogue of splice_to_pipe(); vmsplice_to_pipe() switched
> to that, leaving splice_to_pipe() only for ->splice_read() instances
> (and that only until they are converted as well).
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/splice.c            | 113 ++++++++++++++++++++++++++++---------------------
>  include/linux/splice.h |   2 +
>  2 files changed, 67 insertions(+), 48 deletions(-)
>

[...]

> @@ -1523,26 +1553,13 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
>         if (ret < 0)
>                 return ret;
>
> -       if (splice_grow_spd(pipe, &spd)) {
> -               kfree(iov);
> -               return -ENOMEM;
> -       }
> -
>         pipe_lock(pipe);
>         ret = wait_for_space(pipe, flags);
> -       if (!ret) {
> -               spd.nr_pages = get_iovec_page_array(&from, spd.pages,
> -                                                   spd.partial,
> -                                                   spd.nr_pages_max);
> -               if (spd.nr_pages <= 0)
> -                       ret = spd.nr_pages;
> -               else
> -                       ret = splice_to_pipe(pipe, &spd);
> -               pipe_unlock(pipe);
> -               if (ret > 0)
> -                       wakeup_pipe_readers(pipe);
> -       }
> -       splice_shrink_spd(&spd);
> +       if (!ret)
> +               ret = iter_to_pipe(&from, pipe, buf_flag);
> +       pipe_unlock(pipe);

Ah, here it is :)

Thanks,
Miklos
