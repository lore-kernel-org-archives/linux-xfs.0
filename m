Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:31:06 -0400
Subject: [PATCH 07/25] vfs: skip zero-length dedupe requests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Oct 2018 17:11:27 -0700
Message-ID: <153913028716.32295.15849395030883190383.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother calling the filesystem for a zero-length dedupe request;
we can return zero and exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index f7b728d4972f..3ff90b3315fb 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1975,6 +1975,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (!dst_file->f_op->dedupe_file_range)
 		goto out_drop_write;
 
+	if (len == 0) {
+		ret = 0;
+		goto out_drop_write;
+	}
+
 	ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
 						dst_file, dst_pos, len);
 out_drop_write:
