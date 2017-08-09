Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47932 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdHIQGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 12:06:12 -0400
Date: Wed, 9 Aug 2017 09:06:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: don't leak quotacheck dquots when cow recovery
 fails
Message-ID: <20170809160607.GT24087@magnolia>
References: <20170809010444.GR24087@magnolia>
 <20170809010700.GA4461@magnolia>
 <20170809123656.GC62448@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809123656.GC62448@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 09, 2017 at 08:36:58AM -0400, Brian Foster wrote:
> On Tue, Aug 08, 2017 at 06:07:00PM -0700, Darrick J. Wong wrote:
> > If we fail a mount on account of cow recovery errors, it's possible that
> > a previous quotacheck left some dquots in memory.  The bailout clause of
> > xfs_mountfs forgets to purge these, and so we leak them.  Fix that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_mount.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index d463ab3..8a12118 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1029,6 +1029,8 @@ xfs_mountfs(
> >   out_agresv:
> >  	xfs_fs_unreserve_ag_blocks(mp);
> >   out_quota:
> > +	/* Clean out dquots that might be in memory after quotacheck. */
> > +	xfs_qm_unmount(mp);
> >  	xfs_qm_unmount_quotas(mp);
> 
> Should these calls be reversed? It looks like qm_unmount() can free
> m_quotainfo before qm_unmount_quotas() has a chance to release quota
> inodes and whatnot.

xfs_qm_unmount -> xfs_qm_destroy_quotainfo will free the quota inodes,
but you're right that we need (at least in theory) to call
xfs_qm_unmount_quotas first so that we can xfs_qm_dqdetach the
root/rbm/rsum inodes.  I don't think we've actually attached dquots to
those inodes at that point in the mount process (and the slab leak
complaints have stopped) so at a practical level it might not matter.

Will change & resubmit,

--D

> 
> Brian
> 
> >   out_rtunmount:
> >  	xfs_rtunmount_inodes(mp);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
