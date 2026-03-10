Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97D843C049;
	Tue, 10 Mar 2026 09:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133904; cv=none; b=keJgad4SptoGt7sYLkDcCp8cJf0x/oSmcDfEIXJxTmAISl1/Y1Cv2u0z3KeGa48jXtY9dObd4NzADv8z/bfjpLODk/haqBwe5SVwUStedoKHK7s5/gCkPmLKGKfwex1Bux4Rzwh9/lDxv+7AQBuhkWC5pTuA0/+SxbKcm715tcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133904; c=relaxed/simple;
	bh=niXizPhah5hIAj3UF6lrgVzIWXZCa1tgKKfZO/MSq/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtwdNMStNS29CKQdpz4fpZbUZILtXor+aO4eL/iIIbtjp2qNLk375SxnMPpz8mUN37H7S7cAHPqb+x2OcVK05LWg9s8Fqy8Uu5+XPc++pn17bzc2qjwhXsDT9CZiQ0X+/b5r9IsSbTnQ+h9GFV416tmUyGeHVOHTb8Yuo66bGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB17168C4E; Tue, 10 Mar 2026 10:11:38 +0100 (CET)
Date: Tue, 10 Mar 2026 10:11:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4 17/25] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260310091136.GA18959@lst.de>
References: <20260309192355.176980-1-aalbersh@kernel.org> <20260309192355.176980-18-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-18-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 09, 2026 at 08:23:32PM +0100, Andrey Albershteyn wrote:
> -		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> +		if (bio_op(&ioend->io_bio) == REQ_OP_READ) {
> +			if (xfs_fsverity_is_file_data(ip, ioend->io_offset))
> +				fsverity_verify_bio(ioend->io_vi,
> +						    &ioend->io_bio);
>  			iomap_finish_ioends(ioend,
>  				blk_status_to_errno(ioend->io_bio.bi_status));

If bi_status is non-zero, there is no point in doing the verification.

> -		else
> +		} else {
>  			xfs_end_ioend_write(ioend);
> +		}

Also now that the code is non-trivial I'd add a xfs_end_ioend_read
mirroring xfs_end_ioend_write.

> @@ -764,9 +774,12 @@ xfs_bio_submit_read(
>  	struct iomap_read_folio_ctx	*ctx)
>  {
>  	struct bio			*bio = ctx->read_ctx;
> +	struct iomap_ioend		*ioend;
>  
>  	/* defer read completions to the ioend workqueue */
> -	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> +	ioend = iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);

Overly long line.

>  	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
>  		return &xfs_iomap_read_ops;
> +	if (xfs_fsverity_is_file_data(ip, position))
> +		return &xfs_iomap_read_ops;

use || here instead of two checks?

> +{
> +	const struct inode	*inode = VFS_IC(ip);
> +
> +	return fsverity_active(inode) &&
> +	       offset < xfs_fsverity_metadata_offset(ip);

Just open code the XFS_IC instead of a single use local variable?

