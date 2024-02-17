Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817FD1CD15
	for <linux-xfs@vger.kernel.org>; Sat, 17 Feb 2024 07:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708156500; cv=none; b=Bu95eUR+zyjp0B2IWntxtpZGz4MhV38BMqXXC9WvdojknCEmPQJo6RxsgSbMeh+yxwCbJG3kemvbybvO9KL7T0XOVb3C+uY/yBeSywQfAG+A1aVLLeawxP2A9vuUf/XfzKwCajXP33Oqceyr/a2acAIfsaGvBJ5M3xnX61MBC2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708156500; c=relaxed/simple;
	bh=W4Yl+QOQcGr5pB+8KMomO4gKDZSYGb8I52H5j0OxohE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pleiPmohkIs6jFpm25qd+E3pJgm7L5utaXnu5Rjlx8f/Y6a6DURfKs2l1HuBTxoip/Gy1zUa9pDQ/gKEyaj0zmZ+Kn9SZoftIH+zjchoo9w2Rh8SudjXLoh+2KN6YSFG1Sp3SZnpfhk+tBOD2rzO/0Io/PHdtRowzCthogxlRvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKN/L6QO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKN/L6QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB84C433C7;
	Sat, 17 Feb 2024 07:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708156500;
	bh=W4Yl+QOQcGr5pB+8KMomO4gKDZSYGb8I52H5j0OxohE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qKN/L6QOi2L1mJqVJ2RqL7djMGQXJcdoCTY8NjeL8dgK2vRf4JveNwa4laKRyhm2z
	 TZBErE7QuoK2oV4xJvY6QOjcPmeka1nRKQqxkQbP0XW0PNaiXa76iIDw3wgJTy0Xg/
	 CAYfB9xpeqbxiHf/Tmi48NIFE2tuB0ibeckn5lBUHTYkAGYu+inzJ0ZCb/or3bwbYq
	 UYfNARyCAW3nj34AGTnXyCbXpLDa/8mEDA6uuKumlWK+ix2J3NXbJ9DtXZ8I6d75YM
	 hr2EI0wwXn8e51RemXOPs5ismEm+IM9PDfbmRKPQyF1ZOIPf6KTniqE8nGTH0/TcEc
	 7HzeW69UMEHbQ==
Date: Sat, 17 Feb 2024 08:54:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use kvfree for buf in xfs_ioc_getbmap
Message-ID: <jdmhruuflukp5osmux43e4geuxtpzbqgbn4mtx54dzfu7bz46x@g6ltam3sc55e>
References: <1xetTiweC9oejErvoM_w05FWmWBZB1r5p73djCWdW5f8AlRpX9EA8V82PXttdBvZ-n3qCzgDBv6S17-Nt-3ASg==@protonmail.internalid>
 <20240216170230.2468445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216170230.2468445-1-hch@lst.de>

On Fri, Feb 16, 2024 at 06:02:30PM +0100, Christoph Hellwig wrote:
> Without this the kernel crashes in kfree for files with a sufficiently
> large number of extents.
> 
> Fixes: d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7eeebcb6b9250b..7c35d764409720 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1506,7 +1506,7 @@ xfs_ioc_getbmap(
> 
>  	error = 0;
>  out_free_buf:
> -	kfree(buf);
> +	kvfree(buf);
>  	return error;
>  }
> 
> --
> 2.39.2
> 
> 
