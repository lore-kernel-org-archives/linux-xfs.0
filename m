Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BA1C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 20:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiF2U4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiF2U4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 16:56:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283F924BFD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 13:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99CF9B824B7
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 20:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7ADC34114;
        Wed, 29 Jun 2022 20:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656536180;
        bh=D3Na3jwbZGWPSwrgK8IYfMF8UZ8yQWZJAX31l3klnK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXdXAyqiD5fUuYy+PcR3Wo4QfXMb5V9cGEN82fasZQM0ETN4ALERpyoXq63oMZ3aK
         Vsggb622RJnSyWpdQ5zVggDqF3QM8i8QxPuNHiddXRlRN4qymxG1OS1J1jMq+8slat
         lTLfqkvifg3lx7UwB8g55cMV+1QcBXuA4/pUjBd2DH3Nn+Ff4rXp0Vz0ZP1me4FZrg
         qLAQ719U2d3MYFNNGv/C0N/KfoEDRsGc3hkWTqwh+EL8/u/TrUkULVGhy7IMl8iGRn
         u3kjY0GryGvtg88j5pFOdruutX2shp6cSzbUpxCNc5aR+zvQsFLXEVxCZfFV+HnE9z
         sbgsv/j/x3u7w==
Date:   Wed, 29 Jun 2022 13:56:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: refactor xlog_recover_process_iunlinks()
Message-ID: <Yry8cwIemNfeJIcs@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:30AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For upcoming changes to the way inode unlinked list processing is
> done, the structure of recovery needs to change slightly. We also
> really need to untangle the messy error handling in list recovery
> so that actions like emptying the bucket on inode lookup failure
> are associated with the bucket list walk failing, not failing
> to look up the inode.
> 
> Refactor the recovery code now to keep the re-organisation seperate
> to the algorithm changes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 162 ++++++++++++++++++++-------------------
>  1 file changed, 84 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f360b46533a6..7d0f530d7e3c 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2627,23 +2627,23 @@ xlog_recover_cancel_intents(
>   * This routine performs a transaction to null out a bad inode pointer
>   * in an agi unlinked inode hash bucket.
>   */
> -STATIC void
> +static void
>  xlog_recover_clear_agi_bucket(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agno,
> -	int		bucket)
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,

Why even pass in *mp when you've got *pag?

> +	int			bucket)
>  {
> -	xfs_trans_t	*tp;
> -	xfs_agi_t	*agi;
> -	struct xfs_buf	*agibp;
> -	int		offset;
> -	int		error;
> +	struct xfs_trans	*tp;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	int			offset;
> +	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
>  	if (error)
>  		goto out_error;
>  
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> +	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
>  	if (error)
>  		goto out_abort;
>  
> @@ -2662,46 +2662,40 @@ xlog_recover_clear_agi_bucket(
>  out_abort:
>  	xfs_trans_cancel(tp);
>  out_error:
> -	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
> +	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.",
> +		__func__, pag->pag_agno);
>  	return;

Nit: Don't need the return here.

Otherwise looks good.

--D

>  }
>  
> -STATIC xfs_agino_t
> -xlog_recover_process_one_iunlink(
> -	struct xfs_mount		*mp,
> -	xfs_agnumber_t			agno,
> -	xfs_agino_t			agino,
> -	int				bucket)
> +static int
> +xlog_recover_iunlink_bucket(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	struct xfs_agi		*agi,
> +	int			bucket)
>  {
> -	struct xfs_inode		*ip;
> -	xfs_ino_t			ino;
> -	int				error;
> +	struct xfs_inode	*ip;
> +	xfs_agino_t		agino;
>  
> -	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> -	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
> -	if (error)
> -		goto fail;
> +	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +	while (agino != NULLAGINO) {
> +		int	error;
>  
> -	xfs_iflags_clear(ip, XFS_IRECOVERY);
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> +		error = xfs_iget(mp, NULL,
> +				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
> +				0, 0, &ip);
> +		if (error)
> +			return error;;
>  
> -	/* setup for the next pass */
> -	agino = ip->i_next_unlinked;
> -	xfs_irele(ip);
> -	return agino;
> +		ASSERT(VFS_I(ip)->i_nlink == 0);
> +		ASSERT(VFS_I(ip)->i_mode != 0);
> +		xfs_iflags_clear(ip, XFS_IRECOVERY);
> +		agino = ip->i_next_unlinked;
>  
> - fail:
> -	/*
> -	 * We can't read in the inode this bucket points to, or this inode
> -	 * is messed up.  Just ditch this bucket of inodes.  We will lose
> -	 * some inodes and space, but at least we won't hang.
> -	 *
> -	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> -	 * clear the inode pointer in the bucket.
> -	 */
> -	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> -	return NULLAGINO;
> +		xfs_irele(ip);
> +		cond_resched();
> +	}
> +	return 0;
>  }
>  
>  /*
> @@ -2727,51 +2721,63 @@ xlog_recover_process_one_iunlink(
>   * scheduled on this CPU to ensure other scheduled work can run without undue
>   * latency.
>   */
> -STATIC void
> -xlog_recover_process_iunlinks(
> -	struct xlog	*log)
> +static void
> +xlog_recover_iunlink_ag(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
>  {
> -	struct xfs_mount	*mp = log->l_mp;
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  	struct xfs_agi		*agi;
>  	struct xfs_buf		*agibp;
> -	xfs_agino_t		agino;
>  	int			bucket;
>  	int			error;
>  
> -	for_each_perag(mp, agno, pag) {
> -		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
> +	error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
> +	if (error) {
> +		/*
> +		 * AGI is b0rked. Don't process it.
> +		 *
> +		 * We should probably mark the filesystem as corrupt after we've
> +		 * recovered all the ag's we can....
> +		 */
> +		return;
> +	}
> +
> +	/*
> +	 * Unlock the buffer so that it can be acquired in the normal course of
> +	 * the transaction to truncate and free each inode.  Because we are not
> +	 * racing with anyone else here for the AGI buffer, we don't even need
> +	 * to hold it locked to read the initial unlinked bucket entries out of
> +	 * the buffer. We keep buffer reference though, so that it stays pinned
> +	 * in memory while we need the buffer.
> +	 */
> +	agi = agibp->b_addr;
> +	xfs_buf_unlock(agibp);
> +
> +	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> +		error = xlog_recover_iunlink_bucket(mp, pag, agi, bucket);
>  		if (error) {
>  			/*
> -			 * AGI is b0rked. Don't process it.
> -			 *
> -			 * We should probably mark the filesystem as corrupt
> -			 * after we've recovered all the ag's we can....
> +			 * Bucket is unrecoverable, so only a repair scan can
> +			 * free the remaining unlinked inodes. Just empty the
> +			 * bucket and remaining inodes on it unreferenced and
> +			 * unfreeable.
>  			 */
> -			continue;
> +			xlog_recover_clear_agi_bucket(mp, pag, bucket);
>  		}
> -		/*
> -		 * Unlock the buffer so that it can be acquired in the normal
> -		 * course of the transaction to truncate and free each inode.
> -		 * Because we are not racing with anyone else here for the AGI
> -		 * buffer, we don't even need to hold it locked to read the
> -		 * initial unlinked bucket entries out of the buffer. We keep
> -		 * buffer reference though, so that it stays pinned in memory
> -		 * while we need the buffer.
> -		 */
> -		agi = agibp->b_addr;
> -		xfs_buf_unlock(agibp);
> -
> -		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> -			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> -			while (agino != NULLAGINO) {
> -				agino = xlog_recover_process_one_iunlink(mp,
> -						pag->pag_agno, agino, bucket);
> -				cond_resched();
> -			}
> -		}
> -		xfs_buf_rele(agibp);
> +	}
> +
> +	xfs_buf_rele(agibp);
> +}
> +
> +static void
> +xlog_recover_process_iunlinks(
> +	struct xlog	*log)
> +{
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno;
> +
> +	for_each_perag(log->l_mp, agno, pag) {
> +		xlog_recover_iunlink_ag(log->l_mp, pag);
>  	}
>  
>  	/*
> @@ -2779,7 +2785,7 @@ xlog_recover_process_iunlinks(
>  	 * are fully completed on disk and the incore inodes can be reclaimed
>  	 * before we signal that recovery is complete.
>  	 */
> -	xfs_inodegc_flush(mp);
> +	xfs_inodegc_flush(log->l_mp);
>  }
>  
>  STATIC void
> -- 
> 2.36.1
> 
