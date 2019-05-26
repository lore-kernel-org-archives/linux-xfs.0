Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39959 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfEZGLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 02:11:25 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 6/8] vfs: copy_file_range should update file timestamps
Date: Sun, 26 May 2019 09:10:57 +0300
Message-Id: <20190526061100.21761-7-amir73il@gmail.com>
In-Reply-To: <20190526061100.21761-1-amir73il@gmail.com>
References: <20190526061100.21761-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Timestamps are not updated right now, so programs looking for
timestamp updates for file modifications (like rsync) will not
detect that files have changed. We are also accessing the source
data when doing a copy (but not when cloning) so we need to update
atime on the source file as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index e16bcafc0da2..4b23a86aacd9 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1576,6 +1576,16 @@ int generic_copy_file_range_prep(struct file *file_in, struct file *file_out)
 
 	WARN_ON_ONCE(!inode_is_locked(file_inode(file_out)));
 
+	/* Update source timestamps, because we are accessing file data */
+	file_accessed(file_in);
+
+	/* Update destination timestamps, since we can alter file contents. */
+	if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+		ret = file_update_time(file_out);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Clear the security bits if the process is not being run by root.
 	 * This keeps people from modifying setuid and setgid binaries.
-- 
2.17.1
