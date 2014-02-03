Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F04C7FE9
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 09:12:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7085AC003
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 07:12:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Z99DfUaAIJtafFyG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 07:12:48 -0800 (PST)
Date: Mon, 3 Feb 2014 07:12:42 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140203151242.GA6868@infradead.org>
References: <20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140201224301.GS10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Kleikamp <shaggy@kernel.org>, Sage Weil <sage@inktank.com>, Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Sat, Feb 01, 2014 at 10:43:01PM +0000, Al Viro wrote:
> * WTF bother passing 'pos' separately?  It's the same mistake that was
> made with ->aio_read/->aio_write and just as with those, *all* callers
> provably have pos == iocb->ki_pos.

I think this landed with the initial aio support, which planned for
allowing AIO retries for a workqueue with a partially incremented
pos.  None of this ever got merged, probably because it was too ugly
to live.

> * We *definitely* want a variant structure with tag - unsigned long thing
> was just plain insane.  I see at least two variants - array of iovecs
> and array of (at least) triples <page, offset, length>.  Quite possibly -
> quadruples, with "here's how to try to steal this page" thrown in, if
> we want that as replacement for ->splice_write() as well (it looks like
> the few instances that do steal on pipe-to-file splices could be dealt
> with the same way as the dumb ones, provided that ->write_iter or whatever
> we end up calling it is allowed to try and steal pages).   Possibly more
> variants on the read side of things...  FWIW, I'm not sure that bio_vec
> makes a lot of sense here.

bio_vec just is one of the many page+offset+len containers we have, I
guess Dave took it because loop uses it.  We could either invent a new
one here or finally have a common one for the different uses all over
the kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
