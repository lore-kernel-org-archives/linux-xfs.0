Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfBAOc6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 09:32:58 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F98FDA322
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:58 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4451E5D9D1
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 4/6] xfs: remove superfluous writeback mapping eof trimming
Date: Fri,  1 Feb 2019 09:32:54 -0500
Message-Id: <20190201143256.43232-5-bfoster@redhat.com>
In-Reply-To: <20190201143256.43232-1-bfoster@redhat.com>
References: <20190201143256.43232-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that the cached writeback mapping is explicitly invalidated on
data fork changes, the EOF trimming band-aid is no longer necessary.
Remove xfs_trim_extent_eof() as well since it has no other users.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 -----------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 fs/xfs/xfs_aops.c        | 15 ---------------
 3 files changed, 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 332eefa2700b..4c73927819c2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3685,17 +3685,6 @@ xfs_trim_extent(
 	}
 }
 
-/* trim extent to within eof */
-void
-xfs_trim_extent_eof(
-	struct xfs_bmbt_irec	*irec,
-	struct xfs_inode	*ip)
-
-{
-	xfs_trim_extent(irec, 0, XFS_B_TO_FSB(ip->i_mount,
-					      i_size_read(VFS_I(ip))));
-}
-
 /*
  * Trim the returned map to the required bounds
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 09d3ea97cc15..b4ff710d7250 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -181,7 +181,6 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
 
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
-void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5b0256a8a420..515532f45beb 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -357,19 +357,6 @@ xfs_map_blocks(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	/*
-	 * We have to make sure the cached mapping is within EOF to protect
-	 * against eofblocks trimming on file release leaving us with a stale
-	 * mapping. Otherwise, a page for a subsequent file extending buffered
-	 * write could get picked up by this writeback cycle and written to the
-	 * wrong blocks.
-	 *
-	 * Note that what we really want here is a generic mapping invalidation
-	 * mechanism to protect us from arbitrary extent modifying contexts, not
-	 * just eofblocks.
-	 */
-	xfs_trim_extent_eof(&wpc->imap, ip);
-
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
 	 * aren't shared.  COW I/O always takes precedent, so we must always
@@ -482,7 +469,6 @@ xfs_map_blocks(
 	}
 
 	wpc->imap = imap;
-	xfs_trim_extent_eof(&wpc->imap, ip);
 	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
 	return 0;
 allocate_blocks:
@@ -494,7 +480,6 @@ xfs_map_blocks(
 	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
 	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
 	wpc->imap = imap;
-	xfs_trim_extent_eof(&wpc->imap, ip);
 	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
 	return 0;
 }
-- 
2.17.2
