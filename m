Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdAQEjn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:39:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B78FBACE4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 04:39:41 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 3/3] xfs_repair: fix thread creation failure recovery
Date: Mon, 16 Jan 2017 23:39:33 -0500
Message-Id: <1484627973-11535-4-git-send-email-jeffm@suse.com>
In-Reply-To: <1484627973-11535-1-git-send-email-jeffm@suse.com>
References: <1484627973-11535-1-git-send-email-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

When pf_create_prefetch_thread fails, it tears down the args struct
and frees it.  This causes a use-after-free in prefetch_ag_range, which
then passes the now-invalid pointer to start_inode_prefetch.  The struct
is only freed when the queuing thread can't be started.  When we can't
start even one worker thread, we mark the args ready for processing and
allow it to proceed single-threaded.  Unfortunately, this only marks
the current args ready for processing and since we return immediately,
the call to pf_create_prefetch_thread at the end of pf_queuing_worker
never gets called and we wait forever for prefetch to start on the
next AG.

This patch factors out the cleanup into a new pf_skip_prefetch_thread
that is called when we fail to create either the queuing thread or
the first of the workers.  It marks the args ready for processing, marks
it done so start_inode_prefetch doesn't add another AG to the list, and
tries to start a new thread for the next AG in the list.  We also clear
->next_args and check for it in cleanup_inode_prefetch so this condition
is easier to catch should it arise again.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 repair/prefetch.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 37d60d6..4c74b6e 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -679,11 +679,32 @@ static int
 pf_create_prefetch_thread(
 	prefetch_args_t		*args);
 
+/*
+ * If we fail to create the queuing thread or can't create even one
+ * prefetch thread, we need to let processing continue without it.
+ */
+static void
+pf_skip_prefetch_thread(prefetch_args_t *args)
+{
+	prefetch_args_t *next;
+
+	pthread_mutex_lock(&args->lock);
+	args->prefetch_done = 1;
+	pf_start_processing(args);
+	next = args->next_args;
+	args->next_args = NULL;
+	pthread_mutex_unlock(&args->lock);
+
+	if (next)
+		pf_create_prefetch_thread(next);
+}
+
 static void *
 pf_queuing_worker(
 	void			*param)
 {
 	prefetch_args_t		*args = param;
+	prefetch_args_t		*next_args;
 	int			num_inos;
 	ino_tree_node_t		*irec;
 	ino_tree_node_t		*cur_irec;
@@ -707,7 +728,7 @@ pf_queuing_worker(
 				args->agno, strerror(err));
 			args->io_threads[i] = 0;
 			if (i == 0) {
-				pf_start_processing(args);
+				pf_skip_prefetch_thread(args);
 				return NULL;
 			}
 			/*
@@ -798,11 +819,13 @@ pf_queuing_worker(
 	ASSERT(btree_is_empty(args->io_queue));
 
 	args->prefetch_done = 1;
-	if (args->next_args)
-		pf_create_prefetch_thread(args->next_args);
-
+	next_args = args->next_args;
+	args->next_args = NULL;
 	pthread_mutex_unlock(&args->lock);
 
+	if (next_args)
+		pf_create_prefetch_thread(next_args);
+
 	return NULL;
 }
 
@@ -822,7 +845,7 @@ pf_create_prefetch_thread(
 		pftrace("failed to create prefetch thread for AG %d: %s",
 			args->agno, strerror(err));
 		args->queuing_thread = 0;
-		cleanup_inode_prefetch(args);
+		pf_skip_prefetch_thread(args);
 	}
 
 	return err == 0;
@@ -884,14 +907,15 @@ start_inode_prefetch(
 	} else {
 		pthread_mutex_lock(&prev_args->lock);
 		if (prev_args->prefetch_done) {
+			pthread_mutex_unlock(&prev_args->lock);
 			if (!pf_create_prefetch_thread(args))
 				args = NULL;
 		} else {
 			prev_args->next_args = args;
 			pftrace("queued AG %d after AG %d",
 				args->agno, prev_args->agno);
+			pthread_mutex_unlock(&prev_args->lock);
 		}
-		pthread_mutex_unlock(&prev_args->lock);
 	}
 
 	return args;
@@ -1066,6 +1090,8 @@ cleanup_inode_prefetch(
 
 	pftrace("AG %d prefetch done", args->agno);
 
+	ASSERT(args->next_args == NULL);
+
 	pthread_mutex_destroy(&args->lock);
 	pthread_cond_destroy(&args->start_reading);
 	pthread_cond_destroy(&args->start_processing);
-- 
2.7.1

