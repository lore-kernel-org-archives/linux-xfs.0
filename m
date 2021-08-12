Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CECC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94878601FD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhHLA7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233141AbhHLA7a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D3B60FE6;
        Thu, 12 Aug 2021 00:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729946;
        bh=Fx6B9y9rUdFzkb9RgI/twYjs6X+U71F6fJFdey5YjL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dR9JiP4WnUP8Tn3GfCLimf4sBdpL3Tfb/nxO/j+QdFV+FA8JsexYib2lbTWLrNqOU
         wSytVEFOSpNMDn8wCN9jXs9ueUjTCmpbz2vcnepb6zQWxcmCz/lEX52YZZgxamuhrO
         Jqrxw/tcYkY5XmaSXH6+aFzkybuXoUC/2yqtpQZnvPt8fK5e1QaqxQJlLINnymPAMl
         YL01e5l7s0F6P+tw3AdiSpeC5K1xmMws3w4APVTyoSwuGx+31F0fdx6cOruDRe5lBp
         GPXRX55UMhYKuGQDlTpwXNTjX5cpQs4Z1lglQDxvJ1vFkg9wll9Pz+RUoBVtmIdT/K
         /R2EgMoGHjIsA==
Subject: [PATCH 2/2] xfs: add trace point for fs shutdown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:59:06 -0700
Message-ID: <162872994625.1220748.12679533833955140333.stgit@magnolia>
In-Reply-To: <162872993519.1220748.15526308019664551101.stgit@magnolia>
References: <162872993519.1220748.15526308019664551101.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a tracepoint for fs shutdowns so we can capture that in ftrace
output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_error.h |   12 ++++++++++++
 fs/xfs/xfs_fsops.c |    3 +++
 fs/xfs/xfs_mount.h |    6 ++++++
 fs/xfs/xfs_trace.c |    1 +
 fs/xfs/xfs_trace.h |   27 +++++++++++++++++++++++++++
 5 files changed, 49 insertions(+)


diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 1717b7508356..5735d5ea87ee 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -75,4 +75,16 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
 #define		XFS_PTAG_VERIFIER_ERROR		0x00000100
 
+#define XFS_PTAG_STRINGS \
+	{ XFS_NO_PTAG,			"none" }, \
+	{ XFS_PTAG_IFLUSH,		"iflush" }, \
+	{ XFS_PTAG_LOGRES,		"logres" }, \
+	{ XFS_PTAG_AILDELETE,		"aildelete" }, \
+	{ XFS_PTAG_ERROR_REPORT	,	"error_report" }, \
+	{ XFS_PTAG_SHUTDOWN_CORRUPT,	"corrupt" }, \
+	{ XFS_PTAG_SHUTDOWN_IOERROR,	"ioerror" }, \
+	{ XFS_PTAG_SHUTDOWN_LOGERROR,	"logerror" }, \
+	{ XFS_PTAG_FSBLOCK_ZERO,	"fsb_zero" }, \
+	{ XFS_PTAG_VERIFIER_ERROR,	"verifier" }
+
 #endif	/* __XFS_ERROR_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7a2f4feacc35..0ef0aad7ddc9 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_trace.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -551,6 +552,8 @@ xfs_do_force_shutdown(
 		why = "Metadata I/O Error";
 	}
 
+	trace_xfs_force_shutdown(mp, tag, flags, fname, lnnum);
+
 	xfs_alert_tag(mp, tag,
 "%s (0x%x) detected at %pS (%s:%d).  Shutting down filesystem.",
 			why, flags, __return_address, fname, lnnum);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2266c6a668cf..57f2ea398832 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -331,6 +331,12 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
 #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
 
+#define XFS_SHUTDOWN_STRINGS \
+	{ SHUTDOWN_META_IO_ERROR,	"metadata_io" }, \
+	{ SHUTDOWN_LOG_IO_ERROR,	"log_io" }, \
+	{ SHUTDOWN_FORCE_UMOUNT,	"force_umount" }, \
+	{ SHUTDOWN_CORRUPT_INCORE,	"corruption" }
+
 /*
  * Flags for xfs_mountfs
  */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 4c86afad1617..d269ef57ff01 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -33,6 +33,7 @@
 #include "xfs_icache.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_error.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 70c142f6aeb2..84199e29845d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4096,6 +4096,33 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
+
+TRACE_EVENT(xfs_force_shutdown,
+	TP_PROTO(struct xfs_mount *mp, int ptag, int flags, const char *fname,
+		 int line_num),
+	TP_ARGS(mp, ptag, flags, fname, line_num),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, ptag)
+		__field(int, flags)
+		__string(fname, fname)
+		__field(int, line_num)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ptag = ptag;
+		__entry->flags = flags;
+		__assign_str(fname, fname);
+		__entry->line_num = line_num;
+	),
+	TP_printk("dev %d:%d tag %s flags %s file %s line_num %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		__print_flags(__entry->ptag, "|", XFS_PTAG_STRINGS),
+		__print_flags(__entry->flags, "|", XFS_SHUTDOWN_STRINGS),
+		__get_str(fname),
+		__entry->line_num)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

