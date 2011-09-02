Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p820HrHO045540 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 19:17:53 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47E6612E0F8
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2011 17:17:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0QGiQONe8axldGxZ for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2011 17:17:51 -0700 (PDT)
Date: Fri, 2 Sep 2011 10:17:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: call xfs_buf_delwri_queue directly
Message-ID: <20110902001747.GR32358@dastard>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.512830398@bombadil.infradead.org>
	<1314904935.2903.62.camel@doink>
	<20110901214640.GB4579@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110901214640.GB4579@infradead.org>
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
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Sep 01, 2011 at 05:46:40PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 01, 2011 at 02:22:15PM -0500, Alex Elder wrote:
> > that the buffer should be queued at unlock time, we now
> > just put it in the queue right away.  Seems reasonable.
> > Do you know why enqueueing it was delayed before?
> 
> I don't know why - it's a carryover from IRIX days,

Right. On Irix a buffer could simply have the BUF_DELWRI flag set on
it, and the buffer cache would take care of everything else. There
wasn't a specific delayed write list in Irix, instead there was a
fixed table of buffers (large!) that was scanned every 5 seconds
(20% scanned once per second) and the delwri buffers were gathered
by the scan.  Hence there were places in XFS where it simply set the
flag to mark a buffer delwri, and that's what this Linux code had to
catch.

> so long before my time.

The XFS code long predates me, too, but I spend a couple of years in
the trenches around the Irix buffer cache when I was at SGI so I at
least know why it was like that. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
