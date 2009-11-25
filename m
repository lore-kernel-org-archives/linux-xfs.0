Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAP057Ca179692 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 18:05:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FD7818D8D4E
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:05:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	8abXyqT3Fxuhi57p for <xfs@oss.sgi.com>;
	Tue, 24 Nov 2009 16:05:32 -0800 (PST)
Date: Wed, 25 Nov 2009 11:05:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: protecting per-ag access in the sync path
Message-ID: <20091125000527.GL3804@discord.disaster>
References: <20091124170455.GA9021@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091124170455.GA9021@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Nov 24, 2009 at 12:04:55PM -0500, Christoph Hellwig wrote:
> Since Linux 2.6.29 we use the perag structures a lot in the sync path,
> but we're not actually protecting against the re-allocation in growfs.

Damn. My fault, I should have thought of that long ago.

> I've recently received a new, fast SSD which allows me to hit those
> races.  With it 104 reproducibly crashes the system, hitting the slab
> redzoning for the old per-ag structure.  I experimentally put
> synchronization using m_peraglock into xfs_inode_ag_walk which fixes the
> issue at the cost of lock order reversals between the i_lock and the
> m_peraglock in various places.

It is worth noting that growfs can already deadlock on the m_peraglock
in a busy filesystem - that is why qa test 104 was disabled for so
long. IIRC, changing the locking mechanism was the only way around
the problem and combined with the lack of real-life incidents of
growfs hangs it has just been left to fester.

My intention was with xfs_get_perag() and xfs_put_perag() was to
slowly move all the places using mp->m_perag[agno] to this
interface and then move the locking into these functions so that
is is easy to modify the locking implementation. It also means
that the implementation of the per-ag structure can easily be
changed.

Ultimately I wanted to move away from using a single great
big array for the m_perag list as scaling to thousands of AGs
requires a significant contiguous chunk of memory to be allocated
for this structure. This would also allow for dynamic addition
or removal of AGs from the list without affecting all the unchanged
AGs. i.e. the m_peraglock would no longer be needed to protect
against use-after-free.

The m_peraglock then really becomes a lookup lock - it is gained
in xfs_get_perag() to find the struct xfs_perag, which is then
internally locked/reference counted, and then the m_peraglock is
dropped. This means that there are no lock inversions against
inodes or other objects because it only protects the tree/list
of perag structures, not the perag structures themselves....

> Any better idea how to protect the new sync path against growfs?

I think a short term fix is to use a second lock only for the sync
traversals.  i.e. growfs does:

	mutex_lock(mp->m_perag_sync_lock);
	write_lock(mp->m_peraglock);
	//realloc
	write_unlock(mp->m_peraglock);
	mutex_unlock(mp->m_perag_sync_lock);

and the sync code uses the lock order:

	m_perag_sync_lock -> inode lock -> m_peraglock

ISTM that this should avoid any new lock inversions and deadlocks
whilst fixing the reported problem. Do that sound workable,
Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
