Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1W6sd156712 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:32:06 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5zXZklHgZhgHhKAw for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:34:34 -0800 (PST)
Date: Mon, 10 Dec 2012 12:34:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/5] xfs: fix segment in xfs_buf_item_format_segment
Message-ID: <20121210013406.GL15784@dastard>
References: <20121204231801.982422341@sgi.com>
	<20121204224938.820985192@sgi.com>
	<20121208122921.GC29107@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121208122921.GC29107@infradead.org>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sat, Dec 08, 2012 at 07:29:21AM -0500, Christoph Hellwig wrote:
> On Tue, Dec 04, 2012 at 05:18:04PM -0600, Mark Tinguely wrote:
> > Not every segment in a multi-segment buffer is dirty in a
> > transaction and they will not be outputted. The assert in
> > xfs_buf_item_format_segment() that checks for the at least
> > one chunk of data in the segment to be used is not necessary
> > true for multi-segmented buffers.
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > ---
> >  fs/xfs/xfs_buf_item.c |   20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > Index: b/fs/xfs/xfs_buf_item.c
> > ===================================================================
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -287,6 +287,17 @@ xfs_buf_item_format_segment(
> >  	 */
> >  	base_size = offsetof(struct xfs_buf_log_format, blf_data_map) +
> >  			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
> > +
> > +	nvecs = 0;
> > +	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> > +	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
> > +		/*
> > +		 * If the map is not be dirty in the transaction, mark
> > +		 * the size as zero and do not advance the vector pointer.
> > +		 */
> > +		goto out;
> > +	}
> > +
> 
> I don't really like the style of this check.  What's the problem of
> doing it this way:
> 
>   1) fill out the first vecp
>   2) do the stale check as-is
>   3) handle the the first_bit == -1 case  ala:
> 
> 	if (first_bit == -1) {
> 		blfp->blf_size = 0;
> 		return vecp;
> 	}

Because if we have already written all the dirty regions and we have
a trailing clean buffer segment, vecp points past the memory
allocated for the vectors. Hence we can end up with memory
corruption if we write to vecp in this case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
