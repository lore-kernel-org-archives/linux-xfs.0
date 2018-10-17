Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbeJRGmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 02:42:36 -0400
Subject: [PATCH 03/29] vfs: exit early from zero length remap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Oct 2018 15:44:36 -0700
Message-ID: <153981627600.5568.16857314567554014035.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If a remap caller asks us to remap to the source file's EOF and the
source file length leaves us with a zero byte request, exit early.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index d6e8e242a15f..2456da3f8a41 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1748,6 +1748,8 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 		if (pos_in > isize)
 			return -EINVAL;
 		*len = isize - pos_in;
+		if (*len == 0)
+			return 0;
 	}
 
 	/* Check that we don't violate system file offset limits. */
