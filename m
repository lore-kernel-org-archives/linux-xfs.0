Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272B155A5D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706545487; cv=none; b=WP3RZuRdSvXGJt/FzJbt8LwxCb6UBFXu24bXdT9eRSFZUIyURpWDP66ADNw+sJrHuzDYnUDPsXSazixuV+yMXl0T7iF/lRPzDa3wwivKmXNZKD1K/eAKnGJn4HaaYo9CuIUpUDOWzsr9HUZ5H2cqnIJ+ilCEGOpUajilRu578/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706545487; c=relaxed/simple;
	bh=RF+t/ug2aOYYQWYS86JZHdcPLDQcDKP8/QueqxLvlWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVK0/C4uloBOgy1rJwMyB4ksFFQ2hvEITcHPmxmqQ+gcSp7nym0jIPtXLCbPXZt2d0G3+fXCKjLWE06csGrqgu+BDklnDoeTaIUnfEWzJ1wH+YrBtqObAO8Q3jILAgq4AQR5j1tYa0La1BbDs2bbpBalPe0qEGcyo0pInH/79DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErSrsBq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErSrsBq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B0C433C7;
	Mon, 29 Jan 2024 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706545486;
	bh=RF+t/ug2aOYYQWYS86JZHdcPLDQcDKP8/QueqxLvlWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ErSrsBq+UEvOJ4YQtK1RHz3ZKlkQwkIP60gEojNdC0XRoGv768fNkG/R6exvcfYKY
	 sPrdacnEewSskxCuP5w0SzoIBXVVEyeisF98K3VV7tsDNizY5t/Eh/gI9qzuidNIk6
	 9oM65DCCYKRx5NLNbZTGHwajESqRkQseRvH/MSToLus22RWfizZed+HPlk+W+cxlZR
	 xRGgZpsnMqiJxa8WoQOQPSJKYwvjF2+2dQ1t9XDSP/sSltPCNr7tax3hv7ujGXfvKC
	 VHs02st7Id4vLwZJp1KzKqTFq/YrLyWItxbtuhkc8J4eGL5+8b6zrEnuKHSBbsTaYT
	 hs4Tf2IavK7bQ==
Date: Mon, 29 Jan 2024 08:24:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 06/20] shmem: export shmem_kernel_file_setup
Message-ID: <20240129162446.GF1371843@frogsfrogsfrogs>
References: <20240129143502.189370-1-hch@lst.de>
 <20240129143502.189370-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129143502.189370-7-hch@lst.de>

On Mon, Jan 29, 2024 at 03:34:48PM +0100, Christoph Hellwig wrote:
> XFS wants to use this for it's internal in-memory data structures and
> currently duplicates the functionality.  Export shmem_kernel_file_setup
> to allow XFS to switch over to using the proper kernel API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mm/shmem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index dae684cd3c99fb..e89fb5eccb0c0a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4856,6 +4856,7 @@ struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned lon
>  {
>  	return __shmem_file_setup(shm_mnt, name, size, flags, S_PRIVATE);
>  }
> +EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
>  
>  /**
>   * shmem_file_setup - get an unlinked file living in tmpfs
> -- 
> 2.39.2
> 
> 
