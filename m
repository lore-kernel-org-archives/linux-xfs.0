Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55882931F5;
	Tue, 25 Aug 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681542; cv=none; b=ENTZz0vjmWpmaDlP108wQk4pikZ9v4qGMVsNidco7XaRXfeSy+4TvzaTWVCNeOrhowty2LtKWI7soAFPGLd6x5pp932JFY4lP5T758Qx3eMDpbX5aHGvikIcp1SbHCyXbW65q2uliFBdjJ4dUfv02kIgm88LLzZ9VmK3btdN3oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681542; c=relaxed/simple;
	bh=QooTYtJ3bN8dIYgEz0Us/zJUft017MDHBeFReDpsUxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oslB93oE72Ct5wNLbM3poFzxoru1Luc2FIFhhszWokHBKfuJ5j/4pN9CRXbuEkQv4HZNzdP1iBdXkOGuaBBjI08OMBrx/9ieg7ZpmgH165wc+BjvlJq8/Ke68ZeUGCIB5Qr9zthzc0uUMGz1jkl7MLdsav52+HsdC00PIAHz7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CL+JBC6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CL+JBC6y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8506A1F000E9;
	Tue, 25 Aug 2026 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787681541;
	bh=k5m5pg3Y1ygF1RpXEmC6vFAt2uPfAQBKYmg95DKKdFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CL+JBC6y+S8lCHGtMg7Egh/MONhExuBV7phS+VcC9Hb6FWJVoqTNzMoSVzOib8rrL
	 zyesyc9FLA0rGKTFjazMr14Z2lqr5DzmQakM5znVHgJne/NcBcVUUXXvlnkEQ1t79F
	 w2g3nULtL5gCOWUz1Xpjh6UETTUoiJX/VlUZ3XpBNtnU0kXkBbTL3h1kCgMWroG/63
	 SyaVOUzl2ExjhfaEl/ANyU1ZtLQyzF+hEk+KU2/7gLbO5Y1C2rItL+Wwd1owV4Butq
	 h4cTvJdXxmX6X2T10yDgbEROiQKciDCyIWG6VEWYqx1X5laxTH4MYcV5AcMOXF4qQ3
	 9bcix/9vCryAw==
Date: Tue, 25 Aug 2026 11:12:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't stash removename operations with unknown
 ftype
Message-ID: <20260825181221.GT6072@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940721.944084.7350116310283813250.stgit@frogsfrogsfrogs>
 <20260825062800.GB24324@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825062800.GB24324@lst.de>

On Tue, Aug 25, 2026 at 08:28:00AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:34:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM notices that the behavior of xrep_dir_replay_update changes based
> > on the ftype recorded in the stashed removename information.  It also
> > notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
> > because the regular directory tree update code paths don't need to know
> > the ftype of the child.
> > 
> > Unfortunately, this results in incorrect link counts, which eventually
> > trips link count errors in later phases of xfs_scrub, or in xfs_repair.
> > Fix this.
> 
> Fix what?
> 
> > @@ -1381,9 +1381,24 @@ xrep_dir_live_update(
> >  		if (p->delta > 0)
> >  			error = xrep_dir_stash_createname(rd, p->name,
> >  					I_INO(p->ip));
> > -		else
> > -			error = xrep_dir_stash_removename(rd, p->name,
> > +		else {
> > +			/*
> > +			 * xfs_dentry_to_name in unlink or rename-exchange can
> > +			 * pass us names with ftype FT_UNKNOWN, but we really
> > +			 * must know the ftype of the child that is being
> > +			 * removed so that we can do nlink updates correctly
> > +			 * without holding inode references.
> > +			 */
> > +			struct xfs_name	name = {
> > +				.name	= p->name->name,
> > +				.len	= p->name->len,
> > +				.type	= xfs_mode_to_ftype(
> > +						VFS_IC(p->ip)->i_mode),
> > +			};
> 
> .. fix up the xfs_name to always have the correct type is I guess what
> the commit log should say.

I'll expand that last sentence to read:
"Fix this by creating a second xfs_name with the type set correctly."

> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
