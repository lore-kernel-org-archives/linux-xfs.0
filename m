Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NCDcdi091104 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:13:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 817C2B14B3E
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:16:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1oBR1RwhQUNRasJq for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:16:39 -0700 (PDT)
Date: Wed, 23 Mar 2011 08:16:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
Message-ID: <20110323121638.GB468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
	<20110322233054.GD15270@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322233054.GD15270@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 10:30:54AM +1100, Dave Chinner wrote:
> > +	if (error)
> > +		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len);
> 
> Shouldn't that be "if (!error)"?  i.e. if we freed the extent
> successfully we need to insert it in the busy list. This current
> code has the effect of never inserting freed data extents in the
> busy list....

Yes, it should.  This got messed up at some point during reshuffling
the series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
