Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40688 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfEaQrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 12:47:24 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 7/9] xfs: use file_modified() helper
Date: Fri, 31 May 2019 19:46:59 +0300
Message-Id: <20190531164701.15112-8-amir73il@gmail.com>
In-Reply-To: <20190531164701.15112-1-amir73il@gmail.com>
References: <20190531164701.15112-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

Note that by using the helper, the order of calling file_remove_privs()
after file_update_mtime() in xfs_file_aio_write_checks() has changed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 76748255f843..916a35cae5e9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -367,20 +367,7 @@ xfs_file_aio_write_checks(
 	 * lock above.  Eventually we should look into a way to avoid
 	 * the pointless lock roundtrip.
 	 */
-	if (likely(!(file->f_mode & FMODE_NOCMTIME))) {
-		error = file_update_time(file);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * If we're writing the file then make sure to clear the setuid and
-	 * setgid bits if the process is not being run by root.  This keeps
-	 * people from modifying setuid and setgid binaries.
-	 */
-	if (!IS_NOSEC(inode))
-		return file_remove_privs(file);
-	return 0;
+	return file_modified(file);
 }
 
 static int
-- 
2.17.1
