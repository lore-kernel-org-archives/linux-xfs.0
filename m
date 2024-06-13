Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5140414900F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718291385; cv=none; b=XyGjyGo5T0AySOOG9svFBsM9CMfb7O39ZoQjiMn0RbtleJcVThj6V0zkzD8PdUp9p011H1j/H78YMwymm+aqYEATCbDMIc6coIUQI6Ib+2mF36bRBWRZ4miDaJk+vcED1K79CkFYMYeqPRaZKlX6rj+6rk5ZyjSbHZPnpzETCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718291385; c=relaxed/simple;
	bh=+jiy0lvI9/vierJpV6+SU5L2Iku112O5dVz6Ug3VHIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KqLQT9gij+DXFmsCJvGxFKv2iGJNN7cCJ+PszCka1IctuJIS4GPpzd7PSuLstPRnQk8wY5jte814hQV/cmU+M3QR21TFoX3mRO50drWEV1lGm4zdGDmU0ZEDK1ByJ4THmQHQJu6a2odtN2LqC+NuNjkF8pcIJ6M2hiFTxV9Irg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QosfTmM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QosfTmM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD70AC2BBFC;
	Thu, 13 Jun 2024 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718291384;
	bh=+jiy0lvI9/vierJpV6+SU5L2Iku112O5dVz6Ug3VHIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QosfTmM/PIuTwCR2LT/CNUzP2XLB8MYA3eZO8t3hwzmY87Z7aBB6sNaz2XwNJZEKA
	 2VPUup99gxybXfY7Y42/l0zFwtHbRr7ao/fch22QISlprDOf0JXOxWwiz1+Or/hmX9
	 zeMQ8V5zdUN6zUnrNhPZ2N8NyMGhBpjPBSymAt8vIL4nAyoqzjecSw9VupczQYuFdI
	 nkV7NhtCRYZp6SrKpsso0Ive/tPhbZtmaYBAVGLm8xiHWzzt4Xsv1A4Lu8FEKnRq1o
	 //Tz1MUNdOpMVveENUkxL4wSkGzZOFN+zVR8hdFp/a5Ly1i7c/fl2HilZwKxKAsZYL
	 /XCTCMf/K4FDg==
Date: Thu, 13 Jun 2024 08:09:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v4] xfs: don't walk off the end of a directory data block
Message-ID: <20240613150944.GO2764752@frogsfrogsfrogs>
References: <20240613030509.124873-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613030509.124873-1-llfamsec@gmail.com>

On Thu, Jun 13, 2024 at 11:05:09AM +0800, lei lu wrote:
> This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
> to make sure don't stray beyond valid memory region. Before patching, the
> loop simply checks that the start offset of the dup and dep is within the
> range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
> can change dup->length to dup->length-1 and leave 1 byte of space. In the
> next traversal, this space will be considered as dup or dep. We may
> encounter an out of bound read when accessing the fixed members.
> 
> In the patch, we make sure that the remaining bytes large enough to hold
> an unused entry before accessing xfs_dir2_data_unused and
> xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
> sure that the remaining bytes large enough to hold a dirent with a
> single-byte name before accessing xfs_dir2_data_entry.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 30 +++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
>  2 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index dbcf58979a59..feb4499f70e2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -177,6 +177,14 @@ __xfs_dir3_data_check(
>  	while (offset < end) {
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> +		unsigned int	reclen;
> +
> +		/*
> +		 * Are the remaining bytes large enough to hold an
> +		 * unused entry?
> +		 */
> +		if (offset > end - xfs_dir2_data_unusedsize(1))
> +			return __this_address;
>  
>  		/*
>  		 * If it's unused, look for the space in the bestfree table.
> @@ -186,9 +194,12 @@ __xfs_dir3_data_check(
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
>  			xfs_failaddr_t	fa;
>  
> +			reclen = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));

Overly long line here.

			reclen = xfs_dir2_data_unusedsize(
					be16_to_cpu(dup->length));

With that fixed up, I think this is good to go.  Thanks for working on
this bug report!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  			if (lastfree != 0)
>  				return __this_address;
> -			if (offset + be16_to_cpu(dup->length) > end)
> +			if (be16_to_cpu(dup->length) != reclen)
> +				return __this_address;
> +			if (offset + reclen > end)
>  				return __this_address;
>  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
>  			    offset)
> @@ -206,10 +217,18 @@ __xfs_dir3_data_check(
>  				    be16_to_cpu(bf[2].length))
>  					return __this_address;
>  			}
> -			offset += be16_to_cpu(dup->length);
> +			offset += reclen;
>  			lastfree = 1;
>  			continue;
>  		}
> +
> +		/*
> +		 * This is not an unused entry. Are the remaining bytes
> +		 * large enough for a dirent with a single-byte name?
> +		 */
> +		if (offset > end - xfs_dir2_data_entsize(mp, 1))
> +			return __this_address;
> +
>  		/*
>  		 * It's a real entry.  Validate the fields.
>  		 * If this is a block directory then make sure it's
> @@ -218,9 +237,10 @@ __xfs_dir3_data_check(
>  		 */
>  		if (dep->namelen == 0)
>  			return __this_address;
> -		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
> +		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
> +		if (offset + reclen > end)
>  			return __this_address;
> -		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
> +		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
>  			return __this_address;
>  		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
>  			return __this_address;
> @@ -244,7 +264,7 @@ __xfs_dir3_data_check(
>  			if (i >= be32_to_cpu(btp->count))
>  				return __this_address;
>  		}
> -		offset += xfs_dir2_data_entsize(mp, dep->namelen);
> +		offset += reclen;
>  	}
>  	/*
>  	 * Need to have seen all the entries and all the bestfree slots.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 1db2e60ba827..263f77bc4cf8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -188,6 +188,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
>  extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
>  		       struct dir_context *ctx, size_t bufsize);
>  
> +static inline unsigned int
> +xfs_dir2_data_unusedsize(
> +	unsigned int	len)
> +{
> +	return round_up(len, XFS_DIR2_DATA_ALIGN);
> +}
> +
>  static inline unsigned int
>  xfs_dir2_data_entsize(
>  	struct xfs_mount	*mp,
> -- 
> 2.34.1
> 
> 
