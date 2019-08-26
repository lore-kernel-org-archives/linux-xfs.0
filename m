Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D9FC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D522186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MbyAODab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfHZVcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbfHZVcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLElSs161898;
        Mon, 26 Aug 2019 21:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=01P+uYa7qTluvpzK1A421h86QagJI+Jtv33c8rv6Gys=;
 b=MbyAODabK2Y3fLAeejI8QZeCBkn7XgwB+8Vkrgy34GdgCKMBjDuWW4lHt9oAUVil5daz
 Vg8gU04jhS8HEryzG/PhvPZTaR+Kl2J6oydsvpkllerirR5XfYkjZybJWD5cl/fse9PR
 HPqTMzwA9+cvyVHBT4+I4Ys0pG5DSqlDhqaRG7nATTDP7oaOViO+MQnrxOR1AJfiSk7q
 Xc96762bYXwyAt0cA1IsYEO5ctDN5wCv+PNsMsyXswVka608tN9yul4Zvs81909pdJey
 Yt/4ZRgI7omcRg9CawjSybWc0e2gvKYfxLYHHnUQAL4+nfDCDhzEIxGW9JGk1uIARn6r yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t82jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIKi2170003;
        Mon, 26 Aug 2019 21:32:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2umj278b91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLWg2J031135;
        Mon, 26 Aug 2019 21:32:42 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:32:41 -0700
Subject: [PATCH 2/3] xfs_scrub: implement deferred description string
 rendering
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:33 -0700
Message-ID: <156685515347.2843450.12844192480104385890.stgit@magnolia>
In-Reply-To: <156685514116.2843450.13345990837227741560.stgit@magnolia>
References: <156685514116.2843450.13345990837227741560.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A flamegraph analysis of xfs_scrub runtimes showed that we spend 7-10%
of the program's userspace runtime rendering prefix strings in case we
want to show a message about something we're checking, whether or not
that string ever actually gets used.

For a non-verbose run on a clean filesystem, this work is totally
unnecessary.  We could defer the message catalog lookup and snprintf
call until we actually need that message, so build enough of a function
closure mechanism so that we can capture some location information when
its convenient and push that all the way to the edge of the call graph
and only when we need it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    2 +
 scrub/descr.c     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/descr.h     |   29 ++++++++++++++
 scrub/scrub.c     |   75 +++++++++++++++++++++----------------
 scrub/xfs_scrub.c |    8 ++++
 5 files changed, 188 insertions(+), 33 deletions(-)
 create mode 100644 scrub/descr.c
 create mode 100644 scrub/descr.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 882da8fd..47c887eb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -34,6 +34,7 @@ endif	# scrub_prereqs
 HFILES = \
 common.h \
 counter.h \
+descr.h \
 disk.h \
 filemap.h \
 fscounters.h \
@@ -50,6 +51,7 @@ xfs_scrub.h
 CFILES = \
 common.c \
 counter.c \
+descr.c \
 disk.c \
 filemap.c \
 fscounters.c \
