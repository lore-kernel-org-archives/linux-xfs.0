Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RJo1q6237166 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 14:50:02 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XJ3RtSgFB1hGy0bE for
	<xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:50:52 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJopTi025427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q7RJopHY032578
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 1/4] xfs: add EOFBLOCKS inode tagging/untagging
Date: Mon, 27 Aug 2012 15:51:48 -0400
Message-Id: <1346097111-4476-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
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

Add the XFS_ICI_EOFBLOCKS_TAG inode tag to identify inodes with
speculatively preallocated blocks beyond EOF. An inode is tagged
when speculative preallocation occurs and untagged either via
truncate down or when post-EOF blocks are freed via release or
reclaim.

The tag management is intentionally not aggressive to prefer
simplicity over the complexity of handling all the corner cases
under which post-EOF blocks could be freed (i.e., forward
truncation, fallocate, write error conditions, etc.). This means
that a tagged inode may or may not have post-EOF blocks after a
period of time. The tag is eventually cleared when the inode is
released or reclaimed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ag.h       |    1 +
 fs/xfs/xfs_inode.h    |    8 ++++-
 fs/xfs/xfs_iomap.c    |    7 ++++
 fs/xfs/xfs_iops.c     |    3 ++
 fs/xfs/xfs_sync.c     |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h     |    3 ++
 fs/xfs/xfs_trace.h    |    5 +++
 fs/xfs/xfs_vnodeops.c |    3 ++
 8 files changed, 105 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 44d65c1..22bd4db 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -233,6 +233,7 @@ typedef struct xfs_perag {
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
 					   in xfs_inode_ag_iterator */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
+#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
 
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 94b32f9..2cd2883 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -305,10 +305,16 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline void
+__xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+{
+	ip->i_flags &= ~flags;
+}
+
+static inline void
 xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
 {
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~flags;
+	__xfs_iflags_clear(ip, flags);
 	spin_unlock(&ip->i_flags_lock);
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 973dff6..2968ee8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -459,6 +459,13 @@ retry:
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
 		return xfs_alert_fsblock_zero(ip, &imap[0]);
 
+	/*
+	 * Tag the inode as speculatively preallocated so we can reclaim this
+	 * space on demand, if necessary.
+	 */
+	if (prealloc)
+		xfs_inode_set_eofblocks_tag(ip);
+
 	*ret_imap = imap[0];
 	return 0;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4e00cf0..dcd1d5f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -854,6 +854,9 @@ xfs_setattr_size(
 		 * and do not wait the usual (long) time for writeout.
 		 */
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
+
+		/* A truncate down always removes post-EOF blocks. */
+		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
 	if (mask & ATTR_CTIME) {
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 9654817..5e14741 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -971,3 +971,79 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
+STATIC void
+__xfs_inode_set_eofblocks_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	int tagged = radix_tree_tagged(&pag->pag_ici_root,
+				       XFS_ICI_EOFBLOCKS_TAG);
+
+	radix_tree_tag_set(&pag->pag_ici_root,
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_EOFBLOCKS_TAG);
+
+	if (!tagged) {
+		/* propagate the eofblocks tag up into the perag radix tree */
+		spin_lock(&ip->i_mount->m_perag_lock);
+		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
+				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				   XFS_ICI_EOFBLOCKS_TAG);
+		spin_unlock(&ip->i_mount->m_perag_lock);
+
+		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
+					      -1, _RET_IP_);
+	}
+}
+
+void
+xfs_inode_set_eofblocks_tag(
+	xfs_inode_t	*ip)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	trace_xfs_set_eofblocks_tag(ip);
+	__xfs_inode_set_eofblocks_tag(pag, ip);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
+STATIC void
+__xfs_inode_clear_eofblocks(
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			     XFS_ICI_EOFBLOCKS_TAG);
+
+	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_EOFBLOCKS_TAG)) {
+		/* clear the eofblocks tag from the perag radix tree */
+		spin_lock(&ip->i_mount->m_perag_lock);
+		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
+				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				     XFS_ICI_EOFBLOCKS_TAG);
+		spin_unlock(&ip->i_mount->m_perag_lock);
+		trace_xfs_perag_clear_eofblocks(ip->i_mount, pag->pag_agno,
+					       -1, _RET_IP_);
+	}
+}
+
+void
+xfs_inode_clear_eofblocks_tag(
+	xfs_inode_t	*ip)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	trace_xfs_clear_eofblocks_tag(ip);
+	__xfs_inode_clear_eofblocks(pag, ip);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 941202e..4486491 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -43,6 +43,9 @@ void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
+void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
+void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
+
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e5795dd..47e37da 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -129,6 +129,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
 
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
@@ -584,6 +586,9 @@ DEFINE_INODE_EVENT(xfs_update_time);
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
 
+DEFINE_INODE_EVENT(xfs_set_eofblocks_tag);
+DEFINE_INODE_EVENT(xfs_clear_eofblocks_tag);
+
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
 	TP_ARGS(ip, caller_ip),
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2a5c6373..658ee2e 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -467,6 +467,8 @@ xfs_release(
 		if (error)
 			return error;
 
+		xfs_inode_clear_eofblocks_tag(ip);
+
 		/* delalloc blocks after truncation means it really is dirty */
 		if (ip->i_delayed_blks)
 			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
@@ -523,6 +525,7 @@ xfs_inactive(
 			error = xfs_free_eofblocks(mp, ip, false);
 			if (error)
 				return VN_INACTIVE_CACHE;
+			xfs_inode_clear_eofblocks_tag(ip);
 		}
 		goto out;
 	}
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
