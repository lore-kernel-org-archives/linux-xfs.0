Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731342AbeGMUWL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 16:22:11 -0400
Date: Fri, 13 Jul 2018 15:06:02 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180713200602.GA4768@redhat.com>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180713164153.GM32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713164153.GM32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 13, 2018 at 09:41:53AM -0700, Darrick J. Wong wrote:
> On Fri, Jul 13, 2018 at 08:10:03AM -0500, Bill O'Donnell wrote:
> > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > Add sanity checks for these parameters.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 350119eeaecb..cdede769ab88 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -261,7 +261,9 @@ xfs_mount_validate_sb(
> >  	    sbp->sb_dblocks == 0					||
> >  	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
> >  	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp)			||
> > -	    sbp->sb_shared_vn != 0)) {
> > +	    sbp->sb_shared_vn != 0					||
> > +	    sbp->sb_fdblocks > sbp->sb_dblocks				||
> > +	    sbp->sb_ifree > sbp->sb_icount)) {
> 
> Hmm.  On its face this seems reasonable for the superblock verifier, but
> then I started wondering, since these are /summary/ counters.

FWIW, I'm proposing a rudimentary bounds check to prevent this sort of
issue from even happening in the first place:
https://www.spinics.net/lists/linux-xfs/msg20592.html

> 
> If the free counts are off by this much, the admin won't be able to
> mount the fs, and xfs_repair is the only other tool that can fix the
> summary counts.  However, if the log is dirty, the mount won't succeed
> to recover the fs, which is too bad since we can reinitialize the
> summary counts after log recovery.  xfs_repair -L will be the only way
> out, which will wreak havoc on the filesystem from discarding the log
> contents.

agreed, but again, I want to prevent the aforementioned use case where
corruption gets introduced.

> 
> So, would it be preferable to split this into two parts?  For example,
> have this as a corruption check in _sb_write_verify to prevent us from
> writing out garbage counters and a clamp in _reinit_percpu_counters so
> that we never present ridiculous free counts to users?
> 
> (Does any of this make sense with !haslazysbcount filesystems?)
> 
> Bonus question: What about checking frextents/rextents?

Hrmm, perhaps. It should definitely be considered.

Thanks-
Bill

> --D
> 
> >  		xfs_notice(mp, "SB sanity check failed");
> >  		return -EFSCORRUPTED;
> >  	}
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
