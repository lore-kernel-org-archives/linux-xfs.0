Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F998C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA66613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhGNFCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhGNFCJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 01:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A953613B0;
        Wed, 14 Jul 2021 04:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626238758;
        bh=mTk7aZ1yK40Cc23aDT54tLQ59Nxg5tPJF48j4oIDoC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=smdOootE77nJOcc21GfMPwPhCq+TK1h/tYpC2ycJgMVR2Tw6gfiUa1leXyF7OT5SP
         qrpIkodqD8KT8X+vJwfm0KXgl0RqiHwx5lA3YX84JfhDGvf8K16/Z4ZM8LVVWJSOjy
         /pQrF3FsLmvkmuTklJN9CuLhU+YCBpFEwR+fgP0Rhciqd20ps6r2DAf4+wk2UQWCKI
         ZmYVS/4kQXHnvup18oOPOnZEdJK11tPN4KY51mBtmhRqdZHkph37Fhm7SqVt4wSECe
         GSjAEkm7QkvNJay8Wdab8bMIByVm82X/Kt7DLw9YtPz5aB6lu/hEyZP6ItmXo92kyB
         OCeTnLbx9WMVw==
Date:   Tue, 13 Jul 2021 21:59:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: improve FSGROWFSRT precondition checking
Message-ID: <20210714045917.GE22402@magnolia>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
 <162612764549.39052.13778481530353608889.stgit@magnolia>
 <20210714005850.GT664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714005850.GT664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 10:58:50AM +1000, Dave Chinner wrote:
> On Mon, Jul 12, 2021 at 03:07:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Improve the checking at the start of a realtime grow operation so that
> > we avoid accidentally set a new extent size that is too large and avoid
> > adding an rt volume to a filesystem with rmap or reflink because we
> > don't support rt rmap or reflink yet.
> > 
> > While we're at it, separate the checks so that we're only testing one
> > aspect at a time.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_rtalloc.c |   20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 4e7be6b4ca8e..8920bce4fb0a 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -928,11 +928,23 @@ xfs_growfs_rt(
> >  	 */
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EPERM;
> > -	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
> > -	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
> > -	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
> > +	if (mp->m_rtdev_targp == NULL || !mp->m_rbmip || !mp->m_rsumip)
> >  		return -EINVAL;
> 
> Shouldn't this use XFS_IS_REALTIME_MOUNT() so it always fails if
> CONFIG_XFS_RT=n?

xfs_rtalloc.c isn't even linked into the binary if CONFIG_XFS_RT=n.

> i.e. if we have to check mp->m_rbmip and mp->m_rsumip to determine
> if this mount is realtime enabled, then doesn't
> XFS_IS_REALTIME_MOUNT() need to be fixed?

TBH I think technically we could actually drop the m_rbmip/m_rsumip
checks since the mount will fail if those files cannot be iget'd.
That said, given how poorly tested realtime is, I figured it doesn't
hurt to double-check for this infrequent operation.

> 
> > -	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
> > +	if (in->newblocks <= sbp->sb_rblocks)
> > +		return -EINVAL;
> > +	if (xfs_sb_version_hasrealtime(&mp->m_sb) &&
> > +	    in->extsize != sbp->sb_rextsize)
> > +		return -EINVAL;
> 
> xfs_sb_version_hasrealtime() checks "sbp->sb_rblocks > 0", it's not
> an actual version flag check. I think this makes much more sense
> being open coded rather than masquerading as a feature check....

Ok, I'll change it back.

> 
> > +	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
> > +	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
> > +		return -EINVAL;
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
> > +	    xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	nrblocks = in->newblocks;
> > +	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
> > +	if (error)
> >  		return error;
> 
> Otherwise looks like a reasonable set of additional checks.

Cool!  Thanks for the review.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
