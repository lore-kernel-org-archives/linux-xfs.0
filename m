Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBC378F2B
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183394; cv=none; b=FI6u/D0FJC7/7+9XHRyCL5/6OmtPEP9IXWS4j/6luDMMV26JSx9WpnKCklUI6VM3oKAW9rzKGkH0ZFf4pqSIN4ukZpi43O0AbseXBmZSV9MCKl5Vq8U1tizRf74TkymP1q9GnBIFnaCeRoo/VqeqYHE4n9C6sU7n9iVIInmkJBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183394; c=relaxed/simple;
	bh=CPzPH23fMABhyNnGzVEl7sK9uRFXKKpBF+ponCNzGrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tftjxsn1w5JWFUnKJ6fy7Rt+/I0xvIN6t6j5KwkzNA0chxthJAM4vmnC2gsfYnCdTAoSRHntdBNNuo4t3itMaK0bS/xDg07Zw0zBNE25NDmoJf/Y05rFkKiOYmacLDPAGVgZUNUi5DjvXpXhVEUH7xeA1Up43VrQMb1/ZbIsMkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arrXhQxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arrXhQxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66506C4CED6;
	Mon,  6 Jan 2025 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736183394;
	bh=CPzPH23fMABhyNnGzVEl7sK9uRFXKKpBF+ponCNzGrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arrXhQxGJ4cTI/+YNo48tmVwZubPdLeiTb4UYIAuU5HgypJ/yfFKwEqOOOxjLavjH
	 AkcEVfUsbD9RK9W4Rtn/D3aoJbt0gLW81oGRvto6L75muCp4BsDkOvs4DTwwyZvBQD
	 55mB79oOUInFcM9bqFWyWXT27lYkzb+3LbPqaVfNZ+IEI5zjucRT9lKaMIMi8BI7Ne
	 xt803b7/Cz+0tMSyu28860nfKAy1ADiGbwVgMwLqXaX9MBPDh5roAIJMjdeD1XHWzy
	 A47GkkBaZYA0pDvzYyr5aOSZNafRKe1QLIL7IofR2u78x8mZOC4544IG74Ts5T6KNz
	 YH+a8PNeTyhLw==
Date: Mon, 6 Jan 2025 09:09:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove XFS_ILOG_NONCORE
Message-ID: <20250106170953.GZ6174@frogsfrogsfrogs>
References: <20250106095044.847334-1-hch@lst.de>
 <20250106095044.847334-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095044.847334-3-hch@lst.de>

On Mon, Jan 06, 2025 at 10:50:30AM +0100, Christoph Hellwig wrote:
> XFS_ILOG_NONCORE is not used in the kernel code or xfsprogs, remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_log_format.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 15dec19b6c32..41e974d17ce2 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h

Technically this is part of the userspace ABI:

$ grep NONCORE /usr/include/
/usr/include/xfs/xfs_log_format.h:362:#define   XFS_ILOG_NONCORE        (XFS_ILOG_DDATA | XFS_ILOG_DEXT | \

But it makes no sense for userspace to try to use that symbol and
Debian codesearch says there are no users, so:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> @@ -351,12 +351,6 @@ struct xfs_inode_log_format_32 {
>   */
>  #define XFS_ILOG_IVERSION	0x8000
>  
> -#define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
> -				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
> -				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
> -				 XFS_ILOG_ABROOT | XFS_ILOG_DOWNER | \
> -				 XFS_ILOG_AOWNER)
> -
>  #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
>  				 XFS_ILOG_DBROOT)
>  
> -- 
> 2.45.2
> 
> 
