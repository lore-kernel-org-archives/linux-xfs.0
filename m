Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F4F45517F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339309; cv=none; b=ap7nRhV0FGtGfkKsNa5a7UMZ3RTYh2mhq6eje2I43I+XDDEQAjXlVTUy046Z9R3zczw//9a9nPM4UZnVnZcCV6cBYV4p8oaB0arOKROZcfGIQgh/7YZ+wmJE5EC4dIz2sQdxNNyCKjAmCBP5Ljtn+P7Dv9ZNHxQt8iDYF44y9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339309; c=relaxed/simple;
	bh=XA8tN6BF98eWQo61YEYHyc/jpDxii2pYswATxd2a5hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVzySA8dDvbHzeXvMSkKsHv6yCncSub2KjbCD0zMQP1mFkdbW0T3D+qDQqwzoDB2AQCRAVMqUilw0GR2isIoTASFoJLdo4MproqloIQUGxF6yUCUWNogfG3dl2VQd5Tacj6MBr5mJeBJAIkcxWBuHwflqbqeHygFU+sLt8jaFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fF8gcp96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fF8gcp96"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F0FB1F000E9;
	Wed, 29 Jul 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339308;
	bh=7h4o0fA6t7Zuu7EjN5xo7oopHEaXcVcqE1254thTAi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fF8gcp96DXLygqgg5mORwLjf17g0HdkDZXBOuRJ1QWZ7UlYB9x81l6LGAPkHQj7/d
	 DSm9MynnH0Rbrbcy+qEDP4X6QK9KSEIq5TLsg5S7HTTOQHa2ZUaB5Zj9KvUfrs1NV8
	 CNuq9dyGRIBtgO8yWgJ8PaATBOYSn1wAEa+6nVX03EaLkPlrcW//Ymo0PeHG7Qq49w
	 UoJL5GO48EMcULxay8apjpUGRr6utHL4EnDlGNfU6qM71CiWByNFkduI/ab0nJHRr5
	 grIvD0/pds1bi3Tx9YR9G0EyDZvCeH+TO4c6oqfSboXsYswC4+DRvhef3zjzN+UTEc
	 wTDVX7bcUHsAg==
Date: Wed, 29 Jul 2026 08:35:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: check v5 superblock features early
Message-ID: <20260729153508.GZ2901224@frogsfrogsfrogs>
References: <20260729130121.2281910-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729130121.2281910-1-hch@lst.de>

On Wed, Jul 29, 2026 at 03:00:58PM +0200, Christoph Hellwig wrote:
> When working on a new features that reuses the existing pad in the
> superblock, I noticed that mounting such a file system on an old kernel
> logs a rather confusing warning:
> 
>     XFS (vdc): Metadir superblock padding fields must be zero.
> 
> This is because we only validate the various feature fields in v5
> superblocks after the common superblock validation helper is called.
> 
> Fix this by calling the feature validation first.
> 
> Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense, and should probably get backported for the improved error
message.  Not sure if we care about pre-6.18 kernels though, since none
of them really support metadir.

Cc: <stable@vger.kernel.org> # v4.19
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> Changes since v1:
>  - minimize the fix, and implement all the good ideas later
> 
>  fs/xfs/libxfs/xfs_sb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..75f2a021ee6d 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1118,10 +1118,10 @@ xfs_sb_read_verify(
>  	 * because _verify_common checks the on-disk values.
>  	 */
>  	__xfs_sb_from_disk(&sb, dsb, false);
> -	error = xfs_validate_sb_common(mp, bp, &sb);
> +	error = xfs_validate_sb_read(mp, &sb);
>  	if (error)
>  		goto out_error;
> -	error = xfs_validate_sb_read(mp, &sb);
> +	error = xfs_validate_sb_common(mp, bp, &sb);
>  
>  out_error:
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> -- 
> 2.53.0
> 
> 
