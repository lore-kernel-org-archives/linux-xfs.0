Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:25268
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbeJEIUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:20:00 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0002u8-FK
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0000OV-Dl
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix data corruption w/ unaligned dedupe ranges
Date: Fri,  5 Oct 2018 11:23:35 +1000
Message-Id: <20181005012336.1418-2-david@fromorbit.com>
In-Reply-To: <20181005012336.1418-1-david@fromorbit.com>
References: <20181005012336.1418-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A deduplication data corruption is Exposed by fstests generic/505 on
XFS. It is caused by extending the block match range to include the
partial EOF block, but then allowing unknown data beyond EOF to be
considered a "match" to data in the destination file because the
comparison is only made to the end of the source file. This corrupts
the destination file when the source extent is shared with it.

XFS only supports whole block dedupe, but we still need to appear to
support whole file dedupe correctly.  Hence if the dedupe request
includes the last block of the souce file, don't include it in the
actual XFS dedupe operation. If the rest of the range dedupes
successfully, then report the partial last block as deduped, too, so
that userspace sees it as a successful dedupe rather than return
EINVAL because we can't dedupe unaligned blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5289e22cb081..6b0da1b80103 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1222,6 +1222,19 @@ xfs_iolock_two_inodes_and_break_layout(
 
 /*
  * Link a range of blocks from one file to another.
+ *
+ * The VFS allows partial EOF blocks to "match" for dedupe even though it hasn't
+ * checked that the bytes beyond EOF physically match. Hence we cannot use the
+ * EOF block in the source dedupe range because it's not a complete block match,
+ * hence can introduce a corruption into the file that has it's
+ * block replaced.
+ *
+ * Despite this issue, we still need to report that range as successfully
+ * deduped to avoid confusing userspace with EINVAL errors on completely
+ * matching file data. The only time that an unaligned length will be passed to
+ * us is when it spans the EOF block of the source file, so if we simply mask it
+ * down to be block aligned here the we will dedupe everything but that partial
+ * EOF block.
  */
 int
 xfs_reflink_remap_range(
@@ -1274,6 +1287,14 @@ xfs_reflink_remap_range(
 	if (ret <= 0)
 		goto out_unlock;
 
+	/*
+	 * If the dedupe data matches, chop off the partial EOF block
+	 * from the source file so we don't try to dedupe the partial
+	 * EOF block.
+	 */
+	if (is_dedupe)
+		len &= ~((u64)i_blocksize(inode_in) - 1);
+
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)
-- 
2.17.0
