Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFE172048
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCfJ2J44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F09FC433C7;
	Mon, 18 Dec 2023 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702921811;
	bh=ur4GTCPi9ltcU01LwW2KcbVJFY+DBsYG6qqjl2B33io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WCfJ2J44ulPnEx0a+rYQR/ffQAtAEiUMSrgm48EXEGSeogWhfbOx5/ZNWh3EhlpN9
	 LUuR6a6ZfHGaQoN5IhHA9T159tiywnaAEazg8JjVq644GSdxoDhzOYh8p50SbXkZLz
	 A61x51hWA7kLjKUsVZ/TiXHUPAqp2Cjc61CNgb3aUzBZoDrv4JDOy2szmm0T87XZ4F
	 8osutLkF9keYir/Rw9sAw5UHYEVVne05/O3o4Cz5Hm/DA5FuEXCQzZnQBiCToTPzMo
	 etn9sZpLdW6IFYniRqm2w+K912iOVI20PXjHOaq8p4dc2ytG8hkWElJu8ifk+ap1yx
	 RjdOfJCBhERgw==
Date: Mon, 18 Dec 2023 09:50:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/22] xfs: invert a check in xfs_rtallocate_extent_block
Message-ID: <20231218175010.GR361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218045738.711465-13-hch@lst.de>

On Mon, Dec 18, 2023 at 05:57:28AM +0100, Christoph Hellwig wrote:
> Doing a break in the else side of a conditional is rather silly.  Invert
> the check, break ASAP and unindent the other leg.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index fbc60658ef24bf..924665b66210ed 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -283,12 +283,11 @@ xfs_rtallocate_extent_block(
>  		/*
>  		 * If not done yet, find the start of the next free space.
>  		 */
> -		if (next < end) {
> -			error = xfs_rtfind_forw(args, next, end, &i);
> -			if (error)
> -				return error;
> -		} else
> +		if (next >= end)
>  			break;
> +		error = xfs_rtfind_forw(args, next, end, &i);
> +		if (error)
> +			return error;
>  	}
>  	/*
>  	 * Searched the whole thing & didn't find a maxlen free extent.
> -- 
> 2.39.2
> 
> 
