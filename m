Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A46221E4E;
	Wed,  2 Oct 2024 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727904482; cv=none; b=EbtB4on6TeAkwspMqxFsjwxkPiV3SHO/pZffHa24w9/kF/qAwkBc5Go47/C032R2TIJLxHd1NAh2MCNUT3rhhX8ci2KIMe2/pRRU5nL1CsrgF9x01pVSpBxTwWZZ2mDWwi5FoCrUVxyrkeC8r3grr9hPP+Je1zPtppt5WZc1kM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727904482; c=relaxed/simple;
	bh=zs6gKrHbBNwdhRQTvo6Z5b0hCuUiP9uhriiml0z0JTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmChn5Mq+2ClXbhQIrLfk5EehNpUStDYg1gjczQmLh+X2eLVitVzzNdXIkPh8pRVpH6ubHuPaz1shu7iRtUHhUeD/jlhc/AUEdr4ZIiNfYhTogP47E7WqIi0wOH/+MFfY0G/hCusoDP76J8je0MXSGhnOWyV75DS29lKPq5YQu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GY12d9iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GY12d9iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E2BC4CEDF;
	Wed,  2 Oct 2024 21:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727904481;
	bh=zs6gKrHbBNwdhRQTvo6Z5b0hCuUiP9uhriiml0z0JTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GY12d9iQlu2/+qtxOwlVMDSQINY8dQIDh7CpTZoJf4iVqNgj1v0+nCuJx9dO9cGp1
	 0MEgTWYfL+cF/OzjecimxdvMdKD1PYdDWgvv37oLdSrPMrZllfTROibkTgV6y31x4o
	 UIcHXGCISD0qpol/Z/F+meXwyo5bflPT9jD5adspiG/IBnqrJzq4vokmsUMNcGBmna
	 iXbIaSBsKTdo4z6r39Nmgo2X9k62P29thAnENXRDdGkS5ilCnRhsHpsIX3cCV04luY
	 xAfHmEDirgICnWCwAKQoj+NZS97cQLRnY0FU7/rbRNymaKGMlR4gRCyx4nr3Q885NF
	 8paFQT1Ss+Z1g==
Date: Wed, 2 Oct 2024 14:28:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrew Kreimer <algonell@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a typo
Message-ID: <20241002212800.GF21853@frogsfrogsfrogs>
References: <20241002211948.10919-1-algonell@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002211948.10919-1-algonell@gmail.com>

On Thu, Oct 03, 2024 at 12:19:48AM +0300, Andrew Kreimer wrote:
> Fix a typo in comments.
> 
> Signed-off-by: Andrew Kreimer <algonell@gmail.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec766b4bc853..a13bf53fea49 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1849,7 +1849,7 @@ xlog_find_item_ops(
>   *	   from the transaction. However, we can't do that until after we've
>   *	   replayed all the other items because they may be dependent on the
>   *	   cancelled buffer and replaying the cancelled buffer can remove it
> - *	   form the cancelled buffer table. Hence they have tobe done last.
> + *	   form the cancelled buffer table. Hence they have to be done last.
>   *
>   *	3. Inode allocation buffers must be replayed before inode items that
>   *	   read the buffer and replay changes into it. For filesystems using the
> -- 
> 2.39.5
> 
> 
