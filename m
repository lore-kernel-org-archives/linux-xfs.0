Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00BA87F73
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 09:05:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4FA8304043
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L0NuTI4Ssg6rGKG5 for
	<xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1BF5XSL016584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r1BF5XW9005710
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 2/2] xfs: remove log force from xfs_buf_trylock()
Date: Mon, 11 Feb 2013 10:08:22 -0500
Message-Id: <1360595302-15865-3-git-send-email-bfoster@redhat.com>
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
