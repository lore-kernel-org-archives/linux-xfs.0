Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42066 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbcINDQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Sep 2016 23:16:55 -0400
Date: Wed, 14 Sep 2016 04:16:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160914031648.GB2356@ZenIV.linux.org.uk>
References: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>

[Jens and Nick Cc'd]

On Fri, Sep 09, 2016 at 07:06:29PM -0700, Linus Torvalds wrote:

> I think you'd be better off with just a really small on-stack case
> (like maybe 2-3 entries), and just allocate anything bigger
> dynamically. Or you could even see how bad it is if you just
> force-limit it to max 4 entries or something like that and just do
> partial writes.

Umm...  Right now it tries to allocate as much as the output pipe could
possibly hold.  With default being 16 buffers, you'll end up with doing
dynamic allocation in all cases (it doesn't even look at the amount of
data we want to transfer).

The situation with splice_pipe_desc looks very odd:

	* all but one instance are on stack frames of some ->splice_read()
or something called by it (exception is in vmsplice)

	* all but one instance (a different one - see below) go through
splice_grow_spd / splice_to_pipe / splice_shrink_spd sequence and
nothing else sees them.  The exception is skb_splice_bits() and there we
have MAX_SKB_FRAGS for size, don't bother with grow/shrink and the only
thing done to that spd is splice_to_pipe() (from the callback passed to
skb_splice_bits()).

	* only one ->splice_read() instance does _not_ create
splice_pipe_descriptor.  It's fuse_dev_splice_read(), and it pays for that
by open-coding splice_to_pipe().  The only reason for open-coding is that
we don't have a "stronger SPLICE_F_NONBLOCK" that would fail if the data
wouldn't fit.  SPLICE_F_NONBLOCK stuffs as much as possible and buggers off
without waiting, fuse_dev_splice_read() wants all or nothing (and no waiting).

	* incidentally, we *can't* add new flags - splice(2)/tee(2)/vmsplice(2)
quietly ignore all bits they do not recognize.  In fact, splice(2) ends up
passing them (unsanitized) to ->splice_read and ->splice_write instances.

	* for splice(2) the IO size is limited by nominal capacity of output
pipe.  Looks fairly arbitrary (the limit is the same whether the pipe is
full or empty), but I wouldn't be surprised if userland programmers would
get unhappy if they have to take more iterations through their loops.

	* the other caller of ->splice_read() is splice_direct_to_actor() and
that can be called on a fairly deep stack.  However, there we loop ourselves
and smaller chunk size is not a problem.

	* in case of skb_splice_bits(), we probably want a grow/shrink pair
as well, with well below MAX_SKB_FRAGS for a default - what's the typical
number of fragments per skb?

> So feel free to try maxing out using only a small handful of
> pipe_buffer entries. Returning partial IO from splice() is fine.

	Are you sure that nobody's growing the output pipe buffer before
doing splice() into it as a way to reduce the amount of iterations?

	FWIW, I would love to replace these array of page * + array of
<offset,len,private> triples with array of pipe_buffer; for one thing,
this ridiculous ->sbd_release() goes away (we simply call ->ops->release()
on all unwanted buffers), which gets rid of wonders like
static void buffer_spd_release(struct splice_pipe_desc *spd, unsigned int i)
{
        struct buffer_ref *ref =
                (struct buffer_ref *)spd->partial[i].private;

        if (--ref->ref)
                return;

        ring_buffer_free_read_page(ref->buffer, ref->page);
        kfree(ref);
        spd->partial[i].private = 0;
}
static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
                                    struct pipe_buffer *buf)
{
        struct buffer_ref *ref = (struct buffer_ref *)buf->private;

        if (--ref->ref)
                return;

        ring_buffer_free_read_page(ref->buffer, ref->page);
        kfree(ref);
        buf->private = 0;
}

pairs that need to be kept in sync, etc.

One inconvenience created by that is stuff like
        spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, spd.pages);
in there; granted, this one will go away with __generic_file_splice_read(),
but e.g. get_iovec_page_array() is using get_user_pages_fast(), which wants
to put pages next to each other.  That one is from vmsplice_to_pipe() guts,
and I've no idea what the normal use patterns are.  OTOH, how much overhead
would we get from repeated calls of get_user_pages_fast() for e.g. 16 pages
or so, compared to larger chunks?  It is on a shallow stack, so it's not
as if we couldn't afford a 16-element array of struct page * in there...
