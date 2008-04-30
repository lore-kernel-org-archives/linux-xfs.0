Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 23:59:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3U6x3xh007231
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 23:59:09 -0700
Date: Wed, 30 Apr 2008 16:59:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Fix non-debug build for xfsidbg.c
Message-ID: <20080430065937.GC108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Make the use of l_iclog_bak conditional on debug configs.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfsidbg.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-04-30 16:47:06.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-04-30 16:49:33.615164895 +1000
@@ -5845,9 +5845,14 @@ xfsidbg_xlog(xlog_t *log)
 	kdb_printf("curr_cycle: %d  prev_cycle: %d  curr_block: %d  prev_block: %d\n",
 	     log->l_curr_cycle, log->l_prev_cycle, log->l_curr_block,
 	     log->l_prev_block);
+#ifdef DEBUG
 	kdb_printf("iclog_bak: 0x%p  iclog_size: 0x%x (%d)  num iclogs: %d\n",
 		log->l_iclog_bak, log->l_iclog_size, log->l_iclog_size,
 		log->l_iclog_bufs);
+#else
+	kdb_printf("iclog_size: 0x%x (%d)  num iclogs: %d\n",
+		log->l_iclog_size, log->l_iclog_size, log->l_iclog_bufs);
+#endif
 	kdb_printf("l_iclog_hsize %d l_iclog_heads %d\n",
 		log->l_iclog_hsize, log->l_iclog_heads);
 	kdb_printf("l_sectbb_log %u l_sectbb_mask %u\n",
