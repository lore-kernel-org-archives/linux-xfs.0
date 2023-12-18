Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC4471470
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mT4kUW2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35833C433C8;
	Mon, 18 Dec 2023 22:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702938271;
	bh=MCYLdypgWT4UcCqG78B6YykDSRIr7I8RhdmKUJ0Sqwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mT4kUW2sIG+3OCdobdNWhHlE4IHYJfBLeX50fbVwbu2rrkWbuoigIRBq/xdz1+H3j
	 YixtIo0467xWKPa3n3QqaH6N3vuvmQLNAldnmuq1/GQ7wTVYHgtG/XQW8CwBx9QjiR
	 huJz5+swhUmCUBkNM4AheCJMXMlWkOHB/whGgQ6M49Cxett/jxNrbtPgmjHjPJqZOg
	 VzKsDvRYD+Lict8M6AVUG1BhNtXtESs/wxk7PHgCY2OuPmuLoOjls8OBwXySKCg7P6
	 PL3D5oO/DOpkWQZrKfSz6crS9TYkkk0wQm4sW4IukPv72u9gyLf0Tl2UNlfrgeARA6
	 mDQVZbS0vVLbw==
Date: Mon, 18 Dec 2023 14:24:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs: rename xfs_bmap_rtalloc to
 xfs_rtallocate_extent
Message-ID: <20231218222430.GW361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218045738.711465-23-hch@lst.de>

On Mon, Dec 18, 2023 at 05:57:38AM +0100, Christoph Hellwig wrote:
> Now that the xfs_rtallocate_extent name has been freed, use it for what
> so far is xfs_bmap_rtalloc as the name is a lot better fitting.
> 
> Also drop the !CONFIG_XFS_RT stub as the compiler will eliminate the
> call for that case given that XFS_IS_REALTIME_INODE is hard wire to
> return 0 in the !CONFIG_XFS_RT case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  2 +-
>  fs/xfs/xfs_bmap_util.h   | 15 +--------------
>  fs/xfs/xfs_rtalloc.c     |  2 +-
>  3 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 46a9b22a3733e3..245f7045da15c4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4091,7 +4091,7 @@ xfs_bmap_alloc_userdata(
>  		}
>  
>  		if (XFS_IS_REALTIME_INODE(bma->ip))
> -			return xfs_bmap_rtalloc(bma);
> +			return xfs_rtallocate_extent(bma);
>  	}
>  
>  	if (unlikely(XFS_TEST_ERROR(false, mp,
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 77ecbb753ef207..233bbbd2a4676d 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -16,20 +16,7 @@ struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_bmalloca;
>  
> -#ifdef CONFIG_XFS_RT
> -int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
> -#else /* !CONFIG_XFS_RT */
> -/*
> - * Attempts to allocate RT extents when RT is disable indicates corruption and
> - * should trigger a shutdown.
> - */
> -static inline int
> -xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
> -{
> -	return -EFSCORRUPTED;
> -}
> -#endif /* CONFIG_XFS_RT */
> -
> +int	xfs_rtallocate_extent(struct xfs_bmalloca *ap);
>  int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
>  		xfs_off_t start_byte, xfs_off_t end_byte);
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4b2de22bdd70cc..6344e499af8e27 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1312,7 +1312,7 @@ xfs_rtalloc_align_minmax(
>  }
>  
>  int
> -xfs_bmap_rtalloc(
> +xfs_rtallocate_extent(
>  	struct xfs_bmalloca	*ap)

Hmm.  I'm still not sure I like the name here -- we're doing an rt
allocation for a bmap allocation args structure.

xfs_rtalloc_bmap?

(Or just drop this one, I've lost my will to fight over naming.)

--D

>  {
>  	struct xfs_mount	*mp = ap->ip->i_mount;
> -- 
> 2.39.2
> 
> 
