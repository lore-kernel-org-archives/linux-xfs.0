Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C795D52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598259; cv=none; b=DEPmXty71kFqxIxEXR09GT5KxFHXnGn66137wGmDErQgHicBY1sjQkfdcrSBfDBdtc0uNsI9s2h9TyUAAQd7wL+AjC+hc+GswS4GcAYZBadHpOp7ZasaN+kbfeIcsdqwhGLOsXv0GbhxQCJjDfKEy+Ugg431SIx8eXVjs8Ff9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598259; c=relaxed/simple;
	bh=ZBVtlS+3q7ovbOTkg/CAfkg3+Ynkj75epW2hhkfgx6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTHTrMVpIsRUrLUcbQf//zceyZmt7bWWMJpbFXOyTYx4m291cCw0+dy3sI1L25A3WWvv6hbTvXn8ID9zIR/8Fpd6z2v92Ndd4+aUNhL/FtFjC4O4WWbP40L6FW5D8nvxCKNg6qBAdEEnPFBzoX5pD3UqyWpWmDC/JyeykwMRSDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=if7KwXQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="if7KwXQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC714C072AA;
	Wed,  1 May 2024 21:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598258;
	bh=ZBVtlS+3q7ovbOTkg/CAfkg3+Ynkj75epW2hhkfgx6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=if7KwXQr6tiErOjXrfzQjcFpPExu7inb6dNxX0vYBqPoEyg6df1AgVMGNJOFPwEzk
	 bJz26XJ6iPnisvjZx/Dyy0NiYXrSMwm+ghLAcKajXSr3pri1nNrlr8RqbgpgFIxNLO
	 x+oBcetmCSlBj0nm91EWLUf76fZaoCOt3bZsXaGyKJyuAyPMfqKAl1e36mkORt+E7a
	 g2KLeA6Pg66NVxG+3B+BkwFBLBsimAeveMp5uOO0l8c8Fu8Qs+pGGA8vmZRcPmQC2Y
	 0bRAncg1pkSOIVc72RxhI2apu7uWGtvKodtZiFFMjcPgGB1z06SwsXDoNT7ZYJP0Ks
	 aVgGQHdbdwMwA==
Date: Wed, 1 May 2024 14:17:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: remove the buffer allocation size in
 xfs_dir2_try_block_to_sf
Message-ID: <20240501211738.GU360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-7-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:16PM +0200, Christoph Hellwig wrote:
> We've already calculated the size of the short form directory in the
> size variable when checking if it fits.  Use that for the temporary
> buffer allocation instead of overallocating to the inode size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index fad3fd28175368..d02f1ddb1da92c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -281,11 +281,11 @@ xfs_dir2_try_block_to_sf(
>  	trace_xfs_dir2_block_to_sf(args);
>  
>  	/*
> -	 * Allocate a temporary destination buffer the size of the inode to
> -	 * format the data into.  Once we have formatted the data, we can free
> -	 * the block and copy the formatted data into the inode literal area.
> +	 * Allocate a temporary destination buffer to format the data into.
> +	 * Once we have formatted the data, we can free the block and copy the
> +	 * formatted data into the inode literal area.
>  	 */
> -	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
> +	sfp = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
>  
>  	/*
> -- 
> 2.39.2
> 
> 
