Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD715DBB9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 19:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709148948; cv=none; b=KfH8NOfvJ84wk/j2WnFMfgFFPkLfS3EWEVkddXOFc3Eowm9VsiBAI/UzQR9/E1EzpKU64R3A3fNjAvP4fdAnWCjqKZhK3cW3sbRShKLxNLMCJnValYCNWx6tuCASPoZ5GQg0oyv9zPdx6DPxiK0Wx67L821SQZq0eaT2m3WHszQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709148948; c=relaxed/simple;
	bh=8kJV45dg8RsUFGeu3xKKiJ7GZCZoGSE2S/tkKM87LUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=feh9pZsoWOMJb7BINtS0fku8w/dXXcmYsX8rledR14SNouVy6MK5J7F+t99HBORb3lSumE+Vdg8Lwt7Cjwr4nCEjHV943VcCUB9xUTPCZ7S5ZjWWW/BDwyYfbw/tOT3JdEELMrpTsWI/X2TLkS+04yykgVfOM+VnxcK+SsqZ8oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJstFyVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJstFyVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BECC43141;
	Wed, 28 Feb 2024 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709148948;
	bh=8kJV45dg8RsUFGeu3xKKiJ7GZCZoGSE2S/tkKM87LUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pJstFyVd9+0f2UKNmX7+f7rP3b69BLvKE80W9FghqyPjMh9aGiZIJXqDNyTw1+taX
	 gYKfMj+o7LMh3QGX3qqjjviAlf0tyvhvB37acKw/XFWVEj/mRL0tHKW5KOcJ7WgQtu
	 3MXwPKhHNbXPm1T6o8Y87QmZcW1rVnGMV820REnFFO1PGVJDFjwbR5vM19J6kVEBgI
	 XFn2C8zClqen22I2dbhyvvBvxdcaHZ381bEplI/BLgTNkCy6ze0jcrAqscnZ+rD2Yo
	 MHn4wG521xVLiYStblUIMDw9/PRNE42BqI5ruWLFwLt5VvpeVhxuIkcIEnp3VtsjMy
	 4+ReENC7Nohgw==
Date: Wed, 28 Feb 2024 11:35:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <20240228193547.GQ1927156@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9U4GAYxqw7zpXe@infradead.org>

On Wed, Feb 28, 2024 at 07:44:32AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:21:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Introduce a pair of new ioctls to handle exchanging ranges of bytes
> > between files.  The goal here is to perform the exchange atomically with
> > respect to applications -- either they see the file contents before the
> > exchange or they see that A-B is now B-A, even if the kernel crashes.
> > 
> > The simpler of the two ioctls is XFS_IOC_EXCHANGE_RANGE, which performs
> > the exchange unconditionally.  XFS_IOC_COMMIT_RANGE, on the other hand,
> > requires the caller to sample the file attributes of one of the files
> > participating in the exchange, and aborts the exchange if that file has
> > changed in the meantime (presumably by another thread).
> 
> So per all the discussions, wouldn't it make sense to separate out
> XFS_IOC_COMMIT_RANGE (plus the new start commit one later), and if
> discussions are still going on just get XFS_IOC_EXCHANGE_RANGE
> done ASAP to go on with online repair, and give XFS_IOC_COMMIT_RANGE
> enough time to discuss the finer details?

Done.  All of the COMMIT_RANGE code (and the _CHECK_FRESH2 code) have
been moved to a separate patch and combined with the patch[1] from
yesterday.

[1] https://lore.kernel.org/linux-xfs/CAOQ4uxiPfno-Hx+fH3LEN_4D6HQgyMAySRNCU=O2R_-ksrxSDQ@mail.gmail.com/

> > +struct xfs_exch_range {
> > +	__s64		file1_fd;
> 
> I should have noticed this last time, by why are we passing a fd
> as a 64-bit value when it actually just is a 32-bit value in syscalls?
> (same for commit).

I'll change that.

> > +	if (((fxr->file1->f_flags | fxr->file2->f_flags) & (__O_SYNC | O_DSYNC)) ||
> 
> Nit: overly long line here.

I'll replace the __O_SYNC | O_DSYNC with O_SYNC, since they're the same
thing.

> > +	if (fxr->flags & ~(XFS_EXCHRANGE_ALL_FLAGS | __XFS_EXCHRANGE_CHECK_FRESH2))
> 
> .. and here

Fixed, thanks.

> > +	/*
> > +	 * The ioctl enforces that src and dest files are on the same mount.
> > +	 * However, they only need to be on the same file system.
> > +	 */
> > +	if (inode1->i_sb != inode2->i_sb)
> > +		return -EXDEV;
> 
> How about only doing this checks once further up?  As the same sb also
> applies the same mount.

I'll remove this check entirely, since we've already checked that the
vfsmnt are the same.  Assuming that's what you meant-- I was slightly
confused by "same sb also applies the same mount" and decided to
interpret that as "same sb implies the same mount".

--D
