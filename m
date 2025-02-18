Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5996D26A098
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894050; cv=none; b=Su+BIr7j0pzuPSrC9H7h4A0Xr6nHlXhdgV+76GUPKnkVVgqreN5ccjavARfzSdXwqgTGDcHO4pk3v4dO0V08kqyCmzq7ABsYS4xKfMkVebXDQ6NsmV+s9sIGsMcaQLnh4Y8NclAB335w3CSw7ZI7L9WZoxM2+pzRQy1G4/M+Xfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894050; c=relaxed/simple;
	bh=0gq/zTud3d2Ghoa7koHzxDzKXtSaPfJEG2L18tMAJV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJyHg8Jb9awtRNuVVFqdokBQj1OZu0pJQ96wvhX6Azek+Y20pNjdBHB/1oMnO09BmwAf37d1cR+Stj2bOW+EzNEAHFp299OlJZmZg1sTVeq/jmbmRKJVMGMh5ZypPxbAhIi30GtAPh+yUIV5pokmfnP2j7X/qVyU3vZbCiF3ito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw7JoLqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw7JoLqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3F0C4CEE2;
	Tue, 18 Feb 2025 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739894049;
	bh=0gq/zTud3d2Ghoa7koHzxDzKXtSaPfJEG2L18tMAJV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fw7JoLqbr7i7w/WJOK60VBaBT2GHoYuoMvxU4ZNRy7r2QZDUlt75eTexE4C1BqEpI
	 IOc3qA90qmks9DBKs9QFvL0BL7CUym5zaDmBFyI6nHJe5uXwSNbE/vR67mHcD102dm
	 LeBYwKPXn0AUOs5kIQZT52zjKk8NhuDmM1x91eRfNFG5bxbT6eEUzg/3VTBeOQxQw2
	 MPixQ0fb37mdGq8WMTjDRy80t50qOrW8aN6+NbIu7FrW+zlO9xlty7USEPPZiWfKVv
	 COIrpRqoVUXmf749tNie2xNi0txTZMuiiYVVQixTFTsJ/v0hiN3MONR7g0lUOwIGG+
	 yH1towc6S7yHw==
Date: Tue, 18 Feb 2025 07:54:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <20250218155409.GQ3028674@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7RGkVLW13HPXAb-@infradead.org>

On Tue, Feb 18, 2025 at 12:36:33AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 03:03:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Aheada of deprecating V4 support in the kernel, let's give people a way
> > to extract their files from a filesystem without needing to mount.
> 
> So I've wanted a userspace file access for a while, but if we deprecate
> the v4 support in the kernel that will propagte to libxfs quickly,
> and this code won't help you with v4 file systems either.  So I don't
> think the rationale here seems very good.

We aren't removing V4 support from the kernel until September 2030 and
xfsprogs effectively builds with CONFIG_XFS_SUPPORT_V4=y.  That should
be enough time, right?

> >  extern void		bmapinflate_init(void);
> > +extern void		rdump_init(void);
> 
> No need for the extern.

Ok.

> > +	/* XXX cannot copy fsxattrs */
> 
> Should this be fixed first?  Or document in a full sentence comment
> explaining why it can't should not be?

	/* XXX cannot copy fsxattrs until setfsxattrat() syscall merge */

> > +		[1] = {
> > +			.tv_sec  = inode_get_mtime_sec(VFS_I(ip)),
> > +			.tv_nsec = inode_get_mtime_nsec(VFS_I(ip)),
> > +		},
> > +	};
> > +	int			ret;
> > +
> > +	/* XXX cannot copy ctime or btime */
> 
> Same for this and others.

Is there a way to set ctime or btime?  I don't know of any.

	/* Cannot set ctime or btime */

> > +	/* Format xattr name */
> > +	if (attr_flags & XFS_ATTR_ROOT)
> > +		nsp = XATTR_TRUSTED_PREFIX;
> > +	else if (attr_flags & XFS_ATTR_SECURE)
> > +		nsp = XATTR_SECURITY_PREFIX;
> > +	else
> > +		nsp = XATTR_USER_PREFIX;
> 
> Add a self-cotained helper for this?  I'm pretty sure we do this
> translation in a few places.

Ok.  I think at least scrub phase5 does this.

> > +	if (XFS_IS_REALTIME_INODE(ip))
> > +		btp = ip->i_mount->m_rtdev_targp;
> > +	else
> > +		btp = ip->i_mount->m_ddev_targp;
> 
> Should be move xfs_inode_buftarg from kernel code to common code?

Hmm.  The xfs_inode -> xfs_buftarg translation could be moved to
libxfs/xfs_inode_util.c, yes.  Though that can't happen until 6.15
because we're well past the merge window.  For now I think it's the only
place in xfsprogs where we do that.

--D
