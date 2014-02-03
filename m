Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD3CA7FC7
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:41:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63E8BAC001
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 06:41:05 -0800 (PST)
Received: from mail-ea0-f174.google.com (mail-ea0-f174.google.com
	[209.85.215.174]) by cuda.sgi.com with ESMTP id
	9aN6tg9igzjy0faL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 06:41:02 -0800 (PST)
Received: by mail-ea0-f174.google.com with SMTP id b10so3711176eae.5
	for <xfs@oss.sgi.com>; Mon, 03 Feb 2014 06:41:00 -0800 (PST)
Date: Mon, 3 Feb 2014 15:41:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140203144155.GO24171@tucsk.piliscsaba.szeredi.hu>
References: <20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<20140202192104.GA21959@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140202192104.GA21959@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Sun, Feb 02, 2014 at 07:21:04PM +0000, Al Viro wrote:
> On Sat, Feb 01, 2014 at 10:43:01PM +0000, Al Viro wrote:
> 
> > * pipe_buffer_operations ->map()/->unmap() should die; let the caller do
> > k{,un}map{,_atomic}().  All instances have the same method there and
> > there's no point to make it different.  PIPE_BUF_FLAG_ATOMIC should also
> > go.
> 
> BTW, another pile of code interesting in that respect (i.e. getting that
> interface right) is fs/fuse/dev.c; I don't like the way it's playing
> with get_user_pages_fast() there,

It's trying to work around a deadlock by lock_page() recursion.  I.e. fuse
daemon is reading a request into a page for which the readpage is being serviced
by said request (no, that's not something that happens accidentally).

Do all archs set FAULT_FLAG_KILLABLE?  If so, that flag along with code
depending on the lack of it can go away and we can simply depend on page faults
being interruptible by fatal signals.

And that would simplify the fuse device I/O substantially.

>  and I doubt that sharing the code for
> read and write side as it's done there makes much sense, but it's
> definitely going to be a test for any API of that kind.  It *does*
> try to unify write-from-iovec with write-from-array-of-pages and
> similar for reads; the interesting issue is that unlike the usual
> write-to-pagecache we can have many chunks picked from one page and
> we'd rather avoid doing kmap_atomic/kunmap_atomic for each of those.
> 
> I suspect that the right answer is, in addition to a primitive that
> does copying from iov_iter to have "copy from iov_iter and be ready
> to copy more from soon after" + "done copying"; for the "array of
> pages" the former would be allowed to leave the current page mapped,
> skipping kmap_atomic() on the next call.  And the latter would unmap.
> of course.  The caller is responsible for not blocking or doing
> unbalanced map/unmap until it's said "done copying".
> 
> BTW, is there any reason why fuse/dev.c doesn't use atomic kmaps for
> everything?  After all, as soon as we'd done kmap() in there, we
> grab a spinlock and don't drop it until just before kunmap().  With
> nothing by memcpy() done in between...  Miklos?  AFAICS, we only win
> from switching to kmap_atomic there - we can't block anyway, we don't
> need it to be visible on other CPUs and nesting isn't a problem.
> Looks like it'll be cheaper in highmem cases and do exactly the same
> thing as now for non-highmem...  Comments?

We don't hold the spinlock.   But regardless, I don't see any reason why it
couldn't be atomic kmap.

Thanks,
Miklos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
