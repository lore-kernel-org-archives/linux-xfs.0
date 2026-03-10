Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE72FD1BF
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154628; cv=none; b=ii+kWcGHLn0hcyBsMxJc8kOJmSpJpSumlM4I6a7/Ma7s2yJCzJ9EOiiCisGBAk9yl8nNzX1G6IDUEpRkSOYWYshvRdJE0nQ9nxfkMv75Tsn/eSm02gcKTJJEML87nhKqPWNkf+dprARhWYr1rb/XCZVpJMN6E+5jaRmY5KyLbJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154628; c=relaxed/simple;
	bh=ZZMPPrNmMrvpk1SybQG5SEN/NBLh/Hb10oJOH1IY7W8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZHuxnK21dW1KhekKe+PW8T5vrrkh2INssVvVRNPosoRb1qwTqTtGjWBrOWIrKgZig1BLqpjWfeGaU86ydftgQyYbC4vqsUk4FSV9inXs/DXFSRXJkshrAUYHgDXhqFh6MROCygT3gYNBQT4GPEnsxpoJvKAdnoab2KS+byHRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZFUAtbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZFUAtbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7DFC19423;
	Tue, 10 Mar 2026 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154628;
	bh=ZZMPPrNmMrvpk1SybQG5SEN/NBLh/Hb10oJOH1IY7W8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZFUAtbAWesq3sQEiAzwIJM0Db48jY8mSLZlyQ+CtfDNmBpsfiWS5P+7y9K17iXEa
	 3UDkZTosCMbQk/uRyW1Owf6urC1CEMvYcb2mlQOs72ju4bcmRv2f7AqHBOV0yayeyi
	 oS4yHH8elSPdFECXGFYj/8MipCIHnyVjhOuDAc2DBFMnpv4zdWl/GJ18sq+fQIB17J
	 UjIImIfRldUxRx9bGzFkxujDfxofkmQa1CYZS2bjkG3PcK3o63Q9TXSueg1F2c6tph
	 hRB3yFDMpziB1irCULMSl8O4BZ7ToEJnxWz4wFWt64Dn5+aDvJX+mtAYXpVpCAXrxm
	 oXUN65keEW9uA==
Date: Tue, 10 Mar 2026 07:57:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260310145707.GO1105363@frogsfrogsfrogs>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <20260310004400.GU6033@frogsfrogsfrogs>
 <274965b98fee964be0cdcf4503d394b3@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <274965b98fee964be0cdcf4503d394b3@herbolt.com>

