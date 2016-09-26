Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF6507CAF
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 08:35:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FD1EAC002
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 06:35:18 -0700 (PDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
	[209.85.220.68]) by cuda.sgi.com with ESMTP id IW4SQxBScPJyBz0G
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Sep 2016 06:35:15 -0700 (PDT)
Received: by mail-pa0-f68.google.com with SMTP id j3so801500paj.2
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 06:35:15 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com.
	[209.85.220.43]) by smtp.gmail.com with ESMTPSA id
	r66sm31342905pfb.54.2016.09.26.06.35.13 for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 26 Sep 2016 06:35:13 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id qn7so45758251pac.3
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 06:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160924035951.GN2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk>
	<CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
	<20160914042559.GC2356@ZenIV.linux.org.uk>
	<20160917082007.GA6489@ZenIV.linux.org.uk>
	<20160917190023.GA8039@ZenIV.linux.org.uk>
	<20160923190032.GA25771@ZenIV.linux.org.uk>
	<20160923190326.GB2356@ZenIV.linux.org.uk>
	<CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
	<20160923201025.GJ2356@ZenIV.linux.org.uk>
	<CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
	<20160924035951.GN2356@ZenIV.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Sep 2016 15:35:12 +0200
Message-ID: <CAELBmZCBo49dvi5mPK2NAYnSz0tv=kktTvcygW44e2hRJNpGkQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Sep 24, 2016 at 5:59 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> * splice_to_pipe() stops at pipe overflow and does *not* take pipe_lock
> * ->splice_read() instances do the same
> * vmsplice_to_pipe() and do_splice() (ultimate callers of splice_to_pipe())
>   arrange for waiting, looping, etc. themselves.
>
> That should make pipe_lock the outermost one.
>
> Unfortunately, existing rules for the amount passed by vmsplice_to_pipe()
> and do_splice() are quite ugly _and_ userland code can be easily broken
> by changing those.  It's not even "no more than the maximal capacity of
> this pipe" - it's "once we'd fed pipe->nr_buffers pages into the pipe,
> leave instead of waiting".
>
> Considering how poorly these rules are documented, let's try "wait for some
> space to appear, unless given SPLICE_F_NONBLOCK, then push into pipe
> and if we run into overflow, we are done".
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/fuse/dev.c |   2 -
>  fs/splice.c   | 138 +++++++++++++++++++++++++++-------------------------------
>  2 files changed, 63 insertions(+), 77 deletions(-)
>

[...]

> @@ -1546,14 +1528,20 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
>                 return -ENOMEM;
>         }
>
> -       spd.nr_pages = get_iovec_page_array(&from, spd.pages,
> -                                           spd.partial,
> -                                           spd.nr_pages_max);
> -       if (spd.nr_pages <= 0)
> -               ret = spd.nr_pages;
> -       else
> -               ret = splice_to_pipe(pipe, &spd);
> -
> +       pipe_lock(pipe);
> +       ret = wait_for_space(pipe, flags);
> +       if (!ret) {
> +               spd.nr_pages = get_iovec_page_array(&from, spd.pages,
> +                                                   spd.partial,
> +                                                   spd.nr_pages_max);
> +               if (spd.nr_pages <= 0)
> +                       ret = spd.nr_pages;
> +               else
> +                       ret = splice_to_pipe(pipe, &spd);
> +               pipe_unlock(pipe);
> +               if (ret > 0)
> +                       wakeup_pipe_readers(pipe);
> +       }

Unbalanced pipe_lock()?

Also, while it doesn't hurt, the constification of the "from" argument
of get_iovec_page_array() looks only noise in this patch.

Thanks,
Miklos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
