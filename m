Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C0xVL8001351 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 19:59:31 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E40717B61F9
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:59:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	R5KymjfjNQGy00NM for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 17:59:29 -0700 (PDT)
Date: Tue, 12 Jul 2011 10:59:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: remove the dead QUOTADEBUG debug
Message-ID: <20110712005927.GK23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205018.525481665@bombadil.infradead.org>
	<1310423602.7019.62.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310423602.7019.62.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:33:22PM -0500, Alex Elder wrote:
> On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> > Remove the dead hash table test rid which has been rotting away under
> > QUOTADEBUG, including some code that was compiled for normal debug
> > builds, but not actually called without QUOTADEBUG, and enable a few
> > cheap debug checks that were hidden under QUOTADEBUG for normal
> > debug builds.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I've never used it and I don't suppose anyone else has
> been (or will any time soon).  So I guess it might as
> well go.

I have actually used it in the past year or so, but that was only
because I changed locking and needed to verify that the QUOTADEBUG
code still worked. But if it wasn't there, i wouldn't have had to do
that, so I'm happy to see it go.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
