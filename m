Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1766008AbdAJNw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:52:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 185/206] xfs: use new extent lookup helpers in __xfs_reflink_reserve_cow
Date: Tue, 10 Jan 2017 14:37:48 +0100
Message-Id: <20170110131511.463154728@linuxfoundation.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-xfs@vger.kernel.org, Dave Chinner" <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>Dave Chinner <david@fromorbit.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


commit 2755fc4438501c8c28e7783df890e889f6772bee upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -243,10 +243,11 @@ xfs_reflink_reserve_cow(
 	struct xfs_bmbt_irec	*imap,
 	bool			*shared)
 {
-	struct xfs_bmbt_irec	got, prev;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_bmbt_irec	got;
 	xfs_fileoff_t		end_fsb, orig_end_fsb;
-	int			eof = 0, error = 0;
-	bool			trimmed;
+	int			error = 0;
+	bool			eof = false, trimmed;
 	xfs_extnum_t		idx;
 	xfs_extlen_t		align;
 
@@ -258,8 +259,9 @@ xfs_reflink_reserve_cow(
 	 * extent list is generally faster than going out to the shared extent
 	 * tree.
 	 */
-	xfs_bmap_search_extents(ip, imap->br_startoff, XFS_COW_FORK, &eof, &idx,
-			&got, &prev);
+
+	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &idx, &got))
+		eof = true;
 	if (!eof && got.br_startoff <= imap->br_startoff) {
 		trace_xfs_reflink_cow_found(ip, imap);
 		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);


