Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D7B282E7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBuYagnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33AAC433C8;
	Thu, 14 Dec 2023 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702588644;
	bh=/y348Ktugk+nDmzCdJ/GYlRvu7ijRAunA61uHWrqBEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gBuYagnTArLQVZjA4OjNMzrQOFn+RJ5vuE/JBxgN/0qeZnBPz6C0pdfBFSMlQeej0
	 0+U/6gW5c1wwvjhpvvlPXxeq99lfHyVzxRei3AfncTpuTBlYa8yY5bntlK/7C+uTGh
	 gMD6+PzRDIhk08Hz23cu4nyRGNoETx0SVQArJ9wLnhjgTq/A3xxRvMYQD/blrjUVP/
	 pJNhb1EgtG/UodMQOZTfjGJFAmT31Lq3Onj+Hykxtgcc3PTSlrb52XNYAV45pzpMP5
	 XBz2g73SamSMlTAliwDkpFREMRb/uXehw+QP7zOpqh2qw8WT0w/5AO31VWMyOqNTIX
	 raMbTNpC3JTQg==
Date: Thu, 14 Dec 2023 13:17:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/19] xfs: tidy up xfs_rtallocate_extent_exact
Message-ID: <20231214211723.GD361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-14-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:32AM +0100, Christoph Hellwig wrote:
> Use common code for both xfs_rtallocate_range calls by moving
> the !isfree logic into the non-default branch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 5f42422a976a3e..ea6f221c6a193c 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -349,32 +349,24 @@ xfs_rtallocate_extent_exact(
>  	if (error)
>  		return error;
>  
> -	if (isfree) {
> +	if (!isfree) {
>  		/*
> -		 * If it is, allocate it and return success.
> +		 * If not, allocate what there is, if it's at least minlen.
>  		 */
> -		error = xfs_rtallocate_range(args, start, maxlen);
> -		if (error)
> -			return error;
> -		*len = maxlen;
> -		*rtx = start;
> -		return 0;
> -	}
> -	/*
> -	 * If not, allocate what there is, if it's at least minlen.
> -	 */
> -	maxlen = next - start;
> -	if (maxlen < minlen)
> -		return -ENOSPC;
> -
> -	/*
> -	 * Trim off tail of extent, if prod is specified.
> -	 */
> -	if (prod > 1 && (i = maxlen % prod)) {
> -		maxlen -= i;
> +		maxlen = next - start;
>  		if (maxlen < minlen)
>  			return -ENOSPC;
> +
> +		/*
> +		 * Trim off tail of extent, if prod is specified.
> +		 */
> +		if (prod > 1 && (i = maxlen % prod)) {
> +			maxlen -= i;
> +			if (maxlen < minlen)
> +				return -ENOSPC;
> +		}
>  	}
> +
>  	/*
>  	 * Allocate what we can and return it.
>  	 */
> -- 
> 2.39.2
> 
> 
