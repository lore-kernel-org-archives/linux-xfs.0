Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfADXJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 18:09:39 -0500
Date: Fri, 4 Jan 2019 15:09:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs: scrub should flag dir/attr offsets that aren't
 mappable with xfs_dablk_t
Message-ID: <20190104230933.GE12689@magnolia>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630856305.14372.3244113773553269634.stgit@magnolia>
 <20190104183931.GJ16751@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104183931.GJ16751@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:39:31PM -0500, Brian Foster wrote:
> On Mon, Dec 31, 2018 at 06:09:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach scrub to flag extent maps that exceed the range that can be mapped
> > with a xfs_dablk_t.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_types.c |   11 +++++++++++
> >  fs/xfs/libxfs/xfs_types.h |    1 +
> >  fs/xfs/scrub/bmap.c       |   27 +++++++++++++++++++++++++++
> >  3 files changed, 39 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> > index 3306fc42cfad..8e03e88a2f1a 100644
> > --- a/fs/xfs/libxfs/xfs_types.c
> > +++ b/fs/xfs/libxfs/xfs_types.c
> > @@ -204,3 +204,14 @@ xfs_verify_icount(
> >  	xfs_icount_range(mp, &min, &max);
> >  	return icount >= min && icount <= max;
> >  }
> > +
> > +/* Sanity-checking of dir/attr block offsets. */
> > +bool
> > +xfs_verify_dablk(
> > +	struct xfs_mount	*mp,
> > +	xfs_fileoff_t		dabno)
> > +{
> > +	xfs_dablk_t		max_dablk = -1U;
> > +
> > +	return dabno < max_dablk;
> 
> Should that be <= ?

Yeah.  Thanks for catching that.

/me notes that xfs_repair doesn't seem to check dablk offsets at all.

Anyway, thanks for the review!  I'll resend the patches that need a v2
early next week.

--D

> Brian
> 
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 8f02855a019a..704b4f308780 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -188,5 +188,6 @@ bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
> >  bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
> >  bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> >  bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
> > +bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
> >  
> >  #endif	/* __XFS_TYPES_H__ */
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index e1d11f3223e3..a703cd58a90e 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -281,6 +281,31 @@ xchk_bmap_extent_xref(
> >  	xchk_ag_free(info->sc, &info->sc->sa);
> >  }
> >  
> > +/*
> > + * Directories and attr forks should never have blocks that can't be addressed
> > + * by a xfs_dablk_t.
> > + */
> > +STATIC void
> > +xchk_bmap_dirattr_extent(
> > +	struct xfs_inode	*ip,
> > +	struct xchk_bmap_info	*info,
> > +	struct xfs_bmbt_irec	*irec)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_fileoff_t		off;
> > +
> > +	if (!S_ISDIR(VFS_I(ip)->i_mode) && info->whichfork != XFS_ATTR_FORK)
> > +		return;
> > +
> > +	if (!xfs_verify_dablk(mp, irec->br_startoff))
> > +		xchk_fblock_set_corrupt(info->sc, info->whichfork,
> > +				irec->br_startoff);
> > +
> > +	off = irec->br_startoff + irec->br_blockcount - 1;
> > +	if (!xfs_verify_dablk(mp, off))
> > +		xchk_fblock_set_corrupt(info->sc, info->whichfork, off);
> > +}
> > +
> >  /* Scrub a single extent record. */
> >  STATIC int
> >  xchk_bmap_extent(
> > @@ -305,6 +330,8 @@ xchk_bmap_extent(
> >  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
> >  				irec->br_startoff);
> >  
> > +	xchk_bmap_dirattr_extent(ip, info, irec);
> > +
> >  	/* There should never be a "hole" extent in either extent list. */
> >  	if (irec->br_startblock == HOLESTARTBLOCK)
> >  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
> > 
