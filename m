Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25659 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdIUASD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:18:03 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0I3Sx005183
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0I3Wf014207
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0I28n031955
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:02 GMT
Subject: [PATCH 04/27] xfs: dispatch metadata scrub subcommands
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:18:02 -0700
Message-ID: <150595308233.18473.14684248657858896342.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create structures needed to hold scrubbing context and dispatch incoming
commands to the individual scrubbers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h |   19 ++++++
 fs/xfs/scrub/trace.h |   43 +++++++++++++
 3 files changed, 233 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5db2a6f..7cf518e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -44,11 +44,181 @@
 #include "scrub/scrub.h"
 #include "scrub/trace.h"
 
+/*
+ * Online Scrub and Repair
+ *
+ * Traditionally, XFS (the kernel driver) did not know how to check or
+ * repair on-disk data structures.  That task was left to the xfs_check
+ * and xfs_repair tools, both of which require taking the filesystem
+ * offline for a thorough but time consuming examination.  Online
+ * scrub & repair, on the other hand, enables us to check the metadata
+ * for obvious errors while carefully stepping around the filesystem's
+ * ongoing operations, locking rules, etc.
+ *
+ * Given that most XFS metadata consist of records stored in a btree,
+ * most of the checking functions iterate the btree blocks themselves
+ * looking for irregularities.  When a record block is encountered, each
+ * record can be checked for obviously bad values.  Record values can
+ * also be cross-referenced against other btrees to look for potential
+ * misunderstandings between pieces of metadata.
+ *
+ * It is expected that the checkers responsible for per-AG metadata
+ * structures will lock the AG headers (AGI, AGF, AGFL), iterate the
+ * metadata structure, and perform any relevant cross-referencing before
+ * unlocking the AG and returning the results to userspace.  These
+ * scrubbers must not keep an AG locked for too long to avoid tying up
+ * the block and inode allocators.
+ *
+ * Block maps and b-trees rooted in an inode present a special challenge
+ * because they can involve extents from any AG.  The general scrubber
+ * structure of lock -> check -> xref -> unlock still holds, but AG
+ * locking order rules /must/ be obeyed to avoid deadlocks.  The
+ * ordering rule, of course, is that we must lock in increasing AG
+ * order.  Helper functions are provided to track which AG headers we've
+ * already locked.  If we detect an imminent locking order violation, we
+ * can signal a potential deadlock, in which case the scrubber can jump
+ * out to the top level, lock all the AGs in order, and retry the scrub.
+ *
+ * For file data (directories, extended attributes, symlinks) scrub, we
+ * can simply lock the inode and walk the data.  For btree data
+ * (directories and attributes) we follow the same btree-scrubbing
+ * strategy outlined previously to check the records.
+ *
+ * We use a bit of trickery with transactions to avoid buffer deadlocks
+ * if there is a cycle in the metadata.  The basic problem is that
+ * travelling down a btree involves locking the current buffer at each
+ * tree level.  If a pointer should somehow point back to a buffer that
+ * we've already examined, we will deadlock due to the second buffer
+ * locking attempt.  Note however that grabbing a buffer in transaction
+ * context links the locked buffer to the transaction.  If we try to
+ * re-grab the buffer in the context of the same transaction, we avoid
+ * the second lock attempt and continue.  Between the verifier and the
+ * scrubber, something will notice that something is amiss and report
+ * the corruption.  Therefore, each scrubber will allocate an empty
+ * transaction, attach buffers to it, and cancel the transaction at the
+ * end of the scrub run.  Cancelling a non-dirty transaction simply
+ * unlocks the buffers.
+ *
+ * There are four pieces of data that scrub can communicate to
+ * userspace.  The first is the error code (errno), which can be used to
+ * communicate operational errors in performing the scrub.  There are
+ * also three flags that can be set in the scrub context.  If the data
+ * structure itself is corrupt, the CORRUPT flag will be set.  If
+ * the metadata is correct but otherwise suboptimal, the PREEN flag
+ * will be set.
+ */
+
+/* Scrub setup and teardown */
+
+/* Free all the resources and finish the transactions. */
+STATIC int
+xfs_scrub_teardown(
+	struct xfs_scrub_context	*sc,
+	int				error)
+{
+	if (sc->tp) {
+		xfs_trans_cancel(sc->tp);
+		sc->tp = NULL;
+	}
+	return error;
+}
+
+/* Scrubbing dispatch. */
+
+static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
+};
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
 	struct xfs_inode		*ip,
 	struct xfs_scrub_metadata	*sm)
 {
-	return -EOPNOTSUPP;
+	struct xfs_scrub_context	sc;
+	struct xfs_mount		*mp = ip->i_mount;
+	const struct xfs_scrub_meta_ops	*ops;
+	bool				try_harder = false;
+	int				error = 0;
+
+	trace_xfs_scrub_start(ip, sm, error);
+
+	/* Forbidden if we are shut down or mounted norecovery. */
+	error = -ESHUTDOWN;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out;
+	error = -ENOTRECOVERABLE;
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		goto out;
+
+	/* Check our inputs. */
+	error = -EINVAL;
+	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
+		goto out;
+	if (memchr_inv(sm->sm_reserved, 0, sizeof(sm->sm_reserved)))
+		goto out;
+
+	/* Do we know about this type of metadata? */
+	error = -ENOENT;
+	if (sm->sm_type >= XFS_SCRUB_TYPE_NR)
+		goto out;
+	ops = &meta_scrub_ops[sm->sm_type];
+	if (ops->scrub == NULL)
+		goto out;
+
+	/* Does this fs even support this type of metadata? */
+	if (ops->has && !ops->has(&mp->m_sb))
+		goto out;
+
+	/* We don't know how to repair anything yet. */
+	error = -EOPNOTSUPP;
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		goto out;
+
+	/* This isn't a stable feature.  Use with care. */
+	{
+		static bool warned;
+
+		if (!warned)
+			xfs_alert(mp,
+	"EXPERIMENTAL online scrub feature in use. Use at your own risk!");
+		warned = true;
+	}
+
+retry_op:
+	/* Set up for the operation. */
+	memset(&sc, 0, sizeof(sc));
+	sc.mp = ip->i_mount;
+	sc.sm = sm;
+	sc.ops = ops;
+	sc.try_harder = try_harder;
+	error = sc.ops->setup(&sc, ip);
+	if (error)
+		goto out_teardown;
+
+	/* Scrub for errors. */
+	error = sc.ops->scrub(&sc);
+	if (!try_harder && error == -EDEADLOCK) {
+		/*
+		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
+		 * Tear down everything we hold, then set up again with
+		 * preparation for worst-case scenarios.
+		 */
+		error = xfs_scrub_teardown(&sc, 0);
+		if (error)
+			goto out;
+		try_harder = true;
+		goto retry_op;
+	} else if (error)
+		goto out_teardown;
+
+	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT))
+		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+
+out_teardown:
+	error = xfs_scrub_teardown(&sc, error);
+out:
+	trace_xfs_scrub_done(ip, sm, error);
+	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index eb1cd9d..b271b2a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -20,6 +20,25 @@
 #ifndef __XFS_SCRUB_SCRUB_H__
 #define __XFS_SCRUB_SCRUB_H__
 
