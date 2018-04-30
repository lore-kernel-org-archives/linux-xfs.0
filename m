Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753840AbeD3RTs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 13:19:48 -0400
Date: Mon, 30 Apr 2018 13:19:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180430171945.GB22176@bfoster.bfoster>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525102372-8430-3-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
> XFS recently added support for async discards. While this can be
> a win for some workloads and devices, there are also cases where
> async bursty discard will severly harm the latencies of reads
> and writes.
> 
> Add a 'discard_sync' mount flag to revert to using sync discard,
> issuing them one at the time and waiting for each one. This fixes
> a big performance regression we had moving to kernels that include
> the XFS async discard support.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Hm, I figured the async discard stuff would have been a pretty clear win
all around, but then again I'm not terribly familiar with what happens
with discards beneath the fs. I do know that the previous behavior would
cause fs level latencies due to holding up log I/O completion while
discards completed one at a time. My understanding is that this lead to
online discard being pretty much universally "not recommended" in favor
of fstrim.

Do you have any more data around the workload where the old sync discard
behavior actually provides an overall win over the newer behavior? Is it
purely a matter of workload, or is it a workload+device thing with how
discards may be handled by certain devices?

I'm ultimately not against doing this if it's useful for somebody and is
otherwise buried under a mount option, but it would be nice to see if
there's opportunity to improve the async mechanism before resorting to
that. Is the issue here too large bio chains, too many chains at once,
or just simply too many discards (regardless of chaining) at the same
time?

I'm wondering if xfs could separate discard submission from log I/O
completion entirely and then perhaps limit/throttle submission somehow
or another (Christoph, thoughts?) via a background task. Perhaps doing
something like that may even eliminate the need for some discards on
busy filesystems with a lot of block free -> reallocation activity, but
I'm just handwaving atm.

Brian

>  fs/xfs/xfs_log_cil.c | 18 ++++++++++++++----
>  fs/xfs/xfs_mount.h   |  1 +
>  fs/xfs/xfs_super.c   |  7 ++++++-
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4668403b1741..4eced3eceea5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -552,10 +552,16 @@ xlog_discard_busy_extents(
>  	struct bio		*bio = NULL;
>  	struct blk_plug		plug;
>  	int			error = 0;
> +	int			discard_flags = 0;
> +	bool			sync_discard = mp->m_flags & XFS_MOUNT_DISCARD_SYNC;
>  
>  	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
>  
> -	blk_start_plug(&plug);
> +	if (!sync_discard)
> +		blk_start_plug(&plug);
> +	else
> +		discard_flags = BLKDEV_DISCARD_SYNC;
> +
>  	list_for_each_entry(busyp, list, list) {
>  		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
>  					 busyp->length);
> @@ -563,7 +569,7 @@ xlog_discard_busy_extents(
>  		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
>  				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
>  				XFS_FSB_TO_BB(mp, busyp->length),
> -				GFP_NOFS, 0, &bio);
> +				GFP_NOFS, discard_flags, &bio);
>  		if (error && error != -EOPNOTSUPP) {
>  			xfs_info(mp,
>  	 "discard failed for extent [0x%llx,%u], error %d",
> @@ -574,14 +580,18 @@ xlog_discard_busy_extents(
>  		}
>  	}
>  
> -	if (bio) {
> +	if (sync_discard) {
> +		xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
> +		kmem_free(ctx);
> +	} else if (bio) {
>  		bio->bi_private = ctx;
>  		bio->bi_end_io = xlog_discard_endio;
>  		submit_bio(bio);
> +		blk_finish_plug(&plug);
>  	} else {
>  		xlog_discard_endio_work(&ctx->discard_endio_work);
> +		blk_finish_plug(&plug);
>  	}
> -	blk_finish_plug(&plug);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 10b90bbc5162..3f0b7b9106c7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -219,6 +219,7 @@ typedef struct xfs_mount {
>  						   operations, typically for
>  						   disk errors in metadata */
>  #define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
> +#define XFS_MOUNT_DISCARD_SYNC	(1ULL << 6)	/* discard unused blocks sync */
>  #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
>  						   allocations */
>  #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d71424052917..6d960bb4725f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -83,7 +83,7 @@ enum {
>  	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
>  	Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err, Opt_discard_sync,
>  };
>  
>  static const match_table_t tokens = {
> @@ -129,6 +129,7 @@ static const match_table_t tokens = {
>  	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit enforcement */
>  	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
>  	{Opt_discard,	"discard"},	/* Discard unused blocks */
> +	{Opt_discard_sync,"discard_sync"},/* Discard unused blocks sync */
>  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
>  
>  	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
> @@ -363,11 +364,15 @@ xfs_parseargs(
>  			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
>  			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
>  			break;
> +		case Opt_discard_sync:
> +			mp->m_flags |= XFS_MOUNT_DISCARD_SYNC;
> +			/* fall through and set XFS_MOUNT_DISCARD too */
>  		case Opt_discard:
>  			mp->m_flags |= XFS_MOUNT_DISCARD;
>  			break;
>  		case Opt_nodiscard:
>  			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +			mp->m_flags &= ~XFS_MOUNT_DISCARD_SYNC;
>  			break;
>  #ifdef CONFIG_FS_DAX
>  		case Opt_dax:
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
