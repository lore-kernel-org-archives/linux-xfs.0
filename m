Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943D61C07ED
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 13:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997830; cv=none; b=P/8WgHqP/yQmkZoGN4zwMszxax1l4Zru9/kGo+XoljI/+fDprLq/ofYfj2FdorCyw2SBI03xpbHWwnDh5glVLUCNV5Up0i3RoQjBRlWl0XOVQkocUEjqcoH0St9auql+jU6Z43DTYf7E6N8UkFsMntsSAtPKvYIdtTgbIgYLuG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997830; c=relaxed/simple;
	bh=aXWkzN5e4cQGJUighR1SCOam1f39uc1h8PUsBIwk/Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkazmpAeOGyOKIY8MJSBBRQChKsNRgrJdoLIAyFztEqMMtDbsr2shcxrtrKc9fh5hvfpr2UScq0Usydm8k6ArobM9jU19RPZyfCRzPdPeCknPP6MIWbVNIuzeADe9G+z8gNLKZeaOAbAPMB8s00VdZpbRVUNZ5+u0OIQElpjfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ml6wSkxZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ml6wSkxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728997827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/z9v4LLs7Hzq/SU2L/soPcOQHlLyWzYWzLrSR7XSfQ0=;
	b=Ml6wSkxZtRealmCfQRItknWBO5va8MVhUzPsGYNou5zRTRHQZaLIDz8PQtK7AbWpniKg3U
	tb1s4rxwBfj1JLwKYeCKDZRF2ZfI7TxTPQM1ns9JjCmv027cigIRcAzA3uQbzRfHAwCiZP
	gEEnaBnXgznWq6Hp93X+epQUHGksL9g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-6Mdy7cBMMOq3uqpUd64BnQ-1; Tue,
 15 Oct 2024 09:10:22 -0400
X-MC-Unique: 6Mdy7cBMMOq3uqpUd64BnQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEAB419560AA;
	Tue, 15 Oct 2024 13:10:20 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.74])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F17EF1956089;
	Tue, 15 Oct 2024 13:10:19 +0000 (UTC)
Date: Tue, 15 Oct 2024 09:11:41 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: update the pag for the last AG at recovery time
Message-ID: <Zw5qDZXQd2UzoGQu@bfoster>
References: <20241014060516.245606-1-hch@lst.de>
 <20241014060516.245606-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014060516.245606-7-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Oct 14, 2024 at 08:04:55AM +0200, Christoph Hellwig wrote:
> Currently log recovery never updates the in-core perag values for the
> last allocation group when they were grown by growfs.  This leads to
> btree record validation failures for the alloc, ialloc or finotbt
> trees if a transaction references this new space.
> 
> Found by Brian's new growfs recovery stress test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Thanks for tracking this down. The test now passes here as well. I'll
try to get it polished up and posted soon.

>  fs/xfs/libxfs/xfs_ag.c        | 17 +++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h        |  1 +
>  fs/xfs/xfs_buf_item_recover.c | 19 ++++++++++++++++---
>  3 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 25cec9dc10c941..5ca8d01068273d 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -273,6 +273,23 @@ xfs_agino_range(
>  	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
>  }
>  

Comment please. I.e.,

/*
 * Update the perag of the previous tail AG if it has been changed
 * during recovery (i.e. recovery of a growfs).
 */

> +int
> +xfs_update_last_ag_size(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		prev_agcount)
> +{
> +	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
> +
> +	if (!pag)
> +		return -EFSCORRUPTED;
> +	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
> +			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
> +	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
> +			&pag->agino_max);
> +	xfs_perag_rele(pag);
> +	return 0;
> +}
> +
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 6e68d6a3161a0f..9edfe0e9643964 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -150,6 +150,7 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
>  void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
>  		xfs_agnumber_t end_agno);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
> +int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
>  
>  /* Passive AG references */
>  struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index a839ff5dcaa908..5180cbf5a90b4b 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -708,6 +708,11 @@ xlog_recover_do_primary_sb_buffer(
>  
>  	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  
> +	if (orig_agcount == 0) {
> +		xfs_alert(mp, "Trying to grow file system without AGs");
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * Update the in-core super block from the freshly recovered on-disk one.
>  	 */
> @@ -718,15 +723,23 @@ xlog_recover_do_primary_sb_buffer(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/*
> +	 * Growfs can also grow the last existing AG.  In this case we also need

It can shrink the last AG as well, FWIW.

> +	 * to update the length in the in-core perag structure and values
> +	 * depending on it.
> +	 */
> +	error = xfs_update_last_ag_size(mp, orig_agcount);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Initialize the new perags, and also update various block and inode
>  	 * allocator setting based off the number of AGs or total blocks.
>  	 * Because of the latter this also needs to happen if the agcount did
>  	 * not change.
>  	 */
> -	error = xfs_initialize_perag(mp, orig_agcount,
> -			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);

Seems like this should be folded into an earlier patch?

With the nits addressed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (error) {
>  		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
>  		return error;
> -- 
> 2.45.2
> 
> 

