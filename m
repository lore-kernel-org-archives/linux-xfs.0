Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F00507CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 07:55:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B13168F8035
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 05:55:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BlXzzlKpPlml4xJb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 05:55:31 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B194F81255
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 12:55:30 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-33.bos.redhat.com [10.18.41.33])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7OCtUUr011897
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 08:55:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: prevent dropping ioend completions during buftarg wait
Date: Wed, 24 Aug 2016 08:55:29 -0400
Message-Id: <1472043329-30700-1-git-send-email-bfoster@redhat.com>
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

xfs_wait_buftarg() waits for all pending I/O, drains the ioend
completion workqueue and walks the LRU until all buffers in the cache
have been released. This is traditionally an unmount operation` but the
mechanism is also reused during filesystem freeze.

xfs_wait_buftarg() invokes drain_workqueue() as part of the quiesce,
which is intended more for a shutdown sequence in that it indicates to
the queue that new operations are not expected once the drain has begun.
New work jobs after this point result in a WARN_ON_ONCE() and are
otherwise dropped.

With filesystem freeze, however, read operations are allowed and can
proceed during or after the workqueue drain. If such a read occurs
during the drain sequence, the workqueue infrastructure complains about
the queued ioend completion work item and drops it on the floor. As a
result, the buffer remains on the LRU and the freeze never completes.

Despite the fact that the overall buffer cache cleanup is not necessary
during freeze, fix up this operation such that it is safe to invoke
during non-unmount quiesce operations. Replace the drain_workqueue()
call with flush_workqueue(), which runs a similar serialization on
pending workqueue jobs without causing new jobs to be dropped. This is
safe for unmount as unmount independently locks out new operations by
the time xfs_wait_buftarg() is invoked.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 607cc29..b5b9bff 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1611,7 +1611,7 @@ xfs_wait_buftarg(
 	 */
 	while (percpu_counter_sum(&btp->bt_io_count))
 		delay(100);
-	drain_workqueue(btp->bt_mount->m_buf_workqueue);
+	flush_workqueue(btp->bt_mount->m_buf_workqueue);
 
 	/* loop until there is nothing left on the lru list. */
 	while (list_lru_count(&btp->bt_lru)) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
