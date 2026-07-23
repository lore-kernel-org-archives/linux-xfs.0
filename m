Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30F53DA7E6;
	Thu, 23 Jul 2026 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840538; cv=none; b=e//WaxMLOPgGidUjw3mf6nLkdI9Pl2Ghr0z4WxxDjud+EUUVXstc87oyxJKKD6bO6hNQnz/cUe6c6h9XrEO1FNabajSbSncH8OVQ+5iM2jJ5c/XbqvHGhoPFABrQpqrj7ee2TTNhKuETz9LZQ9y+OvYBnmMb28NpLzj+Zm98/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840538; c=relaxed/simple;
	bh=w22EBJ1AOSUAHTZTiJ9fGMCV+vheubkDBaaV6m632wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soyTeRBeFpaM3mMJXZms966hT6yA/XHZ3uX7uZto79hpkVa0I7sQqZUw/Xwm0auicKoGJ2dEYap0/BuVijxKRAAa+0XLVQDEm3oO8kMiqjqAU4FJ04+dDUf/aE3gKHDtxHYh5DEqz9LQhgUroJ59ZzWKOFlQifxoLanxNc4x8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAJ2+BQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAJ2+BQ/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F02F1F000E9;
	Thu, 23 Jul 2026 21:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840536;
	bh=lhkx7vhxSzmmO8WYBA3ZmOB2/x4KrzqjtB8QGTJ19q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TAJ2+BQ/G0Ur98TS1SHxbQSW5+fC5T+4hCN0zazfomLfC68j/aPuSAUzVFpZX7RCX
	 H1CN2x7mBfRBmJgq5QQSfueAEjgtGHpP8Tn7N3SEEsCRXO/aVmjdqTUm1rbu3mtQqk
	 h9ys7/72JuLB+qnd3KIW1LzqeljEzYdyQeepBhTo35L3kLBzDzzBsJBPftolGLeoCt
	 erQX0Wp5hXjhuXv868IPIzbzpSamUmgEnKTCQDTfldB/xVgA9zoy5n8Rexvg2ZEWFZ
	 4fPTYTE+Ikbm4TvCDhytEh+2+bUcSN8cK1c2JE8/ndX3ORhGwTlSxqJNRL91AXKUzF
	 GC3KnWZ0YYv8w==
Date: Thu, 23 Jul 2026 14:02:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/22] iomap,xfs: move integrity verification to the file
 system
Message-ID: <20260723210216.GI2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-20-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:44PM +0200, Christoph Hellwig wrote:
> Integrity support in file systems already requires file system-specific
> completion handling because it must be run in process context.
> 
> Move the actual verification to the file system so that it can better
> handle errors in file system specific ways, and to support lazy bounce
> buffering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sounds good to me.  I gather the idea here is that direct reads go
straight into the user's buffer, and if they're evil and mess with the
buffer contents during the read to make the PI verification fail, we can
then retry the read with a bounce buffer out of spite for userspace?

If so, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c      | 8 ++------
>  fs/xfs/xfs_ioend.c    | 3 +++
>  include/linux/iomap.h | 1 +
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 438be92e131b..b1078f7c08c6 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -308,12 +308,13 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  }
>  EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
>  
> -static int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
> +int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
>  {
>  	struct bvec_iter data_iter = BVEC_ITER_IOEND(ioend);
>  
>  	return fs_bio_integrity_verify(&ioend->io_bio, &data_iter);
>  }
> +EXPORT_SYMBOL_GPL(iomap_ioend_integrity_verify);
>  
>  static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  {
> @@ -330,11 +331,6 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  	if (!atomic_dec_and_test(&ioend->io_remaining))
>  		return 0;
>  
> -	if (!ioend->io_error &&
> -	    bio_integrity(&ioend->io_bio) &&
> -	    bio_op(&ioend->io_bio) == REQ_OP_READ)
> -		ioend->io_error = iomap_ioend_integrity_verify(ioend);
> -
>  	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
>  		return iomap_finish_ioend_direct(ioend);
>  	if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 37a3ae8066e9..a095cf217863 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -25,6 +25,9 @@ xfs_end_io_read(
>  	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
>  	int			error = blk_status_to_errno(bio->bi_status);
>  
> +	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY))
> +		error = iomap_ioend_integrity_verify(ioend);
> +
>  	iomap_finish_ioends(ioend, error);
>  }
>  
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 1916a4f28002..f9e2fce21be0 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -518,6 +518,7 @@ void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
>  void iomap_ioend_try_merge(struct iomap_ioend *ioend,
>  		struct list_head *more_ioends);
>  void iomap_sort_ioends(struct list_head *ioend_list);
> +int iomap_ioend_integrity_verify(struct iomap_ioend *ioend);
>  ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  		loff_t pos, loff_t end_pos, unsigned int dirty_len);
>  int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error);
> -- 
> 2.53.0
> 
> 
