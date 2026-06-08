Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCBC33D6FD
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780919594; cv=none; b=p/RlgjBVHnov4f8J357Wd0aF9P8Z5drdAKqdV7ydFVCkv6c8Vc5c6WK9v7JfkseUfUFyF9pX39/Yg86wjbUvf+kP0jro6rBc+EtNSnDttd52eU1q5wEDWWDUgjUjgsiKExSUc0b0cIZqRasTzSDO6OHfzTah6F8WyDKCvR6JAoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780919594; c=relaxed/simple;
	bh=p7TE6lVtf22i6nq3kEOP2YnIm7xfh8ZOd453ARwNvjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlhmPr8YXCOC5PPf4YfG3hOLb3n2YBbUrDa0PzHIX0wxKOOR0DIeXAQ1Uu6aTdgHvlTsi6EN8pj5Z+ZDKqPOWW/gwtmx18jMRBawl34Fp02shD4k0+ylF9/h+P1VbH0/MQDTK43jFzoGH2FpBAqCcDncCij04CveqcJqmD4fvko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsBWh3pW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsBWh3pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC021F00893;
	Mon,  8 Jun 2026 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780919593;
	bh=TI9x0nz424aSFQMT/WRXb1EjRijY2pzNQjEWzTHOPaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IsBWh3pWBDmR8zYzS1d/UEGL1qfmeNLLnE975u3tJXWWaFCXfGWybspCfBcpG1jj0
	 ZJcfGiOIcwhVk3FtQSkHNla/+D2jVyFNMp06H0L22J01oZ0wNg5noshW9hYmLDZdbD
	 QPOSJgZDmqnzfaQZVXdozAWIl82ar1ifzxQgGG0ho1YLmo1W82TWP31VYHu6MrgpIq
	 +wKdDF4xdTJNCmB8U9Wmj3P8QMCuEOh49JHXRzFy2Gf97G/ML9TVKsFJJFVe84GCsp
	 L8qq1gGqI7Ur92EAW1iG0SYTvHEVyQLXeqWxRN3bnxxpZDtii06kTH/I9h6Cj6Q5JW
	 SGItlRJTJ25oQ==
Date: Mon, 8 Jun 2026 13:53:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: mark struct xfs_imap as __packed
Message-ID: <aiatHy6BS4LIXsU-@nidhogg.toxiclabs.cc>
References: <20260601124410.3508980-1-hch@lst.de>
 <20260601124410.3508980-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601124410.3508980-6-hch@lst.de>

On Mon, Jun 01, 2026 at 02:43:51PM +0200, Christoph Hellwig wrote:
> This returns 2 bytes of padding at the to struct xfs_inode into which
> this structure is embedded.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 57192adc7744..f3624532b023 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,7 @@ struct xfs_dinode;
>  struct xfs_imap {
>  	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
>  	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
> -};
> +} __packed;
>  
>  int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
>  		xfs_agblock_t agbno, struct xfs_buf **bpp);
> -- 
> 2.53.0
> 
