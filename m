Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2E29ACC5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375774; cv=none; b=BhAk9bfpv/ucjCLaHa7QDVhhNUF61GAIdXaQs/+2COO1IVazK2/lGAhUZ0I71qDmTsCd66DHLZ8irBcbSFVacPDxQ2Aswqh3NO+mQIbdrsuZ+ehnO89i77jt0tNcjTVkcdFOyMzFYiOjOQi0lOW9kcTIUEcv+CsRyWGGkyQJXWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375774; c=relaxed/simple;
	bh=IOpcsR4I+e0iKEtMe94nX4sGcyFudElRM/bBul8Y7Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGf7QB5SBzpjeu5rT5EUf8IGzPXwYeR2YaNrcsVwYbiZXLXtEn8iNbU8B2umiufPDM38jtYeGOu7HNEQSE6RhMK6GcH8JGKaVM8IJN2SP0zAwwJdP9RkHn+Hc6LazkAKQNAaHKWrCj6AQ1Vqycl1pyhzlVgZz//kQz1S7lr9Y9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYHtQOan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYHtQOan"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1EE8E1F00893;
	Tue,  2 Jun 2026 04:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375773;
	bh=rsijJGyZlsZnQuQS8ZUCHRk2AtdfUS0pG4tQTO0Pzdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nYHtQOankxr5Is4jFe7isG7ntEvJcZ1n5U8f7V/nP04tg9ZH/iXTxed0gxji4w9Il
	 9kNpYyx5nIWXjGedr/UTMNQtk/ULdnfbsnY/Wu9/h9Jcfaq3etBfjn11+vSG2JoZi5
	 mBLwE7xqOa/ARbT+wQd45ktfn7wQduBDSzs6ORXpVhjBZ1F52Oaclz+oQhS/UaD6aj
	 nUVUYuEW4wRZQtTWs52/rU+dtidJFdut34YdfqJT+veX4ahjviz3+uD+UjAuIu4sjo
	 zIkBHzNywTMrBFbgvPIMqWcmttcFNkI/gtAuZ0q5T5DMkFwWTBaxW0bnk+1Jhbts7V
	 s3p0zhjrX7aNA==
Date: Mon, 1 Jun 2026 21:49:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: mark struct xfs_imap as __packed
Message-ID: <20260602044932.GR6078@frogsfrogsfrogs>
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

Nice and compact now!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
>  		xfs_agblock_t agbno, struct xfs_buf **bpp);
> -- 
> 2.53.0
> 
> 
