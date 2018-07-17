Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56074 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbeGQVHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 17:07:39 -0400
Date: Tue, 17 Jul 2018 13:33:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180717203301.GW32415@magnolia>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180716192655.27792-1-billodo@redhat.com>
 <20180717170654.GR32415@magnolia>
 <20180717171714.GA13114@redhat.com>
 <20180717191253.GA26736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717191253.GA26736@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 02:12:53PM -0500, Bill O'Donnell wrote:
> On Tue, Jul 17, 2018 at 12:17:14PM -0500, Bill O'Donnell wrote:
> > On Tue, Jul 17, 2018 at 10:06:54AM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 16, 2018 at 02:26:55PM -0500, Bill O'Donnell wrote:
> > > > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > > > Add sanity checks for these parameters.
> > > > 
> > > > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > > > ---
> > > > v2: make extra sanity checks exclusive to writes (allow read)
> > > > 
> > > >  fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++++-----
> > > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index 350119eeaecb..6a98ec68e8ad 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -104,7 +104,8 @@ xfs_mount_validate_sb(
> > > >  	xfs_mount_t	*mp,
> > > >  	xfs_sb_t	*sbp,
> > > >  	bool		check_inprogress,
> > > > -	bool		check_version)
> > > > +	bool		check_version,
> > > > +	bool		write_flag)
> > > 
> > > I notice that check_version and write_flag are always xor -- either
> > > we're reading the sb and set check_version, or we're writing the sb and
> > > set write_flag.  Perhaps we can combine these two as write_flag?
> > > 
> > > if (check_version)
> > > 	check version stuff...
> > > 
> > > becomes:
> > > 
> > > if (!write_flag)
> > > 	check version stuff...
> > > 
> > > and we only have to pass around one flag.
> > 
> > I suppose that makes sense, but my notion is that 2 unique flags
> > is preferable for clarity and mutual exclusiveness for anyone doing
> > subsequent patches.
> 
> I'm all for simplifying and saving stack space, but is it ok
> to turn a single purpose flag into a dual purpose one?

That depends on the flag involved -- if they're mutually exclusive, then
I think it's ok to do that, so long as there's a comment nearby to
document the argument semantics.

In the case of this particular flag (check_version) it is set by the
read verifier so that we reject versions that we don't recognize; it is
not set by the write verifier because we don't change the v5 feature
masks at runtime* and we never write anything if the fs won't mount.

For write_flag, the read verifier never sets it because we have to be
able to mount the fs in case the log contains an sb with an updated set
of summary counters or for lazysbcount filesystems we'll recalculate the
counter after recovery; and we set write_flag at write time, obviously.

So having come this far, you could meld them into a single parameter so
long as you note that write_flag == true means that we're writing the fs
and write_flag == false means we want to check the v5 feature flags at
mount time to reject features bits that we don't recognize.

* Oh, but what about that pesky asterisk?  My sense of paranoia wonders
why we don't check the v5 feature flags on write too, just in case
memory gets corrupted.  I think the reason is that we don't allow
feature flag changes at runtime, we'll check the changes at ioctl time
if we ever do support runtime feature flag updates, and we implicitly
trust memory not to corrupt memory on us (ha ha ha).

At this point my tldr opinion is "seems fine to me, let's see if any of
the lurking vacationers have anything to say?  We're still ~3 weeks to
the next merge window.

--D

> > 
> > > 
> > > >  {
> > > >  	uint32_t	agcount = 0;
> > > >  	uint32_t	rem;
> > > > @@ -266,6 +267,15 @@ xfs_mount_validate_sb(
> > > >  		return -EFSCORRUPTED;
> > > >  	}
> > > >  
> > > > +	/* Additional sb sanity checks for writes */
> > > > +	if (write_flag) {
> > > > +		if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> > > > +		    sbp->sb_ifree > sbp->sb_icount) {
> > > 
> > > Hmm, we still need something that will detect this on read and set a
> > > flag to force recalculation of the summary counters... though since a
> > > patch to implement that flag is sitting in my tree I'll take care of
> > > that part separately.
> > 
> > That sounds good, thanks!
> > -Bill
> > 
> > > 
> > > --D
> > > 
> > > > +			    xfs_notice(mp, "SB sanity check failed");
> > > > +			    return -EFSCORRUPTED;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	if (sbp->sb_unit) {
> > > >  		if (!xfs_sb_version_hasdalign(sbp) ||
> > > >  		    sbp->sb_unit > sbp->sb_width ||
> > > > @@ -599,7 +609,9 @@ xfs_sb_to_disk(
> > > >  static int
> > > >  xfs_sb_verify(
> > > >  	struct xfs_buf	*bp,
> > > > -	bool		check_version)
> > > > +	bool		check_version,
> > > > +	bool		write_flag)
> > > > +
> > > >  {
> > > >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> > > >  	struct xfs_sb	sb;
> > > > @@ -616,7 +628,7 @@ xfs_sb_verify(
> > > >  	 */
> > > >  	return xfs_mount_validate_sb(mp, &sb,
> > > >  				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
> > > > -				     check_version);
> > > > +				     check_version, write_flag);
> > > >  }
> > > >  
> > > >  /*
> > > > @@ -657,7 +669,7 @@ xfs_sb_read_verify(
> > > >  			}
> > > >  		}
> > > >  	}
> > > > -	error = xfs_sb_verify(bp, true);
> > > > +	error = xfs_sb_verify(bp, true, false);
> > > >  
> > > >  out_error:
> > > >  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> > > > @@ -695,7 +707,7 @@ xfs_sb_write_verify(
> > > >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > > >  	int			error;
> > > >  
> > > > -	error = xfs_sb_verify(bp, false);
> > > > +	error = xfs_sb_verify(bp, false, true);
> > > >  	if (error) {
> > > >  		xfs_verifier_error(bp, error, __this_address);
> > > >  		return;
> > > > -- 
> > > > 2.17.1
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
