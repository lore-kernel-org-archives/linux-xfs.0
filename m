Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B5377CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 05:52:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8A3FAC002
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 03:52:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id neD7jF2yw3tCd7aX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2016 03:52:49 -0700 (PDT)
Date: Thu, 14 Jul 2016 06:52:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: helper to set flags on uncached buffer reads
Message-ID: <20160714105247.GA4207@bfoster.bfoster>
References: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
	<1468426595-35032-2-git-send-email-bfoster@redhat.com>
	<20160714000103.GR1922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160714000103.GR1922@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 14, 2016 at 10:01:04AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2016 at 12:16:33PM -0400, Brian Foster wrote:
> > xfs_buf_read_uncached() allocates an uncached buffer and performs a read
> > in one go. As part of the upcoming buftarg I/O accounting mechanism,
> > some sites may need to set flags on a buffer before I/O submission.
> > 
> > Create a new helper to support the ability to set flags on a buffer
> > before it is submitted for I/O. This use case is the exception, so
> > create a wrapper for the original xfs_buf_read_uncached().
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 20 +++++++++++++++++---
> >  fs/xfs/xfs_buf.h |  4 ++++
> >  2 files changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 4665ff6..f007713 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -693,13 +693,14 @@ xfs_buf_readahead_map(
> >   * buffer containing the disk contents or nothing.
> >   */
> >  int
> > -xfs_buf_read_uncached(
> > +xfs_buf_read_uncached_flags(
> >  	struct xfs_buftarg	*target,
> >  	xfs_daddr_t		daddr,
> >  	size_t			numblks,
> >  	int			flags,
> >  	struct xfs_buf		**bpp,
> > -	const struct xfs_buf_ops *ops)
> > +	const struct xfs_buf_ops *ops,
> > +	int			bflags)
> >  {
> 
> We already have a flags field being passed in. Why can't that be
> used to pass the XBF_NO_IOACCT flag? i.e:
> 

Oops, I read over that too quickly as I saw it being passed into
alloc_page() and assumed it was for memory allocation flags. It is in
fact for buffer flags.. we just use xb_to_gfp() to select GFP_* flags
based on the buffer flags. I'll drop this patch and fold the
xfs_buf_read_cached() fixup into patch 2. Thanks.

Brian

> >  	ASSERT(bp->b_map_count == 1);
> >  	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> >  	bp->b_maps[0].bm_bn = daddr;
> > -	bp->b_flags |= XBF_READ;
> > +	bp->b_flags |= XBF_READ | bflags;
> 
> 	bp->b_flags |= XBF_READ;
> 	bp->b_flags |= (flags & XBF_NO_IOACCT);
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
