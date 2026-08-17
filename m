Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF573B47C3;
	Mon, 17 Aug 2026 07:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786951207; cv=none; b=MeyG5xmAgztU6+HdiTex34Ca+wcNEz4RYlYRzsfMROA8VFQHTDMCedj+myXz7HolwovcC3+8ys0i92Dx/PNixsFnHHM0a/VOxXEGsCniF7or9S7VQkTUKA4UHq73LR+qMkQEifKjx2IQFyI29wFa6oXu0SnFAO8iLIIDydKWzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786951207; c=relaxed/simple;
	bh=myeqPs/5HjoaiaENp6VOEIO9ZPDU1o1pXiX7ZccVRHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fktVRMoIlnXq4fem+p4zujSBZEfXhycyOvA0oVedTpWxIL02rvhxVa7FFlLg7TEsMQmFoIRcKIUL+GzzIboQFfSxF8C/bY3HpSmzcAHgI2etWqbKNhxYroliu4uVWkmnbdgCT3OIYufxNu2lzwm2r8DpiqBOrD42yosW5QNEtSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 65CDA68D07; Mon, 17 Aug 2026 09:20:00 +0200 (CEST)
Date: Mon, 17 Aug 2026 09:20:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 17/25] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260817072000.GD17371@lst.de>
References: <20260814092448.1818082-1-aalbersh@kernel.org> <20260814092448.1818082-18-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-18-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 14, 2026 at 11:24:34AM +0200, Andrey Albershteyn wrote:
> Use read ioends for fsverity verification. Do not issue fsverity
> metadata I/O through the same workqueue due to risk of a deadlock by a
> filled workqueue.
> 
> Pass fsverity_info from iomap context down to the ioend as hashtable
> lookups are expensive.
> 
> Add a simple helper to check that this is not fsverity metadata but file
> data that needs verification.

> -	const struct address_space	*mapping)
> +	const struct address_space	*mapping,
> +	loff_t				position)
>  {

Hmm, "position" is new for these kinds of arguments.  We tend to call
them "pos", "off", or "offset", but I guess this completes the matrix :)

But maybe stick to pos to match the naming of the helpers used by the
callers.


>  	struct xfs_inode		*ip = XFS_I(mapping->host);
>  
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
> +			xfs_fsverity_is_file_data(ip, position))
>  		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;

Nit: While this is one of the standard Linux indent styles for long
ifs, the other one would seem more readable here:

	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
	    xfs_fsverity_is_file_data(ip, position))

> +#include "xfs_errortag.h"
> +#include "xfs_fsverity.h"
>  #include <linux/bio-integrity.h>
> +#include <linux/fsverity.h>
> +
> +static void
> +xfs_end_fsverity_io_read(
> +	struct work_struct	*work)
> +{
> +	struct iomap_ioend	*ioend =
> +		container_of(work, struct iomap_ioend, io_work);
> +
> +	if (!ioend->io_bio.bi_status)
> +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
> +
> +	iomap_finish_ioends(
> +		ioend, blk_status_to_errno(ioend->io_bio.bi_status));

Indentation looks odd here, this should be:

	iomap_finish_ioends(ioend,
		blk_status_to_errno(ioend->io_bio.bi_status));

or maybe add a local bio variable given that you use ioend->io_bio
three times, and this would fit onto a single line.

> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0959b97e641b..f329a57d6ee9 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -454,6 +454,7 @@ struct iomap_ioend {
>  	sector_t		io_sector;	/* start sector of ioend */
>  	void			*io_private;	/* file system private data */
>  	struct fsverity_info	*io_vi;		/* fsverity info */
> +	struct work_struct	io_work;	/* fsverity blocking I/O */
>  	struct bio		io_bio;		/* MUST BE LAST! */
>  };

Please don't add new fields to iomap structures in xfs patches.

And I really don't like adding it here given that struct work_struct is
rather big and not useful in other ways here.  So maybe just do the
alloc a struct for the workqueue and queue it up using
fsverity_enqueue_verify_work approach the other file systems do.
Or add something like the block complete in task thing to fsverity
and simplify all these so that they only need a list entry
(which we already have in the ioend).
