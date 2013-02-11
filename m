Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B9567F6A
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 09:05:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2423304043
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yeaeJ4rD1E22TI2s for
	<xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1BF5XUG000704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1BF5XUO015817
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 1/2] xfs: recheck buffer pinned status after push trylock
	failure
Date: Mon, 11 Feb 2013 10:08:21 -0500
Message-Id: <1360595302-15865-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
References: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
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

The buffer pinned check and trylock sequence in xfs_buf_item_push()
can race with an active transaction on marking the buffer pinned.
This can result in the buffer becoming pinned and stale after the
initial check and the trylock failure, but before the check in
xfs_buf_trylock() that issues a log force. If the log force is
issued from this context, a spinlock recursion occurs on xa_lock.

Prepare xfs_buf_item_push() to handle the race by detecting a
pinned buffer after the trylock failure so xfsaild issues a log
force from a safe context. This, along with various previous fixes,
renders the log force in xfs_buf_trylock() redundant.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9c4c050..cf26347 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -469,8 +469,18 @@ xfs_buf_item_push(
 
 	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
-	if (!xfs_buf_trylock(bp))
+	if (!xfs_buf_trylock(bp)) {
+		/*
+		 * If we have just raced with a buffer being pinned and it has
+		 * been marked stale, we could end up stalling until someone else
+		 * issues a log force to unpin the stale buffer. Check for the
+		 * race condition here so xfsaild recognizes the buffer is pinned
+		 * and queues a log force to move it along.
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
