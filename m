Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U2HlYR186515 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 21:17:47 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9ImFwLYGj1xkS9VN for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 19:17:45 -0700 (PDT)
Date: Mon, 30 Apr 2012 12:17:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 29/37 V3] xfs: move busy extent handling to it's own file
Message-ID: <20120430021727.GA7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-30-git-send-email-david@fromorbit.com>
	<20120423175725.GG16881@sgi.com> <20120424002502.GS9541@dastard>
	<4F96CD24.2070805@sgi.com> <4F96EC97.3050404@sgi.com>
	<20120429103943.GQ9541@dastard>
	<20120429215027.GH19889@infradead.org>
	<20120430003628.GC3283@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430003628.GC3283@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 10:36:28AM +1000, Dave Chinner wrote:
> On Sun, Apr 29, 2012 at 05:50:27PM -0400, Christoph Hellwig wrote:
> > I would have called it xfs_busy_extent.h, but given how far you are with
> > the series it's really not worth bike sheeding about this detail.
> 
> I'm ambivalent, really. I used extent_busy to match the
> xfs_extfree_item.c naming. i.e. extent specific manipulations are in
> xfs_ext* namespace. It's pretty simple to change (a couple of search
> and replace), so if you'd prefer busy_extent I can change it pretty
> quickly...

Actually, I just found a problem with this patch -
xfs_alloc_busy_trim is not properly handled - so I've got to respin
it. I'll change it all to busy_extent while I'm at it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
