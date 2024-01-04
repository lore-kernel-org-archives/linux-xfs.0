Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131191847
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGSwdFTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B539C433C8;
	Thu,  4 Jan 2024 00:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704327718;
	bh=sInAZji0FgjBKb4Yg/f4gvF7/RXfJasa60oS1R36FQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pGSwdFTXhqNtFGWhMvAYB5ce6FKfmkuTGZphlTfkekv7jzaVqQl4uXBrWOWxunn9W
	 9AsRBJJqAXcDicDuOmDleocDUkButJjBfYvvHKAJq9f1uF8/Fg+IvuSu5Ty0pkWSWF
	 vMqTOX7Q/An/nwCTCMiQWNkxsnEzLvIKR3t0rWEcfdCCOvpjmMUxkEvhqZHDCw2Lf4
	 JHkyU1voQDa/hcjglEVVCHucGfMBefvHa4FYxGzXgHx2rd1ewmKanrqtbqysOS1BWq
	 EPFfu5qHX5XnwB26ddaf9UmjMxxuTVXV3iAEfCtQJFZ0jKLCLyBz5AogSqzwLwj3SF
	 q4OO0SJyHqzmQ==
Date: Wed, 3 Jan 2024 16:21:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/15] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <20240104002158.GJ361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-4-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:14AM +0000, Christoph Hellwig wrote:
> Add a blurb that simply dirtying the folio will persist data for in-kernel
> shmem files.  This is what most of the callers already do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/shmem.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 328eb3dbea9f1c..235fac6dc53a0b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2129,6 +2129,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   *
>   * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
>   * and no folio was found at @index, or an ERR_PTR() otherwise.
> + *
> + * If the caller modifies data in the returned folio, it must call
> + * folio_mark_dirty() on the locked folio before dropping the reference to
> + * ensure the folio is not reclaimed.  Unlike for normal file systems there is
> + * no need to reserve space for users of shmem_*file_setup().

/me notes that this matches how /I/ think this is supposed to work, but
I think someone more familiar with tmpfs should review this...

--D

>   */
>  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
>  		enum sgp_type sgp)
> -- 
> 2.39.2
> 
> 
