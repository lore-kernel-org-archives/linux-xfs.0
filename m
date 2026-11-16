Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827132;
	b=l5MQoNdFhpiShAn/IDGpToReM12WZnUADdzpXkHt9y682E7H6Laf9I1up5tfNnEhvpp7
	 zUbmBUYDonwJn6dFzvY6P0CHvx/gpZyOQNxXEum4UyfKgpIgH8bNAeEZJAAaobsce0eln
	 QPg+rTUyfGbLU1tLZwYZld8TClqoZb0EKluuZ0wR7fU8iuvccRfjLPobjIJtG0wPpOGuj
	 1gfEQ3dKaxrH/wrojxp3EmKBJHBkBLqDc+O3IijlO8Q3YcgSl910CI8qljYIf3fUSLWIs
	 luZYnathe2Sx3cMk4/vu1Vy+UrlaM0GnRlmZkigxDSb3JWl5rhKG3dQvb40L10LkZcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827132;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6m7pNiFJP9GDQ5q5Qguwm4pP6n0KJNKNJUw997q7JCE=;
	b=oJfQcf0GbljuHuI1+3wcKvqLgAPljg77RAHXmDpNgekr1y30JwzvmjYtHL7l57h/SvqZ
	 uHyU3C+ULiqzqnOaHvleaRcBxrVxFL8T0lzmJthPM8wsjkdAGvzpaNZSKTD33jC36gibH
	 CnTG/nriTHWiCvshGFDlyoWlV0duqAGv+ia3FJL0hCr3FLRFJ2MqXQVhS9IU40Y9vRFVN
	 pk98qbaCHAJyLlk8NgZ01eeWltNZmF26F5WHgq40Ddd/XPtHUYtifujn5x7VkU8xoRzph
	 EO6sT7nF+0wmyn/BScbXTRXtWHpIi/LI7j930ZmbrO8Kd8SMkV4YmXbctCqSb13aVjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+5jSjm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAC76073C4D;
	Mon, 16 Nov 2026 11:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+5jSjm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB211F000CB;
	Mon, 16 Nov 2026 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827131;
	bh=6m7pNiFJP9GDQ5q5Qguwm4pP6n0KJNKNJUw997q7JCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l+5jSjm1IFe81iQ/yNkb7eD/+1iKPUj/IepRtMoXO3ddKeFntCTQctHbDqPEi1cEw
	 tcDahbr3Yqts0gD6DjIBXOqwwg2kaKWP8NfKJWjSQs/EWAFH1i+M2bHSBDoUVR6Ihq
	 AN95Uv+3GZipwZ06OiDmFn0GzLhmG5sAo7Av/o98Ar6AbUWu3hJ1sKHvgH36rk+ILU
	 155OFEUmUG+rt8YZLCwdE++jslfklSvJrDkyxLtQyvG/qZ5g3Sr6j6IZolEUSxcQ7j
	 shv6iY++0sD7t4ixad3P9w7CVlxF4G4QS2n4LHIGwV2u6Nji2KKJcdjRCnkwfxavft
	 ZDwtei9al43DQ==
Date: Mon, 16 Nov 2026 12:05:26 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tz2294@columbia.edu, 
	brauner@kernel.org
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112214604.67875-6-mason@kernel.org>

On Thu, Nov 12, 2026 at 04:46:09PM -0500, Chris Mason wrote:
> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
> 
>     block size 4096, i_size 512, O_APPEND
>     validated:        0 to 4095
>     written:          512 to 4607
>     new blocks:       0 to 8191
>     stale below EOF:  0 to 511
> 
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
> 
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> Signed-off-by: Chris Mason <mason@kernel.org>

FWIW, this is another patch that would normally go through Brauner's
branch, so just in case once we get it settled...

Chris, Ted, Jan. Are you guys fine if I merge this patch through xfs's
tree?


> ---
> 
> Notes:
>     v6->v9: no change
> 
>  fs/ext4/file.c    |  4 ----
>  fs/read_write.c   | 13 +++++++++++++
>  fs/xfs/xfs_file.c | 17 +++++++++++------
>  3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50d3c92709c8..e301d4faf1c3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
>  		    len > EXT4_SB(inode->i_sb)->s_awu_max)
>  			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	if (iocb->ki_flags & IOCB_DIRECT)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 676728310899..1b34b7382619 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * O_APPEND has moved the position and the file size limits have
> +	 * shortened the write by now, so this is the range to validate.  An
> +	 * atomic write is all or nothing, so refuse it if it got shorter.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (count != iov_iter_count(from))
> +			return -EINVAL;
> +		ret = generic_atomic_write_valid(iocb, from);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	iov_iter_truncate(from, count);
>  	return iov_iter_count(from);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index be1f775128d1..153f53f964b9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -926,12 +926,21 @@ xfs_file_dio_write(
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
> +	/*
> +	 * An atomic write is at least one block long, and generic_write_checks()
> +	 * refuses it unless its final position is a multiple of its length.  So
> +	 * there is no unaligned case to handle for it.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (xfs_is_zoned_inode(ip))
> +			return xfs_file_dio_write_zoned(ip, iocb, from);
> +		return xfs_file_dio_write_atomic(ip, iocb, from);
> +	}
> +
>  	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
>  	if (xfs_is_zoned_inode(ip))
>  		return xfs_file_dio_write_zoned(ip, iocb, from);
> -	if (iocb->ki_flags & IOCB_ATOMIC)
> -		return xfs_file_dio_write_atomic(ip, iocb, from);
>  	return xfs_file_dio_write_aligned(ip, iocb, from,
>  			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
>  }
> @@ -1128,10 +1137,6 @@ xfs_file_write_iter(
>  
>  		if (ocount > xfs_get_atomic_write_max(ip))
>  			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	if (IS_DAX(inode))
> -- 
> 2.55.0
> 
> 
