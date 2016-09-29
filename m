Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36644 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbcI2UyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 16:54:01 -0400
Received: by mail-pa0-f67.google.com with SMTP id cd13so2027735pac.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2016 13:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160924040117.GP2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040117.GP2356@ZenIV.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Sep 2016 22:53:55 +0200
Message-ID: <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
Subject: Re: [PATCH 10/12] new iov_iter flavour: pipe-backed
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Sep 24, 2016 at 6:01 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> iov_iter variant for passing data into pipe.  copy_to_iter()
> copies data into page(s) it has allocated and stuffs them into
> the pipe; copy_page_to_iter() stuffs there a reference to the
> page given to it.  Both will try to coalesce if possible.
> iov_iter_zero() is similar to copy_to_iter(); iov_iter_get_pages()
> and friends will do as copy_to_iter() would have and return the
> pages where the data would've been copied.  iov_iter_advance()
> will truncate everything past the spot it has advanced to.
>
> New primitive: iov_iter_pipe(), used for initializing those.
> pipe should be locked all along.
>
> Running out of space acts as fault would for iovec-backed ones;
> in other words, giving it to ->read_iter() may result in short
> read if the pipe overflows, or -EFAULT if it happens with nothing
> copied there.

This is the hardest part of the whole set.  I've been trying to
understand it, but the modular arithmetic makes it really tricky to
read.  Couldn't we have more small inline helpers like next_idx()?

Specific comments inline.

[...]

> +static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t bytes,
> +                        struct iov_iter *i)
> +{
> +       struct pipe_inode_info *pipe = i->pipe;
> +       struct pipe_buffer *buf;
> +       size_t off;
> +       int idx;
> +
> +       if (unlikely(bytes > i->count))
> +               bytes = i->count;
> +
> +       if (unlikely(!bytes))
> +               return 0;
> +
> +       if (!sanity(i))
> +               return 0;
> +
> +       off = i->iov_offset;
> +       idx = i->idx;
> +       buf = &pipe->bufs[idx];
> +       if (off) {
> +               if (offset == off && buf->page == page) {
> +                       /* merge with the last one */
> +                       buf->len += bytes;
> +                       i->iov_offset += bytes;
> +                       goto out;
> +               }
> +               idx = next_idx(idx, pipe);
> +               buf = &pipe->bufs[idx];
> +       }
> +       if (idx == pipe->curbuf && pipe->nrbufs)
> +               return 0;

The EFAULT logic seems to be missing across the board.  And callers
don't expect a zero return value.  Most will loop indefinitely.

[...]

> +static size_t push_pipe(struct iov_iter *i, size_t size,
> +                       int *idxp, size_t *offp)
> +{
> +       struct pipe_inode_info *pipe = i->pipe;
> +       size_t off;
> +       int idx;
> +       ssize_t left;
> +
> +       if (unlikely(size > i->count))
> +               size = i->count;
> +       if (unlikely(!size))
> +               return 0;
> +
> +       left = size;
> +       data_start(i, &idx, &off);
> +       *idxp = idx;
> +       *offp = off;
> +       if (off) {
> +               left -= PAGE_SIZE - off;
> +               if (left <= 0) {
> +                       pipe->bufs[idx].len += size;
> +                       return size;
> +               }
> +               pipe->bufs[idx].len = PAGE_SIZE;
> +               idx = next_idx(idx, pipe);
> +       }
> +       while (idx != pipe->curbuf || !pipe->nrbufs) {
> +               struct page *page = alloc_page(GFP_USER);
> +               if (!page)
> +                       break;

Again, unexpected zero return if this is the first page.  Should
return -ENOMEM?  Some callers only expect -EFAULT, though.

[...]

> +static void pipe_advance(struct iov_iter *i, size_t size)
> +{
> +       struct pipe_inode_info *pipe = i->pipe;
> +       struct pipe_buffer *buf;
> +       size_t off;
> +       int idx;
> +
> +       if (unlikely(i->count < size))
> +               size = i->count;
> +
> +       idx = i->idx;
> +       off = i->iov_offset;
> +       if (size || off) {
> +               /* take it relative to the beginning of buffer */
> +               size += off - pipe->bufs[idx].offset;
> +               while (1) {
> +                       buf = &pipe->bufs[idx];
> +                       if (size > buf->len) {
> +                               size -= buf->len;
> +                               idx = next_idx(idx, pipe);
> +                               off = 0;

off is unused and reassigned before breaking out of the loop.

[...]

> @@ -732,7 +1101,20 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages)
>         if (!size)
>                 return 0;
>
> -       iterate_all_kinds(i, size, v, ({
> +       if (unlikely(i->type & ITER_PIPE)) {
> +               struct pipe_inode_info *pipe = i->pipe;
> +               size_t off;
> +               int idx;
> +
> +               if (!sanity(i))
> +                       return 0;
> +
> +               data_start(i, &idx, &off);
> +               /* some of this one + all after this one */
> +               npages = ((pipe->curbuf - idx - 1) & (pipe->buffers - 1)) + 1;

It's supposed to take i->count into account, no?  And that calculation
will result in really funny things if the pipe is full.  And we can't
return -EFAULT here, since that's not expected by callers...

Thanks,
Miklos
