Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbeFXTYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOMAJ119885
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:22 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:21 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOL8m026177
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:21 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOL2k031571
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:21 GMT
Subject: [PATCH 08/21] xfs: defer iput on certain inodes while scrub /
 repair are running
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:20 -0700
Message-ID: <152986826018.3155.9241833069276452949.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Destroying an incore inode sometimes requires some work to be done on
the inode.  For example, post-EOF blocks on a non-PREALLOC inode are
trimmed, and copy-on-write staging extents are freed.  This work is done
in separate transactions, which is bad for scrub and repair because (a)
we already have a transaction and can't nest them, and (b) if we've
frozen the filesystem for scrub/repair work, that (regular) transaction
allocation will block on the freeze.

Therefore, if we detect that work has to be done to destroy the incore
inode, we'll just hang on to the reference until after the scrub is
finished.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |    1 +
 fs/xfs/scrub/dir.c    |    2 +-
 fs/xfs/scrub/parent.c |    6 +++---
 fs/xfs/scrub/scrub.c  |   20 +++++++++++++++++++
 fs/xfs/scrub/scrub.h  |    9 ++++++++
 fs/xfs/scrub/trace.h  |   30 ++++++++++++++++++++++++++++
 7 files changed, 116 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c1132a40a366..9740c28384b6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -22,6 +22,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_bmap_util.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_refcount.h"
@@ -890,3 +891,54 @@ xfs_scrub_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
+
+/*
+ * Release a reference to an inode while the fs is running a scrub or repair.
+ * If we anticipate that destroying the incore inode will require work to be
+ * done, we'll defer the iput until after the scrub/repair releases the
+ * transaction.
+ */
+void
+xfs_scrub_iput(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	/*
+	 * If this file doesn't have any blocks to be freed at release time,
+	 * go straight to iput.
+	 */
+	if (!xfs_can_free_eofblocks(ip, true))
+		goto iput;
+
+	/*
+	 * Any real/unwritten extents in the CoW fork will have to be freed
+	 * so iput if there aren't any.
+	 */
+	if (!xfs_inode_has_cow_blocks(ip))
+		goto iput;
+
+	/*
+	 * Any blocks after the end of the file will have to be freed so iput
+	 * if there aren't any.
+	 */
+	if (!xfs_inode_has_posteof_blocks(ip))
+		goto iput;
+
+	/*
+	 * There are no other users of i_private in XFS so if it's non-NULL
+	 * this inode is already on the deferred iput list and we can release
+	 * this reference.
+	 */
+	if (VFS_I(ip)->i_private)
+		goto iput;
+
+	/* Otherwise, add it to the deferred iput list. */
+	trace_xfs_scrub_iput_defer(ip, __return_address);
+	VFS_I(ip)->i_private = sc->deferred_iput_list;
+	sc->deferred_iput_list = VFS_I(ip);
+	return;
+
+iput:
+	trace_xfs_scrub_iput_now(ip, __return_address);
+	iput(VFS_I(ip));
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2172bd5361e2..ca9e15af2a4f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -140,5 +140,6 @@ static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
 
 int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
 int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+void xfs_scrub_iput(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 86324775fc9b..5cb371576732 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -87,7 +87,7 @@ xfs_scrub_dir_check_ftype(
 			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
 	if (ino_dtype != dtype)
 		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-	iput(VFS_I(ip));
+	xfs_scrub_iput(sdc->sc, ip);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index e2bda58c32f0..fd0b2bfb8f18 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -230,11 +230,11 @@ xfs_scrub_parent_validate(
 
 	/* Drat, parent changed.  Try again! */
 	if (dnum != dp->i_ino) {
-		iput(VFS_I(dp));
+		xfs_scrub_iput(sc, dp);
 		*try_again = true;
 		return 0;
 	}
-	iput(VFS_I(dp));
+	xfs_scrub_iput(sc, dp);
 
 	/*
 	 * '..' didn't change, so check that there was only one entry
@@ -247,7 +247,7 @@ xfs_scrub_parent_validate(
 out_unlock:
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 out_rele:
-	iput(VFS_I(dp));
+	xfs_scrub_iput(sc, dp);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index fec0e130f19e..b66cfbc56a34 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -157,6 +157,24 @@ xfs_scrub_probe(
 
 /* Scrub setup and teardown */
 
+/* Release all references to inodes we encountered needing deferred iput. */
+STATIC void
+xfs_scrub_iput_deferred(
+	struct xfs_scrub_context	*sc)
+{
+	struct inode			*inode, *next;
+
+	inode = sc->deferred_iput_list;
+	while (inode != (struct inode *)sc) {
+		next = inode->i_private;
+		inode->i_private = NULL;
+		trace_xfs_scrub_iput_deferred(XFS_I(inode), __return_address);
+		iput(inode);
+		inode = next;
+	}
+	sc->deferred_iput_list = sc;
+}
+
 /* Free all the resources and finish the transactions. */
 STATIC int
 xfs_scrub_teardown(
@@ -180,6 +198,7 @@ xfs_scrub_teardown(
 			iput(VFS_I(sc->ip));
 		sc->ip = NULL;
 	}
+	xfs_scrub_iput_deferred(sc);
 	if (sc->has_quotaofflock)
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (sc->buf) {
@@ -506,6 +525,7 @@ xfs_scrub_metadata(
 	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.try_harder = try_harder;
 	sc.sa.agno = NULLAGNUMBER;
+	sc.deferred_iput_list = &sc;
 	error = sc.ops->setup(&sc, ip);
 	if (error)
 		goto out_teardown;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b295edd5fc0e..69eee2ffed29 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -65,6 +65,15 @@ struct xfs_scrub_context {
 	bool				try_harder;
 	bool				has_quotaofflock;
 
+	/*
+	 * List of inodes which cannot be released (by scrub) until after the
+	 * scrub operation concludes because we'd have to do some work to the
+	 * inode to destroy its incore representation (cow blocks, posteof
+	 * blocks, etc.).  Each inode's i_private points to the next inode, or
+	 * to the scrub context as a sentinel for the end of the list.
+	 */
+	void				*deferred_iput_list;
+
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;
 };
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cec3e5ece5a1..a050a00fc258 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -480,6 +480,36 @@ TRACE_EVENT(xfs_scrub_xref_error,
 		  __entry->ret_ip)
 );
 
+DECLARE_EVENT_CLASS(xfs_scrub_iref_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_failaddr_t caller_ip),
+	TP_ARGS(ip, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, count)
+		__field(xfs_failaddr_t, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx count %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->count,
+		  __entry->caller_ip)
+)
+
+#define DEFINE_SCRUB_IREF_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_iref_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_failaddr_t caller_ip), \
+	TP_ARGS(ip, caller_ip))
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_deferred);
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_defer);
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_now);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

