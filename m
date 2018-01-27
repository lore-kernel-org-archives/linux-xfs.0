Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbeA0BL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:11:26 -0500
Subject: [PATCH 7/7] xfs: don't screw up direct writes when freesp is
 fragmented
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:53 -0800
Message-ID: <151701545313.3070.9752957895549047286.stgit@magnolia>
In-Reply-To: <151701540938.3070.15043243007590700677.stgit@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_bmap_btalloc is given a range of file offset blocks that must be
allocated to some data/attr/cow fork.  If the fork has an extent size
hint associated with it, the request will be enlarged on both ends to
try to satisfy the alignment hint.  If free space is fragmentated,
sometimes we can allocate some blocks but not enough to fulfill any of
the requested range.  Since bmapi_allocate always trims the new extent
mapping to match the originally requested range, this results in
bmapi_write returning zero and no mapping.

The consequences of this vary -- buffered writes will simply re-call
bmapi_write until it can satisfy at least one block from the original
request.  Direct IO overwrites notice nmaps == 0 and return -ENOSPC
through the dio mechanism out to userspace with the weird result that
writes fail even when we have enough space because the ENOSPC return
overrides any partial write status.  For direct CoW writes the situation
was disastrous because nobody notices us returning an invalid zero-length
wrong-offset mapping to iomap and the write goes off into space.

Therefore, if free space is so fragmented that we managed to allocate
some space but not enough to map into even a single block of the
original allocation request range, we should break the alignment hint in
order to guarantee at least some forward progress for the direct write.
If we return a short allocation to iomap_apply it'll call back about the
remaining blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cad21fd..35660e9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3390,6 +3390,8 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
+	xfs_fileoff_t	orig_offset;
+	xfs_extlen_t	orig_length;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	nextminlen = 0;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -3399,6 +3401,8 @@ xfs_bmap_btalloc(
 	int		stripe_align;
 
 	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	mp = ap->ip->i_mount;
 
@@ -3614,6 +3618,22 @@ xfs_bmap_btalloc(
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
+		/*
+		 * If the extent size hint is active, we tried to round the
+		 * caller's allocation request offset down to extsz and the
+		 * length up to another extsz boundary.  If we found a free
+		 * extent we mapped it in starting at this new offset.  If the
+		 * newly mapped space isn't long enough to cover the entire
+		 * range of offsets that was originally requested, move the
+		 * mapping up so that we can fill as much of the caller's
+		 * original request as possible.  Free space is apparently
+		 * very fragmented so we're unlikely to be able to satisfy the
+		 * hints anyway.
+		 */
+		if (ap->length <= orig_length)
+			ap->offset = orig_offset;
+		else if (ap->offset + ap->length < orig_offset + orig_length)
+			ap->offset = orig_offset + orig_length - ap->length;
 		xfs_bmap_btalloc_accounting(ap, &args);
 	} else {
 		ap->blkno = NULLFSBLOCK;

