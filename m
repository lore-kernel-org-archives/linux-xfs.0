Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E8F18030
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818837; cv=none; b=kLQCr2z7Boi4y0wu2INQr/lG0AkathYHXIlD3uLBHtHPlZ1nTjhP2GqWRB6wS4zcN1ZjVOs4v/jMNTuyLONdb3cabKoJ6i4mCcVFQAaVekFDYugNQnhO/kq6lg3oyrLK3HM/l4NA6XH+Oue9pxhJQ4CprOsgy0YXp0E7/ni5vG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818837; c=relaxed/simple;
	bh=JvaQ5mq4boEWOv43JDrQtAEMYN89PfMaf+Zaa2OLXwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRXFgnmm39Xjc3lQblL/Y5qf6rUSguzVBvQhjteZ2uPMI7IDnQ0GXGYz6E6dTHkXxtMX9zy5vYz4AkwkS9IJWIDBa1skE5kOcYP2eSkRIiwQZ21+p3XG9GM5NrJuLL3VsmVIAUA/XCtyVtqCfGCBhvIgz7Cm4+NPayiAhuPVe4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8768168B05; Wed, 28 Aug 2024 06:20:33 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:20:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/10] xfs: hoist the code that moves the incore inode
 fork broot memory
Message-ID: <20240828042033.GI30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 27, 2024 at 04:35:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Whenever we change the size of the memory buffer holding an inode fork
> btree root block, we have to copy the contents over.  Refactor all this
> into a single function that handles both, in preparation for making
> xfs_iroot_realloc more generic.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c |   87 ++++++++++++++++++++++++++--------------
>  1 file changed, 56 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 60646a6c32ec7..307207473abdb 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -387,6 +387,50 @@ xfs_iroot_free(
>  	ifp->if_broot = NULL;
>  }
>  
> +/* Move the bmap btree root from one incore buffer to another. */
> +static void
> +xfs_ifork_move_broot(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	struct xfs_btree_block	*dst_broot,
> +	size_t			dst_bytes,
> +	struct xfs_btree_block	*src_broot,
> +	size_t			src_bytes,
> +	unsigned int		numrecs)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	void			*dptr;
> +	void			*sptr;
> +
> +	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));

Overly long line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
