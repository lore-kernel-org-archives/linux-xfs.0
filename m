Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392EB1FCF5B
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779842; cv=none; b=KJssuygRtvn8TFanRI4nT9ly4EeFG7JclTFzEVSy1BoxcS9XFK4N47Ck0ND/P5NRdGpL8RdBGjZwiFCrRHnN7HY8h/RitnbUe/E/6luKTv+7iqjjJKClbzSXBbjMeylXY7cg4x2n16Wkwc2uNq6jzB199aIwYXJZutEa9E1kwPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779842; c=relaxed/simple;
	bh=m8C9h0sps9UCHZwueqdkQmEiCF+Qvtt59ODkB7qS5mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/fmlhDJZOim/5RfYPtO3yXBXiF47KYvbjZ2135mCpZ85KXM+VBZKoH0PjFD73hy1Jzxffoc2ib6v01jnxmb9P9Kk4Fxi2BcykDyA9ahkct04FVLN3pRfc04hPvf86EifFAxfBbb88FinZ8dQkP8pzI3fzFywAnpznr+nyFOBKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tHb9p5nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tHb9p5nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0160C4CED1;
	Wed,  5 Feb 2025 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738779841;
	bh=m8C9h0sps9UCHZwueqdkQmEiCF+Qvtt59ODkB7qS5mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tHb9p5nzV9h+ObEF4s2Y5Cj56pgRMkBHrp0lNavpVDstdP9aSV5JB2BCnlgX4PezI
	 U4sn8yys0pNbC59vfgd8mbNdEhj9f5mSrhvCJli12Y5C6rXiNSsfBEkBsyLwStXUFc
	 h0aPbOEvGbdnW46yKw4x+Z5dzrpY6Z0Wo1l+1t4tXlN1VDZ34JyxmZXeUWiGQnLCvN
	 88sH4soqtqrl7tNpz58pKxRk7wnh5Vhc+rJEPolDteiH4KWsM1JhcBTGYbUxW5jWjL
	 kTBM0Y75p5hSrh3+ncRyHr6SNo94CLP/NUQ5ktc3Wz92sSgNStsFtLVky1DoLaj7l/
	 Q9FgqZtqVX5UA==
Date: Wed, 5 Feb 2025 10:24:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename xfs_iomap_swapfile_activate to
 xfs_vm_swap_activate
Message-ID: <20250205182401.GK21808@frogsfrogsfrogs>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205162813.2249154-3-hch@lst.de>

On Wed, Feb 05, 2025 at 05:28:01PM +0100, Christoph Hellwig wrote:
> Match the method name and the naming convention or address_space
> operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c792297aa0a3..fc492a1724c3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -681,7 +681,7 @@ xfs_vm_readahead(
>  }
>  
>  static int
> -xfs_iomap_swapfile_activate(
> +xfs_vm_swap_activate(

Hee hee.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	struct swap_info_struct		*sis,
>  	struct file			*swap_file,
>  	sector_t			*span)
> @@ -717,11 +717,11 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.migrate_folio		= filemap_migrate_folio,
>  	.is_partially_uptodate  = iomap_is_partially_uptodate,
>  	.error_remove_folio	= generic_error_remove_folio,
> -	.swap_activate		= xfs_iomap_swapfile_activate,
> +	.swap_activate		= xfs_vm_swap_activate,
>  };
>  
>  const struct address_space_operations xfs_dax_aops = {
>  	.writepages		= xfs_dax_writepages,
>  	.dirty_folio		= noop_dirty_folio,
> -	.swap_activate		= xfs_iomap_swapfile_activate,
> +	.swap_activate		= xfs_vm_swap_activate,
>  };
> -- 
> 2.45.2
> 
> 
