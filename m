Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38784 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbcJCSyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 14:54:54 -0400
Date: Mon, 3 Oct 2016 19:54:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] O_DIRECT vs EFAULT (was Re: [PATCH 10/12] new iov_iter
 flavour: pipe-backed)
Message-ID: <20161003185448.GV19539@ZenIV.linux.org.uk>
References: <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040117.GP2356@ZenIV.linux.org.uk>
 <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
 <20160929225003.GQ19539@ZenIV.linux.org.uk>
 <CAJfpegs9He0bWX3VWkr2EY-7X3-pAhNAUT=mQad-zxtWkQt_SQ@mail.gmail.com>
 <20161003033409.GT19539@ZenIV.linux.org.uk>
 <CA+55aFw+Tfw4bZr0AZv2ujBx4uQcKyrorLwUgV4uUqYQe6Jw7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+Tfw4bZr0AZv2ujBx4uQcKyrorLwUgV4uUqYQe6Jw7w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Oct 03, 2016 at 10:07:39AM -0700, Linus Torvalds wrote:
> On Sun, Oct 2, 2016 at 8:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Linus, do you have any objections against such behaviour change?  AFAICS,
> > all it takes is this:
> >
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 7c3ce73..3a8ebda 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -246,6 +246,8 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
> >                 if ((dio->op == REQ_OP_READ) &&
> >                     ((offset + transferred) > dio->i_size))
> >                         transferred = dio->i_size - offset;
> > +               if (ret == -EFAULT)
> > +                       ret = 0;
> 
> I don't think that's right. To me it looks like the short read case
> might have changed "transferred" back to zero, in which case we do
> *not* want to skip the EFAULT.

There's this in do_blockdev_direct_IO():
        /* Once we sampled i_size check for reads beyond EOF */
        dio->i_size = i_size_read(inode);
        if (iov_iter_rw(iter) == READ && offset >= dio->i_size) {
                if (dio->flags & DIO_LOCKING)
                        mutex_unlock(&inode->i_mutex);
                kmem_cache_free(dio_cache, dio);
                retval = 0;
                goto out;
        }
so that shouldn't happen.  Said that,

> But if there's some reason that can't happen (ie "dio->i_size" is
> guaranteed to be larger than "offset"), then with a comment to that
> effect it's ok.
> 
> Otherwise I think it would need to be something like
> 
>         /* If we were partially successful, ignore later EFAULT */
>         if (transferred && ret == -EFAULT)
>                 ret = 0;

... it's certainly less brittle that way.  I'd probably still put it under
the same if (dio->result) and write it as
	if (unlikely(ret == -EFAULT) && transferred)
though.
