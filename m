Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8254354B1D3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928705; cv=none; b=nHr5DkLISFg/HydagTwqlUlo7aOEs+DDAgwtwWQD/hlgQleqPnF019aNbkkjkgcdpNhv7yuHjrXZqrAXG8qjEA+hQ+RUYrOPuUiF6VmfLbey+p3d9lKbVZd8Z/c3EH/PBcq1avjGIbnYCbpXIbQm8jTn4tbrumRhFyIN7YuZ4HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928705; c=relaxed/simple;
	bh=I7Nj3g9+DkNMlS8Navu7EcXWx0kiWWQUzNDCpf3lgyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTi5xNJ2M+ve9c1yXqZ+IvPGeiD0z4NpkcCyA0CzYB9dsWRYuLMv0b9joCOP5HPW4o1LbW2QS5YbM0Vyf4iNJazGDtAn+xFnyNsA0i5E8rAL1NUCr7mPQRUhjUSQP0P2rBpGlK92g3K1/7kXBWPRlxno9FcBRnuGdzMHTHi7mCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyemtKLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyemtKLY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EE4D01F00893;
	Tue, 13 Oct 2026 21:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791928704;
	bh=F4ul7HKpWwMx1mXNRfTv311PDLVduNHFL4BLOXms//0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WyemtKLYwyINq8qzG10d7I92Q8lisxXtbrI3MA7+gxm+tt/qhMmwvdJyTTdt/fVVw
	 DijaIuwVORtDp+edVNK+9vadbEn/55tIfKtCj0PVx35IFauQ+zzdA6kNSrZFmN4f/4
	 +QD/5Pyy88zORc6YugYheuoM9FmB0FKAE/JJYWjpsILEiLgm6bVFM83nQ2LyoXO6mf
	 U2lXGI9n5P9DPq8RGRqL6t+0h1lIcUPjoT9sLmUpwTirC9FA7tEdjnZdIN/7cYQDzA
	 dE+TKWfqOGGwdOvO+aF8XstrdLAYaLVOq59ai9L3frazoY1PUFR1m/3nc0s/oZYZp5
	 pIrI8B4Tl5voQ==
Date: Tue, 13 Oct 2026 14:58:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: add missing cursor status check after
 xfs_get_rec
Message-ID: <20261013215823.GF2705364@frogsfrogsfrogs>
References: <20261013211851.641256-1-sandeen@redhat.com>
 <20261013211851.641256-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013211851.641256-2-sandeen@redhat.com>

On Tue, Oct 13, 2026 at 04:07:46PM -0500, Eric Sandeen wrote:
> The xfs_inobt_get_rec() call in xfs_ialloc_count_ondisk fails to check
> the &has_record return - if the record is not found, the next
> conditional will read an uninitialized  or stale irec. Fix that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Yeah, we had better check has_record before using irec...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index e705f681ed44..17699f7c009f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2843,6 +2843,11 @@ xfs_ialloc_count_ondisk(
>  		error = xfs_inobt_get_rec(cur, &irec, &has_record);
>  		if (error)
>  			return error;
> +		if (XFS_IS_CORRUPT(cur->bc_mp, has_record != 1)) {
> +			xfs_btree_mark_sick(cur);
> +			return -EFSCORRUPTED;
> +		}
> +
>  		if (irec.ir_startino > high)
>  			break;
>  
> -- 
> 2.55.0
> 
> 
