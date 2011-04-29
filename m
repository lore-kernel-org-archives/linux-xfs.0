Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T1AAfB032224 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 20:10:10 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C5FC41F2C6
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:13:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tY4WvtVyoGuVLFwS for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 18:13:43 -0700 (PDT)
Date: Fri, 29 Apr 2011 11:13:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: reduce the number of pagb_lock roundtrips in
	xfs_alloc_clear_busy
Message-ID: <20110429011340.GX12436@dastard>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190657.249817918@bombadil.infradead.org>
	<1303923381.2056.58.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303923381.2056.58.camel@doink>
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

On Wed, Apr 27, 2011 at 11:56:21AM -0500, Alex Elder wrote:
> On Sun, 2011-04-24 at 15:06 -0400, Christoph Hellwig wrote:
> > Instead of finding the per-ag and then taking and releasing the pagb_lock
> > for every single busy extent completed sort the list of busy extents and
> > only switch betweens AGs where nessecary.  This becomes especially important
> > with the online discard support which will hit this lock more often.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I said this looked good before, but since you haven't
> indicated that here yet, I'll make one more comment.
> 
> Both places that call (the new) xfs_alloc_busy_clear()
> precede the call with a call to xfs_alloc_busy_sort().
> Considering that, and the fact that xfs_alloc_busy_clear()
> depends on the list being sorted for correct (or at least
> efficient) operation, I think you should just embed the
> list_sort() call in xfs_alloc_busy_clear().
> 
> There would then be no real need to define the
> xfs_alloc_busy_sort() helper (just call list_sort()
> directly), and you can move the definition of
> xfs_busy_extent_ag_cmp() up in the file and give
> it private scope.

I agree with this - sorting the list externally just seems to
complicate the API and means callers need to remember to sort the
list first...

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
