Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 251897F53
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 14:42:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12068304032
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:42:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vFdBVXs9gkdlyoGB for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:42:01 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0TKfwDK015470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:42:01 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r0TKft6Q021052
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:41:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/2] xfs: conditionally force log on trylock failure of
	pinned/stale buf
Date: Tue, 29 Jan 2013 15:42:36 -0500
Message-Id: <1359492157-30521-2-git-send-email-bfoster@redhat.com>
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

xfs_force_log() is not safe from all contexts. Add a flag parameter
to xfs_buf_trylock() to specify when the force is appropriate and
create a macro to preserve current behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c |    8 +++++---
 fs/xfs/xfs_buf.h |    3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fbbb9eb..2e04a44 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -943,15 +943,17 @@ xfs_buf_rele(
  *	to push on stale inode buffers.
  */
 int
-xfs_buf_trylock(
-	struct xfs_buf		*bp)
+__xfs_buf_trylock(
+	struct xfs_buf		*bp,
+	bool			force_log)
 {
 	int			locked;
 
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked)
 		XB_SET_OWNER(bp);
-	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+	else if (force_log &&
+		 atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 
 	trace_xfs_buf_trylock(bp, _RET_IP_);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 433a12e..667b723 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -258,7 +258,8 @@ extern void xfs_buf_free(xfs_buf_t *);
 extern void xfs_buf_rele(xfs_buf_t *);
 
 /* Locking and Unlocking Buffers */
-extern int xfs_buf_trylock(xfs_buf_t *);
+#define xfs_buf_trylock(bp) __xfs_buf_trylock(bp, true)
+extern int __xfs_buf_trylock(xfs_buf_t *, bool);
 extern void xfs_buf_lock(xfs_buf_t *);
 extern void xfs_buf_unlock(xfs_buf_t *);
 #define xfs_buf_islocked(bp) \
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
