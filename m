Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VMJOxd079144 for <xfs@oss.sgi.com>; Tue, 31 May 2011 17:19:24 -0500
Subject: Re: [PATCH 1/2] xfs: clear inode per-lifetime state when recycling it
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1306815659-23346-2-git-send-email-david@fromorbit.com>
References: <1306815659-23346-1-git-send-email-david@fromorbit.com>
	<1306815659-23346-2-git-send-email-david@fromorbit.com>
Date: Tue, 31 May 2011 17:19:19 -0500
Message-ID: <1306880359.2865.73.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-05-31 at 14:20 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFs inodes have several per-lifetime state flags that determine heaviour of the
> inode. These state flags are not reset when an inode is reallocated and reused
> from the reclaimable state.
> 
> This can lead to specualtive preallocation not being truncated away in the
> expected manner for local files until the inode is subsequently truncated,
> freed or cycles out of the cache. It can also lead to an inode being considered
> to be a filestream inode or having been truncated when that is not the case.
> 
> Clear the state flags when the inode is recycled to avoid these problems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Other than simple typo's, this looks good to me.

Comment below.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_iget.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index cb9b6d1..36467f1 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -262,7 +262,17 @@ xfs_iget_cache_hit(
>  
>  		spin_lock(&pag->pag_ici_lock);
>  		spin_lock(&ip->i_flags_lock);
> -		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
> +
> +		/*
> +		 * Clear the relcaim and per-lifetime state flags as we are now

                              reclaim

> +		 * effectively a new inode and so we need to reset to the
> +		 * initial state.
> +		 *
> +		 * XXX(dgc): should the XFS_ISTALE flag only be cleared here?
> +		 */
> +		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM |
> +				 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED |
> +				 XFS_IFILESTREAM);
>  		ip->i_flags |= XFS_INEW;

If you clear XFS_ISTALE here you could simply re-phrase the
above comment to emphasize the "reset to initial state" and
change it to a simple assignment:

 		ip->i_flags = XFS_INEW;

(Though that makes clearing the rest of the flags
implicit, which I think is undesirable from the point
of view of code searching.  XFS_IDIRTY_RELEASE is
already cleared only implicitly.)

Otherwise I was going to suggest you define a symbol
representing the subset of XFS inode flags that are
per-lifetime state flags, so if another one gets
invented along the way it could get added to the set.


>  		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
>  		inode->i_state = I_NEW;



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
