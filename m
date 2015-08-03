Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9EA57F7C
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36F99AC045
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:41:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XRUcMF4z58pWImYP for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:41:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAMH-0000AT-Li
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAMH-0008Ch-L4
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: log recovery needs to validate against sb_meta_uuid
Date: Mon,  3 Aug 2015 17:40:24 +1000
Message-Id: <1438587625-31437-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-1-git-send-email-david@fromorbit.com>
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that sb_uuid can be changed by the user, we cannot use this to
validate the metadata blocks being recovered belong to this
filesystem. We must check against the sb_meta_uuid as that will
remain unchanged.

There is a complication in this code - the superblock itself. We can
not check the sb_meta_uuid unconditionally, as that may not be set
on disk. Hence we must verify the superblock sb_uuid matches between
the log record and the in-core superblock.

Found by inspection after the previous two problems were found.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c674b40..6f83d12 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1895,15 +1895,25 @@ xlog_recover_get_buf_lsn(
 		 */
 		goto recover_immediately;
 	case XFS_SB_MAGIC:
+		/*
+		 * superblock uuids are magic. We may or may not have a
+		 * sb_meta_uuid on disk, but it will be set in the in-core
+		 * superblock. We set the uuid pointer for verification
+		 * according to the superblock feature mask to ensure we check
+		 * the relevant UUID in the superblock.
+		 */
 		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
-		uuid = &((struct xfs_dsb *)blk)->sb_uuid;
+		if (xfs_sb_version_hasmetauuid(&mp->m_sb))
+			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
+		else
+			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
 		break;
 	default:
 		break;
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
