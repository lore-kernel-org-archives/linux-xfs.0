Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D94637F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 18:40:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA220304053
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:40:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SABmNukZNbOdllKz for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 16:39:59 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: inode unlink does not set AGI buffer type
Date: Wed, 21 Jan 2015 11:39:39 +1100
Message-Id: <1421800780-26008-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1421800780-26008-1-git-send-email-david@fromorbit.com>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

This leads to log recovery throwing errors like:

XFS (md0): Mounting V5 Filesystem
XFS (md0): Starting recovery (logdev: internal)
XFS (md0): Unknown buffer type 0!
XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1
ffff8800ffc53800: 58 41 47 49 .....

Which is the AGI buffer magic number.

Ensure that we set the type appropriately in both unlink list
addition and removal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 573b49c..f616c8f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2051,6 +2051,7 @@ xfs_iunlink(
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 	return 0;
@@ -2142,6 +2143,7 @@ xfs_iunlink_remove(
 		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
 		offset = offsetof(xfs_agi_t, agi_unlinked) +
 			(sizeof(xfs_agino_t) * bucket_index);
+		xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 		xfs_trans_log_buf(tp, agibp, offset,
 				  (offset + sizeof(xfs_agino_t) - 1));
 	} else {
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
