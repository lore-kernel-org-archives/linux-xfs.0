Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79A183CC3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Aug 2025 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754385797; cv=none; b=G80+lPNGH9XwZLXbq0l5DHV9/ULURTR7rnRGb8b4Y4XOycmoTjfmi8WCyA2V39Qhmxr/eHn/9CVgMQwmHAZY81RCOWH5gVvlBzLq9nxf7JS2ZcgyP4LR17/NWxn6K+TKBIXB9jWeMiNN3ot7GirI4+VOnLXJINeaSPYraXB7tmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754385797; c=relaxed/simple;
	bh=A5MI7v359iM3G3rBq/m8vB+Y0UYslOKxRDR9fnz9Y2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujdqQz4a1RSC2VxqbR1kesbF/CxBWRAVseFI+ZBRwNny76HdR51CAS49JPtQvZDdji9IHFYpR+srH1wgAx5/xj0hZrUFGQb0KrJ03cWcYznb97KfR8zfaXy6EEvWKRJIiXtlCqmU2XhNYD5BJg5fMqoMmszITtrsN66oRntze1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qx72LsuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx72LsuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A522C4CEF0;
	Tue,  5 Aug 2025 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754385796;
	bh=A5MI7v359iM3G3rBq/m8vB+Y0UYslOKxRDR9fnz9Y2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qx72LsuQ+7Y4KpZ3trUgd4Oxx4USvO5OubywiZubVwoo8be7AEsPdIoR0X7vjc089
	 GzY+Rv8OnDUA9DY3Hy5/n1+4wmll1vm0t8gQXs8GbWinwkQ7BbpBZUvVrGIlx50cjg
	 19h9QLxGSO1p+DMH0/Ipy03DMwreyrv9rlvRlilR5RRXyCmnKfgBexrTeUR8fzD9l2
	 UAQN7vaZa+mBJUmL+FpNgObJrE66MvD36RlJZH2NkcnF/UBd0TIY66b2EJfRdzjCsK
	 vXkaDlVvVDu+oRr6YJ2DeDn/kqDnZt33AkPRJeBAFC9oLebscHNtvH82JQEB0y0fWV
	 8eMDwijWZm2Wg==
Date: Tue, 5 Aug 2025 11:23:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cen zhang <zzzccc427@gmail.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK*
 flags
Message-ID: <2l7t2mjaunavutfcd4m4zoi72fg3zwkz5hjkrasc56oqrmapdm@io4mnxkj7qkl>
References: <20250723122011.3178474-1-hch@lst.de>
 <20250723122011.3178474-2-hch@lst.de>
 <SBKKojj1Lc3l2YnWc7kYcOBZhpRIoIg3xPRaJmgpmyLEWYhZICUIBe5RlbF7dBQon0yC87SO_27SUZl7_aQxTw==@protonmail.internalid>
 <20250723162047.GX2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723162047.GX2672049@frogsfrogsfrogs>

On Wed, Jul 23, 2025 at 09:20:47AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 23, 2025 at 02:19:44PM +0200, Christoph Hellwig wrote:
> > Fix up xfs_inumbers to now pass in the XFS_IBULK* flags into the flags
> > argument to xfs_inobt_walk, which expects the XFS_IWALK* flags.
> >
> > Currently passing the wrong flags works for non-debug builds because
> > the only XFS_IWALK* flag has the same encoding as the corresponding
> > XFS_IBULK* flag, but in debug builds it can trigger an assert that no
> > incorrect flag is passed.  Instead just extra the relevant flag.
> >
> > Fixes: 5b35d922c52798 ("xfs: Decouple XFS_IBULK flags from XFS_IWALK flags")
> > Reported-by: cen zhang <zzzccc427@gmail.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'd prefer this come with the
> Cc: <stable@vger.kernel.org> # v5.19
> so that I don't have to manually backport this to 6.12

Done.


> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_itable.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index c8c9b8d8309f..5116842420b2 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -447,17 +447,21 @@ xfs_inumbers(
> >  		.breq		= breq,
> >  	};
> >  	struct xfs_trans	*tp;
> > +	unsigned int		iwalk_flags = 0;
> >  	int			error = 0;
> >
> >  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
> >  		return 0;
> >
> > +	if (breq->flags & XFS_IBULK_SAME_AG)
> > +		iwalk_flags |= XFS_IWALK_SAME_AG;
> > +
> >  	/*
> >  	 * Grab an empty transaction so that we can use its recursive buffer
> >  	 * locking abilities to detect cycles in the inobt without deadlocking.
> >  	 */
> >  	tp = xfs_trans_alloc_empty(breq->mp);
> > -	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
> > +	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
> >  			xfs_inumbers_walk, breq->icount, &ic);
> >  	xfs_trans_cancel(tp);
> >
> > --
> > 2.47.2
> >
> >
> 
