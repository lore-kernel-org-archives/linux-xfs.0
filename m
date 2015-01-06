Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DBAA7F8C
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 306D4304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:49 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id DiGc6kdlpg6ggocP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:47 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/18] nfsd: add trace events
Date: Tue,  6 Jan 2015 17:28:35 +0100
Message-Id: <1420561721-9150-13-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

For now just a few simple events to trace the layout stateid lifetime, but
these already were enough to find several bugs in the Linux client layout
stateid handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/Makefile      |  7 ++++++-
 fs/nfsd/nfs4layouts.c | 16 ++++++++++++++-
 fs/nfsd/nfs4proc.c    |  6 +++++-
 fs/nfsd/trace.c       |  5 +++++
 fs/nfsd/trace.h       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 3 deletions(-)
 create mode 100644 fs/nfsd/trace.c
 create mode 100644 fs/nfsd/trace.h

diff --git a/fs/nfsd/Makefile b/fs/nfsd/Makefile
index 5806270..6cba933 100644
--- a/fs/nfsd/Makefile
+++ b/fs/nfsd/Makefile
@@ -2,9 +2,14 @@
 # Makefile for the Linux nfs server
 #
 
+ccflags-y += -I$(src)			# needed for trace events
+
 obj-$(CONFIG_NFSD)	+= nfsd.o
 
-nfsd-y 			:= nfssvc.o nfsctl.o nfsproc.o nfsfh.o vfs.o \
+# this one should be compiled first, as the tracing macros can easily blow up
+nfsd-y			+= trace.o
+
+nfsd-y 			+= nfssvc.o nfsctl.o nfsproc.o nfsfh.o vfs.o \
 			   export.o auth.o lockd.o nfscache.o nfsxdr.o stats.o
 nfsd-$(CONFIG_NFSD_FAULT_INJECTION) += fault_inject.o
 nfsd-$(CONFIG_NFSD_V2_ACL) += nfs2acl.o
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 72a12ca..bb91981 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -9,6 +9,7 @@
 
 #include "pnfs.h"
 #include "netns.h"
+#include "trace.h"
 
 #define NFSDDBG_FACILITY                NFSDDBG_PNFS
 
@@ -124,6 +125,8 @@ nfsd4_free_layout_stateid(struct nfs4_stid *stid)
 	struct nfs4_client *clp = ls->ls_stid.sc_client;
 	struct nfs4_file *fp = ls->ls_stid.sc_file;
 
+	trace_layoutstate_free(&ls->ls_stid.sc_stateid);
+
 	spin_lock(&clp->cl_lock);
 	list_del_init(&ls->ls_perclnt);
 	spin_unlock(&clp->cl_lock);
@@ -214,6 +217,7 @@ nfsd4_alloc_layout_stateid(struct nfsd4_compound_state *cstate,
 	list_add(&ls->ls_perfile, &fp->fi_lo_states);
 	spin_unlock(&fp->fi_lock);
 
+	trace_layoutstate_alloc(&ls->ls_stid.sc_stateid);
 	return ls;
 }
 
@@ -279,6 +283,8 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 	if (list_empty(&ls->ls_layouts))
 		goto out_unlock;
 
+	trace_layout_recall(&ls->ls_stid.sc_stateid);
+
 	atomic_inc(&ls->ls_stid.sc_count);
 	update_stateid(&ls->ls_stid.sc_stateid);
 	memcpy(&ls->ls_recall_sid, &ls->ls_stid.sc_stateid, sizeof(stateid_t));
