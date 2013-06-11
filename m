Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E858929DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5796304053
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:50:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HINugJuNKarXKOc5 for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 14:50:54 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't shutdown log recovery on validation errors
Date: Wed, 12 Jun 2013 07:50:42 +1000
Message-Id: <1370987442-30601-1-git-send-email-david@fromorbit.com>
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
Cc: davej@redhat.com, bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

Unfortunately, we cannot guarantee that items logged multiple times
and replayed by log recovery do not take objects back in time. When
theya re taken back in time, the go into an intermediate state which
is corrupt, and hence verification that occurs on this intermediate
state causes log recovery to abort with a corruption shutdown.

Instead of causing a shutdown and unmountable filesystem, don't
verify post-recovery items before they are written to disk. This is
less than optimal, but there is no way to detect this issue for
non-CRC filesystems If log recovery successfully completes, this
will be undone and the object will be consistent by subsequent
transactions that are replayed, so in most cases we don't need to
take drastic action.

For CRC enabled filesystems, leave the verifiers in place - we need
to call them to recalculate the CRCs on the objects anyway. This
recovery problem canbe solved for such filesystems - we have a LSN
stamped in all metadata at writeback time that we can to determine
whether the item should be replayed or not. This is a separate piece
of work, so is not addressed by this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 45a85ff..7cf5e4e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1845,7 +1845,13 @@ xlog_recover_do_inode_buffer(
 	xfs_agino_t		*buffer_nextp;
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
-	bp->b_ops = &xfs_inode_buf_ops;
+
+	/*
+	 * Post recovery validation only works properly on CRC enabled
+	 * filesystems.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		bp->b_ops = &xfs_inode_buf_ops;
 
 	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
@@ -2205,7 +2211,16 @@ xlog_recover_do_reg_buffer(
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
 
-	xlog_recovery_validate_buf_type(mp, bp, buf_f);
+	/*
+	 * We can only do post recovery validation on items on CRC enabled
+	 * fielsystems as we need to know when the buffer was written to be able
+	 * to determine if we should have replayed the item. If we replay old
+	 * metadata over a newer buffer, then it will enter a temporarily
+	 * inconsistent state resulting in verification failures. Hence for now
+	 * just avoid the verification stage for non-crc filesystems
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xlog_recovery_validate_buf_type(mp, bp, buf_f);
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
