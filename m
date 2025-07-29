Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDFE1E0DCB
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753799575; cv=none; b=NrawK2iKzwTmSxrqJeAC6U8OPe6EVnbV5X0rrF0qofCMXjktkKUTp3f7R70nhXTFIg/aYRJrBCB8EUF7vbWCIzMuZQSMiUBpUrSSPZIwMGaKg1pZwRax3W7+dn3MTjDrTsT03qBLy+l69ifVT6sy6j3ppa1CMvCYv/8AwtkTsvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753799575; c=relaxed/simple;
	bh=G71kRrH4Uu91v1DvRlZ+GjPR3P8wXk91J54pJ6jEezQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UX6ASfRbnd7A+lKE9vywPWAJcGJdSxtgpt7qNhmW14hkrfgvKqQZgFCBxlYOAqnoQfprQtARrQe/0Z9v43kfWuhGP/K5/CI3b+B4yFjsQ34/7VxeMgIq6dZDWxQhp2bbNaBXj1LDTNwp/ALth/73aI5N4uQrGNaYDU40SD9mS5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+Sz+rqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+Sz+rqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC7FC4CEEF;
	Tue, 29 Jul 2025 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753799575;
	bh=G71kRrH4Uu91v1DvRlZ+GjPR3P8wXk91J54pJ6jEezQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s+Sz+rqRB8ZFoBY6y5UMOwncS6bWiylIIIiqTr96ZWWGvAFqDfgjzcPk8ij5kWzjg
	 upSBecHafsrHLpjNb2Xm9+HlKnB1V31uvLMK29VjdlTZyeBad1ZqBIE6+hZmOQBMgn
	 udIZ+jOqJgA0VPhIaV42sn6RdCo2lElK1MYhRtAI90fN7svgL49k8rCpPpgCoFjzIL
	 b0zG0fDdLbgUCOFnaHknKTHKB0o5QB7BvzHsyGZiK/kuyt813yEfGG+LU4ubN56tVx
	 yxCj3J5fU4x7e/L92U/Lkpj4h5ApXj10P0gsPGMrwKri3kWteWBspFM8BOJTCqFHd9
	 35sqwuC4vqsIg==
Date: Tue, 29 Jul 2025 07:32:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow setting xattrs on special files
Message-ID: <20250729143254.GZ2672049@frogsfrogsfrogs>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
 <20250729-xfs-xattrat-v1-2-7b392eee3587@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729-xfs-xattrat-v1-2-7b392eee3587@kernel.org>

On Tue, Jul 29, 2025 at 01:00:36PM +0200, Andrey Albershteyn wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
> 
> XFS does't have extended attributes manipulation ioctls for special
> files. Changing or reading file extended attributes is rejected for them

"extended file attributes" or "fileattrs" as Amir suggested,
but never "extended attributes" because that's a separate thing.

(no need to drop the rvb over this)

--D

> in xfs_fileattr_*et().
> 
> In XFS, this is necessary to work for project quota directories.
> When project is set up, xfs_quota opens and calls FS_IOC_SETFSXATTR on
> every inode in the directory. However, special files are skipped due to
> open() returning a special inode for them. So, they don't even get to
> this check.
> 
> The recently added file_getattr/file_setattr will call xfs_fileattr_*et,
> on special files. This patch allows reading/changing extended file
> attributes on special files.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_ioctl.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index fe1f74a3b6a3..f3c89172cc27 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -512,9 +512,6 @@ xfs_fileattr_get(
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
> 
> -- 
> 2.49.0
> 
> 
