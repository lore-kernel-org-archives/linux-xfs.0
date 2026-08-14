Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AB730146C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715873; cv=none; b=pt/C8+5auF79ZUpTDDAtDwS6SGOPE2KsYcb2slXOHy6TxYxu+5tEY5pioYZItCpc/MmRwFlRkPKBDlDlyKDKbiSWPat2yI5MkwTHeKJLW+2SscaTSiQmvzsRB8AvKMTRRBzJe5RWopCzjbLest4jmgh/FwHSpTQog7eC+ikr50Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715873; c=relaxed/simple;
	bh=aZaQk7Y4Grxnn5kzyvUWOI2SXyAFyiWJ5dZnXBOYYaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7ZjSkQHX9Y4H3APWCeOa2o2iWdEjnmpfWwQ7hcchmHUDhDUs1mrBBI21hd1LdU8G8SZ+ctZtm8X5zAHbwDuI4LUbygVsaWst2SfUg8uprUdjyn6YAgNAkxYUHn31VvBz00nyhmHESVLzxlP4vgilvDXSJ7hH99KgG/z4izPvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q2orfS+S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2orfS+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786715870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6QcTGzqfi9qU2qQSbHEK1yNjbFPgDMFkB/6JODJH9w=;
	b=Q2orfS+S51LEyPXFH9LtJndsyNgEENJvGM8KbHqTbVn5lDIGYnnoFjepkuy5gvj80JGAeN
	IfHWn5xZnYIbP22jffIkR2aXh3vKq9h+AiDQDh5zI20hfr7BE0HuJHON8HRz/z3F/nG2Nh
	sGS4Vomt3qdwnXGGSn6I211fwX7fXbY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-virNyTEFPVSRpxLNMJCyoQ-1; Fri,
 14 Aug 2026 09:57:45 -0400
X-MC-Unique: virNyTEFPVSRpxLNMJCyoQ-1
X-Mimecast-MFC-AGG-ID: virNyTEFPVSRpxLNMJCyoQ_1786715864
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DFAC195606C;
	Fri, 14 Aug 2026 13:57:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.105])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83DFB1800347;
	Fri, 14 Aug 2026 13:57:43 +0000 (UTC)
Date: Fri, 14 Aug 2026 09:57:41 -0400
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 3/3] xfs: incorporate increased AGFL min requirement
 for minleft allocs
