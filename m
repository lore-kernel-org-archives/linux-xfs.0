Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB54n5le111231 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:49:05 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82F1B1DC2178
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:49:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	baLLqAO8hSYk3CwQ for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:49:00 -0800 (PST)
Date: Mon, 5 Dec 2011 15:32:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/16] xfs: implement lazy removal for the dquot freelist
Message-ID: <20111205043230.GO7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.638600213@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.638600213@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:30AM -0500, Christoph Hellwig wrote:
> Do not remove dquots from the freelist when we grab a reference to them in
> xfs_qm_dqlookup, but leave them on the freelist util scanning notices that
> they have a reference.  This speeds up the lookup fastpath, and greatly
> simplifies the lock ordering constraints.  Note that the same scheme is
> used by the VFS inode and dentry caches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That cleans things up nicely, and should be significantly faster if
the VFS cache examples are anything to go by....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

As an aside:

> +		/*
> +		 * move the dquot to the front of the hashchain
> +		 */
> +		list_move(&dqp->q_hashlist, &qh->qh_list);
> +		trace_xfs_dqlookup_done(dqp);
> +		*O_dqpp = dqp;
> +		return 0;

Back when the inode cache used a hash, we found that this moving of
the item to the front of the list actually slowed down lookups - the
impact of dirtying cachelines (i.e. remote CPU cache invalidation)
to move the item in the list was greater than the time saved during
lookups. That was because that when there are no hash chain
modifications taking place, then the frequently hit chains simply
end up shared in all the cpu caches rather than being turfed out on
every successful lookup on a different CPU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