+struct xfs_scrub_context;
+
+struct xfs_scrub_meta_ops {
+	int		(*setup)(struct xfs_scrub_context *,
+				 struct xfs_inode *);
+	int		(*scrub)(struct xfs_scrub_context *);
+	bool		(*has)(struct xfs_sb *);
+};
+
+struct xfs_scrub_context {
+	/* General scrub state. */
+	struct xfs_mount		*mp;
+	struct xfs_scrub_metadata	*sm;
+	const struct xfs_scrub_meta_ops	*ops;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	bool				try_harder;
+};
+
 /* Metadata scrubbers */
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a95a7c8..688517e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -25,6 +25,49 @@
 
 #include <linux/tracepoint.h>
 
+DECLARE_EVENT_CLASS(xfs_scrub_class,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
+		 int error),
+	TP_ARGS(ip, sm, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, inum)
+		__field(unsigned int, gen)
+		__field(unsigned int, flags)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->type = sm->sm_type;
+		__entry->agno = sm->sm_agno;
+		__entry->inum = sm->sm_ino;
+		__entry->gen = sm->sm_gen;
+		__entry->flags = sm->sm_flags;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d ino %llu type %u agno %u inum %llu gen %u flags 0x%x error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->type,
+		  __entry->agno,
+		  __entry->inum,
+		  __entry->gen,
+		  __entry->flags,
+		  __entry->error)
+)
+#define DEFINE_SCRUB_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm, \
+		 int error), \
+	TP_ARGS(ip, sm, error))
+
+DEFINE_SCRUB_EVENT(xfs_scrub_start);
+DEFINE_SCRUB_EVENT(xfs_scrub_done);
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

