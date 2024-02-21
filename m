Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D17490
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 02:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481850; cv=none; b=QzY+QpBsR+5On7+38TuW8F4+eFxpdkJg7WlUJ9J7+/wOuIFZQPnoLSiRpEkdldd7O2Tluosdo75LUb4p4aNBv0IpyIdzT0hqgEqGeDz1KdPFN450XYD8r8lUJrL15qkSGWQyhjFTQFpfdlCD4bmslyqU1mLReNP2PsbQ5zRWNEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481850; c=relaxed/simple;
	bh=fG10la6HkZl3Cf0hmrnwUOBE/u8UN3enCJqXUOALu/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8lZ2LxLSI/GG3MvzA4q+Xz6/SD7hOJ84EsPWoDpseWsjU9VPLWp9X4bJvKyMMAJNrSyh2MK4QnZmsopT/sRYvmNmjiAoiz9hj1bsDHujJJDFMkecmLHzQufHdXdscQQVdNX50a/koBG75YTc+VTzzG5Bip+LOSc0CvWAqthBIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsGlZpw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsGlZpw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99882C433F1;
	Wed, 21 Feb 2024 02:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708481849;
	bh=fG10la6HkZl3Cf0hmrnwUOBE/u8UN3enCJqXUOALu/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SsGlZpw2/xIomRZeYnMl/G53jn5sLX4MMA/Tbw+XsVLHDVNlHLxem/R/WPAE7qkJg
	 RCfYKJe9IiokhSpnI6eCdqr5/ZboJKrbbCruwzcaV6PxuN5kmagsaYjtB9OEd1NjSM
	 21j6kVeQFX/gAODZaPwichfF3n2kQ3T6kzLg7V2fngH1JixBIwEkr6BNTQleZUBzlO
	 lo2kxTpj5ZxyTGqw3R5TYMGkzI5lQOo8CMK0RhIUp65UKXh8VLzSVRj5fqfy7wfT8X
	 j/nxHbYIWQ0YyDxFtHm1X69QdM2SzdV4Hbdt7lIge+8DSc9JNmxEyhrB054ioKbaq2
	 Ocnu0xrCn2U3w==
Date: Tue, 20 Feb 2024 18:17:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/22] xfs: use shmem_kernel_file_setup in xfile_create
Message-ID: <20240221021729.GD616564@frogsfrogsfrogs>
References: <20240219062730.3031391-1-hch@lst.de>
 <20240219062730.3031391-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219062730.3031391-11-hch@lst.de>

On Mon, Feb 19, 2024 at 07:27:18AM +0100, Christoph Hellwig wrote:
> shmem_kernel_file_setup is equivalent to shmem_file_setup except that it
> already sets the S_PRIVATE flag.  Use it instead of open coding the
> logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/xfile.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index e649558351bc5a..99a2b48f5662e6 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -68,7 +68,7 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
> +	xf->file = shmem_kernel_file_setup(description, isize, VM_NORESERVE);
>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> @@ -85,7 +85,7 @@ xfile_create(
>  			    FMODE_LSEEK;
>  	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
>  	inode = file_inode(xf->file);
> -	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
> +	inode->i_flags |= S_NOCMTIME | S_NOATIME;
>  	inode->i_mode &= ~0177;
>  	inode->i_uid = GLOBAL_ROOT_UID;
>  	inode->i_gid = GLOBAL_ROOT_GID;
> -- 
> 2.39.2
> 
> 
