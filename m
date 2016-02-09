Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BA8329DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:48:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B473AC005
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:48:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SympHHJR636AqXdW for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:48:51 -0800 (PST)
Date: Wed, 10 Feb 2016 08:48:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: Introduce writeback context for writepages
Message-ID: <20160209214850.GE14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-3-git-send-email-david@fromorbit.com>
	<20160209133941.GA13357@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209133941.GA13357@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 05:39:41AM -0800, Christoph Hellwig wrote:
> Removing xfs_cancel_ioend and replacing it with the start and cancel
> writeback scheme that we currently only use for
> xfs_setfilesize_trans_alloc failures actually seems to be the biggest
> change in this patch and is entirely undocumented.  Any chance you
> could split this into a prep patch and properly document it?

I can try.

> > -
> > -	if (!ioend || need_ioend || type != ioend->io_type) {
> > -		xfs_ioend_t	*previous = *result;
> > -
> > -		ioend = xfs_alloc_ioend(inode, type);
> > -		ioend->io_offset = offset;
> > -		ioend->io_buffer_head = bh;
> > -		ioend->io_buffer_tail = bh;
> > -		if (previous)
> > -			previous->io_list = ioend;
> > -		*result = ioend;
> > +	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
> > +	    bh->b_blocknr != wpc->last_block + 1) {
> 
> We now start a new ioend if the blocks aren't contiguous, which seems
> reasonable.  But this also means the similar check in xfs_submit_ioend
> should be removed at the same time.

OK.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
