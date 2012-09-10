Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8AIZlZ0175861 for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 13:35:47 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W2ARPpQ9sxwGSG5R for
	<xfs@oss.sgi.com>; Mon, 10 Sep 2012 11:36:50 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8AIaoCk020894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 14:36:50 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8AIancN027942
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 14:36:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/8] xfs: create function to scan and clear EOFBLOCKS inodes
Date: Mon, 10 Sep 2012 14:37:23 -0400
Message-Id: <1347302246-52710-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347302246-52710-1-git-send-email-bfoster@redhat.com>
References: <1347302246-52710-1-git-send-email-bfoster@redhat.com>
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

xfs_inodes_free_eofblocks() implements scanning functionality for
EOFBLOCKS inodes. It uses the AG iterator to walk the tagged inodes
and free post-EOF blocks via the xfs_inode_free_eofblocks() execute
function. The scan can be invoked in best-effort mode or wait
(force) mode.

A best-effort scan (default) handles all inodes for which we
successfully acquire the io lock via trylock. In wait mode, we
continue to cycle through an AG until all inodes are handled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sync.c  |   36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h  |    1 +
 fs/xfs/xfs_trace.h |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 0da93c9..a248a52 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -1014,6 +1014,42 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
+STATIC int
+xfs_inode_free_eofblocks(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags,
+	void			*args)
+{
+	int ret;
+	bool force = flags & SYNC_WAIT;
+
+	if (!xfs_can_free_eofblocks(ip, false)) {
+		/* inode could be preallocated or append-only */
+		trace_xfs_inode_free_eofblocks_invalid(ip);
+		xfs_inode_clear_eofblocks_tag(ip);
+		return 0;
+	}
+
+	ret = xfs_free_eofblocks(ip->i_mount, ip, false);
+
+	/* ignore EAGAIN on a best effort scan */
+	if (!force && (ret == EAGAIN))
+		ret = 0;
+
+	return ret;
+}
+
+int
+xfs_inodes_free_eofblocks(
+	struct xfs_mount	*mp,
+	int			flags)
+{
+	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
+	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
+					 NULL, XFS_ICI_EOFBLOCKS_TAG);
+}
+
 void
 xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 463ea0a..307654a 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -45,6 +45,7 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
+int xfs_inodes_free_eofblocks(struct xfs_mount *, int);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d081f3e..9c810f7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -588,6 +588,7 @@ DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
 
 DEFINE_INODE_EVENT(xfs_inode_set_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
+DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
