Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9133286891;
	Thu, 19 Feb 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522468; cv=none; b=MOuAkSl7jLrGB3x90daTY9EnW7cHQs2SNyDc6aXmeT59NHMhNg88QMd6omQEfHWSAjgmIdtwuR56fuv16jWEa1aswG8p8nD8xMOrUYSRAc1Y0tEwHqhATbwsCvt9phYe/LgA8z5NtJ0xiiDazdNooQC00BsDerXavJ7toG//T6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522468; c=relaxed/simple;
	bh=15ecolc4Le4QiyvI6qoKONWdkGhqdDvi0NBBSRoJ1RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIEGGEr4rcggHQRcj1ruS1xwPEUXLgJXaApBBcfzkXni5gWr+dYdI0Y+mSElM7TPW2yRw/MjpVax2eLfBGQPrZsey1bP2RBfr6vHQTXBoef2/cyQE7w4VmIIGTa2F8mEPPeuqtLirIe3TLM3o1YPVo/+NSN0NDBLyRFNqIsprdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XoQguC60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XoQguC60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B5DC4CEF7;
	Thu, 19 Feb 2026 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771522467;
	bh=15ecolc4Le4QiyvI6qoKONWdkGhqdDvi0NBBSRoJ1RI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XoQguC60CFm09PADgnIsjZYHpHvAu8UDsH9QnBWV1JJ+V62+zmbcJo9bhgdWyWP3Z
	 4Al045quKuP5UnXeuObJfWLZ/OZQ8eGdq03Wpl6zI4LvL9NYzXC1P30kn8ohW8Jl1p
	 H+ZRkYvjt+ZNrVaNKFXOjhYb195P4oCw16oACfgVll/De5YPBO203HKasjSxECCvFu
	 BOripoKD/HJ2a9F2AJe8nWZ8FAgTxT7cYJ6XbWtHvIaSdTVItUdDyJpJJXSf9LmFx8
	 1Qvn/law0NGDmzeAshG6M/isi5kCP0i6IXSTYgZdmwC0y5HSTZ6qs4rFY/thWqZH+W
	 LQgAxY2qjJurA==
Date: Thu, 19 Feb 2026 09:34:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 33/35] xfs: introduce health state for corrupted
 fsverity metadata
Message-ID: <20260219173427.GL6490@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-34-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-34-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:33AM +0100, Andrey Albershteyn wrote:
> Report corrupted fsverity descriptor through health system.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me, though I'll have to revisit this with a sharper eye
for what happens if/when you rebase to use fserror_*.

IIRC inconsistencies between the merkle tree and the file data are
reported as -EIO, right?  And at that point we have the file range
information, so we could actually use fserror_report_data_lost.

I forget, what do we do for inconsistencies between an internal node of
the merkle tree and the next level down?  That sounds like something
that should set XFS_SICK_INO_FSVERITY, right?

For this bit involving just the fsverity descriptor,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_fs.h     |  1 +
>  fs/xfs/libxfs/xfs_health.h |  4 +++-
>  fs/xfs/xfs_fsverity.c      | 13 ++++++++++---
>  fs/xfs/xfs_health.c        |  1 +
>  4 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 36a87276f0b7..d8be7fe93382 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -423,6 +423,7 @@ struct xfs_bulkstat {
>  #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
>  #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
>  #define XFS_BS_SICK_DATA	(1 << 9)  /* file data */
> +#define XFS_BS_SICK_FSVERITY	(1 << 10) /* fsverity metadata */
>  
>  /*
>   * Project quota id helpers (previously projid was 16bit only
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index fa91916ad072..c534aacf3199 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -105,6 +105,7 @@ struct xfs_rtgroup;
>  #define XFS_SICK_INO_FORGET	(1 << 12)
>  #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
>  #define XFS_SICK_INO_DATA	(1 << 14)  /* file data */
> +#define XFS_SICK_INO_FSVERITY	(1 << 15)  /* fsverity metadata */
>  
>  /* Primary evidence of health problems in a given group. */
>  #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
> @@ -142,7 +143,8 @@ struct xfs_rtgroup;
>  				 XFS_SICK_INO_SYMLINK | \
>  				 XFS_SICK_INO_PARENT | \
>  				 XFS_SICK_INO_DIRTREE | \
> -				 XFS_SICK_INO_DATA)
> +				 XFS_SICK_INO_DATA | \
> +				 XFS_SICK_INO_FSVERITY)
>  
>  #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
>  				 XFS_SICK_INO_BMBTA_ZAPPED | \
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 5a2874236c3c..d89512d59328 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -197,16 +197,23 @@ xfs_fsverity_get_descriptor(
>  		return error;
>  
>  	desc_size = be32_to_cpu(d_desc_size);
> -	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
> +	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE)) {
> +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
>  		return -ERANGE;
> -	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
> +	}
> +
> +	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos)) {
> +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
>  		return -ERANGE;
> +	}
>  
>  	if (!buf_size)
>  		return desc_size;
>  
> -	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
> +	if (XFS_IS_CORRUPT(mp, desc_size > buf_size)) {
> +		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
>  		return -ERANGE;
> +	}
>  
>  	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
>  	error = xfs_fsverity_read(inode, buf, desc_size, desc_pos);
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index b851651c02b2..e52ee02f7d7c 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -488,6 +488,7 @@ static const struct ioctl_sick_map ino_map[] = {
>  	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
>  	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
>  	{ XFS_SICK_INO_DATA,	XFS_BS_SICK_DATA },
> +	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
>  };
>  
>  /* Fill out bulkstat health info. */
> -- 
> 2.51.2
> 
> 
