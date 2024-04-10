Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA68640870
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 23:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712792078; cv=none; b=S9b8AwCXrJAbm49ZR8OKJoQ/5xSCmXORWiYNHc65DD09ZCsH9W2BVFeHVa7t8TdgeeueX/vyYVLsUGcAzgKDcP4i2j9mzdEWNK0z+Nl8MXlqeobGg0ITocwX9ViO31BxUx5d9znF9Ha9eikayqXo2zpoom+AXSQV6fQ5kzo48B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712792078; c=relaxed/simple;
	bh=SreCLicxd38tH3sYlh+zkdRvIsMK+Uine7uZUlT6p7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9ibWDwh9PK7ovefcWiYZb2ldpcOy3DFRgNmSjibLdLhMqsUcdl+wxv2uMp6QX2EvbWwRD7wk0puUpZAugWzb8xgBSvifWSPyGq4BPDChmoOBILEmfsavWFvpyGhxH0SwkIsZ052uUtABrq7CAkLLa7Ly7lHiP7l3UIjxMU8+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAe7NXvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAe7NXvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AE6C433C7;
	Wed, 10 Apr 2024 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712792078;
	bh=SreCLicxd38tH3sYlh+zkdRvIsMK+Uine7uZUlT6p7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KAe7NXvKHhONAFn6u9eJ/SsAty6pwEZ+7kATfchNOp286Q7PIch2D2tNi35gvjhAG
	 k/d6yzg702Lr41wr2rdGREBb1dELfeBT0O3xNW/yiqzgBdIczr1sN51YGJCUMqwTKq
	 Sm6/+qhUYyvWtNenBMJytpFgJDZ1+UfwRqC7aPHDS2MgDAwDbLcynU1NfD+PvK9HYM
	 w1d7QtOfcLx6BaiNY5xOR+D88TD39DKskVj56FZKSkZQgLfKrroagp9XqegLFxFt8Y
	 O/5HgFnp2EoYm+cQ9N041wscpboJ/vJyokxsy4N264dhpMXQr1M1/k0oIit6zGv57a
	 F+97mhGovWI6A==
Date: Wed, 10 Apr 2024 16:34:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240410233436.GO6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <ZhYr2PCHeVAdCn3K@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYr2PCHeVAdCn3K@infradead.org>

On Tue, Apr 09, 2024 at 11:04:08PM -0700, Christoph Hellwig wrote:
> Maybe replace the subject with 'add parent pointer listing ioctls' ?
> 
> On Tue, Apr 09, 2024 at 06:00:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This patch adds a pair of new file ioctls to retrieve the parent pointer
> > of a given inode.  They both return the same results, but one operates
> > on the file descriptor passed to ioctl() whereas the other allows the
> > caller to specify a file handle for which the caller wants results.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > [djwong: adjust to new ondisk format, split ioctls]
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Note that the first signoff should always be from the patch author.
> as recorded in the From line.

Yeah.  At this point the ioctl is so much different from Allison's
original version that it doesn't make much sense to keep her as the
patch author or sob person.

> > +	/* Size of the gp_buffer in bytes */
> > +	__u32				gp_bufsize;
> > +
> > +	/* Must be set to zero */
> > +	__u64				__pad;
> 
> We don't really need this as padding.  If you want to keep it for
> extensibility (although I can't really think of anything to use it
> for in the future) it should probably be renamed to gp_reserved;

Eh, I'll keep it, just in case.  The getparents_by_handle aligns nicely
with a single cacheline. :P

> > +static inline struct xfs_getparents_rec *
> > +xfs_getparents_next_rec(struct xfs_getparents *gp,
> > +			struct xfs_getparents_rec *gpr)
> > +{
> > +	char *next = ((char *)gpr + gpr->gpr_reclen);
> > +	char *end = (char *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
> > +
> > +	if (next >= end)
> > +		return NULL;
> > +
> > +	return (struct xfs_getparents_rec *)next;
> 
> We rely on void pointer arithmetics everywhere in the kernel and
> xfsprogs, so maybe use that here and avoid the need for the cast
> at the end?

Hopefully our downstream users also have compilers that allow void
pointer arithmetic. ;)

> > + */
> > +int
> > +xfs_parent_from_xattr(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		attr_flags,
> > +	const unsigned char	*name,
> > +	unsigned int		namelen,
> > +	const void		*value,
> > +	unsigned int		valuelen,
> > +	xfs_ino_t		*parent_ino,
> > +	uint32_t		*parent_gen)
> > +{
> > +	const struct xfs_parent_rec	*rec = value;
> > +
> > +	if (!(attr_flags & XFS_ATTR_PARENT))
> > +		return 0;
> 
> I wonder if this check should move to the callers.  That makes the
> calling conventions a lot simpler, and I think it probably makes
> the code a bit easier to follow as well.  But I'm not entirely sure
> either and open for arguments.

Yeah, on further thought I don't like the 0/1 return value convention
and will change that to require callers to screen for ATTR_PARENT.

> > +static inline unsigned int
> > +xfs_getparents_rec_sizeof(
> > +	unsigned int		namelen)
> > +{
> > +	return round_up(sizeof(struct xfs_getparents_rec) + namelen + 1,
> > +			sizeof(uint32_t));
> > +}
> 
> As we marked the xfs_getparents_rec as __packed we shouldn't really
> need the alignment here.  Or if we align, it should be to 8 bytes,
> in which case we don't need to pack it.

Let's align it to u64; everything else is.

> > +	unsigned short			reclen = xfs_getparents_rec_sizeof(namelen);
> 
> Please avoid the overly long line here.

Fixed.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
