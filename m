Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF523B71BB
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950369; cv=none; b=RggoNRHIOETjLpKeldnSIuTqaxXWUQFkiLXrnGAtNUh8hg4ztj14KcSxFLyPAezF+bD0RifRRsX0BSO9iFwY6xrnMEzHchD1SahB2Y/1oUOYLm3hT7pYia2bEvSoZEYYwIxMxkIuyBfhX/oBzfQMFjz/TzqL2ktNnSTsxgtjIl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950369; c=relaxed/simple;
	bh=oUj2yTHFc/t6apj4ClCXUia7OtC41aTQCjqmCwT7vXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAmrRffpANWLlenuN03Ebbl4yJKEwxVD/YHVT4aibChiBzlEl+ZNqIXo41IrrHolBnbbPFoA+Tkd93To+EfraSnaDCBA8nhKKglo0BJajeMnqv8iE+gZXsK70eP9FTs9GYXi/xNx1d2Fn2K2hpvvbmkavD3EF/IqvfxOGlJ1DVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqSxlsiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqSxlsiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894CF1F000FF;
	Wed, 14 Oct 2026 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950367;
	bh=Ko0vWd/L2IBtyhDxmSs+vxDUaTfxl+ek7h51rOGIr5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aqSxlsiMznTGREgTEWHU/H7+llCRWleJP7fqliVYNDxmH2PHVNv81nrqKcakK0GRJ
	 H+5TwaPjU3b3T90k1MOfRZ1AP9VdJ4UjQZwK9+pKzjTXkjOolcWqZdkUcHnNEjoGL+
	 Oix0L+zOYmR5/padToso9JRi2TPTjIDR4cELbsjNjcGz3o7updsr1jsA6zEuibK6Dr
	 VuvDazNaeRj81SDGtBgW0drLHZC/INjTPxEYukEriUbi0laEooYWyZ/l2F5mMwMidh
	 rOfsobX0P2WBSRFFyxuSZRSNNjO9B10LLpvdnb2W+rnr3SkdDkbFRk8VJUTpIFgVTl
	 eAusfaVJy+D7Q==
Date: Wed, 14 Oct 2026 14:59:19 +1100
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH 5/5] xfs: remove status parameter from several btree
 insert functions
Message-ID: <as7-F3aJcKmqu3mO@dread>
References: <20261014013505.759089-1-sandeen@redhat.com>
 <20261014013505.759089-6-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014013505.759089-6-sandeen@redhat.com>

On Tue, Oct 13, 2026 at 08:30:03PM -0500, Eric Sandeen wrote:
> xfs_btree_insert and its callers now have no need for the status
> parameter; either they return error = 0 / status = 1, or nonzero error
> and status 0. Every caller now handles the error and never reaches
> the duplicate status variable check. Remove the status params.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 10 +++++-----
>  fs/xfs/libxfs/xfs_bmap.c     | 22 +++++++++++-----------
>  fs/xfs/libxfs/xfs_btree.c    |  4 +---
>  fs/xfs/libxfs/xfs_btree.h    |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c   | 13 ++++++-------
>  fs/xfs/libxfs/xfs_ialloc.h   |  3 +--
>  fs/xfs/libxfs/xfs_refcount.c | 17 +++++++----------
>  fs/xfs/libxfs/xfs_refcount.h |  2 +-
>  fs/xfs/libxfs/xfs_rmap.c     | 14 +++++++-------
>  fs/xfs/scrub/rcbag.c         |  2 +-
>  fs/xfs/scrub/rcbag_btree.c   |  5 ++---
>  fs/xfs/scrub/rcbag_btree.h   |  3 +--
>  12 files changed, 44 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b40c51a0f651..13a61144a2c8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -692,7 +692,7 @@ xfs_alloc_fixup_trees(
>  			xfs_btree_mark_sick(cnt_cur);
>  			return -EFSCORRUPTED;
>  		}
> -		if ((error = xfs_btree_insert(cnt_cur, &i)))
> +		if ((error = xfs_btree_insert(cnt_cur)))

While you are touching all of these, can you convert them to the
more common pattern of:

	error = xfs_btree_insert(cur);
	if (error)
		return error;

Otherwise the whole series looks good to me.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
