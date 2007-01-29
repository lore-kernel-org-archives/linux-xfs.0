Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 08:39:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0TGcrqw000628
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 08:38:54 -0800
Message-ID: <45BE22FD.1040508@sandeen.net>
Date: Mon, 29 Jan 2007 10:38:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill off unused xfs_mac, xfs_cap headers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: rpjday@mindspring.com

Followup to Robert's initial noticing of the unused bits.

compile-tested on 2.6, x86_64

---

Remove unused xfs_mac.h, xfs_cap.h headers

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 xfs-linux/linux-2.4/xfs_ioctl.c   |    2 
 xfs-linux/linux-2.4/xfs_iops.c    |    2 
 xfs-linux/linux-2.4/xfs_ksyms.c   |    2 
 xfs-linux/linux-2.4/xfs_lrw.c     |    2 
 xfs-linux/linux-2.4/xfs_super.c   |    2 
 xfs-linux/linux-2.6/xfs_ioctl.c   |    2 
 xfs-linux/linux-2.6/xfs_iops.c    |    2 
 xfs-linux/linux-2.6/xfs_ksyms.c   |    2 
 xfs-linux/linux-2.6/xfs_lrw.c     |    2 
 xfs-linux/linux-2.6/xfs_super.c   |    2 
 xfs-linux/quota/xfs_dquot.c       |    2 
 xfs-linux/quota/xfs_dquot_item.c  |    2 
 xfs-linux/quota/xfs_qm.c          |    2 
 xfs-linux/quota/xfs_qm_bhv.c      |    2 
 xfs-linux/quota/xfs_qm_stats.c    |    2 
 xfs-linux/quota/xfs_qm_syscalls.c |    2 
 xfs-linux/quota/xfs_trans_dquot.c |    2 
 xfs-linux/xfs_acl.c               |    1 
 xfs-linux/xfs_dfrag.c             |    1 
 xfs-linux/xfs_inode.c             |    1 
 xfs-linux/xfs_iomap.c             |    2 
 xfs-linux/xfs_rw.c                |    1 
 xfs-linux/xfs_vnodeops.c          |    1 
 xfs_cap.h                         |   70 -------------------------
 xfs_mac.h                         |  106 --------------------------------------

Index: xfs-linux/linux-2.4/xfs_ioctl.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_ioctl.c
+++ xfs-linux/linux-2.4/xfs_ioctl.c
@@ -42,8 +42,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/linux-2.4/xfs_iops.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_iops.c
+++ xfs-linux/linux-2.4/xfs_iops.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/linux-2.4/xfs_ksyms.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_ksyms.c
+++ xfs-linux/linux-2.4/xfs_ksyms.c
@@ -53,8 +53,6 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_inode_item.h"
Index: xfs-linux/linux-2.4/xfs_lrw.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_lrw.c
+++ xfs-linux/linux-2.4/xfs_lrw.c
@@ -44,8 +44,6 @@
 #include "xfs_rw.h"
 #include "xfs_refcache.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
Index: xfs-linux/linux-2.4/xfs_super.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_super.c
+++ xfs-linux/linux-2.4/xfs_super.c
@@ -44,8 +44,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_ioctl.c
+++ xfs-linux/linux-2.6/xfs_ioctl.c
@@ -41,8 +41,6 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
Index: xfs-linux/linux-2.6/xfs_iops.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_iops.c
+++ xfs-linux/linux-2.6/xfs_iops.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/linux-2.6/xfs_ksyms.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_ksyms.c
+++ xfs-linux/linux-2.6/xfs_ksyms.c
@@ -53,8 +53,6 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_inode_item.h"
Index: xfs-linux/linux-2.6/xfs_lrw.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_lrw.c
+++ xfs-linux/linux-2.6/xfs_lrw.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
Index: xfs-linux/linux-2.6/xfs_super.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_super.c
+++ xfs-linux/linux-2.6/xfs_super.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/quota/xfs_dquot.c
===================================================================
--- xfs-linux.orig/quota/xfs_dquot.c
+++ xfs-linux/quota/xfs_dquot.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs-linux/quota/xfs_dquot_item.c
===================================================================
--- xfs-linux.orig/quota/xfs_dquot_item.c
+++ xfs-linux/quota/xfs_dquot_item.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs-linux/quota/xfs_qm.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm.c
+++ xfs-linux/quota/xfs_qm.c
@@ -44,8 +44,6 @@
 #include "xfs_bmap.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs-linux/quota/xfs_qm_bhv.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm_bhv.c
