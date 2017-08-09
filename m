Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34449 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753609AbdHIPqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 11:46:30 -0400
Date: Wed, 9 Aug 2017 08:46:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery to
 avoid inode leak
Message-ID: <20170809154624.GS24087@magnolia>
References: <20170809010444.GR24087@magnolia>
 <20170809123600.GA62448@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809123600.GA62448@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 09, 2017 at 08:36:03AM -0400, Brian Foster wrote:
> On Tue, Aug 08, 2017 at 06:04:44PM -0700, Darrick J. Wong wrote:
> > Way back when we established inode block-map redo log items, it was
> > discovered that we needed to prevent the VFS from evicting inodes during
> > log recovery because any given inode might be have bmap redo items to
> > replay even if the inode has no link count and is ultimately deleted,
> > and any eviction of an unlinked inode causes the inode to be truncated
> > and freed too early.
> > 
> > To make this possible, we set MS_ACTIVE so that inodes would not be torn
> > down immediately upon release.  Unfortunately, this also results in the
> > quota inodes not being released at all if a later part of the mount
> > process should fail, because we never reclaim the inodes.  So, clear
> > MS_ACTIVE immediately after we finish the log recovery so that the quota
> > inodes will be torn down properly if we abort the mount.
> > 
> > Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_mount.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 40d4e8b..d463ab3 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -949,7 +949,9 @@ xfs_mountfs(
> >  	 * iput to behave like they do for an active filesystem.
> >  	 * xfs_fs_drop_inode needs to be able to prevent the deletion
> >  	 * of inodes before we're done replaying log items on those
> > -	 * inodes.
> > +	 * inodes.  Turn it off immediately after xfs_log_mount_finish
> > +	 * so that we don't leak the quota inodes if subsequent mount
> > +	 * activities fail.
> >  	 */
> >  	mp->m_super->s_flags |= MS_ACTIVE;
> >  
> > @@ -959,6 +961,7 @@ xfs_mountfs(
> >  	 * read in.
> >  	 */
> >  	error = xfs_log_mount_finish(mp);
> > +	mp->m_super->s_flags &= ~MS_ACTIVE;
> 
> Just an aesthetic nit, but could we combine these two above hunks and
> the associated comments so the intent is very obvious? E.g., so it looks
> something like this:
> 
> 	/*
> 	 * Set MS_ACTIVE around log recovery ...
> 	 */
> 	mp->m_super->s_flags |= MS_ACTIVE;
> 	error = xfs_log_mount_finish(mp);
> 	mp->m_super->s_flags &= ~MS_ACTIVE;
> 	...

Yes, that's fine.

--D

> 
> Otherwise this looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	if (error) {
> >  		xfs_warn(mp, "log mount finish failed");
> >  		goto out_rtunmount;
> > @@ -1028,7 +1031,6 @@ xfs_mountfs(
> >   out_quota:
> >  	xfs_qm_unmount_quotas(mp);
> >   out_rtunmount:
> > -	mp->m_super->s_flags &= ~MS_ACTIVE;
> >  	xfs_rtunmount_inodes(mp);
> >   out_rele_rip:
> >  	IRELE(rip);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
