Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP7Qtxp237702 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 01:26:55 -0600
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C0951A6B77
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:28:32 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id B2mbPfZi3pQvtkXM for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:28:32 -0800 (PST)
Subject: Re: XFS reclaim lock order bug
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101125070817.GA4120@amd>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124200341.GA2493@infradead.org> <20101125034824.GA3359@amd>
	<1290666325.2072.535.camel@laptop>  <20101125070817.GA4120@amd>
Date: Thu, 25 Nov 2010 08:28:17 +0100
Message-ID: <1290670097.2072.554.camel@laptop>
Mime-Version: 1.0
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>, xfs@oss.sgi.com

On Thu, 2010-11-25 at 18:08 +1100, Nick Piggin wrote:
> > +static struct lock_class_key xfs_dead_inode;
> > +
> >  STATIC void
> >  xfs_fs_evict_inode(
> >       struct inode            *inode)
> > @@ -1118,6 +1120,8 @@ xfs_fs_evict_inode(
> >        */
> >       ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
> >       mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
> > +     lockdep_set_class_and_name(&ip->i_iolock->mr_lock, &xfs_dead_inode, 
> > +                     "xfd_dead_inode");
> >  
> >       xfs_inactive(ip);
> >  }
> 
> With this change, I assume the mrlock_init can go? (it would be nice
> to have a wrapper to allocate the class by itself)


mrlock_init() does allocate a class (well rwsem_init, really), but sets
the name to a stringified version of the lock argument.

The lockdep_set_class*() interface is only guaranteed to work on a
freshly initialized lock structure -- which in this case is a bit of a
waste, but for debugging purposes would allow setting a clearer name.

Alternatively, you can write the code like:

  xfs_inode_t	dead_ip = XFS_I(inode);

  mrlock_init(&dead_ip->i_iolock, ...);

In which case its also obvious, as that would result in:

   (&(&dead_ip->i_iolock)->mr_lock)

as opposed to:

   (&(&ip->i_iolock)->mr_lock)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
