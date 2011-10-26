Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QL7Pro036184 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 16:07:26 -0500
Message-ID: <1319663241.5239.74.camel@doink>
Subject: Re: [PATCH 2/4] xfs: replace i_flock with a sleeping bitlock
From: Alex Elder <aelder@sgi.com>
Date: Wed, 26 Oct 2011 16:07:21 -0500
In-Reply-To: <20111019182420.881974453@bombadil.infradead.org>
References: <20111019182343.762985925@bombadil.infradead.org>
	<20111019182420.881974453@bombadil.infradead.org>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-10-19 at 14:23 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-kill-i_flush)
> We almost never block on i_flock, the exception is synchronous inode
> flushing.  Instead of bloating the inode with a 16/24-byte completion
> that we abuse as a semaphore just implement it as a bitlock that uses
> a bit waitqueue for the rare sleeping path.  This primarily is a
> tradeoff between a much smaller inode and a faster non-blocking
> path vs a faster faster wakeups, and we are much better off with
       vs faster wakeups
> the former.
> 
> A small downside is that we will lose lockdep checking for i_flock, but
> given that it's always taken inside the ilock that should be acceptable.
> 
> Note that for example the inode writeback locking is implemented in a
> very similar way.

Substitute "beeing" -> "being" throughout.  There's
also one thing I'd like you to check and likely fix,
below.  Otherwise looks good.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -331,6 +330,19 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
>  	return ret;
>  }
>  
> +static inline int
> +xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)

i_flags is now an unsigned long (so make the
flags argument here match that type).

> +{
> +	int ret;
> +
> +	spin_lock(&ip->i_flags_lock);
> +	ret = ip->i_flags & flags;
> +	if (!ret)
> +		ip->i_flags |= flags;

Although you are now only passing in a single
flag bit, the interface doesn't preclude you
passing in multiple bits.

Therefore I think the correct logic would be:

	ret = (ip->i_flags & flags) != flags;
	if (ret)
		ip->flags |= flags;

Either that, or change the name of the "flags"
argument to better reflect that we really want
a single lock bit provided (and perhaps,
ASSERT(is_power_of_2(flags))).

> +	spin_unlock(&ip->i_flags_lock);
> +	return ret;
> +}
> +

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
