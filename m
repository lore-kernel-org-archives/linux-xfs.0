Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003834D4D6;
	Thu, 23 Jul 2026 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840333; cv=none; b=DjVHwI5Vketcf7Ty5AnjnFb44zZ1EWmcoiUYB5/kw7syCXlMTFQkz1AlXPgB5cHzuxlbDRoMGR8o3c+qB8fHxZbssmsRLO1v25HvIYG0lmvAPP9UnKIKJwB0dVlg1FNfCezSIbDALFjVzTznr7eHwz8EE1tC+i6wMezE/MFfPNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840333; c=relaxed/simple;
	bh=a7xwlQTHMkpXFmK1gWizhlEYREBtr9q7x0Jt2ehswUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWMi59Sf6Wu9NGX1QWrNQIWaa7KQ9pzwA5Up6xZjNbyC7Xs4s5qtGbT6OBVbCQ0fdMYTPEHKirZ3YOLHN0CqHhuljwiqQOWQwV++ry9t5xI3xp1hJ5UCqQVs0rsCeUrt7CPiliaYEzGAcKNMK9pV/XZDwK/UCQC7H2xsogIruZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhlSfCxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhlSfCxY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 84ED51F000E9;
	Thu, 23 Jul 2026 20:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840330;
	bh=1ziTfovUdohtXInxF+PcLSLDD1W5ZNjsRuYLVuqmqJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hhlSfCxYbYEdZXnMcGV1ViltG3rM5yJTcIxFLnyueuFuTWczQ2RAJ+Ui9o5vcNTBt
	 hAvBgLRlXBYprb6gWuerZ47mCwxlREO/d5l+34iUb61JsNw1jwV3R5mobGw1/Pa8BK
	 6iuCwYS7S0pWy4U/lNygUpN52DObi0fMFYZJ5dwnVJhv64mS/egAp21oMhXm/HlB3U
	 Dd04TzB6vgs36GIk1JpCDk0Djs7Q2TxOblDGS09mSqEY7BlaEVuqoLc92hyycSmROk
	 2cRejsBVwqnHiq8lGp/ns85UJ89UAllP6N0t/Hv1wxtZM6YQ2lZcCgUFACouBRF/HB
	 ql0ZAQ2dsKMuQ==
Date: Thu, 23 Jul 2026 13:58:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered
 read I/Os
Message-ID: <20260723205849.GH2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-19-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:43PM +0200, Christoph Hellwig wrote:
> Stop using the xfs per-inode work struct for completing read bios, as
> unlike writes we don't want to serialize reads on a single inode as
> there is no exclusive resource contention for them.
> 
> Factor the code for kicking off a read that needs and ioend and the
> task context completion into a single helper so that it is split off
> the xfs_end_bio machinery, which is not only used for writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 10 ++++------
>  fs/xfs/xfs_file.c  |  9 +--------
>  fs/xfs/xfs_ioend.c | 32 +++++++++++++++++++++++++++-----
>  fs/xfs/xfs_ioend.h |  2 ++
>  4 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 49d21d905cc3..76918bd15ca8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -580,12 +580,10 @@ xfs_bio_submit_read(
>  	const struct iomap_iter		*iter,
>  	struct iomap_read_folio_ctx	*ctx)
>  {
> -	struct bio			*bio = ctx->read_ctx;
> -
> -	/* defer read completions to the ioend workqueue */
> -	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
> -		iomap_ioend_flags(&iter->iomap));
> -	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
> +	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
> +			ctx->read_ctx_file_offset,
> +			iomap_ioend_flags(&iter->iomap));
> +	ctx->read_ctx = NULL;

Hmm, so I guess the advantage here is that instead of chaining together
a lot of ioends to do all the read completion stuff serially, we can
instead process them all in parallel(ish) since we don't really need to
grab ILOCKs and stuff like that, right?

If so then I think this it's appropriate not to use the ioend coalescing
anymore:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  static const struct iomap_read_ops xfs_iomap_read_ops = {
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c0c3a11e7ff2..d31a1dddcdc3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -37,7 +37,6 @@
>  #include <linux/fadvise.h>
>  #include <linux/mount.h>
>  #include <linux/filelock.h>
> -#include <linux/bio-integrity.h>
>  
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
> @@ -236,14 +235,8 @@ xfs_dio_read_bounce_submit_io(
>  	struct bio		*bio,
>  	loff_t			file_offset)
>  {
> -	struct iomap_ioend	*ioend;
> -
> -	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
> +	xfs_ioend_submit_read(iter->inode, bio, file_offset,
>  			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> -	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> -		fs_bio_integrity_alloc(bio);
> -	bio->bi_end_io = xfs_end_bio;
> -	submit_bio(bio);
>  }
>  
>  static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 40695d18dac0..37a3ae8066e9 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -16,6 +16,32 @@
>  #include "xfs_reflink.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_ioend.h"
> +#include <linux/bio-integrity.h>
> +
> +static void
> +xfs_end_io_read(
> +	struct bio		*bio)
> +{
> +	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> +	int			error = blk_status_to_errno(bio->bi_status);
> +
> +	iomap_finish_ioends(ioend, error);
> +}
> +
> +void
> +xfs_ioend_submit_read(
> +	struct inode		*inode,
> +	struct bio		*bio,
> +	loff_t			file_offset,
> +	u16			ioend_flags)
> +{
> +	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
> +	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_alloc(bio);
> +	bio->bi_end_io = xfs_end_io_read;
> +	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +	submit_bio(bio);
> +}
>  
>  static void
>  xfs_ioend_put_open_zones(
> @@ -148,11 +174,7 @@ xfs_end_io(
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
>  		iomap_ioend_try_merge(ioend, &tmp);
> -		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> -			iomap_finish_ioends(ioend,
> -				blk_status_to_errno(ioend->io_bio.bi_status));
> -		else
> -			xfs_end_ioend_write(ioend);
> +		xfs_end_ioend_write(ioend);
>  		cond_resched();
>  	}
>  }
> diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
> index 525865767fca..7c2a1ea3e6ed 100644
> --- a/fs/xfs/xfs_ioend.h
> +++ b/fs/xfs/xfs_ioend.h
> @@ -12,5 +12,7 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  }
>  
>  void xfs_end_bio(struct bio *bio);
> +void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
> +		loff_t file_offset, u16 ioend_flags);
>  
>  #endif /* __XFS_IOEND_H */
> -- 
> 2.53.0
> 
> 
