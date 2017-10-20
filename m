Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753075AbdJTLQC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:16:02 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/5] fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 14:07:56 +0300
Message-Id: <1508497678-10508-4-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable xlog_ticket.t_ref is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/xfs/xfs_log.c      | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dc95a49..e4578c0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3571,8 +3571,8 @@ void
 xfs_log_ticket_put(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	if (atomic_dec_and_test(&ticket->t_ref))
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	if (refcount_dec_and_test(&ticket->t_ref))
 		kmem_zone_free(xfs_log_ticket_zone, ticket);
 }
 
@@ -3580,8 +3580,8 @@ xlog_ticket_t *
 xfs_log_ticket_get(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	atomic_inc(&ticket->t_ref);
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	refcount_inc(&ticket->t_ref);
 	return ticket;
 }
 
@@ -3703,7 +3703,7 @@ xlog_ticket_alloc(
 
 	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
 
-	atomic_set(&tic->t_ref, 1);
+	refcount_set(&tic->t_ref, 1);
 	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_res;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 51bf7b8..29f6e1f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -168,7 +168,7 @@ typedef struct xlog_ticket {
 	struct list_head   t_queue;	 /* reserve/write queue */
 	struct task_struct *t_task;	 /* task that owns this ticket */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
-	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
+	refcount_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
-- 
2.7.4

