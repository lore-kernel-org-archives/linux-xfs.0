Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42165D746
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMPG4haz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25971C433C8;
	Mon, 18 Dec 2023 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702921927;
	bh=C0zlTKVXOZnatjc/q70WkgoIsD5VBBnHXD3stuMX3YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NMPG4hazzlyTXEfN1Pqu7icVE1ZOjGXsGMB1RYdJveM7dz5+neTvtpY4zM6GtNBES
	 BoDx5whEKLdfwshy5/xDGu9jqni+3Fl9F5JZgc5zNOD8xIysSM/5Kq/tS9dULSK0ZY
	 2DmPhd8fdOXn4HQx9iGrJllNiH/f3zdCFGZKovvAtcAu6bZ8C88dP2yax+kuKxDxTk
	 F+R5nrd5nvjOOMnhhcqL5sQpAzJG1zYBbbeZR6RKpD5Q4KtbZucYaOHWyBbUJVRav3
	 HsJS37d/K6T37J7bJlrWOxevh19TQzpKjO1CIx0UvjSNBLKXNPfM0GE6Md7MC8o10d
	 O9IfUtd0b8PcQ==
Date: Mon, 18 Dec 2023 09:52:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/22] xfs: merge the calls to xfs_rtallocate_range in
 xfs_rtallocate_block
Message-ID: <20231218175206.GT361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218045738.711465-15-hch@lst.de>

On Mon, Dec 18, 2023 at 05:57:30AM +0100, Christoph Hellwig wrote:
> Use a goto to use a common tail for the case of being able to allocate
> an extent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6fcc847b116273..9604acd7aa6cec 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -252,19 +252,15 @@ xfs_rtallocate_extent_block(
>  		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
>  		if (error)
>  			return error;
> -
>  		if (stat) {
>  			/*
>  			 * i for maxlen is all free, allocate and return that.
>  			 */
> -			error = xfs_rtallocate_range(args, i, maxlen);
> -			if (error)
> -				return error;
> -
> -			*len = maxlen;
> -			*rtx = i;
> -			return 0;
> +			bestlen = maxlen;
> +			besti = i;
> +			goto allocate;
>  		}
> +
>  		/*
>  		 * In the case where we have a variable-sized allocation
>  		 * request, figure out how big this free piece is,
> @@ -315,6 +311,7 @@ xfs_rtallocate_extent_block(
>  	/*
>  	 * Allocate besti for bestlen & return that.
>  	 */
> +allocate:
>  	error = xfs_rtallocate_range(args, besti, bestlen);
>  	if (error)
>  		return error;
> -- 
> 2.39.2
> 
> 
