Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbeIJLzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Sep 2018 07:55:14 -0400
Date: Mon, 10 Sep 2018 00:02:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix transaction leak in xfs_reflink_allocate_cow()
Message-ID: <20180910070241.GB30888@infradead.org>
References: <20180907015113.32448-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907015113.32448-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, git.user@gmail.com

> +	/*
> +	 * if we don't find an overlapping extent, trim the range we need to
> +	 * allocate to fit the hole we found.
> +	 */

Please capitalize the first letter in each sentence.

> +	*shared = true;
> +	if (isnullstartblock(got.br_startblock)) {
> +		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> +		return 0;
> +	}

Taken out of the context of the bigger function this conditional
could really use a comment as well.

> +	} while (tp);

This looks a little odd as tp will always be true if we reach this
point.  I'd suggest to switch to a do { } while (1) or for (;;) style
loop.

Alternatively we could just skip the loop entirely now that we have
the lookup + trim helper.  Untested patch below:

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 38f405415b88..79e2279d8e15 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -352,6 +352,47 @@ xfs_reflink_convert_cow(
 	return error;
 }
 
+/*
+ * Find the extent that maps the given range in the COW fork. Even if the extent
+ * is not shared we might have a preallocation for it in the COW fork. If so we
+ * use it that rather than trigger a new allocation.
+ */
+static int
+find_trim_cow_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	bool			*shared,
+	bool			*found)
+{
+	xfs_fileoff_t		offset_fsb = imap->br_startoff;
+	xfs_filblks_t		count_fsb = imap->br_blockcount;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	bool			trimmed;
+
+	*found = false;
+
+	/*
+	 * If we don't find an overlapping extent, trim the range we need to
+	 * allocate to fit the hole we found.
+	 */
+	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
+	    got.br_startoff > offset_fsb)
+		return xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+
+	*shared = true;
+	if (isnullstartblock(got.br_startblock)) {
+		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
+		return 0;
+	}
+
+	/* real extent found - no need to allocate */
+	xfs_trim_extent(&got, offset_fsb, count_fsb);
+	*imap = got;
+	*found = true;
+	return 0;
+}
+
 /* Allocate all CoW reservations covering a range of blocks in a file. */
 int
 xfs_reflink_allocate_cow(
@@ -363,78 +404,62 @@ xfs_reflink_allocate_cow(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = imap->br_startoff;
 	xfs_filblks_t		count_fsb = imap->br_blockcount;
-	struct xfs_bmbt_irec	got;
-	struct xfs_trans	*tp = NULL;
+	struct xfs_trans	*tp;
 	int			nimaps, error = 0;
-	bool			trimmed;
+	bool			found;
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks = 0;
-	struct xfs_iext_cursor	icur;
 
-retry:
-	ASSERT(xfs_is_reflink_inode(ip));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_reflink_inode(ip));
 
-	/*
-	 * Even if the extent is not shared we might have a preallocation for
-	 * it in the COW fork.  If so use it.
-	 */
-	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) &&
-	    got.br_startoff <= offset_fsb) {
-		*shared = true;
-
-		/* If we have a real allocation in the COW fork we're done. */
-		if (!isnullstartblock(got.br_startblock)) {
-			xfs_trim_extent(&got, offset_fsb, count_fsb);
-			*imap = got;
-			goto convert;
-		}
+	error = find_trim_cow_extent(ip, imap, shared, &found);
+	if (error || !*shared)
+		return error;
+	if (found)
+		goto convert;
 
-		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-	} else {
-		error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
-		if (error || !*shared)
-			goto out;
-	}
+	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
+		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
-	if (!tp) {
-		resaligned = xfs_aligned_fsb_count(imap->br_startoff,
-			imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-		resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	xfs_iunlock(ip, *lockmode);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	*lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, *lockmode);
 
-		xfs_iunlock(ip, *lockmode);
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
-		*lockmode = XFS_ILOCK_EXCL;
-		xfs_ilock(ip, *lockmode);
+	if (error)
+		return error;
 
-		if (error)
-			return error;
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error)
+		goto out_trans_cancel;
 
-		error = xfs_qm_dqattach_locked(ip, false);
-		if (error)
-			goto out;
-		goto retry;
+	/* check for an overlapping extent again no that we dropped the ilock */
+	error = find_trim_cow_extent(ip, imap, shared, &found);
+	if (error || !*shared)
+		goto out_trans_cancel;
+	if (found) {
+		xfs_trans_cancel(tp);
+		goto convert;
 	}
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
 	if (error)
-		goto out;
+		goto out_trans_cancel;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	nimaps = 1;
-
 	/* Allocate the entire reservation as unwritten blocks. */
+	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
 			resblks, imap, &nimaps);
 	if (error)
-		goto out_trans_cancel;
+		goto out_unreserve;
 
 	xfs_inode_set_cowblocks_tag(ip);
-
-	/* Finish up. */
 	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
@@ -447,12 +472,12 @@ xfs_reflink_allocate_cow(
 		return -ENOSPC;
 convert:
 	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
-out_trans_cancel:
+
+out_unreserve:
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
-out:
-	if (tp)
-		xfs_trans_cancel(tp);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
 	return error;
 }
 
