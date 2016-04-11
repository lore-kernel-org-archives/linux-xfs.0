Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D3907CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 18:32:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACF2B8F8037
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 16:32:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Frrf5bb9CUSrJABk for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 16:31:58 -0700 (PDT)
Date: Tue, 12 Apr 2016 09:31:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 v2] xfs: xfs_iflush_cluster vs xfs_reclaim_inode
Message-ID: <20160411233156.GE9088@dastard>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
	<20160408171843.GC30614@bfoster.bfoster>
	<20160408221706.GB567@dastard>
	<20160411133716.GA47566@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160411133716.GA47566@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 11, 2016 at 09:37:18AM -0400, Brian Foster wrote:
> On Sat, Apr 09, 2016 at 08:17:06AM +1000, Dave Chinner wrote:
> > On Fri, Apr 08, 2016 at 01:18:44PM -0400, Brian Foster wrote:
> > > On Fri, Apr 08, 2016 at 09:37:45AM +1000, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > This is the second version of this patch set, first posted and
> > > > described here:
> > > > 
> > > > http://oss.sgi.com/archives/xfs/2016-04/msg00069.html
> > > > 
> > > > The only change from the first version is splitting up the first
> > > > patch into two as Christoph requested - one for the bug fix, the
> > > > other for the variable renaming.
> > > > 
> > > 
> > > Did your xfstests testing for this series include generic/233? I'm
> > > seeing a consistently reproducible test hang. The test is hanging on a
> > > "xfs_quota -x -c off -ug /mnt/scratch" command. The stack is as follows:
> > > 
> > > [<ffffffffa0772306>] xfs_qm_dquot_walk.isra.8+0x196/0x1b0 [xfs]
> > > [<ffffffffa0774a98>] xfs_qm_dqpurge_all+0x78/0x80 [xfs]
> > > [<ffffffffa07713e8>] xfs_qm_scall_quotaoff+0x148/0x640 [xfs]
> > > [<ffffffffa077733d>] xfs_quota_disable+0x3d/0x50 [xfs]
> > > [<ffffffff812c27e3>] SyS_quotactl+0x3b3/0x8c0
> > > [<ffffffff81003e17>] do_syscall_64+0x67/0x190
> > > [<ffffffff81763f7f>] return_from_SYSCALL_64+0x0/0x7a
> > > [<ffffffffffffffff>] 0xffffffffffffffff
....
> > IOWs, this looks like xfs_qm_dquot_walk() is skipping dquots because
> > xfs_qm_dqpurge is hitting this:
> > 
> >         xfs_dqlock(dqp);
> >         if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> >                 xfs_dqunlock(dqp);
> >                 return -EAGAIN;
> >         }
> > 
> > So that means we've got an inode that probably hasn't been
> > reclaimed, because the last thing that happens during reclaim is the
> > dquots are detatched from the inode and hence the reference counts
> > are dropped.
> > 
> > > FWIW, this only occurs with patch 6 applied. The test and scratch
> > > devices are both 10GB lvm volumes formatted with mkfs defaults (v5).
> > 
> > I can't see how patch 6 would prevent an inode from being reclaimed,
> > as all the changes occur *after* the reclaim decision has been made.
> > More investigation needed, I guess...
> > 
> 
> The attached diff addresses the problem for me. Feel free to fold it
> into the original patch.
....
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a60db43..749689c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -818,14 +818,15 @@ xfs_inode_set_reclaim_tag(
>  STATIC void
>  __xfs_inode_clear_reclaim(
>  	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> +	xfs_inode_t	*ip,
> +	xfs_ino_t	ino)
>  {
>  	pag->pag_ici_reclaimable--;
>  	if (!pag->pag_ici_reclaimable) {
>  		/* clear the reclaim tag from the perag radix tree */
>  		spin_lock(&ip->i_mount->m_perag_lock);
>  		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
> -				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> +				XFS_INO_TO_AGNO(ip->i_mount, ino),
>  				XFS_ICI_RECLAIM_TAG);
>  		spin_unlock(&ip->i_mount->m_perag_lock);
>  		trace_xfs_perag_clear_reclaim(ip->i_mount, pag->pag_agno,

Yeah, that'll do it. Though I think the fix should be something
different - why do we need ip->i_ino to find the agno or the
xfs_mount when we've already got pag->pag_agno and pag->pag_mount?

I'll clean up all these per-ag tag functions to only take xfs_perag
and an xfs_ino_t where needed and repost once i've tested it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
