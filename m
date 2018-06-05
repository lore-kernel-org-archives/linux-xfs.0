Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37314 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751497AbeFEFaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 01:30:15 -0400
Date: Tue, 5 Jun 2018 15:30:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/3] xfs: verify root inode more thoroughly
Message-ID: <20180605053013.GF10363@dastard>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605025704.GZ10363@dastard>
 <20180605040657.GD9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605040657.GD9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:06:57PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2018 at 12:57:04PM +1000, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When looking up the root inode at mount time, we don't actually do
> > any verification to check that the inode is allocated and accounted
> > for correctly in the INOBT. Make the checks on the root inode more
> > robust by making it an untrusted lookup. This forces the inode
> > lookup to use the inode btree to verify the inode is allocated
> > and mapped correctly to disk. This will also have the effect of
> > catching a significant number of AGI/INOBT related corruptions in
> > AG 0 at mount time.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > ---
> >  fs/xfs/xfs_mount.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 189fa7b615d3..a3378252baa1 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -862,9 +862,12 @@ xfs_mountfs(
> >  	 * Get and sanity-check the root inode.
> >  	 * Save the pointer to it in the mount structure.
> >  	 */
> > -	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
> > +	error = xfs_iget(mp, NULL, sbp->sb_rootino, XFS_IGET_UNTRUSTED,
> 
> One little quirk I've noticed with xfs_iget is that a corrupt inode
> buffer's -EFSCORRUPTED gets turned into -EINVAL on the way out of iget.

That's in xfs_imap_to_bp(), right?

And the only place we care about this is xfs_nfs_get_inode() so that
we return ESTALE rather than EFSCORRUPTED, yes?

Ok, so let's fix that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
