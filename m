Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42156 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2Rnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 13:43:52 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 12/13] nfs: copy_file_range needs to strip setuid bits and update timestamps
Date: Wed, 29 May 2019 20:43:16 +0300
Message-Id: <20190529174318.22424-13-amir73il@gmail.com>
In-Reply-To: <20190529174318.22424-1-amir73il@gmail.com>
References: <20190529174318.22424-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

Like ->write_iter(), we update mtime and strip setuid of dst file before
copy and like ->read_iter(), we update atime of src file after copy.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/nfs/nfs42proc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 5196bfa7894d..c37a8e5116c6 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -345,10 +345,13 @@ ssize_t nfs42_proc_copy(struct file *src, loff_t pos_src,
 
 	do {
 		inode_lock(file_inode(dst));
-		err = _nfs42_proc_copy(src, src_lock,
-				dst, dst_lock,
-				&args, &res);
+		err = file_modified(dst);
+		if (!err)
+			err = _nfs42_proc_copy(src, src_lock,
+					       dst, dst_lock,
+					       &args, &res);
 		inode_unlock(file_inode(dst));
+		file_accessed(src);
 
 		if (err >= 0)
 			break;
-- 
2.17.1
