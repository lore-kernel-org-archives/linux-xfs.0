Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECB507F69
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 23:13:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D44AA8F8059
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 21:13:46 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id yaCMJd6ratyxkTNJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jan 2014 21:13:45 -0800 (PST)
Date: Sun, 19 Jan 2014 05:13:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] unifying write variants for filesystems
Message-ID: <20140119051335.GN10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140118201031.GI10323@ZenIV.linux.org.uk>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Jan 18, 2014 at 08:10:31PM +0000, Al Viro wrote:

> Ouch...  No, I hadn't meant that kind of insanity, but I'd missed the
> problem with scarcity of mappings completely...

OK, that pretty much kills this approach.  Pity...

Folks, what do you think about the following:
	* a new data structure:
struct io_source {
	enum {IO_IOVEC, IO_PVEC} type;
	union {
		struct iovec *iov;
		struct pvec {
			struct page *page;
			unsigned offset;
			unsigned size;
		} *pvec;
	};
}
	* a new method that would look like aio_write, but take
struct io_source instead of iovec.
	* store the type in iov_iter (normally - IO_UIOVEC) and teach the
code dealing with it to do the right thing depending on type.  I.e. instead
of __copy_from_user_inatomic() do kmap_atomic()/memcpy()/kunmap_atomic() if
it's a IO_PAGEVEC.
	* generic_file_aio_write() analog for new method, converging with
generic_file_aio_write() almost immediately (basically, as soon as iov_iter
has been initialized).
	* new_aio_write() consisting of
{
	struct io_source source = {.type = IO_UIOVEC, .user = iov};
	return file->f_op-><new_method>(iocb, &source, nr_segs, pos);
}
	* new_sync_write(), doing what do_sync_write() does for files
that have new_aio_write() as ->aio_write().
	* new_splice_write() usable for files that provide that method -
it would collect pipe_buffers, put together struct pvec array and pass
it to that method.  All mapping the pages would happen one-by-one
and only around actual copying the data.  And, of course, the locking
would be identical to what we do for write()/writev()/aio write

	Then filesystems can switch to that new method, turning their
flipping their aio_write() instances to new type and replacing ->aio_write
with default_aio_write, ->write with new_write and ->splice_write with
new_splice_write.

	Actually, there's a possibility that it would be possible to use
it for *all* instances of ->splice_write() - we'd need to store something
a pointer to "call this to try and steal this page" function in pvec
and allow the method do actual stealing.  Note that pipe_buffer ->steal()
only uses the page argument - they all ignore which pipe it's in (and
there's nothing they could usefully do if they knew which pipe had it been
in the first place).

	This is very preliminary, of course, and I might easily miss
something - the previous idea was unworkable, after all.  Comments
would be very welcome...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
