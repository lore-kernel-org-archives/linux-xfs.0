Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3JDpWkd220263 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 08:51:33 -0500
Subject: Re: [PATCHv2 5/5] xfs: kill off l_sectbb_mask
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100418172935.GA1677@infradead.org>
References: <201004162054.o3GKs54f025204@stout.americas.sgi.com>
	<20100418172935.GA1677@infradead.org>
Date: Mon, 19 Apr 2010 08:53:27 -0500
Message-ID: <1271685207.3032.54.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Sun, 2010-04-18 at 13:29 -0400, Christoph Hellwig wrote:
> On Fri, Apr 16, 2010 at 03:54:05PM -0500, Alex Elder wrote:
> > + * Return the address of the start of the given block number's data
> > + * in a log buffer.  The buffer covers a log sector-aligned region.
> > + */
> >  STATIC xfs_caddr_t
> >  xlog_align(
> >  	xlog_t		*log,
> > @@ -128,14 +132,14 @@ xlog_align(
> >  	int		nbblks,
> >  	xfs_buf_t	*bp)
> >  {
> > +	xfs_daddr_t	offset;
> >  	xfs_caddr_t	ptr;
> >  
> > -	if (log->l_sectBBsize == 1)
> > -		return XFS_BUF_PTR(bp);
> > +	offset = blk_no & ((xfs_daddr_t) log->l_sectBBsize - 1);
> > +	ptr = XFS_BUF_PTR(bp) + BBTOB(offset);
> > +
> > +	ASSERT(ptr + BBTOB(nbblks) <= XFS_BUF_PTR(bp) + XFS_BUF_SIZE(bp));
> >  
> > -	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
> > -	ASSERT(XFS_BUF_SIZE(bp) >=
> > -		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
> >  	return ptr;
> 
> And btw, now that I think about it we can just remove the
> log->l_sectBBsize == 1 case entirely, so the whole thing could become:

Yes, I contemplated that and am happy to do it that way.
I chose this way because there seemed to be "so much" cruft
that was not needed in that special case...  Anyway, I'll
change it to the way you suggest before committing it.

Thanks for the review.

					-Alex

> STATIC xfs_caddr_t
> xlog_align(
> 	struct log	*log,
> 	xfs_daddr_t	blk_no,
> 	int		nbblks,
> 	struct xfs_buf	*bp)
> {
> 	xfs_daddr_t	offset;
> 
> 	offset = blk_no & ((xfs_daddr_t) log->l_sectBBsize - 1);
> 	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
> 
> 	return XFS_BUF_PTR(bp) + BBTOB(offset);
> }



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
