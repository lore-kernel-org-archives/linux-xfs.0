Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbeJPK6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 06:58:40 -0400
Subject: [PATCH 04/26] vfs: exit early from zero length remap operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Oct 2018 20:10:23 -0700
Message-ID: <153965942391.1256.1491987046439132016.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If a remap caller asks us to remap to the source file's EOF and the
source file has zero bytes, exit early.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
