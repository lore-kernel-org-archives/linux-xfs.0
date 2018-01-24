Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbeAXCSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:18:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27YUb065785
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:37 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fph1qr105-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:37 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2IbFf030836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:37 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0O2Iakj020525
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:36 GMT
Subject: [PATCH 06/11] xfs: fix up cowextsz allocation shortfalls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:18:35 -0800
Message-ID: <151676031559.12349.8327260913918740589.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_bmap_btalloc, we try using the CoW extent size hint to force
allocations to align (offset-wise) to cowextsz granularity to reduce CoW
fragmentation.  This works fine until we cannot satisfy the allocation
with enough blocks to cover the requested range and the alignment hints.
If this happens, return an unaligned region because if we don't the
extent trim functions cause us to return a zero-length extent to iomap,
which iomap doesn't catch and thus blows up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c               |    2 +-
 fs/xfs/libxfs/xfs_bmap.c |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)


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
index 93ce2c6..4ec1fdc5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3480,8 +3480,20 @@ xfs_bmap_btalloc_filestreams(
 static void
 xfs_bmap_btalloc_cow(
 	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_fileoff_t		orig_offset,
+	xfs_extlen_t		orig_length)
 {
+	/*
+	 * If we didn't get enough blocks to satisfy the cowextsize
+	 * aligned request, break the alignment and return whatever we
+	 * got; it's the best we can do.
+	 */
+	if (ap->length <= orig_length)
+		ap->offset = orig_offset;
+	else if (ap->offset + ap->length < orig_offset + orig_length)
+		ap->offset = orig_offset + orig_length - ap->length;
+
 	/* Filling a previously reserved extent; nothing to do here. */
 	if (ap->wasdel)
 		return;
@@ -3520,6 +3532,8 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
+	xfs_fileoff_t	orig_offset;
+	xfs_extlen_t	orig_length;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	nextminlen = 0;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -3529,6 +3543,8 @@ xfs_bmap_btalloc(
 	int		stripe_align;
 
 	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	mp = ap->ip->i_mount;
 
@@ -3745,7 +3761,8 @@ xfs_bmap_btalloc(
 		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		if (ap->flags & XFS_BMAPI_COWFORK) {
-			xfs_bmap_btalloc_cow(ap, &args);
+			xfs_bmap_btalloc_cow(ap, &args, orig_offset,
+					orig_length);
 		} else {
 			ap->ip->i_d.di_nblocks += args.len;
 			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);

