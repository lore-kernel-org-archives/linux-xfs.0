Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751191AbdKURf7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 12:35:59 -0500
Date: Tue, 21 Nov 2017 12:35:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171121173557.GB6004@bfoster.bfoster>
References: <20171121150557.GA5014@bfoster.bfoster>
 <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Tinguely <mark.tinguely@hpe.com>
Cc: linux-xfs@vger.kernel.org

cc linux-xfs

On Tue, Nov 21, 2017 at 10:51:10AM -0600, Mark Tinguely wrote:
> On 11/21/2017 09:05 AM, Brian Foster wrote:
> > I ended up looking at tr_ifree while investigating some options to
> > resolve this problem and am slightly confused by the reservation
> > calculation. In particular, we do this for the inobt portion of the
> > operation (i.e., "the inode btree: max depth * blocksize"):
> > 
> >                  xfs_calc_buf_res(2 + mp->m_ialloc_blks +
> >                                   mp->m_in_maxlevels, 0) +
> 

Hi Mark,

> I reviewed the Jeff Lui refactoring of the log space calculation years
> ago....
> 
> There is some combination of entries  only difference that I see is that the
> original calculation used the generic btree calculation for the inode btree
> and the generic btree calculation accounts for the by-block and by-count, so
> they are times two:
> 
> /*
>  * In freeing an inode we can modify:
>  *    the inode being freed: inode size
>  *    the super block free inode counter: sector size
>  *    the agi hash list and counters: sector size
>  *    the inode btree entry: block size
>  *    the on disk inode before ours in the agi hash list: inode cluster size
>  *    the inode btree: max depth * blocksize
>  *    the allocation btrees: 2 trees * (max depth - 1) * block size
>  */
> STATIC uint
> xfs_calc_ifree_reservation(
>         struct xfs_mount        *mp)
> {
>         return XFS_DQUOT_LOGRES(mp) +
>                 mp->m_sb.sb_inodesize +
>                 mp->m_sb.sb_sectsize +
>                 mp->m_sb.sb_sectsize +
>                 XFS_FSB_TO_B(mp, 1) +
>                 MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
>                     XFS_INODE_CLUSTER_SIZE(mp)) +
>                 128 * 5 +
>                 XFS_ALLOCFREE_LOG_RES(mp, 1) +
>                 128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
>                        XFS_ALLOCFREE_LOG_COUNT(mp, 1));
> }
> ...

Indeed, this looks fairly similar to the line cited above from the
current code (modulo the xfs_calc_buf_res() refactoring). I'm curious
why we only consider the buffer overhead (i.e., 128 bytes *
->m_in_maxlevels) of the ->m_in_maxlevels value rather than the full
buffer size.

> /*
>  * Per-extent log reservation for the allocation btree changes
>  * involved in freeing or allocating an extent.
>  * 2 trees * (2 blocks/level * max depth - 1) * block size
>  */
> #define XFS_ALLOCFREE_LOG_RES(mp,nx) \
>         ((nx) * (2 * XFS_FSB_TO_B((mp), 2 * XFS_AG_MAXLEVELS(mp) - 1)))
> #define XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
>         ((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
> 
> Doesn't the blocks for the btrees get allocated in:
> 
> 	xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
>                                  XFS_FSB_TO_B(mp, 1)) +

Yeah, I believe that covers the log reservation for the allocation
btrees. I'm wondering if/where we'd account for a join of the inobt due
to freeing an inode chunk and removing the associated inobt record. I
suppose the above could also cover the inobt since the transaction is
rolled, but then aren't we assuming that m_in_maxlevels ==
m_ag_maxlevels..?

Brian

> 
> And the rest of the calculation counts the log chunks that can get modified?
