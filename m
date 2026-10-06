Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141EE26AC3
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 07:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791271527; cv=none; b=YVPWmk9LWltNsl+FzNWcRdfqWbNVGUyJVEVA+g4/xCbRqQaMpvNkp3ic1hvqutHQCk4xswqQuZyohNXLSxzFnuQhdy0TGvT6ks+h/1GgtWljqHsCM95t2XZgbdLmcFii7suWzwZLjB8JSQ6lGzYWF1BILB7kU9BZgBSnjkntrCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791271527; c=relaxed/simple;
	bh=+3PCfl1V+z/dtJr0gXLl4zFK5pNBpH0jJN8CkSm6b2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMVZY46EjLjscF8HgjZzux0vwB6t7fRLN+s53sQ2g+IhsoDf+qUY1OuWOSF9TvfZ26Cc4u6p6pttlUzmYOLxIduSrQCVVyYdEBUfhroF4YSs5wi4uCXpASqdHru1WWTI8fiNyTUlKCXZ6dCTr2oC6lqJ5/A2jQlTinCG/TqHcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdjvymHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdjvymHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568A81F000FF;
	Tue,  6 Oct 2026 07:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791271525;
	bh=BEIWa+R4/MCKg5XoYNjHz1jbYVPyqbRDzBJDdgvaNvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HdjvymHqZp3zM/w7BY7V12geSb+TR/a9krrPthsemynpLKkx+tVV3LfbZyHjHoanT
	 +Nt0o4rnSl0nhFjfb/hqIyI2lviTwk7Xn0xU1W0WNZ9xGeA01HR/sYqy3ZgkveO4IL
	 Gt66OUXfByKfJrdb+UbXnKb3cyyY5LoXzTGD56dbQ7J/XWiMkf8tn96saMQ2e7lb/S
	 6W3jUEhZXxJDCViFC33GU+DCPh0ESfUOrsiwYT4sPP6P8Dtqgm/yw6PqJYUwZ0jXlv
	 RjL1xb2ri5Rj/lbFn29jIBRE49CccJvY3M34ws1fy/dYvgWe8bmcpYGgn4fzNFeQim
	 p+DJNJ21wl+3w==
Date: Tue, 6 Oct 2026 18:25:17 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Norbert Szetei <norbert@doyensec.com>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <asSiXW4XxBl8Kivw@dread>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006050914.GU2705364@frogsfrogsfrogs>

On Mon, Oct 05, 2026 at 10:09:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Norbert Szetei posted a patch containing an incomplete description of a
> bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
> exchange-range into modifying a file so that it has shared blocks
> starting beyond EOF, which is never allowed because files never have
> written data beyond EOF, and you can only share written data blocks.
> This is key to all the incorrect behavior that follows.
....
> 
> Having confused the file sizes, the PoC uses a second exchange-range
> call on what looks like a non-reflinked single-block file.  Because the
> file size is set incorrectly, exchange-range thinks it's exchanging the
> full contents of two files and clears the reflink flag on the broken
> file.

Hmmm, another "exchrange reflink flag coherency" bug.

Aside from fixing this specific issue, how can we prevent
other/future logic bugs from failing to set the reflink flag
appropriately and so never expose such a bug to userspace again?

I'm thinking that we should not try to swap the reflink flag along
with the extents. Instead, if one of the files had the reflink flag
set before the swap, then we scan scan the extents of both files
after the swap for shared extents and set the reflink flags for each
file appropriately.  EXCHRANGE isn't really performance sensitive,
so the cost of the refcount scans shouldn't be an issue.

Setting the flags this way means it doesn't matter what file shared
extent(s) ends up in, the inode(s) that owns it(them) will always
have the reflink flag set correctly. Hence there is no way to use
EXCHRANGE creatively to expose this "didn't COW when it should have'
class of corruption bugs ever again...

> That enables an extending write of the broken file to rewrite the
> shared block that's just past EOF.  This has become known colloquially
> as refluxfs.
> 
> Once the file sizes are set correctly, the second exchange-range no
> longer thinks that it's doing a full-contents swap, so it won't clear
> the reflink flag on either of its file arguments.
> 
> Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
> Reported-by: Norbert Szetei <norbert@doyensec.com>
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
>  fs/xfs/xfs_exchrange.c       |   10 ++++++----
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 6a66b6075e0af4..c9d9464e9d39f5 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
>  	const struct xfs_exchmaps_req	*req)
>  {
>  	struct xfs_exchmaps_intent	*xmi;
> +	struct xfs_mount		*mp = req->ip1->i_mount;
>  	unsigned int			rs = 0;
>  
>  	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
>  	}
>  
>  	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> +		loff_t	off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> +		loff_t	off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> +
>  		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
> -		xmi->xmi_isize1 = req->ip2->i_disk_size;
> -		xmi->xmi_isize2 = req->ip1->i_disk_size;
> +		xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
> +		xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
>  	}

I think this really needs a comment to explain why the calculation
is structured this way. I think it is trying to set the file sizes
to the "destination offset" + "swap length from other file" because
the ranges in each file might be different lengths, but I could be
wrong...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
