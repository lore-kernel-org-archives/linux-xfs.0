Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A240B2C15AB;
	Tue, 29 Sep 2026 00:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641831; cv=none; b=tXDcNVxSRBA2bgUyUAkW+ejXUlA5US3UhN4ozBmWHSJgVg4i/7LFGm5f0u+tPyd/amwfOIJ/ESDVXs3KK08H3Mr7aIHjbPq044CAxustZXSzFq/qA7JL/78TGOp1KWqG4pQt3QLB1rwK7N5yKi7Nodm5mri6nY35XPxOHFRA3Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641831; c=relaxed/simple;
	bh=S9tgNtmy9SBLKrwmw9FhF873mIPRkt/WDmUZJ99sZYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6kMr5fZZ6PkW7UOaKV39VSMbjWtJHd4BEvdyTbpFUNcMt6ukWn1eyvC2i5+iV01K/h+JJYFEml6HWVJ61RJLKud2kcU53UmTh60KgG+4o7iUPPDXeggDnLXdAtz/XFNxTylZa5f0fBu87uy0tZs8HeJUnN0D8xzfMjmZSIbn/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iik0j5H6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iik0j5H6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 31EAA1F000FF;
	Tue, 29 Sep 2026 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641830;
	bh=SXeHN1uXeLEP2tcBtmxvCEX2fsY1PuyEfmwhkCYzCEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Iik0j5H6mICajP6vobCjY/LgcDL+74kQx0RZdXsIrzLLBGrJxc92dXZk7a0YHdr6O
	 09D8X6b6O9j1Mhuh1MeTso2uKKx5HMfDjnE3tXWHzDRxVggUWRJqYX5Drg2aDnlBsx
	 Rt58RPM+oHKTeWkMbWX+7eeafysrFopDLqD99M5ZNqa40Nn/Pl6fESRrcXYtrO/tDp
	 EKZjFCx2mr8mcCRRB0cYvUn0aEPJpGKmfVKoVdtLo/9kglzULIljwB1jG4HvmWfGy+
	 5k46aDCOAqzg3dSxzkAmyE9BI9/w7f53OdECQkfJbZBuxmIMb1gQdAl+333nVAQq91
	 9NKtU95pwwkGA==
Date: Mon, 28 Sep 2026 17:30:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: use bio_complete_in_task for buffered simple
 dio read failures
Message-ID: <20260929003029.GQ6283@frogsfrogsfrogs>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-4-hch@lst.de>

On Mon, Sep 28, 2026 at 11:11:09AM +0200, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice conversion here too.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce8..8ee8db6bb794 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -919,7 +919,6 @@ struct iomap_dio_simple {
>  	struct kiocb		*iocb;
>  	size_t			size;
>  	unsigned int		dio_flags;
> -	struct work_struct	work;
>  	/*
>  	 * Align @bio to a cacheline boundary so that, combined with the
>  	 * front_pad passed to bioset_init(), the bio sits at the start of
> @@ -961,30 +960,14 @@ static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
>  	return ret;
>  }
>  
> -static void iomap_dio_simple_complete_work(struct work_struct *work)
> -{
> -	struct iomap_dio_simple *sr =
> -		container_of(work, struct iomap_dio_simple, work);
> -	struct kiocb *iocb = sr->iocb;
> -
> -	WRITE_ONCE(iocb->private, NULL);
> -	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
> -}
> -
>  static void iomap_dio_simple_end_io(struct bio *bio)
>  {
>  	struct iomap_dio_simple *sr =
>  		container_of(bio, struct iomap_dio_simple, bio);
>  	struct kiocb *iocb = sr->iocb;
>  
> -	if (unlikely(sr->bio.bi_status)) {
> -		struct inode *inode = file_inode(iocb->ki_filp);
> -
> -		INIT_WORK(&sr->work, iomap_dio_simple_complete_work);
> -		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
> +	if (unlikely(bio->bi_status) && bio_complete_in_task(bio))
>  		return;
> -	}
> -
>  	WRITE_ONCE(iocb->private, NULL);
>  	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
>  }
> -- 
> 2.53.0
> 
