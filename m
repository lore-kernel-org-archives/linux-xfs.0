Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A7B029DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 12:10:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86425AC009
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 10:10:40 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id hmLyYi2GVlwF5ofG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 10:10:38 -0800 (PST)
Date: Wed, 15 Jan 2014 18:10:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140115181027.GA8077@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140114172033.GU10323@ZenIV.linux.org.uk>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, Jan 14, 2014 at 05:20:33PM +0000, Al Viro wrote:
> And that's less than half of fs/*...  I'm not saying that the current
> situation on the write side is good; hell, just the mess with write/aio_write
> alone is ugly enough - we have
> 	* a bunch of file_operations without ->aio_write(); simple enough.
> 	* a bunch with ->write == do_sync_write.  Also simple.
> 	* several with NULL ->write and non-NULL ->aio_write(); same as
> do_sync_write() for ->write (socket, android/logger, kmsg, macvtap)
> 	* several with ->aio_write being an optimized equivalent of
> do_sync_write() (blackhole for /dev/null and /dev/zero, error for bad_inode)
> 	* 9p cached with its "oh, but if we have O_DIRECT we want ->write()
> to be different" (why not use a separate file_operations, then?  It's not
> as if ->open() couldn't switch to it if it sees O_DIRECT...)
> 	* two infinibad things (ipath and qib), with completely unrelated
> semantics on write(2) and writev(2) (the latter shared with aio).  As in
> "writev() of a single-element iovec array does things that do not even
> resemble what write() of the same data would've done".  Yes, really - check
> for yourself.
> 	* snd_pcm - hell knows; it might be that it tries to collect the
> data from iovec and push it in one go, as if it was a single write, but
> then it might be something as bogus as what ipath is doing...
> 	* gadgetfs - hell knows; ep_write() seems to be doing something
> beyond what ep_aio_write() does, but I haven't traced them down the call
> chain...  That one, BTW, won't be fun for splice - looks like it cares
> about datagram boundaries a lot, so it's not obvious what the semantics
> should be.
> 	* lustre.  I _think_ do_sync_write() would work there, but I'm might
> be easily missing something in all those layers of obfusca^Wgood software
> development practices.

BTW, ->read/->aio_read situation is only slighlty better - of file_operations
instances that have ->aio_read, most have do_sync_read() for ->read() (as
they ought to).  Exceptions:
	* 9p O_DIRECT (again)
	* NULL ->read where do_sync_read ought to be (socket, macvtap)
	* optimized ->read (/dev/zero, /dev/null, bad_inode)
	* snd_pcm - magic.  It (and its ->aio_write counterpart) wants exactly
one iovec per channel.  IOW, it's not a general-purpose ->aio_{read,write}
at all - it's a magic API shoehorned into readv(2)/writev(2) (and aio
IOCB_CMD_P{READ,WRITE}V as well).
	* lustre - probably could live with do_sync_read(), but there might
be stack footprint considerations or some really weird magic going on
(the difference is that instead of iocb on stack they appear to be using
per-thread one allocated on heap and hashed by pid, of all things).
It's really weird - they end up doing repeated hash lookups for that
per-thread wastebasket of a structure on different levels of call chain.
Looks like they have swept a lot of local variables of a lot of functions
into that thing; worse, it appears to be one of several dynamically allocated
bits of that thing, hidden behind a bunch of wrappers...  Overall feel is
Lovecraftian, complete with lurking horrors of the deep...  BTW, its ->aio_read
would better never return -EIOCBQUEUED - its ->read does *not* wait for
completion of iocb it has submitted.
	* gadgetfs - it appears to be seriously datagram-oriented; basically,
they want to reduce readv/writev to read/write, not the other way round.

> BTW, speaking of ->aio_write() - why the devil do we pass the pos
> argument (long long, at that) separately, when all call sites provably
> have it equal to iocb->ki_pos?  If nothing else, on a bunch of architectures
> it makes the difference between passing arguments in registers and spilling
> them on stack; moreover, if we do something and only then call
> generic_file_aio_write(), we get to propagate it all way down.  And
> generic_file_aio_write() has had explicit BUG_ON(iocb->ki_pos != pos)
> since 2.5.55, for crying out loud...

The same goes for ->aio_read() (except for s/2.5.55/2.5.39/)...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
