Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07431DD0C7
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742299451; cv=none; b=D3WGGuD2bQ2s+yBWb62DFgqTeWNsV3SnRZ6V2AedZIKPMQyBuqGT82ofa31m8JVBByjQAYCJpIuLUV5v5cCKm/XA+AVih4NWkhLJJOEx7JWGldqQwKHEfa3b/UQxKzP1ho8p1G/kapkRbtRhylbs4zbiZ+eq1cteaoyUorbxB7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742299451; c=relaxed/simple;
	bh=LghChFkseVXoysNk9y2xyzP9DPKr50E6oF4PabTTz2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbHV3wG1IjGu3uxo0VtNBBLCpTCpW9+fsd8X6fcNMFomAwODl+ULk6UGDPNa0b2vCN5whViZC8IuzrEKJMn0s1m9jHkerLFvgilKRmZRhii7lCyaIUO5VbkcCZi4VDff0oaX7s6NRU9511WLrR5Px9hARVb4C4lqi7d+7t3MQKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlAKzpMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlAKzpMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C7C4CEF3;
	Tue, 18 Mar 2025 12:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742299449;
	bh=LghChFkseVXoysNk9y2xyzP9DPKr50E6oF4PabTTz2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mlAKzpMAlOMRNoSkw+2GDZfGr6bih8kOmP0mtKpZOX/iP1csGRyetOJJJevHzyZ5l
	 hryiSoV7lmWL36c+g6OH1RTMYC4+nh5fLir+Uc2mwHuLsFpR7wFa4xt2ZxwfwJBjkG
	 1TMn3T/WSRb5m1S5Iq7oBzq05C3D8o+EbpByvnM4WDVYVOYPiioQzPpy6c3Oa+olbU
	 C3rkkq5I/Gh4CAdzwSiVyiNm/P0Me1oI9Zd1+TYcQGc/56TF2mA1kkgDd4fYl3jFW7
	 WqCUOcsHs6r284+3aC+yNQRS0A7sFXD+66klQf35dwVB7GFmTyoSqwoZoREKJDQnC1
	 hdNEzGTnom7wA==
Date: Tue, 18 Mar 2025 13:04:05 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't wake zone space waiters without
 m_zone_info
Message-ID: <tlfagkid4yswrtf2nij6vonr3brsksojr3hxleeflhlni5dc5j@rfqdcvh2q7gj>
References: <20250317054512.1131950-1-hch@lst.de>
 <VtJ_ty0nXwF5weajL2NS81rKnI9UCfXxRkfbPnus7eFXuwmEqSdM25cksGPD0Qx5QZxJaXupZ2yHGxEvuFNIMw==@protonmail.internalid>
 <20250317054512.1131950-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054512.1131950-4-hch@lst.de>

On Mon, Mar 17, 2025 at 06:44:54AM +0100, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> xfs_zoned_wake_all checks SB_ACTIVE to make sure it does the right thing
> when a shutdown happens during unmount, but it fails to account for the
> log recovery special case that sets SB_ACTIVE temporarily.  Add a NULL
> check to cover both cases.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> [hch: added a commit log and comment]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_alloc.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index fd4c60a050e6..52af234936a2 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -853,13 +853,22 @@ xfs_zone_alloc_and_submit(
>  	bio_io_error(&ioend->io_bio);
>  }
> 
> +/*
> + * Wake up all threads waiting for a zoned space allocation when the file system
> + * is shut down.
> + */
>  void
>  xfs_zoned_wake_all(
>  	struct xfs_mount	*mp)
>  {
> -	if (!(mp->m_super->s_flags & SB_ACTIVE))
> -		return; /* can happen during log recovery */
> -	wake_up_all(&mp->m_zone_info->zi_zone_wait);
> +	/*
> +	 * Don't wake up if there is no m_zone_info.  This is complicated by the
> +	 * fact that unmount can't atomically clear m_zone_info and thus we need
> +	 * to check SB_ACTIVE for that, but mount temporarily enables SB_ACTIVE
> +	 * during log recovery so we can't entirely rely on that either.
> +	 */
> +	if ((mp->m_super->s_flags & SB_ACTIVE) && mp->m_zone_info)
> +		wake_up_all(&mp->m_zone_info->zi_zone_wait);
>  }
> 
>  /*
> --
> 2.45.2
> 
