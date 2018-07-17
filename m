Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729697AbeGQRuz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jul 2018 13:50:55 -0400
Date: Tue, 17 Jul 2018 12:17:14 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180717171714.GA13114@redhat.com>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180716192655.27792-1-billodo@redhat.com>
 <20180717170654.GR32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717170654.GR32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 10:06:54AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 16, 2018 at 02:26:55PM -0500, Bill O'Donnell wrote:
> > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > Add sanity checks for these parameters.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> > v2: make extra sanity checks exclusive to writes (allow read)
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 350119eeaecb..6a98ec68e8ad 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -104,7 +104,8 @@ xfs_mount_validate_sb(
> >  	xfs_mount_t	*mp,
> >  	xfs_sb_t	*sbp,
> >  	bool		check_inprogress,
> > -	bool		check_version)
> > +	bool		check_version,
> > +	bool		write_flag)
> 
> I notice that check_version and write_flag are always xor -- either
> we're reading the sb and set check_version, or we're writing the sb and
> set write_flag.  Perhaps we can combine these two as write_flag?
> 
> if (check_version)
> 	check version stuff...
> 
> becomes:
> 
> if (!write_flag)
> 	check version stuff...
> 
> and we only have to pass around one flag.

I suppose that makes sense, but my notion is that 2 unique flags
is preferable for clarity and mutual exclusiveness for anyone doing
subsequent patches.

> 
> >  {
> >  	uint32_t	agcount = 0;
> >  	uint32_t	rem;
> > @@ -266,6 +267,15 @@ xfs_mount_validate_sb(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > +	/* Additional sb sanity checks for writes */
> > +	if (write_flag) {
> > +		if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> > +		    sbp->sb_ifree > sbp->sb_icount) {
> 
> Hmm, we still need something that will detect this on read and set a
> flag to force recalculation of the summary counters... though since a
> patch to implement that flag is sitting in my tree I'll take care of
> that part separately.

That sounds good, thanks!
-Bill

> 
> --D
> 
> > +			    xfs_notice(mp, "SB sanity check failed");
> > +			    return -EFSCORRUPTED;
> > +		}
> > +	}
> > +
> >  	if (sbp->sb_unit) {
> >  		if (!xfs_sb_version_hasdalign(sbp) ||
> >  		    sbp->sb_unit > sbp->sb_width ||
> > @@ -599,7 +609,9 @@ xfs_sb_to_disk(
> >  static int
> >  xfs_sb_verify(
> >  	struct xfs_buf	*bp,
> > -	bool		check_version)
> > +	bool		check_version,
> > +	bool		write_flag)
> > +
> >  {
> >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> >  	struct xfs_sb	sb;
> > @@ -616,7 +628,7 @@ xfs_sb_verify(
> >  	 */
> >  	return xfs_mount_validate_sb(mp, &sb,
> >  				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
> > -				     check_version);
> > +				     check_version, write_flag);
> >  }
> >  
> >  /*
> > @@ -657,7 +669,7 @@ xfs_sb_read_verify(
> >  			}
> >  		}
> >  	}
> > -	error = xfs_sb_verify(bp, true);
> > +	error = xfs_sb_verify(bp, true, false);
> >  
> >  out_error:
> >  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> > @@ -695,7 +707,7 @@ xfs_sb_write_verify(
> >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  	int			error;
> >  
> > -	error = xfs_sb_verify(bp, false);
> > +	error = xfs_sb_verify(bp, false, true);
> >  	if (error) {
> >  		xfs_verifier_error(bp, error, __this_address);
> >  		return;
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
