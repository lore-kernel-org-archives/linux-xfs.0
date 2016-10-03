Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34220 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbcJCRHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 13:07:40 -0400
MIME-Version: 1.0
In-Reply-To: <20161003033409.GT19539@ZenIV.linux.org.uk>
References: <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040117.GP2356@ZenIV.linux.org.uk> <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
 <20160929225003.GQ19539@ZenIV.linux.org.uk> <CAJfpegs9He0bWX3VWkr2EY-7X3-pAhNAUT=mQad-zxtWkQt_SQ@mail.gmail.com>
 <20161003033409.GT19539@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Oct 2016 10:07:39 -0700
Message-ID: <CA+55aFw+Tfw4bZr0AZv2ujBx4uQcKyrorLwUgV4uUqYQe6Jw7w@mail.gmail.com>
Subject: Re: [RFC] O_DIRECT vs EFAULT (was Re: [PATCH 10/12] new iov_iter
 flavour: pipe-backed)
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Oct 2, 2016 at 8:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Linus, do you have any objections against such behaviour change?  AFAICS,
> all it takes is this:
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 7c3ce73..3a8ebda 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -246,6 +246,8 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
>                 if ((dio->op == REQ_OP_READ) &&
>                     ((offset + transferred) > dio->i_size))
>                         transferred = dio->i_size - offset;
> +               if (ret == -EFAULT)
> +                       ret = 0;

I don't think that's right. To me it looks like the short read case
might have changed "transferred" back to zero, in which case we do
*not* want to skip the EFAULT.

But if there's some reason that can't happen (ie "dio->i_size" is
guaranteed to be larger than "offset"), then with a comment to that
effect it's ok.

Otherwise I think it would need to be something like

        /* If we were partially successful, ignore later EFAULT */
        if (transferred && ret == -EFAULT)
                ret = 0;

or something. Yes?

                Linus
