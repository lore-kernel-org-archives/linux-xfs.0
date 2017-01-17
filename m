Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36271 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbdAQEjm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:39:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DFFA6AC88
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 04:39:40 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 2/3] xfs_repair: add prefetch trace calls to debug thread creation failures
Date: Mon, 16 Jan 2017 23:39:32 -0500
Message-Id: <1484627973-11535-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1484627973-11535-1-git-send-email-jeffm@suse.com>
References: <1484627973-11535-1-git-send-email-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

When debugging prefetch failures, it's useful to have thread creation
failure messages that are output as warnings on stderr in the trace
log as well.  It's also helpful to see when an AG gets queued behind
another one rather than having the thread started directly, which
has a separate trace line.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 repair/prefetch.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 044fab2..37d60d6 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -703,6 +703,8 @@ pf_queuing_worker(
 		if (err != 0) {
 			do_warn(_("failed to create prefetch thread: %s\n"),
 				strerror(err));
+			pftrace("failed to create prefetch thread for AG %d: %s",
+				args->agno, strerror(err));
 			args->io_threads[i] = 0;
 			if (i == 0) {
 				pf_start_processing(args);
@@ -817,6 +819,8 @@ pf_create_prefetch_thread(
 	if (err != 0) {
 		do_warn(_("failed to create prefetch thread: %s\n"),
 			strerror(err));
+		pftrace("failed to create prefetch thread for AG %d: %s",
+			args->agno, strerror(err));
 		args->queuing_thread = 0;
 		cleanup_inode_prefetch(args);
 	}
@@ -882,8 +886,11 @@ start_inode_prefetch(
 		if (prev_args->prefetch_done) {
 			if (!pf_create_prefetch_thread(args))
 				args = NULL;
-		} else
+		} else {
 			prev_args->next_args = args;
+			pftrace("queued AG %d after AG %d",
+				args->agno, prev_args->agno);
+		}
 		pthread_mutex_unlock(&prev_args->lock);
 	}
 
-- 
2.7.1

