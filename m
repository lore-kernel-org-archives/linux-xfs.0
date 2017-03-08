Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14588 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750783AbdCHKdB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 05:33:01 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/5] fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
Date: Wed,  8 Mar 2017 10:53:37 +0200
Message-Id: <1488963219-11709-4-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/xfs/xfs_log.c      | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b1469f0..c127fa0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3500,8 +3500,8 @@ void
 xfs_log_ticket_put(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	if (atomic_dec_and_test(&ticket->t_ref))
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	if (refcount_dec_and_test(&ticket->t_ref))
 		kmem_zone_free(xfs_log_ticket_zone, ticket);
 }
 
@@ -3509,8 +3509,8 @@ xlog_ticket_t *
 xfs_log_ticket_get(
 	xlog_ticket_t	*ticket)
 {
-	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	atomic_inc(&ticket->t_ref);
+	ASSERT(refcount_read(&ticket->t_ref) > 0);
+	refcount_inc(&ticket->t_ref);
 	return ticket;
 }
 
@@ -3632,7 +3632,7 @@ xlog_ticket_alloc(
 
 	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
 
-	atomic_set(&tic->t_ref, 1);
+	refcount_set(&tic->t_ref, 1);
 	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_res;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c2604a5..3fc4aba 100644
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

