Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECIJAu092238 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:18:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UotuQiwrBEnPn67s for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 05:19:25 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ECJP2o006862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8ECJPBQ022248
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 5/8] xfs: create function to scan and clear EOFBLOCKS inodes
Date: Fri, 14 Sep 2012 08:19:52 -0400
Message-Id: <1347625195-6369-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
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

A best-effort scan (default) handles all inodes that do not have a
dirty cache and we successfully acquire the io lock via trylock. In
wait mode, we continue to cycle through an AG until all inodes are
handled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sync.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h  |    1 +
 fs/xfs/xfs_trace.h |    1 +
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 0da93c9..48cab9f 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -1014,6 +1014,46 @@ xfs_reclaim_inodes_count(
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
+	if (!force && mapping_tagged(VFS_I(ip)->i_mapping,
+				     PAGECACHE_TAG_DIRTY))
+		return 0;
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
index 6f46e03..cb52346 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -589,6 +589,7 @@ DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
 
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
