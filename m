Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E41D7E5F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734039538; cv=none; b=lVT0NOMnaF46G+TFu31FFviVdC+g8BcD9xXEvihpBKcdLxjzh5V9xetFBj3rI6BYA7WydjGdRljVydMZPBo04issRR/jj0tT3aw+Np1l8H/d05mT1FeYF/G941vC7WKjirmrB4qbuWDxn8bPXcIDBPcVOun/yI3sd0R/mGtpJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734039538; c=relaxed/simple;
	bh=N81AFoIJ+283vkHcReGkk26kqLYUve9+TvrWqJf0icQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLf7G+7n5tVPhRkb2ORerB4LcT84ehR8hNWTv+6w66FA+IrbzANf2v6OeZw06vza6FJJBEzSYY7d089XeaauRCQTrsdS/IImka6oK6gzXvvhw0BU/2sqEHxN9e1oaY6h0nuEYZcpv+WH//SgnkfMkba3QFn+jwDYP4nIqBr7a3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PycANQ6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PycANQ6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23580C4CECE;
	Thu, 12 Dec 2024 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734039538;
	bh=N81AFoIJ+283vkHcReGkk26kqLYUve9+TvrWqJf0icQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PycANQ6NFW4Pt6EZA1k/B4OQ52+Vw2IVP9BgfhNd4s/38nPQep1I6XNv3YMwFq5WN
	 7gN0hcsn+61k65f1eUtSGKXYkbm1qX0Yicg1Ifvm8YiGJcwNn+DlarYFmEuXHgWXPk
	 9qNmFBA3YVpQnfW78IH+VKbExJbHhC7SIt3GmwLnbT1xPsmBNNdo/kSf9S99NARi5T
	 aG7YCzwMadCxD2icV0Fr+2LrEdPs1pUYbtQkRlVG19u53nlZwxJu6UuiusmN6Q8kUY
	 plpCb0knCe0A/NHceCf5b9xhVFFjMzTXi7GRWQh+D4IbfjwsyMELa3dS+tyN5slfSO
	 MlEzhuZRbiNbA==
Date: Thu, 12 Dec 2024 13:38:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: skip always_cow inodes in
 xfs_reflink_trim_around_shared
Message-ID: <20241212213857.GW6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-12-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:36AM +0100, Christoph Hellwig wrote:
> xfs_reflink_trim_around_shared tries to find shared blocks in the
> refcount btree.  Always_cow inodes don't have that tree, so don't
> bother.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Is this a bug fix?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 59f7fc16eb80..3e778e077d09 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -235,7 +235,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
> +	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> -- 
> 2.45.2
> 
> 
