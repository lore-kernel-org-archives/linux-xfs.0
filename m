Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932215AbeEIKMG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 06:12:06 -0400
Date: Wed, 9 May 2018 06:12:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/9] xfs: fix double ijoin in
 xfs_reflink_clear_inode_flag()
Message-ID: <20180509101204.GB64624@bfoster.bfoster>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-8-david@fromorbit.com>
 <20180508141826.GH4764@bfoster.bfoster>
 <20180509004059.GO23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509004059.GO23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 09, 2018 at 10:40:59AM +1000, Dave Chinner wrote:
> On Tue, May 08, 2018 at 10:18:26AM -0400, Brian Foster wrote:
> > On Tue, May 08, 2018 at 01:42:00PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Another assert failure:
> > > 
> > > XFS: Assertion failed: !(lip->li_flags & XFS_LI_TRANS), file: fs/xfs/xfs_trans.c, line: 740
> > 
> > Same assert comment...
> > 
> > > ....
> > > xfs_trans_add_item+0xcc/0xe0
> > > xfs_reflink_clear_inode_flag+0x53/0x120
> > > xfs_reflink_try_clear_inode_flag+0x5b/0xa0
> > > ? filemap_write_and_wait+0x4f/0x70
> > > xfs_reflink_unshare+0x18e/0x19d
> > > xfs_file_fallocate+0x241/0x310
> > > ? selinux_file_permission+0xd4/0x140
> > > vfs_fallocate+0x13d/0x260
> > > SyS_fallocate+0x43/0x80
> > > 
> > > Another fix.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_reflink.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index bce2b5351d64..12d441a73b53 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -1553,7 +1553,12 @@ xfs_reflink_inode_has_shared_extents(
> > >  	return 0;
> > >  }
> > >  
> > > -/* Clear the inode reflink flag if there are no shared extents. */
> > > +/*
> > > + * Clear the inode reflink flag if there are no shared extents.
> > > + *
> > > + * The caller is responsible for joining the inode to the transaction passed in.
> > > + * The inode will be joined to the transaction that is returned to the caller.
> > > + */
> > >  int
> > >  xfs_reflink_clear_inode_flag(
> > >  	struct xfs_inode	*ip,
> > > @@ -1572,7 +1577,6 @@ xfs_reflink_clear_inode_flag(
> > >  	 * We didn't find any shared blocks so turn off the reflink flag.
> > >  	 * First, get rid of any leftover CoW mappings.
> > >  	 */
> > > -	xfs_trans_ijoin(*tpp, ip, 0);
> > 
...
> 
> > This seems a bit
> > superfluous. If the inode was already joined by the one caller of this
> > function, why not just remove this call in the previous patch rather
> > than move it and remove it?
> 
> Because every time I put multiple independent fixes into a single
> patch I get told to separate them into individual patches.
> 

Ok, fair enough:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
