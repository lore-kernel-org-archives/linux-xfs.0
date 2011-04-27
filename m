Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RGqpEa223134 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 11:52:51 -0500
Subject: Re: [PATCH 4/4] xfs: reduce the number of pagb_lock roundtrips in
	xfs_alloc_clear_busy
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110424190657.249817918@bombadil.infradead.org>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190657.249817918@bombadil.infradead.org>
Date: Wed, 27 Apr 2011 11:56:21 -0500
Message-ID: <1303923381.2056.58.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-04-24 at 15:06 -0400, Christoph Hellwig wrote:
> Instead of finding the per-ag and then taking and releasing the pagb_lock
> for every single busy extent completed sort the list of busy extents and
> only switch betweens AGs where nessecary.  This becomes especially important
> with the online discard support which will hit this lock more often.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I said this looked good before, but since you haven't
indicated that here yet, I'll make one more comment.

Both places that call (the new) xfs_alloc_busy_clear()
precede the call with a call to xfs_alloc_busy_sort().
Considering that, and the fact that xfs_alloc_busy_clear()
depends on the list being sorted for correct (or at least
efficient) operation, I think you should just embed the
list_sort() call in xfs_alloc_busy_clear().

There would then be no real need to define the
xfs_alloc_busy_sort() helper (just call list_sort()
directly), and you can move the definition of
xfs_busy_extent_ag_cmp() up in the file and give
it private scope.

Perhaps you have other plans that make the model you
have here more appropriate though.  Let me know
if you intend to re-submit, otherwise I'll just take
this version.

Either way, this looks good to me.  I have been
testing with these patches.  I'll wait another day
to give others a chance to review, but I'll plan
to incorporate this tomorrow.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
