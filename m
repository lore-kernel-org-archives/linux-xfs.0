Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6531F1110
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlWvyED0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF371C433C7;
	Thu, 14 Dec 2023 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587763;
	bh=DcBMD6zS76JbqkgmL9lS1HJhQ2qnyxLmKDqkrzl+M6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlWvyED0Cv+KL8k2R4nfb0hgxed6FgaMqVLScd0QGB7AG39v8Y9DI7JJoLyhxqQcB
	 v+xxKFWZOOsHh6HVp+vgXPu4p3tZDXgk65FGK+wo3Xi2m4LYKXTMyk0aftiCrWN79N
	 bTJYA7GrHUKr/KUMsEpUYhx72OifPDPQpmHG7uiLYosdrou/tOiyLhNvdkxs8ijRB6
	 84JLHIf++kSZSlwXWxW3FrVYZJya0gBxMEc9cUvnAWRPQ+vShIEygP9cYGorDV13w6
	 zLwqLaG5DzhpAOYBFdXmUZkOHBbarsxHF8hh/T488wLyg+S+vSLjF0fTT+0mT0hkGN
	 2RZzQ+12CrUAw==
Date: Thu, 14 Dec 2023 13:02:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/19] xfs: consider minlen sized extents in
 xfs_rtallocate_extent_block
Message-ID: <20231214210243.GA361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-2-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:20AM +0100, Christoph Hellwig wrote:
> minlen is the lower bound on the extent length that the caller can
> accept, and maxlen is at this point the maximal available length.
> This means a minlen extent is perfectly fine to use, so do it.  This
> matches the equivalent logic in xfs_rtallocate_extent_exact that also
> accepts a minlen sized extent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 8feb58c6241ce4..fe98a96a26484f 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -309,7 +309,7 @@ xfs_rtallocate_extent_block(
>  	/*
>  	 * Searched the whole thing & didn't find a maxlen free extent.
>  	 */
> -	if (minlen < maxlen && besti != -1) {
> +	if (minlen <= maxlen && besti != -1) {
>  		xfs_rtxlen_t	p;	/* amount to trim length by */
>  
>  		/*
> -- 
> 2.39.2
> 
> 
