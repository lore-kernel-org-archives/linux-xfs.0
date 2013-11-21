Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C26C7F51
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 22:41:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C8C3304053
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 20:41:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zffdhWVXe4YsYFtC for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 20:41:34 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VjM4h-0001CS-0D
	for xfs@oss.sgi.com; Thu, 21 Nov 2013 15:41:07 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VjM4g-0005nZ-Vl
	for xfs@oss.sgi.com; Thu, 21 Nov 2013 15:41:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: growfs overruns AGFL buffer on V4 filesystems
Date: Thu, 21 Nov 2013 15:41:06 +1100
Message-Id: <1385008866-22256-1-git-send-email-david@fromorbit.com>
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

This loop in xfs_growfs_data_private() is incorrect for V4
superblocks filesystems:

		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);

For V4 filesystems, we don't have a agfl header structure, and so
XFS_AGFL_SIZE() returns an entire sector's worth of entries, which
we then index from an offset into the sector. Hence: buffer overrun.

This problem was introduced in 3.10 by commit 77c95bba ("xfs: add
CRC checks to the AGFL") which changed the AGFL structure but failed
to update the growfs code to handle the different structures.

Fix it by using the correct offset into the buffer for both V4 and
V5 filesystems.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a6e54b3..02fb943 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -220,6 +220,8 @@ xfs_growfs_data_private(
 	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
+		__be32	*agfl_bno;
+
 		/*
 		 * AG freespace header block
 		 */
@@ -279,8 +281,10 @@ xfs_growfs_data_private(
 			agfl->agfl_seqno = cpu_to_be32(agno);
 			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
 		}
+
+		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
 		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
-			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
+			agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
