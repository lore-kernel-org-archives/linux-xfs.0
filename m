Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8333E3C5F
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791235066; cv=none; b=Rro6ZPW7cZth0FOPEMiWtDs+uT4eC4aOASR43hOXcgFDjmvlYVixmdqDiHg6u1aJwC5RypgfK8qptD5yfr3bEdWVzrnlrrDgRDRW+I5QPiNUrFhDu+fJI4eahBWoVZ5uofwmuVEUJ3G0vgK4zQYiSH33a+JnwDrTOrp8d0A8gV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791235066; c=relaxed/simple;
	bh=+bIQPeeTCCiwiYgSeQPpF2D/5QfsTpYH4rSq0or8lkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsikiUxLxys/pwCfLdAB1gqXRvVNBuZRx4GfZmtWUEQqpwXNu4u6bKE+mpQjwviyC1Zgbo+qmI3s2MO9+A6LtoOZGmMGul9Kwr6MYmQZZaL26x9nx94nPUksy0Jn166Wgtc0/hcgB8IL8m+DQJHLficfTf+eUN7++xXYffs064k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cH00h19F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cH00h19F"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 662181F000FF;
	Mon,  5 Oct 2026 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791235062;
	bh=bkDrF+8PHHRKGSs5WUksYXplIsrI/ZQD/FebyiW4SkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cH00h19F1PvnOrqb7J9By+gaZBZbVjljOWFeuDJ/8HMoHv+VBsPNj2slhNru/dQBT
	 gglPn8qPwV0TBokGv3ux+HOjU4GzZ24VKdRtZDTlDPaEk2WjyYPpV2z7iDzdXcqChc
	 zkEB2TLsnKUHr2EGhF9MXshCPxcb/ATxqqwHmp8LGW5+tcbUt4cqSSLPC/zvj9dVku
	 vLzcrlDAoYkZAJ6x1Emdnf6p59oE+jAzM1jh7JrMyQ9/o16QqOhbvaPKUUf4pJii77
	 /3MWfbnKuQJACbfcSz5/4d1SObXCNZA79vuxipXvb/cniLtpUy1HahEabdqJTq8v0v
	 NweJg1P4KT7kw==
Date: Mon, 5 Oct 2026 14:17:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <20261005211741.GF1615495@frogsfrogsfrogs>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
 <20261005202059.GD2705364@frogsfrogsfrogs>
 <d68afc86-6510-45c4-a225-784e7f629a33@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d68afc86-6510-45c4-a225-784e7f629a33@redhat.com>

On Mon, Oct 05, 2026 at 03:43:08PM -0500, Eric Sandeen wrote:
> On 10/5/26 3:20 PM, Darrick J. Wong wrote:
> > On Mon, Oct 05, 2026 at 02:11:37PM -0500, Eric Sandeen wrote:
> >> The open-coded ~10 line series of steps to reset a fork to empty extents
> >> format is repeated 3 times; factor this out into a helper to eliminate
> >> cut and paste.
> 
> ...
> 
> >> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> >> index c2a437416227..8385308c852f 100644
> >> --- a/fs/xfs/scrub/repair.c
> >> +++ b/fs/xfs/scrub/repair.c
> >> @@ -882,6 +882,32 @@ xrep_ino_ensure_extent_count(
> >>  	return 0;
> >>  }
> >>  
> >> +/* Discard the contents of this fork and initialize as empty extent-format. */
> >> +void
> >> +xrep_reset_fork_to_extents(
> >> +	struct xfs_scrub	*sc,
> >> +	int			whichfork)
> >> +{
> >> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
> >> +	uint			ilog_flags = XFS_ILOG_CORE;
> >> +
> >> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> >> +
> >> +	if (whichfork == XFS_DATA_FORK)
> >> +		ilog_flags |= XFS_ILOG_DDATA;
> >> +	else
> >> +		ilog_flags |= XFS_ILOG_ADATA;
> > 
> > Nit pick:
> 
> I thought about a case switch but it seemed excessive for 2 choices.
> My ASSERT does make sure we have one or the other valid value... *shrug*
> 
> > 	switch (whichfork) {
> > 	case XFS_DATA_FORK:
> > 		ilog_flags |= XFS_ILOG_DDATA;
> > 		break;
> > 	case XFS_ATTR_FORK:
> > 		ilog_flags |= XFS_ILOG_ADATA;
> > 		break;
> > 	default:
> > 		ASSERT(0);
> > 		return;
> 
> I guess this has the advantage of kinda handling an unknown whichfork or
> XFS_COW_FORK, though who knows what happens to callers that get a do-nothing
> return at that point?
> > 	}

There shouldn't be any, I just thought it looks cleaner. :)

--D

> > 
> > Either way this looks like a good hoist to me, so
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > --D
> > 
> >> +
> >> +	xfs_idestroy_fork(ifp);
> >> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> >> +	ifp->if_nextents = 0;
> >> +	ifp->if_bytes = 0;
> >> +	ifp->if_data = NULL;
> >> +	ifp->if_height = 0;
> >> +
> >> +	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
> >> +}
> >> +
> >>  /*
> >>   * Initialize all the btree cursors for an AG repair except for the btree that
> >>   * we're rebuilding.
> >> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> >> index 2bb125c4f9bf..c1ba462e4426 100644
> >> --- a/fs/xfs/scrub/repair.h
> >> +++ b/fs/xfs/scrub/repair.h
> >> @@ -81,6 +81,7 @@ int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
> >>  int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
> >>  		xfs_extnum_t nextents);
> >>  int xrep_reset_perag_resv(struct xfs_scrub *sc);
> >> +void xrep_reset_fork_to_extents(struct xfs_scrub *sc, int whichfork);
> >>  int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
> >>  int xrep_metadata_inode_forks(struct xfs_scrub *sc);
> >>  int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
> >> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
> >> index 181961364233..9f6901905bfd 100644
> >> --- a/fs/xfs/scrub/symlink_repair.c
> >> +++ b/fs/xfs/scrub/symlink_repair.c
> >> @@ -303,20 +303,8 @@ xrep_symlink_swap_prep(
> >>  	 * to an empty extent list in preparation for the atomic mapping
> >>  	 * exchange.
> >>  	 */
> >> -	if (ip_local) {
> >> -		struct xfs_ifork	*ifp;
> >> -
> >> -		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
> >> -		xfs_idestroy_fork(ifp);
> >> -		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> >> -		ifp->if_nextents = 0;
> >> -		ifp->if_bytes = 0;
> >> -		ifp->if_data = NULL;
> >> -		ifp->if_height = 0;
> >> -
> >> -		xfs_trans_log_inode(sc->tp, sc->ip,
> >> -				XFS_ILOG_CORE | XFS_ILOG_DDATA);
> >> -	}
> >> +	if (ip_local)
> >> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
> >>  
> >>  	return 0;
> >>  }
> >> -- 
> >> 2.55.0
> >>
> >>
> > 
> 
