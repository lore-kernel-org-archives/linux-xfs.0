Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbdJWQyS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 12:54:18 -0400
Date: Mon, 23 Oct 2017 12:54:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: drain the buffer LRU on mount
Message-ID: <20171023165416.GD45316@bfoster.bfoster>
References: <20171023144646.50107-1-bfoster@redhat.com>
 <20171023144646.50107-4-bfoster@redhat.com>
 <20171023163940.GE5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023163940.GE5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 09:39:40AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 23, 2017 at 10:46:45AM -0400, Brian Foster wrote:
> > Log recovery of v4 filesystems does not use buffer verifiers because
> > log recovery historically can result in transient buffer corruption
> > when target buffers might be ahead of the log after a crash. v5
> > filesystems work around this problem with metadata LSN ordering.
> > 
> > While the log recovery behavior is necessary on v4 supers, it
> > currently can result in leaving buffers around in the LRU without
> > verifiers attached for a significant amount of time. This can lead
> > to use of unverified buffers while the filesystem is in active use,
> > long after recovery has completed.
> > 
> > To address this problem and provide a more consistent clean,
> > post-mount buffer cache state, update the log mount sequence to
> > unconditionally drain all buffers from the LRU as a final step.
> > 
> > Reported-by: Darrick Wong <darrick.wong@oracle.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index dc95a49..e282fd8 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -744,6 +744,7 @@ xfs_log_mount_finish(
> >  {
> >  	int	error = 0;
> >  	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> > +	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
> >  
> >  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> > @@ -780,6 +781,18 @@ xfs_log_mount_finish(
> >  	mp->m_super->s_flags &= ~MS_ACTIVE;
> >  	evict_inodes(mp->m_super);
> >  
> > +	/*
> > +	 * Drain the buffer LRU after log recovery. This is required for v4
> > +	 * filesystems to avoid leaving around buffers with NULL verifier ops,
> > +	 * but we do it unconditionally to make sure we're always in a clean
> > +	 * cache state after mount.
> > +	 */
> > +	if (recovered) {
> 
> if (recovered && !error) { ?
> 
> I observed that running xfs/376 on an rmap filesystem fails when it
> tries to fuzz the high bit of u3.bmx[0].startoff.  That triggers an
> incorrect freeing of what is now a post-eof extent.  The corresponding
> rmap free operation fails after the RUI has been logged and shuts down
> the filesystem, so a subsequent log recovery attempt also fails when it
> tries to remove an rmap that doesn't exist.  If we then try to force the
> log we end up deadlocked somehwere... though if we /don't/ then memory
> gets corrupted and the kernel blows up anyway. :(
> 

Interesting... do you have a stack trace? I'm curious why forcing the
log would hang here and not in the subsequent log force in
xfs_log_unmount() -> xfs_log_quiesce().

Brian

> --D
> 
> > +		xfs_log_force(mp, XFS_LOG_SYNC);
> > +		xfs_ail_push_all_sync(mp->m_ail);
> > +	}
> > +	xfs_wait_buftarg(mp->m_ddev_targp);
> > +
> >  	if (readonly)
> >  		mp->m_flags |= XFS_MOUNT_RDONLY;
> >  
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
