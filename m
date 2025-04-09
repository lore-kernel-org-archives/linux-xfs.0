Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145F01E47B7
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744226953; cv=none; b=ILmcX3imWzTF/zU83N0McPMZVFUGe2bVkXoiQapPBf87Xt/Yy6KdIpvRkKM1V1Sejk4HgQOFCHNIyOClYglT0NGzxQdXFkIRkubO9BRevViocHaWF9otn7B3MbRARHa63rBLVOeiICneI5nD/dMPAicWg6ZOxu3j/a48MY07Kw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744226953; c=relaxed/simple;
	bh=UQep7dISPhaDL6kP5xsT5XvEsUwb6J03ers6ZswnZCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvH/Z145h/06Tep5ttm8BsmKhjuzRmDv1L9OlZTLXrGK8dsC8LoX/hGBIt5qDo58c1V+nseyw2DDQqERhBWAd0D0L/Bex8B6uR/NcXr+KNvBWlpur876Di/+a2p8nDCc7Hckz+RCuJsseM0ped7mLwB6R4KyG/YDBVkZGDRdFJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhJ58ohL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhJ58ohL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8313EC4CEE2;
	Wed,  9 Apr 2025 19:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744226952;
	bh=UQep7dISPhaDL6kP5xsT5XvEsUwb6J03ers6ZswnZCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhJ58ohLi4YIqkOylpgB4AqLbi9hTHAZ0eCZNAfC/3xW3zezrMgCuGCDXZDnEt00j
	 JTm8yrGSy2ZGnAdwARijlTYZG1u4+jG0oBwqgfJmvJN+86j5Pb3WVkTY7IkWZ4SLkw
	 WlZk+kETFJy+u0aANZ2ZqODKw6zZk3orGc+RPsWM8VnqCizMl2ZYi5Wb+LESRVZp+0
	 nLNqkCWU7r6dy/gy4a61ZzquVWR7nol+q4aHingusxHNywBw4nO8en9qnV1XnPTzPL
	 4yFUGYYLFqOEOd5U5Bl8jODAUybPkePVfQE0ZUrNnDOlW4vyV5jXH+xNE12+AwXGsH
	 mdprsPGnpqYTQ==
Date: Wed, 9 Apr 2025 12:29:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/45] xfs_spaceman: handle internal RT devices
Message-ID: <20250409192911.GM6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-42-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-42-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:44AM +0200, Christoph Hellwig wrote:
> Handle the synthetic fmr_device values for fsmap.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks correct to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  spaceman/freesp.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index dfbec52a7160..9ad321c4843f 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -140,12 +140,19 @@ scan_ag(
>  	if (agno != NULLAGNUMBER) {
>  		l->fmr_physical = cvt_agbno_to_b(xfd, agno, 0);
>  		h->fmr_physical = cvt_agbno_to_b(xfd, agno + 1, 0);
> -		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
> +		if (file->xfd.fsgeom.rtstart)
> +			l->fmr_device = XFS_DEV_DATA;
> +		else
> +			l->fmr_device = file->fs_path.fs_datadev;
>  	} else {
>  		l->fmr_physical = 0;
>  		h->fmr_physical = ULLONG_MAX;
> -		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
> +		if (file->xfd.fsgeom.rtstart)
> +			l->fmr_device = XFS_DEV_RT;
> +		else
> +			l->fmr_device = file->fs_path.fs_rtdev;
>  	}
> +		h->fmr_device = l->fmr_device;
>  	h->fmr_owner = ULLONG_MAX;
>  	h->fmr_flags = UINT_MAX;
>  	h->fmr_offset = ULLONG_MAX;
> -- 
> 2.47.2
> 
> 
