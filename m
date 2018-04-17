Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeDQFTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 01:19:22 -0400
Date: Mon, 16 Apr 2018 22:19:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: cap the length of deduplication requests
Message-ID: <20180417051918.GD5203@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: fstests <fstests@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since deduplication potentially has to read in all the pages in both
files in order to compare the contents, cap the deduplication request
length at MAX_RW_COUNT (roughly 2GB) so that we have /some/ upper bound
on the request length and can't just lock up the kernel forever.  Found
by running generic/304 after commit 1ddae54555b62 ("common/rc: add
missing 'local' keywords").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 299aee4..9fd9dd7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -876,8 +876,17 @@ xfs_file_dedupe_range(
 	struct file	*dst_file,
 	u64		dst_loff)
 {
+	struct inode	*srci = file_inode(src_file);
+	u64		max_dedupe;
 	int		error;
 
+	/*
+	 * Since we have to read all these pages in to compare them, cut
+	 * it off at MAX_RW_COUNT rounded down to the nearest block.
+	 */
+	max_dedupe = MAX_RW_COUNT & ~(i_blocksize(srci) - 1);
+	if (len > max_dedupe)
+		len = max_dedupe;
 	error = xfs_reflink_remap_range(src_file, loff, dst_file, dst_loff,
 				     len, true);
 	if (error)
