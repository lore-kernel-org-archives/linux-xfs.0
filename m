Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31993 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbeKIJ7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 04:59:43 -0500
Date: Fri, 9 Nov 2018 11:21:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/16] xfs: finobt AG reserves don't consider last AG can
 be a runt
Message-ID: <20181109002136.GF19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-4-david@fromorbit.com>
 <20181107165508.GA4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107165508.GA4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 07, 2018 at 08:55:08AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 07, 2018 at 05:31:14PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The last AG may be very small comapred to all other AGs, and hence
> > AG reservations based on the superblock AG size may actually consume
> > more space than the AG actually has. This results on assert failures
> > like:
> > 
> > XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 319
> > [   48.932891]  xfs_ag_resv_init+0x1bd/0x1d0
> > [   48.933853]  xfs_fs_reserve_ag_blocks+0x37/0xb0
> > [   48.934939]  xfs_mountfs+0x5b3/0x920
> > [   48.935804]  xfs_fs_fill_super+0x462/0x640
> > [   48.936784]  ? xfs_test_remount_options+0x60/0x60
> > [   48.937908]  mount_bdev+0x178/0x1b0
> > [   48.938751]  mount_fs+0x36/0x170
> > [   48.939533]  vfs_kern_mount.part.43+0x54/0x130
> > [   48.940596]  do_mount+0x20e/0xcb0
> > [   48.941396]  ? memdup_user+0x3e/0x70
> > [   48.942249]  ksys_mount+0xba/0xd0
> > [   48.943046]  __x64_sys_mount+0x21/0x30
> > [   48.943953]  do_syscall_64+0x54/0x170
> > [   48.944835]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > Hence we need to ensure the finobt per-ag space reservations take
> > into account the size of the last AG rather than treat it like all
> > the other full size AGs.
> > 
> > Note that both refcountbt and rmapbt already take the size of the AG
> > into account via reading the AGF length directly.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc_btree.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 86c50208a143..62014780d5e4 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -538,15 +538,24 @@ xfs_inobt_rec_check_count(
> >  
> >  static xfs_extlen_t
> >  xfs_inobt_max_size(
> > -	struct xfs_mount	*mp)
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno)
> >  {
> > +	uint32_t		agblocks = mp->m_sb.sb_agblocks;
> > +
> >  	/* Bail out if we're uninitialized, which can happen in mkfs. */
> >  	if (mp->m_inobt_mxr[0] == 0)
> >  		return 0;
> >  
> > +	/* last AG can be a runt */
> > +	if (agno == mp->m_sb.sb_agcount - 1) {
> > +		div_u64_rem(mp->m_sb.sb_dblocks, mp->m_sb.sb_agblocks,
> > +				&agblocks);
> > +	}
> 
> Why not: agblocks = xfs_ag_block_count(mp, agno); ?
> 

forgot about that function :)

Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
