Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbeGaBQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 21:16:05 -0400
Date: Mon, 30 Jul 2018 16:38:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180730233835.GR30972@magnolia>
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
 <153292862122.19274.13281750487162777731.stgit@magnolia>
 <82b9a6d9-c5b9-112d-98eb-c9e7153e67da@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82b9a6d9-c5b9-112d-98eb-c9e7153e67da@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>

On Mon, Jul 30, 2018 at 06:16:40PM -0500, Eric Sandeen wrote:
> On 7/30/18 12:30 AM, Darrick J. Wong wrote:
> > From: Bill O'Donnell <billodo@redhat.com>
> > 
> > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > Add sanity checks for these parameters.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > [darrick: port to refactored sb validation predicates]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> comment nitpicks below, but otherwise
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 516bef7b0f50..64bc471d57e6 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -153,6 +153,18 @@ xfs_validate_sb_write(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_sb		*sbp)
> >  {
> > +	/*
> > +	 * Carry out additional sb sanity checks exclusively for writes.
> 
> We're in xfs_validate_sb_write so that's obvious, can drop this line.
> 
> > +	 * We don't do these checks for reads, since faulty parameters could
> > +	 * be fixed in the log, and we shouldn't prohibit mounting for those
> > +	 * cases.
> > +	 */
> 
> Hm, it's not really a log reaplay issue, right?  These summary counters
> get reinitialized at mount, so failing to mount before we overwrite them
> anyway makes no sense.

Well, we don't reinitialize them if ( (!lazysbcount) or (clean log) )
and (non-crazy values)...

> /*
>  * These summary counters get re-initialized after they are read
>  * during mount, so this is a write-only check.

They're not always re-initialized -- only if we had a dirty lazysbcont
fs or the values were crazy.

/*
 * Carry out additional sb summary counter sanity checks when we write
 * the superblock.  We skip this in the read validator because there
 * could be newer superblocks in the log and if the values are garbage
 * even after replay we'll recalculate them at the end of log mount.
 */

--D

>  */
> 
> ?  And yeah, modulo lazycount... but whatevs.
> 
> -Eric
> 
> > +	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> > +	    sbp->sb_ifree > sbp->sb_icount) {
> > +		xfs_warn(mp, "SB summary counter sanity check failed");
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> >  	if (!xfs_sb_version_hascrc(sbp))
> >  		return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
