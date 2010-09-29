Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TBcKYg044246 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 06:38:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C4271885286
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:39:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	tINaZ9e29fCvI16D for <xfs@oss.sgi.com>;
	Wed, 29 Sep 2010 04:39:18 -0700 (PDT)
Date: Wed, 29 Sep 2010 21:39:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] [PATCH 2/3] xfs: do not use xfs_mod_incore_sb for
	per-cpu counters
Message-ID: <20100929113914.GP5665@dastard>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072238.162539532@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929072238.162539532@bombadil.infradead.org>
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

On Wed, Sep 29, 2010 at 03:22:23AM -0400, Christoph Hellwig wrote:
> Export xfs_icsb_modify_counters and always use it for modifying the per-cpu
> counters.  Remove support for per-cpu counters from xfs_mod_incore_sb to
> simplify it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Couple of things, though.

>  			nblks += cur->bc_private.b.allocated;
>  		ASSERT(nblks <= da_old);
>  		if (nblks < da_old)
> -			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
> +			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
>  				(int64_t)(da_old - nblks), rsvd);
>  	}
>  	/*
> @@ -1078,8 +1078,8 @@ xfs_bmap_add_extent_delay_real(
>  		temp2 = xfs_bmap_worst_indlen(ip, temp2);
>  		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
>  			(cur ? cur->bc_private.b.allocated : 0));
> -		if (diff > 0 &&
> -		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
> +		if (diff > 0 && xfs_icsb_modify_counters(ip->i_mount,
> +				XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {

Not sure I like the indenting of the second line. I'd prefer the
parameters to have a little more indent or use three lines...

>  int
>  xfs_mod_incore_sb(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field,
> -	int64_t		delta,
> -	int		rsvd)
> +	struct xfs_mount	*mp,
> +	xfs_sb_field_t		field,
> +	int64_t			delta,
> +	int			rsvd)
>  {
> -	int	status;
> +	int			status;
>  
> -	/* check for per-cpu counters */
> -	switch (field) {
> -#ifdef HAVE_PERCPU_SB
> -	case XFS_SBS_ICOUNT:
> -	case XFS_SBS_IFREE:
> -	case XFS_SBS_FDBLOCKS:
> -		status = xfs_icsb_modify_counters(mp, field, delta, rsvd);
> -		break;
> -#endif
> -	default:
> -		spin_lock(&mp->m_sb_lock);
> -		status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
> -		spin_unlock(&mp->m_sb_lock);
> -		break;
> -	}
> +	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);

That assert will cause issues with:

> @@ -97,6 +99,8 @@ extern void	xfs_icsb_sync_counters_locke
>  #define xfs_icsb_reinit_counters(mp)		do { } while (0)
>  #define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
>  #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
> +#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
> +	xfs_mod_incore_sb(mp, field, delta, rsvd)
>  #endif

UP builds. Perhaps a CONFIG_SMP only assert? Given that the per-cpu
counter rework I'm doing doesn't have a different code path for
UP vs SMP, it'd only be a temporary concern....

>  undo_blocks:
>  	if (blocks > 0) {
> -		(void) xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
> +		(void) xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
>  					 (int64_t)blocks, rsvd);

You can kill the (void) cast there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
