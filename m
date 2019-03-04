Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:41843 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDThg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 14:37:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: mark xfs_dir2_sf_entry_t as __packed again
Date: Mon,  4 Mar 2019 20:36:47 +0100
Message-Id: <20190304193723.657089-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

For ARM OABI builds, we run into a compile time assertion:

inlined from 'init_xfs_fs' at /git/arm-soc/fs/xfs/xfs_super.c:1991:2:
fs/xfs/xfs_ondisk.h:119:208: error: call to '__compiletime_assert_119' declared with attribute error: XFS: sizeof(xfs_dir2_sf_entry_t) is wrong, expected 3

While ARM OABI is pretty much dead and fails to build for typical
configurations on modern architectures (ARMv6 or higher), and has
been declared deprecated in user space since gcc-4.6, the kernel
still allows it to used for building the kernel.

In commit 8353a649f577 ("xfs: kill xfs_dir2_sf_off_t"), Christoph
removed the old __arch_pack annotation that made it possible to
build xfs with oddball ABIs. However, OABI not only requrires
padding around short structure but still adds padding after this
change. There is no harm to unconditionally mark the structure as
__packed now, and that will do the right thing here.

As of commit aa2dd0ad4d6d ("xfs: remove __arch_pack"), we need to
use __packed here as well, instead of the old __arch_pack.

Fixes: 8353a649f577 ("xfs: kill xfs_dir2_sf_off_t")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/libxfs/xfs_da_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ae654e06b2fb..fa8f07451d39 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -230,7 +230,7 @@ typedef struct xfs_dir2_sf_entry {
 	 * A 64-bit or 32-bit inode number follows here, at a variable offset
 	 * after the name.
 	 */
-} xfs_dir2_sf_entry_t;
+} __packed xfs_dir2_sf_entry_t;
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
-- 
2.20.0
