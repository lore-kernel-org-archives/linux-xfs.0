Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52ddt134582 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:40 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Uq0BsgrM4P6y9c6m for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZa-0003ED-LY
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bS-J8
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 004/102] xfs: reduce ioend latency
Date: Thu, 23 Aug 2012 15:01:22 +1000
Message-Id: <1345698180-13612-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: fc0063c4474599b7a066ba76b90902abe21bc675

There is no reason to queue up ioends for processing in user context
unless we actually need it.  Just complete ioends that do not convert
unwritten extents or need a size update from the end_io context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 68ac1ce..20f356d 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -149,6 +149,15 @@ xfs_ioend_new_eof(
 }
 
 /*
+ * Fast and loose check if this write could update the on-disk inode size.
+ */
+static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
+{
+	return ioend->io_offset + ioend->io_size >
+		XFS_I(ioend->io_inode)->i_d.di_size;
+}
+
+/*
  * Update on-disk file size now that data has been written to disk.  The
  * current in-memory file size is i_size.  If a write is beyond eof i_new_size
  * will be the intended file size until i_size is updated.  If this write does
@@ -184,6 +193,9 @@ xfs_setfilesize(
 
 /*
  * Schedule IO completion handling on the final put of an ioend.
+ *
+ * If there is no work to do we might as well call it a day and free the
+ * ioend right now.
  */
 STATIC void
 xfs_finish_ioend(
@@ -192,8 +204,10 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		if (ioend->io_type == IO_UNWRITTEN)
 			queue_work(xfsconvertd_workqueue, &ioend->io_work);
-		else
+		else if (xfs_ioend_is_append(ioend))
 			queue_work(xfsdatad_workqueue, &ioend->io_work);
+		else
+			xfs_destroy_ioend(ioend);
 	}
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