+++ xfs-linux/quota/xfs_qm_bhv.c
@@ -44,8 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs-linux/quota/xfs_qm_stats.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm_stats.c
+++ xfs-linux/quota/xfs_qm_stats.c
@@ -43,8 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs-linux/quota/xfs_qm_syscalls.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm_syscalls.c
+++ xfs-linux/quota/xfs_qm_syscalls.c
@@ -46,8 +46,6 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs-linux/quota/xfs_trans_dquot.c
===================================================================
--- xfs-linux.orig/quota/xfs_trans_dquot.c
+++ xfs-linux/quota/xfs_trans_dquot.c
@@ -43,8 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs-linux/xfs_acl.c
===================================================================
--- xfs-linux.orig/xfs_acl.c
+++ xfs-linux/xfs_acl.c
@@ -31,7 +31,6 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_acl.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 
 #include <linux/capability.h>
Index: xfs-linux/xfs_cap.h
===================================================================
--- xfs-linux.orig/xfs_cap.h
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_CAP_H__
-#define __XFS_CAP_H__
-
-/*
- * Capabilities
- */
-typedef __uint64_t xfs_cap_value_t;
-
-typedef struct xfs_cap_set {
-	xfs_cap_value_t	cap_effective;	/* use in capability checks */
-	xfs_cap_value_t	cap_permitted;	/* combined with file attrs */
-	xfs_cap_value_t	cap_inheritable;/* pass through exec */
-} xfs_cap_set_t;
-
-/* On-disk XFS extended attribute names */
-#define SGI_CAP_FILE	"SGI_CAP_FILE"
-#define SGI_CAP_FILE_SIZE	(sizeof(SGI_CAP_FILE)-1)
-#define SGI_CAP_LINUX	"SGI_CAP_LINUX"
-#define SGI_CAP_LINUX_SIZE	(sizeof(SGI_CAP_LINUX)-1)
-
-/*
- * For Linux, we take the bitfields directly from capability.h
- * and no longer attempt to keep this attribute ondisk compatible
- * with IRIX.  Since this attribute is only set on executables,
- * it just doesn't make much sense to try.  We do use a different
- * named attribute though, to avoid confusion.
- */
-
-#ifdef __KERNEL__
-
-#ifdef CONFIG_FS_POSIX_CAP
-
-#include <linux/posix_cap_xattr.h>
-
-struct bhv_vnode;
-
-extern int xfs_cap_vhascap(struct bhv_vnode *);
-extern int xfs_cap_vset(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vget(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vremove(struct bhv_vnode *);
-
-#define _CAP_EXISTS		xfs_cap_vhascap
-
-#else
-#define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
-#define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
-#define xfs_cap_vremove(v)	(-EOPNOTSUPP)
-#define _CAP_EXISTS		(NULL)
-#endif
-
-#endif	/* __KERNEL__ */
-
-#endif  /* __XFS_CAP_H__ */
Index: xfs-linux/xfs_dfrag.c
===================================================================
--- xfs-linux.orig/xfs_dfrag.c
+++ xfs-linux/xfs_dfrag.c
@@ -41,7 +41,6 @@
 #include "xfs_itable.h"
 #include "xfs_dfrag.h"
 #include "xfs_error.h"
-#include "xfs_mac.h"
 #include "xfs_rw.h"
 
 /*
Index: xfs-linux/xfs_inode.c
===================================================================
--- xfs-linux.orig/xfs_inode.c
+++ xfs-linux/xfs_inode.c
@@ -47,7 +47,6 @@
 #include "xfs_utils.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_quota.h"
-#include "xfs_mac.h"
 #include "xfs_acl.h"
 
 
Index: xfs-linux/xfs_iomap.c
===================================================================
--- xfs-linux.orig/xfs_iomap.c
+++ xfs-linux/xfs_iomap.c
@@ -43,8 +43,6 @@
 #include "xfs_itable.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
-#include "xfs_cap.h"
-#include "xfs_mac.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs-linux/xfs_mac.h
===================================================================
--- xfs-linux.orig/xfs_mac.h
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * Copyright (c) 2001-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_MAC_H__
-#define __XFS_MAC_H__
-
-/*
- * Mandatory Access Control
- *
- * Layout of a composite MAC label:
- * ml_list contains the list of categories (MSEN) followed by the list of
- * divisions (MINT). This is actually a header for the data structure which
- * will have an ml_list with more than one element.
- *
- *      -------------------------------
- *      | ml_msen_type | ml_mint_type |
- *      -------------------------------
- *      | ml_level     | ml_grade     |
- *      -------------------------------
- *      | ml_catcount                 |
- *      -------------------------------
- *      | ml_divcount                 |
- *      -------------------------------
- *      | category 1                  |
- *      | . . .                       |
- *      | category N                  | (where N = ml_catcount)
- *      -------------------------------
- *      | division 1                  |
- *      | . . .                       |
- *      | division M                  | (where M = ml_divcount)
- *      -------------------------------
- */
-#define XFS_MAC_MAX_SETS	250
-typedef struct xfs_mac_label {
-	__uint8_t	ml_msen_type;	/* MSEN label type */
-	__uint8_t	ml_mint_type;	/* MINT label type */
-	__uint8_t	ml_level;	/* Hierarchical level */
-	__uint8_t	ml_grade;	/* Hierarchical grade */
-	__uint16_t	ml_catcount;	/* Category count */
-	__uint16_t	ml_divcount;	/* Division count */
-					/* Category set, then Division set */
-	__uint16_t	ml_list[XFS_MAC_MAX_SETS];
-} xfs_mac_label_t;
-
-/* MSEN label type names. Choose an upper case ASCII character.  */
-#define XFS_MSEN_ADMIN_LABEL	'A'	/* Admin: low<admin != tcsec<high */
-#define XFS_MSEN_EQUAL_LABEL	'E'	/* Wildcard - always equal */
-#define XFS_MSEN_HIGH_LABEL	'H'	/* System High - always dominates */
-#define XFS_MSEN_MLD_HIGH_LABEL	'I'	/* System High, multi-level dir */
-#define XFS_MSEN_LOW_LABEL	'L'	/* System Low - always dominated */
-#define XFS_MSEN_MLD_LABEL	'M'	/* TCSEC label on a multi-level dir */
-#define XFS_MSEN_MLD_LOW_LABEL	'N'	/* System Low, multi-level dir */
-#define XFS_MSEN_TCSEC_LABEL	'T'	/* TCSEC label */
-#define XFS_MSEN_UNKNOWN_LABEL	'U'	/* unknown label */
-
-/* MINT label type names. Choose a lower case ASCII character.  */
-#define XFS_MINT_BIBA_LABEL	'b'	/* Dual of a TCSEC label */
-#define XFS_MINT_EQUAL_LABEL	'e'	/* Wildcard - always equal */
-#define XFS_MINT_HIGH_LABEL	'h'	/* High Grade - always dominates */
-#define XFS_MINT_LOW_LABEL	'l'	/* Low Grade - always dominated */
-
-/* On-disk XFS extended attribute names */
-#define SGI_MAC_FILE	"SGI_MAC_FILE"
-#define SGI_MAC_FILE_SIZE	(sizeof(SGI_MAC_FILE)-1)
-
-
-#ifdef __KERNEL__
-
-#ifdef CONFIG_FS_POSIX_MAC
-
-/* NOT YET IMPLEMENTED */
-
-#define MACEXEC		00100
-#define MACWRITE	00200
-#define MACREAD		00400
-
-struct xfs_inode;
-extern int  xfs_mac_iaccess(struct xfs_inode *, mode_t, cred_t *);
-
-#define _MAC_XFS_IACCESS(i,m,c) (xfs_mac_iaccess(i,m,c))
-#define _MAC_VACCESS(v,c,m)	(xfs_mac_vaccess(v,c,m))
-#define _MAC_EXISTS		xfs_mac_vhaslabel
-
-#else
-#define _MAC_XFS_IACCESS(i,m,c)	(0)
-#define _MAC_VACCESS(v,c,m)	(0)
-#define _MAC_EXISTS		(NULL)
-#endif
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_MAC_H__ */
Index: xfs-linux/xfs_rw.c
===================================================================
--- xfs-linux.orig/xfs_rw.c
+++ xfs-linux/xfs_rw.c
@@ -42,7 +42,6 @@
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_acl.h"
-#include "xfs_mac.h"
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_rw.h"
Index: xfs-linux/xfs_vnodeops.c
===================================================================
--- xfs-linux.orig/xfs_vnodeops.c
+++ xfs-linux/xfs_vnodeops.c
@@ -51,7 +51,6 @@
 #include "xfs_refcache.h"
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
-#include "xfs_mac.h"
 
 STATIC int
 xfs_open(
