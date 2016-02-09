Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A853F29DF6
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:24:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B03CAC005
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:24:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	W0W9sc18adaMIZ4x for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 15:24:32 -0800 (PST)
Date: Wed, 10 Feb 2016 10:16:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: Introduce writeback context for writepages
Message-ID: <20160209231637.GJ14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-3-git-send-email-david@fromorbit.com>
	<20160209133941.GA13357@infradead.org>
	<20160209214850.GE14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209214850.GE14668@dastard>
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

On Wed, Feb 10, 2016 at 08:48:50AM +1100, Dave Chinner wrote:
> On Tue, Feb 09, 2016 at 05:39:41AM -0800, Christoph Hellwig wrote:
> > > -	if (!ioend || need_ioend || type != ioend->io_type) {
> > > -		xfs_ioend_t	*previous = *result;
> > > -
> > > -		ioend = xfs_alloc_ioend(inode, type);
> > > -		ioend->io_offset = offset;
> > > -		ioend->io_buffer_head = bh;
> > > -		ioend->io_buffer_tail = bh;
> > > -		if (previous)
> > > -			previous->io_list = ioend;
> > > -		*result = ioend;
> > > +	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
> > > +	    bh->b_blocknr != wpc->last_block + 1) {
> > 
> > We now start a new ioend if the blocks aren't contiguous, which seems
> > reasonable.  But this also means the similar check in xfs_submit_ioend
> > should be removed at the same time.
> 
> OK.

On second thoughts, I have another patch I haven't posted yet that
builds bios directly in xfs_add_to_ioend() that gets rid of the
buffer head chain walk during submission, so I'll leave changing the
submission code to that patch rather than changing here...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
