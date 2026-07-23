Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D1F3264FF;
	Thu, 23 Jul 2026 20:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840038; cv=none; b=IkKSdjJFjVJFgkqP+lhY6olIMlMXRFi3Jxv+TXRKtmeHNu6Qxq0HW+hoqL58VseeUjqMqlwEcUMdILf1YwzIP6lQ+uOATxYYJI49c7O/tjDooR1yIIwiXZtDqeAIKx3HgRYaY0r6EQYgANf/KmfUX4FbRf5eJHiheeu6VmSL+LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840038; c=relaxed/simple;
	bh=R2v5//vJbgLLcvWjFSpuJTqInLdiZ2FML/Cfk2q7uHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZ0uQuod4pAlbKtaNsyWaXLxyXD8mswGZlp95c8O6pqGuQSPaDvbwR7gO08z7+BzUhqbe39ytuuAwSJ8u06vu42Dygm/Mw7M09hzpP24GLbAa1QJj6pZvWAK1hohoKNdFLkJKHNUqeB0kfzxppS6dWY26H8W2U4z/y6WfnLWchI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiFKCRWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiFKCRWR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0989D1F000E9;
	Thu, 23 Jul 2026 20:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840037;
	bh=rx4ATTd1PawPoII6FZeENYlG7JsvpZmRl/re4Og0+Ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KiFKCRWR1lW86iXkOqM7fbZgcpVxPC4Hma6iG79Viqu/FfaKe9Tf3ZXchWelxi6rS
	 T2s9i4z+hYW5YaOW9KNwQfyvBu/V5AwHsDvPuMSJbYJdYFU3PmL2xDlvsP5Xu9y2QC
	 vvKhflOdXMJkTb9UG+ifDaY43vgrwBynuXqMoud384xJYakF5hhqrrLyT7A83HgoWv
	 Rmmj+yMlHdW7K5O5TlZUoJLxBxscarUzMu6V05r7QsAT9KJLivNerDCB5C6o+JbkFV
	 QKHFg+jvhQ8+8ozDmYgyh7NZksP9Wje8xLFikNnOXCv0ZjdebzIIFJji2IipUloWrm
	 ErDBbScLtcdfQ==
Date: Thu, 23 Jul 2026 13:53:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/22] iomap: add a IOMAP_IOEND_INTEGRITY flag
Message-ID: <20260723205356.GD2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-15-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:39PM +0200, Christoph Hellwig wrote:
> This will make it easier to share code for the various submit callback
> provided by the file system to iomap.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This also looks pretty straightforward, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c      |  2 +-
>  fs/xfs/xfs_aops.c     |  3 ++-
>  fs/xfs/xfs_file.c     |  5 +++--
>  include/linux/iomap.h | 11 ++++++++++-
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index b1bca36de430..438be92e131b 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -150,7 +150,7 @@ int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error)
>  		return error;
>  	}
>  
> -	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
>  		fs_bio_integrity_generate(&ioend->io_bio);
>  	submit_bio(&ioend->io_bio);
>  	return 0;
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 51293b6f331f..b95d74e40b06 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -763,7 +763,8 @@ xfs_bio_submit_read(
>  	struct bio			*bio = ctx->read_ctx;
>  
>  	/* defer read completions to the ioend workqueue */
> -	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> +	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
> +		iomap_ioend_flags(&iter->iomap));
>  	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
>  }
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..e94a26f32e65 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -235,7 +235,8 @@ xfs_dio_read_bounce_submit_io(
>  	struct bio		*bio,
>  	loff_t			file_offset)
>  {
> -	iomap_init_ioend(iter->inode, bio, file_offset, IOMAP_IOEND_DIRECT);
> +	iomap_init_ioend(iter->inode, bio, file_offset,
> +		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
>  	bio->bi_end_io = xfs_end_bio;
>  	submit_bio(bio);
>  }
> @@ -724,7 +725,7 @@ xfs_dio_zoned_submit_io(
>  
>  	bio->bi_end_io = xfs_end_bio;
>  	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
> -			IOMAP_IOEND_DIRECT);
> +		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
>  	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
>  }
>  
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 2541ebfabca0..1916a4f28002 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -406,6 +406,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
>  #define IOMAP_IOEND_DIRECT		(1U << 3)
>  /* is DONTCACHE I/O */
>  #define IOMAP_IOEND_DONTCACHE		(1U << 4)
> +/* generate integrity (PI) information */
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +#define IOMAP_IOEND_INTEGRITY		(1U << 5)
> +#else
> +#define IOMAP_IOEND_INTEGRITY		0
> +#endif /* CONFIG_BLK_DEV_INTEGRITY */
>  
>  /*
>   * Flags that if set on either ioend prevent the merge of two ioends.
> @@ -413,7 +419,7 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
>   */
>  #define IOMAP_IOEND_NOMERGE_FLAGS \
>  	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
> -	 IOMAP_IOEND_DONTCACHE)
> +	 IOMAP_IOEND_DONTCACHE | IOMAP_IOEND_INTEGRITY)
>  
>  /* ioend flags directly implied by iomap flags */
>  static inline u16 iomap_ioend_flags(const struct iomap *iomap)
> @@ -424,6 +430,9 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
>  		flags |= IOMAP_IOEND_UNWRITTEN;
>  	if (iomap->flags & IOMAP_F_SHARED)
>  		flags |= IOMAP_IOEND_SHARED;
> +	if (iomap->flags & IOMAP_F_INTEGRITY)
> +		flags |= IOMAP_IOEND_INTEGRITY;
> +
>  	return flags;
>  }
>  
> -- 
> 2.53.0
> 
> 