On Tue, Mar 10, 2026 at 11:20:54AM +0100, Lukas Herbolt wrote:
> On 2026-03-10 01:44, Darrick J. Wong wrote:
> > On Mon, Mar 09, 2026 at 07:12:36PM +0100, Lukas Herbolt wrote:
> > > Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
> > > enable the unmap write zeroes operation.
> > > 
> > > Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> > > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > > 
> > > ---
> > >  v11 changes:
> > > 	- split into 2 patches separating the bmapi_flags addition
> > > 	- 2 step allocation, to avoid zeroing beyond EOF
> > > 
> > >  fs/xfs/xfs_file.c | 41 +++++++++++++++++++++++++++++------------
> > >  1 file changed, 29 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index fd049a1fc9c6..f8c1611e3267 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1293,29 +1293,45 @@ xfs_falloc_zero_range(
> > >  	unsigned int		blksize = i_blocksize(inode);
> > >  	loff_t			new_size = 0;
> > >  	int			error;
> > > +	bool                    need_convert = false;
> > > 
> > >  	trace_xfs_zero_file_space(ip);
> > > 
> > > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> > > +		if (xfs_is_always_cow_inode(ip) ||
> > > +		    !bdev_write_zeroes_unmap_sectors(
> > > +			    xfs_inode_buftarg(ip)->bt_bdev))
> > > +			return -EOPNOTSUPP;
> > > +		need_convert = true;
> > > +	}
> > > +
> > >  	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> > >  	if (error)
> > >  		return error;
> > > 
> > >  	if (xfs_falloc_force_zero(ip, ac)) {
> > >  		error = xfs_zero_range(ip, offset, len, ac, NULL);
> > > -	} else {
> > > -		error = xfs_free_file_space(ip, offset, len, ac);
> > > -		if (error)
> > > -			return error;
> > > -
> > > -		len = round_up(offset + len, blksize) -
> > > -			round_down(offset, blksize);
> > > -		offset = round_down(offset, blksize);
> > > -		error = xfs_alloc_file_space(ip, offset, len,
> > > -				XFS_BMAPI_PREALLOC);
> > > +		goto set_filesize;
> > >  	}
> > > +	error = xfs_free_file_space(ip, offset, len, ac);
> > >  	if (error)
> > >  		return error;
> > > -	return xfs_falloc_setsize(file, new_size);
> > > +
> > > +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> > > +	offset = round_down(offset, blksize);
> > > +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
> > > +
> > > +set_filesize:
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_falloc_setsize(file, new_size);
> > > +	if (error)
> > > +		return error;
> > > +	if (need_convert)
> > > +		error = xfs_alloc_file_space(ip, offset, len,
> > > +				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> > > +	return error;
> > >  }
> > 
> > I can't help but think this would be cleaner as:
> > 
> > static int
> > xfs_falloc_write_zero_range(
> > 	struct file		*file,
> > 	int			mode,
> > 	loff_t			offset,
> > 	loff_t			len,
> > 	struct xfs_zone_alloc_ctx *ac)
> > {
> > 	struct inode		*inode = file_inode(file);
> > 	struct xfs_inode	*ip = XFS_I(inode);
> > 	unsigned int		blksize = i_blocksize(inode);
> > 	loff_t			new_size = 0;
> > 	int			error;
> > 
> > 	trace_xfs_zero_file_space(ip);
> > 
> > 	if (xfs_is_always_cow_inode(ip) ||
> > 	    !bdev_write_zeroes_unmap_sectors(
> > 				xfs_inode_buftarg(ip)->bt_bdev))
> > 		return -EOPNOTSUPP;
> > 
> > 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> > 	if (error)
> > 		return error;
> > 
> > 	if (xfs_falloc_force_zero(ip, ac)) {
> > 		error = xfs_zero_range(ip, offset, len, ac, NULL);
> > 		if (error)
> > 			return error;
> > 
> > 		return xfs_falloc_setsize(file, new_size);
> > 	}
> > 
> > 	error = xfs_free_file_space(ip, offset, len, ac);
> > 	if (error)
> > 		return error;
> > 
> > 	len = round_up(offset + len, blksize) -
> > 		round_down(offset, blksize);
> > 	offset = round_down(offset, blksize);
> > 	error = xfs_alloc_file_space(ip, offset, len);
> > 	if (error)
> > 		return error;
> > 
> > 	error = xfs_falloc_setsize(file, new_size);
> > 	if (error)
> > 		return error;
> > 
> > 	return xfs_alloc_file_space(ip, offset, len,
> > 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> > }
> I didn't want to duplicate most of the xfs_falloc_zero_range, but if that's
> fine we can go this way.

I /much/ prefer that each fallocate mode have its own small cohesive
function.  We used to have one giant function with conditionals
everywhere and it was very hard to understand.

> > ...assuming there's even a point to WRITE_ZEROES on a zoned file?
> I think this is covered in:
> 
> if (xfs_is_always_cow_inode(ip) ||
>     !bdev_write_zeroes_unmap_sectors(
> 		xfs_inode_buftarg(ip)->bt_bdev))
> 	return -EOPNOTSUPP;

Yeah, it is.  I missed that, so this becomes shorter:

static int
xfs_falloc_write_zero_range(
	struct file		*file,
	int			mode,
	loff_t			offset,
	loff_t			len,
	struct xfs_zone_alloc_ctx *ac)
{
	struct inode		*inode = file_inode(file);
	struct xfs_inode	*ip = XFS_I(inode);
	unsigned int		blksize = i_blocksize(inode);
	loff_t			new_size = 0;
	int			error;

	if (xfs_is_always_cow_inode(ip) ||
	    !bdev_write_zeroes_unmap_sectors(
				xfs_inode_buftarg(ip)->bt_bdev))
		return -EOPNOTSUPP;

	trace_xfs_write_zero_range(ip);

	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
	if (error)
		return error;

	error = xfs_free_file_space(ip, offset, len, ac);
	if (error)
		return error;

	len = round_up(offset + len, blksize) -
		round_down(offset, blksize);
	offset = round_down(offset, blksize);
	error = xfs_alloc_file_space(ip, offset, len,
			XFS_BMAPI_PREALLOC);
	if (error)
		return error;

	error = xfs_falloc_setsize(file, new_size);
	if (error)
		return error;

	return xfs_alloc_file_space(ip, offset, len,
			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
}

--D
