Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFFA242D65
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386403; cv=none; b=kTf87A+0N3LgzBYQ5mIqQIXXA9MUKFX6y6e6QTDzEawVxk6ic//22gzG2KRnwAccqBhpePpEn2yMAOLTdU57K9li55/9SaodEEsk0YeloDT9Q9PZbDtGqoAFbxwPY9+EKXcye8SCHOSNVBkHHBvKBTcRPgZirfmb17JkAjpNOy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386403; c=relaxed/simple;
	bh=1DWtyC5/JQrryxRH+Sp7CV6f/Kofk7ite6xTjT5gz44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIM57awnLH49FPMz7NPBnEyoebgbkzEEG2zuXydYqzaEAtO9Xmf9Yhwh8iwHxcxvb4JNybRzpSuh1KnyVsgJaxF3gEoh2YeeLrYd48G9qB706Vr/Y2OsaLgSIfYRF5xzkWF/45/nvaKWogJTx6GaKydSRK/Cyys5PdqsemYRjkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcO4OTVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcO4OTVN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9C23D1F00A3D;
	Mon, 10 Aug 2026 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386401;
	bh=FDQHrlS2SrTvOIGMZE2s3e31zNEyflKReQaIV8C9sw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OcO4OTVNbPy9Wi2PPE0QXT+UP7JGfz93/LF+YYNPysjrGQJEHgpqcwjfRv0ctxqtK
	 nO4bIOTEwUrX6prcrz062cN4VWeJiczVoL+aiMnkYlqx84FjgzhZm0PMSqppCIaJfo
	 PArOdu4PSjeBcksQgIon9XzSsxGFtJn6QF3NMEh0McpqJN/eG+PE4Id/+MmYa3xnwn
	 druZW7KkNYgist0YhiOv1oGx+l65Vi0GBFvrymAFOGATKNciYTDzjsKUwJ3BlYzCqy
	 S0MUHvlHHXpeizoVxmC7B5PX3ZC2jdnrCMu6meyoGUTMH83Hy+jmA0yP5n0V/3ufm5
	 +JwoD2kVBcAqw==
Date: Mon, 10 Aug 2026 11:26:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use inode_init_always_gfp with __GFP_NOFAIL in
 xfs_inode_alloc
Message-ID: <20260810182640.GX3556460@frogsfrogsfrogs>
References: <20260810153848.466459-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153848.466459-1-hch@lst.de>

On Mon, Aug 10, 2026 at 08:38:38AM -0700, Christoph Hellwig wrote:
> Just like the inode allocation itself, allocation of the security data
> inside of inode_init_always(_gfp) must not fail here as we can be inside
> an already dirty transaction context.  Note that we do not have to pass
> GFP_NOFS explicitly as we are already in a nofs context when in a
> transaction, as seen by the call to alloc_inode_sb.
> 
> Also update the comment about this a bit to be more clear.
> 
> Fixes: bf904248a2ad ("[XFS] Combine the XFS and Linux inodes")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that makes sense.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 9d8dd30bd927..a857b8aa255c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -82,24 +82,20 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>  
>  /*
>   * Allocate and initialise an xfs_inode.
> + *
> + * This can happen in context of already dirtied transactions, so the memory
> + * allocations must not fail.
>   */
>  struct xfs_inode *
>  xfs_inode_alloc(
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		ino)
>  {
> +	gfp_t			gfp = GFP_KERNEL | __GFP_NOFAIL;
>  	struct xfs_inode	*ip;
>  
> -	/*
> -	 * XXX: If this didn't occur in transactions, we could drop GFP_NOFAIL
> -	 * and return NULL here on ENOMEM.
> -	 */
> -	ip = alloc_inode_sb(mp->m_super, xfs_inode_cache, GFP_KERNEL | __GFP_NOFAIL);
> -
> -	if (inode_init_always(mp->m_super, VFS_I(ip))) {
> -		kmem_cache_free(xfs_inode_cache, ip);
> -		return NULL;
> -	}
> +	ip = alloc_inode_sb(mp->m_super, xfs_inode_cache, gfp);
> +	inode_init_always_gfp(mp->m_super, VFS_I(ip), gfp);
>  
>  	VFS_I(ip)->i_ino = ino;
>  	/* VFS doesn't initialise i_mode! */
> -- 
> 2.53.0
> 
> 
