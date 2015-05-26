Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A1457F3F
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:45:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46CF48F8033
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 16:45:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	haumaDUYwBtNfhRX for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 16:45:17 -0700 (PDT)
Date: Wed, 27 May 2015 09:44:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: xfs_attr_inactive leaves inconsistent attr fork
	state behind
Message-ID: <20150526234458.GZ4316@dastard>
References: <1430780408-12539-1-git-send-email-david@fromorbit.com>
	<1430780408-12539-3-git-send-email-david@fromorbit.com>
	<20150506050208.GA4278@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506050208.GA4278@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, May 05, 2015 at 10:02:08PM -0700, Christoph Hellwig wrote:
> > -STATIC void
> > +void
> >  xfs_attr_fork_reset(
> 
> Maybe rename it to xfs_attr_fork_remove while you're at it?

Done.

> > +	xfs_ilock(dp, lock_mode);
> > +	if (!XFS_IFORK_Q(dp))
> > +		goto out_destroy_fork;
> > +	xfs_iunlock(dp, lock_mode);
> 
> The use of a goto here seems confsing as it moves the code to just
> free the attribute code out of line like some error handling.

Well, it is effectively an error case, because we check before entry
that this shouldn't occur...

> It could also use a comment on when we have an in-memory attribute
> fork but XFS_IFORK_Q is false.  I don't really know when that
> would be true given that xfs_attr_shortform_remove either removes
> the attribute fork, or asserts that the forkoff is non-zero when
> it is left as-is.

If was just maintaining the logic we currently have. There are
separate checks for on disk and in memory attr fork structures in
the code path. i.e. being conservative and just fixing the bug
rather than rewriting everything with different logic because it has
to be back ported to several stable kernels...

> >  	/*
> > -	 * Decide on what work routines to call based on the inode size.
> > +	 * It's unlikely we've raced with an attribute fork creation, but check
> > +	 * anyway just in case.
> >  	 */
> 
> We always need to check for races if they are possible, no matter how
> unlikely they are.  So that just in case comment seems confusing.

Removed.

> 
> > +	if (XFS_IFORK_Q(ip)) {
> >  		error = xfs_attr_inactive(ip);
> >  		if (error)
> >  			return;
> >  	}
> 
> Given that we don't even call xfs_attr_inactive when XFS_IFORK_Q is
> false the check above doesn't seem to be reachable anyway.  At least
> I can't think of a way how we could add an attr fork in a way that
> races with inode teardown.

Like I said, it's just maintaining the existing logic. we can clean
this up later with patches that don't need to be backported to other
kernels...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
