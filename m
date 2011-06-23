Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NLLLpP217901 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 16:21:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2768297F2
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 14:21:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	S4ETgVoqryPbqY4k for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2011 14:21:20 -0700 (PDT)
Date: Thu, 23 Jun 2011 17:21:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: reset inode per-lifetime state when recycling it
Message-ID: <20110623212115.GA18901@infradead.org>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
	<1308792901-22880-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1308792901-22880-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 23, 2011 at 11:34:59AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS inodes has several per-lifetime state fields that determine the
> behaviour of the inode. These state fields are not all reset when an
> inode is reused from the reclaimable state.
> 
> This can lead to unexpected behaviour of the new inode such as
> speculative preallocation not being truncated away in the expected
> manner for local files until the inode is subsequently truncated,
> freed or cycles out of the cache. It can also lead to an inode being
> considered to be a filestream inode or having been truncated when
> that is not the case.
> 
> Rework the reinitialisation of the inode when it is recycled to
> ensure that it is pristine before it is reused. While there, also
> fix the resetting of state flags in the recycling error paths so the
> inode does not become unreclaimable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iget.c  |   13 +++++++++----
>  fs/xfs/xfs_inode.h |   10 ++++++++++
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index cb9b6d1..3631783 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -253,16 +253,21 @@ xfs_iget_cache_hit(
>  			rcu_read_lock();
>  			spin_lock(&ip->i_flags_lock);
>  
> -			ip->i_flags &= ~XFS_INEW;
> -			ip->i_flags |= XFS_IRECLAIMABLE;
> -			__xfs_inode_set_reclaim_tag(pag, ip);
> +			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
> +			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);

Looking over this again XFS_INEW can't be set here, as we return early
a few lines above.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
