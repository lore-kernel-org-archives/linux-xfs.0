Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60959
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbeLCIeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:31 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/11] vfs: copy_file_range needs to strip setuid bits
Date: Mon,  3 Dec 2018 19:34:11 +1100
Message-Id: <20181203083416.28978-7-david@fromorbit.com>
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

The file we are copying data into needs to have its setuid bit
stripped before we start the data copy so that unprivileged users
can't copy data into executables that are run with root privs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 69809345977e..3b101183ea19 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1574,6 +1574,16 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    size_t len, unsigned int flags)
 {
+	ssize_t ret;
+
+	/*
+	 * Clear the security bits if the process is not being run by root.
+	 * This keeps people from modifying setuid and setgid binaries.
+	 */
+	ret = file_remove_privs(file_out);
+	if (ret)
+		return ret;
+
 	if (file_out->f_op->copy_file_range)
 		return file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
-- 
2.19.1
