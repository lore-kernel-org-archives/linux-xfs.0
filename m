Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFA0D7F6F
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 00:40:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C202A8F8084
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 22:40:56 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id iShYRiJ5diUT8sk6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 22:40:55 -0800 (PST)
Date: Sat, 18 Jan 2014 06:40:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118064040.GE10323@ZenIV.linux.org.uk>
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
> On Tue, Jan 14, 2014 at 05:22:07AM -0800, Christoph Hellwig wrote:
> > On Mon, Jan 13, 2014 at 11:56:46PM +0000, Al Viro wrote:
> > > On Mon, Jan 13, 2014 at 06:14:16AM -0800, Christoph Hellwig wrote:
> > > > ping?  Would be nice to get this into 3.14
> > > 
> > > Umm...  The reason for pipe_lock outside of ->i_mutex is this:
> > > default_file_splice_write() calls splice_from_pipe() with
> > > write_pipe_buf for callback.  splice_from_pipe() calls that
> > > callback under pipe_lock(pipe).  And write_pipe_buf() calls
> > > __kernel_write(), which certainly might want to take ->i_mutex.
> > > 
> > > Now, this codepath isn't taken for files that have non-NULL
> > > ->splice_write(), so that's not an issue for XFS and OCFS2,
> > > but having pipe_lock nest between the ->i_mutex for filesystems
> > > that do and do not have ->splice_write()...  Ouch...
> > 
> > What would be the alternative?  Duplicating the code in even more
> > filesystems to enforce an non-natural locking order for filesystems
> > actually implementing splice?  There don't actually seem to be a whole
> > lot of real filesystems not implemting splice_write, the prime use
> > would be for device drivers or synthetic ones.  I'm not even sure
> > how much that fallback gets used in practice.

Hmm...  In principle, the following would be no worse than what
generic_file_splice_write() is doing: confirm and map the pages, build
an iovec and use ->aio_write() to write it out, then unmap the suckers,
release ones entirely written to file and adjust the partially
written one.  All under pipe_lock().  Hell, if we introduce
kernel_writev() (either by calling vfs_writev() or taking do_readv_writev()
sans copying iovec and using that under set_fs()), we could switch
default_file_splice_write() to that and get rid of ->splice_write() for
the majority of filesystems, if not all of them.

Sure, it means copying from pipe buffers to pagecache, but we have
generic_file_splice_write() do that copy anyway - conditional memcpy()
in pipe_to_file() is actually unconditional; that if (page != buf->page) in
there had just been forgotten by Nick back in 2007 ("1/2 splice: dont steal").

Objections, comments?

The problem Christoph was talking about is that generic_file_splice_write()
plays with ->i_mutex and both gets/drops it for each page of IO *and*
causes PITA for any fs that wants some locks of its own taken in addition
to ->i_mutex on the write paths.  What ->splice_write() without page
stealing is doing is pretty much a writev() from array of pages in kernel
space; so it looks like we might as well just reuse writev() guts for that...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
