Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82A913BC26
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734039883; cv=none; b=IDFybyFsnoS7V+uZyA4E8mJzZU2lCvXuiXxShrdmmzoDeQTtlHMW+P/cheOX79KycdS+2LYLA8Gw5Or6ca7cchQPZut1YUWXCJeehaiSfwMcGzyGPQ9umeOWpmw/rctjp1dLhqWPf/LvfrppB3Ro5XZdiWsH8cIANFvGnq5wRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734039883; c=relaxed/simple;
	bh=22T2JXckAEF1t13yXyXSjwXWd87qTqHDKWFmdDkOyI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBO64OoAuN45PmGiLiIJ1In32GGlxxkmBvl41wbi4ztFMxIbGNhcqy8ulw20377OFVMQgrMAd4HMZVHxP7ALFT22aAm3yR1vTBVRo1WPo8CnPfAyrGD3Pm3u13azhJJAG9V4+jWBsQ7iJ079leo3NsURhoDnN0+zEaoq1RhUhiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efQ6v01D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efQ6v01D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4678BC4CECE;
	Thu, 12 Dec 2024 21:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734039883;
	bh=22T2JXckAEF1t13yXyXSjwXWd87qTqHDKWFmdDkOyI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efQ6v01DiCj19r/oOo1yvTt1jpzhJvvRNIVnRnEgdHBq4UIHsV7ljockq+50RtaHC
	 6OloUKPdxwN9MbaDwrDRkFHN4RFsfhmHOg65Xi+6SpBqWgsbar49mZ688p5FCpNNuJ
	 W69gpGFcuAjyChiZRsiR+cFYyNQ270s049dPsE9wpYgcjjUl19AcKRxSSVg5IYTlg/
	 O3n0urUfsY9pxy7IFInRNRmGt2OFWBpRSEvxpFgehfPz2XIZS9nlc19dAjS7k6dOkl
	 w/SojJNHxr0uX8UQh0lOcGHTYfGF2eKhM1qc31SkRGnzKzjbSJ/lX477oyPPExzGTb
	 iVdr7VvzSSqog==
Date: Thu, 12 Dec 2024 13:44:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: refine the unaligned check for always COW
 inodes in xfs_file_dio_write
Message-ID: <20241212214442.GY6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-13-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:37AM +0100, Christoph Hellwig wrote:
> For always COW inodes we also must check the alignment of each individual
> iovec segment, as they could end up with different I/Os due to the way
> bio_iov_iter_get_pages works, and we'd then overwrite an already written
> block.

I'm not sure why an alwayscow inode now needs to require fsblock-aligned
segments, seeing as it's been running mostly fine for years.

Is this a bug fix?  Or prep for rtzone files, which are (presumably)
always written out of place?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 2b6d4c71994d..6bcfd4c34a37 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -721,7 +721,16 @@ xfs_file_dio_write(
>  	/* direct I/O must be aligned to device logical sector size */
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
> -	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
> +
> +	/*
> +	 * For always COW inodes we also must check the alignment of each
> +	 * individual iovec segment, as they could end up with different
> +	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
> +	 * then overwrite an already written block.
> +	 */
> +	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
> +	    (xfs_is_always_cow_inode(ip) &&
> +	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
>  	return xfs_file_dio_write_aligned(ip, iocb, from);
>  }
> -- 
> 2.45.2
> 
> 
