Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916EA595745;
	Tue,  8 Sep 2026 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893808; cv=none; b=XznSKa52IMwA5ZUzADNn3pfOM+BR4fbKqMqqZfi6ehMkLMvO8YTxMsfrPDuM1wj+JVZRlBoUr1KYmaIsfbP+/YjjmrOlWVmhPeYtFA3LsPcwWeXI0yHKptcwIPVvbjGidNZGAjQ2aW+A1YvzDbpii0aG/xMqBlt3BUvYiW3wnk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893808; c=relaxed/simple;
	bh=f7PEyOt3JNcaMn1+lbqfcipo2OVYJ+0pMlvBTga0ofA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVW0BhTzWvaen8DUnSbeNCChE5IN6B4l8t4yas+ufH5T8JnYAitNufy9c81Qa9EgPav+gEwBzIbhs12lNHo/X+jtVG8EsWlnNT45SbOFOQYZsqYbGfajlbZPB17dqKq1rvrqmD4YP5XsbBl+20zuqqLerzigP1sOAN0SYUMM4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZS7bQvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZS7bQvb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 277FF1F00A3A;
	Tue,  8 Sep 2026 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788893807;
	bh=Q3xTvYH38yrqBeUdvCpSOTtMsiy3C2x+4I+sL4PIZ5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SZS7bQvbW6CRHvuZYpfTrWekS7YKmBHNnfrBfFuJmvEIcLlMUp1WjtSQO8jAnEbBg
	 g9v5GcOakOwEhYQ1FJiBDwaTpT9staiOgNjgGHHgxB63p0F+fuZqcI8iNDOeOnJmLU
	 KTUtHxkebBiHWUHYzMMI33D7pnF6ukKHQTg9qp8BKL62m3rBmud1X9inGrx2wvKY+q
	 rln/D0Tatd+TNaLR9I1yCoFD7RqQPylNW/PHaLH2vjV0s5pZVNr4386gDvTJEcX6dg
	 uqdtG6TRaPSC15OQBjbsIq8qJgAG9u3qRt6rkFnU/X5DJsYx7VLm7+moZZNe1p2u4F
	 atksjE6aLgHiw==
Date: Tue, 8 Sep 2026 11:56:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Chinner <dgc@kernel.org>
Subject: Re: [PATCH] xfs: reserve a full directory block when repair expands
 the tempdir
Message-ID: <20260908185646.GG127607@frogsfrogsfrogs>
References: <20260908-b4-xrep-dir-total-v1-1-b982f1652fd7@peridio.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-b4-xrep-dir-total-v1-1-b982f1652fd7@peridio.com>

On Tue, Sep 08, 2026 at 10:16:12AM -0600, Javier Tia wrote:
> xrep_dir_swap_prep() passes args.total = 1 to xfs_dir2_sf_to_block(),
> but the conversion allocates args->geo->fsbcount filesystem blocks,
> which is 1 << sb_dirblklog.  The two agree only when the directory
> block size equals the filesystem block size, so the shortfall is
> invisible on a 4k block filesystem and is four blocks on a 1k block
> filesystem carrying a 4k directory block size.  xfs_da_grow_inode_int()
> then subtracts more blocks than total ever held, underflowing it, and
> hands the understated value to xfs_bmapi_write() as the remaining-space
> hint the allocator sizes minleft from.
> 
> fsbcount is what the other caller of this conversion already reserves:
> xfs_bmap_add_attrfork_local() sets dargs.total the same way, and it is
> exactly what the single xfs_dir2_grow_inode() call underneath consumes.
> The attribute counterpart in xrep_xattr_swap_prep() keeps its literal 1
> because m_attr_geo->fsbcount is always 1.
> 
> Found by the reservation assert in xfs_da_grow_inode_int(), which Dave
> Chinner hit running xfs/286 at 1k block size.
> 
> Fixes: b1991ee3e7cf ("xfs: online repair of directories")
> Reported-by: Dave Chinner <dgc@kernel.org>
> Closes: https://lore.kernel.org/linux-xfs/ap-mIH9nTNkpWq9K@dread/
> Signed-off-by: Javier Tia <javier@peridio.com>
> ---
>  fs/xfs/scrub/dir_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 31a23c5f386a..0a3d02d8f041 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -1488,7 +1488,7 @@ xrep_dir_swap_prep(
>  			.geo		= sc->mp->m_dir_geo,
>  			.whichfork	= XFS_DATA_FORK,
>  			.trans		= sc->tp,
> -			.total		= 1,
> +			.total		= sc->mp->m_dir_geo->fsbcount,

This is enough to shut up the assertion, but it doesn't fix the
additional problem that the block reservation in sc->tp can also
underrun for this same reason.  I'm testing a fixpatch for both, please
be patient...

--D

>  			.owner		= I_INO(sc->ip),
>  		};
>  
> 
> ---
> base-commit: 0ca15a1a115132dfebeee5447fd6abe46f66d61d
> change-id: 20260908-b4-xrep-dir-total-3c77d0bcff51
> 
> Best regards,
> -- 
> Javier Tia <javier@peridio.com>
> 
