Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752851AbcKHU1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 15:27:37 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64EF57F7D5
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2016 20:27:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA8KRb6R014912
        for <linux-xfs@vger.kernel.org>; Tue, 8 Nov 2016 15:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 2/4] xfs: logically separate iomap range from allocation range
Date: Tue,  8 Nov 2016 15:27:34 -0500
Message-Id: <1478636856-7590-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_file_iomap_begin_delay() function currently converts the bmbt
record output from the xfs_bmapi_reserve_delalloc() call to the iomap
mapping for the higher level iomap code. In preparation to reuse
xfs_file_iomap_begin_delay() for data fork and COW fork allocation,
logically separate the iomap mapping provided to the caller from the
bmbt record returned by xfs_bmapi_reserve_delalloc().

This is necessary because while COW reservation involves delalloc
allocation to the COW fork, the mapping returned to the caller must
still refer to the shared blocks from the data fork. Note that this
patch does not change behavior in any way.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 193aee4..7446531 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -539,6 +539,7 @@ xfs_file_iomap_begin_delay(
 	int			error = 0, eof = 0;
 	struct xfs_bmbt_irec	got;
 	struct xfs_bmbt_irec	prev;
+	struct xfs_bmbt_irec	imap;	/* for iomap */
 	xfs_extnum_t		idx;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
@@ -565,19 +566,20 @@ xfs_file_iomap_begin_delay(
 
 	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
 			&got, &prev);
+	imap = got;
 	if (!eof && got.br_startoff <= offset_fsb) {
 		if (xfs_is_reflink_inode(ip)) {
 			bool		shared;
 
 			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
 					maxbytes_fsb);
-			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &got, &shared);
+			xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
+			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
 			if (error)
 				goto out_unlock;
 		}
 
-		trace_xfs_iomap_found(ip, offset, count, 0, &got);
+		trace_xfs_iomap_found(ip, offset, count, 0, &imap);
 		goto done;
 	}
 
@@ -648,17 +650,18 @@ xfs_file_iomap_begin_delay(
 		xfs_inode_set_eofblocks_tag(ip);
 
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
+	imap = got;
 done:
-	if (isnullstartblock(got.br_startblock))
-		got.br_startblock = DELAYSTARTBLOCK;
+	if (isnullstartblock(imap.br_startblock))
+		imap.br_startblock = DELAYSTARTBLOCK;
 
-	if (!got.br_startblock) {
-		error = xfs_alert_fsblock_zero(ip, &got);
+	if (!imap.br_startblock) {
+		error = xfs_alert_fsblock_zero(ip, &imap);
 		if (error)
 			goto out_unlock;
 	}
 
-	xfs_bmbt_to_iomap(ip, iomap, &got);
+	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
2.7.4

