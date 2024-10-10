Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D931BDAA5
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568968; cv=none; b=g3T3ok4GtRp5qsocNd/5Wao+ioHwnkeKIO2LXyW8WrpBTpRivnlbU2+Iwb8WUVlxI25xWSZyNOeElfpMWBgSGEZ23fRHmn4iT/hH2FOrU5O6I5ZhT/Zb41u4jMlxlEgiv4PqNDKgwceqeDg2TJR0WhgnZ+WG+kxBDIH64Y83SRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568968; c=relaxed/simple;
	bh=vo08ZxSkaPFZBP2qUF+bG+z7dIUwv6cx8p0sqKrV9bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k11WeZvq1VMta6OVig6Vbxy/+tv8X3PSdOnNdwC1W+bN0TQvRJLQRUFdyZxPUe7IcMvzs+/ENAxo4SBOc2zNCOCxpl4EOYVcJyHgTkwu8qcIocLg/V66fE1miXtJ0UJV+WXbLDk7oG7RPTuQ+RW9V1Kvd8qsivJEMUP6+/BWeDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkbS4X9o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkbS4X9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728568963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=93mtVlWKIa1aqk1ymGZDfCHEDK0FlrQpU3CqR9yci/I=;
	b=NkbS4X9oDTdrkN/wj+pd4jiMx0HgM7+/J05Be7h4DV9ugZNs/s11jdg+OF1/JT5+SsGw9M
	t3mjpC335E8YB1SPzmNzZv47ewF6a25RhYdrTF+UzntZqvBC/TmtWYFAD3Ov0Cx+MkoJFI
	aCI77CHltsdhaEGpB4KPLzB93dgqIKQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-GyF0X0QgMOiuO2LmNGxzVg-1; Thu,
 10 Oct 2024 10:02:38 -0400
X-MC-Unique: GyF0X0QgMOiuO2LmNGxzVg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC2CF1955F3F;
	Thu, 10 Oct 2024 14:02:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEBC61956046;
	Thu, 10 Oct 2024 14:02:35 +0000 (UTC)
Date: Thu, 10 Oct 2024 10:03:51 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <ZwfexwSEUV8Jnrg0@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-4-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Sep 30, 2024 at 06:41:44PM +0200, Christoph Hellwig wrote:
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
>  fs/xfs/libxfs/xfs_log_recover.h |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c        | 27 +++++++++++++++++++--------
>  3 files changed, 48 insertions(+), 8 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6a165ca55da1a8..03701409c7dcd6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3334,6 +3334,25 @@ xlog_do_log_recovery(
>  	return error;
>  }
>  
> +int
> +xlog_recover_update_agcount(
> +	struct xfs_mount		*mp,
> +	struct xfs_dsb			*dsb)
> +{
> +	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
> +	int				error;
> +
> +	xfs_sb_from_disk(&mp->m_sb, dsb);
> +	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
> +	if (error) {
> +		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
> +		return error;
> +	}
> +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);

Re: my comments on patch 1, it looks like this also doesn't need to
change unless the superblock update actually changed the AG count.
Otherwise seems Ok in terms of the context change.

Brian

> +	return 0;
> +}
> +
>  /*
>   * Do the actual recovery
>   */
> @@ -3346,7 +3365,6 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3394,13 +3412,6 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
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

