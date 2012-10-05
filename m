Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEAwE053210 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:10 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7FFU02FH6mnn8hKY for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFasY025349
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q95EFadU014852
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 01/10] xfs: add EOFBLOCKS inode tagging/untagging
Date: Fri,  5 Oct 2012 10:17:07 -0400
Message-Id: <1349446636-8611-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h       |    1 +
 fs/xfs/xfs_icache.c   |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h   |    3 ++
 fs/xfs/xfs_iomap.c    |    8 ++++++
 fs/xfs/xfs_iops.c     |    4 +++
 fs/xfs/xfs_trace.h    |    5 ++++
 fs/xfs/xfs_vnodeops.c |    2 +
 7 files changed, 85 insertions(+), 0 deletions(-)

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
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9c8703b..f9afc5f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1128,3 +1128,65 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
+void
+xfs_inode_set_eofblocks_tag(
+	xfs_inode_t	*ip)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
+	int tagged;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	trace_xfs_inode_set_eofblocks_tag(ip);
+
+	tagged = radix_tree_tagged(&pag->pag_ici_root,
+				   XFS_ICI_EOFBLOCKS_TAG);
+	radix_tree_tag_set(&pag->pag_ici_root,
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_EOFBLOCKS_TAG);
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
+
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
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
+	trace_xfs_inode_clear_eofblocks_tag(ip);
+
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			     XFS_ICI_EOFBLOCKS_TAG);
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
+
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 222e22f..db36130 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -35,6 +35,9 @@ void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
+void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
+
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f858b90..08b8777 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -41,6 +41,7 @@
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -450,6 +451,13 @@ retry:
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
index 4e00cf0..81f5c49 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,6 +38,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -854,6 +855,9 @@ xfs_setattr_size(
 		 * and do not wait the usual (long) time for writeout.
 		 */
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
+
+		/* A truncate down always removes post-EOF blocks. */
+		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
 	if (mask & ATTR_CTIME) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7d36ccf..6f46e03 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -130,6 +130,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
 
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
@@ -585,6 +587,9 @@ DEFINE_INODE_EVENT(xfs_update_time);
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
 
+DEFINE_INODE_EVENT(xfs_inode_set_eofblocks_tag);
+DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
+
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
 	TP_ARGS(ip, caller_ip),
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index e9cae13..d8ce502 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -238,6 +238,8 @@ xfs_free_eofblocks(
 		} else {
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
+			if (!error)
+				xfs_inode_clear_eofblocks_tag(ip);
 		}
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
