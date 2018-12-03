Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:36689
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbeLCIeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:31 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/11] vfs: copy_file_range should update file timestamps
Date: Mon,  3 Dec 2018 19:34:12 +1100
Message-Id: <20181203083416.28978-8-david@fromorbit.com>
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

Timestamps are not updated right now, so programs looking for
timestamp updates for file modifications (like rsync) will not
detect that files have changed. We are also accessing the source
data when doing a copy (but not when cloning) so we need to update
atime on the source file as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3b101183ea19..3288db1d5f21 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1576,6 +1576,16 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	ssize_t ret;
 
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
2.19.1
