Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FA51EB56
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717691482; cv=none; b=SYJYZkZd9WMFSu9TVMGoWtvrO2llhSTF2PTi7RZDKZ8iTp1vNg5zzhtTj6u4WwLPmhC4wPKeZfZwWJ67EWesln+jL3PZfPv92JBk8Y8AkAu4kbW+mrKZuTCTzYPHX/cxQSWV29bvDcr9CBKwFmTsBlK/qaJNhPHnSs4QdDMyi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717691482; c=relaxed/simple;
	bh=IMVdkFDl3HJ82kwT/AalcvRNHhd3v0skwLPWnPE7BM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9mPD/UEPZN+uugrqgQBcQ+EcJTz4r0+nuLKpOcAuD/WaMRTMUG2Tv67cRPgWgrTe0d8q3EcBBuq6tY5QOyr/lrosMgglEUozrs87NKMpwqH3pOyioQqckXkNvhRuPwPcEW3BmKMrPjYULCmqfJMNV4YikNyaN2n/MYe9FuayIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO3Ovcdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO3Ovcdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531FAC2BD10;
	Thu,  6 Jun 2024 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717691482;
	bh=IMVdkFDl3HJ82kwT/AalcvRNHhd3v0skwLPWnPE7BM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iO3Ovcdt2cPvZKmGqxj3YYtjbgeoDaP44qkgz5uGM0mn8ArBtL3EWtoVuzULC9aYp
	 39i6x2mBFjR1DAIAdURbusW/zLZuo/K14GsOtiBJkj+14apF0hAtV21j9sroK3JgPd
	 6pMwS+2GjA2opHgGXeTMwKHoQDJDYcgdRZYeT9LYdBoJ4yQemmJ9WvAI+4L1+p4H+d
	 mZxdXwiXYdW//4QM/uiAckiHqhEejrwwkyL9CmPDzKKaemdBy2APJ7FnMM9CYEk5Ty
	 IgoHqi8KoOnumxQjnghGcaZhRttXJ3WqEQp/dMitp2a2ukccl0FRHqJ38Qkjpt1cKf
	 khisXzFUPpicQ==
Date: Thu, 6 Jun 2024 09:31:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3] xfs: don't walk off the end of a directory data block
Message-ID: <20240606163121.GM52987@frogsfrogsfrogs>
References: <20240606031416.90900-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606031416.90900-1-llfamsec@gmail.com>

On Thu, Jun 06, 2024 at 11:14:16AM +0800, lei lu wrote:
> This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
> to make sure don't stray beyond valid memory region. Before patching, the
> loop simply checks that the start offset of the dup and dep is within the
> range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
> can change dup->length to dup->length-1 and leave 1 byte of space. In the
> next traversal, this space will be considered as dup or dep. We may
> encounter an out of bound read when accessing the fixed members.
> 
> In the patch, we check dup->length % XFS_DIR2_DATA_ALIGN != 0 to make
> sure that dup is 8 byte aligned. And we also check the size of each entry
> is greater than xfs_dir2_data_entsize(mp, 1) which ensures that there is
> sufficient space to access fixed members. It should be noted that if the
> last object in the buffer is less than xfs_dir2_data_entsize(mp, 1) bytes
> in size it must be a dup entry of exactly XFS_DIR2_DATA_ALIGN bytes in
> length.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index dbcf58979a59..71398ce0225f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -178,6 +178,12 @@ __xfs_dir3_data_check(
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  
> +		if (offset > end - xfs_dir2_data_entsize(mp, 1)) {
> +			if (end - offset != XFS_DIR2_DATA_ALIGN ||
> +			    be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
> +				return __this_address;
> +		}

Let me work through the logic here.  If @offset is too close to @end to
contain a dep for a single-byte name, then you check if it's an 8-byte
dup.  If it's not a an 8-byte dup, then you bail out.  Is that correct?

So if we get to this point in the function, either @offset is far enough
away from @end to contain a possibly valid dep; or it's an 8-byte
FREE_TAG region that's possibly correct.

I think the logic is correct, though I think it would be clearer if
you'd add this to xfs_dir2_priv.h:

static inline unsigned int
xfs_dir2_data_unusedsize(
	unsigned int		len)
{
	return round_up(len, XFS_DIR2_DATA_ALIGN);
}

and modify the loop to read like this:

	/*
	 * Loop over the data/unused entries.
	 */
	while (offset < end) {
		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
		unsigned int			reclen;

		/*
		 * Are the remaining bytes large enough to hold an
		 * unused entry?
		 */
		if (offset > end - xfs_dir2_data_unusedsize(1))
			return __this_address;

		/*
		 * If it's unused, look for the space in the bestfree table.
		 * If we find it, account for that, else make sure it
		 * doesn't need to be there.
		 */
		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
			xfs_failaddr_t	fa;

			reclen = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
			if (lastfree != 0)
				return __this_address;
			if (be16_to_cpu(dup->length) != reclen)
				return __this_address;
			if (offset + reclen > end)
				return __this_address;
			...
			offset += reclen;
			continue;
		}

		/*
		 * This is not an unused entry.  Are the remaining bytes
		 * large enough for a dirent with a single-byte name?
		 */
		if (offset > end - xfs_dir2_data_entsize(mp, 1))
			return __this_address;

		/*
		 * It's a real entry.  Validate the fields.
		 * If this is a block directory then make sure it's
		 * in the leaf section of the block.
		 * The linear search is crude but this is DEBUG code.
		 */
		if (dep->namelen == 0)
			return __this_address;
		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
		if (offset + reclen > end)
			return __this_address;
		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
			return __this_address;
		...
		offset += reclen;
	}

What do you all think?

--D

> +
>  		/*
>  		 * If it's unused, look for the space in the bestfree table.
>  		 * If we find it, account for that, else make sure it
> @@ -188,6 +194,8 @@ __xfs_dir3_data_check(
>  
>  			if (lastfree != 0)
>  				return __this_address;
> +			if (be16_to_cpu(dup->length) % XFS_DIR2_DATA_ALIGN != 0)
> +				return __this_address;
>  			if (offset + be16_to_cpu(dup->length) > end)
>  				return __this_address;
>  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
> -- 
> 2.34.1
> 
> 
