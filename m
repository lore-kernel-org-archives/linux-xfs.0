Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40C415AA
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705618249; cv=none; b=CrmlZFbFmd9PImCe1j+n6jFgsR2Ve9YLxm3Fn1hi4mUag71sU+hN/3XaHReZJ/ePyHJ2xCveEVPvMIrNumgxm3cnPNn+AxZJFuB877IihCvrMUoPHB6xCY/CmpLGqcbBATyqN5zXH2WApxSP4emasQGNQjV4OXhBR6SvyF8tXoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705618249; c=relaxed/simple;
	bh=64Zv/6JApHxo1U7/CRMWb4wdog5aYP4w0VkShfc+Feg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXzx5fqu9QyLbi7eT5NvZotj6VuYqOUAbDjGG4ZqEOOCBhWvEbKfHHx/2XNuN/daO5BzHfuCyaMR3R/YbyECKfJixrwGSNDPAzVDfV7P0wzLpKM+IKbu/1DipZOEUZKDVD6Ud4Ga2kYcvZj2m6voBEsITI9Gd023bVVnogYPIsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQMN+ob5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQMN+ob5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A46C433C7;
	Thu, 18 Jan 2024 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705618249;
	bh=64Zv/6JApHxo1U7/CRMWb4wdog5aYP4w0VkShfc+Feg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQMN+ob5xe9P1ZSJIwD7QqDxIE1H1yt6ZsncRRVKHdfuM9nBQSzXmoeHIl0Tmj+0D
	 xb5S87MV0/nRIM0U+l6hHqwdUJtHWFu9j2xA7IoH5n0Cmgj+FcK0W6TIRZFdYALXpx
	 98/NXcyLe7/FJpGGfj6m3zRWWk0s7xEtr72EmwSfXUO5dagFs6R5uzvQeHAtYmO9/p
	 GHqKFNl9sNbX1DKwTQSD7+SU0okQfbiP8XOtpzUCQsZ9b//p5+I/Sg8SIhgSLRVcWS
	 ztyqYIy6wLRa0p1VEil0CVROAPp1rgB1ZIdzOGjUCAlvdpwMZejo48TiaQtyd2+EUx
	 k5TVrctof6cfQ==
Date: Thu, 18 Jan 2024 14:50:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/12] xfs: move kmem_to_page()
Message-ID: <20240118225048.GF674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-4-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move it to the general xfs linux wrapper header file so we can
> prepare to remove kmem.h
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/kmem.h      | 11 -----------
>  fs/xfs/xfs_linux.h | 11 +++++++++++
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 1343f1a6f99b..48e43f29f2a0 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -20,15 +20,4 @@ static inline void  kmem_free(const void *ptr)
>  	kvfree(ptr);
>  }
>  
> -/*
> - * Zone interfaces
> - */
> -static inline struct page *
> -kmem_to_page(void *addr)
> -{
> -	if (is_vmalloc_addr(addr))
> -		return vmalloc_to_page(addr);
> -	return virt_to_page(addr);
> -}
> -
>  #endif /* __XFS_SUPPORT_KMEM_H__ */
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index d7873e0360f0..666618b463c9 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -269,4 +269,15 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  # define PTR_FMT "%p"
>  #endif
>  
> +/*
> + * Helper for IO routines to grab backing pages from allocated kernel memory.
> + */
> +static inline struct page *
> +kmem_to_page(void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		return vmalloc_to_page(addr);
> +	return virt_to_page(addr);
> +}
> +
>  #endif /* __XFS_LINUX__ */
> -- 
> 2.43.0
> 
> 
