Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728024AbeKGQBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:20 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/16] xfs: add zero-around controls to iomap
Date: Wed,  7 Nov 2018 17:31:24 +1100
Message-Id: <20181107063127.3902-14-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For buffered writes into block size > page size filesystems, XFS
will need to trigger zero-around for delayed allocation mappings
and writes over unwritten extents.

Unwritten extents will only remain unwritten until the first data
gets written back, so we have to ensure that any write mapping
triggers zero-around for them.

Delayed allocation occurs over holes, which then require the data in
the page cache to completely cover them at write-out time. Hence we
have to trigger write-around for these mappings, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 27c93b5f029d..35626855e207 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -575,6 +575,15 @@ xfs_file_iomap_begin_delay(
 				goto out_unlock;
 		}
 
+		/*
+		 * If we are about to write to an unwritten extent and the
+		 * the block size is larger than page size, then we need to make sure
+		 * that the caller zeroes blocks partially covered by data.
+		 */
+		if (got.br_state == XFS_EXT_UNWRITTEN &&
+		    mp->m_sb.sb_blocksize > PAGE_SIZE)
+			iomap->flags |= IOMAP_F_ZERO_AROUND;
+
 		trace_xfs_iomap_found(ip, offset, count, 0, &got);
 		goto done;
 	}
@@ -647,6 +656,8 @@ xfs_file_iomap_begin_delay(
 	 * them out if the write happens to fail.
 	 */
 	iomap->flags |= IOMAP_F_NEW;
+	if (mp->m_sb.sb_blocksize > PAGE_SIZE)
+		iomap->flags |= IOMAP_F_ZERO_AROUND;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1107,6 +1118,15 @@ xfs_file_iomap_begin(
 	if (flags & IOMAP_ZERO)
 		goto out_found;
 
+	/*
+	 * If we are about to write to an unwritten extent and the
+	 * the block size is larger than page size, then we need to make sure
+	 * that the caller zeroes blocks partially covered by data.
+	 */
+	if (imap.br_state == XFS_EXT_UNWRITTEN &&
+	    mp->m_sb.sb_blocksize > PAGE_SIZE)
+		iomap->flags |= IOMAP_F_ZERO_AROUND;
+
 	if (!imap_needs_alloc(inode, &imap, nimaps))
 		goto out_found;
 
-- 
2.19.1
