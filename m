Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73C867F54
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 14:42:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5347E304032
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:41:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cHCj4PnUxMJFNK6c for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:41:58 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0TKfucx001781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:41:58 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r0TKftSM012946
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:41:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 2/2] xfs: drop xa_lock around log force in xfs_buf_item
	push
Date: Tue, 29 Jan 2013 15:42:37 -0500
Message-Id: <1359492157-30521-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
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

If the trylock fails and the buffer is pinned and stale, the
resulting xfs_log_force() can lead to lock recursion on the ailp
xa_lock. Call __xfs_buf_trylock() to attempt the buf lock with
xa_lock held, but to avoid the log force. We subsequently pull the
check and log force up into xfs_buf_item_push() where we can drop
and reacquire xa_lock appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9c4c050..7b6e98a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -469,8 +469,16 @@ xfs_buf_item_push(
 
 	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
-	if (!xfs_buf_trylock(bp))
+
+	if (!__xfs_buf_trylock(bp, false)) {
+		if (atomic_read(&bp->b_pin_count) &&
+		    (bp->b_flags & XBF_STALE)) {
+			spin_unlock(&lip->li_ailp->xa_lock);
+			xfs_log_force(bp->b_target->bt_mount, 0);
+			spin_lock(&lip->li_ailp->xa_lock);
+		}
 		return XFS_ITEM_LOCKED;
+	}
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
