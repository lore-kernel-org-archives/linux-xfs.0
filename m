Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B6777CA0
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 14:19:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0BA1AC001
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 12:19:08 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id W3Ltq22yxnfB01fR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 12:19:02 -0700 (PDT)
Date: Sun, 31 Jul 2016 21:19:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160731191900.GA29301@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
	<20160718111400.GC16044@dastard> <20160718111851.GD16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160718111851.GD16044@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Another quiet weekend trying to debug this, and only minor progress.

The biggest different in traces of the old vs new code is that we manage
to allocate much bigger delalloc reservations at a time in xfs_bmapi_delay
-> xfs_bmapi_reserve_delalloc.  The old code always went for a single FSB,
which also meant allocating an indlen of 7 FSBs.  With the iomap code
we always allocate at least 4FSB (aka a page), and sometimes 8 or 12.
All of these still need 7 FSBs for the worst case indirect blocks.  So
what happens here is that in an ENOSPC case we manage to allocate more
actual delalloc blocks before hitting ENOSPC - notwithstanding that the
old case would immediately release them a little later in
xfs_bmap_add_extent_hole_delay after merging the delalloc extents.

On the writeback side I don't see to many changes either.  We'll
eventually run out of blocks when allocating the transaction in
xfs_iomap_write_allocate because the reserved pool is too small.  The
only real difference to before is that under the ENOSPC / out of memory
case we have allocated between 4 to 12 times more blocks, so we have
to clean up 4 to 12 times as much while write_cache_pages continues
iterating over these dirty delalloc blocks.   For me this happens
~6 times as much as before, but I still don't manage to hit an
endless loop.

Now after spending this much time I've started wondering why we even
reserve blocks in xfs_iomap_write_allocate - after all we've reserved
space for the actual data blocks and the indlen worst case in
xfs_bmapi_reserve_delalloc.  And in fact a little hack to drop that
reservation seems to solve both the root cause (depleted reserved pool)
and the cleanup mess.  I just haven't spend enought time to convince
myself that it's actually safe, and in fact looking at the allocator
makes me thing it only works by accident currently despite generally
postive test results.

Here is the quick patch if anyone wants to chime in:

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 620fc91..67c317f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -717,7 +717,7 @@ xfs_iomap_write_allocate(
 
 		nimaps = 0;
 		while (nimaps == 0) {
-			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+			nres = 0; // XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 
 			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
 					0, XFS_TRANS_RESERVE, &tp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
