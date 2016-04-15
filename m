Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C0267CA1
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 13:43:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 671BAAC002
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:43:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s6tCUs72hjNpTKMR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:43:12 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 50026C062C94
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 18:43:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-148.bos.redhat.com [10.18.41.148])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3FIhBeO006868
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:43:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: buffer ->bi_end_io function requires irq-safe lock
Date: Fri, 15 Apr 2016 14:43:09 -0400
Message-Id: <1460745789-42073-1-git-send-email-bfoster@redhat.com>
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

Reports have surfaced of a lockdep splat complaining about an irq-safe
-> irq-unsafe locking order in the xfs_buf_bio_end_io() bio completion
handler. This only occurs when I/O errors are present because bp->b_lock
is only acquired in this context to protect setting an error on the
buffer. The problem is that this lock can be acquired with the
(request_queue) q->queue_lock held. See scsi_end_request() or
ata_qc_schedule_eh(), for example.

Replace the locked test/set of b_io_error with a cmpxchg() call. This
eliminates the need for the lock and thus the lock ordering problem goes
away.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Use cmpxchg() instead of lock. [hch]
v1: http://oss.sgi.com/pipermail/xfs/2016-April/048384.html

 fs/xfs/xfs_buf.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9a2191b..e71cfbd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1100,22 +1100,18 @@ xfs_bwrite(
 	return error;
 }
 
-STATIC void
+static void
 xfs_buf_bio_end_io(
 	struct bio		*bio)
 {
-	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
+	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
 
 	/*
 	 * don't overwrite existing errors - otherwise we can lose errors on
 	 * buffers that require multiple bios to complete.
 	 */
-	if (bio->bi_error) {
-		spin_lock(&bp->b_lock);
-		if (!bp->b_io_error)
-			bp->b_io_error = bio->bi_error;
-		spin_unlock(&bp->b_lock);
-	}
+	if (bio->bi_error)
+		cmpxchg(&bp->b_io_error, 0, bio->bi_error);
 
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
