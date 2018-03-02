Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:9457 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164734AbeCBEDG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 23:03:06 -0500
Subject: [PATCH v5 05/12] ext4,
 dax: define ext4_dax_*() infrastructure in all cases
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Mar 2018 19:54:00 -0800
Message-ID: <151996284080.28483.11296105582801541424.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

In preparation for fixing S_DAX to be defined in the CONFIG_FS_DAX=n +
CONFIG_DEV_DAX=y case, move the definition of these routines outside of
the "#ifdef CONFIG_FS_DAX" guard. This is also a coding-style fix to
move all ifdef handling to header files rather than in the source. The
compiler will still be able to determine that all the related code can
be discarded in the CONFIG_FS_DAX=n case.

Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/file.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fb6f023622fe..51854e7608f0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -34,7 +34,6 @@
 #include "xattr.h"
 #include "acl.h"
 
-#ifdef CONFIG_FS_DAX
 static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -60,7 +59,6 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	file_accessed(iocb->ki_filp);
 	return ret;
 }
-#endif
 
 static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
@@ -70,10 +68,8 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
-#ifdef CONFIG_FS_DAX
 	if (IS_DAX(file_inode(iocb->ki_filp)))
 		return ext4_dax_read_iter(iocb, to);
-#endif
 	return generic_file_read_iter(iocb, to);
 }
 
@@ -179,7 +175,6 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	return iov_iter_count(from);
 }
 
-#ifdef CONFIG_FS_DAX
 static ssize_t
 ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
@@ -208,7 +203,6 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ret = generic_write_sync(iocb, ret);
 	return ret;
 }
-#endif
 
 static ssize_t
 ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)

