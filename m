Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752800AbeDRC6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:58:12 -0400
Date: Tue, 17 Apr 2018 19:57:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: cap the length of deduplication requests
Message-ID: <20180418025755.GN24738@magnolia>
References: <20180417051918.GD5203@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417051918.GD5203@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since deduplication potentially has to read in all the pages in both
files in order to compare the contents, cap the deduplication request
length at MAX_RW_COUNT/2 (roughly 1GB) so that we have /some/ upper bound
on the request length and can't just lock up the kernel forever.  Found
by running generic/304 after commit 1ddae54555b62a ("common/rc: add
missing 'local' keywords").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: halve the amount so that we do MAX_RW_COUNT IO max
---
 fs/xfs/xfs_file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 299aee4..9cafad4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -876,8 +876,18 @@ xfs_file_dedupe_range(
 	struct file	*dst_file,
 	u64		dst_loff)
 {
+	struct inode	*srci = file_inode(src_file);
+	u64		max_dedupe;
 	int		error;
 
+	/*
+	 * Since we have to read all these pages in to compare them, cut
+	 * it off at MAX_RW_COUNT/2 rounded down to the nearest block.
+	 * That means we won't do more than MAX_RW_COUNT IO per request.
+	 */
+	max_dedupe = (MAX_RW_COUNT >> 1) & ~(i_blocksize(srci) - 1);
+	if (len > max_dedupe)
+		len = max_dedupe;
 	error = xfs_reflink_remap_range(src_file, loff, dst_file, dst_loff,
 				     len, true);
 	if (error)
