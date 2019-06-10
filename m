Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46947 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfFJR0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:26:18 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] vfs: allow copy_file_range from a swapfile
Date: Mon, 10 Jun 2019 20:26:06 +0300
Message-Id: <20190610172606.4119-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

read(2) is allowed from a swapfile, so copy_file_range(2) should
be allowed as well.

Reported-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Darrick,

This fixes the generic/554 issue reported by Ted.

I intend to remove the test case of copy from swap file from
generic/554, so test is expected to pass with or without this fix.
But if you wait for next week's xfstests update before applying
this fix, then at lease maintainer that run current xfstests master
could use current copy-file-range-fixes branch to pass the tests.

Thanks,
Amir.

 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index aac71aef4c61..f74e5ce7ca50 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3081,7 +3081,7 @@ int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	if (IS_IMMUTABLE(inode_out))
 		return -EPERM;
 
-	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
+	if (IS_SWAPFILE(inode_out))
 		return -ETXTBSY;
 
 	/* Ensure offsets don't wrap. */
-- 
2.17.1
