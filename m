Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754360AbcJMN0z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 09:26:55 -0400
Date: Thu, 13 Oct 2016 09:26:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: refactor xfs_bunmapi_cow
Message-ID: <20161013132647.GB9339@bfoster.bfoster>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
 <1476106685-29048-7-git-send-email-hch@lst.de>
 <20161012141308.GB56019@bfoster.bfoster>
 <20161013065432.GC10579@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161013065432.GC10579@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Oct 13, 2016 at 08:54:32AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 12, 2016 at 10:13:08AM -0400, Brian Foster wrote:
> > > +	/*
> > > +	 * Update the inode delalloc counter now and wait to update the
> > > +	 * sb counters as we might have to borrow some blocks for the
> > > +	 * indirect block accounting.
> > > +	 */
> > > +	xfs_trans_reserve_quota_nblks(NULL, ip, -((long)del->br_blockcount), 0,
> > > +			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> > > +	ip->i_delayed_blks -= del->br_blockcount;
> > > +
> > 
> > This appears to be fixed up later, but i_delayed_blks is accounted twice
> > as of this patch. It would be nice if we could avoid known breakage,
> > even if transient.
> 
> Where do we account for it the second time?
> 

Note again that this is transient and fixed up in a later patch (so you
won't see it looking at the code with the full series applied). But as
of this patch the following is possible:

  ...
  xfs_reflink_cancel_cow_blocks()
    i_delayed_blks -= blockcount
    xfs_bunmapi_cow()
      xfs_bmap_del_extent_delay()
        i_delayed_blks -= blockcount

Brian

> > > +	case 0:
> > > +		/*
> > > +		 * Deleting the middle of the extent.
> > > +		 *
> > > +		 * Distribute the original indlen reservation across the two
> > > +		 * new extents.  Steal blocks from the deleted extent if
> > > +		 * necessary. Stealing blocks simply fudges the fdblocks
> > > +		 * accounting in xfs_bunmapi().
> > > +		 */
> > > +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> > > +		got->br_blockcount = del->br_startoff - got->br_startoff;
> > > +
> > > +		got_indlen = xfs_bmap_worst_indlen(ip, got->br_blockcount);
> > > +		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
> > 
> > Doesn't look like new.br_blockcount is set until a few lines below.
> 
> Indeed.  Fixed for the next resend.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
