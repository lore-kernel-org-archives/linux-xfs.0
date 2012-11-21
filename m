Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL9uqtC029592 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 03:56:52 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Yljm1tTS528Yu3bh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 01:59:02 -0800 (PST)
Date: Wed, 21 Nov 2012 04:59:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix direct IO nested transaction deadlock.
Message-ID: <20121121095900.GD23339@infradead.org>
References: <1353410831-22653-1-git-send-email-david@fromorbit.com>
	<1353410831-22653-3-git-send-email-david@fromorbit.com>
	<20121120161015.GB18244@infradead.org>
	<20121120195344.GD2591@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120195344.GD2591@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Nov 21, 2012 at 06:53:44AM +1100, Dave Chinner wrote:
> Right, I was concerned about blocking IO completion workers waiting
> for log reservations. I'm still concerned about that, but I don't
> see any way around it.

That's information that should be added to a comment..

> > >  	/*
> > >  	 * The transaction was allocated in the I/O submission thread,
> > >  	 * thus we need to mark ourselves as beeing in a transaction
> > > -	 * manually.
> > > +	 * manually. Similarly for freeze protection.
> > >  	 */
> > >  	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
> > > +	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> > > +			   0, 1, _THIS_IP_);
> > 
> > The comment above isn't true anymore, and the flags hack should be
> > removed.
> 
> It's still used by buffered IO in that way.

It's conditionaly though, so there should at least be a "may" in the
sentence.

> > >  	if (ioend->io_type == XFS_IO_UNWRITTEN) {
> > >  		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
> > > +						  ioend->io_size);
> > > +		goto done;
> > > +	}
> > > +
> > > +	/*
> > > +	 * For direct I/O we do not know if we need to allocate blocks or not so
> > > +	 * we can't preallocate an append transaction as that results in nested
> > > +	 * reservations and log space deadlocks. Hence allocate the transaction
> > > +	 * here.  For buffered I/O we preallocate a transaction when submitting
> > > +	 * the IO.
> > > +	 */
> > > +	if (ioend->io_isdirect && xfs_ioend_is_append(ioend)) {
> > 
> > xfs_iomap_write_unwritten already updates the inode size, so this should
> > be an "else if"
> 
> The unwritten branch jumps over this completely if it is taken, so
> it makes no difference. I can change it is you want....

Oh, right - I missed that.  But it seems the else would do the same as
the goto done in your new version, and I generally prefer else if style
control flow for this over gotos.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
