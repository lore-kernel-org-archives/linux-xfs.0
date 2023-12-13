Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEB956B7A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAcrc2Cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD22C433C7;
	Wed, 13 Dec 2023 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491043;
	bh=8nhwjRh0+/rgSwqEfd6zBv7d45HjRUsij3xqSvNYFXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dAcrc2CponRu5S3+8eyr1fS/GKzJ3UhpBC89X8Lr6qxyDDl/7apUbVhnSoFGApAOx
	 R2jts4l7oPVr99CmpjHkXe17bRIK7H43R/Yoo0KmhhHDE/RU6Wbjuy8/+C6dmOfVWS
	 liYrOX/wXgO/oOx7f3CSuUWmywFZxSRhhDbDG1tOdI4xE0ymylK83HYzDlgRNnhGf0
	 qm+WLNMIkuW7Zx6Nb/JExJNFR33ZTWkSqqLN9ODc0cpnMZxVLOD7RXk+WIVvb3W8lj
	 xWP/GA48OWwITc1t8lsujSj9MX+i+z2lIqb+celQHK9+p8kYm1y3Q5nw2oau0oJon4
	 zbneGjl9qdIcQ==
Date: Wed, 13 Dec 2023 10:10:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] xfs: move xfs_attr_defer_type up in xfs_attr_item.c
Message-ID: <20231213181042.GE361584@frogsfrogsfrogs>
References: <20231213090633.231707-1-hch@lst.de>
 <20231213090633.231707-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213090633.231707-3-hch@lst.de>

On Wed, Dec 13, 2023 at 10:06:30AM +0100, Christoph Hellwig wrote:
> We'll reference it directly in xlog_recover_attri_commit_pass2, so move
> it up a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c | 66 +++++++++++++++++++++---------------------
>  1 file changed, 33 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 39f2c5a46179f7..4e0eaa2640e0d2 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -654,6 +654,39 @@ xfs_attr_relog_intent(
>  	return &new_attrip->attri_item;
>  }
>  
> +/* Get an ATTRD so we can process all the attrs. */
> +static struct xfs_log_item *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*intent,
> +	unsigned int			count)
> +{
> +	struct xfs_attri_log_item	*attrip;
> +	struct xfs_attrd_log_item	*attrdp;
> +
> +	attrip = ATTRI_ITEM(intent);
> +
> +	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
> +
> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
> +			  &xfs_attrd_item_ops);
> +	attrdp->attrd_attrip = attrip;
> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
> +
> +	return &attrdp->attrd_item;
> +}
> +
> +const struct xfs_defer_op_type xfs_attr_defer_type = {
> +	.max_items	= 1,
> +	.create_intent	= xfs_attr_create_intent,
> +	.abort_intent	= xfs_attr_abort_intent,
> +	.create_done	= xfs_attr_create_done,
> +	.finish_item	= xfs_attr_finish_item,
> +	.cancel_item	= xfs_attr_cancel_item,
> +	.recover_work	= xfs_attr_recover_work,
> +	.relog_intent	= xfs_attr_relog_intent,
> +};
> +
>  STATIC int
>  xlog_recover_attri_commit_pass2(
>  	struct xlog                     *log,
> @@ -730,39 +763,6 @@ xlog_recover_attri_commit_pass2(
>  	return 0;
>  }
>  
> -/* Get an ATTRD so we can process all the attrs. */
> -static struct xfs_log_item *
> -xfs_attr_create_done(
> -	struct xfs_trans		*tp,
> -	struct xfs_log_item		*intent,
> -	unsigned int			count)
> -{
> -	struct xfs_attri_log_item	*attrip;
> -	struct xfs_attrd_log_item	*attrdp;
> -
> -	attrip = ATTRI_ITEM(intent);
> -
> -	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
> -
> -	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
> -			  &xfs_attrd_item_ops);
> -	attrdp->attrd_attrip = attrip;
> -	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
> -
> -	return &attrdp->attrd_item;
> -}
> -
> -const struct xfs_defer_op_type xfs_attr_defer_type = {
> -	.max_items	= 1,
> -	.create_intent	= xfs_attr_create_intent,
> -	.abort_intent	= xfs_attr_abort_intent,
> -	.create_done	= xfs_attr_create_done,
> -	.finish_item	= xfs_attr_finish_item,
> -	.cancel_item	= xfs_attr_cancel_item,
> -	.recover_work	= xfs_attr_recover_work,
> -	.relog_intent	= xfs_attr_relog_intent,
> -};
> -
>  /*
>   * This routine is called when an ATTRD format structure is found in a committed
>   * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
> -- 
> 2.39.2
> 
> 
