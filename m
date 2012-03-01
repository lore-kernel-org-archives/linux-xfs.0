Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q213wWcN074424 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 21:58:33 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	w2xjytu4A8ibM9wo for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 19:58:31 -0800 (PST)
Date: Thu, 1 Mar 2012 14:58:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120301035812.GA5091@dastard>
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
	<20120229005351.GV3592@dastard> <20120229014906.GX3592@dastard>
	<20120301030324.GX28391@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120301030324.GX28391@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Feb 29, 2012 at 09:03:24PM -0600, Ben Myers wrote:
> > The race condition is between the insertion of the inode into the
> > cache in the case of a cache miss and a concurrently lookup:
> > 
> > Thread 1			Thread 2
> > xfs_iget()
> >   xfs_iget_cache_miss()
> >     xfs_iread()
> >     lock radix tree
> >     radix_tree_insert()
> >     				rcu_read_lock
> > 				radix_tree_lookup
> > 				lock inode flags
> > 				XFS_INEW not set
> > 				igrab()
> > 				unlock inode flags
> > 				rcu_read_unlock
> > 				use uninitialised inode
> > 				.....
> >     lock inode flags
> >     set XFS_INEW
> >     unlock inode flags
> >     unlock radix tree
> >   xfs_setup_inode()
> >     inode flags = I_NEW
> >     unlock_new_inode()
> >       WARNING as inode flags != I_NEW

.....

> > -	spin_lock(&pag->pag_ici_lock);
> > +	/* These values _must_ be set before inserting the inode into the radix
> > +	 * tree as the moment it is inserted a concurrent lookup (allowed by the
> > +	 * RCU locking mechanism) can find it and that lookup must see that this
> > +	 * is an inode currently under construction (i.e. that XFS_INEW is set).
> > +	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
> > +	 * memory barrier that ensures this detection works correctly at lookup
> > +	 * time.
> > +	 */
> > +	xfs_iflags_set(ip, XFS_INEW);
> > +	ip->i_udquot = ip->i_gdquot = NULL;
> >  
> >  	/* insert the new inode */
> > +	spin_lock(&pag->pag_ici_lock);
> >  	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
> >  	if (unlikely(error)) {
> >  		WARN_ON(error != -EEXIST);
> > @@ -360,11 +370,6 @@ xfs_iget_cache_miss(
> >  		error = EAGAIN;
> >  		goto out_preload_end;
> >  	}
> > -
> > -	/* These values _must_ be set before releasing the radix tree lock! */
> 							   ^^^ 
> So, in this comment 'radix tree lock' refers to pag->pag_ici_lock?

Right. "ici" is short for "in-core inode". So pag_ici_lock reads as
"per-ag in-core inode lock". The lock is used to protect
modifications to the in-core inode cache which is radix tree indexed
and the root is at pag_ici_root...

> And, pag_ici_lock lock provides no exclusion with radix_tree_lookup.

Right, but rcu based radix tree traversal is safe as long as the
objects being indexed are RCU freed and have some external method of
validating their freed/in use state independent of the radix tree
lookup. IOWs, tree lookups are not synchronised with inserts,
deletes or tag modifications - the are synchronised with RCU freeing
of the objects the tree points to. Hence we only need to validate
the objects against races with RCU freeing after the tree lookup -
we don't need to care about the state of the tree at all....

> I believe I understand.  That isn't to say that I couldn't use a
> brush-up on RCU.  Awesome.  ;)

RCU is tricky. It took me a long time to convince myself that we
could use RCU lookups here because it relies on memory barriers
rather than locking to ensure coherency across all CPUs.  I firmly
beleive that when a concept is difficult to understand, it shouldn't
be made harder to understand by optimising it with a smart and/or
tricky implementation. Spin locks provide memory barriers and they
are something simple that everyone understands, therefore all we
need to concentrate on is the order in which operations occur....

FWIW, once I had decided on the memory barrier implementation
(ip->i_flags_lock), there were three basic principles I followed to
prove to myself that the inode cache lookup is RCU safe:

	1. that the state of inodes in the process of removal from
	the tree is detectable during lookup (i.e. via the
	XFS_IRECLAIM flag).

	2. that inodes in the process of being freed (regardless of
	removal state) in the RCU grace period can be detected (i.e.
	by clearing ip->i_ino before calling rcu_free)

	3. that the state of new inodes is detectable during lookup
	so we can avoid them until they are fully initialised. i.e.
	the XFS_INEW flag.

That's why xfs_iget_cache_hit() takes the i_flags_lock, then checks
ip->i_ino and against the XFS_INEW | XFS_IRECLAIM flags, and
xfs_inode_free() ensures that ip->i_ino = 0 and XFS_IRECLAIM is set
before calling rcu_free() on the inode. The problem was that I
hadn't got the ordering of operations for #3 correct, and that's
what the bug fix is for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
