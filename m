Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE8C3B6C15
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275570; cv=none; b=Vo5STI2NNjLizcGD76uv+wP2KzttMCM5dm/6BAwTVQgeKQfqrDQkDOFxXCEtvW7VouoWj5lCbSK4GniSVn95kmGZnmPbRl+aH1VRVP1bQxCeHcAm2YVRWbh3ll0aZY2hp+26G63DTzTrfrW/09C81w3fbrybBrYPtsgKwFhJr7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275570; c=relaxed/simple;
	bh=p2gVAZ3QQpixdG4p/MoiuW1rjGdVJU7VBpgVUNXaIDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOAkMFQVHbj6Jt7AiCtzL+Tf7oXyywrPFRd3FPLL+AttbUvYlCmPW2enDxgdgrhCaqDbMcYUtKtACqsuiF4SOQAogQWI2AILKTyhnFQcTp7PTHxvcpLhOC8IonOiFoYK13IeagnivWhux63WqU/hUImqpIf6BsfYAakGKb34P1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgY9/2EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgY9/2EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81931F000FF;
	Tue,  6 Oct 2026 08:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791275569;
	bh=l2JDpJk5XjEsgb8lu6NPuMMEvP/VaOw1Rx5Jh0FBWXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RgY9/2EYDuFZDcfysy9nBPC5qpe2cw+TRloMVXWQCmRd6EHA7sV0pI87w71Glrvr6
	 5rC+/NtyAipdZeqWpsZcKIlTrbkmsfO9M88FQ1hZlXavwKhaz2sgbcGCyjDCtg0P/D
	 k4yrAM1rKWCTzcGoO763ktYMMEPaxNFnIP7uXUtBPA7t2MRVgbWv0YTEWrUF5/vOqx
	 SYSLX8/vlpgHAtlMtcS/i2PTHU5sWjOq7LqVYmR+Z5/x5JpazBoyDptbxS4r9hAhRa
	 Uyd+ldQa+bDbYq5jxYr12eQOMKfHR2alYqd5pmzifqCX2wlNphSmLPAbtHJ+ixiXDP
	 oEUGJr2R1hnmQ==
Date: Tue, 6 Oct 2026 10:32:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <asSwijU34G7m5RiQ@cronus.toxiclabs.cc>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
 <20261005202059.GD2705364@frogsfrogsfrogs>
 <d68afc86-6510-45c4-a225-784e7f629a33@redhat.com>
 <20261005211741.GF1615495@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005211741.GF1615495@frogsfrogsfrogs>

On Mon, Oct 05, 2026 at 02:17:41PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 05, 2026 at 03:43:08PM -0500, Eric Sandeen wrote:
> > On 10/5/26 3:20 PM, Darrick J. Wong wrote:
> > > On Mon, Oct 05, 2026 at 02:11:37PM -0500, Eric Sandeen wrote:
> > >> The open-coded ~10 line series of steps to reset a fork to empty extents
> > >> format is repeated 3 times; factor this out into a helper to eliminate
> > >> cut and paste.
> > 
> > ...
> > 
> > >> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > >> index c2a437416227..8385308c852f 100644
> > >> --- a/fs/xfs/scrub/repair.c
> > >> +++ b/fs/xfs/scrub/repair.c
> > >> @@ -882,6 +882,32 @@ xrep_ino_ensure_extent_count(
> > >>  	return 0;
> > >>  }
> > >>  
> > >> +/* Discard the contents of this fork and initialize as empty extent-format. */
> > >> +void
> > >> +xrep_reset_fork_to_extents(
> > >> +	struct xfs_scrub	*sc,
> > >> +	int			whichfork)
> > >> +{
> > >> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
> > >> +	uint			ilog_flags = XFS_ILOG_CORE;
> > >> +
> > >> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> > >> +
> > >> +	if (whichfork == XFS_DATA_FORK)
> > >> +		ilog_flags |= XFS_ILOG_DDATA;
> > >> +	else
> > >> +		ilog_flags |= XFS_ILOG_ADATA;
> > > 
> > > Nit pick:
> > 
> > I thought about a case switch but it seemed excessive for 2 choices.
> > My ASSERT does make sure we have one or the other valid value... *shrug*
> > 
> > > 	switch (whichfork) {
> > > 	case XFS_DATA_FORK:
> > > 		ilog_flags |= XFS_ILOG_DDATA;
> > > 		break;
> > > 	case XFS_ATTR_FORK:
> > > 		ilog_flags |= XFS_ILOG_ADATA;
> > > 		break;
> > > 	default:
> > > 		ASSERT(0);
> > > 		return;
> > 

> > I guess this has the advantage of kinda handling an unknown whichfork or
> > XFS_COW_FORK, though who knows what happens to callers that get a do-nothing
> > return at that point?
> > > 	}
> 
> There shouldn't be any, I just thought it looks cleaner. :)

Perhaps...

ilog_flags |= (whichfork == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA)

?

But the switch indeed looks nicer.

> 
> --D
> 
> > > 
> > > Either way this looks like a good hoist to me, so
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > 
> > > --D
> > > 
> > >> +
> > >> +	xfs_idestroy_fork(ifp);
> > >> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> > >> +	ifp->if_nextents = 0;
> > >> +	ifp->if_bytes = 0;
> > >> +	ifp->if_data = NULL;
> > >> +	ifp->if_height = 0;
> > >> +
> > >> +	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
> > >> +}
> > >> +
> > >>  /*
> > >>   * Initialize all the btree cursors for an AG repair except for the btree that
> > >>   * we're rebuilding.
> > >> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > >> index 2bb125c4f9bf..c1ba462e4426 100644
> > >> --- a/fs/xfs/scrub/repair.h
> > >> +++ b/fs/xfs/scrub/repair.h
> > >> @@ -81,6 +81,7 @@ int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
> > >>  int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
> > >>  		xfs_extnum_t nextents);
> > >>  int xrep_reset_perag_resv(struct xfs_scrub *sc);
> > >> +void xrep_reset_fork_to_extents(struct xfs_scrub *sc, int whichfork);
> > >>  int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
> > >>  int xrep_metadata_inode_forks(struct xfs_scrub *sc);
> > >>  int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
> > >> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
> > >> index 181961364233..9f6901905bfd 100644
> > >> --- a/fs/xfs/scrub/symlink_repair.c
> > >> +++ b/fs/xfs/scrub/symlink_repair.c
> > >> @@ -303,20 +303,8 @@ xrep_symlink_swap_prep(
> > >>  	 * to an empty extent list in preparation for the atomic mapping
> > >>  	 * exchange.
> > >>  	 */
> > >> -	if (ip_local) {
> > >> -		struct xfs_ifork	*ifp;
> > >> -
> > >> -		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
> > >> -		xfs_idestroy_fork(ifp);
> > >> -		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> > >> -		ifp->if_nextents = 0;
> > >> -		ifp->if_bytes = 0;
> > >> -		ifp->if_data = NULL;
> > >> -		ifp->if_height = 0;
> > >> -
> > >> -		xfs_trans_log_inode(sc->tp, sc->ip,
> > >> -				XFS_ILOG_CORE | XFS_ILOG_DDATA);
> > >> -	}
> > >> +	if (ip_local)
> > >> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
> > >>  
> > >>  	return 0;
> > >>  }
> > >> -- 
> > >> 2.55.0
> > >>
> > >>
> > > 
> > 
> 
