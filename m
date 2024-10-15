Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77651C07DF
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 13:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997800; cv=none; b=LZCQDlg8PdP18GukUdlc5zjfjYfLoSKR5Av5aFoM0xljvqSeNs3j5NttHjp1oVtBL6DuMbdaMOWvJ/xRSPWSdVPDlnlhdWGGWKxBJdQW9+bqhkeYqSY9fi95Pwzid5OFj0FvdaJNhkymx37fy19t750DFIXQ96avF1wka9dc9pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997800; c=relaxed/simple;
	bh=egcVtsWyTJ7a1fwfLfsA9JAKyN8F1dqrieCPyMWL4ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLLf2p79QDvO/bjcQoixFxiMMH/cAqhG7covncSGO+ZB1aBMNxvlBrSZ4dF1uznnIIc1EuMAKVKNZFUcWZ6AZlbsZaJ8VvSWya9OuGyqxGV6x/wk6q/rOygp41N1PlaFyz1ZgZwRNov39EhoBg60ytSeJocTccGcj8lAoCeK/jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfTuynbr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfTuynbr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728997797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ygn5ra32LDPfMbZhVRtOPr8iSMe1GmlSdLwB80pyKAk=;
	b=PfTuynbrbYRmAXuKWO21e2YpsRUWPQ42bPy0NPRXyOw7SlHY+JkAAeCNZc0PxnZgg0tr6k
	rokT6su2hotSOjoltR/PqhW3LcDe3V9LLZhJrucitBajG8FebPavQN72MDqcf0wWTPVe5v
	s3R5VxgdoxpxI3hRaG9GG7zGZ02y3YM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-C7Vw8q6QOEOYQbfWKxX4-w-1; Tue,
 15 Oct 2024 09:09:55 -0400
X-MC-Unique: C7Vw8q6QOEOYQbfWKxX4-w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 979301955D4D;
	Tue, 15 Oct 2024 13:09:54 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.74])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A898A1955E93;
	Tue, 15 Oct 2024 13:09:53 +0000 (UTC)
Date: Tue, 15 Oct 2024 09:11:14 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <Zw5p8oWepsp6AKfu@bfoster>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

