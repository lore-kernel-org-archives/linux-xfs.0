Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932303AbeFGMlZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 08:41:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E12D873C2
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7203A2026DEF
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: define internal buf flag for delwri queue wait list
Date: Thu,  7 Jun 2018 08:41:24 -0400
Message-Id: <20180607124125.38700-2-bfoster@redhat.com>
In-Reply-To: <20180607124125.38700-1-bfoster@redhat.com>
References: <20180607124125.38700-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The delwri queue mechanism does not provide the ability to
distinguish between stale (or lazily removed) buffers in a delwri
queue and buffers that have been submitted from a delwri queue and
sit on a wait list. Buffers in both cases have the _XBF_DELWRI_Q
flag cleared and ->b_list as a member of an associated list. This
means that a queue of a buffer cannot always tell if a buffer is
actually on a delwri queue if ->b_list is non-empty and
_XBF_DELWRI_Q is not already set.

Define a new flag for wait listed buffers to distinguish this case
and prepare to handle it properly. This patch defines, sets and
clears the _XBF_DELWRI_W flag at the appropriate places and
otherwise does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 5 +++--
 fs/xfs/xfs_buf.h | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 980bc48979e9..912cbbf44db7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2033,6 +2033,7 @@ xfs_buf_delwri_submit_buffers(
 		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
 		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
 		if (wait_list) {
+			bp->b_flags |= _XBF_DELWRI_W;
 			xfs_buf_hold(bp);
 			list_move_tail(&bp->b_list, wait_list);
 		} else
@@ -2083,10 +2084,10 @@ xfs_buf_delwri_submit(
 	while (!list_empty(&wait_list)) {
 		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
-		list_del_init(&bp->b_list);
-
 		/* locking the buffer will wait for async IO completion. */
 		xfs_buf_lock(bp);
+		bp->b_flags &= ~_XBF_DELWRI_W;
+		list_del_init(&bp->b_list);
 		error2 = bp->b_error;
 		xfs_buf_relse(bp);
 		if (!error)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d24dbd4dac39..07409b72dcad 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -50,7 +50,8 @@ typedef enum {
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
+#define _XBF_DELWRI_W	 (1 << 23)/* buffer on a delwri wait list */
+#define _XBF_COMPOUND	 (1 << 24)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -71,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_DELWRI_W,	"DELWRI_W" }, \
 	{ _XBF_COMPOUND,	"COMPOUND" }
 
 
-- 
2.17.1

