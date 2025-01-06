Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB863597E
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183482; cv=none; b=m0/BXv5j6GPa1t9+C9bfDRTH5mr9ySybkIZ5i+38d4EX6CWkHeCdrE5gnf/sG8VXG5z3TFMZNn9uPj9lIRkjItgwwHU5glC0dlVpbp+HUcGwKPL1VdiJOTXzmnSnnn5nnhZlw3eKqSlPOp9ZMOV2lsF9F9IQusQmVKa0p+0Lwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183482; c=relaxed/simple;
	bh=KeXW02rawzVp6laYEDYfder/o97D5JrhPG0g/eup7gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYWMnAm70n//UGnDqY6MBww0X3D98fGanYGvBPMVpGeZW2smm1V+npPD1G3O+S3aDk8VxGS2tvGQ7fp9MDjM6tZtZFTQmHn2Z6G9ZvwjwNlTSOmd/e7Iz4oQLAijhKAySJ+oCbWtXjDaYiDLhx/4kNvgsikKgAY0yFs+qWYpBe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbHRmUyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbHRmUyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3294C4CED2;
	Mon,  6 Jan 2025 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736183481;
	bh=KeXW02rawzVp6laYEDYfder/o97D5JrhPG0g/eup7gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbHRmUyfLWRP9uPMxpj/vRVw0Le/k3uTiou+15l8aZodolx30aA+Ii7xveYMbWN1i
	 eYvPZS+SByYX/V0P1fOtivroHrmMwT1zsOeAkgmbuxew7gdwJAnD5h1G7x6xyO2uDg
	 3uLMXQE5UU2AD17KbH0UjLyiVK/5QPLwScAaL5sGQb65l2O0e7Y1urYmxQq+ruDFna
	 cy4xbd+5EmU/JBdL5sFt9iHnT/m1Pu58DXtCHBUrwQ989biXlgHVY4mZ0YZ/yOnuLY
	 HRaF//ov1L3Ke6S/WnJwPAm2eLaef/Eu437HJ39dZ8l4r1oUM+vt49NSfqu95l9tDM
	 wZZpIz13+DkrQ==
Date: Mon, 6 Jan 2025 09:11:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: remove the t_magic field in struct xfs_trans
Message-ID: <20250106171121.GA6174@frogsfrogsfrogs>
References: <20250106095044.847334-1-hch@lst.de>
 <20250106095044.847334-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095044.847334-4-hch@lst.de>

On Mon, Jan 06, 2025 at 10:50:31AM +0100, Christoph Hellwig wrote:
> The t_magic field is only ever assigned to, but never read.  Remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

And it eliminates a 4-byte hole!

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 2 --
>  fs/xfs/xfs_trans.h | 1 -
>  2 files changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4cd25717c9d1..786fb659ee3f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -100,7 +100,6 @@ xfs_trans_dup(
>  	/*
>  	 * Initialize the new transaction structure.
>  	 */
> -	ntp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	ntp->t_mountp = tp->t_mountp;
>  	INIT_LIST_HEAD(&ntp->t_items);
>  	INIT_LIST_HEAD(&ntp->t_busy);
> @@ -275,7 +274,6 @@ xfs_trans_alloc(
>  	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
>  	       xfs_has_lazysbcount(mp));
>  
> -	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
>  	tp->t_mountp = mp;
>  	INIT_LIST_HEAD(&tp->t_items);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 71c2e82e4dad..2b366851e9a4 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -122,7 +122,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>   * This is the structure maintained for every active transaction.
>   */
>  typedef struct xfs_trans {
> -	unsigned int		t_magic;	/* magic number */
>  	unsigned int		t_log_res;	/* amt of log space resvd */
>  	unsigned int		t_log_count;	/* count for perm log res */
>  	unsigned int		t_blk_res;	/* # of blocks resvd */
> -- 
> 2.45.2
> 
> 
