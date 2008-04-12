Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 19:56:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3C2uE65028921
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:56:17 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A32F2241A
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:56:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PirEHZ6fQ68GH0IK for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:56:45 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 5166618019ABE
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 21:56:13 -0500 (CDT)
Message-ID: <480024CC.8040407@sandeen.net>
Date: Fri, 11 Apr 2008 21:56:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] de-duplicate calls to xfs_attr_trace_enter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Every call to xfs_attr_trace_enter() shares the exact 
same 16 args in the middle... just send in the context
pointer and let the next level down split it into the
ktrace.

Compile tested only.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 xfs_attr.c    |  106 +++++++++++++---------------------------------------------
 xfs_attr_sf.h |   10 +----
 2 files changed, 28 insertions(+), 88 deletions(-)


Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c
@@ -2286,23 +2286,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 void
 xfs_attr_trace_l_c(char *where, struct xfs_attr_list_context *context)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_C, where,
-		(__psunsigned_t)context->dp,
-		(__psunsigned_t)context->cursor->hashval,
-		(__psunsigned_t)context->cursor->blkno,
-		(__psunsigned_t)context->cursor->offset,
-		(__psunsigned_t)context->alist,
-		(__psunsigned_t)context->bufsize,
-		(__psunsigned_t)context->count,
-		(__psunsigned_t)context->firstu,
-		(__psunsigned_t)
-			((context->count > 0) &&
-			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
-				? (ATTR_ENTRY(context->alist,
-					      context->count-1)->a_valuelen)
-				: 0,
-		(__psunsigned_t)context->dupcnt,
-		(__psunsigned_t)context->flags,
+	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_C, where, context,
 		(__psunsigned_t)NULL,
 		(__psunsigned_t)NULL,
 		(__psunsigned_t)NULL);
@@ -2315,23 +2299,7 @@ void
 xfs_attr_trace_l_cn(char *where, struct xfs_attr_list_context *context,
 			 struct xfs_da_intnode *node)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CN, where,
