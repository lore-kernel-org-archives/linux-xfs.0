Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD3FA7F7C
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 02:41:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9B428F811E
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 00:41:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nHDBw6yIXrYBi9of for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 00:41:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMAMH-0000AU-MH
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMAMH-0008Cm-LM
	for xfs@oss.sgi.com; Mon, 03 Aug 2015 17:40:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: dquots should be stamped with sb_meta_uuid
Date: Mon,  3 Aug 2015 17:40:25 +1000
Message-Id: <1438587625-31437-5-git-send-email-david@fromorbit.com>
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

Once the sb_uuid is changed, the wrong uuid is stamped into new
dquots on disk. Found by inspection, verified by generic/219.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4143dc7..b1b26b6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -251,7 +251,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_flags = type;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
 					 XFS_DQUOT_CRC_OFF);
 		}
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
