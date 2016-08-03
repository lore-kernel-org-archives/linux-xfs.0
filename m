Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC83A7CA3
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 11:12:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE8778F8039
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 09:12:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gDj8hpQwOsWRScgI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 09:12:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F21228E251
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 16:12:54 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-64.bos.redhat.com [10.18.41.64])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u73GCsCS021812
	for <xfs@oss.sgi.com>; Wed, 3 Aug 2016 12:12:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: don't assert fail on non-async buffers on ioacct
	decrement
Date: Wed,  3 Aug 2016 12:12:53 -0400
Message-Id: <1470240773-12850-1-git-send-email-bfoster@redhat.com>
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

The buffer I/O accounting mechanism tracks async buffers under I/O.  As
an optimization, the buffer I/O count is incremented only once on the
first async I/O for a given hold cycle of a buffer and decremented once
the buffer is released to the LRU (or freed).

xfs_buf_ioacct_dec() has an ASSERT() check for an XBF_ASYNC buffer, but
we have one or two corner cases where a buffer can be submitted for I/O
multiple times via different methods in a single hold cycle. If an async
I/O occurs first, the I/O count is incremented. If a sync I/O occurs
before the hold count drops, XBF_ASYNC is cleared by the time the I/O
count is decremented.

Remove the async assert check from xfs_buf_ioacct_dec() as this is a
perfectly valid scenario. For the purposes of I/O accounting, we really
only care about the buffer async state at I/O submission time.

Discovered-and-analyzed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 32fc540..b13ff61 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -115,7 +115,6 @@ xfs_buf_ioacct_dec(
 	if (!(bp->b_flags & _XBF_IN_FLIGHT))
 		return;
 
-	ASSERT(bp->b_flags & XBF_ASYNC);
 	bp->b_flags &= ~_XBF_IN_FLIGHT;
 	percpu_counter_dec(&bp->b_target->bt_io_count);
 }
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
