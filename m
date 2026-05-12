Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B1E3D79EF;
	Tue, 12 May 2026 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604189; cv=none; b=g0c3739c3jP05oKUXfIL72v6g0c2eKECBdlEJ2m7F4AGxZKxgb4eZilFmHvZ1nuQ1j2XYmGPNnzm1ubC/iPgSFCjfdIQMm0XMA07LZc/4bVdy+3DaCrgVJsxRNsPV9S4DkwYVUzlAwH1Yp4j3xABh5n9XJXdDdMft1RQsg904oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604189; c=relaxed/simple;
	bh=PBZrTiN4pAoVDQXCJJ+alWgO2xkZJqjotuEKJ6A2uec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTDCkCTVC3i2MGwkow19dY4IlzgSWYY37xbZE2KoqVtofYlv6tGTasDNGyqt8WCxBtHDq6VgGZ+7OwvS6elqulsuBTFpb04V5LUzSFkuaqpwjuO2SEZ/5A2VaZph2oOB2r/mRFmD6FY+ZeQ/Zjr14AAzew0Ie2xIaCbT8rOH7wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhDaw5al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhDaw5al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1B5C2BCF6;
	Tue, 12 May 2026 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604188;
	bh=PBZrTiN4pAoVDQXCJJ+alWgO2xkZJqjotuEKJ6A2uec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LhDaw5alyksUgGWr7B+0tNRNRMhWix5nRIyBwa98tq/kd6I8j+shUG6aVX4PjpvCV
	 T0UPqngSxtLEFupErYJkxP6xFRAzIkRfQwy84MuvBPY0FvI7QEYc94CPrTP2bmwrXX
	 d/otVY/0Kkw1xfrrVmsd2Er2k2zyg56OwnHH3xBSjgLwQu0/pnFnSdhe5iyEuqvWiJ
	 8Q8dB1D3YHgUfms3a7YcngYBDEhhHjo5vNSt2zuw5VNg0vWPLMGb8+TM2WzzgGb37n
	 luePu92paJZ4t8fhc+C51bQBP0YyCtdfc0OkYS94Y5yjSIvG0Ls6lxWYIA4uojhZML
	 lBXUfTYggysNQ==
Date: Tue, 12 May 2026 09:43:08 -0700
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
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
Message-ID: <20260512164308.GF9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-6-hch@lst.de>

On Tue, May 12, 2026 at 07:35:21AM +0200, Christoph Hellwig wrote:
> Reflow setup_swap_extents so that the flag checking is not conditional on
> a swap_activate method.  This is currently a no-op because the swapoff
> code still checks the presence of a swap_deactivate method, but it
> simplifies adding a new check, and also makes the SWP_ACTIVATED flag
> more consistent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/swapfile.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 651c1b59ff9f..1b7fc03612f4 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2783,25 +2783,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  {
>  	struct address_space *mapping = swap_file->f_mapping;
>  	struct inode *inode = mapping->host;
> -	int ret;
> +	int ret, error = 0;

/me wonders why not reuse ret instead of declaring a new variable?

--D

>  
>  	if (S_ISBLK(inode->i_mode))
>  		return add_swap_extent(sis, sis->max, 0);
>  
> -	if (swap_file->f_op->swap_activate) {
> +	if (swap_file->f_op->swap_activate)
>  		ret = swap_file->f_op->swap_activate(swap_file, sis);
> -		if (ret < 0)
> -			return ret;
> -		sis->flags |= SWP_ACTIVATED;
> -		if ((sis->flags & SWP_FS_OPS) &&
> -		    sio_pool_init() != 0) {
> -			destroy_swap_extents(sis, swap_file);
> -			return -ENOMEM;
> -		}
> +	else
> +		ret = generic_swap_activate(swap_file, sis);
> +	if (ret < 0)
>  		return ret;
> -	}
>  
> -	return generic_swap_activate(swap_file, sis);
> +	sis->flags |= SWP_ACTIVATED;
> +	if (sis->flags & SWP_FS_OPS)
> +		error = sio_pool_init();
> +	if (error)
> +		destroy_swap_extents(sis, swap_file);
> +	return error;
>  }
>  
>  static void _enable_swap_info(struct swap_info_struct *si)
> -- 
> 2.53.0
> 
> 
