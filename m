Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LHU13J038231 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 12:30:02 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8001A16837AB
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 10:30:00 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id n8VUQJtCNhnmravH for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 10:30:00 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6LH8iDo004241
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 13:08:44 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6LHTtbo113278 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 13:29:55 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6LDTfCV015167 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 10:29:42 -0300
Subject: Re: [PATCH 02/12] xfs: Remove the macro XFS_BUF_ZEROFLAGS
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110716015901.GC589@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012116.6629.48217.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716015901.GC589@infradead.org>
Date: Thu, 21 Jul 2011 10:29:51 -0700
Message-ID: <1311269391.3210.956.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: xfs@oss.sgi.com

HI Christoph,

Some clarifications sought....

On Fri, 2011-07-15 at 21:59 -0400, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1367,7 +1367,7 @@ xlog_sync(xlog_t		*log,
> >  	}
> >  	XFS_BUF_SET_COUNT(bp, count);
> >  	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
> > -	XFS_BUF_ZEROFLAGS(bp);
> > +	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
> >  	XFS_BUF_BUSY(bp);
> >  	XFS_BUF_ASYNC(bp);
> >  	bp->b_flags |= XBF_LOG_BUFFER;
> 
> Note that XBF_ORDERED is gone in the current tree, you need to rebase
> your patches to pick up the buffer changes I recently sent out.
> 
> I don't link this blind expansion.  For one all that flag setting is
> duplicated in two places in xlog_sync, please send a patch to
> consolidate it in xlog_bdstrat.  Second XBF_READ and XBF_DELWRI

The two places are using 2 different bps, how do you want it to be
consolidated in xlog_bdstrat() ?

> won't ever be set here, so no need to clear them.  And XBF_WRITE
> and XBF_ASYNC will get re-set a few lines down the code, so no need
> to clear them either.  The XBF_FLUSH and XBF_FUA flag also get set
> conditionally a little below, so I'd just clear them in an else
> clause for the if condition checking if they should be set.

It looks cleaner if I just have those flags cleared above, instead of
conditionally clearing them, what do you think ?

> 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 04142ca..75ba081 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -261,7 +261,7 @@ xlog_bwrite(
> >  	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
> >  
> >  	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
> > -	XFS_BUF_ZEROFLAGS(bp);
> > +	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
> >  	XFS_BUF_BUSY(bp);
> >  	XFS_BUF_HOLD(bp);
> >  	XFS_BUF_PSEMA(bp, PRIBIO);
> 
> XBF_READ, XBF_WRITE, XBF_ASYNC and XBF_DELWRI already get dealt with
> in xfs_bwrite a few lines down, and XBF_ORDERED can't be set here. IOW
> this line can simply be removed.

New definition of XFS_BUF_ZEROFLAGS has these: XBF_SYNCIO, XBF_FUA, and
XBF_FLUSH. In this context is it ok to not clear those ?

> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
