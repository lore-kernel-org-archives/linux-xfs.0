Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 138097F3F
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 08:48:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F38738F8050
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 06:48:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dfMf7MlD5GFFmBFd for
	<xfs@oss.sgi.com>; Fri, 08 Feb 2013 06:48:15 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r18EmEQ5018818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r18EmEeR012652
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/2] xfs: recheck buffer pinned status after push trylock
	failure
Date: Fri,  8 Feb 2013 09:51:06 -0500
Message-Id: <1360335067-59999-2-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_buf_item.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9c4c050..4e3a059 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -469,8 +469,15 @@ xfs_buf_item_push(
 
 	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
-	if (!xfs_buf_trylock(bp))
+	if (!xfs_buf_trylock(bp)) {
+		/*
+		 * Check whether we've raced with the buffer being pinned so
+		 * xfsaild will pend up a log force.
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
