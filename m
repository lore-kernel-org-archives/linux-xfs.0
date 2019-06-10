Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37653 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfFJRhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:37:07 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] cifs: copy_file_range needs to strip setuid bits and update timestamps
Date: Mon, 10 Jun 2019 20:36:57 +0300
Message-Id: <20190610173657.4655-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steve French <smfrench@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org

cifs has both source and destination inodes locked throughout the copy.
Like ->write_iter(), we update mtime and strip setuid bits of destination
file before copy and like ->read_iter(), we update atime of source file
after copy.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Steve,

Please apply this patch to you cifs branch after merging Darrick's
copy-file-range-fixes branch from:
        git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

Thanks,
Amir.

 fs/cifs/cifsfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f11eea6125c1..83956452c108 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1096,6 +1096,10 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 		goto out;
 	}
 
+	rc = -EOPNOTSUPP;
+	if (!target_tcon->ses->server->ops->copychunk_range)
+		goto out;
+
 	/*
 	 * Note: cifs case is easier than btrfs since server responsible for
 	 * checks for proper open modes and file type and if it wants
@@ -1107,11 +1111,12 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	/* should we flush first and last page first */
 	truncate_inode_pages(&target_inode->i_data, 0);
 
-	if (target_tcon->ses->server->ops->copychunk_range)
+	rc = file_modified(dst_file);
+	if (!rc)
 		rc = target_tcon->ses->server->ops->copychunk_range(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-	else
-		rc = -EOPNOTSUPP;
+
+	file_accessed(src_file);
 
 	/* force revalidate of size and timestamps of target file now
 	 * that target is updated on the server
-- 
2.17.1
