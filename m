Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A873513398E
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227578; cv=none; b=iBwVmZT2ixr1Twjv1/MzS30J9GSCEbwFWTPlIm33r6bGtP7NfavpEuL2zJV0Wb5CT9Xa65IdFCzJ4u8s1Vqn7z2BEwwBUctVAyBB7y1tP8hdZaHll80uIKJgz9Auwra97tgDdHHWKn6U8OyvxYw9J6pJg+5EIreliFVx2OrmeKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227578; c=relaxed/simple;
	bh=FFez1oksga3HW2R9FFcy9aY6Zs6Ijl13XlrFTXINSZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UePvhqDM2Wq512MsvWzYBy4QJdVmZpcFe474+PBeuFmbzfU1E6XCYQYWoBuQfq2JUwFF6ZXxYK/bOsZm9JfK5Qdv4UHDvwc85rIODMdjhxlIJkP7fraeVhY4sYkktDdLXjvVBLsR8hg9pEfGb2MxlrbN7yXjnmh8kcjMMbYRTuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcRlpZpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcRlpZpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D2FC32789;
	Mon, 20 May 2024 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227578;
	bh=FFez1oksga3HW2R9FFcy9aY6Zs6Ijl13XlrFTXINSZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcRlpZpf8JJ88qywtnIilv4rNY1AvSPI6Ia75YgSBq3Vbw+VdTLNBmutQg/OlkdAN
	 DUN8OfmT2I7ZMqfK6B70Bk85Nr9sd2XdZ2NVAZMWSxyyqNx/o4dSH722m50Qcr3Ftq
	 H2mbUu7q1K83pEJiAJFj+DbcboOFI2F7hYJrxrPuuSLqa2TOmPJ7bKdBA8dKRw3HyM
	 njscCzXPqau8xFSSBpOmY6+JrIEx0Hgwed9jVvGBZ/UN3F4Kv/vQwPbVPoMj0gNPih
	 LLPT8ZG+fuuBOP9DgcMjfYQ19rKTvcUkfSfwHLKXeZKhKH/lFfntoreqH3YXe4vjd5
	 vB0h2qVertBlQ==
Date: Mon, 20 May 2024 10:52:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH v2 3/4] xfs: allow setting xattrs on special files
Message-ID: <20240520175257.GE25518@frogsfrogsfrogs>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-5-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520164624.665269-5-aalbersh@redhat.com>

On Mon, May 20, 2024 at 06:46:22PM +0200, Andrey Albershteyn wrote:
> As XFS didn't have ioctls for special files setting an inode
> extended attributes was rejected for them in xfs_fileattr_set().
> Same applies for reading.
> 
> With XFS's project quota directories this is necessary. When project
> is setup, xfs_quota opens and calls FS_IOC_SETFSXATTR on every inode
> in the directory. However, special files are skipped due to open()
> returning a special inode for them. So, they don't even get to this
> check.
> 
> The FS_IOC_FS[SET|GET]XATTRAT will call xfs_fileattr_set/get() on a
> special file. Therefore, allow them to work on special inodes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f0117188f302..adedfcd3fde5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -459,9 +459,6 @@ xfs_fileattr_get(
>  {
>  	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
>  
> -	if (d_is_special(dentry))
> -		return -ENOTTY;
> -
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> @@ -736,9 +733,6 @@ xfs_fileattr_set(
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> -	if (d_is_special(dentry))
> -		return -ENOTTY;
> -
>  	if (!fa->fsx_valid) {
>  		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
>  				  FS_NOATIME_FL | FS_NODUMP_FL |
> -- 
> 2.42.0
> 
> 
