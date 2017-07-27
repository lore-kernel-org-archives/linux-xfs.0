Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46694 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdG0WmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:42:20 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMgIvf012083
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMgITh009395
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:18 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6RMgIN6003313
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:18 GMT
Subject: [PATCH 06/26] xfs: create helpers to scrub a metadata btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:42:17 -0700
Message-ID: <150119533693.15159.16871161757150604640.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create helper functions and tracepoints to deal with errors while
scrubbing a metadata btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/scrub/btree.c |  119 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.h |   57 +++++++++++++++++
 fs/xfs/scrub/trace.c |   14 ++++
 fs/xfs/scrub/trace.h |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 362 insertions(+)
 create mode 100644 fs/xfs/scrub/btree.c
 create mode 100644 fs/xfs/scrub/btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index bce3a94..276b7a3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -144,6 +144,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
 xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
+				   btree.o \
 				   common.o \
 				   scrub.o \
 				   )
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
new file mode 100644
index 0000000..4b95909
--- /dev/null
+++ b/fs/xfs/scrub/btree.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* btree scrubbing */
+
+static const union xfs_btree_ptr nullptr = {
+	.s = cpu_to_be32(NULLAGBLOCK),
+	.l = cpu_to_be64(NULLFSBLOCK),
+};
+
+/* Check for btree operation errors . */
+bool
+xfs_scrub_btree_op_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	int				*error)
+{
+	if (*error == 0)
+		return true;
+
+	switch (*error) {
+	case -EDEADLOCK:
+		/* Used to restart an op with deadlock avoidance. */
+		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Note the badness but don't abort. */
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		*error = 0;
+		/* fall through */
+	default:
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
+					*error, __return_address);
+		else
+			trace_xfs_scrub_btree_op_error(sc, cur, level,
+					*error, __return_address);
+		break;
+	}
+	return false;
+}
+
+/* Check for btree corruption. */
+bool
+xfs_scrub_btree_check_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	int				level,
+	bool				fs_ok)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		trace_xfs_scrub_ifork_btree_error(sc, cur, level,
+				__return_address);
+	else
+		trace_xfs_scrub_btree_error(sc, cur, level,
+				__return_address);
+	return fs_ok;
+}
+
+/*
+ * Visit all nodes and leaves of a btree.  Check that all pointers and
+ * records are in order, that the keys reflect the records, and use a callback
+ * so that the caller can verify individual records.  The callback is the same
+ * as the one for xfs_btree_query_range, so therefore this function also
+ * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
+ */
+int
+xfs_scrub_btree(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		*cur,
+	xfs_scrub_btree_rec_fn		scrub_fn,
+	struct xfs_owner_info		*oinfo,
+	void				*private)
+{
+	xfs_scrub_btree_op_ok(sc, cur, 0, false);
+	return -EOPNOTSUPP;
+}
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
new file mode 100644
index 0000000..133e33d
--- /dev/null
+++ b/fs/xfs/scrub/btree.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_SCRUB_BTREE_H__
+#define __XFS_SCRUB_BTREE_H__
+
+/* btree scrub */
+
+/* Check for btree operation errors. */
+bool xfs_scrub_btree_op_ok(struct xfs_scrub_context *sc,
+			   struct xfs_btree_cur *cur, int level, int *error);
+
+/* Check for btree corruption. */
+bool xfs_scrub_btree_check_ok(struct xfs_scrub_context *sc,
+			      struct xfs_btree_cur *cur, int level, bool fs_ok);
+
+struct xfs_scrub_btree;
+typedef int (*xfs_scrub_btree_rec_fn)(
+	struct xfs_scrub_btree	*bs,
+	union xfs_btree_rec	*rec);
+
+struct xfs_scrub_btree {
+	/* caller-provided scrub state */
+	struct xfs_scrub_context	*sc;
+	struct xfs_btree_cur		*cur;
+	xfs_scrub_btree_rec_fn		scrub_rec;
+	struct xfs_owner_info		*oinfo;
+	void				*private;
+
+	/* internal scrub state */
+	union xfs_btree_rec		lastrec;
+	bool				firstrec;
+	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
+	bool				firstkey[XFS_BTREE_MAXLEVELS];
+	struct list_head		to_check;
+};
+int xfs_scrub_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		    xfs_scrub_btree_rec_fn scrub_fn,
+		    struct xfs_owner_info *oinfo, void *private);
+
+#endif /* __XFS_SCRUB_BTREE_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 88b5ccb..ee00115 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -30,10 +30,24 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
+#include "xfs_bit.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
+/* Figure out which block the btree cursor was pointing to. */
+static inline xfs_fsblock_t
+xfs_scrub_btree_cur_fsbno(
+	struct xfs_btree_cur		*cur,
+	int				level)
+{
+	if (level < cur->bc_nlevels && cur->bc_bufs[level])
+		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
+	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_private.b.ip->i_ino);
+	return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno, 0);
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9a72f18..e857c66 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -268,6 +268,177 @@ TRACE_EVENT(xfs_scrub_incomplete,
 		  __entry->ret_ip)
 );
 
