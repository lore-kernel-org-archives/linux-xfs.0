Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbeGaBTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 21:19:09 -0400
Date: Mon, 30 Jul 2018 16:41:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: verify icount in superblock write
Message-ID: <20180730234138.GS30972@magnolia>
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
 <153292862751.19274.16285578072920087708.stgit@magnolia>
 <091b2c87-d6d1-e8c5-7ee7-175095252fe8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <091b2c87-d6d1-e8c5-7ee7-175095252fe8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>

On Mon, Jul 30, 2018 at 06:26:29PM -0500, Eric Sandeen wrote:
> On 7/30/18 12:30 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a helper predicate to check the inode count for sanity, then use it
> > in the superblock write verifier to inspect sb_icount.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c    |    1 +
> >  fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_types.h |    1 +
> >  3 files changed, 36 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 64bc471d57e6..e5972121e82d 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -160,6 +160,7 @@ xfs_validate_sb_write(
> >  	 * cases.
> >  	 */
> >  	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> > +	    !xfs_verify_icount(mp, sbp->sb_icount) ||
> >  	    sbp->sb_ifree > sbp->sb_icount) {
> >  		xfs_warn(mp, "SB summary counter sanity check failed");
> >  		return -EFSCORRUPTED;
> > diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> > index 2e2a243cef2e..57f4fd028898 100644
> > --- a/fs/xfs/libxfs/xfs_types.c
> > +++ b/fs/xfs/libxfs/xfs_types.c
> > @@ -171,3 +171,37 @@ xfs_verify_rtbno(
> >  {
> >  	return rtbno < mp->m_sb.sb_rblocks;
> >  }
> > +
> > +/* Calculate the range of valid icount values. */
> > +static void
> > +xfs_icount_range(
> > +	struct xfs_mount	*mp,
> > +	unsigned long long	*min,
> > +	unsigned long long	*max)
> > +{
> > +	unsigned long long	nr_inos = 0;
> > +	xfs_agnumber_t		agno;
> > +
> > +	/* root, rtbitmap, rtsum all live in the first chunk */
> > +	*min = XFS_INODES_PER_CHUNK;
> > +
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		xfs_agino_t	first, last;
> > +
> > +		xfs_agino_range(mp, agno, &first, &last);
> > +		nr_inos += last - first + 1;
> > +	}
> > +	*max = nr_inos;
> 
> I still think this is more work than we need to do for a verifier,
> TBH.
> 
> In practice how far off is this from do_div(dblocks, inodes_per_block) ?
> 
> Oh well.   I guess computationally it's pretty cheap...
> 
> > +}
> > +
> > +/* Sanity-checking of inode counts. */
> > +bool
> > +xfs_verify_icount(
> > +	struct xfs_mount	*mp,
> > +	unsigned long long	icount)
> > +{
> > +	unsigned long long	min, max;
> > +
> > +	xfs_icount_range(mp, &min, &max);
> > +	return icount >= min && icount < max;
> 
> Since you've calculated it down to the very last inode, why is
> "= max" out of range?

I think that's a bug, will fix. :/

--D

> > +}
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 4055d62f690c..b9e6c89284c3 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -165,5 +165,6 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
> >  bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
> >  bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
> >  bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> > +bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
> >  
> >  #endif	/* __XFS_TYPES_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
