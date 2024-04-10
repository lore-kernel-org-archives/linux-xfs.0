Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE8C181CE4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787525; cv=none; b=cm1elsD5/hi4e3nFOc54dsvyOUVc6Xgvyexh82RqCCqzYV5qszoRWjIbPAm9fgZ5HuhSFlCuB/IE0zwauzQ4eyKrJTsRBFvWDcJSPOX3Svla8rVQqAAeAfYd7T6PIApNi8n9dIdOgtIVwMzWlFmFLfYnAvkzuMNnnBnWvff0B8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787525; c=relaxed/simple;
	bh=cvoPn2N3keZ7BdXJJjT3aQJKwE1NFtZiBxNxwHXq4+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nsWTft0gIhEGSAxASVR/lFU/6eCJpiHiEh0I7GYBgeEmHIKxy5hx71h1UvDAu+PwF/FwUctYhjb/PCM1llM+t3ffkp11hQnD77CUHHQ4w7rZjJxuktG87XY3gmjHN5qbEzu2lOy2fDNj07i5tprQqKCXpHdTR741N9pWXDo7JX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isuhsl64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isuhsl64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA687C433F1;
	Wed, 10 Apr 2024 22:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712787524;
	bh=cvoPn2N3keZ7BdXJJjT3aQJKwE1NFtZiBxNxwHXq4+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isuhsl64jcewFZRB4ibjDKUuR2W1fTRGM11zONobajbpgqPvfRfvXYqkTQjWg/TzG
	 Gl2RXWakcPnKoRj/gVEHbd/1VZiVxUjSO5PEUOpY+54g3khKUltrEIsWPed/aGH1f4
	 lS3V88PhdKdQwGrLgBAEkoNQ5NZAuBnO1f62qSqqyzuSwTOA+5TkyhCyW8mGgAhqLQ
	 +219ReRzqMUC3L7zyPs1lR1qGXhtnpYagV8k5LFe6Y9I5aOz3wfdvCCXLtQAZOSxku
	 fityM+jwBo11fzs2TGFs2J/FjQFyESRXY9MvJ0Iv0DVWIS1PVdsmy82fn23lv1vxgT
	 r2Ay/KWyloNLA==
Date: Wed, 10 Apr 2024 15:18:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: add xattr setname and removename functions
 for internal users
Message-ID: <20240410221844.GL6390@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
 <ZhYvG1_eNLVKu3Ag@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYvG1_eNLVKu3Ag@infradead.org>

On Tue, Apr 09, 2024 at 11:18:03PM -0700, Christoph Hellwig wrote:
> > +static int
> > +xfs_attr_ensure_iext(
> > +	struct xfs_da_args	*args,
> > +	int			nr)
> > +{
> > +	int			error;
> > +
> > +	error = xfs_iext_count_may_overflow(args->dp, XFS_ATTR_FORK, nr);
> > +	if (error == -EFBIG)
> > +		return xfs_iext_count_upgrade(args->trans, args->dp, nr);
> > +	return error;
> > +}
> 
> I'd rather get my consolidation of these merged instead of adding
> a wrapper like this.  Just waiting for my RT delalloc and your
> exchrange series to hit for-next to resend it.

Yeah, I made a mental note to scrub this function out if your patch wins
the race.

> > +/*
> > + * Ensure that the xattr structure maps @args->name to @args->value.
> > + *
> > + * The caller must have initialized @args, attached dquots, and must not hold
> > + * any ILOCKs.  Only XATTR_CREATE may be specified in @args->xattr_flags.
> > + * Reserved data blocks may be used if @rsvd is set.
> > + *
> > + * Returns -EEXIST if XATTR_CREATE was specified and the name already exists.
> > + */
> > +int
> > +xfs_attr_setname(
> 
> Is there any case where we do not want to pass XATTR_CREATE, that
> is replace an existing attribute when there is one?

Yes, verity setup will use xfs_attr_setname to upsert a merkle tree
block into the attr structure and obliterate stale blocks that might
already have been there.

> > +int
> > +xfs_attr_removename(
> > +	struct xfs_da_args	*args,
> > +	bool			rsvd)
> > +{
> 
> Is there a good reason to have a separate remove helper and not
> overload a NULL value like we do for the normal xattr interface?

xfs_repair uses xfs_parent_unset -> xfs_attr_removename to erase any
XFS_ATTR_PARENT attribute that doesn't validate, so it needs to be able
to pass in a non-NULL value.  Perhaps I'll add a comment about that,
since this isn't the first time this has come up.

Come to think of it you can't removename a remote parent value, so I
guess in that bad case xfs_repair will have to drop the entire attr
structure <frown>.

/*
 * Ensure that the xattr structure does not map @args->name to @args->value.
 * @args->value must be set for XFS_ATTR_PARENT removal (e.g. xfs_repair).
 *
 * The caller must have initialized @args, attached dquots, and must not hold
 * any ILOCKs.  Reserved data blocks may be used if @rsvd is set.
 *
 * Returns -ENOATTR if the name did not already exist.
 */


--D
