Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57493 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933141AbeCGAp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 19:45:57 -0500
Date: Wed, 7 Mar 2018 11:45:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: rewrite the fdatasync optimization
Message-ID: <20180307004554.GM18129@dastard>
References: <20180222150421.18138-1-hch@lst.de>
 <20180226145503.GB51394@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180226145503.GB51394@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 26, 2018 at 09:55:04AM -0500, Brian Foster wrote:
> On Thu, Feb 22, 2018 at 07:04:21AM -0800, Christoph Hellwig wrote:
> > Currently we need to the ilock over the log force in xfs_fsync so that we
> > can protect ili_fsync_fields against incorrect manipulation.
> > Unfortunately that can cause huge latency spikes for workloads that mix
> > fsync with writes from other thread or through aio on the same file.
> > 
> > Instead record the last dirty lsn that was not just a timestamp update in
> > the inode log item as long as the inode is pinned, and clear it when
> > unpinning the inode.  This removes the need for ili_fsync_fields and thus
> > holding the ilock over the log force, and drastically reduces latency on
> > multithreaded workloads that mix writes with fsync calls on the same file.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > 
> > Changes since V1:
> >  - reomve the XFS_ILOG_VERSION optimization
> > 
> >  fs/xfs/xfs_file.c        | 20 ++++++--------------
> >  fs/xfs/xfs_inode.c       |  2 --
> >  fs/xfs/xfs_inode_item.c  | 10 ++++++++--
> >  fs/xfs/xfs_inode_item.h  |  2 +-
> >  fs/xfs/xfs_iomap.c       |  3 +--
> >  fs/xfs/xfs_trans_inode.c |  9 ---------
> >  6 files changed, 16 insertions(+), 30 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 9ea08326f876..ccb331f96a6d 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -165,27 +165,19 @@ xfs_file_fsync(
> >  	 * All metadata updates are logged, which means that we just have to
> >  	 * flush the log up to the latest LSN that touched the inode. If we have
> >  	 * concurrent fsync/fdatasync() calls, we need them to all block on the
> > -	 * log force before we clear the ili_fsync_fields field. This ensures
> > -	 * that we don't get a racing sync operation that does not wait for the
> > -	 * metadata to hit the journal before returning. If we race with
> > -	 * clearing the ili_fsync_fields, then all that will happen is the log
> > -	 * force will do nothing as the lsn will already be on disk. We can't
> > -	 * race with setting ili_fsync_fields because that is done under
> > -	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
> > -	 * until after the ili_fsync_fields is cleared.
> > +	 * log force before returning.
> >  	 */
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  	if (xfs_ipincount(ip)) {
> > -		if (!datasync ||
> > -		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > +		if (datasync)
> > +			lsn = ip->i_itemp->ili_datasync_lsn;
> > +		else
> >  			lsn = ip->i_itemp->ili_last_lsn;
> >  	}
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  
> > -	if (lsn) {
> > +	if (lsn)
> >  		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> > -		ip->i_itemp->ili_fsync_fields = 0;
> > -	}
> > -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  
> >  	/*
> >  	 * If we only have a single device, and the log force about was
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 604ee384a00a..a57772553a2a 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2385,7 +2385,6 @@ xfs_ifree_cluster(
> >  
> >  			iip->ili_last_fields = iip->ili_fields;
> >  			iip->ili_fields = 0;
> > -			iip->ili_fsync_fields = 0;
> >  			iip->ili_logged = 1;
> >  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> >  						&iip->ili_item.li_lsn);
> > @@ -3649,7 +3648,6 @@ xfs_iflush_int(
> >  	 */
> >  	iip->ili_last_fields = iip->ili_fields;
> >  	iip->ili_fields = 0;
> > -	iip->ili_fsync_fields = 0;
> >  	iip->ili_logged = 1;
> >  
> >  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index d5037f060d6f..b60592e82833 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -630,6 +630,9 @@ xfs_inode_item_committed(
> >  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> >  	struct xfs_inode	*ip = iip->ili_inode;
> >  
> > +	iip->ili_last_lsn = 0;
> > +	iip->ili_datasync_lsn = 0;
> > +
> 
> Hmm, it's not clear to me why we're messing with ili_last_lsn here as
> well since I don't see any mention of it anywhere. That aside, I'm not
> quite sure this is safe even with regard to ->ili_datasync_lsn.

Actually, it's not safe with regard to iip->ili_last_lsn, either:

[ 6158.067488] run fstests generic/476 at 2018-03-05 16:26:36
[ 6159.036562] XFS (sdg): Mounting V5 Filesystem
[ 6159.074800] XFS (sdg): Ending clean mount
[ 6370.748497] kworker/dying (24679) used greatest stack depth: 11168 bytes left
[ 6527.664801] XFS: Assertion failed: lsn != 0, file: fs/xfs/xfs_log.c, line: 3458
[ 6527.667593] ------------[ cut here ]------------
[ 6527.669286] kernel BUG at fs/xfs/xfs_message.c:114!
[ 6527.670253] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6527.673091] CPU: 2 PID: 697 Comm: kswapd0 Not tainted 4.16.0-rc2-dgc #383
[ 6527.675120] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[ 6527.677410] RIP: 0010:assfail+0x28/0x30
[ 6527.678402] RSP: 0018:ffffc900016b7a88 EFLAGS: 00010202
[ 6527.679852] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000000
[ 6527.681579] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff82271753
[ 6527.683235] RBP: ffff8801276e1400 R08: 0000000000000000 R09: 0000000000000000
[ 6527.684467] R10: ffff8800ba50f028 R11: f000000000000000 R12: ffff880121420000
[ 6527.685549] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000002079f51
[ 6527.686604] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[ 6527.687896] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6527.688739] CR2: 00007f5ac5bbb000 CR3: 000000013a3e4000 CR4: 00000000000006e0
[ 6527.689759] Call Trace:
[ 6527.690141]  _xfs_log_force_lsn+0x323/0x340
[ 6527.690758]  ? xfs_reclaim_inode+0x71/0x400
[ 6527.691365]  __xfs_iunpin_wait+0xa4/0x170
[ 6527.691981]  ? woken_wake_function+0x10/0x10
[ 6527.692602]  xfs_reclaim_inode+0x71/0x400
[ 6527.693271]  xfs_reclaim_inodes_ag+0x1a5/0x2e0
[ 6527.693904]  xfs_reclaim_inodes_nr+0x31/0x40
[ 6527.694515]  super_cache_scan+0x14d/0x1a0
[ 6527.695086]  shrink_slab.part.66+0x171/0x370
[ 6527.695739]  shrink_node+0x7e/0x1a0
[ 6527.696238]  kswapd+0x270/0x6b0
[ 6527.696723]  ? node_reclaim+0x220/0x220
[ 6527.697271]  kthread+0x111/0x130
[ 6527.697737]  ? __kthread_create_worker+0x120/0x120
[ 6527.698421]  ? call_usermodehelper_exec_async+0x11c/0x150
[ 6527.699196]  ret_from_fork+0x24/0x30
[ 6527.699741] Code: 0b c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 d0 64 2d 82 48 89 fa 31 ff e8 84 fa ff ff 80 3d d1 e3 0d 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 4
[ 6527.702441] RIP: assfail+0x28/0x30 RSP: ffffc900016b7a88
[ 6527.704099] ---[ end trace bbf263c1abbd8799 ]---

On log checkpoint completion, there is a big window between
->iop_committed and ->iop_unpin calls where we are in the state
i_pincount > 0 and ili_last_lsn = zero.

If anything calls xfs_iunpin()/xfs_iunpin_wait() in this window,
then we run this:

	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);

Which then fires the above assert because the force lsn is zero.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
