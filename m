Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB14360ED7;
	Tue, 12 May 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604353; cv=none; b=BUYSzBdyZ+SGr4HiFKfdBi9EupomzzTx32lPbaWR4idR32zG7wkBltrc5h/URLw8aMAsBR9qLBcyAzFXEy/pQqgCyw5DMlsiQxkBmVjZk8ditZTlQGcfUmV+ngMzEIiOFZ3s4zSlySCyyrOpHexmJWTP5N/Tr+6N7ex47LSR7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604353; c=relaxed/simple;
	bh=AcAe4/elaHVR4qdaARIi+sqWloNOcTI2K7pOyCzPQJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3oZA1eXTnQtBd5gaGCEdIMCW5H1K3ML9t6Bs1t7GyQtoVWBkqF97hcPQhDwRtPBnnW0AiYZeowHaspjQWL0jSw2rPgi0xcOeIyZR6OODN0B7H1FNqzviDfp8fKMxUHG3B2CjyCNYetNg8SbJAr7gf5FzbVjXutQFtAE1rHlJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTl8SWVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTl8SWVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50240C2BCB0;
	Tue, 12 May 2026 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604353;
	bh=AcAe4/elaHVR4qdaARIi+sqWloNOcTI2K7pOyCzPQJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KTl8SWVyQT9eR0KJRerRA1Am+3qK8dO9BevMUKnMoH23CRP9mM5f3Wu8yquPkjamu
	 iDhJafpxFURM/nRV7YIcdF2vJ6mMlLYTcDMvY4jbNiIkyUsF9ww8yELMptMTkRbEh4
	 oMnRfp5DdCOcFHf+dy1yNxg//l2bSr3pQHtixqa4AlGaNF4Cxj1528N8RUtvReqe3h
	 SBiA5b1rqJP4iqw7iclgX7NmxGE5ZBDhsuApEownA7rjZzSFO99rRbfwmVruqi3YO8
	 sRA83twil/gSQfzUvwWP5wcTf/c5w5ehJsVY7Iboby7AQBhvuZnkU7BEEXnZxHnPWb
	 xain+gAgQ2EFA==
Date: Tue, 12 May 2026 09:45:52 -0700
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
Subject: Re: [PATCH 07/12] swap,block: limit swap file size to device size
Message-ID: <20260512164552.GH9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-8-hch@lst.de>

On Tue, May 12, 2026 at 07:35:23AM +0200, Christoph Hellwig wrote:
> Don't blindly pass the value from the swap header to swap_add_extent,
> but instead the device size rounded down to page granularity.  This
> activated the sanity checking in the core code that catches a too large
> value in the swap header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/fops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 453141801684..067e46299666 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -951,7 +951,9 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
>  
>  static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
>  {
> -	return add_swap_extent(sis, sis->max, 0);
> +	loff_t isize = i_size_read(bdev_file_inode(file));

Good catch!

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), 0);
>  }
>  
>  const struct file_operations def_blk_fops = {
> -- 
> 2.53.0
> 
> 
