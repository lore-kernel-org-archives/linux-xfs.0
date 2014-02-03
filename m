Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCDCF7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 09:33:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6D44304077
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 07:33:41 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id QvnVEm6W1krG7Oeo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 07:33:40 -0800 (PST)
Date: Mon, 3 Feb 2014 15:33:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140203153323.GW10323@ZenIV.linux.org.uk>
References: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<20140202192104.GA21959@ZenIV.linux.org.uk>
	<20140203144155.GO24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140203144155.GO24171@tucsk.piliscsaba.szeredi.hu>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Mon, Feb 03, 2014 at 03:41:55PM +0100, Miklos Szeredi wrote:

> > BTW, is there any reason why fuse/dev.c doesn't use atomic kmaps for
> > everything?  After all, as soon as we'd done kmap() in there, we
> > grab a spinlock and don't drop it until just before kunmap().  With
> > nothing by memcpy() done in between...  Miklos?  AFAICS, we only win
> > from switching to kmap_atomic there - we can't block anyway, we don't
> > need it to be visible on other CPUs and nesting isn't a problem.
> > Looks like it'll be cheaper in highmem cases and do exactly the same
> > thing as now for non-highmem...  Comments?
> 
> We don't hold the spinlock.   But regardless, I don't see any reason why it
> couldn't be atomic kmap.

Oh, right - lock_request() drops it.  Still, I don't see anything other
than copying between map and unmap, and not a lot of it either...

As for get_user_pages_fast()...  Why not do what mm/filemap.c does to
deal with the same issue?  Prefault, then lock the destination page,
kmap_atomic() and do __copy_from_user_inatomic().  If that fails (i.e.
if something has raced with us and evicted the source from page table),
shrug, unlock and repeat.

I do realize that you want to share code between the read and write sides
of the whole thing, but I'm not sure it's worth doing.  Almost everything
in that pile knows the direction - splitting a few low-level functions
into ..._in() and ..._out() variants (mostly along the checks already
in them) allows to separate these paths completely, at which point it
becomes possible to use copy-page-to-iov_iter, etc. to take care of
mapping, dealing with iovec components, etc.

What I want to do is to get a sane set of iov_iter primitives that could
be used for everything, without their users having to care about the
nature of iov_iter - iovec, array of <page,offset,size,how_to_steal>
quadruples, biovec, etc.  The interesting part of it is how to make
that set expressive enough, while keeping it reasonably sane.  And
fs/fuse/dev.c is one of the more interesting potential users out there...

I've a growing queue with the beginning of that stuff; so far it's mostly
preparatory bits and pieces.  Currently being tested: copy_page_to_iter()
(more or less similar to iov_iter_copy_to_..., but with saner interface
and dealing with the kmap, atomics, etc. without forcing the callers do
do that) with conversion of generic_file_aio_read() and friends to it.
If it survives the local beating, I'll start pushing it out (as
vfs.git#iov_iter); that pile is getting to potentially interesting bits...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
