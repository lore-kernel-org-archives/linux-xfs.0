Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7E3E7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 17:50:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22190AC003
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 15:50:16 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id gak8Szr4FvTQkcdI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 15:50:10 -0700 (PDT)
Date: Thu, 29 Sep 2016 23:50:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 10/12] new iov_iter flavour: pipe-backed
Message-ID: <20160929225003.GQ19539@ZenIV.linux.org.uk>
References: <20160914042559.GC2356@ZenIV.linux.org.uk>
	<20160917082007.GA6489@ZenIV.linux.org.uk>
	<20160917190023.GA8039@ZenIV.linux.org.uk>
	<20160923190032.GA25771@ZenIV.linux.org.uk>
	<20160923190326.GB2356@ZenIV.linux.org.uk>
	<CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
	<20160923201025.GJ2356@ZenIV.linux.org.uk>
	<CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
	<20160924040117.GP2356@ZenIV.linux.org.uk>
	<CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, Sep 29, 2016 at 10:53:55PM +0200, Miklos Szeredi wrote:

> The EFAULT logic seems to be missing across the board.  And callers
> don't expect a zero return value.  Most will loop indefinitely.

Nope.  copy_page_to_iter() *never* returns -EFAULT.  Including the iovec
one - check copy_page_to_iter_iovec().  Any caller that does not expect
a zero return value from that primitive is a bug, triggerable as soon as
you feed it an iovec with NULL ->iov_base.

> Again, unexpected zero return if this is the first page.  Should
> return -ENOMEM?  Some callers only expect -EFAULT, though.

For copy_to_iter() and zero_iter() it's definitely "return zero".  For
get_pages...  Hell knows; those probably ought to return -EFAULT, but
I'll need to look some more at the callers.  It should end up triggering
a short read as the end result (or, as usual, EFAULT on zero-length read).

> > +               /* take it relative to the beginning of buffer */
> > +               size += off - pipe->bufs[idx].offset;
> > +               while (1) {
> > +                       buf = &pipe->bufs[idx];
> > +                       if (size > buf->len) {
> > +                               size -= buf->len;
> > +                               idx = next_idx(idx, pipe);
> > +                               off = 0;
> 
> off is unused and reassigned before breaking out of the loop.

True.

> [...]
> 
> > +       if (unlikely(i->type & ITER_PIPE)) {
> > +               struct pipe_inode_info *pipe = i->pipe;
> > +               size_t off;
> > +               int idx;
> > +
> > +               if (!sanity(i))
> > +                       return 0;
> > +
> > +               data_start(i, &idx, &off);
> > +               /* some of this one + all after this one */
> > +               npages = ((pipe->curbuf - idx - 1) & (pipe->buffers - 1)) + 1;
> 
> It's supposed to take i->count into account, no?  And that calculation
> will result in really funny things if the pipe is full.  And we can't
> return -EFAULT here, since that's not expected by callers...

It should look at i->count, in principle.  OTOH, overestimating the amount
is not really a problem for possible users of such iov_iter.  I'll look
into that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
