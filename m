Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEMHtqS233122 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 16:17:55 -0600
Date: Wed, 14 Dec 2011 16:18:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 12/19] xfs: flatten the dquot lock ordering
Message-ID: <20111214221820.GE29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.769664827@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.769664827@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:18PM -0500, Christoph Hellwig wrote:
> Introduce a new XFS_DQ_FREEING flag that tells lookup and mplist walks
> to skip a dquot that is beeing freed, and use this avoid the trylock
> on the hash and mplist locks in xfs_qm_dqreclaim_one.  Also simplify
> xfs_dqpurge by moving the inodes to a dispose list after marking them
> XFS_DQ_FREEING and avoid the locker ordering constraints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Wow.  That was a tough review.
Reviewed-by: Ben Myers <bpm@sgi.com>

> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
...  
> @@ -1737,57 +1716,42 @@ again:
>  			}
>  			goto dqunlock;
>  		}
> +		xfs_dqfunlock(dqp);
>  
>  		/*
> -		 * We're trying to get the hashlock out of order. This races
> -		 * with dqlookup; so, we giveup and goto the next dquot if
> -		 * we couldn't get the hashlock. This way, we won't starve
> -		 * a dqlookup process that holds the hashlock that is
> -		 * waiting for the freelist lock.
> +		 * Prevent lookup now that we are going to reclaim the dquot.
> +		 * Once XFS_DQ_FREEING is set lookup won't touch the inode,
								     dquot

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
