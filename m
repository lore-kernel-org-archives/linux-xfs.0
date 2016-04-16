Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BF8F7CA0
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2016 15:31:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9375DAC001
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2016 13:31:31 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13]) by
	cuda.sgi.com with ESMTP id L3TXIeAKcjaKYRdV (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Apr 2016 13:31:27 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: hide unused variable
Date: Sat, 16 Apr 2016 22:30:36 +0200
Message-Id: <1460838665-1249242-1-git-send-email-arnd@arndb.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, xfs@oss.sgi.com

The newly added xfs_finish_page_writeback() function causes
a harmless gcc warning when debugging is disabled:

fs/xfs/xfs_aops.c: In function 'xfs_finish_page_writeback':
fs/xfs/xfs_aops.c:97:16: error: unused variable 'blockmask' [-Werror=unused-variable]
  unsigned int  blockmask = (1 << inode->i_blkbits) - 1;
                ^~~~~~~~~

This adds an #ifdef around the variable declaration to hide
it whenever the ASSERT macro is defined as a stub, following
the same style as used elsewhere in xfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 37992c18bba3 ("xfs: don't release bios on completion immediately")
---
 fs/xfs/xfs_aops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e5c3a457c191..737d028914a2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -94,7 +94,9 @@ xfs_finish_page_writeback(
 	struct bio_vec		*bvec,
 	int			error)
 {
+#if defined(DEBUG) || defined(XFS_WARN)
 	unsigned int		blockmask = (1 << inode->i_blkbits) - 1;
+#endif
 	unsigned int		end = bvec->bv_offset + bvec->bv_len - 1;
 	struct buffer_head	*head, *bh;
 	unsigned int		off = 0;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
