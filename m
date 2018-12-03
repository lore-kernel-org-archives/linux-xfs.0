Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60959
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbeLCIeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:24 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/11] vfs: copy_file_range source range over EOF should fail
Date: Mon,  3 Dec 2018 19:34:06 +1100
Message-Id: <20181203083416.28978-2-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-1-david@fromorbit.com>
References: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The man page says:

EINVAL Requested range extends beyond the end of the source file

But the current behaviour is that copy_file_range does a short
copy up to the source file EOF. Fix the kernel behaviour to match
the behaviour described in the man page.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4dae0399c75a..09d1816cf3cf 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1581,6 +1581,10 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (len == 0)
 		return 0;
 
+	/* If the source range crosses EOF, fail the copy */
+	if (pos_in >= i_size(inode_in) || pos_in + len > i_size(inode_in))
+		return -EINVAL;
+
 	file_start_write(file_out);
 
 	/*
-- 
2.19.1
