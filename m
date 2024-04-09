Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2B5157476
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704633; cv=none; b=YPSOGQAjldyJGpXoYbyVjDdcdpiA7Y60fW9On+tywWDuNFWXs0t+m80jpVLykdGyhbKnp2drBoCDAyEbN/TKavOjStGyhsy8ai9qP2p14y8CFQpx7derLNlqs6BNkV9f91dWN6woo7pQleTtkNPakULp4kAFnhcv8TFYsWr4MTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704633; c=relaxed/simple;
	bh=g1KK4yNjABR1TOjZMZykyDCtUhE+Jv8FVh4QawTIdzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1I/stfBRyPvURzALZ6GcH1rKttV6dxtUmjgCfoJRYtKaz8apBSq5cltwekZ76wzmZgsbr0sfzEydzEU4kCdlzuKSga4cNOjXwmILtrp9b7OHbfUiN/2sWhWvOmmVgj8Pr9xuhERx/o2YGXQr/ojfinBEr7HHc7wQBU2gqRIXk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umxRCVZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umxRCVZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA90AC433C7;
	Tue,  9 Apr 2024 23:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704632;
	bh=g1KK4yNjABR1TOjZMZykyDCtUhE+Jv8FVh4QawTIdzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umxRCVZXFH/DdY+il4Y0t4crr7YRk8lbjTY9q3EtAGAdKGInltVB9llcHq/z3NfKK
	 A8AErStVzz2yUInVH98n3yFy2LV6yfdcH7oQCobHx60NwFQ5qheDLiWODftEgbHrP/
	 QKGAvr6xxNYpFIAM7BaI4NxktjXuytgEKNqBAogMt6qQcoiInQeCQSF0hDE8eLT5PX
	 hTJaKvG0lQgykMpHtL0DtfyhLLuLt/3MVF6Vv4R56sMCRc5ZGIUOcpMHEDROTtcghb
	 4YacK7HjkjPBGvMW+4sOwxcsHpTVW+nSucH5aggItHD/RC+AQ9/4mTo0nFZY2yZAqR
	 xJRl3F92V/X8w==
Date: Tue, 9 Apr 2024 16:17:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/8] xfs: don't open code XFS_FILBLKS_MIN in
 xfs_bmapi_write
Message-ID: <20240409231712.GM6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-5-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:50PM +0200, Christoph Hellwig wrote:
> XFS_FILBLKS_MIN uses min_t and thus does the comparison using the correct
> xfs_filblks_t type.  Use it in xfs_bmapi_write and slightly adjust the
> comment document th potential pitfall to take account of this
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward conversion,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 3b5816de4af2a1..f2e934c2fb423c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4537,14 +4537,11 @@ xfs_bmapi_write(
>  			 * allocation length request (which can be 64 bits in
>  			 * length) and the bma length request, which is
>  			 * xfs_extlen_t and therefore 32 bits. Hence we have to
> -			 * check for 32-bit overflows and handle them here.
> +			 * be careful and do the min() using the larger type to
> +			 * avoid overflows.
>  			 */
> -			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
> -				bma.length = XFS_MAX_BMBT_EXTLEN;
> -			else
> -				bma.length = len;
> +			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
>  
> -			ASSERT(len > 0);
>  			ASSERT(bma.length > 0);
>  			error = xfs_bmapi_allocate(&bma);
>  			if (error) {
> -- 
> 2.39.2
> 
> 
