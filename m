Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 734D87F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 11:20:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3987D8F8035
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 09:20:51 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id TxMMlw8rvAXLrzEk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 09:20:46 -0800 (PST)
Date: Tue, 14 Jan 2014 17:20:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140114172033.GU10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140114132207.GA25170@infradead.org>
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

On Tue, Jan 14, 2014 at 05:22:07AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 13, 2014 at 11:56:46PM +0000, Al Viro wrote:
> > On Mon, Jan 13, 2014 at 06:14:16AM -0800, Christoph Hellwig wrote:
> > > ping?  Would be nice to get this into 3.14
> > 
> > Umm...  The reason for pipe_lock outside of ->i_mutex is this:
> > default_file_splice_write() calls splice_from_pipe() with
> > write_pipe_buf for callback.  splice_from_pipe() calls that
> > callback under pipe_lock(pipe).  And write_pipe_buf() calls
> > __kernel_write(), which certainly might want to take ->i_mutex.
> > 
> > Now, this codepath isn't taken for files that have non-NULL
> > ->splice_write(), so that's not an issue for XFS and OCFS2,
> > but having pipe_lock nest between the ->i_mutex for filesystems
> > that do and do not have ->splice_write()...  Ouch...
> 
> What would be the alternative?  Duplicating the code in even more
> filesystems to enforce an non-natural locking order for filesystems
> actually implementing splice?  There don't actually seem to be a whole
> lot of real filesystems not implemting splice_write, the prime use
> would be for device drivers or synthetic ones.  I'm not even sure
> how much that fallback gets used in practice.

Actually, I wonder if splice should be allowed just because destination
has ->write() - for a lot of synthetic files the effect of writes really
depends on boundaries in output stream and I'm not sure if splice to
such a beast makes any sense.

Going through fs/*:
	* 9p: messy when we have O_DIRECT on target file.  Other than that,
probably could use generic_file_splice_write().
	* adfs, affs, afs, bfs, fat, hfs, hfs+, minix, sysv: can use
generic_file_splice_write()
	* /proc/fs/afs/*: probably shouldn't allow splice at all
	* binfmt_misc: shouldn't allow splice
	* btrfs: not sure, O_DIRECT complicates the picture again.
	* cachefiles_daemon_write(): probably shouldn't allow splice at all
	* ceph: uses generic_file_splice_write(), but I'm not sure whether
it is correct - there are interesting things done by ceph_aio_write() that
do not have any counterparts on that path.
	* cifs: trouble; might be switchable to generic, but
there's an interesting bit in the end of its ->aio_write() to consider...
In any case, should be doable as generic_file_splice_write() +
filemap_fdatawrite().
	* cifs mounted with strict_io - ouch.  Would need ->splice_write() of
its own with really interesting locking order.
	* cifs with direct_io - about the same story.  Er...  Just where
is it doing suid removal in that case, BTW?  cifs_user_writev() doesn't
seem to?
	* /proc/fs/cifs/*: shouldn't allow splice to it
	* coda: needs ->splice_write() with that patch, might or might not
be tricky
	* coda misc device: shouldn't allow splice to it
	* configfs: shouldn't allow splice to it
	* debugfs default fops: blackhole ->write(), might as well offer
blackhole ->splice_write().  Or refuse to allow splice to it, since I'd
bet that most of non-default ones are of the "shouldn't allow splice to it"
kind...
	* debugfs bool: shouldn't allow splice to it
	* dlm misc devices: shouldn't allow splice to it
	* ecryptfs: probably should use generic_file_splice_write()
(incidentally, who the hell has thought it would be a good idea to
put ->iterate (aka ->readdir) into file_operations of a non-directory?)
	* ecryptfs misc device: probably shouldn't allow splice to it at all
	* eventfd: shouldn't allow splice to it at all
	* XIP ext2: needs ->splice_write() with that patch

And that's less than half of fs/*...  I'm not saying that the current
situation on the write side is good; hell, just the mess with write/aio_write
alone is ugly enough - we have
	* a bunch of file_operations without ->aio_write(); simple enough.
	* a bunch with ->write == do_sync_write.  Also simple.
	* several with NULL ->write and non-NULL ->aio_write(); same as
do_sync_write() for ->write (socket, android/logger, kmsg, macvtap)
	* several with ->aio_write being an optimized equivalent of
do_sync_write() (blackhole for /dev/null and /dev/zero, error for bad_inode)
	* 9p cached with its "oh, but if we have O_DIRECT we want ->write()
to be different" (why not use a separate file_operations, then?  It's not
as if ->open() couldn't switch to it if it sees O_DIRECT...)
	* two infinibad things (ipath and qib), with completely unrelated
semantics on write(2) and writev(2) (the latter shared with aio).  As in
"writev() of a single-element iovec array does things that do not even
resemble what write() of the same data would've done".  Yes, really - check
for yourself.
	* snd_pcm - hell knows; it might be that it tries to collect the
data from iovec and push it in one go, as if it was a single write, but
then it might be something as bogus as what ipath is doing...
	* gadgetfs - hell knows; ep_write() seems to be doing something
beyond what ep_aio_write() does, but I haven't traced them down the call
chain...  That one, BTW, won't be fun for splice - looks like it cares
about datagram boundaries a lot, so it's not obvious what the semantics
should be.
	* lustre.  I _think_ do_sync_write() would work there, but I'm might
be easily missing something in all those layers of obfusca^Wgood software
development practices.

And ->splice_write() thrown into that mess, defaulting to "just do
->write() or ->aio_write(), everything writable should be able to cope
with splice to it" hasn't made it any prettier.  Unfortunately, what
you are proposing will make it worse - we'll have to grow a bunch of
->splice_write() instances, with non-trivial correspondence between
them and ->aio_write() ones...

It needs to be cleaned up, but it's nowhere near as simple as "just flip
the order of i_mutex and pipe_lock" ;-/

BTW, speaking of ->aio_write() - why the devil do we pass the pos
argument (long long, at that) separately, when all call sites provably
have it equal to iocb->ki_pos?  If nothing else, on a bunch of architectures
it makes the difference between passing arguments in registers and spilling
them on stack; moreover, if we do something and only then call
generic_file_aio_write(), we get to propagate it all way down.  And
generic_file_aio_write() has had explicit BUG_ON(iocb->ki_pos != pos)
since 2.5.55, for crying out loud...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
