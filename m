Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6B697F4E
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 02:09:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7088DAC019
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 00:09:03 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kng4MUqZHP2bl2pw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 00:08:59 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAK88v6C000911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 08:08:58 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAK88v9p000981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 08:08:57 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAK88u1O026434 for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 08:08:56 GMT
Message-ID: <528C6E15.3030801@oracle.com>
Date: Wed, 20 Nov 2013 16:08:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't  perform discard if the given range length is
	less than block size
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

For discard operation, we should return EINVAL if the given range length
is less than a block size, otherwise it will go through the file system
to discard data blocks as the end range might be evaluated to -1, e.g,
# fstrim -v -o 0 -l 100 /xfs7
/xfs7: 9811378176 bytes were trimmed

This issue can be triggered via xfstests/generic/288.

Also, it seems to get the request queue pointer via bdev_get_queue()
instead of the hard code pointer dereference is not a bad thing.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_discard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8367d6d..4f11ef0 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -157,7 +157,7 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
+	struct request_queue	*q = bdev_get_queue(mp->m_ddev_targp->bt_bdev);
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
@@ -180,7 +180,8 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
-	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
+	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
+	    range.len < mp->m_sb.sb_blocksize)
 		return -XFS_ERROR(EINVAL);
 
 	start = BTOBB(range.start);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
