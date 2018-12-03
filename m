Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60959
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbeLCIeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:36 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Date: Mon,  3 Dec 2018 19:34:10 +1100
Message-Id: <20181203083416.28978-6-david@fromorbit.com>
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

Similar to FI_DEDUPERANGE, make copy_file_range() check that we have
write permissions to the destination inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/filemap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0a170425935b..876df5275514 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3013,6 +3013,11 @@ int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	    (file_out->f_flags & O_APPEND))
 		return -EBADF;
 
+	/* may sure we really are allowed to write to the destination inode */
+	ret = inode_permission(inode_out, MAY_WRITE);
+	if (ret < 0)
+		return ret;
+
 	/* Ensure offsets don't wrap. */
 	if (pos_in + count < pos_in || pos_out + count < pos_out)
 		return -EOVERFLOW;
-- 
2.19.1
