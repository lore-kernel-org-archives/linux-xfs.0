Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKJpdd6207196 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 13:51:39 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Dtiy4NnFK0tPUYag for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 11:53:48 -0800 (PST)
Date: Wed, 21 Nov 2012 06:53:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix direct IO nested transaction deadlock.
Message-ID: <20121120195344.GD2591@dastard>
References: <1353410831-22653-1-git-send-email-david@fromorbit.com>
	<1353410831-22653-3-git-send-email-david@fromorbit.com>
	<20121120161015.GB18244@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120161015.GB18244@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 11:10:15AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 20, 2012 at 10:27:11PM +1100, Dave Chinner wrote:
> > This was discovered on a filesystem with a log of only 10MB, and a
> > log stripe unit of 256k whih increased the base reservations by
> > 512k. Hence a allocation transaction requires 1.2MB of log space to
> > be available instead of only 260k, and so greatly increased the
> > chance that there wouldn't be enough log space available for the
> > nested transaction to succeed. The key to reproducing it is this
> > mkfs command:
> > 
> > mkfs.xfs -f -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b $SCRATCH_DEV
> > 
> > The test case was a 1000 fsstress processes running with random
> > freeze and unfreezes every few seconds. Thanks to Eryu Guan
> > (eguan@redhat.com) for writing the test that found this on a system
> > with a somewhat unique default configuration....
> 
> That sounds like something that could fit xfstests fairly easily.
> 
> Re the patch - you're moving the transaction allocation back into the
> end_io handler.  That's what my original version did, and I'm pretty
> sure you talked me out of it back then.  I can't remember the details
> but the list should have it.

Right, I was concerned about blocking IO completion workers waiting
for log reservations. I'm still concerned about that, but I don't
see any way around it.

> 
> > @@ -151,9 +151,11 @@ xfs_setfilesize(
> >  	/*
> >  	 * The transaction was allocated in the I/O submission thread,
> >  	 * thus we need to mark ourselves as beeing in a transaction
> > -	 * manually.
> > +	 * manually. Similarly for freeze protection.
> >  	 */
> >  	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
> > +	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> > +			   0, 1, _THIS_IP_);
> 
> The comment above isn't true anymore, and the flags hack should be
> removed.

It's still used by buffered IO in that way.

> I'm also not sure the freeze protection still works if the acquire is
> outside the original broader scope protection.

We've still got a write level freeze reference, so that has to
expire before the transaction level freeze is done. hence I don't
see a problem here.

Indeed, the problem was exposed by freezing and unfreezing every few
seconds and typically tripped within 10-15s of starting. The fix has
survived all night under the same load, so I think the freeze code is
fine.

> I'll defer to Jan on
> this as I don't really understand this magic enough.q
> should be removed respectively replaced with sb_start_intwrite/sb_end_intwrite
> >  	if (ioend->io_type == XFS_IO_UNWRITTEN) {
> >  		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
> > +						  ioend->io_size);
> > +		goto done;
> > +	}
> > +
> > +	/*
> > +	 * For direct I/O we do not know if we need to allocate blocks or not so
> > +	 * we can't preallocate an append transaction as that results in nested
> > +	 * reservations and log space deadlocks. Hence allocate the transaction
> > +	 * here.  For buffered I/O we preallocate a transaction when submitting
> > +	 * the IO.
> > +	 */
> > +	if (ioend->io_isdirect && xfs_ioend_is_append(ioend)) {
> 
> xfs_iomap_write_unwritten already updates the inode size, so this should
> be an "else if"

The unwritten branch jumps over this completely if it is taken, so
it makes no difference. I can change it is you want....

> 
> > +		error = xfs_setfilesize_trans_alloc(ioend);
> > +		if (error)
> > +	}
> > +
> > +	if (ioend->io_append_trans) {
> >  		error = xfs_setfilesize(ioend);
> >  	} else {
> >  		ASSERT(!xfs_ioend_is_append(ioend));
> >  	}
> 
> Does it really make sense to have different allocation points for
> buffered vs direct I/O? At least it needs a comment explaining why
> it's done differently.

It does, I think, because if we can avoid blocking IO completion for
transaction reservation we should. I'll add a comment. 

> While it's probably too much work for a quick fix I'd much rather
> replace the hacks we currently do in the direct I/O code with a
> scheme where the dio code has a hook to allocate the transaction if
> needed at the right point.

The dio code needs an enema. There's plenty wrong with it that needs
optimising (e.g. allocation call on every iovec element) but the
code is so complex, fast-pathy and fragile that it I'm not about to
touch it and complicate what is a relatively simple XFS bug fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
