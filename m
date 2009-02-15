Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FJQC7e091574 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 13:26:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF08F122D44
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:25:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oJxmd2zItcDRFsTg for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:25:38 -0800 (PST)
Date: Sun, 15 Feb 2009 14:25:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
Message-ID: <20090215192507.GA15360@infradead.org>
References: <49921B3E.8040406@sgi.com> <20090211092020.GR8830@disturbed>
	<49937458.2000500@sgi.com> <20090212223253.GV8830@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090212223253.GV8830@disturbed>
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
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 13, 2009 at 09:32:53AM +1100, Dave Chinner wrote:
> > Yes, I agree.  I just don't have the time to hunt it down.  I see
> > there's a call to xfs_idestroy_fork() in xfs_ireclaim() for directories
> > but xfs_ireclaim() gets called after xfs_iflush() in xfs_reclaim_inode().
> 
> I suspect it should be in xfs_inactive() if we are in local format.
> This is what happens with the attribute fork.  I think that is where
> we need something like:
> 
> 	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR &&
> 	    ip->i_d.di_nextents == 0)
> 		xfs_idestroy_fork(ip, XFS_DATA_FORK);

Why would we special case directories?

> > Might also need something like:
> >
> > @@ -2445,6 +2447,7 @@ xfs_idestroy_fork(
> >                         kmem_free(ifp->if_u1.if_data);
> >                         ifp->if_u1.if_data = NULL;
> >                         ifp->if_real_bytes = 0;
> > +                       ifp->if_bytes = 0;
> >                 }
> >         } else if ((ifp->if_flags & XFS_IFEXTENTS) &&
> >                    ((ifp->if_flags & XFS_IFEXTIREC) ||
> 
> Looking at that, the whole if (local) {} else if (extent/btree)
> code could probably be replaced with a single call to
> xfs_iext_destroy() as it does the cleanup correctly in both cases,
> anyway....

We could, but with the way the function name, comments and how the
unions are set up it would be very confusing to the user. 


Btw, I can't reproduce this issue with the extent.c program and the
invocation from the next patch.  Does it need other parameters to
reproduce?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
