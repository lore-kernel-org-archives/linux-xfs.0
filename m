Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA41B7CA0
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 03:25:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A8F9AC002
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 01:25:44 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id 34IK3vZYp95IZLzv (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 May 2016 01:25:41 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] xfs: hide unused variable
Date: Thu, 19 May 2016 10:25:15 +0200
Message-Id: <1463646331-933024-1-git-send-email-arnd@arndb.de>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

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
I originally sent this on April 16 when the warning first showed up
but got no reply. Sending it again now as the warning is still present
in linux-next.

 fs/xfs/xfs_aops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8a5244e4c2e9..62d938c46f31 100644
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
