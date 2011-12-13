Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDMJKqG177037 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 16:19:21 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A80D15718BD
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 14:19:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	n9zgE50sUwlsrqc4 for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 14:19:19 -0800 (PST)
Date: Wed, 14 Dec 2011 09:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs: replace i_flock with a sleeping bitlock
Message-ID: <20111213221917.GD3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.493178782@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155918.493178782@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:58:01AM -0500, Christoph Hellwig wrote:
> We almost never block on i_flock, the exception is synchronous inode
> flushing.  Instead of bloating the inode with a 16/24-byte completion
> that we abuse as a semaphore just implement it as a bitlock that uses
> a bit waitqueue for the rare sleeping path.  This primarily is a
> tradeoff between a much smaller inode and a faster non-blocking
> path vs faster wakeups, and we are much better off with the former.
> 
> A small downside is that we will lose lockdep checking for i_flock, but
> given that it's always taken inside the ilock that should be acceptable.

I didn't think we had lockdep checking on the i_flock because it
uses completions rather than real lock primitives. Either way, I'm
not concerned about this aspect of the change - lockdep doesn't pick
up the typical sort of holdoff problems that i_flock vs delwri
trigger...

> Note that for example the inode writeback locking is implemented in a
> very similar way.

....

> +
> +static inline void xfs_ifunlock(struct xfs_inode *ip)
> +{
> +	xfs_iflags_clear(ip, XFS_IFLOCK);
> +	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
> +}

Should the wakeup be done whilst the ip->i_flags_lock is still held?
The VFS code does the __I_SYNC wakeup while still holding the
inode->i_lock so that the clear and wakeup are atomic, similarly the
__I_NEW bit....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
