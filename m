Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4A0E7F3F
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 08:48:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74B30AC004
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 06:48:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lufzACCgcDcSz8qc for
	<xfs@oss.sgi.com>; Fri, 08 Feb 2013 06:48:14 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r18EmEBC021091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r18EmE38012654
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 2/2] xfs: remove log force from xfs_buf_trylock()
Date: Fri,  8 Feb 2013 09:51:07 -0500
Message-Id: <1360335067-59999-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1360335067-59999-1-git-send-email-bfoster@redhat.com>
References: <1360335067-59999-1-git-send-email-bfoster@redhat.com>
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

The trylock log force invoked via xfs_buf_item_push() can attempt
to acquire xa_lock, thus leading to a recursion bug when called
with xa_lock held.

This log force was originally added to xfs_buf_trylock() to address
xfsaild stalls due to pinned and stale buffers. Since the addition
of this behavior, the log item pushing code had been reworked to
detect and track pinned items to inform xfsaild to issue a log
force itself when necessary. As such, the log force on trylock
failure is redundant and safe to remove.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fbbb9eb..4e8f0df 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -951,8 +951,6 @@ xfs_buf_trylock(
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked)
 		XB_SET_OWNER(bp);
-	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
-		xfs_log_force(bp->b_target->bt_mount, 0);
 
 	trace_xfs_buf_trylock(bp, _RET_IP_);
 	return locked;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