@@ -453,8 +459,10 @@ nfsd4_return_file_layouts(struct svc_rqst *rqstp,
 	nfserr = nfsd4_preprocess_layout_stateid(rqstp, cstate, &lrp->lr_sid,
 						false, lrp->lr_layout_type,
 						&ls);
-	if (nfserr)
+	if (nfserr) {
+		trace_layout_return_lookup_fail(&lrp->lr_sid);
 		return nfserr;
+	}
 
 	spin_lock(&ls->ls_lock);
 	list_for_each_entry_safe(lp, n, &ls->ls_layouts, lo_perstate) {
@@ -471,6 +479,7 @@ nfsd4_return_file_layouts(struct svc_rqst *rqstp,
 		}
 		lrp->lrs_present = 1;
 	} else {
+		trace_layoutstate_unhash(&ls->ls_stid.sc_stateid);
 		nfs4_unhash_stid(&ls->ls_stid);
 		lrp->lrs_present = 0;
 	}
@@ -569,6 +578,8 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
 
 	rpc_ntop((struct sockaddr *)&clp->cl_addr, addr_str, sizeof(addr_str));
 
+	nfsd4_cb_layout_fail(ls);
+
 	printk(KERN_WARNING
 		"nfsd: client %s failed to respond to layout recall. "
 		"  Fencing..\n", addr_str);
@@ -596,6 +607,7 @@ nfsd4_cb_layout_done(struct nfsd4_callback *cb, struct rpc_task *task)
 	case 0:
 		return 1;
 	case -NFS4ERR_NOMATCHING_LAYOUT:
+		trace_layout_recall_done(&ls->ls_stid.sc_stateid);
 		task->tk_status = 0;
 		return 1;
 	case -NFS4ERR_DELAY:
@@ -623,6 +635,8 @@ nfsd4_cb_layout_release(struct nfsd4_callback *cb)
 		container_of(cb, struct nfs4_layout_stateid, ls_recall);
 	LIST_HEAD(reaplist);
 
+	trace_layout_recall_release(&ls->ls_stid.sc_stateid);
+
 	nfsd4_return_all_layouts(ls, &reaplist);
 	nfsd4_free_layouts(&reaplist);
 	nfs4_put_stid(&ls->ls_stid);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c051d5b..28e3927 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -44,6 +44,7 @@
 #include "netns.h"
 #include "acl.h"
 #include "pnfs.h"
+#include "trace.h"
 
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #include <linux/security.h>
@@ -1298,8 +1299,10 @@ nfsd4_layoutget(struct svc_rqst *rqstp,
 
 	nfserr = nfsd4_preprocess_layout_stateid(rqstp, cstate, &lgp->lg_sid,
 						true, lgp->lg_layout_type, &ls);
-	if (nfserr)
+	if (nfserr) {
+		trace_layout_get_lookup_fail(&lgp->lg_sid);
 		goto out;
+	}
 
 	nfserr = nfserr_recallconflict;
 	if (atomic_read(&ls->ls_stid.sc_file->fi_lo_recalls))
@@ -1359,6 +1362,7 @@ nfsd4_layoutcommit(struct svc_rqst *rqstp,
 						false, lcp->lc_layout_type,
 						&ls);
 	if (nfserr) {
+		trace_layout_commit_lookup_fail(&lcp->lc_sid);
 		/* fixup error code as per RFC5661 */
 		if (nfserr == nfserr_bad_stateid)
 			nfserr = nfserr_badlayout;
diff --git a/fs/nfsd/trace.c b/fs/nfsd/trace.c
new file mode 100644
index 0000000..82f8907
--- /dev/null
+++ b/fs/nfsd/trace.c
@@ -0,0 +1,5 @@
+
+#include "state.h"
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
new file mode 100644
index 0000000..c668520
--- /dev/null
+++ b/fs/nfsd/trace.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nfsd
+
+#if !defined(_NFSD_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _NFSD_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(nfsd_stateid_class,
+	TP_PROTO(stateid_t *stp),
+	TP_ARGS(stp),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, si_id)
+		__field(u32, si_generation)
+	),
+	TP_fast_assign(
+		__entry->cl_boot = stp->si_opaque.so_clid.cl_boot;
+		__entry->cl_id = stp->si_opaque.so_clid.cl_id;
+		__entry->si_id = stp->si_opaque.so_id;
+		__entry->si_generation = stp->si_generation;
+	),
+	TP_printk("client %08x:%08x stateid %08x:%08x",
+		__entry->cl_boot,
+		__entry->cl_id,
+		__entry->si_id,
+		__entry->si_generation)
+)
+
+#define DEFINE_STATEID_EVENT(name) \
+DEFINE_EVENT(nfsd_stateid_class, name, \
+	TP_PROTO(stateid_t *stp), \
+	TP_ARGS(stp))
+DEFINE_STATEID_EVENT(layoutstate_alloc);
+DEFINE_STATEID_EVENT(layoutstate_unhash);
+DEFINE_STATEID_EVENT(layoutstate_free);
+DEFINE_STATEID_EVENT(layout_get_lookup_fail);
+DEFINE_STATEID_EVENT(layout_commit_lookup_fail);
+DEFINE_STATEID_EVENT(layout_return_lookup_fail);
+DEFINE_STATEID_EVENT(layout_recall);
+DEFINE_STATEID_EVENT(layout_recall_done);
+DEFINE_STATEID_EVENT(layout_recall_fail);
+DEFINE_STATEID_EVENT(layout_recall_release);
+
+#endif /* _NFSD_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
