Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N1ZOIF141050 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 20:35:25 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75190274F5
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:35:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TRgW972CZJqR3l4F for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 18:35:22 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QZYpD-0003zX-1m
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:19 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QZYoy-0005xq-LV
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: reset inode per-lifetime state when recycling it
Date: Thu, 23 Jun 2011 11:34:59 +1000
Message-Id: <1308792901-22880-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1308792901-22880-1-git-send-email-david@fromorbit.com>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS inodes has several per-lifetime state fields that determine the
behaviour of the inode. These state fields are not all reset when an
inode is reused from the reclaimable state.

This can lead to unexpected behaviour of the new inode such as
speculative preallocation not being truncated away in the expected
manner for local files until the inode is subsequently truncated,
freed or cycles out of the cache. It can also lead to an inode being
considered to be a filestream inode or having been truncated when
that is not the case.

Rework the reinitialisation of the inode when it is recycled to
ensure that it is pristine before it is reused. While there, also
fix the resetting of state flags in the recycling error paths so the
inode does not become unreclaimable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c  |   13 +++++++++----
 fs/xfs/xfs_inode.h |   10 ++++++++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cb9b6d1..3631783 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -253,16 +253,21 @@ xfs_iget_cache_hit(
 			rcu_read_lock();
 			spin_lock(&ip->i_flags_lock);
 
-			ip->i_flags &= ~XFS_INEW;
-			ip->i_flags |= XFS_IRECLAIMABLE;
-			__xfs_inode_set_reclaim_tag(pag, ip);
+			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
 			trace_xfs_iget_reclaim_fail(ip);
 			goto out_error;
 		}
 
 		spin_lock(&pag->pag_ici_lock);
 		spin_lock(&ip->i_flags_lock);
-		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
+
+		/*
+		 * Clear the per-lifetime state in the inode as we are now
+		 * effectively a new inode and need to return to the initial
+		 * state before reuse occurs.
+		 */
+		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 		ip->i_flags |= XFS_INEW;
 		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		inode->i_state = I_NEW;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3ae6d58..964cfea 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -384,6 +384,16 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
 
 /*
+ * Per-lifetime flags need to be reset when re-using a reclaimable inode during
+ * inode lookup. Thi prevents unintended behaviour on the new inode from
+ * ocurring.
+ */
+#define XFS_IRECLAIM_RESET_FLAGS	\
+	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
+	 XFS_IFILESTREAM);
+
+/*
  * Flags for inode locking.
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