+#define XFS_BTNUM_DESC \
+	{ XFS_BTNUM_BNO,	"bnobt" }, \
+	{ XFS_BTNUM_CNT,	"cntbt" }, \
+	{ XFS_BTNUM_RMAP,	"rmapbt" }, \
+	{ XFS_BTNUM_BMAP,	"bmapbt" }, \
+	{ XFS_BTNUM_INO,	"inobt" }, \
+	{ XFS_BTNUM_FINO,	"finobt" }, \
+	{ XFS_BTNUM_REFC,	"refcountbt" }
+
+TRACE_EVENT(xfs_scrub_btree_op_error,
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		 int level, int error, void *ret_ip),
+	TP_ARGS(sc, cur, level, error, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(xfs_btnum_t, btnum)
+		__field(int, level)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, ptr);
+		__field(int, error)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+		__entry->ptr = cur->bc_ptrs[level];
+		__entry->error = error;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type '%s' btnum '%s' level %d ptr %d agno %u agbno %u error %d ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_DESC),
+		  __entry->level,
+		  __entry->ptr,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->error,
+		  __entry->ret_ip)
+);
+
+TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		 int level, int error, void *ret_ip),
+	TP_ARGS(sc, cur, level, error, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(int, type)
+		__field(xfs_btnum_t, btnum)
+		__field(int, level)
+		__field(int, ptr)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, error)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->ip->i_ino;
+		__entry->whichfork = cur->bc_private.b.whichfork;
+		__entry->type = sc->sm->sm_type;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->ptr = cur->bc_ptrs[level];
+		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+		__entry->error = error;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d ino %llu fork '%s' type '%s' btnum '%s' level %d ptr %d agno %u agbno %u error %d ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_FORK_DESC),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_DESC),
+		  __entry->level,
+		  __entry->ptr,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->error,
+		  __entry->ret_ip)
+);
+
+TRACE_EVENT(xfs_scrub_btree_error,
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		 int level, void *ret_ip),
+	TP_ARGS(sc, cur, level, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(xfs_btnum_t, btnum)
+		__field(int, level)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, ptr);
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d type '%s' btnum '%s' level %d ptr %d agno %u agbno %u ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_DESC),
+		  __entry->level,
+		  __entry->ptr,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->ret_ip)
+);
+
+TRACE_EVENT(xfs_scrub_ifork_btree_error,
+	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		 int level, void *ret_ip),
+	TP_ARGS(sc, cur, level, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(int, type)
+		__field(xfs_btnum_t, btnum)
+		__field(int, level)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, ptr);
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->ip->i_ino;
+		__entry->whichfork = cur->bc_private.b.whichfork;
+		__entry->type = sc->sm->sm_type;
+		__entry->btnum = cur->bc_btnum;
+		__entry->level = level;
+		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d ino %llu fork '%s' type '%s' btnum '%s' level %d ptr %d agno %u agbno %u ret_ip %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_FORK_DESC),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_DESC),
+		  __entry->level,
+		  __entry->ptr,
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->ret_ip)
+);
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

