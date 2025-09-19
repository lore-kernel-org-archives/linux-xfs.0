Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780521ABD0
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298099; cv=none; b=UmS9Neuawm960t48H3zeTcfRrtqqN+QRfZs4EXTbZroSaGi3mb44CttnuJINWUi55FMbt3M4wbFY/MrdPV9pJlHtUIm72QtGslaO6Ja9Ir/91pxHaWmGdmIECNtH4Ry+7zGQvlouI5p+AI5bvMD/Wr8bhOo9wtlDM0W4fThSfcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298099; c=relaxed/simple;
	bh=uNmC3iZCvbcnjwLgEqNfm/auw5jU4wcnD2ohqXtjrJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r15lQod8GqR6y6e14MIOJlEiblPjaJgk7JnLT0D19IXReiafUzLtopPqLGr2vpbvdu6afs2FuDjqLjfEc2pt1AQMaKu757Yi27RLe//gOJOU8BluNL2UFZ8uBfW7Q/l8e4VZ6DIqfxZ2aOWQhCmC6qnhpTDrECqZMXE9RZ9kvLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxS3zeOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxS3zeOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C925C4CEF5;
	Fri, 19 Sep 2025 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298099;
	bh=uNmC3iZCvbcnjwLgEqNfm/auw5jU4wcnD2ohqXtjrJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxS3zeOhaRlFBVRA+d3ja3HHo5IN4GJ2VdeEMHKW4WaMQZ1pGq7J8QlGM7qqvQ05c
	 XRaKQDVQHQRslc3w5M041Fv1qRj5SLQJKEwLBLpPAp+YUQGILBhSsTGlSBXjeAi3zu
	 sMuEBGuVcQA1af/FpVWsCLK0KLMYrVMndHxw7rdnX41sNppvVm0C3qE0gG0CkfYjNG
	 6sC8nP1E1Ocj8pdtemNfG2v67RxxbD24P2FTpFRou9GQI7p+ffCnk8BFjrggi4GYU1
	 utvdkyMfDcG+UY5R0j03ZSDWCUWq5khYLXOUBi7woe9dL5E6QBYph2TB3+GOzrI7F3
	 iGS9Bsa0Jwr+Q==
Date: Fri, 19 Sep 2025 09:08:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 1/2] xfs: rearrange code in xfs_inode_item_precommit
Message-ID: <20250919160818.GN8096@frogsfrogsfrogs>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-2-david@fromorbit.com>
 <aM10mF6U4qSb1eTp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aM10mF6U4qSb1eTp@infradead.org>

On Fri, Sep 19, 2025 at 08:19:52AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 18, 2025 at 08:12:53AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There are similar extsize checks and updates done inside and outside
> > the inode item lock, which could all be done under a single top
> > level logic branch outside the ili_lock. The COW extsize fixup can
> > potentially miss updating the XFS_ILOG_CORE in ili_fsync_fields, so
> > moving this code up above the ili_fsync_fields update could also be
> > considered a fix.
> > 
> > Further, to make the next change a bit cleaner, move where we
> > calculate the on-disk flag mask to after we attach the cluster
> > buffer to the the inode log item.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode_item.c | 65 ++++++++++++++++++-----------------------
> >  1 file changed, 29 insertions(+), 36 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index afb6cadf7793..318e7c68ec72 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -131,46 +131,28 @@ xfs_inode_item_precommit(
> >  	}
> >  
> >  	/*
> > +	 * Inode verifiers do not check that the extent size hints are an
> > +	 * integer multiple of the rt extent size on a directory with
> > +	 * rtinherit flags set.  If we're logging a directory that is
> > +	 * misconfigured in this way, clear the bad hints.
> >  	 */
> 
> Not directly related to this patch, but why are we not checking for
> that in the inode verifier?  Even if we can't reject that value,
> it seems like we should fix that up when reading an inode into memory
> instead of in a pre-commit hook?

growfs can change rtextsize when adding a rt section to the filesystem,
and we're not allowed to break userspace (even though I'd wager nobody
has actually done this in the past 20 years).

--D

> The patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
