Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:18220
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbeJEIUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:20:03 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0002u9-G1
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0000OY-Ex
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix data corruption w/ unaligned reflink ranges
Date: Fri,  5 Oct 2018 11:23:36 +1000
Message-Id: <20181005012336.1418-3-david@fromorbit.com>
In-Reply-To: <20181005012336.1418-1-david@fromorbit.com>
References: <20181005012336.1418-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When reflinking sub-file ranges, a data corruption can occur when
the source file range includes a partial EOF block. This shares the
unknown data beyond EOF into the second file at a position inside
EOF, exposing stale data in the second file.

XFS only supports whole block sharing, but we still need to
support whole file reflink correctly.  Hence if the reflink
request includes the last block of the souce file, only proceed with
the reflink operation if it lands at or past the destination file's
current EOF. If it lands within the destination file EOF, reject the
entire request with -EINVAL and make the caller go the hard way.

This avoids the data corruption vector, but also avoids disruption
of returning EINVAL to userspace for the common case of whole file
cloning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6b0da1b80103..2615271603ce 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1229,12 +1229,24 @@ xfs_iolock_two_inodes_and_break_layout(
  * hence can introduce a corruption into the file that has it's
  * block replaced.
  *
- * Despite this issue, we still need to report that range as successfully
- * deduped to avoid confusing userspace with EINVAL errors on completely
- * matching file data. The only time that an unaligned length will be passed to
- * us is when it spans the EOF block of the source file, so if we simply mask it
- * down to be block aligned here the we will dedupe everything but that partial
- * EOF block.
+ * In similar fashion, the VFS file cloning also allows partial EOF blocks to be
+ * "block aligned" for the purposes of cloning entire files. 
+ * However, if the source file range
+ * includes the EOF block and it lands within the existing EOF of the
+ * destination file, then we can expose stale data from beyond the source file
+ * EOF in the destination file.
+ *
+ * XFs doesn't support partial block sharing, so in both cases we have check
+ * these cases ourselves. For dedupe, we can simply round the length to dedupe
+ * down to the previous whole block and ignore the partial EOF block. While this
+ * means we can't dedupe the last block of a file, this is an acceptible
+ * tradeoff for simplicity on implementation.
+ *
+ * For cloning, we want to share the partial EOF block if it is also the new EOF
+ * block of the destination file. If the partial EOF blck lies inside the
+ * existing destination EOF, then we have to abort the clone to avoid exposing
+ * stale data int eh destination file. Hence we reject these clone attempts with
+ * -EINVAL in this case.
  */
 int
 xfs_reflink_remap_range(
@@ -1255,6 +1267,7 @@ xfs_reflink_remap_range(
 	xfs_filblks_t		fsblen;
 	xfs_extlen_t		cowextsize;
 	ssize_t			ret;
+	u64			blkmask = i_blocksize(inode_in) - 1;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1292,8 +1305,18 @@ xfs_reflink_remap_range(
 	 * from the source file so we don't try to dedupe the partial
 	 * EOF block.
 	 */
-	if (is_dedupe)
-		len &= ~((u64)i_blocksize(inode_in) - 1);
+	if (is_dedupe) {
+		len &= ~blkmask;
+	} else if (len & blkmask) {
+		/*
+		 * The user is attempting to share a partial EOF block,
+		 * if it's inside the destination EOF then reject it
+		 */
+		if (pos_out + len < i_size_read(inode_out)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+	}
 
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
-- 
2.17.0
