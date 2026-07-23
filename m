Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1611438422F;
	Thu, 23 Jul 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825361; cv=none; b=jDK3Ne8N6jyk48qgMlxC05ZAcp8tA1rRvmLVotkpSTj/LDXyQMZ/c17iwCpF1+ls0XpbJDIrILcqnYqtnVy4+X8jfwB6+UcCcD05pE3BXGqLFHGqKUJSHiY/cD0PZUpEW2ryfRPzlpsYbdTHbwEZgD/jvJD5o74yEjs4smXTzb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825361; c=relaxed/simple;
	bh=Um+FZXUulB+pH/DDTCHz09+kqXzDBmVQGi0IHZYBaCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ap8wxp02Ef6muVgPOHolJ40yUe2lnSOeT5sEpu1aA8Vlg6GnVndrVdaAcb0XdpoRqH+9ZQ9nos/MzJd1TNOsvGhuwGO0oSG94s3rtdYvyZhkb4oKROQu69ux4TW6K1JVSrKNOYnlW7pXM9Sl3137zVmgBj8kQM8nL/A40Z2x/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E5E121F000E9;
	Thu, 23 Jul 2026 16:49:19 +0000 (UTC)
Date: Thu, 23 Jul 2026 09:49:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/22] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260723164907.GA2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-2-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:26PM +0200, Christoph Hellwig wrote:
> iomap_split_ioend can split bios that already come from
> iomap_ioend_bioset and thus deadlock when the bioset is exhausted.
> 
> Add a separate bio_set to avoid this deadlock.
> 
> Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 0565328764c1..2ec755a89228 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -13,6 +13,7 @@
>  
>  struct bio_set iomap_ioend_bioset;
>  EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
> +static struct bio_set iomap_ioend_split_bioset;
>  
>  struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  		struct bio *bio, loff_t file_offset, u16 ioend_flags)
> @@ -486,7 +487,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
>  	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
>  			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
>  
> -	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
> +	split = bio_split(bio, sector_offset, GFP_NOFS,
> +			&iomap_ioend_split_bioset);
>  	if (IS_ERR(split))
>  		return ERR_CAST(split);
>  	split->bi_private = bio->bi_private;
> @@ -509,8 +511,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
>  
>  static int __init iomap_ioend_init(void)
>  {
> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> +	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
> +	int error;
> +
> +	error = bioset_init(&iomap_ioend_bioset, nr_mempool_entries,
>  			   offsetof(struct iomap_ioend, io_bio),
>  			   BIOSET_NEED_BVECS);
> +	if (error)
> +		return error;
> +	error = bioset_init(&iomap_ioend_split_bioset, nr_mempool_entries,
> +			   offsetof(struct iomap_ioend, io_bio),
> +			   BIOSET_NEED_BVECS);
> +	if (error)
> +		goto out_exit_ioend_bioset;
> +	return 0;
> +
> +out_exit_ioend_bioset:
> +	bioset_exit(&iomap_ioend_bioset);
> +	return error;
>  }
>  fs_initcall(iomap_ioend_init);
> -- 
> 2.53.0
> 
> 
