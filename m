Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UMBjTn076756 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:11:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kNFdUFcJghGzAGIO for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 15:13:34 -0700 (PDT)
Date: Wed, 31 Oct 2012 09:13:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/25] xfs: verify AGI blocks as they are read from disk
Message-ID: <20121030221333.GB29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-8-git-send-email-david@fromorbit.com>
	<20121030005321.GI30227@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030005321.GI30227@caliban.engr.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 05:53:22PM -0700, Phil White wrote:
> On Thu, Oct 25, 2012 at 05:33:56PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add an AGI block verify callback function and pass it into the
> > buffer read functions. Remove the now redundant verification code
> > that is currently in use.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_ialloc.c |   47 ++++++++++++++++++++++++++---------------------
> >  1 file changed, 26 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> > index 7c944e1..9311ae5 100644
> > --- a/fs/xfs/xfs_ialloc.c
> > +++ b/fs/xfs/xfs_ialloc.c
> > @@ -1472,6 +1472,31 @@ xfs_check_agi_unlinked(
> >  #define xfs_check_agi_unlinked(agi)
> >  #endif
> >  
> > +static void
> > +xfs_agi_read_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	struct xfs_mount *mp = bp->b_target->bt_mount;
> > +	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
> > +	int		agi_ok;
> > +
> > +	/*
> > +	 * Validate the magic number of the agi block.
> > +	 */
> > +	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
> > +		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
> > +		be32_to_cpu(agi->agi_seqno) == bp->b_pag->pag_agno;
> > +	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
> > +			XFS_RANDOM_IALLOC_READ_AGI))) {
> > +		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
> > +				     mp, agi);
> > +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +	}
> > +	xfs_check_agi_unlinked(agi);
> > +	bp->b_iodone = NULL;
> > +	xfs_buf_ioend(bp, 0);
> > +}
> > +
> 
> In like fashion, shouldn't this be XFS_CORRUPTION_ERROR("xfs_agi_read_verify",
> ...)?  In principle, it might be called from somewhere else in the future.

It should be converted to __func__. I thought I caught most of them,
but I didn't. It's not immediately critical - if I need to repost
the series, I'll fix them.

Most of these messages get revamped when CRC checking is enabled,
anyway, because there are different errors and more useful
information that is worth reporting. hence I haven't been too
concerned about little things like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
