Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765996AbdAJNwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 183/206] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
Date: Tue, 10 Jan 2017 14:37:46 +0100
Message-Id: <20170110131511.361119026@linuxfoundation.org>
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


commit 65c5f419788d623a0410eca1866134f5e4628594 upstream.

We can easily lookup the previous extent for the cases where we need it,
which saves the callers from looking it up for us later in the series.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 ++++++--
 fs/xfs/libxfs/xfs_bmap.h |    3 +--
 fs/xfs/xfs_iomap.c       |    3 +--
 fs/xfs/xfs_reflink.c     |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4250,7 +4250,6 @@ xfs_bmapi_reserve_delalloc(
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*prev,
 	xfs_extnum_t		*lastx,
 	int			eof)
 {
@@ -4272,7 +4271,12 @@ xfs_bmapi_reserve_delalloc(
 	else
 		extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
-		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
+		struct xfs_bmbt_irec	prev;
+
+		if (!xfs_iext_get_extent(ifp, *lastx - 1, &prev))
+			prev.br_startoff = NULLFILEOFF;
+
+		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, rt, eof,
 					       1, 0, &aoff, &alen);
 		ASSERT(!error);
 	}
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -243,8 +243,7 @@ struct xfs_bmbt_rec_host *
 		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t aoff, xfs_filblks_t len,
-		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *prev,
-		xfs_extnum_t *lastx, int eof);
+		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -622,8 +622,7 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, &got,
-			&prev, &idx, eof);
+			end_fsb - offset_fsb, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -293,7 +293,7 @@ xfs_reflink_reserve_cow(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			end_fsb - imap->br_startoff, &got, &prev, &idx, eof);
+			end_fsb - imap->br_startoff, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;


