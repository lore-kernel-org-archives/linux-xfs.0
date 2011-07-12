Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C9FDIa023906 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 04:15:13 -0500
Date: Tue, 12 Jul 2011 05:15:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] xfs: remove wrappers around b_fspriv
Message-ID: <20110712091509.GD8364@infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.863949257@bombadil.infradead.org>
	<1310423589.7019.59.camel@doink> <20110712010257.GL23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110712010257.GL23038@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Tue, Jul 12, 2011 at 11:02:57AM +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2011 at 05:33:09PM -0500, Alex Elder wrote:
> > On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I never did understand exactly why these things
> > were macro-ized, but figured it must have hidden
> > some sort of conditional debug or development aid
> > long ago.  In any case, good riddance.
> 
> It was part of the original Linux port. Both the Irix and Linux XFS
> code was converted to use these XFS_BUF macros. Hence the core XFS
> code was identical on both platforms and easy to move changes from
> Irix to Linux because the macros hid the differences in buffer cache
> implementations.

That was the theory, but these portability changes never got merged
back to IRIX.  On the other hand XFS/Linux actually had two different
buffer implementations in it's early days and the macros allowed
switching between them.  Back then the area was an even bigger mess,
as the buffer cache implementation that survived was called pagebuf,
and used page_buf_/pb_/PB_/ prefixes, which not only got mapped to
various different and often duplicate xfs_buf or similar names.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
