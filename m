Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BBD87CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 07:53:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3DBE304039
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 05:53:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J5qwsiDSIHsfimk1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2016 05:53:51 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9BDE563171
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:53:50 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-180.bos.redhat.com [10.18.41.180])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5UCroSu017061
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 08:53:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: add readahead bufs to lru early to prevent post-unmount
	panic
Date: Thu, 30 Jun 2016 08:53:49 -0400
Message-Id: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
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

Newly allocated XFS metadata buffers are added to the LRU once the hold
count is released, which typically occurs after I/O completion. There is
no other mechanism at current that tracks the existence or I/O state of
a new buffer. Further, readahead I/O tends to be submitted
asynchronously by nature, which means the I/O can remain in flight and
actually complete long after the calling context is gone. This means
that file descriptors or any other holds on the filesystem can be
released, allowing the filesystem to be unmounted while I/O is still in
flight. When I/O completion occurs, core data structures may have been
freed, causing completion to run into invalid memory accesses and likely
to panic.

This problem is reproduced on XFS via directory readahead. A filesystem
is mounted, a directory is opened/closed and the filesystem immediately
unmounted. The open/close cycle triggers a directory readahead that if
delayed long enough, runs buffer I/O completion after the unmount has
completed.

To work around this problem, add readahead buffers to the LRU earlier
than other buffers (when the buffer is allocated, specifically). The
buffer hold count will ultimately remain until I/O completion, which
means any shrinker activity will skip the buffer until then. This makes
the buffer visible to xfs_wait_buftarg(), however, which ensures that an
unmount or quiesce waits for I/O completion appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This addresses the problem reproduced by the recently posted xfstests
test:

  http://thread.gmane.org/gmane.comp.file-systems.fstests/2740

This could probably be made more involved, i.e., to create another list
of buffers in flight or some such. This seems more simple/sane to me,
however, and survives my testing so far...

Brian

 fs/xfs/xfs_buf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4665ff6..3f03df9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -590,8 +590,20 @@ xfs_buf_get_map(
 		return NULL;
 	}
 
+	/*
+	 * If the buffer found doesn't match the one allocated above, somebody
+	 * else beat us to insertion and we can toss the new one.
+	 *
+	 * If we did add the buffer and it happens to be readahead, add to the
+	 * LRU now rather than waiting until the hold is released. Otherwise,
+	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
+	 * nothing else prevents an unmount before I/O completion.
+	 */
 	if (bp != new_bp)
 		xfs_buf_free(new_bp);
+	else if (flags & XBF_READ_AHEAD &&
+		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
+		atomic_inc(&bp->b_hold);
 
 found:
 	if (!bp->b_addr) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
