Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BF477CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 19:57:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 056A4AC003
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:57:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jTcJGVwVQmrWKB6j for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 17:57:29 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:57:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/48] xfs: add CRC checks to block format directory blocks
Message-ID: <20130725005725.GE11222@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-10-git-send-email-david@fromorbit.com>
	<20130724205358.GR3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130724205358.GR3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 24, 2013 at 03:53:58PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:32AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that directory buffers are made from a single struct xfs_buf, we
> > can add CRC calculation and checking callbacks. While there, add all
> > the fields to the on disk structures for future functionality such
> > as d_type support, uuids, block numbers, owner inode, etc.
> > 
> > To distinguish between the different on disk formats, change the
> > magic numbers for the new format directory blocks.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> corresponds to commit f5f3d9b016
> 
> > ---
> >  include/xfs_dir2_format.h |  155 +++++++++++++++++++++++++++++++++++++++++--
> >  libxfs/xfs_dir2_block.c   |  126 +++++++++++++++++++++++++----------
> >  libxfs/xfs_dir2_data.c    |  160 ++++++++++++++++++++++++++++-----------------
> >  libxfs/xfs_dir2_leaf.c    |    6 +-
> >  libxfs/xfs_dir2_node.c    |    2 +-
> >  libxfs/xfs_dir2_priv.h    |    4 +-
> >  libxfs/xfs_dir2_sf.c      |    2 +-
> >  7 files changed, 346 insertions(+), 109 deletions(-)
> > 
> > diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
> > index f5c264a..da928c7 100644
> > --- a/include/xfs_dir2_format.h
> > +++ b/include/xfs_dir2_format.h
> 
> ...
> 
> > @@ -215,11 +247,43 @@ typedef struct xfs_dir2_data_free {
> >   */
> >  typedef struct xfs_dir2_data_hdr {
> >  	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
> > -						/* XFS_DIR2_BLOCK_MAGIC */
> > +	/* XFS_DIR2_BLOCK_MAGIC */
> 
> This change to remove some tabs does not match the kernel code.  Suggest you
> remove it.  Maybe you have done that in one of the syncs later.

All this has been done in later syncs. I'd suggest that you need to
check the current code, as what was committed to  the crc-dev branch
didn't *exactly* match what was in the kernel code.

Why do you think I spent so much time trying to unify them after
this?


> > +	bf = xfs_dir3_data_bestfree_p(hdr);
> > +	p = (char *)xfs_dir3_data_entry_p(hdr);
> >  
> >  	switch (be32_to_cpu(hdr->magic)) {
> >  	case XFS_DIR2_BLOCK_MAGIC:
> > +	case XFS_DIR3_BLOCK_MAGIC:
> 	    ^^^^^
> 
> In the kernel the endian flip is done here, not in the switch parens.

See later patches. It's done that way here because the kernel method
causes compilation failure. i.e. this patch:

[PATCH 06/49] libxfs: fix byte swapping on constants

modifies the xfsprogs infrastructure to allow the kernel method to
be used in userspace, and it swaps all the libxfs code around.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
