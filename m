Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MFIBCS090814 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 10:18:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31FE08E134
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:18:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HOLMRnowlHaBlbRd for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 08:18:08 -0700 (PDT)
Date: Fri, 22 Jul 2011 11:18:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfs: Remove the macro XFS_BUF_ZEROFLAGS
Message-ID: <20110722151805.GE30317@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012116.6629.48217.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716015901.GC589@infradead.org>
	<1311269391.3210.956.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311269391.3210.956.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 21, 2011 at 10:29:51AM -0700, Chandra Seetharaman wrote:
> > >  	XFS_BUF_SET_COUNT(bp, count);
> > >  	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
> > > -	XFS_BUF_ZEROFLAGS(bp);
> > > +	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
> > >  	XFS_BUF_BUSY(bp);
> > >  	XFS_BUF_ASYNC(bp);
> > >  	bp->b_flags |= XBF_LOG_BUFFER;
> > 
> > Note that XBF_ORDERED is gone in the current tree, you need to rebase
> > your patches to pick up the buffer changes I recently sent out.
> > 
> > I don't link this blind expansion.  For one all that flag setting is
> > duplicated in two places in xlog_sync, please send a patch to
> > consolidate it in xlog_bdstrat.  Second XBF_READ and XBF_DELWRI
> 
> The two places are using 2 different bps, how do you want it to be
> consolidated in xlog_bdstrat() ?

xlog_bdstrate is called for both buffers, so any code that's the same
for both can be moved into it.  If you don't want to go down to that
level just leave the macro in for your next series, and I'll fix it
later.

> It looks cleaner if I just have those flags cleared above, instead of
> conditionally clearing them, what do you think ?

I don't really care either way.

> > XBF_READ, XBF_WRITE, XBF_ASYNC and XBF_DELWRI already get dealt with
> > in xfs_bwrite a few lines down, and XBF_ORDERED can't be set here. IOW
> > this line can simply be removed.
> 
> New definition of XFS_BUF_ZEROFLAGS has these: XBF_SYNCIO, XBF_FUA, and
> XBF_FLUSH. In this context is it ok to not clear those ?

Yes, all these are only ever set on log buffers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
