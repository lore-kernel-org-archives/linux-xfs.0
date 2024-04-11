Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96AAD5B
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 00:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712797182; cv=none; b=sigQuqWmJSCMnBfAm42o5HJOyEI7QbURAc2fKKcHTyDR5X1ouu3UpQjGc3tB7+LIBEgsxD1RJ/nM0nCACrjXnG6ifO92wnVgZHCz/FYJ93IzrLhTjt8YtrICxycFupGH/r0xUn+YgKJhFbhS04AxpfxNwz3LIW4Vh3zVZF/WcDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712797182; c=relaxed/simple;
	bh=4KkPv/jsWTFgFVAJcyDrjL4XK5C5NEU06co4yzHa4vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayECkmefIi1ZUbIePhl8hQ8gaN8X42mrK1cZCc0mW+7YT3mYh603sCZ7BdiRZmpXFP+9Zfy8TM0lOPkHs2ySFhNWcAIaM88l93NVPJH7C5Jd1j39g9w5mRX5WeJsGRzcSimnufMnKRVtI1Cd4g5yY/T9rmBv1M2+29DI9njZ00I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeB1vp47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeB1vp47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A24C433C7;
	Thu, 11 Apr 2024 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712797182;
	bh=4KkPv/jsWTFgFVAJcyDrjL4XK5C5NEU06co4yzHa4vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FeB1vp47Uz4LgU0Gq+HkS0GmROMV24jMqfEnPszFhfnXlgLtP+sErWjdLNN2/qzFp
	 ExS70SFxlucpaY/UDFiN9um03q9OlJ+1x5I19yhIx68ZEEedsEUSWRBpC2zdhnHeOr
	 w+hEDpjaixKP17uLyjQ4T3ZwaHTCTE50kJ4eZidO6BZcACkYb66nID8TPZfSqqLU7F
	 vGALKWHsj7zwmf+HfgUuTAHmfd810ddIIry/Ybp6DHwUYSJ80N1VOJt2DtGcAUOUAf
	 kXpsoouC1j8cqSrQPxgT2m9K+kvGjYPURpQbO2Jb2g7FYAXxdUY3iMYBesxRealHw0
	 AQnbcrxa8jarw==
Date: Wed, 10 Apr 2024 17:59:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: introduce vectored scrub mode
Message-ID: <20240411005941.GQ6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972051.3634974.4637574179795648493.stgit@frogsfrogsfrogs>
 <Zhapez1auz_thPN1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zhapez1auz_thPN1@infradead.org>

On Wed, Apr 10, 2024 at 08:00:11AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 06:08:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
> > mode.  The caller specifies the principal metadata object that they want
> > to scrub (allocation group, inode, etc.) once, followed by an array of
> > scrub types they want called on that object.  The kernel runs the scrub
> > operations and writes the output flags and errno code to the
> > corresponding array element.
> > 
> > A new pseudo scrub type BARRIER is introduced to force the kernel to
> > return to userspace if any corruptions have been found when scrubbing
> > the previous scrub types in the array.  This enables userspace to
> > schedule, for example, the sequence:
> > 
> >  1. data fork
> >  2. barrier
> >  3. directory
> > 
> > If the data fork scrub is clean, then the kernel will perform the
> > directory scrub.  If not, the barrier in 2 will exit back to userspace.
> > 
> > When running fstests in "rebuild all metadata after each test" mode, I
> > observed a 10% reduction in runtime due to fewer transitions across the
> > system call boundary.
> 
> Just curius: what is the benefit over shaving a scruball $OBJECT interface
> where the above order is encoded in the kernel instead of in the
> scrub tool?

I thought about designing this interface that way, where userspace
passes a pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  I didn't like that, because now the kernel has to have a way to
communicate that the buffer needed to have been at least X size, even
though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.

Better, I thought, to let userspace figure out what it wants to run, and
tell that explicitly to the kernel, and then the kernel can just do
that.  The downside is that now we need the barriers.

> > +	BUILD_BUG_ON(sizeof(struct xfs_scrub_vec_head) ==
> > +		     sizeof(struct xfs_scrub_metadata));
> > +	BUILD_BUG_ON(XFS_IOC_SCRUB_METADATA == XFS_IOC_SCRUBV_METADATA);
> 
> What is the point of these BUILD_BUG_ONs?

Reusing the same ioctl number instead of burning another one.  It's not
really necessary I suppose.

> > +	if (copy_from_user(&head, uhead, sizeof(head)))
> > +		return -EFAULT;
> > +
> > +	if (head.svh_reserved)
> > +		return -EINVAL;
> > +
> > +	bytes = sizeof_xfs_scrub_vec(head.svh_nr);
> > +	if (bytes > PAGE_SIZE)
> > +		return -ENOMEM;
> > +	vhead = kvmalloc(bytes, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> 
> Why __GFP_RETRY_MAYFAIL and not just a plain GFP_KERNEL?

Hmm.  At one point I convinced myself this was correct because it would
retry if the allocation failed but could still just fail.  But I guess
it tries "really" hard (so says memory-allocation.rst) sooo yeah
GFP_KERNEL it is then.

> > +	if (!vhead)
> > +		return -ENOMEM;
> > +	memcpy(vhead, &head, sizeof(struct xfs_scrub_vec_head));
> > +
> > +	if (copy_from_user(&vhead->svh_vecs, &uhead->svh_vecs,
> > +				head.svh_nr * sizeof(struct xfs_scrub_vec))) {
> 
> This should probably use array_size to better deal with overflows.

Yep.

> And maybe it should use an indirection for the vecs so that we can
> simply do a memdup_user to copy the entire array to kernel space?

Hmmm.  That's worth considering.  Heck, userspace is already declaring a
fugly structure like this:

struct scrubv_head {
	struct xfs_scrub_vec_head	head;
	struct xfs_scrub_vec		__vecs[XFS_SCRUB_TYPE_NR + 2];
};

Now the pointers are explicit rather than assuming that nobody will
silently reorder the fields here.  That alone is worth it.

--D
