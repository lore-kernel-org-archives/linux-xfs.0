Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A94A3C9452
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873484; cv=none; b=IXB4ivA1h+CPYEuzt/Brh7erqWT/FhAh6LP6chLoL2LG/DdQyikALgyw260Z1M2DJxL7oAAitOd56w0FMgkK1dQN9BrPQg3uOBEE3J9kV3dRxUUbAqV83v8Dkbf3JZqpazouFt71bwQX+iHfTGaH9Ftnvg52YQDqmJ138MfK+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873484; c=relaxed/simple;
	bh=EOCq6L8HXfLagcjOsfRZqvWvqeqPYbO9nUJ4tKp1X7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvkH3MqOulzdxt42GguiyrCyMZAIwQknFwvnxnVarmZ6vlQQjseqVdYbCZbee6w0WAdPR+MO6HC2yxMcwjB7+lnsgU7K3F4yLXPuUGn+xoGEr+DDoJGO8Oc9eO8VV6+ft1/r9dENetnnAxX/SxhGj85LQMMwT3IivxXy2Y1SzxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4mHr/Q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4mHr/Q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8C2C4CEF7;
	Mon, 30 Mar 2026 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873483;
	bh=EOCq6L8HXfLagcjOsfRZqvWvqeqPYbO9nUJ4tKp1X7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4mHr/Q2tPW4kgmRABo7D4HF9Oy1xxlo3HNWma89AE+GI/iAi/5IbryZdqDtpK8S0
	 fV0Qh+QodCeHOGvxRA5sD3+FotIFSXNNjG8LKdrGZkBuocpvrQim3gL4AIkloU0yFr
	 L4AkDcDm2g4RltHHpVgjbrLAKNjdHpr8jmMsMCNOrE3MtKbg0KQCgGGWhnc6u2cbHJ
	 hoCN2b78JCKU6iYATIQaKmpCD3WBYOq0ndKiJtpD5zkILZ422ZmfOb+ZEyahaKJ+X+
	 2i2M0j9NdpKu9cwB+jSGMH+p9cjTkfbpdUoVtO7zuxfHAOt5OENaV56sD5SKF1+3IF
	 Jc0YPtyjiffEA==
Date: Mon, 30 Mar 2026 14:24:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: put the open zone later xfs_open_zone_put
Message-ID: <acpq2FHpgAnoxpD_@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-4-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:13AM +0200, Christoph Hellwig wrote:
> The open zone is what holds the rtg reference for us.  This doesn't
> matter until we support shrinking, and even then is rather theoretical
> because we can't shrink away a just filled zone in a tiny race window,
> but let's play safe here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index b0a6bc777c36..297a918bf28e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -182,11 +182,11 @@ xfs_open_zone_mark_full(
>  		list_del_init(&oz->oz_entry);
>  	}
>  	spin_unlock(&zi->zi_open_zones_lock);
> -	xfs_open_zone_put(oz);
>  
>  	wake_up_all(&zi->zi_zone_wait);
>  	if (used < rtg_blocks(rtg))
>  		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
> +	xfs_open_zone_put(oz);
>  }
>  
>  static inline void
> -- 
> 2.47.3
> 
> 
