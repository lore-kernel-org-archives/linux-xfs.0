Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2AB1C9ED7
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568918; cv=none; b=sMvhtty4fQ2YGpUHNBLb6Xv8Z4Opn3WaHLldHqeE1xKPkma674ABx19HqB+uWDKZR0Ifj3mMgFCcnGQfIfVXfq3/iT0bLxxBr16GC3o2DU4Dub0f9IZSy7ZmZjSuhDd1qtfoOkbGOw0q9Sl2+TfmyLRf9gmdmJ0Shxz5r93PBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568918; c=relaxed/simple;
	bh=5TFC58OjvnApNuFQgJSLnbZCADzQNP3qn/Ep0qtO3RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNtjvQzd7zNZ1aVq5q1X4IuBP1fLhf/KmUXyb8xiZSfF4v+QgIZyRdJlev3jrOg98nbPlJ4FD5/KYD0ZqkkDevx6BOzMaVp4TSHHjhDBnCfvsBltzhdBrtKQdXC0iefV+3HPxwxcBiAwoH3HJwOzV4cua0L4xA9ei+Qj5g5Lksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c389Oypr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c389Oypr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728568915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WFi4zQK/0FElkw97lZoyPZDoLLiOdrt3XOqKmBBCxuk=;
	b=c389OyprL2RaDO6V+mBCizHdjMH6Ud4JwkxBJUbpgjlGCF+paJYyWP2/69Mmlnk6Swm6Nf
	xZ0EXheZ3aFMdsYaj2Kb0t77KkfrdJnO0OiIX1E3hpAhlRw+Jz9Zx6phiub8eyeJJvWj6k
	2Lo5BAygYkP5QVcf/wTCJnboR8MVIF8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-8VyOgdvlNeSHcdGeHseHmA-1; Thu,
 10 Oct 2024 10:01:50 -0400
X-MC-Unique: 8VyOgdvlNeSHcdGeHseHmA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BAAB1955F69;
	Thu, 10 Oct 2024 14:01:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 893ED19560A2;
	Thu, 10 Oct 2024 14:01:43 +0000 (UTC)
Date: Thu, 10 Oct 2024 10:02:59 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: merge the perag freeing helpers
Message-ID: <Zwfek7DWa-MNRTRu@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Sep 30, 2024 at 06:41:43PM +0200, Christoph Hellwig wrote:
> There is no good reason to have two different routines for freeing perag
> structures for the unmount and error cases.  Add two arguments to specify
> the range of AGs to free to xfs_free_perag, and use that to replace
> xfs_free_unused_perag_range.
> 
> The addition RCU grace period for the error case is harmless, and the
> extra check for the AG to actually exist is not required now that the
> callers pass the exact known allocated range.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c | 40 ++++++++++------------------------------
>  fs/xfs/libxfs/xfs_ag.h |  5 ++---
>  fs/xfs/xfs_fsops.c     |  2 +-
>  fs/xfs/xfs_mount.c     |  5 ++---
>  4 files changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 652376aa52e990..8fac0ce45b1559 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -185,17 +185,20 @@ xfs_initialize_perag_data(
>  }
>  
>  /*
> - * Free up the per-ag resources associated with the mount structure.
> + * Free up the per-ag resources  within the specified AG range.
>   */
>  void
> -xfs_free_perag(
> -	struct xfs_mount	*mp)
> +xfs_free_perag_range(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first_agno,
> +	xfs_agnumber_t		end_agno)
> +
>  {
> -	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xa_erase(&mp->m_perags, agno);
> +	for (agno = first_agno; agno < end_agno; agno++) {
> +		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
> +
>  		ASSERT(pag);
>  		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
>  		xfs_defer_drain_free(&pag->pag_intents_drain);
> @@ -270,29 +273,6 @@ xfs_agino_range(
>  	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
>  }
>  
> -/*
> - * Free perag within the specified AG range, it is only used to free unused
> - * perags under the error handling path.
> - */
> -void
> -xfs_free_unused_perag_range(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agstart,
> -	xfs_agnumber_t		agend)
> -{
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		index;
> -
> -	for (index = agstart; index < agend; index++) {
> -		pag = xa_erase(&mp->m_perags, index);
> -		if (!pag)
> -			break;
> -		xfs_buf_cache_destroy(&pag->pag_bcache);
> -		xfs_defer_drain_free(&pag->pag_intents_drain);
> -		kfree(pag);
> -	}
> -}
> -
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> @@ -369,7 +349,7 @@ xfs_initialize_perag(
>  out_free_pag:
>  	kfree(pag);
>  out_unwind_new_pags:
> -	xfs_free_unused_perag_range(mp, old_agcount, index);
> +	xfs_free_perag_range(mp, old_agcount, index);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 69fc31e7b84728..6e68d6a3161a0f 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -144,13 +144,12 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
>  __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
>  __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
>  
> -void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
> -			xfs_agnumber_t agend);
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
>  		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
>  		xfs_agnumber_t *maxagi);
> +void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
> +		xfs_agnumber_t end_agno);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
> -void xfs_free_perag(struct xfs_mount *mp);
>  
>  /* Passive AG references */
>  struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index de2bf0594cb474..b247d895c276d2 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -229,7 +229,7 @@ xfs_growfs_data_private(
>  	xfs_trans_cancel(tp);
>  out_free_unused_perag:
>  	if (nagcount > oagcount)
> -		xfs_free_unused_perag_range(mp, oagcount, nagcount);
> +		xfs_free_perag_range(mp, oagcount, nagcount);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6fa7239a4a01b6..25bbcc3f4ee08b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1048,7 +1048,7 @@ xfs_mountfs(
>  		xfs_buftarg_drain(mp->m_logdev_targp);
>  	xfs_buftarg_drain(mp->m_ddev_targp);
>   out_free_perag:
> -	xfs_free_perag(mp);
> +	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>   out_free_dir:
>  	xfs_da_unmount(mp);
>   out_remove_uuid:
> @@ -1129,8 +1129,7 @@ xfs_unmountfs(
>  	xfs_errortag_clearall(mp);
>  #endif
>  	shrinker_free(mp->m_inodegc_shrinker);
> -	xfs_free_perag(mp);
> -
> +	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>  	xfs_errortag_del(mp);
>  	xfs_error_sysfs_del(mp);
>  	xchk_stats_unregister(mp->m_scrub_stats);
> -- 
> 2.45.2
> 
> 

