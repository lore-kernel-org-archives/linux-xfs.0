Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2915E7F52
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 06:41:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1B3C8F8049
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 04:41:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P4TcO7SZ7oftWq7G for
	<xfs@oss.sgi.com>; Wed, 06 Feb 2013 04:41:46 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r16Cfj1o017685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2013 07:41:45 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r16CfjdW024564
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2013 07:41:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/2] xfs: disable log force in xfs_buf_item_push() to avoid
	xa_lock recursion
Date: Wed,  6 Feb 2013 07:44:41 -0500
Message-Id: <1360154681-28246-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
References: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
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
xa_lock held, but to avoid the log force. If the trylock had raced
with the buffer being pinned, return XFS_ITEM_PINNED such that
xfsaild will pend up a log force on the next scan.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9c4c050..23a328e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -469,8 +469,20 @@ xfs_buf_item_push(
 
 	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
-	if (!xfs_buf_trylock(bp))
+
+	if (!__xfs_buf_trylock(bp, false)) {
+		/*
+		 * We disable the log force via trylock because the buffer can
+		 * become pinned and stale after the trylock fails and the log
+		 * force is unsafe with xa_lock held.
+		 *
+		 * Check the buffer state once more and return pinned such that
+		 * xfsaild pends up the log force when it drops xa_lock.
+		 */
+		if (xfs_buf_ispinned(bp))
+			return XFS_ITEM_PINNED;
 		return XFS_ITEM_LOCKED;
+	}
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
