Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80338B7A5
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775559760; cv=none; b=kiX5057k4h8ALUWZIO+elj/bG4ZfJ/9qxD1kRAYr+uUSa61Sy8X+Mhkq04bvkMybt+CZzF8tvPvrifbuH9VjvlQKhrmgjimk16LB+J37XVnHXgbAkfZUfqYVXa3ntmTZlwyIdxipgsCkVzL5hMI+PyDO1xhjb6Wayw6+sDaEedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775559760; c=relaxed/simple;
	bh=iU/MgocQDRLnskYiDAWirmtwbnYM1hnaYxrk7Sb38LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tw8Crne+jx3qJirIgs+8Kaw6XMmf6A/S1a0JuelwHKOQnjJyzz1/fjKbxgfACUrIeRRbFbUHAOsh5YYS4/owf4sXjQOg+fLu1+s8y9yslfWQAVAO+cZWSJfwFQviuEDCzBdikc15MxW49j1zPZnDPEjpYVdoZ8HPixw/HTOt6X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYENqEcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYENqEcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302D0C19421;
	Tue,  7 Apr 2026 11:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775559759;
	bh=iU/MgocQDRLnskYiDAWirmtwbnYM1hnaYxrk7Sb38LE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mYENqEcrQUTBhDUuXIBU3JwXXaTMzr1X5Snzez+vwRFgBUs1tOt1Xz7T+HKspBa56
	 4wQCkiwo4uo3zKI8iGTXyfVALLvaoDsIFq4hOWf8HXjbTe0zDG1hFASKwqcqJS4Gif
	 uJM9yNHPbTY5gcV4dneORFFkU4PLuaQJUTuLYEkw+aiypQ2aAz6PIbPJXQdJHVDgsa
	 YW3QNC3nxjVLeurJIi/OBrpGwr5PV+w8e4av0IJqaALWmRTldS9pNXJsr6CFwGRDzN
	 jze1mCjy0opJNXQETv88k2TcUdzUFFk/wOvPVfJj7UbQmpHgUFMPzWZYrr35zbPil2
	 8bzRo6wdgRBHA==
Date: Tue, 7 Apr 2026 13:02:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fold xfs_setattr_size into xfs_vn_setattr_size
Message-ID: <adTkLl_bBXI6Ix0A@nidhogg.toxiclabs.cc>
References: <20260330131607.3904269-1-hch@lst.de>
 <20260330131607.3904269-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330131607.3904269-3-hch@lst.de>

On Mon, Mar 30, 2026 at 03:16:00PM +0200, Christoph Hellwig wrote:
> xfs_vn_setattr_size is the only caller of xfs_setattr_size, so merge the
> two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/xfs/xfs_iops.c | 38 +++++++++++---------------------------
>  1 file changed, 11 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b0256a4a8aa8..325c2200c501 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -901,20 +901,18 @@ xfs_setattr_nonsize(
>  
>  /*
>   * Truncate file.  Must have write permission and not be a directory.
> - *
> - * Caution: The caller of this function is responsible for calling
> - * setattr_prepare() or otherwise verifying the change is fine.
>   */
> -STATIC int
> -xfs_setattr_size(
> +int
> +xfs_vn_setattr_size(
>  	struct mnt_idmap	*idmap,
>  	struct dentry		*dentry,
> -	struct xfs_inode	*ip,
>  	struct iattr		*iattr)
>  {
> +	struct inode		*inode = d_inode(dentry);
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct inode		*inode = VFS_I(ip);
> -	xfs_off_t		oldsize, newsize;
> +	xfs_off_t		oldsize = inode->i_size;
> +	xfs_off_t		newsize = iattr->ia_size;
>  	struct xfs_trans	*tp;
>  	int			error;
>  	uint			lock_flags = 0;
> @@ -927,8 +925,11 @@ xfs_setattr_size(
>  	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
>  		ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
>  
> -	oldsize = inode->i_size;
> -	newsize = iattr->ia_size;
> +	trace_xfs_setattr(ip);
> +
> +	error = xfs_vn_change_ok(idmap, dentry, iattr);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * Short circuit the truncate case for zero length files.
> @@ -1128,23 +1129,6 @@ xfs_setattr_size(
>  	goto out_unlock;
>  }
>  
> -int
> -xfs_vn_setattr_size(
> -	struct mnt_idmap	*idmap,
> -	struct dentry		*dentry,
> -	struct iattr		*iattr)
> -{
> -	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> -	int error;
> -
> -	trace_xfs_setattr(ip);
> -
> -	error = xfs_vn_change_ok(idmap, dentry, iattr);
> -	if (error)
> -		return error;
> -	return xfs_setattr_size(idmap, dentry, ip, iattr);
> -}
> -
>  STATIC int
>  xfs_vn_setattr(
>  	struct mnt_idmap	*idmap,
> -- 
> 2.47.3
> 
