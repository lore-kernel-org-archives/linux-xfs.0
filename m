Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p669BJXV099202 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 04:11:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5223415EB427
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 02:11:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lJD4dgr8HxF3TJQ4 for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 02:11:19 -0700 (PDT)
Date: Wed, 6 Jul 2011 05:11:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/27] xfs: cleanup I/O-related buffer flags
Message-ID: <20110706091118.GJ19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.536262104@bombadil.infradead.org>
	<20110706035411.GU1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706035411.GU1026@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Jul 06, 2011 at 01:54:11PM +1000, Dave Chinner wrote:
> Is it worthwhile tagging all these as READ_META and WRITE_META?
> Though that probably needs to be done as a separate commit...

Right now they preempt synchronous writes, which is not something we
want.  There is a patch out on lkml removing that hack, at which point
we should tag them as _META to make blktrace output more useful.

> >  /* flags used only internally */
> > -#define _XBF_PAGES	(1 << 18)/* backed by refcounted pages */
> > -#define	_XBF_RUN_QUEUES	(1 << 19)/* run block device task queue	*/
> > -#define	_XBF_KMEM	(1 << 20)/* backed by heap memory */
> > -#define _XBF_DELWRI_Q	(1 << 21)/* buffer on delwri queue */
> > +#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
> > +#define	_XBF_KMEM	(1 << 21)/* backed by heap memory */
> > +#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
> 
> Might be worthwhile cleaning up the stray tab before _XBF_KMEM
> there.

done.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