Message-ID: <an8e1YgRDysYtlgM@bfoster>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814132239.271492-4-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
> Matt Fleming reports a filesystem shutdown due to inobt block
> allocation failure during sparse chunk allocation. Inode creation
> can involve multiple allocations in a transaction: the initial chunk
> allocation and inode btree blocks via inobt record insertion. This
> is expected to be safe by using the minleft parameter on the chunk
> allocation to guarantee the selected AG has blocks available for
> a followup inobt insertion.
> 
> The sequence that leads to this failure is that the alloc and inode
> btrees are all full (require a full split on next insertion) and the
> AG has just enough free space to satisfy a sparse chunk allocation
> with minleft set (i.e. 7 blocks in this example). The chunk
> allocation splits a free extent, triggers full allocbt splits, and
> consumes 4 free blocks for the chunk and 4 AGFL blocks for the
> btrees.
> 
> Next, the inobt record insertion triggers an inobt split. The AG has
> enough free blocks, but the allocbt splits caused by the chunk
> allocation have increased the min AGFL requirement for the AG due to
> btree level increases. The AGFL requirement as calculated by
> xfs_alloc_fix_freelist() is:
> 
> 	free + AGFL - res - minfree - minleft = avail
> 
> This evaluates to the following on initial chunk allocation:
> 
> 	2514 + 8 - 2505 - 8 - 2 = 7
> 
> ... and then after the chunk allocation but before the inobt block
> allocation:
> 
> 	2510 + 4 - 2505 - 12 - 0 = -3
> 
> This causes the inobt alloc to fail despite minleft being set in the
> first allocation. The error path cancels the dirty transaction and
> shuts down the fs.
> 
> The problem here is that while minleft ensures free blocks are
> available for the inobt insert, it is not sufficient to cover the
> increase of the AGFL min free requirement. To address this, create a
> variant of the AGFL min free calculation for minleft allocations
> that incorporates an additional allocbt level increase.
> 
> We do not add the additional blocks directly to min_free because
> this would lead to spurious AGFL block allocations and frees in the
> common case (i.e. no btree splits). Instead, add the surplus block
> requirement to the minleft value used to select the AG. This ensures
> the AG has enough blocks for the caller's minleft value plus the
> worst case increase in the AGFL. In the example above, the initial
> calculation now evaluates to 3 blocks available instead of 7 and the
> sparse inode allocation fails gracefully with -ENOSPC.
> 
> Reported-by: Matt Fleming <matt@readmodwrite.com>
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 29 ++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc.h |  2 ++
>  fs/xfs/libxfs/xfs_bmap.c  |  2 +-
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index dbb85fb6314b..74c5b587c87b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2500,6 +2500,20 @@ xfs_alloc_min_freelist(
>  	return __xfs_alloc_min_freelist(mp, pag, 0);
>  }
>  
> +/*
> + * Return the minimum freelist requirement considering a potential allocbt split
> + * from the current allocation. Use this when computing longest free extent for
> + * allocations with minleft set to ensure that the available extent length
> + * accounts for the subsequent allocation's increased AGFL requirement.
> + */
> +unsigned int
> +xfs_alloc_min_freelist_minleft(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
> +{
> +	return __xfs_alloc_min_freelist(mp, pag, 1);
> +}
> +
>  /*
>   * Check if the operation we are fixing up the freelist for should go ahead or
>   * not. If we are freeing blocks, we always allow it, otherwise the allocation
> @@ -2517,6 +2531,7 @@ xfs_alloc_space_available(
>  	xfs_extlen_t		reservation; /* blocks that are still reserved */
>  	int			available;
>  	xfs_extlen_t		agflcount;
> +	xfs_extlen_t		minleft;
>  
>  	if (flags & XFS_ALLOC_FLAG_FREEING)
>  		return true;
> @@ -2533,10 +2548,22 @@ xfs_alloc_space_available(
>  	 * Do we have enough free space remaining for the allocation? Don't
>  	 * account extra agfl blocks because we are about to defer free them,
>  	 * making them unavailable until the current transaction commits.
> +	 *
> +	 * If minleft is set, this allocation might cause an allocbt split that
> +	 * increases the AGFL minimum for the next allocation in the
> +	 * transaction. Reserve that space from the available block count
> +	 * (without prematurely growing the AGFL) to prevent the subsequent
> +	 * allocation from failing due to an increased min_free requirement.
>  	 */
> +	minleft = args->minleft;
> +	if (minleft) {
> +		minleft += xfs_alloc_min_freelist_minleft(args->mp, pag) -
> +					min_free;
> +	}
> +
>  	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
>  	available = (int)(pag->pagf_freeblks + agflcount -
> -			  reservation - min_free - args->minleft);
> +			  reservation - min_free - minleft);
>  	if (available < (int)max(args->total, alloc_len))
>  		return false;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 50ef79a1ed41..026b61a63994 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -73,6 +73,8 @@ xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
>  		xfs_extlen_t need, xfs_extlen_t reserved);
>  unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
>  		struct xfs_perag *pag);
> +unsigned int xfs_alloc_min_freelist_minleft(struct xfs_mount *mp,
> +		struct xfs_perag *pag);
>  int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
>  		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
>  int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d64defeda645..f396df864cf4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3160,7 +3160,7 @@ xfs_bmap_longest_free_extent(
>  	}
>  

I intended to add a comment here but lost track. I.e., something like:

        /*
         * Use the minleft freelist helper because minleft can be set for bmbt
         * allocs. If we don't factor it in here, the alloc can be sized
         * incorrectly and fail.
         */

I'll wait for any further feedback before reposting.

Brian

>  	longest = xfs_alloc_longest_free_extent(pag,
> -				xfs_alloc_min_freelist(pag_mount(pag), pag),
> +				xfs_alloc_min_freelist_minleft(pag_mount(pag), pag),
>  				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
>  	if (*blen < longest)
>  		*blen = longest;
> -- 
> 2.55.0
> 
> 

