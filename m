Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751057AbeAVOGb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Jan 2018 09:06:31 -0500
Date: Mon, 22 Jan 2018 09:06:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: introduce 'fixed agfl' feature
Message-ID: <20180122140629.GA26131@bfoster.bfoster>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
 <151623404388.4727.13556729503051957189.stgit@magnolia>
 <20180118002940.GF25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118002940.GF25805@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 17, 2018 at 04:29:40PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 17, 2018 at 04:07:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new rocompat flag "FIXED_AGFL" to indicate that we've
> > scanned and verified that the AGFL does not hit the troublesome last
> > element of the AGFL array, and update xfs_agfl_size to its new
> > definition based on this feature.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index bb42a11..3befc92f 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -464,6 +464,7 @@ xfs_sb_has_compat_feature(
> >  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> > +#define XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL (1 << 3)	/* fixed agfl */
> 
> (echoing comments made on irc by myself & Dave)
> 
> It suddenly occurred to me that we could do without this rocompat
> feature if we simply don't allow wrapped AGFLs anymore.  As soon as
> fllast points to that last agfl_bno slot, we simply move the whole list
> back to the start of the agfl block (i.e. flfirst = 0) and relog the
> whole agfl.  We still have problems if the admin mounts with an
> unpatched kernel, gets the agfl to wrap, and then then moves to another
> unpatched kernel, but at least the up-to-date kernels can just fix the
> problem and move on.
> 

Eh, I'm not a huge fan of modifying AGFL behavior to deal with a padding
bug. It strikes me as overkill and undue risk (depending on how the code
would have to look I suppose). 

> I guess the nice thing about the rocompat feature is that the unpatched
> kernels won't mount, instead of blowing up randomly some time in the
> future and the user's antiquarian xfsprogs also refuses to touch it.
> 
> We could also only set the rocompat flag if we actually had to fix
> something (vs. now where we always set it) though I wonder if that just
> makes the "I reverted kernels and now it blew up wtf?!" even more
> sporadic?  Hm.  Maybe we want that, since either is a rude awakening &
> making the rude wakeup less frequent isn't a bad thing.
> 
> Ugh.  Maybe bikeshed now? :)
> 

Any reason we couldn't do something like force a read-only mount for
affected filesystems with a notice/msg to run xfs_repair (I assume we've
already backported fixes to repair/stable kernels to help prevent
reoccurence of this..)? Then we'd at least only affect users who are
affected by the problem, and IIUC it sounds like a corruption error is
imminent for those particular users as it is.

Brian

> --D
> 
> >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> >  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> >  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > @@ -566,6 +567,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> >  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
> >  }
> >  
> > +static inline bool xfs_sb_version_hasfixedagfl(struct xfs_sb *sbp)
> > +{
> > +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL);
> > +}
> > +
> >  /*
> >   * end of superblock version macros
> >   */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
