Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdAQEjl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:39:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D616ABDF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 04:39:40 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 1/3] xfs_repair: clear pthread_t when pthread_create fails
Date: Mon, 16 Jan 2017 23:39:31 -0500
Message-Id: <1484627973-11535-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1484627973-11535-1-git-send-email-jeffm@suse.com>
References: <1484627973-11535-1-git-send-email-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

pf_queuing_worker and pf_create_prefetch_thread both try to handle
thread creation failure gracefully, but assume that pthread_create
doesn't modify the pthread_t when it fails.

>From the pthread_create man page:
On  success,  pthread_create() returns 0; on error, it returns an error
number, and the contents of *thread are undefined.

In fact, glibc's pthread_create writes the pthread_t value before
calling clone().  When we join the created threads in
cleanup_inode_prefetch and the cleanup stage of pf_queuing_worker, we
assume that if the pthread_t is nonzero that it's a valid thread handle
and end up crashing in pthread_join.

This patch zeros out the handle after pthread_create failure.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 repair/prefetch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index ff50606..044fab2 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -703,6 +703,7 @@ pf_queuing_worker(
 		if (err != 0) {
 			do_warn(_("failed to create prefetch thread: %s\n"),
 				strerror(err));
+			args->io_threads[i] = 0;
 			if (i == 0) {
 				pf_start_processing(args);
 				return NULL;
@@ -816,6 +817,7 @@ pf_create_prefetch_thread(
 	if (err != 0) {
 		do_warn(_("failed to create prefetch thread: %s\n"),
 			strerror(err));
+		args->queuing_thread = 0;
 		cleanup_inode_prefetch(args);
 	}
 
-- 
2.7.1

