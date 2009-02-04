Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n148VlCc132337 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 02:31:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A328E3D37
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 00:31:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kCDg2O3H6YCFMCIE for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 00:31:08 -0800 (PST)
Date: Wed, 4 Feb 2009 03:30:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090204083037.GA17493@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090203214711.GA24837@infradead.org>
	<20090203220808.GA9195@infradead.org>
	<200902041648.55603.nickpiggin@yahoo.com.au>
	<20090204081547.GA21487@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090204081547.GA21487@infradead.org>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 03:15:47AM -0500, Christoph Hellwig wrote:
> On Wed, Feb 04, 2009 at 04:48:55PM +1100, Nick Piggin wrote:
> > OK, I could reproduce this directly with a vmap test. With this patch,
> > I'm no longer able to. (not sure how this mail client goes with attaching
> > patches, sorry if it messes up)
> 
> With that patch applies I run into a different issue:

And later on we run out of vmalloc space a lot getting warnings like
this:

[ 5796.986579] vmap allocation for size 4194304 failed: use
vmalloc=<size> to increase size.
[ 5797.008728] xfs_buf_get_noaddr: failed to map pages


This didn't happen before.  Maybe it's a result of some of the more
lazy TLB flushing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
