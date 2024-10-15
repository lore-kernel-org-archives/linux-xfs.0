Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F01CB9FC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729009144; cv=none; b=UTuSuMB9dSfwAZJfCoqNIP0QyCZUFzcXwkmMY+3P769Jjmd+wonI68eO629i0D6IJCwphjNOh7uW5ED8+m4jy1gTV38GZjg2oUuiervdMaSBTckmTrSjbGovGmlEHU/b2oSt7BiYhMNpoKfs3nbDG3qMdtKFBuhBPQQPohvEUrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729009144; c=relaxed/simple;
	bh=AmtixfYNWoZKuzk15uzQk7KeAxEXbsF9GlNywoFtxz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHlkcYa5tFbyY5k52x+3p3ha2oL9uvb5NPT1DeuRjRd6oJzzg9wKPZMhXseswkbHmlBDDLtNO96qAn3RdM8daYdY1aG/PPRt1rgfajBYqF+K3lZQZf7eDThuczyOGkZnrEuKVnPnDZ4JbpsucdtoPHqJE7VnO7DV5euCjjJlhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnWF6NZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnWF6NZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61487C4CEC6;
	Tue, 15 Oct 2024 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729009144;
	bh=AmtixfYNWoZKuzk15uzQk7KeAxEXbsF9GlNywoFtxz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WnWF6NZx20+51Zueqy7M2gXSqvZgCuomHvjl5IqGcS1Zk8ac+QdDRaCe/rN/Klzyu
	 VDILymLr6GE+XaaHS1j/1WikUO9wpaarOCOCID7t2y+ADp4zuE+f97JBpLil2Ilw+l
	 rcFpObarfRwUhoUiolA1Q64cSN48PARm9278HQDVN8s/hbUUlkIh5PFR1GV5STyfpP
	 aFLp35MM9aANbGb7UMXEDasPVKyUfBgLvQSJgeV4r8VnH+C8Q/ZBSfMZllcy4bULpb
	 6z0fVlsxFKiVOmyXWMIWFlm5wX1SqOzIsYA5PB+gCwvUQ/Sn5g/mCZmERTkZL/Znib
	 drnofX19D5PWw==
Date: Tue, 15 Oct 2024 09:19:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <20241015161903.GW21853@frogsfrogsfrogs>
References: <20241014060516.245606-1-hch@lst.de>
 <20241014060516.245606-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014060516.245606-4-hch@lst.de>

On Mon, Oct 14, 2024 at 08:04:52AM +0200, Christoph Hellwig wrote:
> Primary superblock buffers that change the file system geometry after a
> growfs operation can affect the operation of later CIL checkpoints that
> make use of the newly added space and allocation groups.
> 
> Apply the changes to the in-memory structures as part of recovery pass 2,
> to ensure recovery works fine for such cases.
> 
> In the future we should apply the logic to other updates such as features
> bits as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me, thanks for making the name changes I requested. :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item_recover.c | 52 +++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c      |  8 ------
>  2 files changed, 52 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 09e893cf563cb9..edf1162a8c9dd0 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -22,6 +22,9 @@
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  #include "xfs_quota.h"
> +#include "xfs_alloc.h"
> +#include "xfs_ag.h"
> +#include "xfs_sb.h"
>  
>  /*
>   * This is the number of entries in the l_buf_cancel_table used during
> @@ -684,6 +687,49 @@ xlog_recover_do_inode_buffer(
>  	return 0;
>  }
>  
> +/*
> + * Update the in-memory superblock and perag structures from the primary SB
> + * buffer.
> + *
> + * This is required because transactions running after growfs may require the
> + * updated values to be set in a previous fully commit transaction.
> + */
> +static int
> +xlog_recover_do_primary_sb_buffer(
> +	struct xfs_mount		*mp,
> +	struct xlog_recover_item	*item,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f,
> +	xfs_lsn_t			current_lsn)
> +{
> +	struct xfs_dsb			*dsb = bp->b_addr;
> +	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
> +	int				error;
> +
> +	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +
> +	/*
> +	 * Update the in-core super block from the freshly recovered on-disk one.
> +	 */
> +	xfs_sb_from_disk(&mp->m_sb, dsb);
> +
> +	/*
> +	 * Initialize the new perags, and also update various block and inode
> +	 * allocator setting based off the number of AGs or total blocks.
> +	 * Because of the latter this also needs to happen if the agcount did
> +	 * not change.
> +	 */
> +	error = xfs_initialize_perag(mp, orig_agcount,
> +			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
> +			&mp->m_maxagi);
> +	if (error) {
> +		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
> +		return error;
> +	}
> +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +	return 0;
> +}
> +
>  /*
>   * V5 filesystems know the age of the buffer on disk being recovered. We can
>   * have newer objects on disk than we are replaying, and so for these cases we
> @@ -967,6 +1013,12 @@ xlog_recover_buf_commit_pass2(
>  		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
>  		if (!dirty)
>  			goto out_release;
> +	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
> +			xfs_buf_daddr(bp) == 0) {
> +		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
> +				current_lsn);
> +		if (error)
> +			goto out_release;
>  	} else {
>  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 60d46338f51792..08b8938e4efb7d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3346,7 +3346,6 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3394,13 +3393,6 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
> -			sbp->sb_dblocks, &mp->m_maxagi);
> -	if (error) {
> -		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
> -		return error;
> -	}
> -	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  
>  	/* Normal transactions can now occur */
>  	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
> -- 
> 2.45.2
> 
> 
