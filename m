Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932624AbcKVNBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:01:22 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 230E564E0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 13:01:22 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAMD14FC009308
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 08:01:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: pass post-eof speculative prealloc blocks to bmapi
Date: Tue, 22 Nov 2016 08:01:02 -0500
Message-Id: <1479819662-64416-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
References: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_file_iomap_begin_delay() implements post-eof speculative
preallocation by extending the block count of the requested delayed
allocation. Now that xfs_bmapi_reserve_delalloc() has been updated to
handle prealloc blocks separately and tag the inode, update
xfs_file_iomap_begin_delay() to use the new parameter and rely on the
former to tag the inode.

Note that this patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4062727..4f46f49 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -536,10 +536,11 @@ xfs_file_iomap_begin_delay(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		maxbytes_fsb =
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	xfs_fileoff_t		end_fsb, orig_end_fsb;
+	xfs_fileoff_t		end_fsb;
 	int			error = 0, eof = 0;
 	struct xfs_bmbt_irec	got;
 	xfs_extnum_t		idx;
+	xfs_fsblock_t		prealloc_blocks = 0;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
@@ -594,33 +595,32 @@ xfs_file_iomap_begin_delay(
 	 * the lower level functions are updated.
 	 */
 	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
-	end_fsb = orig_end_fsb =
-		min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
 
 	if (eof) {
-		xfs_fsblock_t	prealloc_blocks;
-
 		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;
+			xfs_fileoff_t	p_end_fsb;
 
 			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
-			end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
-				prealloc_blocks;
+			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
+					prealloc_blocks;
 
 			align = xfs_eof_alignment(ip, 0);
 			if (align)
-				end_fsb = roundup_64(end_fsb, align);
+				p_end_fsb = roundup_64(p_end_fsb, align);
 
-			end_fsb = min(end_fsb, maxbytes_fsb);
-			ASSERT(end_fsb > offset_fsb);
+			p_end_fsb = min(p_end_fsb, maxbytes_fsb);
+			ASSERT(p_end_fsb > offset_fsb);
+			prealloc_blocks = p_end_fsb - end_fsb;
 		}
 	}
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, 0, &got, &idx, eof);
+			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
 	switch (error) {
 	case 0:
 		break;
@@ -628,8 +628,8 @@ xfs_file_iomap_begin_delay(
 	case -EDQUOT:
 		/* retry without any preallocation */
 		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (end_fsb != orig_end_fsb) {
-			end_fsb = orig_end_fsb;
+		if (prealloc_blocks) {
+			prealloc_blocks = 0;
 			goto retry;
 		}
 		/*FALLTHRU*/
@@ -637,13 +637,6 @@ xfs_file_iomap_begin_delay(
 		goto out_unlock;
 	}
 
-	/*
-	 * Tag the inode as speculatively preallocated so we can reclaim this
-	 * space on demand, if necessary.
-	 */
-	if (end_fsb != orig_end_fsb)
-		xfs_inode_set_eofblocks_tag(ip);
-
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
-- 
2.7.4

