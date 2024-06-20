Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A51B9AAC
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909428; cv=none; b=sTZA502dGlf4VKa2t/5cboRDCFd76nDZPQ/io1k64qswKvThE9SAAyttxOU9CR/9Detye7xQ6IyGj3VSGBsPIOrKVg6EXSdJxDIYxDEqUVed0sPBxErMAUqt7Fngwd894hU7ZV1hjS+LxZ23Yc0sUm46m824zUyr35a/dO1BGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909428; c=relaxed/simple;
	bh=jwHHimXc1Qr80kcV7zV8PGhoUof7r/Nibli/42rj3QI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDACpYsm52A3XjdwiEdFJB6q0WgtbIOrfSOwaytK7zTIgWr0fwkUrH9+VTvDF99MJV4E+ljdXg5tSGvB7HS6RyDxVZUssZbIOBOmcTgkvLiY6idAGS4yzH6Mam8nCv/hqDE9tq7Bk7cYXAoYtXxVSpN0v3DQBM6t5P6skAHpEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDf6YyqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDf6YyqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E96C4AF0A;
	Thu, 20 Jun 2024 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718909427;
	bh=jwHHimXc1Qr80kcV7zV8PGhoUof7r/Nibli/42rj3QI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eDf6YyqVDylF7i+6lfyGViiO7JCVv+I/59Kdqizd9IGDWn8wczvrzkIhCS88DfusU
	 zUokk0MiJu3VaMhiwku1e6RS4y4fv4xOWbcbXPZVsyrTo9AVGlOXYVhb8rU/DbTkWD
	 SW67EGODd+vqtYpIPxmuhKn2Yu4ox9f4dadrWPsyfl2+RK1GEXj2itTsMBqlmQdnga
	 cqsBVr844wEH3lXnwRB07zXYJsZ/5gdhh0UMkyZ7DfP4QI4HM00WRQfVhZhaHuEcSA
	 jMZc4H6Oll7AqK6phCl5HIv6idbh0LIPFmLfhAh/khwMDx6qncKwKEPEQ+P6QMY8v/
	 lkSLYLEdhn9nQ==
Date: Thu, 20 Jun 2024 11:50:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: simplify xfs_dax_fault
Message-ID: <20240620185026.GA103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-4-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:53PM +0200, Christoph Hellwig wrote:
> Replace the separate stub with an IS_ENABLED check, and take the call to
> dax_finish_sync_fault into xfs_dax_fault instead of leaving it in the
> caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 74c2c8d253e69b..8aab2f66fe016f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1251,31 +1251,27 @@ xfs_file_llseek(
>  	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
>  }
>  
> -#ifdef CONFIG_FS_DAX
>  static inline vm_fault_t
>  xfs_dax_fault(
>  	struct vm_fault		*vmf,
>  	unsigned int		order,
> -	bool			write_fault,
> -	pfn_t			*pfn)
> +	bool			write_fault)
>  {
> -	return dax_iomap_fault(vmf, order, pfn, NULL,
> +	vm_fault_t		ret;
> +	pfn_t			pfn;
> +
> +	if (!IS_ENABLED(CONFIG_FS_DAX)) {
> +		ASSERT(0);
> +		return VM_FAULT_SIGBUS;

Does this actually work if FS_DAX=n?  AFAICT there's no !DAX stub for
dax_iomap_fault, so won't that cause a linker error?

> +	}
> +	ret = dax_iomap_fault(vmf, order, &pfn, NULL,
>  			(write_fault && !vmf->cow_page) ?
>  				&xfs_dax_write_iomap_ops :
>  				&xfs_read_iomap_ops);
> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret = dax_finish_sync_fault(vmf, order, pfn);
> +	return ret;

I /almost/ wondered if these ought to be separate helpers for read and
write faults, but then I realized the (write && cow_page) case is a
"read" and ... lol.  So the only question I have is about linker errors.

--D

>  }
> -#else
> -static inline vm_fault_t
> -xfs_dax_fault(
> -	struct vm_fault		*vmf,
> -	unsigned int		order,
> -	bool			write_fault,
> -	pfn_t			*pfn)
> -{
> -	ASSERT(0);
> -	return VM_FAULT_SIGBUS;
> -}
> -#endif
>  
>  /*
>   * Locking for serialisation of IO during page faults. This results in a lock
> @@ -1309,11 +1305,7 @@ __xfs_filemap_fault(
>  		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
>  
>  	if (IS_DAX(inode)) {
> -		pfn_t pfn;
> -
> -		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
> -		if (ret & VM_FAULT_NEEDDSYNC)
> -			ret = dax_finish_sync_fault(vmf, order, pfn);
> +		ret = xfs_dax_fault(vmf, order, write_fault);
>  	} else if (write_fault) {
>  		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
>  	} else {
> -- 
> 2.43.0
> 
> 
