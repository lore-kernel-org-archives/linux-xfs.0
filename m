Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC4625DCE0
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 07:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759477867; cv=none; b=Zi9/nZgg/sBbdD8r8CRgJSBUOozZuNh7Qun4uvtj6sv8p4fSuQsD671XAZ6JOZQS0JEZcHpm35/yuCmTXjK3rIhUBHJWGf3gDZ37IoOYNYZp/WBBBxbXpZyjuvu4B2CGWxbQiUA7gPVRTOeleYjO6aEEFzIT8uWkgu7UcxmZpac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759477867; c=relaxed/simple;
	bh=zLUwn2XQ56ZeNN4z3upMchg94g6ZeMQtXIN0HOGSa2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ots7dfl6MKaGFYGCPDJH14hRdg/4Etiy0LhL513LesTnaAt7KTmAlxhrqDskSfZ1FF88eKsm0GZaiR+biIFSGz3W15J/9g3bzccgkBrtCwvu3jo3i1NGqRHe8OyPx7MVTGL5Dy/q8DXma+SKRxTtvIG1pNyIgtVDo69LsATbiCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZX1U4u24; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZX1U4u24"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=flCC7xUpGWaR1QOI9NxUDKymu/Xoah/VJL8WPu5uNLc=; b=ZX1U4u240VYZgmLgHSVfXAf/c6
	niyj8yhF+48g7PipzHzzddjuzfI2GUOqE6L3CyFUHKnCuGovU8w45Nw6Ih0pFMrYlJ10tRpelg0za
	Zj8o7ypdyFyDtEsmpCl0xQC91ir3yvGO8sC0GFItoE9kGqhXtydV5vw5Yy344z+YIajEjEzJbi5HO
	S+okeTrffa0Z9jXfnAMiWqUtjR2OcKwv+TVxptUk13AHhlGKa5+AX+YdC2ovAnJZAmFpvIdeLZsUh
	g7p3PCJydSoed+zTt6HWPmESBULI16xaVv9HCHfA6GZ2/a048dVR3Ev/U4deepHzmuTHIO/cE5C87
	wxfsMHFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4aZF-0000000BqWM-0H7v;
	Fri, 03 Oct 2025 07:51:05 +0000
Date: Fri, 3 Oct 2025 00:51:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aN-Aac7J7xjMb_9l@infradead.org>
References: <20251002122823.1875398-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002122823.1875398-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 02, 2025 at 02:28:24PM +0200, Lukas Herbolt wrote:
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
> +    uint32_t        flags,      /* XFS_BMAPI_... */

This seems to mix tabs and spaces.

>  static int
>  xfs_falloc_zero_range(
>  	struct file		*file,
> -	int			mode,
> +	int				mode,

More whitespace damage here.

>  	loff_t			offset,
>  	loff_t			len,
>  	struct xfs_zone_alloc_ctx *ac)
> @@ -1277,7 +1277,16 @@ xfs_falloc_zero_range(
>  
>  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>  	offset = round_down(offset, blksize);
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
> +	        return -EOPNOTSUPP;
> +		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_ZERO,
> +				offset, len);
> +	}
> +	else

The closing brace goes onto the same line as the else, and we usually
add the brace in all branches.

Otherwise this looks fine.
