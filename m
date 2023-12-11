Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D192955C02
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTsAhVrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D56C433C9;
	Mon, 11 Dec 2023 22:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702334884;
	bh=0FUTC9slUV/K63R/NQgyKtcsskyMyabvfsm4JRLktK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTsAhVrH0ZrJ2M0rwa+Fw2ikPPHOKWDAJzuNNcIKHU6q9K/JfDjPyCcVR3JFK/KAa
	 V1NlTPaAboG7trapHbgEwyH2v7c/282IG9lqN9HaK5lXyc6MGN7llg60NLkK3lDKb+
	 J3XrXwWL6bJ48YP3B6DOgAlKqxcXlym9OA7ufgbLfCab2yjQtG8b6zL5oI4oDI22Iy
	 EhNfQ8kjv85SS+fZZ5TGgcNWObATOWwGHMLN6C4FuwvyS46xRNOphEjH/jmxS0F9lR
	 sAFMzTkILEvLRsUuD9D9WsSHngxHgNKoPlmIYRs6ZOpmGvRMN5K+1bFlzM5/dvghQi
	 frrtvXEsWne7w==
Date: Mon, 11 Dec 2023 14:48:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: set inode sick state flags when we zap either
 ondisk fork
Message-ID: <20231211224803.GY361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666205.1182270.10061610128319408467.stgit@frogsfrogsfrogs>
 <ZXFfIl3yFsACbjf0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFfIl3yFsACbjf0@infradead.org>

On Wed, Dec 06, 2023 at 09:58:58PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2023 at 06:43:16PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Christoph asked for stronger protections against online repair zapping a
> > fork to get the inode to load vs. other threads trying to access the
> > partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
> > inode health flag whenever repair zaps a fork, and sprinkling checks for
> > that flag into the various file operations for things that don't like
> > handling an unexpected zero-extents fork.
> > 
> > In practice xfs_scrub will scrub and fix the forks almost immediately
> > after zapping them, so the window is very small.
> 
> This probably should be before the previous two patches, and the
> reordering seems easy enough.

Done.

> We should also have a blurb in the commit log and code that this flag
> right now is in-memory only and thus the zapped forks can leak through
> an unmount or crash.

Fixed.  The last paragraph now reads:

"In practice xfs_scrub will scrub and fix the forks almost immediately
after zapping them, so the window is very small.  However, if a crash or
unmount should occur, we can still detect these zapped inode forks by
looking for a zero-extents fork when data was expected."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Actually, I found a couple more bugs -- the checks for
XFS_SICK_INO_*FORK_ZAPPED in bmap.c that control setting the CORRUPT
flag should not do that if we're revalidating after a repair.  I decided
they should also be hoisted up to the xchk_bmap caller to avoid
splitting the logic:

/* Scrub an inode's data fork. */
int
xchk_bmap_data(
	struct xfs_scrub	*sc)
{
	int			error;

	/* Ignore old state if we're revalidating after a repair. */
	if (!(sc->flags & XREP_ALREADY_FIXED) &&
	    xfs_inode_has_sickness(sc->ip, XFS_SICK_INO_DFORK_ZAPPED)) {
		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
		return 0;
	}

	error = xchk_bmap(sc, XFS_DATA_FORK);
	if (error)
		return error;

	/* If the data fork is clean, it is clearly not zapped. */
	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_DFORK_ZAPPED);
	return 0;
}

--D
