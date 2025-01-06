Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E36E142E7C
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183263; cv=none; b=h6pDJSaGv6M+ceNRUNd/m9QJrX14i9kcRI7ysN2Y1/n2numot8OYxFClw2JG8FFQyA8bh7F5ldFummixaqOvm5CUBArWVuBo83RwkN2xZodelwUr+IBbObtddOik0U2spn9JQNLtZsxzRHtjrllsi4OCSj7spPae4r14mXU3PMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183263; c=relaxed/simple;
	bh=GZYsnQi5/onuMhHOpFjqzM1sRAFIwnoC1fhxLeyh8hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fwcz762D1Otho0zZ582ZAgvRY0fgLvDaD4QgnThDXnJcOKcpWFn8u8S+PwZ6pomZ+7Gz0W9RD8ibRu1hsYZi4fBXWCCQficUUK3/4rd7wPIhVbboOe8KitlCwxyCx3ut6R3lXKdhhMKR/nH/JvoC4GCBXSQDlSHn7DBXVLTcTLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmi5GXNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmi5GXNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AD8C4CED2;
	Mon,  6 Jan 2025 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736183262;
	bh=GZYsnQi5/onuMhHOpFjqzM1sRAFIwnoC1fhxLeyh8hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hmi5GXNHJEQE2dZN6+ae2W73dAcvu/U5HqC2a2C28z9R5fuw0VmuN+6iDpjcsJhma
	 Rh0iqphckyUiPoWbDFWQ/iZqtbbMa9BYejoII39DIZ4uoEc/ZqT7bOWqoM19l6DUXo
	 ok61e13a1c7ISlvvKdaxeDe0rjhbv8RJ/MHHfk/ERsMaoocTdMn0UPufuItrgCEi9H
	 M44xLUH5P2V/fzY1Rb9ud0l2cN/OY6CnUsNzy0KOtHVgwAHaDlBHTha6/PajuKERW/
	 3atmdoc7IFsw59ENqYVTi6y2ghI5e7HAGDCQU5svdjWLUtOURfDGVxAVDVTeAfRfJS
	 UYIWioWyNG1Qw==
Date: Mon, 6 Jan 2025 09:07:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: mark xfs_dir_isempty static
Message-ID: <20250106170742.GY6174@frogsfrogsfrogs>
References: <20250106095044.847334-1-hch@lst.de>
 <20250106095044.847334-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095044.847334-2-hch@lst.de>

On Mon, Jan 06, 2025 at 10:50:29AM +0100, Christoph Hellwig wrote:
> And return bool instead of a boolean condition as int.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice and straightfoward, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.c | 6 +++---
>  fs/xfs/libxfs/xfs_dir2.h | 1 -
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 202468223bf9..81aaef2f495e 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -197,7 +197,7 @@ xfs_da_unmount(
>  /*
>   * Return 1 if directory contains only "." and "..".
>   */
> -int
> +static bool
>  xfs_dir_isempty(
>  	xfs_inode_t	*dp)
>  {
> @@ -205,9 +205,9 @@ xfs_dir_isempty(
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
> -		return 1;
> +		return true;
>  	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
> -		return 0;
> +		return false;
>  	sfp = dp->i_df.if_data;
>  	return !sfp->count;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 576068ed81fa..a6594a5a941d 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -58,7 +58,6 @@ extern void xfs_dir_startup(void);
>  extern int xfs_da_mount(struct xfs_mount *mp);
>  extern void xfs_da_unmount(struct xfs_mount *mp);
>  
> -extern int xfs_dir_isempty(struct xfs_inode *dp);
>  extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_inode *pdp);
>  extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
> -- 
> 2.45.2
> 
> 