diff --git a/scrub/descr.c b/scrub/descr.c
new file mode 100644
index 00000000..eedb57d6
--- /dev/null
+++ b/scrub/descr.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-or-newer
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include <assert.h>
+#include <sys/statvfs.h>
+#include "platform_defs.h"
+#include "input.h"
+#include "path.h"
+#include "xfs_scrub.h"
+#include "ptvar.h"
+#include "common.h"
+#include "descr.h"
+
+/*
+ * Deferred String Description Renderer
+ * ====================================
+ * There are many places in xfs_scrub where some event occurred and we'd like
+ * to be able to print some sort of message describing what happened, and
+ * where.  However, we don't know whether we're going to need the description
+ * of where ahead of time and there's little point in spending any time looking
+ * up gettext strings and formatting buffers until we actually need to.
+ *
+ * This code provides enough of a function closure that we are able to record
+ * some information about the program status but defer rendering the textual
+ * description until we know that we need it.  Once we've rendered the string
+ * we can skip it for subsequent calls.  We use per-thread storage for the
+ * message buffer to amortize the memory allocation across calls.
+ *
+ * On a clean filesystem this can reduce the xfs_scrub runtime by 7-10% by
+ * avoiding unnecessary work.
+ */
+
+static struct ptvar *descr_ptvar;
+
+/* Global buffer for when we aren't running in threaded mode. */
+static char global_dsc_buf[DESCR_BUFSZ];
+
+/*
+ * Render a textual description string using the function and location stored
+ * in the description context.
+ */
+const char *
+__descr_render(
+	struct descr		*dsc,
+	const char		*file,
+	int			line)
+{
+	char			*dsc_buf;
+	int			ret;
+
+	if (descr_ptvar) {
+		dsc_buf = ptvar_get(descr_ptvar, &ret);
+		if (ret)
+			return _("error finding description buffer");
+	} else
+		dsc_buf = global_dsc_buf;
+
+	ret = dsc->fn(dsc->ctx, dsc_buf, DESCR_BUFSZ, dsc->where);
+	if (ret < 0) {
+		snprintf(dsc_buf, DESCR_BUFSZ,
+_("error %d while rendering description at %s line %d\n"),
+				ret, file, line);
+	}
+
+	return dsc_buf;
+}
+
+/*
+ * Set a new location for this deferred-rendering string and discard any
+ * old rendering.
+ */
+void
+descr_set(
+	struct descr		*dsc,
+	void			*where)
+{
+	dsc->where = where;
+}
+
+/* Allocate all the description string buffers. */
+bool
+descr_init_phase(
+	struct scrub_ctx	*ctx,
+	unsigned int		nr_threads)
+{
+	int			ret;
+
+	assert(descr_ptvar == NULL);
+	ret = ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating description buffer"));
+		return false;
+	}
+	return true;
+}
+
+/* Free all the description string buffers. */
+void
+descr_end_phase(void)
+{
+	if (descr_ptvar)
+		ptvar_free(descr_ptvar);
+	descr_ptvar = NULL;
+}
diff --git a/scrub/descr.h b/scrub/descr.h
new file mode 100644
index 00000000..598e5888
--- /dev/null
+++ b/scrub/descr.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-newer */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef XFS_SCRUB_DESCR_H_
+#define XFS_SCRUB_DESCR_H_
+
+typedef int (*descr_fn)(struct scrub_ctx *ctx, char *buf, size_t buflen,
+			void *data);
+
+struct descr {
+	struct scrub_ctx	*ctx;
+	descr_fn		fn;
+	void			*where;
+};
+
+#define DEFINE_DESCR(_name, _ctx, _fn) \
+	struct descr _name = { .ctx = (_ctx), .fn = (_fn) }
+
+const char *__descr_render(struct descr *dsc, const char *file, int line);
+#define descr_render(dsc) __descr_render((dsc), __FILE__, __LINE__)
+
+void descr_set(struct descr *dsc, void *where);
+
+bool descr_init_phase(struct scrub_ctx *ctx, unsigned int nr_threads);
+void descr_end_phase(void);
+
+#endif /* XFS_SCRUB_DESCR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 82beb7ad..8c3ae2a6 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -18,6 +18,7 @@
 #include "scrub.h"
 #include "xfs_errortag.h"
 #include "repair.h"
+#include "descr.h"
 
 /* Online scrub and repair wrappers. */
 
@@ -90,33 +91,35 @@ static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
 };
 
 /* Format a scrub description. */
-static void
+static int
 format_scrub_descr(
 	struct scrub_ctx		*ctx,
 	char				*buf,
 	size_t				buflen,
-	struct xfs_scrub_metadata	*meta)
+	void				*where)
 {
+	struct xfs_scrub_metadata	*meta = where;
 	const struct scrub_descr	*sd = &scrubbers[meta->sm_type];
 
 	switch (sd->type) {
 	case ST_AGHEADER:
 	case ST_PERAG:
-		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
+		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
 				_(sd->name));
 		break;
 	case ST_INODE:
-		xfs_scrub_render_ino_suffix(ctx, buf, buflen,
+		return xfs_scrub_render_ino_suffix(ctx, buf, buflen,
 				meta->sm_ino, meta->sm_gen, " %s", _(sd->name));
 		break;
 	case ST_FS:
 	case ST_SUMMARY:
-		snprintf(buf, buflen, _("%s"), _(sd->name));
+		return snprintf(buf, buflen, _("%s"), _(sd->name));
 		break;
 	case ST_NONE:
 		assert(0);
 		break;
 	}
+	return -1;
 }
 
 /* Predicates for scrub flag state. */
@@ -161,21 +164,24 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 static inline void
 xfs_scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
+	struct descr			*dsc,
 	struct xfs_scrub_metadata	*meta)
 {
 	if (is_incomplete(meta))
-		str_info(ctx, descr, _("Check incomplete."));
+		str_info(ctx, descr_render(dsc), _("Check incomplete."));
 
 	if (is_suspicious(meta)) {
 		if (debug)
-			str_info(ctx, descr, _("Possibly suspect metadata."));
+			str_info(ctx, descr_render(dsc),
+					_("Possibly suspect metadata."));
 		else
-			str_warn(ctx, descr, _("Possibly suspect metadata."));
+			str_warn(ctx, descr_render(dsc),
+					_("Possibly suspect metadata."));
 	}
 
 	if (xref_failed(meta))
-		str_info(ctx, descr, _("Cross-referencing failed."));
+		str_info(ctx, descr_render(dsc),
+				_("Cross-referencing failed."));
 }
 
 /* Do a read-only check of some metadata. */
