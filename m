Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363025FF0A
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdxO2YZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BEFC433C8;
	Thu, 30 Nov 2023 21:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701378538;
	bh=PQ6HOO+M10XG+t2kSqNUevdkTuiEnglyGF0Sc7ZNmS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DdxO2YZGIOc3e34EbA+xgRYhU9+GAQJFWsrjdKzIb5ItS4F9cEQLXAu9YNFA4LX/J
	 tocUa+f7JdN31laCWAR8bF8xx+KA/avUq2NGDKttUGyReAB+fZKFyMPEob3Z9gUZ6+
	 cjeAKx8EoXkYDhIvLGd1WeuVIcFGyeILLqs4RbZXJNJD4K5/UZlrcKuPrqwoJiKv4i
	 hnK4pIE90QWwvW7IGlC+uPOmoZp/Ph2qrUg2CZgciWv3Oi+IJP7nIyPSKLYdVGicxy
	 IpSqZw5njd/wRMSe+WXaiIkMhSiBRKbZ8S6cWWsTnV23GlvHaLL2HPKh+1XUWTkoQ4
	 kTrTBQRJttl7A==
Date: Thu, 30 Nov 2023 13:08:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: zap broken inode forks
Message-ID: <20231130210858.GN361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
 <ZWgTSyc4grcWG9L7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgTSyc4grcWG9L7@infradead.org>

On Wed, Nov 29, 2023 at 08:44:59PM -0800, Christoph Hellwig wrote:
> > +/* Verify the consistency of an inline attribute fork. */
> > +xfs_failaddr_t
> > +xfs_attr_shortform_verify(
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct xfs_attr_shortform	*sfp;
> > +	struct xfs_ifork		*ifp;
> > +	int64_t				size;
> > +
> > +	ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
> > +	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
> > +	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
> > +	size = ifp->if_bytes;
> > +
> > +	return xfs_attr_shortform_verify_struct(sfp, size);
> 
> Given that xfs_attr_shortform_verify only has a single caller in the
> kernel and no extra n in xfsprogs I'd just change the calling
> convention to pass the xfs_attr_shortform structure and size there
> and not bother with the wrapper.

Ok.

> > +/* Check that an inode's extent does not have invalid flags or bad ranges. */
> > +xfs_failaddr_t
> > +xfs_bmap_validate_extent(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	struct xfs_bmbt_irec	*irec)
> > +{
> > +	return xfs_bmap_validate_extent_raw(ip->i_mount,
> > +			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
> > +}
> 
> .. while this one has a bunch of caller so I expect it's actually
> somewhat useful.

Yep. :)

> > +extern xfs_failaddr_t xfs_dir2_sf_verify_struct(struct xfs_mount *mp,
> > +		struct xfs_dir2_sf_hdr *sfp, int64_t size);
> 
> It would be nice if we didn't add more pointless externs to function
> declarations in heders.

I'll get rid of the extern.

> > +xfs_failaddr_t
> > +xfs_dir2_sf_verify(
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct xfs_mount		*mp = ip->i_mount;
> > +	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> > +	struct xfs_dir2_sf_hdr		*sfp;
> > +
> > +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> > +
> > +	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> > +	return xfs_dir2_sf_verify_struct(mp, sfp, ifp->if_bytes);
> > +}
> 
> This one also only has a single caller in the kernel and user space
> combined, so I wou;dn't bother with the wrapper.

<nod>

> > +xfs_failaddr_t
> > +xfs_symlink_shortform_verify(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> > +
> > +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> > +
> > +	return xfs_symlink_sf_verify_struct(ifp->if_u1.if_data, ifp->if_bytes);
> > +}
> 
> Same here.

Fixed.

> Once past thes nitpicks the zapping functionality looks fine to me,
> but leaves me with a very high level question:
> 
> As far as I can tell the inodes with the zapped fork(s) remains in it's
> normal place, and normaly accessible, and I think any read will return
> zeroes because i_size isn't reset.  Which would change the data seen
> by an application using it.  Don't we need to block access to it until
> it is fully repaired?

Ideally, yes, we ought to do that.  It's tricky to do this, however,
because i_rwsem doesn't exist until iget succeeds, and we're doing
surgery on the dinode buffer to get it into good enough shape that iget
will work.

Unfortunately for me, the usual locking order is i_rwsem -> tx freeze
protection -> ILOCK.  Lockdep will not be happy if I try to grab i_rwsem
from withina  transaction.  Hence the current repair code commits the
dinode cleaning function before it tries to iget the inode.

But.  trylock exists.

Looking at that code again, the inode scrubber sets us up with the AGI
buffer if it can't iget the inode.  Repairs to the dinode core acquires
the inode cluster buffer, which means that nobody else can be calling
iget.

So I think we can grab the inode in the same transaction as the inode
core repairs.  Nobody else should even be able to see that inode, so it
should be safe to grab i_rwsem before committing the transaction.  Even
if I have to use trylock in a loop to make lockdep happy.

I'll try that out and get back to you.

--D
