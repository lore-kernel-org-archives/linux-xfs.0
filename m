Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6155 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdCAKDq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 05:03:46 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH] fs, ncpfs: convert ncp_request_reply.refs from atomic_t to refcount_t
Date: Wed,  1 Mar 2017 11:58:04 +0200
Message-Id: <1488362284-3385-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, petr@vandrovec.name, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

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
 fs/ncpfs/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index 4bfeae2..c9d5012 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -28,6 +28,7 @@
 #include <linux/ipx.h>
 #include <linux/poll.h>
 #include <linux/file.h>
+#include <linux/refcount.h>
 
 #include "ncp_fs.h"
 
@@ -51,7 +52,7 @@ static int _send(struct socket *sock, const void *buff, int len)
 struct ncp_request_reply {
 	struct list_head req;
 	wait_queue_head_t wq;
-	atomic_t refs;
+	refcount_t refs;
 	unsigned char* reply_buf;
 	size_t datalen;
 	int result;
@@ -71,7 +72,7 @@ static inline struct ncp_request_reply* ncp_alloc_req(void)
 		return NULL;
 
 	init_waitqueue_head(&req->wq);
-	atomic_set(&req->refs, (1));
+	refcount_set(&req->refs, (1));
 	req->status = RQ_IDLE;
 
 	return req;
@@ -79,12 +80,12 @@ static inline struct ncp_request_reply* ncp_alloc_req(void)
 
 static void ncp_req_get(struct ncp_request_reply *req)
 {
-	atomic_inc(&req->refs);
+	refcount_inc(&req->refs);
 }
 
 static void ncp_req_put(struct ncp_request_reply *req)
 {
-	if (atomic_dec_and_test(&req->refs))
+	if (refcount_dec_and_test(&req->refs))
 		kfree(req);
 }
 
-- 
2.7.4

