Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L9FgfZ248207 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 04:15:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 120C01F580
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 02:15:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gMLgM2DC0wkGqehV for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2011 02:15:38 -0700 (PDT)
Date: Tue, 21 Jun 2011 05:15:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: split xfs_setattr
Message-ID: <20110621091536.GA9475@infradead.org>
References: <20110617131519.GA2822@infradead.org>
	<20110621012150.GK32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110621012150.GK32466@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jun 21, 2011 at 11:21:50AM +1000, Dave Chinner wrote:
> I'm not sure that xfs_setattr_simple() is the best name for this.
> It's not really a simple setattr case, it's all the "all except size"
> changes. Perhaps xfs_setattr_nonsize() and xfs_setattr_size()
> would be a better name pair...

Ok.

> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> > +	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> > +	if (error)
> > +		goto error_return;
> > +
> > +	lock_flags = XFS_ILOCK_EXCL;
> > +	xfs_ilock(ip, lock_flags);
> 
> With a slight change to the error unwind stack, you can kill the
> lock_flags variable altogether - it never gets changed in the code
> except for here. 

> If you change it to:
> 
> error_return:
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> error_free_tp:
> 	xfs_trans_cancel(tp, 0);
> 	xfs_qm_dqrele(udqp);
> 	xfs_qm_dqrele(gdqp);
> 	return error;
> 
> And jump to error_free_tp when xfs_trans_reserve() fails above,
> lock_flags and the conditionals in the unwind stack go away.

We'll actually need a third label for just the dqrele calls, as we
get references to the dqouts before allocating the transaction.  And
even with that we change the order of cleanup even if that seems
harmless from a quick audit.

I've prepared a version with the suggestions for QA, but I have a bit
of an uneasy feeling about mixing up such subtile changes with the
simple split.

> > +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > +		xfs_trans_set_sync(tp);
> > +
> > +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> > +	goto out_unlock;
> > +
> > +out_trans_abort:
> > +	commit_flags |= XFS_TRANS_ABORT;
> > +out_trans_cancel:
> > +	xfs_trans_cancel(tp, commit_flags);
> > +out_unlock:
> > +	if (lock_flags)
> > +		xfs_iunlock(ip, lock_flags);
> > +	return error;
> > +}
> 
> And here we never get to out_unlock without lock_flags being set, so
> the conditional can be removed.

We can.  E.g. the zero length truncate case (which is removed in the
next patch) does it, as  does the xfs_flush_pages case if XFS_ATTR_NOLOCK
is set.  So I'd rather leave it in instead of hacking around those cases.

> I also think that the goto after the
> commit call is a bit ugly. I'd prefer the none-failure case is
> straight line code so it is easy to follow, and the unwind stack has
> an extra jump in it. i.e.:

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