-		(__psunsigned_t)context->dp,
-		(__psunsigned_t)context->cursor->hashval,
-		(__psunsigned_t)context->cursor->blkno,
-		(__psunsigned_t)context->cursor->offset,
-		(__psunsigned_t)context->alist,
-		(__psunsigned_t)context->bufsize,
-		(__psunsigned_t)context->count,
-		(__psunsigned_t)context->firstu,
-		(__psunsigned_t)
-			((context->count > 0) &&
-			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
-				? (ATTR_ENTRY(context->alist,
-					      context->count-1)->a_valuelen)
-				: 0,
-		(__psunsigned_t)context->dupcnt,
-		(__psunsigned_t)context->flags,
+	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CN, where, context,
 		(__psunsigned_t)be16_to_cpu(node->hdr.count),
 		(__psunsigned_t)be32_to_cpu(node->btree[0].hashval),
 		(__psunsigned_t)be32_to_cpu(node->btree[
@@ -2345,23 +2313,7 @@ void
 xfs_attr_trace_l_cb(char *where, struct xfs_attr_list_context *context,
 			  struct xfs_da_node_entry *btree)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CB, where,
-		(__psunsigned_t)context->dp,
-		(__psunsigned_t)context->cursor->hashval,
-		(__psunsigned_t)context->cursor->blkno,
-		(__psunsigned_t)context->cursor->offset,
-		(__psunsigned_t)context->alist,
-		(__psunsigned_t)context->bufsize,
-		(__psunsigned_t)context->count,
-		(__psunsigned_t)context->firstu,
-		(__psunsigned_t)
-			((context->count > 0) &&
-			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
-				? (ATTR_ENTRY(context->alist,
-					      context->count-1)->a_valuelen)
-				: 0,
-		(__psunsigned_t)context->dupcnt,
-		(__psunsigned_t)context->flags,
+	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CB, where, context,
 		(__psunsigned_t)be32_to_cpu(btree->hashval),
 		(__psunsigned_t)be32_to_cpu(btree->before),
 		(__psunsigned_t)NULL);
@@ -2374,23 +2326,7 @@ void
 xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
 			      struct xfs_attr_leafblock *leaf)
 {
-	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CL, where,
-		(__psunsigned_t)context->dp,
-		(__psunsigned_t)context->cursor->hashval,
-		(__psunsigned_t)context->cursor->blkno,
-		(__psunsigned_t)context->cursor->offset,
-		(__psunsigned_t)context->alist,
-		(__psunsigned_t)context->bufsize,
-		(__psunsigned_t)context->count,
-		(__psunsigned_t)context->firstu,
-		(__psunsigned_t)
-			((context->count > 0) &&
-			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
-				? (ATTR_ENTRY(context->alist,
-					      context->count-1)->a_valuelen)
-				: 0,
-		(__psunsigned_t)context->dupcnt,
-		(__psunsigned_t)context->flags,
+	xfs_attr_trace_enter(XFS_ATTR_KTRACE_L_CL, where, context,
 		(__psunsigned_t)be16_to_cpu(leaf->hdr.count),
 		(__psunsigned_t)be32_to_cpu(leaf->entries[0].hashval),
 		(__psunsigned_t)be32_to_cpu(leaf->entries[
@@ -2403,22 +2339,30 @@ xfs_attr_trace_l_cl(char *where, struct 
  */
 void
 xfs_attr_trace_enter(int type, char *where,
-			 __psunsigned_t a2, __psunsigned_t a3,
-			 __psunsigned_t a4, __psunsigned_t a5,
-			 __psunsigned_t a6, __psunsigned_t a7,
-			 __psunsigned_t a8, __psunsigned_t a9,
-			 __psunsigned_t a10, __psunsigned_t a11,
-			 __psunsigned_t a12, __psunsigned_t a13,
-			 __psunsigned_t a14, __psunsigned_t a15)
+			 struct xfs_attr_list_context *context,
+			 __psunsigned_t a13, __psunsigned_t a14,
+			 __psunsigned_t a15)
 {
 	ASSERT(xfs_attr_trace_buf);
 	ktrace_enter(xfs_attr_trace_buf, (void *)((__psunsigned_t)type),
-					 (void *)where,
-					 (void *)a2,  (void *)a3,  (void *)a4,
-					 (void *)a5,  (void *)a6,  (void *)a7,
-					 (void *)a8,  (void *)a9,  (void *)a10,
-					 (void *)a11, (void *)a12, (void *)a13,
-					 (void *)a14, (void *)a15);
+		(void *)((__psunsigned_t)where),
+		(void *)((__psunsigned_t)context->dp),
+		(void *)((__psunsigned_t)context->cursor->hashval),
+		(void *)((__psunsigned_t)context->cursor->blkno),
+		(void *)((__psunsigned_t)context->cursor->offset),
+		(void *)((__psunsigned_t)context->alist),
+		(void *)((__psunsigned_t)context->bufsize),
+		(void *)((__psunsigned_t)context->count),
+		(void *)((__psunsigned_t)context->firstu),
+		(void *)((__psunsigned_t)
+			(((context->count > 0) &&
+			!(context->flags & (ATTR_KERNAMELS|ATTR_KERNOVAL)))
+				? (ATTR_ENTRY(context->alist,
+					      context->count-1)->a_valuelen)
+				: 0)),
+		(void *)((__psunsigned_t)context->dupcnt),
+		(void *)((__psunsigned_t)context->flags),
+		(void *)a13, (void *)a14, (void *)a15);
 }
 #endif	/* XFS_ATTR_TRACE */
 
Index: linux-2.6-xfs/fs/xfs/xfs_attr_sf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_sf.h
+++ linux-2.6-xfs/fs/xfs/xfs_attr_sf.h
@@ -97,13 +97,9 @@ void xfs_attr_trace_l_cb(char *where, st
 void xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
 			      struct xfs_attr_leafblock *leaf);
 void xfs_attr_trace_enter(int type, char *where,
-			     __psunsigned_t a2, __psunsigned_t a3,
-			     __psunsigned_t a4, __psunsigned_t a5,
-			     __psunsigned_t a6, __psunsigned_t a7,
-			     __psunsigned_t a8, __psunsigned_t a9,
-			     __psunsigned_t a10, __psunsigned_t a11,
-			     __psunsigned_t a12, __psunsigned_t a13,
-			     __psunsigned_t a14, __psunsigned_t a15);
+			     struct xfs_attr_list_context *context,
+			     __psunsigned_t a13, __psunsigned_t a14,
+			     __psunsigned_t a15);
 #else
 #define	xfs_attr_trace_l_c(w,c)
 #define	xfs_attr_trace_l_cn(w,c,n)
