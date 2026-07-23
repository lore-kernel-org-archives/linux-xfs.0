Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538BD299943;
	Thu, 23 Jul 2026 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840105; cv=none; b=gCZPQkljC62bw+bnbYA6HgqctYiUuAn9FP9BId0nerJpjRm5eAuEDnUSVtLWHEC7lZ84u6dwXEVLpZQxgUz86qZkrxy09WPAITfISIJZG/O7OD63JaEmG+0EzF6OETv7Pp2l7PlyXQPm6N19T5AX7Tkl3WJZK5Ofvj+6sPjf25M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840105; c=relaxed/simple;
	bh=nrqv/9wspY7rrv+TYpjWs+1DGU/gyXGa09D6EzHFnfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5SKL2rqsdFC7NWvfMemMrv2fvTbncIy8xwhch7mHaj5pkBhCN4WoiteNp5YKjsg2o//15MVd3lZyQ+mDMdESgdGQKSmjetwAZNJZfkr+9VQTAc2GmF+TZp/pPF8+MzLRGfvXK6iQ7gTf4k1c6hAcxfTlImOrJs/PqH5AmBNJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1YFv9+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1YFv9+u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2A3171F000E9;
	Thu, 23 Jul 2026 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840104;
	bh=eJCXm0RXIA1IkKWofjM12KYxpFaaqUTF3vxePz7GJAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X1YFv9+uN8EXK2y/2ZyTDQ8SW5RjvHVY6+mYRag4h0dw8KtcE2jKcAiyOrZUDHrvH
	 QTI4eCbEDGN2Epo/MvWCo9hMqnHcSR2OhjK5hamvgw95zSeeQefNZXVIGpUAMWISiS
	 +mo0ygn9DttmzeOwWg1EgRz0KKdt1yLEaGw7TawKcbPTzQytnf6FmSXkUxqqiAnfZw
	 HT4/x4SCSI77z053nCYQpPw9P5aQsrrVNaK4TEWm1biJJF+cDtuR6QjITFVSG4VS31
	 oZi+6dA01k8fgD0xRymU7a7raO3ULdS+f0oCql1oyp/06eJfqVmBp56qY+MYrPNbod
	 uDFqAIoBeGNCg==
Date: Thu, 23 Jul 2026 13:55:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/22] iomap,xfs: move T10 PI handling for direct I/O
 into ->submit_io
Message-ID: <20260723205503.GE2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-16-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:40PM +0200, Christoph Hellwig wrote:
> Currently the buffered I/O code defers PI handling into the submit
> handlers, while direct I/O does it in common code.  Move it all
> into the file system callbacks or their generic implementations
> to be consistent, and to allow file systems to shared helpers
> for submission of buffered and direct bios.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think I like this cleanup, the bio integrity setup code was scattered
around a lot of places.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 22 ++++++++++++----------
>  fs/xfs/xfs_file.c    | 13 ++++++++++---
>  2 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index e2cd5f92babe..8d476f40a3bb 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -75,10 +75,19 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>  
>  	if (dio->dops && dio->dops->submit_io) {
>  		dio->dops->submit_io(iter, bio, pos);
> -	} else {
> -		WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_ANON_WRITE);
> -		blk_crypto_submit_bio(bio);
> +		return;
> +	}
> +
> +	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_ANON_WRITE);
> +
> +	if (iter->iomap.flags & IOMAP_F_INTEGRITY) {
> +		if (dio->flags & IOMAP_DIO_WRITE)
> +			fs_bio_integrity_generate(bio);
> +		else
> +			fs_bio_integrity_alloc(bio);
>  	}
> +
> +	blk_crypto_submit_bio(bio);
>  }
>  
>  static inline enum fserror_type iomap_dio_err_type(const struct iomap_dio *dio)
> @@ -372,13 +381,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  		goto out_bio_release_pages;
>  	}
>  
> -	if (iter->iomap.flags & IOMAP_F_INTEGRITY) {
> -		if (dio->flags & IOMAP_DIO_WRITE)
> -			fs_bio_integrity_generate(bio);
> -		else
> -			fs_bio_integrity_alloc(bio);
> -	}
> -
>  	if (dio->flags & IOMAP_DIO_WRITE)
>  		task_io_account_write(ret);
>  	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e94a26f32e65..80dd278e023f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -37,6 +37,7 @@
>  #include <linux/fadvise.h>
>  #include <linux/mount.h>
>  #include <linux/filelock.h>
> +#include <linux/bio-integrity.h>
>  
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
> @@ -235,8 +236,12 @@ xfs_dio_read_bounce_submit_io(
>  	struct bio		*bio,
>  	loff_t			file_offset)
>  {
> -	iomap_init_ioend(iter->inode, bio, file_offset,
> -		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> +	struct iomap_ioend	*ioend;
> +
> +	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
> +			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_alloc(bio);
>  	bio->bi_end_io = xfs_end_bio;
>  	submit_bio(bio);
>  }
> @@ -725,7 +730,9 @@ xfs_dio_zoned_submit_io(
>  
>  	bio->bi_end_io = xfs_end_bio;
>  	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
> -		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> +			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_generate(bio);
>  	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
>  }
>  
> -- 
> 2.53.0
> 
> 
