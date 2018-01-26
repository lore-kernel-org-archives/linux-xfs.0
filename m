Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbeAZCFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:05:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q22iZt109852
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2fqu60r0ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:19 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25EUx028458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:14 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25Dg1010662
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:14 GMT
Subject: [PATCH 4/6] xfs: don't screw up direct writes when freesp is
 fragmented
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:05:12 -0800
Message-ID: <151693231279.7395.4392783659285038910.stgit@magnolia>
In-Reply-To: <151693228803.7395.12526880865470882359.stgit@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
is disastrous because nobody notices us returning an invalid zero-length
wrong-offset mapping to iomap and the write goes off into space.

First of all, teach iomap and xfs_reflink_allocate_cow to check the
mappings being returned and bail out with ENOSPC if we can't get any
blocks.  Second of all, if free space is so fragmented we can't satisfy
even a single block of the original allocation request but did get a few
blocks, we should break the alignment hint in order to guarantee at
least some forward progress for the direct write.  If we return a short
allocation to iomap_apply it'll call back about the remaining blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c               |    2 +-
 fs/xfs/libxfs/xfs_bmap.c |   15 +++++++++++++++
 fs/xfs/xfs_reflink.c     |    6 ++++++
 3 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/iomap.c b/fs/iomap.c
index e5de772..aec35a0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -63,7 +63,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
 	if (ret)
 		return ret;
-	if (WARN_ON(iomap.offset > pos))
+	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
 		return -EIO;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 032befb..1fb885c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3386,6 +3386,8 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
+	xfs_fileoff_t	orig_offset;
+	xfs_extlen_t	orig_length;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	nextminlen = 0;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -3395,6 +3397,8 @@ xfs_bmap_btalloc(
 	int		stripe_align;
 
 	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	mp = ap->ip->i_mount;
 
@@ -3610,6 +3614,17 @@ xfs_bmap_btalloc(
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
+		/*
+		 * If we didn't get enough blocks to fill even one block of
+		 * the original request, break the alignment and return
+		 * whatever we got; it's the best we can do.  Free space is
+		 * fragmented enough that we cannot honor the extent size
+		 * hints but we can still make some forward progress.
+		 */
+		if (ap->length <= orig_length)
+			ap->offset = orig_offset;
+		else if (ap->offset + ap->length < orig_offset + orig_length)
+			ap->offset = orig_offset + orig_length - ap->length;
 		xfs_bmap_btalloc_accounting(ap, &args);
 	} else {
 		ap->blkno = NULLFSBLOCK;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9a6c545..9eca8aa 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -464,6 +464,12 @@ xfs_reflink_allocate_cow(
 	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
+	/*
+	 * Allocation succeeded but our request was not even partially
+	 * satisfied?  Bail out.
+	 */
+	if (nimaps == 0)
+		return -ENOSPC;
 convert:
 	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb,
 			&dfops);

