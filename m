Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01N8ltB002546 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 17:08:50 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26D5958562
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:50:28 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0vNzw8NMe5TNBiCc for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:50:28 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 4B637AC6273
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 16:50:29 -0600 (CST)
Message-ID: <495D48B3.2080708@sandeen.net>
Date: Thu, 01 Jan 2009 16:50:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove always-true #ifndef HAVE_FORMAT32 tests
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

There are several tests for #ifndef HAVE_FORMAT32, but
this is never defined anywhere so it is always the default
behavior; just remove the ifndef goop.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/xfs_extfree_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.h
+++ xfs/fs/xfs/xfs_extfree_item.h
@@ -33,12 +33,10 @@ typedef struct xfs_extent {
  * conversion routine.
  */
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_extent_32 {
 	__uint64_t	ext_start;
 	__uint32_t	ext_len;
 } __attribute__((packed)) xfs_extent_32_t;
-#endif
 
 typedef struct xfs_extent_64 {
 	__uint64_t	ext_start;
@@ -59,7 +57,6 @@ typedef struct xfs_efi_log_format {
 	xfs_extent_t		efi_extents[1];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efi_log_format_32 {
 	__uint16_t		efi_type;	/* efi log item type */
 	__uint16_t		efi_size;	/* size of this item */
@@ -67,7 +64,6 @@ typedef struct xfs_efi_log_format_32 {
 	__uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
-#endif
 
 typedef struct xfs_efi_log_format_64 {
 	__uint16_t		efi_type;	/* efi log item type */
@@ -90,7 +86,6 @@ typedef struct xfs_efd_log_format {
 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efd_log_format_32 {
 	__uint16_t		efd_type;	/* efd log item type */
 	__uint16_t		efd_size;	/* size of this item */
@@ -98,7 +93,6 @@ typedef struct xfs_efd_log_format_32 {
 	__uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
-#endif
 
 typedef struct xfs_efd_log_format_64 {
 	__uint16_t		efd_type;	/* efd log item type */
Index: xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.h
+++ xfs/fs/xfs/xfs_inode_item.h
@@ -40,7 +40,6 @@ typedef struct xfs_inode_log_format {
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_inode_log_format_32 {
 	__uint16_t		ilf_type;	/* inode log item type */
 	__uint16_t		ilf_size;	/* size of this item */
@@ -56,7 +55,6 @@ typedef struct xfs_inode_log_format_32 {
 	__int32_t		ilf_len;	/* len of inode buffer */
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } __attribute__((packed)) xfs_inode_log_format_32_t;
-#endif
 
 typedef struct xfs_inode_log_format_64 {
 	__uint16_t		ilf_type;	/* inode log item type */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
