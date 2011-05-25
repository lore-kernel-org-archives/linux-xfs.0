Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0SNJG105829 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:28:23 -0500
Subject: Re: [PATCH 3/9] xfs: correctly decrement the extent buffer index
	in xfs_bmap_del_extent
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150711.786279651@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.786279651@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:27:14 -0500
Message-ID: <1306283234.2823.92.camel@doink>
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

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-fix-ep-access)
> The code in xfs_bmap_del_extent does not correctly decrement the extent buffer
> index when deleting a whole extent.  Most of the time this gets caught by
> checks in xfs_bmapi that work around it and decrement it manually and thus
> wasn't noticed so far.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This one crashes in test 008.  I suspect it's due to
what Lachlan pointed out--the index can go negative
and we aren't (yet) ensuring we don't call into
xfs_iext_get_ext() in that case--but I have not
absolutely verified this.

It would be better if this change were combined
with the portion of patch 6 that pulls out the
    if (lastx >= XFS_IFORK_NEXTENTS()
check in xfs_bunmapi().  But it still would
need to go later in the series.

This does look like it's a reasonable thing to do,
it moves "left" in extent list because we know
we've exhausted the current one, and the only
caller--xfs_bunmapi()--is going from the end
backward.  I think the same decrement would be
appropriate for "case 2" below where you put this
change though (because there will be no more of
the current extent remaining after deleting the
left portion).  In fact, it looks to me like
the only one that got it right was "case 1"
because if you're splitting an extent (case 0)
the next one to examine will be the left one
of the two resulting from the split.  (I'm a
bit unsure about these observations though,
you or someone else should verify this and
set me straight if I'm wrong.)

It's all a bit confusing though.  It's not
obvious here what the value of *idx should be
after one of these operations, certainly not
independent of knowledge of whether the
extents are being scanned from the beginning
(as xfs_bmapi() does) or from the end (as
xfs_bunmap() does).


I moved this one change to the end of the series
and I no longer hit the problem I had with test
008 (presumably because the index checking in
later patches avoids the problem).  I will
keep testing with the whole series, with
this one at the end.

Meanwhile I'm interested to hear back on
whether other spots in xfs_bmap_del_extent()
should adjust the index value.

					-Alex



> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-10 17:11:21.212901236 +0200
> +++ xfs/fs/xfs/xfs_bmap.c	2011-05-10 17:13:36.177399627 +0200
> @@ -2916,8 +2916,10 @@ xfs_bmap_del_extent(
>  		 */
>  		xfs_iext_remove(ip, *idx, 1,
>  				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
> +		--*idx;
>  		if (delay)
>  			break;
> +
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		flags |= XFS_ILOG_CORE;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
