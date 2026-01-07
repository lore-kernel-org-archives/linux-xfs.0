Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D992DDAB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744548; cv=none; b=YLVJgN8vdzdCzfyfaacDkLnttknGpPpsZ0ztAO7GNsXwifs9VM6Grg+SkG0i4EzRJ/cbhYHwhFDmt0qtu2d9qvzSdwiM0JT6qiBAZ0gxnNdYoC2vsnBwkZFeDctaz5WuytPKwic88wy/UHAVQV5q9dHSskqDpl98OGvEY0zCqzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744548; c=relaxed/simple;
	bh=9Bj08OadzVnpTvOQmSUKiKcePeo5yRefxKMh1MRaELM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArVt1ba7HUZAMPOHkr5ZWaNb+9PIeaVlTOENwl3eTq6yMp6YIua1dJXHI2C6ht59s/rhPdLwR41PxiiDCA3CGkbetGd+uaUYe1OLXUcbVJdEemysQ161gB49wVxxEh7VIooce2hKmRmSE/QhubkNmWFLIj+UYAx8D37a9Q7hA+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiQCREoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiQCREoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95F4C116C6;
	Wed,  7 Jan 2026 00:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767744547;
	bh=9Bj08OadzVnpTvOQmSUKiKcePeo5yRefxKMh1MRaELM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WiQCREoeMNCoob4G21ijtI1g+Z+14UIU3CehlkCVhGdIw5MuoIYDCLZmVrEXsvKGP
	 zE1dyi2kV/FnH4SZw1K3NeHTutXl2xIjEeaGNVAW6h00mPGlA9iUX/Y6UPoq8as2Gf
	 JAavYu3qLnpAao9zyspBEqnLlwGAeV8F+v/e7eEElH0qqcXlhQxzNjmKHlSpAknFvu
	 VWIYkDA6ZLh6cb+dtjdNqJjeLoog6Og9Guyv6zNfVhefb8PsrQ8sN8TggA5dUwj6m2
	 NW2gRpqE0nojG6bPWdW9A1TRtkFROAtvs4PLQh2D4n8JtDiLRKlX3FVlIHUQjxSJAp
	 WLTy6MpQDJBaw==
Date: Tue, 6 Jan 2026 16:09:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <20260107000907.GM191501@frogsfrogsfrogs>
References: <20251219154154.GP7753@frogsfrogsfrogs>
 <aVzE-5gMi1IHOLTW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVzE-5gMi1IHOLTW@infradead.org>

On Tue, Jan 06, 2026 at 12:16:59AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 19, 2025 at 07:41:54AM -0800, Darrick J. Wong wrote:
> > Now parent pointers only increase the system time by 8% for creation and
> > 19% for deletion.  Wall time increases by 5% and 9%.
> 
> Nice!
> 
> > @@ -202,6 +203,16 @@ xfs_parent_addname(
> >  	xfs_inode_to_parent_rec(&ppargs->rec, dp);
> >  	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
> >  			child->i_ino, parent_name);
> > +
> > +	if (xfs_inode_has_attr_fork(child) &&
> > +	    xfs_attr_is_shortform(child)) {
> > +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
> > +
> > +		error = xfs_attr_try_sf_addname(&ppargs->args);
> > +		if (error != -ENOSPC)
> > +			return error;
> > +	}
> > +
> >  	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
> 
> We should be able to do this for all attrs, not just parent pointers,
> right?

In principle, yes.  For a generic xattr version you'd probably want to
check for a large valuelen on the set side so that we don't waste time
scanning the sf structure when we're just going to end up in remote
value territory anyway.

>         It might be nice to just do this for set and remove in
> xfs_attr_defer_add and have it handle all attr operations.

Yeah.  I think it's more logical to put these new shortcut calls in
xfs_attr_set because we're be deciding /not/ to invoke the deferred
xattr mechanism.

> > +	if (xfs_attr_is_shortform(child)) {
> > +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> > +
> > +		error = xfs_attr_sf_removename(&ppargs->args);
> > +		if (error)
> > +			return error;
> > +
> > +		xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->new_rec,
> > +				child, child->i_ino, new_name);
> > +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
> > +
> > +		error = xfs_attr_try_sf_addname(&ppargs->args);
> > +		if (error == -ENOSPC) {
> > +			xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
> > +			return 0;
> > +		}
> 
> And for replace we should be able to optimize this even further
> by adding a new xfs_attr_sf_replacename that just checks if the new
> version would fit, and then memmove everything behind the changed
> attr and update it in place.  This should improve the operation a lot
> more.

That would depends on the frequency of non-parent pointer xattr
operations where the value doesn't change size modulo the rounding
factor.

I also wonder how much benefit anyone really gets from doing this to
regular xattrs, but once I'm more convinced that it's solid w.r.t.
parent pointers it's trivial to move it to xattrs too.

--D
