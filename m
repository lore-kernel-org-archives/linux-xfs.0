Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 07:46:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5REkctL025651
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 07:46:40 -0700
Received: from Liberator.local (unknown [205.233.52.213])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 61A5018011E86
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 09:46:39 -0500 (CDT)
Message-ID: <4682784C.1070607@sandeen.net>
Date: Wed, 27 Jun 2007 09:46:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] vn_hold return value is unused
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Came across this while looking at the last patch.  
*shrug* it's here if you want it :)

-------------

Make vn_hold a void function; return is never used.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux-clean/linux-2.4/xfs_vnode.c
===================================================================
--- xfs-linux-clean.orig/linux-2.4/xfs_vnode.c
+++ xfs-linux-clean/linux-2.4/xfs_vnode.c
@@ -133,7 +133,7 @@ vn_revalidate(
 /*
  * Add a reference to a referenced vnode.
  */
-bhv_vnode_t *
+void
 vn_hold(
 	bhv_vnode_t	*vp)
 {
@@ -145,8 +145,6 @@ vn_hold(
 	inode = igrab(vn_to_inode(vp));
 	ASSERT(inode);
 	VN_UNLOCK(vp, 0);
-
-	return vp;
 }
 
 #ifdef	XFS_VNODE_TRACE
Index: xfs-linux-clean/linux-2.4/xfs_vnode.h
===================================================================
--- xfs-linux-clean.orig/linux-2.4/xfs_vnode.h
+++ xfs-linux-clean/linux-2.4/xfs_vnode.h
@@ -435,17 +435,17 @@ static inline int vn_count(struct bhv_vn
 /*
  * Vnode reference counting functions (and macros for compatibility).
  */
-extern bhv_vnode_t *vn_hold(struct bhv_vnode *);
+extern void vn_hold(struct bhv_vnode *);
 
 #if defined(XFS_VNODE_TRACE)
 #define VN_HOLD(vp)		\
-	((void)vn_hold(vp),	\
+	(vn_hold(vp),	\
 	  vn_trace_hold(vp, __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
 	  (vn_trace_rele(vp, __FILE__, __LINE__, (inst_t *)__return_address), \
 	   iput(vn_to_inode(vp)))
 #else
-#define VN_HOLD(vp)		((void)vn_hold(vp))
+#define VN_HOLD(vp)		(vn_hold(vp))
 #define VN_RELE(vp)		(iput(vn_to_inode(vp)))
 #endif
 
Index: xfs-linux-clean/linux-2.6/xfs_vnode.c
===================================================================
--- xfs-linux-clean.orig/linux-2.6/xfs_vnode.c
+++ xfs-linux-clean/linux-2.6/xfs_vnode.c
@@ -172,7 +172,7 @@ vn_revalidate(
 /*
  * Add a reference to a referenced vnode.
  */
-bhv_vnode_t *
+void
 vn_hold(
 	bhv_vnode_t	*vp)
 {
@@ -184,8 +184,6 @@ vn_hold(
 	inode = igrab(vn_to_inode(vp));
 	ASSERT(inode);
 	VN_UNLOCK(vp, 0);
-
-	return vp;
 }
 
 #ifdef	XFS_VNODE_TRACE
Index: xfs-linux-clean/linux-2.6/xfs_vnode.h
===================================================================
--- xfs-linux-clean.orig/linux-2.6/xfs_vnode.h
+++ xfs-linux-clean/linux-2.6/xfs_vnode.h
@@ -454,17 +454,17 @@ static inline int vn_count(struct bhv_vn
 /*
  * Vnode reference counting functions (and macros for compatibility).
  */
-extern bhv_vnode_t	*vn_hold(struct bhv_vnode *);
+extern void vn_hold(struct bhv_vnode *);
 
 #if defined(XFS_VNODE_TRACE)
 #define VN_HOLD(vp)		\
-	((void)vn_hold(vp),	\
+	(vn_hold(vp),	\
 	  vn_trace_hold(vp, __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
 	  (vn_trace_rele(vp, __FILE__, __LINE__, (inst_t *)__return_address), \
 	   iput(vn_to_inode(vp)))
 #else
-#define VN_HOLD(vp)		((void)vn_hold(vp))
+#define VN_HOLD(vp)		(vn_hold(vp))
 #define VN_RELE(vp)		(iput(vn_to_inode(vp)))
 #endif
 
