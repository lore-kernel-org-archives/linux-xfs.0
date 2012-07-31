Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V4tvTQ137146 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 23:55:57 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iCpESQuPWM2eM4wS for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 21:55:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Sw4Up-0004LV-Fj
	for xfs@oss.sgi.com; Tue, 31 Jul 2012 14:55:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Sw4Up-0006Vk-BO
	for xfs@oss.sgi.com; Tue, 31 Jul 2012 14:55:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix uninitialised variable in xfs_rtbuf_get()
Date: Tue, 31 Jul 2012 14:55:51 +1000
Message-Id: <1343710551-24998-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Results in this assert failure in generic/090:

XFS: Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4363
.....
Call Trace:
 [<ffffffff814680db>] xfs_bmapi_read+0x6b/0x370
 [<ffffffff814b64b2>] xfs_rtbuf_get+0x42/0x130
 [<ffffffff814b6f09>] xfs_rtget_summary+0x89/0x120
 [<ffffffff814b7bfe>] xfs_rtallocate_extent_size+0xce/0x340
 [<ffffffff814b89f0>] xfs_rtallocate_extent+0x240/0x290
 [<ffffffff81462c1a>] xfs_bmap_rtalloc+0x1ba/0x340
 [<ffffffff81463a65>] xfs_bmap_alloc+0x35/0x40
 [<ffffffff8146f111>] xfs_bmapi_allocate+0xf1/0x350
 [<ffffffff8146f9de>] xfs_bmapi_write+0x66e/0xa60
 [<ffffffff8144538a>] xfs_iomap_write_direct+0x22a/0x3f0
 [<ffffffff8143707b>] __xfs_get_blocks+0x38b/0x5d0
 [<ffffffff814372d4>] xfs_get_blocks_direct+0x14/0x20
 [<ffffffff811b0081>] do_blockdev_direct_IO+0xf71/0x1eb0
 [<ffffffff811b1015>] __blockdev_direct_IO+0x55/0x60
 [<ffffffff814355ca>] xfs_vm_direct_IO+0x11a/0x1e0
 [<ffffffff8112d617>] generic_file_direct_write+0xd7/0x1b0
 [<ffffffff8143e16c>] xfs_file_dio_aio_write+0x13c/0x320
 [<ffffffff8143e6f2>] xfs_file_aio_write+0x1c2/0x1d0
 [<ffffffff81174a07>] do_sync_write+0xa7/0xe0
 [<ffffffff81175288>] vfs_write+0xa8/0x160
 [<ffffffff81175702>] sys_pwrite64+0x92/0xb0
 [<ffffffff81b68f69>] system_call_fastpath+0x16/0x1b
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 92d4331..ca28a4b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -857,7 +857,7 @@ xfs_rtbuf_get(
 	xfs_buf_t	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
-	int		nmap;
+	int		nmap = 1;
 	int		error;		/* error value */
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
