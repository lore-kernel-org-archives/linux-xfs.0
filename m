Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF135972
	for <linux-xfs@vger.kernel.org>; Sat,  4 Oct 2025 04:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759550424; cv=none; b=hFn0BkdkY914U0OdHxYEVOQkf8NHyCw3B4jkdAwgpoVGf+qYQS+q8QUAeSq7emNy0GiPH2LM9mNJPakhJGCdcvdUsa+2A2OMF7YtWmnMgsA7dyi8jjrHdLf1cZRSVSfwn6ZsJGX6yFgW46WD1COY3cye2/n61J/AUoDsgx6KYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759550424; c=relaxed/simple;
	bh=TPXIeBCxKa9SEXUXVAtew3ZSCTgs4MW2POa/YFM2JjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDtGrAYEd1aIVoNCckdTHTyhjTWHNzuyaBNRCi4qIFI1Gf3NP8pbu61513Hn3sVy5JArhByFmdBIcqDFOn3Ck6e0M9K4Xg/eFTO5iBQqFc66tr4lNSyViBQ4jY2mZ7azGxFbIR8lHStMLQhAmN7EspaSFubqD8T0hWD7XyyeWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1f9A15I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1f9A15I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58795C4CEF1;
	Sat,  4 Oct 2025 04:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759550421;
	bh=TPXIeBCxKa9SEXUXVAtew3ZSCTgs4MW2POa/YFM2JjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H1f9A15IXPo0qf+Stcx43QVhtwd0Vtbhtmg5DnPNIg725IrUqH5EOWbFq0BBVNQKJ
	 WXV5t1kCI2DjCKxzsEHyNgB66g8YXyAIxSOHEpUO1HZWItbWnHTGksVE+5xcVRpuGg
	 MAeqA7ZXoQR3mGjVrs3gZe0AzM1m6CmaltbLOzJ+f8wEvULtzrGZ/mqNuZ499RqEIS
	 6sP2j6sbTC9MUrPPvnu1uNDdkx8VBdWChdYK6EeFwf9jec0Kbv1V+CS/dX1HXJrhUj
	 t0nk+qqYVrLY/wxLxob73vGXD+Bls1yT/OMaww+4efvEGyGgQJkqBH/tNBGC4Vn5vx
	 RB5my4j2VwZ6w==
Date: Fri, 3 Oct 2025 21:00:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20251004040020.GC8096@frogsfrogsfrogs>
References: <20251002122823.1875398-2-lukas@herbolt.com>
 <aN-Aac7J7xjMb_9l@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aN-Aac7J7xjMb_9l@infradead.org>

On Fri, Oct 03, 2025 at 12:51:05AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 02, 2025 at 02:28:24PM +0200, Lukas Herbolt wrote:
> >  int
> >  xfs_alloc_file_space(
> >  	struct xfs_inode	*ip,
> > +    uint32_t        flags,      /* XFS_BMAPI_... */
> 
> This seems to mix tabs and spaces.
> 
> >  static int
> >  xfs_falloc_zero_range(
> >  	struct file		*file,
> > -	int			mode,
> > +	int				mode,
> 
> More whitespace damage here.
> 
> >  	loff_t			offset,
> >  	loff_t			len,
> >  	struct xfs_zone_alloc_ctx *ac)
> > @@ -1277,7 +1277,16 @@ xfs_falloc_zero_range(
> >  
> >  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> >  	offset = round_down(offset, blksize);
> > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> > +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))

     		                         not correct ^^^^^^^^^^^^^^^^^^^

You need to find the block device associated with the file because XFS
is a multi-device filesystem.

--D

> > +	        return -EOPNOTSUPP;
> > +		error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_ZERO,
> > +				offset, len);
> > +	}
> > +	else
> 
> The closing brace goes onto the same line as the else, and we usually
> add the brace in all branches.
> 
> Otherwise this looks fine.
> 
