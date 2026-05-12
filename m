Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163A2E7631;
	Tue, 12 May 2026 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778602455; cv=none; b=GsWS4tlcfOTd6WmEf+SCRHYRo+MERQd706y4XZ8wFBJRdyKRmF1V9mXhyxpRvZg+Nv4y67IqB6v7EhEd1rvxaWgiV49KOv2QxoHvt2ZfQlmHzTaKOptd1UkDy5oovmKDYI00EWUJEH9bGBUMEtGu4NvzDQVwkv9F8G9i+kcQGSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778602455; c=relaxed/simple;
	bh=IUNQoj40BBpUNJf0ajtJqYtGemiYL8A1ke06SM7+b4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TT4CwthdPK2f4KCeKhXs0d6UfLQNQIAzw7+mmlHz7yfT7nJsW7j8pc/7NPj5HCR7n/19i2OP3Ct95L63un+mYIkctWOUtmumsus8+lKsdmVJpZJQeq3SjHjhj8A+CgQp0dhXgsZpGjg+ZFqRvVYOrEYxRW6KxlSBElYMajILoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/S/PcOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/S/PcOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646AEC2BCFA;
	Tue, 12 May 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778602455;
	bh=IUNQoj40BBpUNJf0ajtJqYtGemiYL8A1ke06SM7+b4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/S/PcOS1XPcZV7Syc+JlqArxkXZ/hbxBjwDT1oINHHwBvkhhEWP9INmRvwBy5uMs
	 IQ7LRTkDcpdEEKM0Tw08keNfDow4yaHa7b0CVm3jBd1tISNFLljNv2sMqAGoS/qtXU
	 kvv4bupqJjw57mXwLGv3YQYnlWf91aYSUfKamfSgWAYibwIdHaKI2hKtoE8SnMjl/r
	 yss2iKimG4E33ynm2qH/k2CFu5aRhuOAM/21vTLClYeYWVJ5nzDy2SveAFpZ27Z4QK
	 HnDMLSECA8B5Mln82mBvnzgxuWuoXQxgVvLQ2dQycDnG6am4VL4o8Rvgtxso9ns8vD
	 fQ/KjPYMec+yg==
Date: Tue, 12 May 2026 09:14:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
Message-ID: <20260512161414.GB9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>

On Tue, May 12, 2026 at 07:35:17AM +0200, Christoph Hellwig wrote:
> Always use si->max which is updated setup_swap_extents instead of copying

"...updated in setup_swap_extents..."

> into and out of maxpages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

But yes, it's much harder to track the data flows if we keep copying the
value in and out of local variables.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mm/swapfile.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..f7ebd97e28a3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3350,10 +3350,9 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
>  }
>  
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
> -				    union swap_header *swap_header,
> -				    unsigned long maxpages)
> +				    union swap_header *swap_header)
>  {
> -	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +	unsigned long nr_clusters = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
>  	struct swap_cluster_info *cluster_info;
>  	int err = -ENOMEM;
>  	unsigned long i;
> @@ -3395,7 +3394,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  		if (err)
>  			goto err;
>  	}
> -	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
> +	for (i = si->max; i < round_up(si->max, SWAPFILE_CLUSTER); i++) {
>  		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
>  		if (err)
>  			goto err;
> @@ -3425,7 +3424,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  	si->cluster_info = cluster_info;
>  	return 0;
>  err:
> -	free_swap_cluster_info(cluster_info, maxpages);
> +	free_swap_cluster_info(cluster_info, si->max);
>  	return err;
>  }
>  
> @@ -3440,7 +3439,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	union swap_header *swap_header;
>  	int nr_extents;
>  	sector_t span;
> -	unsigned long maxpages;
>  	struct folio *folio = NULL;
>  	struct inode *inode = NULL;
>  	bool inced_nr_rotate_swap = false;
> @@ -3512,14 +3510,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	}
>  	swap_header = kmap_local_folio(folio, 0);
>  
> -	maxpages = read_swap_header(si, swap_header, inode);
> -	if (unlikely(!maxpages)) {
> +	si->max = read_swap_header(si, swap_header, inode);
> +	if (unlikely(!si->max)) {
>  		error = -EINVAL;
>  		goto bad_swap_unlock_inode;
>  	}
>  
> -	si->max = maxpages;
> -	si->pages = maxpages - 1;
> +	si->pages = si->max - 1;
>  	nr_extents = setup_swap_extents(si, swap_file, &span);
>  	if (nr_extents < 0) {
>  		error = nr_extents;
> @@ -3531,14 +3528,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap_unlock_inode;
>  	}
>  
> -	maxpages = si->max;
> -
>  	/* Set up the swap cluster info */
> -	error = setup_swap_clusters_info(si, swap_header, maxpages);
> +	error = setup_swap_clusters_info(si, swap_header);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> -	error = swap_cgroup_swapon(si->type, maxpages);
> +	error = swap_cgroup_swapon(si->type, si->max);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> @@ -3546,7 +3541,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
>  	 * be above MAX_PAGE_ORDER incase of a large swap file.
>  	 */
> -	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
> +	si->zeromap = kvmalloc_array(BITS_TO_LONGS(si->max), sizeof(long),
>  				     GFP_KERNEL | __GFP_ZERO);
>  	if (!si->zeromap) {
>  		error = -ENOMEM;
> @@ -3597,7 +3592,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		}
>  	}
>  
> -	error = zswap_swapon(si->type, maxpages);
> +	error = zswap_swapon(si->type, si->max);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> -- 
> 2.53.0
> 
> 
