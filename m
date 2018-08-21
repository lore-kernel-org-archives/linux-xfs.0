Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:13644 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbeHVDGP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 23:06:15 -0400
Date: Wed, 22 Aug 2018 09:43:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: open code sb verifier feature checks
Message-ID: <20180821234357.GO31495@dastard>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-9-david@fromorbit.com>
 <20180821132534.GF15030@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821132534.GF15030@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 09:25:35AM -0400, Brian Foster wrote:
> On Mon, Aug 20, 2018 at 02:48:49PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The superblock verifiers are one of the last places that use the sb
> > version functions to do feature checks. This are all quite simple
> > uses, and there aren't many of them so open code them all.
> > 
> > Also, move the good version number check into xfs_sb.c instead of it
> > being an inline function in xfs_format.h
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |  26 ---------
> >  fs/xfs/libxfs/xfs_sb.c     | 116 +++++++++++++++++++++++++------------
> >  fs/xfs/libxfs/xfs_sb.h     |   1 +
> >  3 files changed, 81 insertions(+), 62 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index bedf6c6bf990..b83cf8adca1a 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> ...
> > @@ -485,7 +523,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >  	 * We need to do these manipilations only if we are working
> >  	 * with an older version of on-disk superblock.
> >  	 */
> > -	if (xfs_sb_version_haspquotino(sbp))
> > +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_5)
> >  		return;
> 
> Isn't this backwards (we want to exit if == XFS_SB_VERSION_5)?

Good catch, will fix.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