@@ -186,16 +192,16 @@ xfs_check_metadata(
 	struct xfs_scrub_metadata	*meta,
 	bool				is_inode)
 {
-	char				buf[DESCR_BUFSZ];
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	unsigned int			tries = 0;
 	int				code;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
+	descr_set(&dsc, meta);
 
-	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
+	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
 retry:
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
@@ -208,13 +214,13 @@ xfs_check_metadata(
 			return CHECK_DONE;
 		case ESHUTDOWN:
 			/* FS already crashed, give up. */
-			str_info(ctx, buf,
+			str_info(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case EIO:
 		case ENOMEM:
 			/* Abort on I/O errors or insufficient memory. */
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_ABORT;
 		case EDEADLOCK:
 		case EBUSY:
@@ -224,12 +230,12 @@ _("Filesystem is shut down, aborting."));
 			 * The first two should never escape the kernel,
 			 * and the other two should be reported via sm_flags.
 			 */
-			str_info(ctx, buf,
+			str_info(ctx, descr_render(&dsc),
 _("Kernel bug!  errno=%d"), code);
 			/* fall through */
 		default:
 			/* Operational error. */
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_DONE;
 		}
 	}
@@ -247,7 +253,7 @@ _("Kernel bug!  errno=%d"), code);
 	}
 
 	/* Complain about incomplete or suspicious metadata. */
-	xfs_scrub_warn_incomplete_scrub(ctx, buf, meta);
+	xfs_scrub_warn_incomplete_scrub(ctx, &dsc, meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
@@ -255,7 +261,7 @@ _("Kernel bug!  errno=%d"), code);
 	 */
 	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
-			str_error(ctx, buf,
+			str_error(ctx, descr_render(&dsc),
 _("Repairs are required."));
 			return CHECK_DONE;
 		}
@@ -271,7 +277,7 @@ _("Repairs are required."));
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			if (!is_inode) {
 				/* AG or FS metadata, always warn. */
-				str_info(ctx, buf,
+				str_info(ctx, descr_render(&dsc),
 _("Optimization is possible."));
 			} else if (!ctx->preen_triggers[meta->sm_type]) {
 				/* File metadata, only warn once per type. */
@@ -725,9 +731,9 @@ xfs_repair_metadata(
 	struct action_item		*aitem,
 	unsigned int			repair_flags)
 {
-	char				buf[DESCR_BUFSZ];
 	struct xfs_scrub_metadata	meta = { 0 };
 	struct xfs_scrub_metadata	oldm;
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	int				error;
 
 	assert(aitem->type < XFS_SCRUB_TYPE_NR);
@@ -751,12 +757,13 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
-	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
+	descr_set(&dsc, &oldm);
 
 	if (needs_repair(&meta))
-		str_info(ctx, buf, _("Attempting repair."));
+		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
 	else if (debug || verbose)
-		str_info(ctx, buf, _("Attempting optimization."));
+		str_info(ctx, descr_render(&dsc),
+				_("Attempting optimization."));
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error) {
@@ -765,12 +772,12 @@ xfs_repair_metadata(
 		case EBUSY:
 			/* Filesystem is busy, try again later. */
 			if (debug || verbose)
-				str_info(ctx, buf,
+				str_info(ctx, descr_render(&dsc),
 _("Filesystem is busy, deferring repair."));
 			return CHECK_RETRY;
 		case ESHUTDOWN:
 			/* Filesystem is already shut down, abort. */
-			str_info(ctx, buf,
+			str_info(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case ENOTTY:
@@ -795,13 +802,13 @@ _("Filesystem is shut down, aborting."));
 			/* fall through */
 		case EINVAL:
 			/* Kernel doesn't know how to repair this? */
-			str_error(ctx, buf,
+			str_error(ctx, descr_render(&dsc),
 _("Don't know how to fix; offline repair required."));
 			return CHECK_DONE;
 		case EROFS:
 			/* Read-only filesystem, can't fix. */
 			if (verbose || debug || needs_repair(&oldm))
-				str_info(ctx, buf,
+				str_info(ctx, descr_render(&dsc),
 _("Read-only filesystem; cannot make changes."));
 			return CHECK_DONE;
 		case ENOENT:
@@ -822,12 +829,12 @@ _("Read-only filesystem; cannot make changes."));
 			 */
 			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 				return CHECK_RETRY;
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_DONE;
 		}
 	}
 	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
-		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
+		xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
 	if (needs_repair(&meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
@@ -836,14 +843,16 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 			return CHECK_RETRY;
-		str_error(ctx, buf,
+		str_error(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (needs_repair(&oldm))
-			record_repair(ctx, buf, _("Repairs successful."));
+			record_repair(ctx, descr_render(&dsc),
+					_("Repairs successful."));
 		else
-			record_preen(ctx, buf, _("Optimization successful."));
+			record_preen(ctx, descr_render(&dsc),
+					_("Optimization successful."));
 	}
 	return CHECK_DONE;
 }
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 378f53b4..7749637e 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -15,6 +15,7 @@
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "descr.h"
 #include "unicrash.h"
 #include "progress.h"
 
@@ -467,8 +468,14 @@ run_scrub_phases(
 			work_threads++;
 			moveon = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
+			if (!moveon)
+				break;
+			moveon = descr_init_phase(ctx, work_threads);
 		} else {
 			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
+			if (!moveon)
+				break;
+			moveon = descr_init_phase(ctx, 1);
 		}
 		if (!moveon)
 			break;
@@ -480,6 +487,7 @@ _("Scrub aborted after phase %d."),
 			break;
 		}
 		progress_end_phase();
+		descr_end_phase();
 		moveon = phase_end(&pi, phase);
 		if (!moveon)
 			break;

