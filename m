Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LI4WhO039214 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 13:04:32 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107211804.p6LI4Rvf006075@stout.americas.sgi.com>
Date: Thu, 21 Jul 2011 13:04:26 -0500
Subject: [PATCH, RFC] xfs: rename "linux-2.6" subdirectory to be simply "linux"
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com

Rename the "linux-2.6" platform-specific subdirectory in XFS to just
be "linux".  This is consistent with the "new" Linux development
model (regular stable releases rather than the old even/odd cycle
with long periods between stable releases).  It was also inspired by
Linus' recent rename of top-level git repository for the Linux code.

I created a "linux-2.6" symlink pointing to "linux", but I'd
like to eliminate that as well.

Despite the way the patch below looks, this change consists of:
  - Rename "fs/xfs/linux-2.6" to be "fs/xfs/linux"
  - Create the "fs/xfs/linux-2.6" link
  - Modify "fs/xfs/Makefile", changing "linux-2.6" -> "linux"
    in three spots.
  - Modify "fs/xfs/xfs.h" to change the name of the directory
    that contains the "xfs_linux.h" include file.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/Makefile                 |    6 +-
 fs/xfs/linux-2.6                |    1 +
 fs/xfs/linux-2.6/kmem.c         |  132 ---
 fs/xfs/linux-2.6/kmem.h         |  124 ---
 fs/xfs/linux-2.6/mrlock.h       |   90 --
 fs/xfs/linux-2.6/time.h         |   36 -
 fs/xfs/linux-2.6/xfs_acl.c      |  462 ----------
 fs/xfs/linux-2.6/xfs_aops.c     | 1496 -------------------------------
 fs/xfs/linux-2.6/xfs_aops.h     |   68 --
 fs/xfs/linux-2.6/xfs_buf.c      | 1874 ---------------------------------------
 fs/xfs/linux-2.6/xfs_buf.h      |  336 -------
 fs/xfs/linux-2.6/xfs_discard.c  |  222 -----
 fs/xfs/linux-2.6/xfs_discard.h  |   10 -
 fs/xfs/linux-2.6/xfs_export.c   |  250 ------
 fs/xfs/linux-2.6/xfs_export.h   |   72 --
 fs/xfs/linux-2.6/xfs_file.c     | 1092 -----------------------
 fs/xfs/linux-2.6/xfs_fs_subr.c  |   96 --
 fs/xfs/linux-2.6/xfs_globals.c  |   43 -
 fs/xfs/linux-2.6/xfs_ioctl.c    | 1556 --------------------------------
 fs/xfs/linux-2.6/xfs_ioctl.h    |   85 --
 fs/xfs/linux-2.6/xfs_ioctl32.c  |  672 --------------
 fs/xfs/linux-2.6/xfs_ioctl32.h  |  237 -----
 fs/xfs/linux-2.6/xfs_iops.c     | 1201 -------------------------
 fs/xfs/linux-2.6/xfs_iops.h     |   30 -
 fs/xfs/linux-2.6/xfs_linux.h    |  310 -------
 fs/xfs/linux-2.6/xfs_message.c  |  108 ---
 fs/xfs/linux-2.6/xfs_message.h  |   39 -
 fs/xfs/linux-2.6/xfs_quotaops.c |  139 ---
 fs/xfs/linux-2.6/xfs_stats.c    |  122 ---
 fs/xfs/linux-2.6/xfs_stats.h    |  223 -----
 fs/xfs/linux-2.6/xfs_super.c    | 1766 ------------------------------------
 fs/xfs/linux-2.6/xfs_super.h    |   87 --
 fs/xfs/linux-2.6/xfs_sync.c     | 1082 ----------------------
 fs/xfs/linux-2.6/xfs_sync.h     |   52 --
 fs/xfs/linux-2.6/xfs_sysctl.c   |  252 ------
 fs/xfs/linux-2.6/xfs_sysctl.h   |  102 ---
 fs/xfs/linux-2.6/xfs_trace.c    |   56 --
 fs/xfs/linux-2.6/xfs_trace.h    | 1746 ------------------------------------
 fs/xfs/linux-2.6/xfs_vnode.h    |   64 --
 fs/xfs/linux-2.6/xfs_xattr.c    |  241 -----
 fs/xfs/linux/kmem.c             |  132 +++
 fs/xfs/linux/kmem.h             |  124 +++
 fs/xfs/linux/mrlock.h           |   90 ++
 fs/xfs/linux/time.h             |   36 +
 fs/xfs/linux/xfs_acl.c          |  462 ++++++++++
 fs/xfs/linux/xfs_aops.c         | 1496 +++++++++++++++++++++++++++++++
 fs/xfs/linux/xfs_aops.h         |   68 ++
 fs/xfs/linux/xfs_buf.c          | 1874 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux/xfs_buf.h          |  336 +++++++
 fs/xfs/linux/xfs_discard.c      |  222 +++++
 fs/xfs/linux/xfs_discard.h      |   10 +
 fs/xfs/linux/xfs_export.c       |  250 ++++++
 fs/xfs/linux/xfs_export.h       |   72 ++
 fs/xfs/linux/xfs_file.c         | 1092 +++++++++++++++++++++++
 fs/xfs/linux/xfs_fs_subr.c      |   96 ++
 fs/xfs/linux/xfs_globals.c      |   43 +
 fs/xfs/linux/xfs_ioctl.c        | 1556 ++++++++++++++++++++++++++++++++
 fs/xfs/linux/xfs_ioctl.h        |   85 ++
 fs/xfs/linux/xfs_ioctl32.c      |  672 ++++++++++++++
 fs/xfs/linux/xfs_ioctl32.h      |  237 +++++
 fs/xfs/linux/xfs_iops.c         | 1201 +++++++++++++++++++++++++
 fs/xfs/linux/xfs_iops.h         |   30 +
 fs/xfs/linux/xfs_linux.h        |  310 +++++++
 fs/xfs/linux/xfs_message.c      |  108 +++
 fs/xfs/linux/xfs_message.h      |   39 +
 fs/xfs/linux/xfs_quotaops.c     |  139 +++
 fs/xfs/linux/xfs_stats.c        |  122 +++
 fs/xfs/linux/xfs_stats.h        |  223 +++++
 fs/xfs/linux/xfs_super.c        | 1766 ++++++++++++++++++++++++++++++++++++
 fs/xfs/linux/xfs_super.h        |   87 ++
 fs/xfs/linux/xfs_sync.c         | 1082 ++++++++++++++++++++++
 fs/xfs/linux/xfs_sync.h         |   52 ++
 fs/xfs/linux/xfs_sysctl.c       |  252 ++++++
 fs/xfs/linux/xfs_sysctl.h       |  102 +++
 fs/xfs/linux/xfs_trace.c        |   56 ++
 fs/xfs/linux/xfs_trace.h        | 1746 ++++++++++++++++++++++++++++++++++++
 fs/xfs/linux/xfs_vnode.h        |   64 ++
 fs/xfs/linux/xfs_xattr.c        |  241 +++++
 fs/xfs/xfs.h                    |    2 +-
 79 files changed, 16578 insertions(+), 16577 deletions(-)
 create mode 120000 fs/xfs/linux-2.6
 delete mode 100644 fs/xfs/linux-2.6/kmem.c
 delete mode 100644 fs/xfs/linux-2.6/kmem.h
 delete mode 100644 fs/xfs/linux-2.6/mrlock.h
 delete mode 100644 fs/xfs/linux-2.6/time.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_acl.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_aops.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_aops.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_buf.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_buf.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_discard.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_discard.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_export.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_export.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_file.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_fs_subr.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_globals.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_ioctl.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_ioctl.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_ioctl32.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_ioctl32.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_iops.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_iops.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_linux.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_message.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_message.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_quotaops.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_stats.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_stats.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_super.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_super.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_sync.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_sync.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_sysctl.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_sysctl.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_trace.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_trace.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_vnode.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_xattr.c
 create mode 100644 fs/xfs/linux/kmem.c
 create mode 100644 fs/xfs/linux/kmem.h
 create mode 100644 fs/xfs/linux/mrlock.h
 create mode 100644 fs/xfs/linux/time.h
 create mode 100644 fs/xfs/linux/xfs_acl.c
 create mode 100644 fs/xfs/linux/xfs_aops.c
 create mode 100644 fs/xfs/linux/xfs_aops.h
 create mode 100644 fs/xfs/linux/xfs_buf.c
 create mode 100644 fs/xfs/linux/xfs_buf.h
 create mode 100644 fs/xfs/linux/xfs_discard.c
 create mode 100644 fs/xfs/linux/xfs_discard.h
 create mode 100644 fs/xfs/linux/xfs_export.c
 create mode 100644 fs/xfs/linux/xfs_export.h
 create mode 100644 fs/xfs/linux/xfs_file.c
 create mode 100644 fs/xfs/linux/xfs_fs_subr.c
 create mode 100644 fs/xfs/linux/xfs_globals.c
 create mode 100644 fs/xfs/linux/xfs_ioctl.c
 create mode 100644 fs/xfs/linux/xfs_ioctl.h
 create mode 100644 fs/xfs/linux/xfs_ioctl32.c
 create mode 100644 fs/xfs/linux/xfs_ioctl32.h
 create mode 100644 fs/xfs/linux/xfs_iops.c
 create mode 100644 fs/xfs/linux/xfs_iops.h
 create mode 100644 fs/xfs/linux/xfs_linux.h
 create mode 100644 fs/xfs/linux/xfs_message.c
 create mode 100644 fs/xfs/linux/xfs_message.h
 create mode 100644 fs/xfs/linux/xfs_quotaops.c
 create mode 100644 fs/xfs/linux/xfs_stats.c
 create mode 100644 fs/xfs/linux/xfs_stats.h
 create mode 100644 fs/xfs/linux/xfs_super.c
 create mode 100644 fs/xfs/linux/xfs_super.h
 create mode 100644 fs/xfs/linux/xfs_sync.c
 create mode 100644 fs/xfs/linux/xfs_sync.h
 create mode 100644 fs/xfs/linux/xfs_sysctl.c
 create mode 100644 fs/xfs/linux/xfs_sysctl.h
 create mode 100644 fs/xfs/linux/xfs_trace.c
 create mode 100644 fs/xfs/linux/xfs_trace.h
 create mode 100644 fs/xfs/linux/xfs_vnode.h
 create mode 100644 fs/xfs/linux/xfs_xattr.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 75bb316..dd124ff 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,14 +16,14 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-ccflags-y := -I$(src) -I$(src)/linux-2.6
+ccflags-y := -I$(src) -I$(src)/linux
 ccflags-$(CONFIG_XFS_DEBUG) += -g
 
 XFS_LINUX := linux-2.6
 
 obj-$(CONFIG_XFS_FS)		+= xfs.o
 
-xfs-y				+= linux-2.6/xfs_trace.o
+xfs-y				+= linux/xfs_trace.o
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
 				   xfs_dquot.o \
@@ -32,7 +32,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
 				   xfs_qm_syscalls.o \
 				   xfs_qm_bhv.o \
 				   xfs_qm.o)
-xfs-$(CONFIG_XFS_QUOTA)		+= linux-2.6/xfs_quotaops.o
+xfs-$(CONFIG_XFS_QUOTA)		+= linux/xfs_quotaops.o
 
 ifeq ($(CONFIG_XFS_QUOTA),y)
 xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
diff --git a/fs/xfs/linux-2.6 b/fs/xfs/linux-2.6
new file mode 120000
index 0000000..9c52cb3
--- /dev/null
+++ b/fs/xfs/linux-2.6
@@ -0,0 +1 @@
+linux
\ No newline at end of file
diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
deleted file mode 100644
index a907de5..0000000
--- a/fs/xfs/linux-2.6/kmem.c
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/slab.h>
-#include <linux/swap.h>
-#include <linux/blkdev.h>
-#include <linux/backing-dev.h>
-#include "time.h"
-#include "kmem.h"
-#include "xfs_message.h"
-
-/*
- * Greedy allocation.  May fail and may return vmalloced memory.
- *
- * Must be freed using kmem_free_large.
- */
-void *
-kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
-{
-	void		*ptr;
-	size_t		kmsize = maxsize;
-
-	while (!(ptr = kmem_zalloc_large(kmsize))) {
-		if ((kmsize >>= 1) <= minsize)
-			kmsize = minsize;
-	}
-	if (ptr)
-		*size = kmsize;
-	return ptr;
-}
-
-void *
-kmem_alloc(size_t size, unsigned int __nocast flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	do {
-		ptr = kmalloc(size, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
-
-void *
-kmem_zalloc(size_t size, unsigned int __nocast flags)
-{
-	void	*ptr;
-
-	ptr = kmem_alloc(size, flags);
-	if (ptr)
-		memset((char *)ptr, 0, (int)size);
-	return ptr;
-}
-
-void
-kmem_free(const void *ptr)
-{
-	if (!is_vmalloc_addr(ptr)) {
-		kfree(ptr);
-	} else {
-		vfree(ptr);
-	}
-}
-
-void *
-kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
-	     unsigned int __nocast flags)
-{
-	void	*new;
-
-	new = kmem_alloc(newsize, flags);
-	if (ptr) {
-		if (new)
-			memcpy(new, ptr,
-				((oldsize < newsize) ? oldsize : newsize));
-		kmem_free(ptr);
-	}
-	return new;
-}
-
-void *
-kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	do {
-		ptr = kmem_cache_alloc(zone, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
-
-void *
-kmem_zone_zalloc(kmem_zone_t *zone, unsigned int __nocast flags)
-{
-	void	*ptr;
-
-	ptr = kmem_zone_alloc(zone, flags);
-	if (ptr)
-		memset((char *)ptr, 0, kmem_cache_size(zone));
-	return ptr;
-}
diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
deleted file mode 100644
index f7c8f7a..0000000
--- a/fs/xfs/linux-2.6/kmem.h
+++ /dev/null
@@ -1,124 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_SUPPORT_KMEM_H__
-#define __XFS_SUPPORT_KMEM_H__
-
-#include <linux/slab.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/vmalloc.h>
-
-/*
- * General memory allocation interfaces
- */
-
-#define KM_SLEEP	0x0001u
-#define KM_NOSLEEP	0x0002u
-#define KM_NOFS		0x0004u
-#define KM_MAYFAIL	0x0008u
-
-/*
- * We use a special process flag to avoid recursive callbacks into
- * the filesystem during transactions.  We will also issue our own
- * warnings, so we explicitly skip any generic ones (silly of us).
- */
-static inline gfp_t
-kmem_flags_convert(unsigned int __nocast flags)
-{
-	gfp_t	lflags;
-
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
-
-	if (flags & KM_NOSLEEP) {
-		lflags = GFP_ATOMIC | __GFP_NOWARN;
-	} else {
-		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
-			lflags &= ~__GFP_FS;
-	}
-	return lflags;
-}
-
-extern void *kmem_alloc(size_t, unsigned int __nocast);
-extern void *kmem_zalloc(size_t, unsigned int __nocast);
-extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
-extern void  kmem_free(const void *);
-
-static inline void *kmem_zalloc_large(size_t size)
-{
-	void *ptr;
-
-	ptr = vmalloc(size);
-	if (ptr)
-		memset(ptr, 0, size);
-	return ptr;
-}
-static inline void kmem_free_large(void *ptr)
-{
-	vfree(ptr);
-}
-
-extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
-
-/*
- * Zone interfaces
- */
-
-#define KM_ZONE_HWALIGN	SLAB_HWCACHE_ALIGN
-#define KM_ZONE_RECLAIM	SLAB_RECLAIM_ACCOUNT
-#define KM_ZONE_SPREAD	SLAB_MEM_SPREAD
-
-#define kmem_zone	kmem_cache
-#define kmem_zone_t	struct kmem_cache
-
-static inline kmem_zone_t *
-kmem_zone_init(int size, char *zone_name)
-{
-	return kmem_cache_create(zone_name, size, 0, 0, NULL);
-}
-
-static inline kmem_zone_t *
-kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
-		     void (*construct)(void *))
-{
-	return kmem_cache_create(zone_name, size, 0, flags, construct);
-}
-
-static inline void
-kmem_zone_free(kmem_zone_t *zone, void *ptr)
-{
-	kmem_cache_free(zone, ptr);
-}
-
-static inline void
-kmem_zone_destroy(kmem_zone_t *zone)
-{
-	if (zone)
-		kmem_cache_destroy(zone);
-}
-
-extern void *kmem_zone_alloc(kmem_zone_t *, unsigned int __nocast);
-extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
-
-static inline int
-kmem_shake_allow(gfp_t gfp_mask)
-{
-	return ((gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS));
-}
-
-#endif /* __XFS_SUPPORT_KMEM_H__ */
diff --git a/fs/xfs/linux-2.6/mrlock.h b/fs/xfs/linux-2.6/mrlock.h
deleted file mode 100644
index ff6a198..0000000
--- a/fs/xfs/linux-2.6/mrlock.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#ifndef __XFS_SUPPORT_MRLOCK_H__
-#define __XFS_SUPPORT_MRLOCK_H__
-
-#include <linux/rwsem.h>
-
-typedef struct {
-	struct rw_semaphore	mr_lock;
-#ifdef DEBUG
-	int			mr_writer;
-#endif
-} mrlock_t;
-
-#ifdef DEBUG
-#define mrinit(mrp, name)	\
-	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
-#else
-#define mrinit(mrp, name)	\
-	do { init_rwsem(&(mrp)->mr_lock); } while (0)
-#endif
-
-#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
-#define mrfree(mrp)		do { } while (0)
-
-static inline void mraccess_nested(mrlock_t *mrp, int subclass)
-{
-	down_read_nested(&mrp->mr_lock, subclass);
-}
-
-static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
-{
-	down_write_nested(&mrp->mr_lock, subclass);
-#ifdef DEBUG
-	mrp->mr_writer = 1;
-#endif
-}
-
-static inline int mrtryaccess(mrlock_t *mrp)
-{
-	return down_read_trylock(&mrp->mr_lock);
-}
-
-static inline int mrtryupdate(mrlock_t *mrp)
-{
-	if (!down_write_trylock(&mrp->mr_lock))
-		return 0;
-#ifdef DEBUG
-	mrp->mr_writer = 1;
-#endif
-	return 1;
-}
-
-static inline void mrunlock_excl(mrlock_t *mrp)
-{
-#ifdef DEBUG
-	mrp->mr_writer = 0;
-#endif
-	up_write(&mrp->mr_lock);
-}
-
-static inline void mrunlock_shared(mrlock_t *mrp)
-{
-	up_read(&mrp->mr_lock);
-}
-
-static inline void mrdemote(mrlock_t *mrp)
-{
-#ifdef DEBUG
-	mrp->mr_writer = 0;
-#endif
-	downgrade_write(&mrp->mr_lock);
-}
-
-#endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/linux-2.6/time.h b/fs/xfs/linux-2.6/time.h
deleted file mode 100644
index 387e695..0000000
--- a/fs/xfs/linux-2.6/time.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_SUPPORT_TIME_H__
-#define __XFS_SUPPORT_TIME_H__
-
-#include <linux/sched.h>
-#include <linux/time.h>
-
-typedef struct timespec timespec_t;
-
-static inline void delay(long ticks)
-{
-	schedule_timeout_uninterruptible(ticks);
-}
-
-static inline void nanotime(struct timespec *tvp)
-{
-	*tvp = CURRENT_TIME;
-}
-
-#endif /* __XFS_SUPPORT_TIME_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
deleted file mode 100644
index 115ac69..0000000
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ /dev/null
@@ -1,462 +0,0 @@
-/*
- * Copyright (c) 2008, Christoph Hellwig
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
-#include "xfs.h"
-#include "xfs_acl.h"
-#include "xfs_attr.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_vnodeops.h"
-#include "xfs_trace.h"
-#include <linux/slab.h>
-#include <linux/xattr.h>
-#include <linux/posix_acl_xattr.h>
-
-
-/*
- * Locking scheme:
- *  - all ACL updates are protected by inode->i_mutex, which is taken before
- *    calling into this file.
- */
-
-STATIC struct posix_acl *
-xfs_acl_from_disk(struct xfs_acl *aclp)
-{
-	struct posix_acl_entry *acl_e;
-	struct posix_acl *acl;
-	struct xfs_acl_entry *ace;
-	int count, i;
-
-	count = be32_to_cpu(aclp->acl_cnt);
-
-	acl = posix_acl_alloc(count, GFP_KERNEL);
-	if (!acl)
-		return ERR_PTR(-ENOMEM);
-
-	for (i = 0; i < count; i++) {
-		acl_e = &acl->a_entries[i];
-		ace = &aclp->acl_entry[i];
-
-		/*
-		 * The tag is 32 bits on disk and 16 bits in core.
-		 *
-		 * Because every access to it goes through the core
-		 * format first this is not a problem.
-		 */
-		acl_e->e_tag = be32_to_cpu(ace->ae_tag);
-		acl_e->e_perm = be16_to_cpu(ace->ae_perm);
-
-		switch (acl_e->e_tag) {
-		case ACL_USER:
-		case ACL_GROUP:
-			acl_e->e_id = be32_to_cpu(ace->ae_id);
-			break;
-		case ACL_USER_OBJ:
-		case ACL_GROUP_OBJ:
-		case ACL_MASK:
-		case ACL_OTHER:
-			acl_e->e_id = ACL_UNDEFINED_ID;
-			break;
-		default:
-			goto fail;
-		}
-	}
-	return acl;
-
-fail:
-	posix_acl_release(acl);
-	return ERR_PTR(-EINVAL);
-}
-
-STATIC void
-xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
-{
-	const struct posix_acl_entry *acl_e;
-	struct xfs_acl_entry *ace;
-	int i;
-
-	aclp->acl_cnt = cpu_to_be32(acl->a_count);
-	for (i = 0; i < acl->a_count; i++) {
-		ace = &aclp->acl_entry[i];
-		acl_e = &acl->a_entries[i];
-
-		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
-		ace->ae_id = cpu_to_be32(acl_e->e_id);
-		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
-	}
-}
-
-struct posix_acl *
-xfs_get_acl(struct inode *inode, int type)
-{
-	struct xfs_inode *ip = XFS_I(inode);
-	struct posix_acl *acl;
-	struct xfs_acl *xfs_acl;
-	int len = sizeof(struct xfs_acl);
-	unsigned char *ea_name;
-	int error;
-
-	acl = get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
-	switch (type) {
-	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
-		break;
-	case ACL_TYPE_DEFAULT:
-		ea_name = SGI_ACL_DEFAULT;
-		break;
-	default:
-		BUG();
-	}
-
-	/*
-	 * If we have a cached ACLs value just return it, not need to
-	 * go out to the disk.
-	 */
-
-	xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
-	if (!xfs_acl)
-		return ERR_PTR(-ENOMEM);
-
-	error = -xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
-							&len, ATTR_ROOT);
-	if (error) {
-		/*
-		 * If the attribute doesn't exist make sure we have a negative
-		 * cache entry, for any other error assume it is transient and
-		 * leave the cache entry as ACL_NOT_CACHED.
-		 */
-		if (error == -ENOATTR) {
-			acl = NULL;
-			goto out_update_cache;
-		}
-		goto out;
-	}
-
-	acl = xfs_acl_from_disk(xfs_acl);
-	if (IS_ERR(acl))
-		goto out;
-
- out_update_cache:
-	set_cached_acl(inode, type, acl);
- out:
-	kfree(xfs_acl);
-	return acl;
-}
-
-STATIC int
-xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
-{
-	struct xfs_inode *ip = XFS_I(inode);
-	unsigned char *ea_name;
-	int error;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	switch (type) {
-	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
-		break;
-	case ACL_TYPE_DEFAULT:
-		if (!S_ISDIR(inode->i_mode))
-			return acl ? -EACCES : 0;
-		ea_name = SGI_ACL_DEFAULT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (acl) {
-		struct xfs_acl *xfs_acl;
-		int len;
-
-		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
-		if (!xfs_acl)
-			return -ENOMEM;
-
-		xfs_acl_to_disk(xfs_acl, acl);
-		len = sizeof(struct xfs_acl) -
-			(sizeof(struct xfs_acl_entry) *
-			 (XFS_ACL_MAX_ENTRIES - acl->a_count));
-
-		error = -xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
-				len, ATTR_ROOT);
-
-		kfree(xfs_acl);
-	} else {
-		/*
-		 * A NULL ACL argument means we want to remove the ACL.
-		 */
-		error = -xfs_attr_remove(ip, ea_name, ATTR_ROOT);
-
-		/*
-		 * If the attribute didn't exist to start with that's fine.
-		 */
-		if (error == -ENOATTR)
-			error = 0;
-	}
-
-	if (!error)
-		set_cached_acl(inode, type, acl);
-	return error;
-}
-
-int
-xfs_check_acl(struct inode *inode, int mask, unsigned int flags)
-{
-	struct xfs_inode *ip;
-	struct posix_acl *acl;
-	int error = -EAGAIN;
-
-	ip = XFS_I(inode);
-	trace_xfs_check_acl(ip);
-
-	/*
-	 * If there is no attribute fork no ACL exists on this inode and
-	 * we can skip the whole exercise.
-	 */
-	if (!XFS_IFORK_Q(ip))
-		return -EAGAIN;
-
-	if (flags & IPERM_FLAG_RCU) {
-		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
-			return -ECHILD;
-		return -EAGAIN;
-	}
-
-	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl) {
-		error = posix_acl_permission(inode, acl, mask);
-		posix_acl_release(acl);
-	}
-
-	return error;
-}
-
-static int
-xfs_set_mode(struct inode *inode, mode_t mode)
-{
-	int error = 0;
-
-	if (mode != inode->i_mode) {
-		struct iattr iattr;
-
-		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
-		iattr.ia_mode = mode;
-		iattr.ia_ctime = current_fs_time(inode->i_sb);
-
-		error = -xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
-	}
-
-	return error;
-}
-
-static int
-xfs_acl_exists(struct inode *inode, unsigned char *name)
-{
-	int len = sizeof(struct xfs_acl);
-
-	return (xfs_attr_get(XFS_I(inode), name, NULL, &len,
-			    ATTR_ROOT|ATTR_KERNOVAL) == 0);
-}
-
-int
-posix_acl_access_exists(struct inode *inode)
-{
-	return xfs_acl_exists(inode, SGI_ACL_FILE);
-}
-
-int
-posix_acl_default_exists(struct inode *inode)
-{
-	if (!S_ISDIR(inode->i_mode))
-		return 0;
-	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
-}
-
-/*
- * No need for i_mutex because the inode is not yet exposed to the VFS.
- */
-int
-xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl)
-{
-	struct posix_acl *clone;
-	mode_t mode;
-	int error = 0, inherit = 0;
-
-	if (S_ISDIR(inode->i_mode)) {
-		error = xfs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl);
-		if (error)
-			return error;
-	}
-
-	clone = posix_acl_clone(default_acl, GFP_KERNEL);
-	if (!clone)
-		return -ENOMEM;
-
-	mode = inode->i_mode;
-	error = posix_acl_create_masq(clone, &mode);
-	if (error < 0)
-		goto out_release_clone;
-
-	/*
-	 * If posix_acl_create_masq returns a positive value we need to
-	 * inherit a permission that can't be represented using the Unix
-	 * mode bits and we actually need to set an ACL.
-	 */
-	if (error > 0)
-		inherit = 1;
-
-	error = xfs_set_mode(inode, mode);
-	if (error)
-		goto out_release_clone;
-
-	if (inherit)
-		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
-
- out_release_clone:
-	posix_acl_release(clone);
-	return error;
-}
-
-int
-xfs_acl_chmod(struct inode *inode)
-{
-	struct posix_acl *acl, *clone;
-	int error;
-
-	if (S_ISLNK(inode->i_mode))
-		return -EOPNOTSUPP;
-
-	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
-
-	clone = posix_acl_clone(acl, GFP_KERNEL);
-	posix_acl_release(acl);
-	if (!clone)
-		return -ENOMEM;
-
-	error = posix_acl_chmod_masq(clone, inode->i_mode);
-	if (!error)
-		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
-
-	posix_acl_release(clone);
-	return error;
-}
-
-static int
-xfs_xattr_acl_get(struct dentry *dentry, const char *name,
-		void *value, size_t size, int type)
-{
-	struct posix_acl *acl;
-	int error;
-
-	acl = xfs_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-
-	error = posix_acl_to_xattr(acl, value, size);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-static int
-xfs_xattr_acl_set(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int type)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl = NULL;
-	int error = 0;
-
-	if (flags & XATTR_CREATE)
-		return -EINVAL;
-	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
-		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
-		return -EPERM;
-
-	if (!value)
-		goto set_acl;
-
-	acl = posix_acl_from_xattr(value, size);
-	if (!acl) {
-		/*
-		 * acl_set_file(3) may request that we set default ACLs with
-		 * zero length -- defend (gracefully) against that here.
-		 */
-		goto out;
-	}
-	if (IS_ERR(acl)) {
-		error = PTR_ERR(acl);
-		goto out;
-	}
-
-	error = posix_acl_valid(acl);
-	if (error)
-		goto out_release;
-
-	error = -EINVAL;
-	if (acl->a_count > XFS_ACL_MAX_ENTRIES)
-		goto out_release;
-
-	if (type == ACL_TYPE_ACCESS) {
-		mode_t mode = inode->i_mode;
-		error = posix_acl_equiv_mode(acl, &mode);
-
-		if (error <= 0) {
-			posix_acl_release(acl);
-			acl = NULL;
-
-			if (error < 0)
-				return error;
-		}
-
-		error = xfs_set_mode(inode, mode);
-		if (error)
-			goto out_release;
-	}
-
- set_acl:
-	error = xfs_set_acl(inode, type, acl);
- out_release:
-	posix_acl_release(acl);
- out:
-	return error;
-}
-
-const struct xattr_handler xfs_xattr_acl_access_handler = {
-	.prefix	= POSIX_ACL_XATTR_ACCESS,
-	.flags	= ACL_TYPE_ACCESS,
-	.get	= xfs_xattr_acl_get,
-	.set	= xfs_xattr_acl_set,
-};
-
-const struct xattr_handler xfs_xattr_acl_default_handler = {
-	.prefix	= POSIX_ACL_XATTR_DEFAULT,
-	.flags	= ACL_TYPE_DEFAULT,
-	.get	= xfs_xattr_acl_get,
-	.set	= xfs_xattr_acl_set,
-};
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
deleted file mode 100644
index 26384fe..0000000
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ /dev/null
@@ -1,1496 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_trans.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_alloc.h"
-#include "xfs_error.h"
-#include "xfs_rw.h"
-#include "xfs_iomap.h"
-#include "xfs_vnodeops.h"
-#include "xfs_trace.h"
-#include "xfs_bmap.h"
-#include <linux/gfp.h>
-#include <linux/mpage.h>
-#include <linux/pagevec.h>
-#include <linux/writeback.h>
-
-
-/*
- * Prime number of hash buckets since address is used as the key.
- */
-#define NVSYNC		37
-#define to_ioend_wq(v)	(&xfs_ioend_wq[((unsigned long)v) % NVSYNC])
-static wait_queue_head_t xfs_ioend_wq[NVSYNC];
-
-void __init
-xfs_ioend_init(void)
-{
-	int i;
-
-	for (i = 0; i < NVSYNC; i++)
-		init_waitqueue_head(&xfs_ioend_wq[i]);
-}
-
-void
-xfs_ioend_wait(
-	xfs_inode_t	*ip)
-{
-	wait_queue_head_t *wq = to_ioend_wq(ip);
-
-	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
-}
-
-STATIC void
-xfs_ioend_wake(
-	xfs_inode_t	*ip)
-{
-	if (atomic_dec_and_test(&ip->i_iocount))
-		wake_up(to_ioend_wq(ip));
-}
-
-void
-xfs_count_page_state(
-	struct page		*page,
-	int			*delalloc,
-	int			*unwritten)
-{
-	struct buffer_head	*bh, *head;
-
-	*delalloc = *unwritten = 0;
-
-	bh = head = page_buffers(page);
-	do {
-		if (buffer_unwritten(bh))
-			(*unwritten) = 1;
-		else if (buffer_delay(bh))
-			(*delalloc) = 1;
-	} while ((bh = bh->b_this_page) != head);
-}
-
-STATIC struct block_device *
-xfs_find_bdev_for_inode(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (XFS_IS_REALTIME_INODE(ip))
-		return mp->m_rtdev_targp->bt_bdev;
-	else
-		return mp->m_ddev_targp->bt_bdev;
-}
-
-/*
- * We're now finished for good with this ioend structure.
- * Update the page state via the associated buffer_heads,
- * release holds on the inode and bio, and finally free
- * up memory.  Do not use the ioend after this.
- */
-STATIC void
-xfs_destroy_ioend(
-	xfs_ioend_t		*ioend)
-{
-	struct buffer_head	*bh, *next;
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-
-	for (bh = ioend->io_buffer_head; bh; bh = next) {
-		next = bh->b_private;
-		bh->b_end_io(bh, !ioend->io_error);
-	}
-
-	/*
-	 * Volume managers supporting multiple paths can send back ENODEV
-	 * when the final path disappears.  In this case continuing to fill
-	 * the page cache with dirty data which cannot be written out is
-	 * evil, so prevent that.
-	 */
-	if (unlikely(ioend->io_error == -ENODEV)) {
-		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ,
-				      __FILE__, __LINE__);
-	}
-
-	xfs_ioend_wake(ip);
-	mempool_free(ioend, xfs_ioend_pool);
-}
-
-/*
- * If the end of the current ioend is beyond the current EOF,
- * return the new EOF value, otherwise zero.
- */
-STATIC xfs_fsize_t
-xfs_ioend_new_eof(
-	xfs_ioend_t		*ioend)
-{
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
-	xfs_fsize_t		isize;
-	xfs_fsize_t		bsize;
-
-	bsize = ioend->io_offset + ioend->io_size;
-	isize = MAX(ip->i_size, ip->i_new_size);
-	isize = MIN(isize, bsize);
-	return isize > ip->i_d.di_size ? isize : 0;
-}
-
-/*
- * Update on-disk file size now that data has been written to disk.  The
- * current in-memory file size is i_size.  If a write is beyond eof i_new_size
- * will be the intended file size until i_size is updated.  If this write does
- * not extend all the way to the valid file size then restrict this update to
- * the end of the write.
- *
- * This function does not block as blocking on the inode lock in IO completion
- * can lead to IO completion order dependency deadlocks.. If it can't get the
- * inode ilock it will return EAGAIN. Callers must handle this.
- */
-STATIC int
-xfs_setfilesize(
-	xfs_ioend_t		*ioend)
-{
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
-	xfs_fsize_t		isize;
-
-	if (unlikely(ioend->io_error))
-		return 0;
-
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return EAGAIN;
-
-	isize = xfs_ioend_new_eof(ioend);
-	if (isize) {
-		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
-		ip->i_d.di_size = isize;
-		xfs_mark_inode_dirty(ip);
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
-}
-
-/*
- * Schedule IO completion handling on the final put of an ioend.
- */
-STATIC void
-xfs_finish_ioend(
-	struct xfs_ioend	*ioend)
-{
-	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		if (ioend->io_type == IO_UNWRITTEN)
-			queue_work(xfsconvertd_workqueue, &ioend->io_work);
-		else
-			queue_work(xfsdatad_workqueue, &ioend->io_work);
-	}
-}
-
-/*
- * IO write completion.
- */
-STATIC void
-xfs_end_io(
-	struct work_struct *work)
-{
-	xfs_ioend_t	*ioend = container_of(work, xfs_ioend_t, io_work);
-	struct xfs_inode *ip = XFS_I(ioend->io_inode);
-	int		error = 0;
-
-	/*
-	 * For unwritten extents we need to issue transactions to convert a
-	 * range to normal written extens after the data I/O has finished.
-	 */
-	if (ioend->io_type == IO_UNWRITTEN &&
-	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
-
-		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
-						 ioend->io_size);
-		if (error)
-			ioend->io_error = error;
-	}
-
-	/*
-	 * We might have to update the on-disk file size after extending
-	 * writes.
-	 */
-	error = xfs_setfilesize(ioend);
-	ASSERT(!error || error == EAGAIN);
-
-	/*
-	 * If we didn't complete processing of the ioend, requeue it to the
-	 * tail of the workqueue for another attempt later. Otherwise destroy
-	 * it.
-	 */
-	if (error == EAGAIN) {
-		atomic_inc(&ioend->io_remaining);
-		xfs_finish_ioend(ioend);
-		/* ensure we don't spin on blocked ioends */
-		delay(1);
-	} else {
-		if (ioend->io_iocb)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
-		xfs_destroy_ioend(ioend);
-	}
-}
-
-/*
- * Call IO completion handling in caller context on the final put of an ioend.
- */
-STATIC void
-xfs_finish_ioend_sync(
-	struct xfs_ioend	*ioend)
-{
-	if (atomic_dec_and_test(&ioend->io_remaining))
-		xfs_end_io(&ioend->io_work);
-}
-
-/*
- * Allocate and initialise an IO completion structure.
- * We need to track unwritten extent write completion here initially.
- * We'll need to extend this for updating the ondisk inode size later
- * (vs. incore size).
- */
-STATIC xfs_ioend_t *
-xfs_alloc_ioend(
-	struct inode		*inode,
-	unsigned int		type)
-{
-	xfs_ioend_t		*ioend;
-
-	ioend = mempool_alloc(xfs_ioend_pool, GFP_NOFS);
-
-	/*
-	 * Set the count to 1 initially, which will prevent an I/O
-	 * completion callback from happening before we have started
-	 * all the I/O from calling the completion routine too early.
-	 */
-	atomic_set(&ioend->io_remaining, 1);
-	ioend->io_error = 0;
-	ioend->io_list = NULL;
-	ioend->io_type = type;
-	ioend->io_inode = inode;
-	ioend->io_buffer_head = NULL;
-	ioend->io_buffer_tail = NULL;
-	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
-	ioend->io_offset = 0;
-	ioend->io_size = 0;
-	ioend->io_iocb = NULL;
-	ioend->io_result = 0;
-
-	INIT_WORK(&ioend->io_work, xfs_end_io);
-	return ioend;
-}
-
-STATIC int
-xfs_map_blocks(
-	struct inode		*inode,
-	loff_t			offset,
-	struct xfs_bmbt_irec	*imap,
-	int			type,
-	int			nonblocking)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	ssize_t			count = 1 << inode->i_blkbits;
-	xfs_fileoff_t		offset_fsb, end_fsb;
-	int			error = 0;
-	int			bmapi_flags = XFS_BMAPI_ENTIRE;
-	int			nimaps = 1;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
-
-	if (type == IO_UNWRITTEN)
-		bmapi_flags |= XFS_BMAPI_IGSTATE;
-
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-		if (nonblocking)
-			return -XFS_ERROR(EAGAIN);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-	}
-
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       (ip->i_df.if_flags & XFS_IFEXTENTS));
-	ASSERT(offset <= mp->m_maxioffset);
-
-	if (offset + count > mp->m_maxioffset)
-		count = mp->m_maxioffset - offset;
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
-			  bmapi_flags,  NULL, 0, imap, &nimaps, NULL);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (error)
-		return -XFS_ERROR(error);
-
-	if (type == IO_DELALLOC &&
-	    (!nimaps || isnullstartblock(imap->br_startblock))) {
-		error = xfs_iomap_write_allocate(ip, offset, count, imap);
-		if (!error)
-			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
-		return -XFS_ERROR(error);
-	}
-
-#ifdef DEBUG
-	if (type == IO_UNWRITTEN) {
-		ASSERT(nimaps);
-		ASSERT(imap->br_startblock != HOLESTARTBLOCK);
-		ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
-	}
-#endif
-	if (nimaps)
-		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
-	return 0;
-}
-
-STATIC int
-xfs_imap_valid(
-	struct inode		*inode,
-	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset)
-{
-	offset >>= inode->i_blkbits;
-
-	return offset >= imap->br_startoff &&
-		offset < imap->br_startoff + imap->br_blockcount;
-}
-
-/*
- * BIO completion handler for buffered IO.
- */
-STATIC void
-xfs_end_bio(
-	struct bio		*bio,
-	int			error)
-{
-	xfs_ioend_t		*ioend = bio->bi_private;
-
-	ASSERT(atomic_read(&bio->bi_cnt) >= 1);
-	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
-
-	/* Toss bio and pass work off to an xfsdatad thread */
-	bio->bi_private = NULL;
-	bio->bi_end_io = NULL;
-	bio_put(bio);
-
-	xfs_finish_ioend(ioend);
-}
-
-STATIC void
-xfs_submit_ioend_bio(
-	struct writeback_control *wbc,
-	xfs_ioend_t		*ioend,
-	struct bio		*bio)
-{
-	atomic_inc(&ioend->io_remaining);
-	bio->bi_private = ioend;
-	bio->bi_end_io = xfs_end_bio;
-
-	/*
-	 * If the I/O is beyond EOF we mark the inode dirty immediately
-	 * but don't update the inode size until I/O completion.
-	 */
-	if (xfs_ioend_new_eof(ioend))
-		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
-
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
-}
-
-STATIC struct bio *
-xfs_alloc_ioend_bio(
-	struct buffer_head	*bh)
-{
-	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
-	struct bio		*bio = bio_alloc(GFP_NOIO, nvecs);
-
-	ASSERT(bio->bi_private == NULL);
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-	bio->bi_bdev = bh->b_bdev;
-	return bio;
-}
-
-STATIC void
-xfs_start_buffer_writeback(
-	struct buffer_head	*bh)
-{
-	ASSERT(buffer_mapped(bh));
-	ASSERT(buffer_locked(bh));
-	ASSERT(!buffer_delay(bh));
-	ASSERT(!buffer_unwritten(bh));
-
-	mark_buffer_async_write(bh);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
-}
-
-STATIC void
-xfs_start_page_writeback(
-	struct page		*page,
-	int			clear_dirty,
-	int			buffers)
-{
-	ASSERT(PageLocked(page));
-	ASSERT(!PageWriteback(page));
-	if (clear_dirty)
-		clear_page_dirty_for_io(page);
-	set_page_writeback(page);
-	unlock_page(page);
-	/* If no buffers on the page are to be written, finish it here */
-	if (!buffers)
-		end_page_writeback(page);
-}
-
-static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
-{
-	return bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
-}
-
-/*
- * Submit all of the bios for all of the ioends we have saved up, covering the
- * initial writepage page and also any probed pages.
- *
- * Because we may have multiple ioends spanning a page, we need to start
- * writeback on all the buffers before we submit them for I/O. If we mark the
- * buffers as we got, then we can end up with a page that only has buffers
- * marked async write and I/O complete on can occur before we mark the other
- * buffers async write.
- *
- * The end result of this is that we trip a bug in end_page_writeback() because
- * we call it twice for the one page as the code in end_buffer_async_write()
- * assumes that all buffers on the page are started at the same time.
- *
- * The fix is two passes across the ioend list - one to start writeback on the
- * buffer_heads, and then submit them for I/O on the second pass.
- */
-STATIC void
-xfs_submit_ioend(
-	struct writeback_control *wbc,
-	xfs_ioend_t		*ioend)
-{
-	xfs_ioend_t		*head = ioend;
-	xfs_ioend_t		*next;
-	struct buffer_head	*bh;
-	struct bio		*bio;
-	sector_t		lastblock = 0;
-
-	/* Pass 1 - start writeback */
-	do {
-		next = ioend->io_list;
-		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private)
-			xfs_start_buffer_writeback(bh);
-	} while ((ioend = next) != NULL);
-
-	/* Pass 2 - submit I/O */
-	ioend = head;
-	do {
-		next = ioend->io_list;
-		bio = NULL;
-
-		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
-
-			if (!bio) {
- retry:
-				bio = xfs_alloc_ioend_bio(bh);
-			} else if (bh->b_blocknr != lastblock + 1) {
-				xfs_submit_ioend_bio(wbc, ioend, bio);
-				goto retry;
-			}
-
-			if (bio_add_buffer(bio, bh) != bh->b_size) {
-				xfs_submit_ioend_bio(wbc, ioend, bio);
-				goto retry;
-			}
-
-			lastblock = bh->b_blocknr;
-		}
-		if (bio)
-			xfs_submit_ioend_bio(wbc, ioend, bio);
-		xfs_finish_ioend(ioend);
-	} while ((ioend = next) != NULL);
-}
-
-/*
- * Cancel submission of all buffer_heads so far in this endio.
- * Toss the endio too.  Only ever called for the initial page
- * in a writepage request, so only ever one page.
- */
-STATIC void
-xfs_cancel_ioend(
-	xfs_ioend_t		*ioend)
-{
-	xfs_ioend_t		*next;
-	struct buffer_head	*bh, *next_bh;
-
-	do {
-		next = ioend->io_list;
-		bh = ioend->io_buffer_head;
-		do {
-			next_bh = bh->b_private;
-			clear_buffer_async_write(bh);
-			unlock_buffer(bh);
-		} while ((bh = next_bh) != NULL);
-
-		xfs_ioend_wake(XFS_I(ioend->io_inode));
-		mempool_free(ioend, xfs_ioend_pool);
-	} while ((ioend = next) != NULL);
-}
-
-/*
- * Test to see if we've been building up a completion structure for
- * earlier buffers -- if so, we try to append to this ioend if we
- * can, otherwise we finish off any current ioend and start another.
- * Return true if we've finished the given ioend.
- */
-STATIC void
-xfs_add_to_ioend(
-	struct inode		*inode,
-	struct buffer_head	*bh,
-	xfs_off_t		offset,
-	unsigned int		type,
-	xfs_ioend_t		**result,
-	int			need_ioend)
-{
-	xfs_ioend_t		*ioend = *result;
-
-	if (!ioend || need_ioend || type != ioend->io_type) {
-		xfs_ioend_t	*previous = *result;
-
-		ioend = xfs_alloc_ioend(inode, type);
-		ioend->io_offset = offset;
-		ioend->io_buffer_head = bh;
-		ioend->io_buffer_tail = bh;
-		if (previous)
-			previous->io_list = ioend;
-		*result = ioend;
-	} else {
-		ioend->io_buffer_tail->b_private = bh;
-		ioend->io_buffer_tail = bh;
-	}
-
-	bh->b_private = NULL;
-	ioend->io_size += bh->b_size;
-}
-
-STATIC void
-xfs_map_buffer(
-	struct inode		*inode,
-	struct buffer_head	*bh,
-	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset)
-{
-	sector_t		bn;
-	struct xfs_mount	*m = XFS_I(inode)->i_mount;
-	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap->br_startoff);
-	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
-
-	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
-	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
-
-	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
-	      ((offset - iomap_offset) >> inode->i_blkbits);
-
-	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
-
-	bh->b_blocknr = bn;
-	set_buffer_mapped(bh);
-}
-
-STATIC void
-xfs_map_at_offset(
-	struct inode		*inode,
-	struct buffer_head	*bh,
-	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset)
-{
-	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
-	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
-
-	xfs_map_buffer(inode, bh, imap, offset);
-	set_buffer_mapped(bh);
-	clear_buffer_delay(bh);
-	clear_buffer_unwritten(bh);
-}
-
-/*
- * Test if a given page is suitable for writing as part of an unwritten
- * or delayed allocate extent.
- */
-STATIC int
-xfs_is_delayed_page(
-	struct page		*page,
-	unsigned int		type)
-{
-	if (PageWriteback(page))
-		return 0;
-
-	if (page->mapping && page_has_buffers(page)) {
-		struct buffer_head	*bh, *head;
-		int			acceptable = 0;
-
-		bh = head = page_buffers(page);
-		do {
-			if (buffer_unwritten(bh))
-				acceptable = (type == IO_UNWRITTEN);
-			else if (buffer_delay(bh))
-				acceptable = (type == IO_DELALLOC);
-			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == IO_OVERWRITE);
-			else
-				break;
-		} while ((bh = bh->b_this_page) != head);
-
-		if (acceptable)
-			return 1;
-	}
-
-	return 0;
-}
-
-/*
- * Allocate & map buffers for page given the extent map. Write it out.
- * except for the original page of a writepage, this is called on
- * delalloc/unwritten pages only, for the original page it is possible
- * that the page has no mapping at all.
- */
-STATIC int
-xfs_convert_page(
-	struct inode		*inode,
-	struct page		*page,
-	loff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
-	struct writeback_control *wbc)
-{
-	struct buffer_head	*bh, *head;
-	xfs_off_t		end_offset;
-	unsigned long		p_offset;
-	unsigned int		type;
-	int			len, page_dirty;
-	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
-
-	if (page->index != tindex)
-		goto fail;
-	if (!trylock_page(page))
-		goto fail;
-	if (PageWriteback(page))
-		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
-		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
-		goto fail_unlock_page;
-
-	/*
-	 * page_dirty is initially a count of buffers on the page before
-	 * EOF and is decremented as we move each into a cleanable state.
-	 *
-	 * Derivation:
-	 *
-	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
-	 * hence give us the correct page_dirty count. On any other page,
-	 * it will be zero and in that case we need page_dirty to be the
-	 * count of buffers on the page.
-	 */
-	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
-			i_size_read(inode));
-
-	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
-	page_dirty = p_offset / len;
-
-	bh = head = page_buffers(page);
-	do {
-		if (offset >= end_offset)
-			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
-		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
-			done = 1;
-			continue;
-		}
-
-		if (buffer_unwritten(bh) || buffer_delay(bh) ||
-		    buffer_mapped(bh)) {
-			if (buffer_unwritten(bh))
-				type = IO_UNWRITTEN;
-			else if (buffer_delay(bh))
-				type = IO_DELALLOC;
-			else
-				type = IO_OVERWRITE;
-
-			if (!xfs_imap_valid(inode, imap, offset)) {
-				done = 1;
-				continue;
-			}
-
-			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
-
-			page_dirty--;
-			count++;
-		} else {
-			done = 1;
-		}
-	} while (offset += len, (bh = bh->b_this_page) != head);
-
-	if (uptodate && bh == head)
-		SetPageUptodate(page);
-
-	if (count) {
-		if (--wbc->nr_to_write <= 0 &&
-		    wbc->sync_mode == WB_SYNC_NONE)
-			done = 1;
-	}
-	xfs_start_page_writeback(page, !page_dirty, count);
-
-	return done;
- fail_unlock_page:
-	unlock_page(page);
- fail:
-	return 1;
-}
-
-/*
- * Convert & write out a cluster of pages in the same extent as defined
- * by mp and following the start page.
- */
-STATIC void
-xfs_cluster_write(
-	struct inode		*inode,
-	pgoff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
-	struct writeback_control *wbc,
-	pgoff_t			tlast)
-{
-	struct pagevec		pvec;
-	int			done = 0, i;
-
-	pagevec_init(&pvec, 0);
-	while (!done && tindex <= tlast) {
-		unsigned len = min_t(pgoff_t, PAGEVEC_SIZE, tlast - tindex + 1);
-
-		if (!pagevec_lookup(&pvec, inode->i_mapping, tindex, len))
-			break;
-
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					imap, ioendp, wbc);
-			if (done)
-				break;
-		}
-
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
-STATIC void
-xfs_vm_invalidatepage(
-	struct page		*page,
-	unsigned long		offset)
-{
-	trace_xfs_invalidatepage(page->mapping->host, page, offset);
-	block_invalidatepage(page, offset);
-}
-
-/*
- * If the page has delalloc buffers on it, we need to punch them out before we
- * invalidate the page. If we don't, we leave a stale delalloc mapping on the
- * inode that can trip a BUG() in xfs_get_blocks() later on if a direct IO read
- * is done on that same region - the delalloc extent is returned when none is
- * supposed to be there.
- *
- * We prevent this by truncating away the delalloc regions on the page before
- * invalidating it. Because they are delalloc, we can do this without needing a
- * transaction. Indeed - if we get ENOSPC errors, we have to be able to do this
- * truncation without a transaction as there is no space left for block
- * reservation (typically why we see a ENOSPC in writeback).
- *
- * This is not a performance critical path, so for now just do the punching a
- * buffer head at a time.
- */
-STATIC void
-xfs_aops_discard_page(
-	struct page		*page)
-{
-	struct inode		*inode = page->mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct buffer_head	*bh, *head;
-	loff_t			offset = page_offset(page);
-
-	if (!xfs_is_delayed_page(page, IO_DELALLOC))
-		goto out_invalidate;
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		goto out_invalidate;
-
-	xfs_alert(ip->i_mount,
-		"page discard on page %p, inode 0x%llx, offset %llu.",
-			page, ip->i_ino, offset);
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	bh = head = page_buffers(page);
-	do {
-		int		error;
-		xfs_fileoff_t	start_fsb;
-
-		if (!buffer_delay(bh))
-			goto next_buffer;
-
-		start_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"page discard unable to remove delalloc mapping.");
-			}
-			break;
-		}
-next_buffer:
-		offset += 1 << inode->i_blkbits;
-
-	} while ((bh = bh->b_this_page) != head);
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out_invalidate:
-	xfs_vm_invalidatepage(page, 0);
-	return;
-}
-
-/*
- * Write out a dirty page.
- *
- * For delalloc space on the page we need to allocate space and flush it.
- * For unwritten space on the page we need to start the conversion to
- * regular allocated space.
- * For any other dirty buffer heads on the page we should flush them.
- */
-STATIC int
-xfs_vm_writepage(
-	struct page		*page,
-	struct writeback_control *wbc)
-{
-	struct inode		*inode = page->mapping->host;
-	struct buffer_head	*bh, *head;
-	struct xfs_bmbt_irec	imap;
-	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
-	loff_t			offset;
-	unsigned int		type;
-	__uint64_t              end_offset;
-	pgoff_t                 end_index, last_index;
-	ssize_t			len;
-	int			err, imap_valid = 0, uptodate = 1;
-	int			count = 0;
-	int			nonblocking = 0;
-
-	trace_xfs_writepage(inode, page, 0);
-
-	ASSERT(page_has_buffers(page));
-
-	/*
-	 * Refuse to write the page out if we are called from reclaim context.
-	 *
-	 * This avoids stack overflows when called from deeply used stacks in
-	 * random callers for direct reclaim or memcg reclaim.  We explicitly
-	 * allow reclaim from kswapd as the stack usage there is relatively low.
-	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
-	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
-		goto redirty;
-
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called while in a filesystem transaction.
-	 */
-	if (WARN_ON(current->flags & PF_FSTRANS))
-		goto redirty;
-
-	/* Is this page beyond the end of the file? */
-	offset = i_size_read(inode);
-	end_index = offset >> PAGE_CACHE_SHIFT;
-	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
-	if (page->index >= end_index) {
-		if ((page->index >= end_index + 1) ||
-		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
-			unlock_page(page);
-			return 0;
-		}
-	}
-
-	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
-			offset);
-	len = 1 << inode->i_blkbits;
-
-	bh = head = page_buffers(page);
-	offset = page_offset(page);
-	type = IO_OVERWRITE;
-
-	if (wbc->sync_mode == WB_SYNC_NONE)
-		nonblocking = 1;
-
-	do {
-		int new_ioend = 0;
-
-		if (offset >= end_offset)
-			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
-
-		/*
-		 * set_page_dirty dirties all buffers in a page, independent
-		 * of their state.  The dirty state however is entirely
-		 * meaningless for holes (!mapped && uptodate), so skip
-		 * buffers covering holes here.
-		 */
-		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			imap_valid = 0;
-			continue;
-		}
-
-		if (buffer_unwritten(bh)) {
-			if (type != IO_UNWRITTEN) {
-				type = IO_UNWRITTEN;
-				imap_valid = 0;
-			}
-		} else if (buffer_delay(bh)) {
-			if (type != IO_DELALLOC) {
-				type = IO_DELALLOC;
-				imap_valid = 0;
-			}
-		} else if (buffer_uptodate(bh)) {
-			if (type != IO_OVERWRITE) {
-				type = IO_OVERWRITE;
-				imap_valid = 0;
-			}
-		} else {
-			if (PageUptodate(page)) {
-				ASSERT(buffer_mapped(bh));
-				imap_valid = 0;
-			}
-			continue;
-		}
-
-		if (imap_valid)
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
-		if (!imap_valid) {
-			/*
-			 * If we didn't have a valid mapping then we need to
-			 * put the new mapping into a separate ioend structure.
-			 * This ensures non-contiguous extents always have
-			 * separate ioends, which is particularly important
-			 * for unwritten extent conversion at I/O completion
-			 * time.
-			 */
-			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type,
-					     nonblocking);
-			if (err)
-				goto error;
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
-		}
-		if (imap_valid) {
-			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, &imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
-					 new_ioend);
-			count++;
-		}
-
-		if (!iohead)
-			iohead = ioend;
-
-	} while (offset += len, ((bh = bh->b_this_page) != head));
-
-	if (uptodate && bh == head)
-		SetPageUptodate(page);
-
-	xfs_start_page_writeback(page, 1, count);
-
-	if (ioend && imap_valid) {
-		xfs_off_t		end_index;
-
-		end_index = imap.br_startoff + imap.br_blockcount;
-
-		/* to bytes */
-		end_index <<= inode->i_blkbits;
-
-		/* to pages */
-		end_index = (end_index - 1) >> PAGE_CACHE_SHIFT;
-
-		/* check against file size */
-		if (end_index > last_index)
-			end_index = last_index;
-
-		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
-				  wbc, end_index);
-	}
-
-	if (iohead)
-		xfs_submit_ioend(wbc, iohead);
-
-	return 0;
-
-error:
-	if (iohead)
-		xfs_cancel_ioend(iohead);
-
-	if (err == -EAGAIN)
-		goto redirty;
-
-	xfs_aops_discard_page(page);
-	ClearPageUptodate(page);
-	unlock_page(page);
-	return err;
-
-redirty:
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
-
-STATIC int
-xfs_vm_writepages(
-	struct address_space	*mapping,
-	struct writeback_control *wbc)
-{
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
-	return generic_writepages(mapping, wbc);
-}
-
-/*
- * Called to move a page into cleanable state - and from there
- * to be released. The page should already be clean. We always
- * have buffer heads in this call.
- *
- * Returns 1 if the page is ok to release, 0 otherwise.
- */
-STATIC int
-xfs_vm_releasepage(
-	struct page		*page,
-	gfp_t			gfp_mask)
-{
-	int			delalloc, unwritten;
-
-	trace_xfs_releasepage(page->mapping->host, page, 0);
-
-	xfs_count_page_state(page, &delalloc, &unwritten);
-
-	if (WARN_ON(delalloc))
-		return 0;
-	if (WARN_ON(unwritten))
-		return 0;
-
-	return try_to_free_buffers(page);
-}
-
-STATIC int
-__xfs_get_blocks(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create,
-	int			direct)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb, end_fsb;
-	int			error = 0;
-	int			lockmode = 0;
-	struct xfs_bmbt_irec	imap;
-	int			nimaps = 1;
-	xfs_off_t		offset;
-	ssize_t			size;
-	int			new = 0;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
-
-	offset = (xfs_off_t)iblock << inode->i_blkbits;
-	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
-	size = bh_result->b_size;
-
-	if (!create && direct && offset >= i_size_read(inode))
-		return 0;
-
-	if (create) {
-		lockmode = XFS_ILOCK_EXCL;
-		xfs_ilock(ip, lockmode);
-	} else {
-		lockmode = xfs_ilock_map_shared(ip);
-	}
-
-	ASSERT(offset <= mp->m_maxioffset);
-	if (offset + size > mp->m_maxioffset)
-		size = mp->m_maxioffset - offset;
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-
-	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
-			  XFS_BMAPI_ENTIRE,  NULL, 0, &imap, &nimaps, NULL);
-	if (error)
-		goto out_unlock;
-
-	if (create &&
-	    (!nimaps ||
-	     (imap.br_startblock == HOLESTARTBLOCK ||
-	      imap.br_startblock == DELAYSTARTBLOCK))) {
-		if (direct) {
-			error = xfs_iomap_write_direct(ip, offset, size,
-						       &imap, nimaps);
-		} else {
-			error = xfs_iomap_write_delay(ip, offset, size, &imap);
-		}
-		if (error)
-			goto out_unlock;
-
-		trace_xfs_get_blocks_alloc(ip, offset, size, 0, &imap);
-	} else if (nimaps) {
-		trace_xfs_get_blocks_found(ip, offset, size, 0, &imap);
-	} else {
-		trace_xfs_get_blocks_notfound(ip, offset, size);
-		goto out_unlock;
-	}
-	xfs_iunlock(ip, lockmode);
-
-	if (imap.br_startblock != HOLESTARTBLOCK &&
-	    imap.br_startblock != DELAYSTARTBLOCK) {
-		/*
-		 * For unwritten extents do not report a disk address on
-		 * the read case (treat as if we're reading into a hole).
-		 */
-		if (create || !ISUNWRITTEN(&imap))
-			xfs_map_buffer(inode, bh_result, &imap, offset);
-		if (create && ISUNWRITTEN(&imap)) {
-			if (direct)
-				bh_result->b_private = inode;
-			set_buffer_unwritten(bh_result);
-		}
-	}
-
-	/*
-	 * If this is a realtime file, data may be on a different device.
-	 * to that pointed to from the buffer_head b_bdev currently.
-	 */
-	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
-
-	/*
-	 * If we previously allocated a block out beyond eof and we are now
-	 * coming back to use it then we will need to flag it as new even if it
-	 * has a disk address.
-	 *
-	 * With sub-block writes into unwritten extents we also need to mark
-	 * the buffer as new so that the unwritten parts of the buffer gets
-	 * correctly zeroed.
-	 */
-	if (create &&
-	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
-	     (offset >= i_size_read(inode)) ||
-	     (new || ISUNWRITTEN(&imap))))
-		set_buffer_new(bh_result);
-
-	if (imap.br_startblock == DELAYSTARTBLOCK) {
-		BUG_ON(direct);
-		if (create) {
-			set_buffer_uptodate(bh_result);
-			set_buffer_mapped(bh_result);
-			set_buffer_delay(bh_result);
-		}
-	}
-
-	/*
-	 * If this is O_DIRECT or the mpage code calling tell them how large
-	 * the mapping is, so that we can avoid repeated get_blocks calls.
-	 */
-	if (direct || size > (1 << inode->i_blkbits)) {
-		xfs_off_t		mapping_size;
-
-		mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
-		mapping_size <<= inode->i_blkbits;
-
-		ASSERT(mapping_size > 0);
-		if (mapping_size > size)
-			mapping_size = size;
-		if (mapping_size > LONG_MAX)
-			mapping_size = LONG_MAX;
-
-		bh_result->b_size = mapping_size;
-	}
-
-	return 0;
-
-out_unlock:
-	xfs_iunlock(ip, lockmode);
-	return -error;
-}
-
-int
-xfs_get_blocks(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
-}
-
-STATIC int
-xfs_get_blocks_direct(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
-}
-
-/*
- * Complete a direct I/O write request.
- *
- * If the private argument is non-NULL __xfs_get_blocks signals us that we
- * need to issue a transaction to convert the range from unwritten to written
- * extents.  In case this is regular synchronous I/O we just call xfs_end_io
- * to do this and we are done.  But in case this was a successful AIO
- * request this handler is called from interrupt context, from which we
- * can't start transactions.  In that case offload the I/O completion to
- * the workqueues we also use for buffered I/O completion.
- */
-STATIC void
-xfs_end_io_direct_write(
-	struct kiocb		*iocb,
-	loff_t			offset,
-	ssize_t			size,
-	void			*private,
-	int			ret,
-	bool			is_async)
-{
-	struct xfs_ioend	*ioend = iocb->private;
-
-	/*
-	 * blockdev_direct_IO can return an error even after the I/O
-	 * completion handler was called.  Thus we need to protect
-	 * against double-freeing.
-	 */
-	iocb->private = NULL;
-
-	ioend->io_offset = offset;
-	ioend->io_size = size;
-	if (private && size > 0)
-		ioend->io_type = IO_UNWRITTEN;
-
-	if (is_async) {
-		/*
-		 * If we are converting an unwritten extent we need to delay
-		 * the AIO completion until after the unwrittent extent
-		 * conversion has completed, otherwise do it ASAP.
-		 */
-		if (ioend->io_type == IO_UNWRITTEN) {
-			ioend->io_iocb = iocb;
-			ioend->io_result = ret;
-		} else {
-			aio_complete(iocb, ret, 0);
-		}
-		xfs_finish_ioend(ioend);
-	} else {
-		xfs_finish_ioend_sync(ioend);
-	}
-}
-
-STATIC ssize_t
-xfs_vm_direct_IO(
-	int			rw,
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
-{
-	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
-	ssize_t			ret;
-
-	if (rw & WRITE) {
-		iocb->private = xfs_alloc_ioend(inode, IO_DIRECT);
-
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL, 0);
-		if (ret != -EIOCBQUEUED && iocb->private)
-			xfs_destroy_ioend(iocb->private);
-	} else {
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    NULL, NULL, 0);
-	}
-
-	return ret;
-}
-
-STATIC void
-xfs_vm_write_failed(
-	struct address_space	*mapping,
-	loff_t			to)
-{
-	struct inode		*inode = mapping->host;
-
-	if (to > inode->i_size) {
-		/*
-		 * punch out the delalloc blocks we have already allocated. We
-		 * don't call xfs_setattr() to do this as we may be in the
-		 * middle of a multi-iovec write and so the vfs inode->i_size
-		 * will not match the xfs ip->i_size and so it will zero too
-		 * much. Hence we jus truncate the page cache to zero what is
-		 * necessary and punch the delalloc blocks directly.
-		 */
-		struct xfs_inode	*ip = XFS_I(inode);
-		xfs_fileoff_t		start_fsb;
-		xfs_fileoff_t		end_fsb;
-		int			error;
-
-		truncate_pagecache(inode, to, inode->i_size);
-
-		/*
-		 * Check if there are any blocks that are outside of i_size
-		 * that need to be trimmed back.
-		 */
-		start_fsb = XFS_B_TO_FSB(ip->i_mount, inode->i_size) + 1;
-		end_fsb = XFS_B_TO_FSB(ip->i_mount, to);
-		if (end_fsb <= start_fsb)
-			return;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-							end_fsb - start_fsb);
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"xfs_vm_write_failed: unable to clean up ino %lld",
-						ip->i_ino);
-			}
-		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-}
-
-STATIC int
-xfs_vm_write_begin(
-	struct file		*file,
-	struct address_space	*mapping,
-	loff_t			pos,
-	unsigned		len,
-	unsigned		flags,
-	struct page		**pagep,
-	void			**fsdata)
-{
-	int			ret;
-
-	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS,
-				pagep, xfs_get_blocks);
-	if (unlikely(ret))
-		xfs_vm_write_failed(mapping, pos + len);
-	return ret;
-}
-
-STATIC int
-xfs_vm_write_end(
-	struct file		*file,
-	struct address_space	*mapping,
-	loff_t			pos,
-	unsigned		len,
-	unsigned		copied,
-	struct page		*page,
-	void			*fsdata)
-{
-	int			ret;
-
-	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-	if (unlikely(ret < len))
-		xfs_vm_write_failed(mapping, pos + len);
-	return ret;
-}
-
-STATIC sector_t
-xfs_vm_bmap(
-	struct address_space	*mapping,
-	sector_t		block)
-{
-	struct inode		*inode = (struct inode *)mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-
-	trace_xfs_vm_bmap(XFS_I(inode));
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-	return generic_block_bmap(mapping, block, xfs_get_blocks);
-}
-
-STATIC int
-xfs_vm_readpage(
-	struct file		*unused,
-	struct page		*page)
-{
-	return mpage_readpage(page, xfs_get_blocks);
-}
-
-STATIC int
-xfs_vm_readpages(
-	struct file		*unused,
-	struct address_space	*mapping,
-	struct list_head	*pages,
-	unsigned		nr_pages)
-{
-	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
-}
-
-const struct address_space_operations xfs_address_space_operations = {
-	.readpage		= xfs_vm_readpage,
-	.readpages		= xfs_vm_readpages,
-	.writepage		= xfs_vm_writepage,
-	.writepages		= xfs_vm_writepages,
-	.releasepage		= xfs_vm_releasepage,
-	.invalidatepage		= xfs_vm_invalidatepage,
-	.write_begin		= xfs_vm_write_begin,
-	.write_end		= xfs_vm_write_end,
-	.bmap			= xfs_vm_bmap,
-	.direct_IO		= xfs_vm_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
-};
diff --git a/fs/xfs/linux-2.6/xfs_aops.h b/fs/xfs/linux-2.6/xfs_aops.h
deleted file mode 100644
index 71f721e..0000000
--- a/fs/xfs/linux-2.6/xfs_aops.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * Copyright (c) 2005-2006 Silicon Graphics, Inc.
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
-#ifndef __XFS_AOPS_H__
-#define __XFS_AOPS_H__
-
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
-extern mempool_t *xfs_ioend_pool;
-
-/*
- * Types of I/O for bmap clustering and I/O completion tracking.
- */
-enum {
-	IO_DIRECT = 0,	/* special case for direct I/O ioends */
-	IO_DELALLOC,	/* mapping covers delalloc region */
-	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
-	IO_OVERWRITE,	/* mapping covers already allocated extent */
-};
-
-#define XFS_IO_TYPES \
-	{ 0,			"" }, \
-	{ IO_DELALLOC,		"delalloc" }, \
-	{ IO_UNWRITTEN,		"unwritten" }, \
-	{ IO_OVERWRITE,		"overwrite" }
-
-/*
- * xfs_ioend struct manages large extent writes for XFS.
- * It can manage several multi-page bio's at once.
- */
-typedef struct xfs_ioend {
-	struct xfs_ioend	*io_list;	/* next ioend in chain */
-	unsigned int		io_type;	/* delalloc / unwritten */
-	int			io_error;	/* I/O error code */
-	atomic_t		io_remaining;	/* hold count */
-	struct inode		*io_inode;	/* file being written to */
-	struct buffer_head	*io_buffer_head;/* buffer linked list head */
-	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
-	size_t			io_size;	/* size of the extent */
-	xfs_off_t		io_offset;	/* offset in the file */
-	struct work_struct	io_work;	/* xfsdatad work queue */
-	struct kiocb		*io_iocb;
-	int			io_result;
-} xfs_ioend_t;
-
-extern const struct address_space_operations xfs_address_space_operations;
-extern int xfs_get_blocks(struct inode *, sector_t, struct buffer_head *, int);
-
-extern void xfs_ioend_init(void);
-extern void xfs_ioend_wait(struct xfs_inode *);
-
-extern void xfs_count_page_state(struct page *, int *, int *);
-
-#endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
deleted file mode 100644
index b2b4119..0000000
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ /dev/null
@@ -1,1874 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include <linux/stddef.h>
-#include <linux/errno.h>
-#include <linux/gfp.h>
-#include <linux/pagemap.h>
-#include <linux/init.h>
-#include <linux/vmalloc.h>
-#include <linux/bio.h>
-#include <linux/sysctl.h>
-#include <linux/proc_fs.h>
-#include <linux/workqueue.h>
-#include <linux/percpu.h>
-#include <linux/blkdev.h>
-#include <linux/hash.h>
-#include <linux/kthread.h>
-#include <linux/migrate.h>
-#include <linux/backing-dev.h>
-#include <linux/freezer.h>
-
-#include "xfs_sb.h"
-#include "xfs_inum.h"
-#include "xfs_log.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_trace.h"
-
-static kmem_zone_t *xfs_buf_zone;
-STATIC int xfsbufd(void *);
-STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
-
-static struct workqueue_struct *xfslogd_workqueue;
-struct workqueue_struct *xfsdatad_workqueue;
-struct workqueue_struct *xfsconvertd_workqueue;
-
-#ifdef XFS_BUF_LOCK_TRACKING
-# define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
-# define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
-# define XB_GET_OWNER(bp)	((bp)->b_last_holder)
-#else
-# define XB_SET_OWNER(bp)	do { } while (0)
-# define XB_CLEAR_OWNER(bp)	do { } while (0)
-# define XB_GET_OWNER(bp)	do { } while (0)
-#endif
-
-#define xb_to_gfp(flags) \
-	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : \
-	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN)
-
-#define xb_to_km(flags) \
-	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)
-
-#define xfs_buf_allocate(flags) \
-	kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags))
-#define xfs_buf_deallocate(bp) \
-	kmem_zone_free(xfs_buf_zone, (bp));
-
-static inline int
-xfs_buf_is_vmapped(
-	struct xfs_buf	*bp)
-{
-	/*
-	 * Return true if the buffer is vmapped.
-	 *
-	 * The XBF_MAPPED flag is set if the buffer should be mapped, but the
-	 * code is clever enough to know it doesn't have to map a single page,
-	 * so the check has to be both for XBF_MAPPED and bp->b_page_count > 1.
-	 */
-	return (bp->b_flags & XBF_MAPPED) && bp->b_page_count > 1;
-}
-
-static inline int
-xfs_buf_vmap_len(
-	struct xfs_buf	*bp)
-{
-	return (bp->b_page_count * PAGE_SIZE) - bp->b_offset;
-}
-
-/*
- * xfs_buf_lru_add - add a buffer to the LRU.
- *
- * The LRU takes a new reference to the buffer so that it will only be freed
- * once the shrinker takes the buffer off the LRU.
- */
-STATIC void
-xfs_buf_lru_add(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buftarg *btp = bp->b_target;
-
-	spin_lock(&btp->bt_lru_lock);
-	if (list_empty(&bp->b_lru)) {
-		atomic_inc(&bp->b_hold);
-		list_add_tail(&bp->b_lru, &btp->bt_lru);
-		btp->bt_lru_nr++;
-	}
-	spin_unlock(&btp->bt_lru_lock);
-}
-
-/*
- * xfs_buf_lru_del - remove a buffer from the LRU
- *
- * The unlocked check is safe here because it only occurs when there are not
- * b_lru_ref counts left on the inode under the pag->pag_buf_lock. it is there
- * to optimise the shrinker removing the buffer from the LRU and calling
- * xfs_buf_free(). i.e. it removes an unnecessary round trip on the
- * bt_lru_lock.
- */
-STATIC void
-xfs_buf_lru_del(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buftarg *btp = bp->b_target;
-
-	if (list_empty(&bp->b_lru))
-		return;
-
-	spin_lock(&btp->bt_lru_lock);
-	if (!list_empty(&bp->b_lru)) {
-		list_del_init(&bp->b_lru);
-		btp->bt_lru_nr--;
-	}
-	spin_unlock(&btp->bt_lru_lock);
-}
-
-/*
- * When we mark a buffer stale, we remove the buffer from the LRU and clear the
- * b_lru_ref count so that the buffer is freed immediately when the buffer
- * reference count falls to zero. If the buffer is already on the LRU, we need
- * to remove the reference that LRU holds on the buffer.
- *
- * This prevents build-up of stale buffers on the LRU.
- */
-void
-xfs_buf_stale(
-	struct xfs_buf	*bp)
-{
-	bp->b_flags |= XBF_STALE;
-	atomic_set(&(bp)->b_lru_ref, 0);
-	if (!list_empty(&bp->b_lru)) {
-		struct xfs_buftarg *btp = bp->b_target;
-
-		spin_lock(&btp->bt_lru_lock);
-		if (!list_empty(&bp->b_lru)) {
-			list_del_init(&bp->b_lru);
-			btp->bt_lru_nr--;
-			atomic_dec(&bp->b_hold);
-		}
-		spin_unlock(&btp->bt_lru_lock);
-	}
-	ASSERT(atomic_read(&bp->b_hold) >= 1);
-}
-
-STATIC void
-_xfs_buf_initialize(
-	xfs_buf_t		*bp,
-	xfs_buftarg_t		*target,
-	xfs_off_t		range_base,
-	size_t			range_length,
-	xfs_buf_flags_t		flags)
-{
-	/*
-	 * We don't want certain flags to appear in b_flags.
-	 */
-	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
-
-	memset(bp, 0, sizeof(xfs_buf_t));
-	atomic_set(&bp->b_hold, 1);
-	atomic_set(&bp->b_lru_ref, 1);
-	init_completion(&bp->b_iowait);
-	INIT_LIST_HEAD(&bp->b_lru);
-	INIT_LIST_HEAD(&bp->b_list);
-	RB_CLEAR_NODE(&bp->b_rbnode);
-	sema_init(&bp->b_sema, 0); /* held, no waiters */
-	XB_SET_OWNER(bp);
-	bp->b_target = target;
-	bp->b_file_offset = range_base;
-	/*
-	 * Set buffer_length and count_desired to the same value initially.
-	 * I/O routines should use count_desired, which will be the same in
-	 * most cases but may be reset (e.g. XFS recovery).
-	 */
-	bp->b_buffer_length = bp->b_count_desired = range_length;
-	bp->b_flags = flags;
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-	atomic_set(&bp->b_pin_count, 0);
-	init_waitqueue_head(&bp->b_waiters);
-
-	XFS_STATS_INC(xb_create);
-
-	trace_xfs_buf_init(bp, _RET_IP_);
-}
-
-/*
- *	Allocate a page array capable of holding a specified number
- *	of pages, and point the page buf at it.
- */
-STATIC int
-_xfs_buf_get_pages(
-	xfs_buf_t		*bp,
-	int			page_count,
-	xfs_buf_flags_t		flags)
-{
-	/* Make sure that we have a page list */
-	if (bp->b_pages == NULL) {
-		bp->b_offset = xfs_buf_poff(bp->b_file_offset);
-		bp->b_page_count = page_count;
-		if (page_count <= XB_PAGES) {
-			bp->b_pages = bp->b_page_array;
-		} else {
-			bp->b_pages = kmem_alloc(sizeof(struct page *) *
-					page_count, xb_to_km(flags));
-			if (bp->b_pages == NULL)
-				return -ENOMEM;
-		}
-		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
-	}
-	return 0;
-}
-
-/*
- *	Frees b_pages if it was allocated.
- */
-STATIC void
-_xfs_buf_free_pages(
-	xfs_buf_t	*bp)
-{
-	if (bp->b_pages != bp->b_page_array) {
-		kmem_free(bp->b_pages);
-		bp->b_pages = NULL;
-	}
-}
-
-/*
- *	Releases the specified buffer.
- *
- * 	The modification state of any associated pages is left unchanged.
- * 	The buffer most not be on any hash - use xfs_buf_rele instead for
- * 	hashed and refcounted buffers
- */
-void
-xfs_buf_free(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_free(bp, _RET_IP_);
-
-	ASSERT(list_empty(&bp->b_lru));
-
-	if (bp->b_flags & _XBF_PAGES) {
-		uint		i;
-
-		if (xfs_buf_is_vmapped(bp))
-			vm_unmap_ram(bp->b_addr - bp->b_offset,
-					bp->b_page_count);
-
-		for (i = 0; i < bp->b_page_count; i++) {
-			struct page	*page = bp->b_pages[i];
-
-			__free_page(page);
-		}
-	} else if (bp->b_flags & _XBF_KMEM)
-		kmem_free(bp->b_addr);
-	_xfs_buf_free_pages(bp);
-	xfs_buf_deallocate(bp);
-}
-
-/*
- * Allocates all the pages for buffer in question and builds it's page list.
- */
-STATIC int
-xfs_buf_allocate_memory(
-	xfs_buf_t		*bp,
-	uint			flags)
-{
-	size_t			size = bp->b_count_desired;
-	size_t			nbytes, offset;
-	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		page_count, i;
-	xfs_off_t		end;
-	int			error;
-
-	/*
-	 * for buffers that are contained within a single page, just allocate
-	 * the memory from the heap - there's no need for the complexity of
-	 * page arrays to keep allocation down to order 0.
-	 */
-	if (bp->b_buffer_length < PAGE_SIZE) {
-		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
-		if (!bp->b_addr) {
-			/* low memory - use alloc_page loop instead */
-			goto use_alloc_page;
-		}
-
-		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
-								PAGE_MASK) !=
-		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
-			/* b_addr spans two pages - use alloc_page instead */
-			kmem_free(bp->b_addr);
-			bp->b_addr = NULL;
-			goto use_alloc_page;
-		}
-		bp->b_offset = offset_in_page(bp->b_addr);
-		bp->b_pages = bp->b_page_array;
-		bp->b_pages[0] = virt_to_page(bp->b_addr);
-		bp->b_page_count = 1;
-		bp->b_flags |= XBF_MAPPED | _XBF_KMEM;
-		return 0;
-	}
-
-use_alloc_page:
-	end = bp->b_file_offset + bp->b_buffer_length;
-	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
-	error = _xfs_buf_get_pages(bp, page_count, flags);
-	if (unlikely(error))
-		return error;
-
-	offset = bp->b_offset;
-	bp->b_flags |= _XBF_PAGES;
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		struct page	*page;
-		uint		retries = 0;
-retry:
-		page = alloc_page(gfp_mask);
-		if (unlikely(page == NULL)) {
-			if (flags & XBF_READ_AHEAD) {
-				bp->b_page_count = i;
-				error = ENOMEM;
-				goto out_free_pages;
-			}
-
-			/*
-			 * This could deadlock.
-			 *
-			 * But until all the XFS lowlevel code is revamped to
-			 * handle buffer allocation failures we can't do much.
-			 */
-			if (!(++retries % 100))
-				xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, gfp_mask);
-
-			XFS_STATS_INC(xb_page_retries);
-			congestion_wait(BLK_RW_ASYNC, HZ/50);
-			goto retry;
-		}
-
-		XFS_STATS_INC(xb_page_found);
-
-		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
-		size -= nbytes;
-		bp->b_pages[i] = page;
-		offset = 0;
-	}
-	return 0;
-
-out_free_pages:
-	for (i = 0; i < bp->b_page_count; i++)
-		__free_page(bp->b_pages[i]);
-	return error;
-}
-
-/*
- *	Map buffer into kernel address-space if necessary.
- */
-STATIC int
-_xfs_buf_map_pages(
-	xfs_buf_t		*bp,
-	uint			flags)
-{
-	ASSERT(bp->b_flags & _XBF_PAGES);
-	if (bp->b_page_count == 1) {
-		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
-		bp->b_flags |= XBF_MAPPED;
-	} else if (flags & XBF_MAPPED) {
-		int retried = 0;
-
-		do {
-			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1, PAGE_KERNEL);
-			if (bp->b_addr)
-				break;
-			vm_unmap_aliases();
-		} while (retried++ <= 1);
-
-		if (!bp->b_addr)
-			return -ENOMEM;
-		bp->b_addr += bp->b_offset;
-		bp->b_flags |= XBF_MAPPED;
-	}
-
-	return 0;
-}
-
-/*
- *	Finding and Reading Buffers
- */
-
-/*
- *	Look up, and creates if absent, a lockable buffer for
- *	a given range of an inode.  The buffer is returned
- *	locked.	 If other overlapping buffers exist, they are
- *	released before the new buffer is created and locked,
- *	which may imply that this call will block until those buffers
- *	are unlocked.  No I/O is implied by this call.
- */
-xfs_buf_t *
-_xfs_buf_find(
-	xfs_buftarg_t		*btp,	/* block device target		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
-	xfs_buf_flags_t		flags,
-	xfs_buf_t		*new_bp)
-{
-	xfs_off_t		range_base;
-	size_t			range_length;
-	struct xfs_perag	*pag;
-	struct rb_node		**rbp;
-	struct rb_node		*parent;
-	xfs_buf_t		*bp;
-
-	range_base = (ioff << BBSHIFT);
-	range_length = (isize << BBSHIFT);
-
-	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(range_length < (1 << btp->bt_sshift)));
-	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
-
-	/* get tree root */
-	pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, ioff));
-
-	/* walk tree */
-	spin_lock(&pag->pag_buf_lock);
-	rbp = &pag->pag_buf_tree.rb_node;
-	parent = NULL;
-	bp = NULL;
-	while (*rbp) {
-		parent = *rbp;
-		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
-
-		if (range_base < bp->b_file_offset)
-			rbp = &(*rbp)->rb_left;
-		else if (range_base > bp->b_file_offset)
-			rbp = &(*rbp)->rb_right;
-		else {
-			/*
-			 * found a block offset match. If the range doesn't
-			 * match, the only way this is allowed is if the buffer
-			 * in the cache is stale and the transaction that made
-			 * it stale has not yet committed. i.e. we are
-			 * reallocating a busy extent. Skip this buffer and
-			 * continue searching to the right for an exact match.
-			 */
-			if (bp->b_buffer_length != range_length) {
-				ASSERT(bp->b_flags & XBF_STALE);
-				rbp = &(*rbp)->rb_right;
-				continue;
-			}
-			atomic_inc(&bp->b_hold);
-			goto found;
-		}
-	}
-
-	/* No match found */
-	if (new_bp) {
-		_xfs_buf_initialize(new_bp, btp, range_base,
-				range_length, flags);
-		rb_link_node(&new_bp->b_rbnode, parent, rbp);
-		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
-		/* the buffer keeps the perag reference until it is freed */
-		new_bp->b_pag = pag;
-		spin_unlock(&pag->pag_buf_lock);
-	} else {
-		XFS_STATS_INC(xb_miss_locked);
-		spin_unlock(&pag->pag_buf_lock);
-		xfs_perag_put(pag);
-	}
-	return new_bp;
-
-found:
-	spin_unlock(&pag->pag_buf_lock);
-	xfs_perag_put(pag);
-
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK) {
-			xfs_buf_rele(bp);
-			XFS_STATS_INC(xb_busy_locked);
-			return NULL;
-		}
-		xfs_buf_lock(bp);
-		XFS_STATS_INC(xb_get_locked_waited);
-	}
-
-	/*
-	 * if the buffer is stale, clear all the external state associated with
-	 * it. We need to keep flags such as how we allocated the buffer memory
-	 * intact here.
-	 */
-	if (bp->b_flags & XBF_STALE) {
-		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
-	}
-
-	trace_xfs_buf_find(bp, flags, _RET_IP_);
-	XFS_STATS_INC(xb_get_locked);
-	return bp;
-}
-
-/*
- *	Assembles a buffer covering the specified range.
- *	Storage in memory for all portions of the buffer will be allocated,
- *	although backing storage may not be.
- */
-xfs_buf_t *
-xfs_buf_get(
-	xfs_buftarg_t		*target,/* target for buffer		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
-	xfs_buf_flags_t		flags)
-{
-	xfs_buf_t		*bp, *new_bp;
-	int			error = 0;
-
-	new_bp = xfs_buf_allocate(flags);
-	if (unlikely(!new_bp))
-		return NULL;
-
-	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
-	if (bp == new_bp) {
-		error = xfs_buf_allocate_memory(bp, flags);
-		if (error)
-			goto no_buffer;
-	} else {
-		xfs_buf_deallocate(new_bp);
-		if (unlikely(bp == NULL))
-			return NULL;
-	}
-
-	if (!(bp->b_flags & XBF_MAPPED)) {
-		error = _xfs_buf_map_pages(bp, flags);
-		if (unlikely(error)) {
-			xfs_warn(target->bt_mount,
-				"%s: failed to map pages\n", __func__);
-			goto no_buffer;
-		}
-	}
-
-	XFS_STATS_INC(xb_get);
-
-	/*
-	 * Always fill in the block number now, the mapped cases can do
-	 * their own overlay of this later.
-	 */
-	bp->b_bn = ioff;
-	bp->b_count_desired = bp->b_buffer_length;
-
-	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	return bp;
-
- no_buffer:
-	if (flags & (XBF_LOCK | XBF_TRYLOCK))
-		xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-	return NULL;
-}
-
-STATIC int
-_xfs_buf_read(
-	xfs_buf_t		*bp,
-	xfs_buf_flags_t		flags)
-{
-	int			status;
-
-	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
-	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
-
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
-	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
-
-	status = xfs_buf_iorequest(bp);
-	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
-		return status;
-	return xfs_buf_iowait(bp);
-}
-
-xfs_buf_t *
-xfs_buf_read(
-	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize,
-	xfs_buf_flags_t		flags)
-{
-	xfs_buf_t		*bp;
-
-	flags |= XBF_READ;
-
-	bp = xfs_buf_get(target, ioff, isize, flags);
-	if (bp) {
-		trace_xfs_buf_read(bp, flags, _RET_IP_);
-
-		if (!XFS_BUF_ISDONE(bp)) {
-			XFS_STATS_INC(xb_get_read);
-			_xfs_buf_read(bp, flags);
-		} else if (flags & XBF_ASYNC) {
-			/*
-			 * Read ahead call which is already satisfied,
-			 * drop the buffer
-			 */
-			goto no_buffer;
-		} else {
-			/* We do not want read in the flags */
-			bp->b_flags &= ~XBF_READ;
-		}
-	}
-
-	return bp;
-
- no_buffer:
-	if (flags & (XBF_LOCK | XBF_TRYLOCK))
-		xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-	return NULL;
-}
-
-/*
- *	If we are not low on memory then do the readahead in a deadlock
- *	safe manner.
- */
-void
-xfs_buf_readahead(
-	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize)
-{
-	if (bdi_read_congested(target->bt_bdi))
-		return;
-
-	xfs_buf_read(target, ioff, isize,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
-}
-
-/*
- * Read an uncached buffer from disk. Allocates and returns a locked
- * buffer containing the disk contents or nothing.
- */
-struct xfs_buf *
-xfs_buf_read_uncached(
-	struct xfs_mount	*mp,
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		daddr,
-	size_t			length,
-	int			flags)
-{
-	xfs_buf_t		*bp;
-	int			error;
-
-	bp = xfs_buf_get_uncached(target, length, flags);
-	if (!bp)
-		return NULL;
-
-	/* set up the buffer for a read IO */
-	XFS_BUF_SET_ADDR(bp, daddr);
-	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
-
-	xfsbdstrat(mp, bp);
-	error = xfs_buf_iowait(bp);
-	if (error || bp->b_error) {
-		xfs_buf_relse(bp);
-		return NULL;
-	}
-	return bp;
-}
-
-xfs_buf_t *
-xfs_buf_get_empty(
-	size_t			len,
-	xfs_buftarg_t		*target)
-{
-	xfs_buf_t		*bp;
-
-	bp = xfs_buf_allocate(0);
-	if (bp)
-		_xfs_buf_initialize(bp, target, 0, len, 0);
-	return bp;
-}
-
-/*
- * Return a buffer allocated as an empty buffer and associated to external
- * memory via xfs_buf_associate_memory() back to it's empty state.
- */
-void
-xfs_buf_set_empty(
-	struct xfs_buf		*bp,
-	size_t			len)
-{
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_page_count = 0;
-	bp->b_addr = NULL;
-	bp->b_file_offset = 0;
-	bp->b_buffer_length = bp->b_count_desired = len;
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_flags &= ~XBF_MAPPED;
-}
-
-static inline struct page *
-mem_to_page(
-	void			*addr)
-{
-	if ((!is_vmalloc_addr(addr))) {
-		return virt_to_page(addr);
-	} else {
-		return vmalloc_to_page(addr);
-	}
-}
-
-int
-xfs_buf_associate_memory(
-	xfs_buf_t		*bp,
-	void			*mem,
-	size_t			len)
-{
-	int			rval;
-	int			i = 0;
-	unsigned long		pageaddr;
-	unsigned long		offset;
-	size_t			buflen;
-	int			page_count;
-
-	pageaddr = (unsigned long)mem & PAGE_MASK;
-	offset = (unsigned long)mem - pageaddr;
-	buflen = PAGE_ALIGN(len + offset);
-	page_count = buflen >> PAGE_SHIFT;
-
-	/* Free any previous set of page pointers */
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_addr = mem;
-
-	rval = _xfs_buf_get_pages(bp, page_count, XBF_DONT_BLOCK);
-	if (rval)
-		return rval;
-
-	bp->b_offset = offset;
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = mem_to_page((void *)pageaddr);
-		pageaddr += PAGE_SIZE;
-	}
-
-	bp->b_count_desired = len;
-	bp->b_buffer_length = buflen;
-	bp->b_flags |= XBF_MAPPED;
-
-	return 0;
-}
-
-xfs_buf_t *
-xfs_buf_get_uncached(
-	struct xfs_buftarg	*target,
-	size_t			len,
-	int			flags)
-{
-	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
-	int			error, i;
-	xfs_buf_t		*bp;
-
-	bp = xfs_buf_allocate(0);
-	if (unlikely(bp == NULL))
-		goto fail;
-	_xfs_buf_initialize(bp, target, 0, len, 0);
-
-	error = _xfs_buf_get_pages(bp, page_count, 0);
-	if (error)
-		goto fail_free_buf;
-
-	for (i = 0; i < page_count; i++) {
-		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i])
-			goto fail_free_mem;
-	}
-	bp->b_flags |= _XBF_PAGES;
-
-	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
-	if (unlikely(error)) {
-		xfs_warn(target->bt_mount,
-			"%s: failed to map pages\n", __func__);
-		goto fail_free_mem;
-	}
-
-	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	return bp;
-
- fail_free_mem:
-	while (--i >= 0)
-		__free_page(bp->b_pages[i]);
-	_xfs_buf_free_pages(bp);
- fail_free_buf:
-	xfs_buf_deallocate(bp);
- fail:
-	return NULL;
-}
-
-/*
- *	Increment reference count on buffer, to hold the buffer concurrently
- *	with another thread which may release (free) the buffer asynchronously.
- *	Must hold the buffer already to call this function.
- */
-void
-xfs_buf_hold(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_hold(bp, _RET_IP_);
-	atomic_inc(&bp->b_hold);
-}
-
-/*
- *	Releases a hold on the specified buffer.  If the
- *	the hold count is 1, calls xfs_buf_free.
- */
-void
-xfs_buf_rele(
-	xfs_buf_t		*bp)
-{
-	struct xfs_perag	*pag = bp->b_pag;
-
-	trace_xfs_buf_rele(bp, _RET_IP_);
-
-	if (!pag) {
-		ASSERT(list_empty(&bp->b_lru));
-		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
-		if (atomic_dec_and_test(&bp->b_hold))
-			xfs_buf_free(bp);
-		return;
-	}
-
-	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
-
-	ASSERT(atomic_read(&bp->b_hold) > 0);
-	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
-		if (!(bp->b_flags & XBF_STALE) &&
-			   atomic_read(&bp->b_lru_ref)) {
-			xfs_buf_lru_add(bp);
-			spin_unlock(&pag->pag_buf_lock);
-		} else {
-			xfs_buf_lru_del(bp);
-			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
-			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
-			spin_unlock(&pag->pag_buf_lock);
-			xfs_perag_put(pag);
-			xfs_buf_free(bp);
-		}
-	}
-}
-
-
-/*
- *	Lock a buffer object, if it is not already locked.
- *
- *	If we come across a stale, pinned, locked buffer, we know that we are
- *	being asked to lock a buffer that has been reallocated. Because it is
- *	pinned, we know that the log has not been pushed to disk and hence it
- *	will still be locked.  Rather than continuing to have trylock attempts
- *	fail until someone else pushes the log, push it ourselves before
- *	returning.  This means that the xfsaild will not get stuck trying
- *	to push on stale inode buffers.
- */
-int
-xfs_buf_trylock(
-	struct xfs_buf		*bp)
-{
-	int			locked;
-
-	locked = down_trylock(&bp->b_sema) == 0;
-	if (locked)
-		XB_SET_OWNER(bp);
-	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
-		xfs_log_force(bp->b_target->bt_mount, 0);
-
-	trace_xfs_buf_trylock(bp, _RET_IP_);
-	return locked;
-}
-
-/*
- *	Lock a buffer object.
- *
- *	If we come across a stale, pinned, locked buffer, we know that we
- *	are being asked to lock a buffer that has been reallocated. Because
- *	it is pinned, we know that the log has not been pushed to disk and
- *	hence it will still be locked. Rather than sleeping until someone
- *	else pushes the log, push it ourselves before trying to get the lock.
- */
-void
-xfs_buf_lock(
-	struct xfs_buf		*bp)
-{
-	trace_xfs_buf_lock(bp, _RET_IP_);
-
-	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
-		xfs_log_force(bp->b_target->bt_mount, 0);
-	down(&bp->b_sema);
-	XB_SET_OWNER(bp);
-
-	trace_xfs_buf_lock_done(bp, _RET_IP_);
-}
-
-/*
- *	Releases the lock on the buffer object.
- *	If the buffer is marked delwri but is not queued, do so before we
- *	unlock the buffer as we need to set flags correctly.  We also need to
- *	take a reference for the delwri queue because the unlocker is going to
- *	drop their's and they don't know we just queued it.
- */
-void
-xfs_buf_unlock(
-	struct xfs_buf		*bp)
-{
-	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
-		atomic_inc(&bp->b_hold);
-		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_delwri_queue(bp, 0);
-	}
-
-	XB_CLEAR_OWNER(bp);
-	up(&bp->b_sema);
-
-	trace_xfs_buf_unlock(bp, _RET_IP_);
-}
-
-STATIC void
-xfs_buf_wait_unpin(
-	xfs_buf_t		*bp)
-{
-	DECLARE_WAITQUEUE	(wait, current);
-
-	if (atomic_read(&bp->b_pin_count) == 0)
-		return;
-
-	add_wait_queue(&bp->b_waiters, &wait);
-	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&bp->b_pin_count) == 0)
-			break;
-		io_schedule();
-	}
-	remove_wait_queue(&bp->b_waiters, &wait);
-	set_current_state(TASK_RUNNING);
-}
-
-/*
- *	Buffer Utility Routines
- */
-
-STATIC void
-xfs_buf_iodone_work(
-	struct work_struct	*work)
-{
-	xfs_buf_t		*bp =
-		container_of(work, xfs_buf_t, b_iodone_work);
-
-	if (bp->b_iodone)
-		(*(bp->b_iodone))(bp);
-	else if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-}
-
-void
-xfs_buf_ioend(
-	xfs_buf_t		*bp,
-	int			schedule)
-{
-	trace_xfs_buf_iodone(bp, _RET_IP_);
-
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-	if (bp->b_error == 0)
-		bp->b_flags |= XBF_DONE;
-
-	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
-		if (schedule) {
-			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
-			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
-		} else {
-			xfs_buf_iodone_work(&bp->b_iodone_work);
-		}
-	} else {
-		complete(&bp->b_iowait);
-	}
-}
-
-void
-xfs_buf_ioerror(
-	xfs_buf_t		*bp,
-	int			error)
-{
-	ASSERT(error >= 0 && error <= 0xffff);
-	bp->b_error = (unsigned short)error;
-	trace_xfs_buf_ioerror(bp, error, _RET_IP_);
-}
-
-int
-xfs_bwrite(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	int			error;
-
-	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
-
-	xfs_buf_delwri_dequeue(bp);
-	xfs_bdstrat_cb(bp);
-
-	error = xfs_buf_iowait(bp);
-	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-	xfs_buf_relse(bp);
-	return error;
-}
-
-void
-xfs_bdwrite(
-	void			*mp,
-	struct xfs_buf		*bp)
-{
-	trace_xfs_buf_bdwrite(bp, _RET_IP_);
-
-	bp->b_flags &= ~XBF_READ;
-	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
-
-	xfs_buf_delwri_queue(bp, 1);
-}
-
-/*
- * Called when we want to stop a buffer from getting written or read.
- * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
- * so that the proper iodone callbacks get called.
- */
-STATIC int
-xfs_bioerror(
-	xfs_buf_t *bp)
-{
-#ifdef XFSERRORDEBUG
-	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
-#endif
-
-	/*
-	 * No need to wait until the buffer is unpinned, we aren't flushing it.
-	 */
-	XFS_BUF_ERROR(bp, EIO);
-
-	/*
-	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
-	XFS_BUF_UNDONE(bp);
-	XFS_BUF_STALE(bp);
-
-	xfs_buf_ioend(bp, 0);
-
-	return EIO;
-}
-
-/*
- * Same as xfs_bioerror, except that we are releasing the buffer
- * here ourselves, and avoiding the xfs_buf_ioend call.
- * This is meant for userdata errors; metadata bufs come with
- * iodone functions attached, so that we can track down errors.
- */
-STATIC int
-xfs_bioerror_relse(
-	struct xfs_buf	*bp)
-{
-	int64_t		fl = XFS_BUF_BFLAGS(bp);
-	/*
-	 * No need to wait until the buffer is unpinned.
-	 * We aren't flushing it.
-	 *
-	 * chunkhold expects B_DONE to be set, whether
-	 * we actually finish the I/O or not. We don't want to
-	 * change that interface.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
-	XFS_BUF_DONE(bp);
-	XFS_BUF_STALE(bp);
-	bp->b_iodone = NULL;
-	if (!(fl & XBF_ASYNC)) {
-		/*
-		 * Mark b_error and B_ERROR _both_.
-		 * Lot's of chunkcache code assumes that.
-		 * There's no reason to mark error for
-		 * ASYNC buffers.
-		 */
-		XFS_BUF_ERROR(bp, EIO);
-		XFS_BUF_FINISH_IOWAIT(bp);
-	} else {
-		xfs_buf_relse(bp);
-	}
-
-	return EIO;
-}
-
-
-/*
- * All xfs metadata buffers except log state machine buffers
- * get this attached as their b_bdstrat callback function.
- * This is so that we can catch a buffer
- * after prematurely unpinning it to forcibly shutdown the filesystem.
- */
-int
-xfs_bdstrat_cb(
-	struct xfs_buf	*bp)
-{
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-		/*
-		 * Metadata write that didn't get logged but
-		 * written delayed anyway. These aren't associated
-		 * with a transaction, and can be ignored.
-		 */
-		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
-			return xfs_bioerror_relse(bp);
-		else
-			return xfs_bioerror(bp);
-	}
-
-	xfs_buf_iorequest(bp);
-	return 0;
-}
-
-/*
- * Wrapper around bdstrat so that we can stop data from going to disk in case
- * we are shutting down the filesystem.  Typically user data goes thru this
- * path; one of the exceptions is the superblock.
- */
-void
-xfsbdstrat(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-		xfs_bioerror_relse(bp);
-		return;
-	}
-
-	xfs_buf_iorequest(bp);
-}
-
-STATIC void
-_xfs_buf_ioend(
-	xfs_buf_t		*bp,
-	int			schedule)
-{
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend(bp, schedule);
-}
-
-STATIC void
-xfs_buf_bio_end_io(
-	struct bio		*bio,
-	int			error)
-{
-	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
-
-	xfs_buf_ioerror(bp, -error);
-
-	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
-		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
-
-	_xfs_buf_ioend(bp, 1);
-	bio_put(bio);
-}
-
-STATIC void
-_xfs_buf_ioapply(
-	xfs_buf_t		*bp)
-{
-	int			rw, map_i, total_nr_pages, nr_pages;
-	struct bio		*bio;
-	int			offset = bp->b_offset;
-	int			size = bp->b_count_desired;
-	sector_t		sector = bp->b_bn;
-
-	total_nr_pages = bp->b_page_count;
-	map_i = 0;
-
-	if (bp->b_flags & XBF_WRITE) {
-		if (bp->b_flags & XBF_SYNCIO)
-			rw = WRITE_SYNC;
-		else
-			rw = WRITE;
-		if (bp->b_flags & XBF_FUA)
-			rw |= REQ_FUA;
-		if (bp->b_flags & XBF_FLUSH)
-			rw |= REQ_FLUSH;
-	} else if (bp->b_flags & XBF_READ_AHEAD) {
-		rw = READA;
-	} else {
-		rw = READ;
-	}
-
-next_chunk:
-	atomic_inc(&bp->b_io_remaining);
-	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
-	if (nr_pages > total_nr_pages)
-		nr_pages = total_nr_pages;
-
-	bio = bio_alloc(GFP_NOIO, nr_pages);
-	bio->bi_bdev = bp->b_target->bt_bdev;
-	bio->bi_sector = sector;
-	bio->bi_end_io = xfs_buf_bio_end_io;
-	bio->bi_private = bp;
-
-
-	for (; size && nr_pages; nr_pages--, map_i++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
-
-		if (nbytes > size)
-			nbytes = size;
-
-		rbytes = bio_add_page(bio, bp->b_pages[map_i], nbytes, offset);
-		if (rbytes < nbytes)
-			break;
-
-		offset = 0;
-		sector += nbytes >> BBSHIFT;
-		size -= nbytes;
-		total_nr_pages--;
-	}
-
-	if (likely(bio->bi_size)) {
-		if (xfs_buf_is_vmapped(bp)) {
-			flush_kernel_vmap_range(bp->b_addr,
-						xfs_buf_vmap_len(bp));
-		}
-		submit_bio(rw, bio);
-		if (size)
-			goto next_chunk;
-	} else {
-		xfs_buf_ioerror(bp, EIO);
-		bio_put(bio);
-	}
-}
-
-int
-xfs_buf_iorequest(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_iorequest(bp, _RET_IP_);
-
-	if (bp->b_flags & XBF_DELWRI) {
-		xfs_buf_delwri_queue(bp, 1);
-		return 0;
-	}
-
-	if (bp->b_flags & XBF_WRITE) {
-		xfs_buf_wait_unpin(bp);
-	}
-
-	xfs_buf_hold(bp);
-
-	/* Set the count to 1 initially, this will stop an I/O
-	 * completion callout which happens before we have started
-	 * all the I/O from calling xfs_buf_ioend too early.
-	 */
-	atomic_set(&bp->b_io_remaining, 1);
-	_xfs_buf_ioapply(bp);
-	_xfs_buf_ioend(bp, 0);
-
-	xfs_buf_rele(bp);
-	return 0;
-}
-
-/*
- *	Waits for I/O to complete on the buffer supplied.
- *	It returns immediately if no I/O is pending.
- *	It returns the I/O error code, if any, or 0 if there was no error.
- */
-int
-xfs_buf_iowait(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_iowait(bp, _RET_IP_);
-
-	wait_for_completion(&bp->b_iowait);
-
-	trace_xfs_buf_iowait_done(bp, _RET_IP_);
-	return bp->b_error;
-}
-
-xfs_caddr_t
-xfs_buf_offset(
-	xfs_buf_t		*bp,
-	size_t			offset)
-{
-	struct page		*page;
-
-	if (bp->b_flags & XBF_MAPPED)
-		return XFS_BUF_PTR(bp) + offset;
-
-	offset += bp->b_offset;
-	page = bp->b_pages[offset >> PAGE_SHIFT];
-	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_SIZE-1));
-}
-
-/*
- *	Move data into or out of a buffer.
- */
-void
-xfs_buf_iomove(
-	xfs_buf_t		*bp,	/* buffer to process		*/
-	size_t			boff,	/* starting buffer offset	*/
-	size_t			bsize,	/* length to copy		*/
-	void			*data,	/* data address			*/
-	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
-{
-	size_t			bend, cpoff, csize;
-	struct page		*page;
-
-	bend = boff + bsize;
-	while (boff < bend) {
-		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
-		cpoff = xfs_buf_poff(boff + bp->b_offset);
-		csize = min_t(size_t,
-			      PAGE_SIZE-cpoff, bp->b_count_desired-boff);
-
-		ASSERT(((csize + cpoff) <= PAGE_SIZE));
-
-		switch (mode) {
-		case XBRW_ZERO:
-			memset(page_address(page) + cpoff, 0, csize);
-			break;
-		case XBRW_READ:
-			memcpy(data, page_address(page) + cpoff, csize);
-			break;
-		case XBRW_WRITE:
-			memcpy(page_address(page) + cpoff, data, csize);
-		}
-
-		boff += csize;
-		data += csize;
-	}
-}
-
-/*
- *	Handling of buffer targets (buftargs).
- */
-
-/*
- * Wait for any bufs with callbacks that have been submitted but have not yet
- * returned. These buffers will have an elevated hold count, so wait on those
- * while freeing all the buffers only held by the LRU.
- */
-void
-xfs_wait_buftarg(
-	struct xfs_buftarg	*btp)
-{
-	struct xfs_buf		*bp;
-
-restart:
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-		if (atomic_read(&bp->b_hold) > 1) {
-			spin_unlock(&btp->bt_lru_lock);
-			delay(100);
-			goto restart;
-		}
-		/*
-		 * clear the LRU reference count so the bufer doesn't get
-		 * ignored in xfs_buf_rele().
-		 */
-		atomic_set(&bp->b_lru_ref, 0);
-		spin_unlock(&btp->bt_lru_lock);
-		xfs_buf_rele(bp);
-		spin_lock(&btp->bt_lru_lock);
-	}
-	spin_unlock(&btp->bt_lru_lock);
-}
-
-int
-xfs_buftarg_shrink(
-	struct shrinker		*shrink,
-	struct shrink_control	*sc)
-{
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
-	struct xfs_buf		*bp;
-	int nr_to_scan = sc->nr_to_scan;
-	LIST_HEAD(dispose);
-
-	if (!nr_to_scan)
-		return btp->bt_lru_nr;
-
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		if (nr_to_scan-- <= 0)
-			break;
-
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-
-		/*
-		 * Decrement the b_lru_ref count unless the value is already
-		 * zero. If the value is already zero, we need to reclaim the
-		 * buffer, otherwise it gets another trip through the LRU.
-		 */
-		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
-			list_move_tail(&bp->b_lru, &btp->bt_lru);
-			continue;
-		}
-
-		/*
-		 * remove the buffer from the LRU now to avoid needing another
-		 * lock round trip inside xfs_buf_rele().
-		 */
-		list_move(&bp->b_lru, &dispose);
-		btp->bt_lru_nr--;
-	}
-	spin_unlock(&btp->bt_lru_lock);
-
-	while (!list_empty(&dispose)) {
-		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
-		list_del_init(&bp->b_lru);
-		xfs_buf_rele(bp);
-	}
-
-	return btp->bt_lru_nr;
-}
-
-void
-xfs_free_buftarg(
-	struct xfs_mount	*mp,
-	struct xfs_buftarg	*btp)
-{
-	unregister_shrinker(&btp->bt_shrinker);
-
-	xfs_flush_buftarg(btp, 1);
-	if (mp->m_flags & XFS_MOUNT_BARRIER)
-		xfs_blkdev_issue_flush(btp);
-
-	kthread_stop(btp->bt_task);
-	kmem_free(btp);
-}
-
-STATIC int
-xfs_setsize_buftarg_flags(
-	xfs_buftarg_t		*btp,
-	unsigned int		blocksize,
-	unsigned int		sectorsize,
-	int			verbose)
-{
-	btp->bt_bsize = blocksize;
-	btp->bt_sshift = ffs(sectorsize) - 1;
-	btp->bt_smask = sectorsize - 1;
-
-	if (set_blocksize(btp->bt_bdev, sectorsize)) {
-		xfs_warn(btp->bt_mount,
-			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, XFS_BUFTARG_NAME(btp));
-		return EINVAL;
-	}
-
-	return 0;
-}
-
-/*
- *	When allocating the initial buffer target we have not yet
- *	read in the superblock, so don't know what sized sectors
- *	are being used is at this early stage.  Play safe.
- */
-STATIC int
-xfs_setsize_buftarg_early(
-	xfs_buftarg_t		*btp,
-	struct block_device	*bdev)
-{
-	return xfs_setsize_buftarg_flags(btp,
-			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
-}
-
-int
-xfs_setsize_buftarg(
-	xfs_buftarg_t		*btp,
-	unsigned int		blocksize,
-	unsigned int		sectorsize)
-{
-	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
-}
-
-STATIC int
-xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp,
-	const char		*fsname)
-{
-	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
-	spin_lock_init(&btp->bt_delwrite_lock);
-	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
-	if (IS_ERR(btp->bt_task))
-		return PTR_ERR(btp->bt_task);
-	return 0;
-}
-
-xfs_buftarg_t *
-xfs_alloc_buftarg(
-	struct xfs_mount	*mp,
-	struct block_device	*bdev,
-	int			external,
-	const char		*fsname)
-{
-	xfs_buftarg_t		*btp;
-
-	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
-
-	btp->bt_mount = mp;
-	btp->bt_dev =  bdev->bd_dev;
-	btp->bt_bdev = bdev;
-	btp->bt_bdi = blk_get_backing_dev_info(bdev);
-	if (!btp->bt_bdi)
-		goto error;
-
-	INIT_LIST_HEAD(&btp->bt_lru);
-	spin_lock_init(&btp->bt_lru_lock);
-	if (xfs_setsize_buftarg_early(btp, bdev))
-		goto error;
-	if (xfs_alloc_delwrite_queue(btp, fsname))
-		goto error;
-	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
-	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
-	register_shrinker(&btp->bt_shrinker);
-	return btp;
-
-error:
-	kmem_free(btp);
-	return NULL;
-}
-
-
-/*
- *	Delayed write buffer handling
- */
-STATIC void
-xfs_buf_delwri_queue(
-	xfs_buf_t		*bp,
-	int			unlock)
-{
-	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
-
-	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
-
-	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
-
-	spin_lock(dwlk);
-	/* If already in the queue, dequeue and place at tail */
-	if (!list_empty(&bp->b_list)) {
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		if (unlock)
-			atomic_dec(&bp->b_hold);
-		list_del(&bp->b_list);
-	}
-
-	if (list_empty(dwq)) {
-		/* start xfsbufd as it is about to have something to do */
-		wake_up_process(bp->b_target->bt_task);
-	}
-
-	bp->b_flags |= _XBF_DELWRI_Q;
-	list_add_tail(&bp->b_list, dwq);
-	bp->b_queuetime = jiffies;
-	spin_unlock(dwlk);
-
-	if (unlock)
-		xfs_buf_unlock(bp);
-}
-
-void
-xfs_buf_delwri_dequeue(
-	xfs_buf_t		*bp)
-{
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
-	int			dequeued = 0;
-
-	spin_lock(dwlk);
-	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		list_del_init(&bp->b_list);
-		dequeued = 1;
-	}
-	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
-	spin_unlock(dwlk);
-
-	if (dequeued)
-		xfs_buf_rele(bp);
-
-	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
-}
-
-/*
- * If a delwri buffer needs to be pushed before it has aged out, then promote
- * it to the head of the delwri queue so that it will be flushed on the next
- * xfsbufd run. We do this by resetting the queuetime of the buffer to be older
- * than the age currently needed to flush the buffer. Hence the next time the
- * xfsbufd sees it is guaranteed to be considered old enough to flush.
- */
-void
-xfs_buf_delwri_promote(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buftarg *btp = bp->b_target;
-	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
-
-	ASSERT(bp->b_flags & XBF_DELWRI);
-	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-
-	/*
-	 * Check the buffer age before locking the delayed write queue as we
-	 * don't need to promote buffers that are already past the flush age.
-	 */
-	if (bp->b_queuetime < jiffies - age)
-		return;
-	bp->b_queuetime = jiffies - age;
-	spin_lock(&btp->bt_delwrite_lock);
-	list_move(&bp->b_list, &btp->bt_delwrite_queue);
-	spin_unlock(&btp->bt_delwrite_lock);
-}
-
-STATIC void
-xfs_buf_runall_queues(
-	struct workqueue_struct	*queue)
-{
-	flush_workqueue(queue);
-}
-
-/*
- * Move as many buffers as specified to the supplied list
- * idicating if we skipped any buffers to prevent deadlocks.
- */
-STATIC int
-xfs_buf_delwri_split(
-	xfs_buftarg_t	*target,
-	struct list_head *list,
-	unsigned long	age)
-{
-	xfs_buf_t	*bp, *n;
-	struct list_head *dwq = &target->bt_delwrite_queue;
-	spinlock_t	*dwlk = &target->bt_delwrite_lock;
-	int		skipped = 0;
-	int		force;
-
-	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	INIT_LIST_HEAD(list);
-	spin_lock(dwlk);
-	list_for_each_entry_safe(bp, n, dwq, b_list) {
-		ASSERT(bp->b_flags & XBF_DELWRI);
-
-		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
-			if (!force &&
-			    time_before(jiffies, bp->b_queuetime + age)) {
-				xfs_buf_unlock(bp);
-				break;
-			}
-
-			bp->b_flags &= ~(XBF_DELWRI | _XBF_DELWRI_Q);
-			bp->b_flags |= XBF_WRITE;
-			list_move_tail(&bp->b_list, list);
-			trace_xfs_buf_delwri_split(bp, _RET_IP_);
-		} else
-			skipped++;
-	}
-	spin_unlock(dwlk);
-
-	return skipped;
-
-}
-
-/*
- * Compare function is more complex than it needs to be because
- * the return value is only 32 bits and we are doing comparisons
- * on 64 bit values
- */
-static int
-xfs_buf_cmp(
-	void		*priv,
-	struct list_head *a,
-	struct list_head *b)
-{
-	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
-	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
-	xfs_daddr_t		diff;
-
-	diff = ap->b_bn - bp->b_bn;
-	if (diff < 0)
-		return -1;
-	if (diff > 0)
-		return 1;
-	return 0;
-}
-
-STATIC int
-xfsbufd(
-	void		*data)
-{
-	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
-
-	current->flags |= PF_MEMALLOC;
-
-	set_freezable();
-
-	do {
-		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
-		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
-		struct list_head tmp;
-		struct blk_plug plug;
-
-		if (unlikely(freezing(current))) {
-			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-			refrigerator();
-		} else {
-			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-		}
-
-		/* sleep for a long time if there is nothing to do. */
-		if (list_empty(&target->bt_delwrite_queue))
-			tout = MAX_SCHEDULE_TIMEOUT;
-		schedule_timeout_interruptible(tout);
-
-		xfs_buf_delwri_split(target, &tmp, age);
-		list_sort(NULL, &tmp, xfs_buf_cmp);
-
-		blk_start_plug(&plug);
-		while (!list_empty(&tmp)) {
-			struct xfs_buf *bp;
-			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
-			list_del_init(&bp->b_list);
-			xfs_bdstrat_cb(bp);
-		}
-		blk_finish_plug(&plug);
-	} while (!kthread_should_stop());
-
-	return 0;
-}
-
-/*
- *	Go through all incore buffers, and release buffers if they belong to
- *	the given device. This is used in filesystem error handling to
- *	preserve the consistency of its metadata.
- */
-int
-xfs_flush_buftarg(
-	xfs_buftarg_t	*target,
-	int		wait)
-{
-	xfs_buf_t	*bp;
-	int		pincount = 0;
-	LIST_HEAD(tmp_list);
-	LIST_HEAD(wait_list);
-	struct blk_plug plug;
-
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
-
-	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
-
-	/*
-	 * Dropped the delayed write list lock, now walk the temporary list.
-	 * All I/O is issued async and then if we need to wait for completion
-	 * we do that after issuing all the IO.
-	 */
-	list_sort(NULL, &tmp_list, xfs_buf_cmp);
-
-	blk_start_plug(&plug);
-	while (!list_empty(&tmp_list)) {
-		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
-		ASSERT(target == bp->b_target);
-		list_del_init(&bp->b_list);
-		if (wait) {
-			bp->b_flags &= ~XBF_ASYNC;
-			list_add(&bp->b_list, &wait_list);
-		}
-		xfs_bdstrat_cb(bp);
-	}
-	blk_finish_plug(&plug);
-
-	if (wait) {
-		/* Wait for IO to complete. */
-		while (!list_empty(&wait_list)) {
-			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
-
-			list_del_init(&bp->b_list);
-			xfs_buf_iowait(bp);
-			xfs_buf_relse(bp);
-		}
-	}
-
-	return pincount;
-}
-
-int __init
-xfs_buf_init(void)
-{
-	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
-						KM_ZONE_HWALIGN, NULL);
-	if (!xfs_buf_zone)
-		goto out;
-
-	xfslogd_workqueue = alloc_workqueue("xfslogd",
-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
-	if (!xfslogd_workqueue)
-		goto out_free_buf_zone;
-
-	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
-	if (!xfsdatad_workqueue)
-		goto out_destroy_xfslogd_workqueue;
-
-	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
-						WQ_MEM_RECLAIM, 1);
-	if (!xfsconvertd_workqueue)
-		goto out_destroy_xfsdatad_workqueue;
-
-	return 0;
-
- out_destroy_xfsdatad_workqueue:
-	destroy_workqueue(xfsdatad_workqueue);
- out_destroy_xfslogd_workqueue:
-	destroy_workqueue(xfslogd_workqueue);
- out_free_buf_zone:
-	kmem_zone_destroy(xfs_buf_zone);
- out:
-	return -ENOMEM;
-}
-
-void
-xfs_buf_terminate(void)
-{
-	destroy_workqueue(xfsconvertd_workqueue);
-	destroy_workqueue(xfsdatad_workqueue);
-	destroy_workqueue(xfslogd_workqueue);
-	kmem_zone_destroy(xfs_buf_zone);
-}
-
-#ifdef CONFIG_KDB_MODULES
-struct list_head *
-xfs_get_buftarg_list(void)
-{
-	return &xfs_buftarg_list;
-}
-#endif
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
deleted file mode 100644
index 6a83b46..0000000
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ /dev/null
@@ -1,336 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_BUF_H__
-#define __XFS_BUF_H__
-
-#include <linux/list.h>
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <asm/system.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/buffer_head.h>
-#include <linux/uio.h>
-
-/*
- *	Base types
- */
-
-#define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
-
-#define xfs_buf_ctob(pp)	((pp) * PAGE_CACHE_SIZE)
-#define xfs_buf_btoc(dd)	(((dd) + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT)
-#define xfs_buf_btoct(dd)	((dd) >> PAGE_CACHE_SHIFT)
-#define xfs_buf_poff(aa)	((aa) & ~PAGE_CACHE_MASK)
-
-typedef enum {
-	XBRW_READ = 1,			/* transfer into target memory */
-	XBRW_WRITE = 2,			/* transfer from target memory */
-	XBRW_ZERO = 3,			/* Zero target memory */
-} xfs_buf_rw_t;
-
-#define XBF_READ	(1 << 0) /* buffer intended for reading from device */
-#define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
-#define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
-#define XBF_MAPPED	(1 << 3) /* buffer mapped (b_addr valid) */
-#define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
-#define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
-#define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
-#define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
-
-/* I/O hints for the BIO layer */
-#define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
-#define XBF_FUA		(1 << 11)/* force cache write through mode */
-#define XBF_FLUSH	(1 << 12)/* flush the disk cache before a write */
-
-/* flags used only as arguments to access routines */
-#define XBF_LOCK	(1 << 15)/* lock requested */
-#define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
-#define XBF_DONT_BLOCK	(1 << 17)/* do not block in current thread */
-
-/* flags used only internally */
-#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
-#define _XBF_KMEM	(1 << 21)/* backed by heap memory */
-#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
-
-typedef unsigned int xfs_buf_flags_t;
-
-#define XFS_BUF_FLAGS \
-	{ XBF_READ,		"READ" }, \
-	{ XBF_WRITE,		"WRITE" }, \
-	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
-	{ XBF_MAPPED,		"MAPPED" }, \
-	{ XBF_ASYNC,		"ASYNC" }, \
-	{ XBF_DONE,		"DONE" }, \
-	{ XBF_DELWRI,		"DELWRI" }, \
-	{ XBF_STALE,		"STALE" }, \
-	{ XBF_SYNCIO,		"SYNCIO" }, \
-	{ XBF_FUA,		"FUA" }, \
-	{ XBF_FLUSH,		"FLUSH" }, \
-	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
-	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
-	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
-	{ _XBF_PAGES,		"PAGES" }, \
-	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
-
-typedef enum {
-	XBT_FORCE_SLEEP = 0,
-	XBT_FORCE_FLUSH = 1,
-} xfs_buftarg_flags_t;
-
-typedef struct xfs_buftarg {
-	dev_t			bt_dev;
-	struct block_device	*bt_bdev;
-	struct backing_dev_info	*bt_bdi;
-	struct xfs_mount	*bt_mount;
-	unsigned int		bt_bsize;
-	unsigned int		bt_sshift;
-	size_t			bt_smask;
-
-	/* per device delwri queue */
-	struct task_struct	*bt_task;
-	struct list_head	bt_delwrite_queue;
-	spinlock_t		bt_delwrite_lock;
-	unsigned long		bt_flags;
-
-	/* LRU control structures */
-	struct shrinker		bt_shrinker;
-	struct list_head	bt_lru;
-	spinlock_t		bt_lru_lock;
-	unsigned int		bt_lru_nr;
-} xfs_buftarg_t;
-
-struct xfs_buf;
-typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
-
-#define XB_PAGES	2
-
-typedef struct xfs_buf {
-	/*
-	 * first cacheline holds all the fields needed for an uncontended cache
-	 * hit to be fully processed. The semaphore straddles the cacheline
-	 * boundary, but the counter and lock sits on the first cacheline,
-	 * which is the only bit that is touched if we hit the semaphore
-	 * fast-path on locking.
-	 */
-	struct rb_node		b_rbnode;	/* rbtree node */
-	xfs_off_t		b_file_offset;	/* offset in file */
-	size_t			b_buffer_length;/* size of buffer in bytes */
-	atomic_t		b_hold;		/* reference count */
-	atomic_t		b_lru_ref;	/* lru reclaim ref count */
-	xfs_buf_flags_t		b_flags;	/* status flags */
-	struct semaphore	b_sema;		/* semaphore for lockables */
-
-	struct list_head	b_lru;		/* lru list */
-	wait_queue_head_t	b_waiters;	/* unpin waiters */
-	struct list_head	b_list;
-	struct xfs_perag	*b_pag;		/* contains rbtree root */
-	xfs_buftarg_t		*b_target;	/* buffer target (device) */
-	xfs_daddr_t		b_bn;		/* block number for I/O */
-	size_t			b_count_desired;/* desired transfer size */
-	void			*b_addr;	/* virtual address of buffer */
-	struct work_struct	b_iodone_work;
-	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
-	struct completion	b_iowait;	/* queue for I/O waiters */
-	void			*b_fspriv;
-	struct xfs_trans	*b_transp;
-	struct page		**b_pages;	/* array of page pointers */
-	struct page		*b_page_array[XB_PAGES]; /* inline pages */
-	unsigned long		b_queuetime;	/* time buffer was queued */
-	atomic_t		b_pin_count;	/* pin count */
-	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
-	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset in first page */
-	unsigned short		b_error;	/* error code on I/O */
-#ifdef XFS_BUF_LOCK_TRACKING
-	int			b_last_holder;
-#endif
-} xfs_buf_t;
-
-
-/* Finding and Reading Buffers */
-extern xfs_buf_t *_xfs_buf_find(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t, xfs_buf_t *);
-#define xfs_incore(buftarg,blkno,len,lockit) \
-	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
-
-extern xfs_buf_t *xfs_buf_get(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t);
-extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t);
-
-extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
-extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
-extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
-extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
-extern void xfs_buf_hold(xfs_buf_t *);
-extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t);
-struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
-				struct xfs_buftarg *target,
-				xfs_daddr_t daddr, size_t length, int flags);
-
-/* Releasing Buffers */
-extern void xfs_buf_free(xfs_buf_t *);
-extern void xfs_buf_rele(xfs_buf_t *);
-
-/* Locking and Unlocking Buffers */
-extern int xfs_buf_trylock(xfs_buf_t *);
-extern void xfs_buf_lock(xfs_buf_t *);
-extern void xfs_buf_unlock(xfs_buf_t *);
-#define xfs_buf_islocked(bp) \
-	((bp)->b_sema.count <= 0)
-
-/* Buffer Read and Write Routines */
-extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
-extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
-
-extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
-extern int xfs_bdstrat_cb(struct xfs_buf *);
-
-extern void xfs_buf_ioend(xfs_buf_t *,	int);
-extern void xfs_buf_ioerror(xfs_buf_t *, int);
-extern int xfs_buf_iorequest(xfs_buf_t *);
-extern int xfs_buf_iowait(xfs_buf_t *);
-extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
-				xfs_buf_rw_t);
-#define xfs_buf_zero(bp, off, len) \
-	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
-
-static inline int xfs_buf_geterror(xfs_buf_t *bp)
-{
-	return bp ? bp->b_error : ENOMEM;
-}
-
-/* Buffer Utility Routines */
-extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
-
-/* Delayed Write Buffer Routines */
-extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
-extern void xfs_buf_delwri_promote(xfs_buf_t *);
-
-/* Buffer Daemon Setup Routines */
-extern int xfs_buf_init(void);
-extern void xfs_buf_terminate(void);
-
-#define xfs_buf_target_name(target)	\
-	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
-
-
-#define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
-#define XFS_BUF_ZEROFLAGS(bp) \
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
-			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
-
-void xfs_buf_stale(struct xfs_buf *bp);
-#define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
-#define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
-#define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
-#define XFS_BUF_SUPER_STALE(bp)	do {				\
-					XFS_BUF_STALE(bp);	\
-					xfs_buf_delwri_dequeue(bp);	\
-					XFS_BUF_DONE(bp);	\
-				} while (0)
-
-#define XFS_BUF_DELAYWRITE(bp)		((bp)->b_flags |= XBF_DELWRI)
-#define XFS_BUF_UNDELAYWRITE(bp)	xfs_buf_delwri_dequeue(bp)
-#define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
-
-#define XFS_BUF_ERROR(bp,no)	xfs_buf_ioerror(bp,no)
-#define XFS_BUF_GETERROR(bp)	xfs_buf_geterror(bp)
-#define XFS_BUF_ISERROR(bp)	(xfs_buf_geterror(bp) ? 1 : 0)
-
-#define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
-#define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
-#define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
-
-#define XFS_BUF_BUSY(bp)	do { } while (0)
-#define XFS_BUF_UNBUSY(bp)	do { } while (0)
-#define XFS_BUF_ISBUSY(bp)	(1)
-
-#define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
-#define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
-#define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
-
-#define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
-#define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
-#define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
-#define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
-
-#define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
-#define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
-#define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
-
-#define XFS_BUF_SET_START(bp)			do { } while (0)
-
-#define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
-#define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
-#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
-#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
-#define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
-#define XFS_BUF_SET_OFFSET(bp, off)	((bp)->b_file_offset = (off))
-#define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
-#define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
-#define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
-#define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
-
-static inline void
-xfs_buf_set_ref(
-	struct xfs_buf	*bp,
-	int		lru_ref)
-{
-	atomic_set(&bp->b_lru_ref, lru_ref);
-}
-#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
-#define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
-
-#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
-
-#define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
-
-#define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
-#define XFS_BUF_TARGET(bp)		((bp)->b_target)
-#define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
-
-static inline void xfs_buf_relse(xfs_buf_t *bp)
-{
-	xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-}
-
-/*
- *	Handling of buftargs.
- */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
-			struct block_device *, int, const char *);
-extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
-extern void xfs_wait_buftarg(xfs_buftarg_t *);
-extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
-extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
-
-#ifdef CONFIG_KDB_MODULES
-extern struct list_head *xfs_get_buftarg_list(void);
-#endif
-
-#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
-#define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
-
-#define xfs_binval(buftarg)		xfs_flush_buftarg(buftarg, 1)
-#define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
-
-#endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_discard.c b/fs/xfs/linux-2.6/xfs_discard.c
deleted file mode 100644
index 244e797..0000000
--- a/fs/xfs/linux-2.6/xfs_discard.c
+++ /dev/null
@@ -1,222 +0,0 @@
-/*
- * Copyright (C) 2010 Red Hat, Inc.
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
-#include "xfs.h"
-#include "xfs_sb.h"
-#include "xfs_inum.h"
-#include "xfs_log.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_quota.h"
-#include "xfs_trans.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_btree.h"
-#include "xfs_inode.h"
-#include "xfs_alloc.h"
-#include "xfs_error.h"
-#include "xfs_discard.h"
-#include "xfs_trace.h"
-
-STATIC int
-xfs_trim_extents(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_fsblock_t		start,
-	xfs_fsblock_t		len,
-	xfs_fsblock_t		minlen,
-	__uint64_t		*blocks_trimmed)
-{
-	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
-	struct xfs_btree_cur	*cur;
-	struct xfs_buf		*agbp;
-	struct xfs_perag	*pag;
-	int			error;
-	int			i;
-
-	pag = xfs_perag_get(mp, agno);
-
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error || !agbp)
-		goto out_put_perag;
-
-	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
-
-	/*
-	 * Force out the log.  This means any transactions that might have freed
-	 * space before we took the AGF buffer lock are now on disk, and the
-	 * volatile disk cache is flushed.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Look up the longest btree in the AGF and start with it.
-	 */
-	error = xfs_alloc_lookup_le(cur, 0,
-				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
-	if (error)
-		goto out_del_cursor;
-
-	/*
-	 * Loop until we are done with all extents that are large
-	 * enough to be worth discarding.
-	 */
-	while (i) {
-		xfs_agblock_t fbno;
-		xfs_extlen_t flen;
-
-		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
-		if (error)
-			goto out_del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
-		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
-
-		/*
-		 * Too small?  Give up.
-		 */
-		if (flen < minlen) {
-			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
-			goto out_del_cursor;
-		}
-
-		/*
-		 * If the extent is entirely outside of the range we are
-		 * supposed to discard skip it.  Do not bother to trim
-		 * down partially overlapping ranges for now.
-		 */
-		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
-		    XFS_AGB_TO_FSB(mp, agno, fbno) >= start + len) {
-			trace_xfs_discard_exclude(mp, agno, fbno, flen);
-			goto next_extent;
-		}
-
-		/*
-		 * If any blocks in the range are still busy, skip the
-		 * discard and try again the next time.
-		 */
-		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
-			trace_xfs_discard_busy(mp, agno, fbno, flen);
-			goto next_extent;
-		}
-
-		trace_xfs_discard_extent(mp, agno, fbno, flen);
-		error = -blkdev_issue_discard(bdev,
-				XFS_AGB_TO_DADDR(mp, agno, fbno),
-				XFS_FSB_TO_BB(mp, flen),
-				GFP_NOFS, 0);
-		if (error)
-			goto out_del_cursor;
-		*blocks_trimmed += flen;
-
-next_extent:
-		error = xfs_btree_decrement(cur, 0, &i);
-		if (error)
-			goto out_del_cursor;
-	}
-
-out_del_cursor:
-	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
-	xfs_buf_relse(agbp);
-out_put_perag:
-	xfs_perag_put(pag);
-	return error;
-}
-
-int
-xfs_ioc_trim(
-	struct xfs_mount		*mp,
-	struct fstrim_range __user	*urange)
-{
-	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
-	unsigned int		granularity = q->limits.discard_granularity;
-	struct fstrim_range	range;
-	xfs_fsblock_t		start, len, minlen;
-	xfs_agnumber_t		start_agno, end_agno, agno;
-	__uint64_t		blocks_trimmed = 0;
-	int			error, last_error = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-	if (!blk_queue_discard(q))
-		return -XFS_ERROR(EOPNOTSUPP);
-	if (copy_from_user(&range, urange, sizeof(range)))
-		return -XFS_ERROR(EFAULT);
-
-	/*
-	 * Truncating down the len isn't actually quite correct, but using
-	 * XFS_B_TO_FSB would mean we trivially get overflows for values
-	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
-	 * used by the fstrim application.  In the end it really doesn't
-	 * matter as trimming blocks is an advisory interface.
-	 */
-	start = XFS_B_TO_FSBT(mp, range.start);
-	len = XFS_B_TO_FSBT(mp, range.len);
-	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
-
-	start_agno = XFS_FSB_TO_AGNO(mp, start);
-	if (start_agno >= mp->m_sb.sb_agcount)
-		return -XFS_ERROR(EINVAL);
-
-	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
-	if (end_agno >= mp->m_sb.sb_agcount)
-		end_agno = mp->m_sb.sb_agcount - 1;
-
-	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = -xfs_trim_extents(mp, agno, start, len, minlen,
-					  &blocks_trimmed);
-		if (error)
-			last_error = error;
-	}
-
-	if (last_error)
-		return last_error;
-
-	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
-	if (copy_to_user(urange, &range, sizeof(range)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-int
-xfs_discard_extents(
-	struct xfs_mount	*mp,
-	struct list_head	*list)
-{
-	struct xfs_busy_extent	*busyp;
-	int			error = 0;
-
-	list_for_each_entry(busyp, list, list) {
-		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
-					 busyp->length);
-
-		error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, 0);
-		if (error && error != EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llu,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			return error;
-		}
-	}
-
-	return 0;
-}
diff --git a/fs/xfs/linux-2.6/xfs_discard.h b/fs/xfs/linux-2.6/xfs_discard.h
deleted file mode 100644
index 344879a..0000000
--- a/fs/xfs/linux-2.6/xfs_discard.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef XFS_DISCARD_H
-#define XFS_DISCARD_H 1
-
-struct fstrim_range;
-struct list_head;
-
-extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
-extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
-
-#endif /* XFS_DISCARD_H */
diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
deleted file mode 100644
index 75e5d32..0000000
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ /dev/null
@@ -1,250 +0,0 @@
-/*
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_types.h"
-#include "xfs_inum.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_mount.h"
-#include "xfs_export.h"
-#include "xfs_vnodeops.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_trace.h"
-
-/*
- * Note that we only accept fileids which are long enough rather than allow
- * the parent generation number to default to zero.  XFS considers zero a
- * valid generation number not an invalid/wildcard value.
- */
-static int xfs_fileid_length(int fileid_type)
-{
-	switch (fileid_type) {
-	case FILEID_INO32_GEN:
-		return 2;
-	case FILEID_INO32_GEN_PARENT:
-		return 4;
-	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		return 3;
-	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		return 6;
-	}
-	return 255; /* invalid */
-}
-
-STATIC int
-xfs_fs_encode_fh(
-	struct dentry		*dentry,
-	__u32			*fh,
-	int			*max_len,
-	int			connectable)
-{
-	struct fid		*fid = (struct fid *)fh;
-	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
-	struct inode		*inode = dentry->d_inode;
-	int			fileid_type;
-	int			len;
-
-	/* Directories don't need their parent encoded, they have ".." */
-	if (S_ISDIR(inode->i_mode) || !connectable)
-		fileid_type = FILEID_INO32_GEN;
-	else
-		fileid_type = FILEID_INO32_GEN_PARENT;
-
-	/*
-	 * If the the filesystem may contain 64bit inode numbers, we need
-	 * to use larger file handles that can represent them.
-	 *
-	 * While we only allocate inodes that do not fit into 32 bits any
-	 * large enough filesystem may contain them, thus the slightly
-	 * confusing looking conditional below.
-	 */
-	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS) ||
-	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
-		fileid_type |= XFS_FILEID_TYPE_64FLAG;
-
-	/*
-	 * Only encode if there is enough space given.  In practice
-	 * this means we can't export a filesystem with 64bit inodes
-	 * over NFSv2 with the subtree_check export option; the other
-	 * seven combinations work.  The real answer is "don't use v2".
-	 */
-	len = xfs_fileid_length(fileid_type);
-	if (*max_len < len) {
-		*max_len = len;
-		return 255;
-	}
-	*max_len = len;
-
-	switch (fileid_type) {
-	case FILEID_INO32_GEN_PARENT:
-		spin_lock(&dentry->d_lock);
-		fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
-		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
-		/*FALLTHRU*/
-	case FILEID_INO32_GEN:
-		fid->i32.ino = inode->i_ino;
-		fid->i32.gen = inode->i_generation;
-		break;
-	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		spin_lock(&dentry->d_lock);
-		fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
-		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
-		/*FALLTHRU*/
-	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		fid64->ino = inode->i_ino;
-		fid64->gen = inode->i_generation;
-		break;
-	}
-
-	return fileid_type;
-}
-
-STATIC struct inode *
-xfs_nfs_get_inode(
-	struct super_block	*sb,
-	u64			ino,
-	u32			generation)
- {
- 	xfs_mount_t		*mp = XFS_M(sb);
-	xfs_inode_t		*ip;
-	int			error;
-
-	/*
-	 * NFS can sometimes send requests for ino 0.  Fail them gracefully.
-	 */
-	if (ino == 0)
-		return ERR_PTR(-ESTALE);
-
-	/*
-	 * The XFS_IGET_UNTRUSTED means that an invalid inode number is just
-	 * fine and not an indication of a corrupted filesystem as clients can
-	 * send invalid file handles and we have to handle it gracefully..
-	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
-	if (error) {
-		/*
-		 * EINVAL means the inode cluster doesn't exist anymore.
-		 * This implies the filehandle is stale, so we should
-		 * translate it here.
-		 * We don't use ESTALE directly down the chain to not
-		 * confuse applications using bulkstat that expect EINVAL.
-		 */
-		if (error == EINVAL || error == ENOENT)
-			error = ESTALE;
-		return ERR_PTR(-error);
-	}
-
-	if (ip->i_d.di_gen != generation) {
-		IRELE(ip);
-		return ERR_PTR(-ESTALE);
-	}
-
-	return VFS_I(ip);
-}
-
-STATIC struct dentry *
-xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		 int fh_len, int fileid_type)
-{
-	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
-	struct inode		*inode = NULL;
-
-	if (fh_len < xfs_fileid_length(fileid_type))
-		return NULL;
-
-	switch (fileid_type) {
-	case FILEID_INO32_GEN_PARENT:
-	case FILEID_INO32_GEN:
-		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen);
-		break;
-	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen);
-		break;
-	}
-
-	return d_obtain_alias(inode);
-}
-
-STATIC struct dentry *
-xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
-		 int fh_len, int fileid_type)
-{
-	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
-	struct inode		*inode = NULL;
-
-	switch (fileid_type) {
-	case FILEID_INO32_GEN_PARENT:
-		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
-					      fid->i32.parent_gen);
-		break;
-	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		inode = xfs_nfs_get_inode(sb, fid64->parent_ino,
-					      fid64->parent_gen);
-		break;
-	}
-
-	return d_obtain_alias(inode);
-}
-
-STATIC struct dentry *
-xfs_fs_get_parent(
-	struct dentry		*child)
-{
-	int			error;
-	struct xfs_inode	*cip;
-
-	error = xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip, NULL);
-	if (unlikely(error))
-		return ERR_PTR(-error);
-
-	return d_obtain_alias(VFS_I(cip));
-}
-
-STATIC int
-xfs_fs_nfs_commit_metadata(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		error = _xfs_log_force_lsn(mp, ip->i_itemp->ili_last_lsn,
-				XFS_LOG_SYNC, NULL);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	return error;
-}
-
-const struct export_operations xfs_export_operations = {
-	.encode_fh		= xfs_fs_encode_fh,
-	.fh_to_dentry		= xfs_fs_fh_to_dentry,
-	.fh_to_parent		= xfs_fs_fh_to_parent,
-	.get_parent		= xfs_fs_get_parent,
-	.commit_metadata	= xfs_fs_nfs_commit_metadata,
-};
diff --git a/fs/xfs/linux-2.6/xfs_export.h b/fs/xfs/linux-2.6/xfs_export.h
deleted file mode 100644
index 3272b6a..0000000
--- a/fs/xfs/linux-2.6/xfs_export.h
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_EXPORT_H__
-#define __XFS_EXPORT_H__
-
-/*
- * Common defines for code related to exporting XFS filesystems over NFS.
- *
- * The NFS fileid goes out on the wire as an array of
- * 32bit unsigned ints in host order.  There are 5 possible
- * formats.
- *
- * (1)	fileid_type=0x00
- *	(no fileid data; handled by the generic code)
- *
- * (2)	fileid_type=0x01
- *	inode-num
- *	generation
- *
- * (3)	fileid_type=0x02
- *	inode-num
- *	generation
- *	parent-inode-num
- *	parent-generation
- *
- * (4)	fileid_type=0x81
- *	inode-num-lo32
- *	inode-num-hi32
- *	generation
- *
- * (5)	fileid_type=0x82
- *	inode-num-lo32
- *	inode-num-hi32
- *	generation
- *	parent-inode-num-lo32
- *	parent-inode-num-hi32
- *	parent-generation
- *
- * Note, the NFS filehandle also includes an fsid portion which
- * may have an inode number in it.  That number is hardcoded to
- * 32bits and there is no way for XFS to intercept it.  In
- * practice this means when exporting an XFS filesystem with 64bit
- * inodes you should either export the mountpoint (rather than
- * a subdirectory) or use the "fsid" export option.
- */
-
-struct xfs_fid64 {
-	u64 ino;
-	u32 gen;
-	u64 parent_ino;
-	u32 parent_gen;
-} __attribute__((packed));
-
-/* This flag goes on the wire.  Don't play with it. */
-#define XFS_FILEID_TYPE_64FLAG	0x80	/* NFS fileid has 64bit inodes */
-
-#endif	/* __XFS_EXPORT_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
deleted file mode 100644
index 8073f61..0000000
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ /dev/null
@@ -1,1092 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_trans.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_bmap.h"
-#include "xfs_error.h"
-#include "xfs_vnodeops.h"
-#include "xfs_da_btree.h"
-#include "xfs_ioctl.h"
-#include "xfs_trace.h"
-
-#include <linux/dcache.h>
-#include <linux/falloc.h>
-
-static const struct vm_operations_struct xfs_file_vm_ops;
-
-/*
- * Locking primitives for read and write IO paths to ensure we consistently use
- * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
- */
-static inline void
-xfs_rw_ilock(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	if (type & XFS_IOLOCK_EXCL)
-		mutex_lock(&VFS_I(ip)->i_mutex);
-	xfs_ilock(ip, type);
-}
-
-static inline void
-xfs_rw_iunlock(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	xfs_iunlock(ip, type);
-	if (type & XFS_IOLOCK_EXCL)
-		mutex_unlock(&VFS_I(ip)->i_mutex);
-}
-
-static inline void
-xfs_rw_ilock_demote(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	xfs_ilock_demote(ip, type);
-	if (type & XFS_IOLOCK_EXCL)
-		mutex_unlock(&VFS_I(ip)->i_mutex);
-}
-
-/*
- *	xfs_iozero
- *
- *	xfs_iozero clears the specified range of buffer supplied,
- *	and marks all the affected blocks as valid and modified.  If
- *	an affected block is not allocated, it will be allocated.  If
- *	an affected block is not completely overwritten, and is not
- *	valid before the operation, it will be read from disk before
- *	being partially zeroed.
- */
-STATIC int
-xfs_iozero(
-	struct xfs_inode	*ip,	/* inode			*/
-	loff_t			pos,	/* offset in file		*/
-	size_t			count)	/* size of data to zero		*/
-{
-	struct page		*page;
-	struct address_space	*mapping;
-	int			status;
-
-	mapping = VFS_I(ip)->i_mapping;
-	do {
-		unsigned offset, bytes;
-		void *fsdata;
-
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		bytes = PAGE_CACHE_SIZE - offset;
-		if (bytes > count)
-			bytes = count;
-
-		status = pagecache_write_begin(NULL, mapping, pos, bytes,
-					AOP_FLAG_UNINTERRUPTIBLE,
-					&page, &fsdata);
-		if (status)
-			break;
-
-		zero_user(page, offset, bytes);
-
-		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
-					page, fsdata);
-		WARN_ON(status <= 0); /* can't return less than zero! */
-		pos += bytes;
-		count -= bytes;
-		status = 0;
-	} while (count);
-
-	return (-status);
-}
-
-STATIC int
-xfs_file_fsync(
-	struct file		*file,
-	int			datasync)
-{
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error = 0;
-	int			log_flushed = 0;
-
-	trace_xfs_file_fsync(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-
-	xfs_ioend_wait(ip);
-
-	if (mp->m_flags & XFS_MOUNT_BARRIER) {
-		/*
-		 * If we have an RT and/or log subvolume we need to make sure
-		 * to flush the write cache the device used for file data
-		 * first.  This is to ensure newly written file data make
-		 * it to disk before logging the new inode size in case of
-		 * an extending write.
-		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(mp->m_rtdev_targp);
-		else if (mp->m_logdev_targp != mp->m_ddev_targp)
-			xfs_blkdev_issue_flush(mp->m_ddev_targp);
-	}
-
-	/*
-	 * We always need to make sure that the required inode state is safe on
-	 * disk.  The inode might be clean but we still might need to force the
-	 * log because of committed transactions that haven't hit the disk yet.
-	 * Likewise, there could be unflushed non-transactional changes to the
-	 * inode core that have to go to disk and this requires us to issue
-	 * a synchronous transaction to capture these changes correctly.
-	 *
-	 * This code relies on the assumption that if the i_update_core field
-	 * of the inode is clear and the inode is unpinned then it is clean
-	 * and no action is required.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	/*
-	 * First check if the VFS inode is marked dirty.  All the dirtying
-	 * of non-transactional updates no goes through mark_inode_dirty*,
-	 * which allows us to distinguish beteeen pure timestamp updates
-	 * and i_size updates which need to be caught for fdatasync.
-	 * After that also theck for the dirty state in the XFS inode, which
-	 * might gets cleared when the inode gets written out via the AIL
-	 * or xfs_iflush_cluster.
-	 */
-	if (((inode->i_state & I_DIRTY_DATASYNC) ||
-	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
-	    ip->i_update_core) {
-		/*
-		 * Kick off a transaction to log the inode core to get the
-		 * updates.  The sync transaction will also force the log.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-		error = xfs_trans_reserve(tp, 0,
-				XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			return -error;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-		/*
-		 * Note - it's possible that we might have pushed ourselves out
-		 * of the way during trans_reserve which would flush the inode.
-		 * But there's no guarantee that the inode buffer has actually
-		 * gone out yet (it's delwri).	Plus the buffer could be pinned
-		 * anyway if it's part of an inode in another recent
-		 * transaction.	 So we play it safe and fire off the
-		 * transaction anyway.
-		 */
-		xfs_trans_ijoin(tp, ip);
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		xfs_trans_set_sync(tp);
-		error = _xfs_trans_commit(tp, 0, &log_flushed);
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	} else {
-		/*
-		 * Timestamps/size haven't changed since last inode flush or
-		 * inode transaction commit.  That means either nothing got
-		 * written or a transaction committed which caught the updates.
-		 * If the latter happened and the transaction hasn't hit the
-		 * disk yet, the inode will be still be pinned.  If it is,
-		 * force the log.
-		 */
-		if (xfs_ipincount(ip)) {
-			error = _xfs_log_force_lsn(mp,
-					ip->i_itemp->ili_last_lsn,
-					XFS_LOG_SYNC, &log_flushed);
-		}
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	}
-
-	/*
-	 * If we only have a single device, and the log force about was
-	 * a no-op we might have to flush the data device cache here.
-	 * This can only happen for fdatasync/O_DSYNC if we were overwriting
-	 * an already allocated file and thus do not have any metadata to
-	 * commit.
-	 */
-	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp &&
-	    !XFS_IS_REALTIME_INODE(ip) &&
-	    !log_flushed)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
-
-	return -error;
-}
-
-STATIC ssize_t
-xfs_file_aio_read(
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	struct file		*file = iocb->ki_filp;
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	size_t			size = 0;
-	ssize_t			ret = 0;
-	int			ioflags = 0;
-	xfs_fsize_t		n;
-	unsigned long		seg;
-
-	XFS_STATS_INC(xs_read_calls);
-
-	BUG_ON(iocb->ki_pos != pos);
-
-	if (unlikely(file->f_flags & O_DIRECT))
-		ioflags |= IO_ISDIRECT;
-	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	/* START copy & waste from filemap.c */
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *iv = &iovp[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		size += iv->iov_len;
-		if (unlikely((ssize_t)(size|iv->iov_len) < 0))
-			return XFS_ERROR(-EINVAL);
-	}
-	/* END copy & waste from filemap.c */
-
-	if (unlikely(ioflags & IO_ISDIRECT)) {
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((iocb->ki_pos & target->bt_smask) ||
-		    (size & target->bt_smask)) {
-			if (iocb->ki_pos == ip->i_size)
-				return 0;
-			return -XFS_ERROR(EINVAL);
-		}
-	}
-
-	n = XFS_MAXIOFFSET(mp) - iocb->ki_pos;
-	if (n <= 0 || size == 0)
-		return 0;
-
-	if (n < size)
-		size = n;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	if (unlikely(ioflags & IO_ISDIRECT)) {
-		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
-
-		if (inode->i_mapping->nrpages) {
-			ret = -xfs_flushinval_pages(ip,
-					(iocb->ki_pos & PAGE_CACHE_MASK),
-					-1, FI_REMAPF_LOCKED);
-			if (ret) {
-				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
-				return ret;
-			}
-		}
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-	} else
-		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-
-	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
-
-	ret = generic_file_aio_read(iocb, iovp, nr_segs, iocb->ki_pos);
-	if (ret > 0)
-		XFS_STATS_ADD(xs_read_bytes, ret);
-
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-	return ret;
-}
-
-STATIC ssize_t
-xfs_file_splice_read(
-	struct file		*infilp,
-	loff_t			*ppos,
-	struct pipe_inode_info	*pipe,
-	size_t			count,
-	unsigned int		flags)
-{
-	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
-	int			ioflags = 0;
-	ssize_t			ret;
-
-	XFS_STATS_INC(xs_read_calls);
-
-	if (infilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-
-	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
-
-	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
-	if (ret > 0)
-		XFS_STATS_ADD(xs_read_bytes, ret);
-
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-	return ret;
-}
-
-STATIC void
-xfs_aio_write_isize_update(
-	struct inode	*inode,
-	loff_t		*ppos,
-	ssize_t		bytes_written)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		isize = i_size_read(inode);
-
-	if (bytes_written > 0)
-		XFS_STATS_ADD(xs_write_bytes, bytes_written);
-
-	if (unlikely(bytes_written < 0 && bytes_written != -EFAULT &&
-					*ppos > isize))
-		*ppos = isize;
-
-	if (*ppos > ip->i_size) {
-		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-		if (*ppos > ip->i_size)
-			ip->i_size = *ppos;
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-}
-
-/*
- * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
- * part of the I/O may have been written to disk before the error occurred.  In
- * this case the on-disk file size may have been adjusted beyond the in-memory
- * file size and now needs to be truncated back.
- */
-STATIC void
-xfs_aio_write_newsize_update(
-	struct xfs_inode	*ip)
-{
-	if (ip->i_new_size) {
-		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-		ip->i_new_size = 0;
-		if (ip->i_d.di_size > ip->i_size)
-			ip->i_d.di_size = ip->i_size;
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-}
-
-/*
- * xfs_file_splice_write() does not use xfs_rw_ilock() because
- * generic_file_splice_write() takes the i_mutex itself. This, in theory,
- * couuld cause lock inversions between the aio_write path and the splice path
- * if someone is doing concurrent splice(2) based writes and write(2) based
- * writes to the same inode. The only real way to fix this is to re-implement
- * the generic code here with correct locking orders.
- */
-STATIC ssize_t
-xfs_file_splice_write(
-	struct pipe_inode_info	*pipe,
-	struct file		*outfilp,
-	loff_t			*ppos,
-	size_t			count,
-	unsigned int		flags)
-{
-	struct inode		*inode = outfilp->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		new_size;
-	int			ioflags = 0;
-	ssize_t			ret;
-
-	XFS_STATS_INC(xs_write_calls);
-
-	if (outfilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
-	new_size = *ppos + count;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
-
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
-
-	xfs_aio_write_isize_update(inode, ppos, ret);
-	xfs_aio_write_newsize_update(ip);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	return ret;
-}
-
-/*
- * This routine is called to handle zeroing any space in the last
- * block of the file that is beyond the EOF.  We do this since the
- * size is being increased without writing anything to that block
- * and we don't want anyone to read the garbage on the disk.
- */
-STATIC int				/* error (positive) */
-xfs_zero_last_block(
-	xfs_inode_t	*ip,
-	xfs_fsize_t	offset,
-	xfs_fsize_t	isize)
-{
-	xfs_fileoff_t	last_fsb;
-	xfs_mount_t	*mp = ip->i_mount;
-	int		nimaps;
-	int		zero_offset;
-	int		zero_len;
-	int		error = 0;
-	xfs_bmbt_irec_t	imap;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
-	if (zero_offset == 0) {
-		/*
-		 * There are no extra bytes in the last block on disk to
-		 * zero, so return.
-		 */
-		return 0;
-	}
-
-	last_fsb = XFS_B_TO_FSBT(mp, isize);
-	nimaps = 1;
-	error = xfs_bmapi(NULL, ip, last_fsb, 1, 0, NULL, 0, &imap,
-			  &nimaps, NULL);
-	if (error) {
-		return error;
-	}
-	ASSERT(nimaps > 0);
-	/*
-	 * If the block underlying isize is just a hole, then there
-	 * is nothing to zero.
-	 */
-	if (imap.br_startblock == HOLESTARTBLOCK) {
-		return 0;
-	}
-	/*
-	 * Zero the part of the last block beyond the EOF, and write it
-	 * out sync.  We need to drop the ilock while we do this so we
-	 * don't deadlock when the buffer cache calls back to us.
-	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	zero_len = mp->m_sb.sb_blocksize - zero_offset;
-	if (isize + zero_len > offset)
-		zero_len = offset - isize;
-	error = xfs_iozero(ip, isize, zero_len);
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	ASSERT(error >= 0);
-	return error;
-}
-
-/*
- * Zero any on disk space between the current EOF and the new,
- * larger EOF.  This handles the normal case of zeroing the remainder
- * of the last block in the file and the unusual case of zeroing blocks
- * out beyond the size of the file.  This second case only happens
- * with fixed size extents and when the system crashes before the inode
- * size was updated but after blocks were allocated.  If fill is set,
- * then any holes in the range are filled and zeroed.  If not, the holes
- * are left alone as holes.
- */
-
-int					/* error (positive) */
-xfs_zero_eof(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,		/* starting I/O offset */
-	xfs_fsize_t	isize)		/* current inode size */
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	start_zero_fsb;
-	xfs_fileoff_t	end_zero_fsb;
-	xfs_fileoff_t	zero_count_fsb;
-	xfs_fileoff_t	last_fsb;
-	xfs_fileoff_t	zero_off;
-	xfs_fsize_t	zero_len;
-	int		nimaps;
-	int		error = 0;
-	xfs_bmbt_irec_t	imap;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-	ASSERT(offset > isize);
-
-	/*
-	 * First handle zeroing the block on which isize resides.
-	 * We only zero a part of that block so it is handled specially.
-	 */
-	error = xfs_zero_last_block(ip, offset, isize);
-	if (error) {
-		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-		return error;
-	}
-
-	/*
-	 * Calculate the range between the new size and the old
-	 * where blocks needing to be zeroed may exist.  To get the
-	 * block where the last byte in the file currently resides,
-	 * we need to subtract one from the size and truncate back
-	 * to a block boundary.  We subtract 1 in case the size is
-	 * exactly on a block boundary.
-	 */
-	last_fsb = isize ? XFS_B_TO_FSBT(mp, isize - 1) : (xfs_fileoff_t)-1;
-	start_zero_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
-	end_zero_fsb = XFS_B_TO_FSBT(mp, offset - 1);
-	ASSERT((xfs_sfiloff_t)last_fsb < (xfs_sfiloff_t)start_zero_fsb);
-	if (last_fsb == end_zero_fsb) {
-		/*
-		 * The size was only incremented on its last block.
-		 * We took care of that above, so just return.
-		 */
-		return 0;
-	}
-
-	ASSERT(start_zero_fsb <= end_zero_fsb);
-	while (start_zero_fsb <= end_zero_fsb) {
-		nimaps = 1;
-		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
-		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
-				  0, NULL, 0, &imap, &nimaps, NULL);
-		if (error) {
-			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-			return error;
-		}
-		ASSERT(nimaps > 0);
-
-		if (imap.br_state == XFS_EXT_UNWRITTEN ||
-		    imap.br_startblock == HOLESTARTBLOCK) {
-			/*
-			 * This loop handles initializing pages that were
-			 * partially initialized by the code below this
-			 * loop. It basically zeroes the part of the page
-			 * that sits on a hole and sets the page as P_HOLE
-			 * and calls remapf if it is a mapped file.
-			 */
-			start_zero_fsb = imap.br_startoff + imap.br_blockcount;
-			ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
-			continue;
-		}
-
-		/*
-		 * There are blocks we need to zero.
-		 * Drop the inode lock while we're doing the I/O.
-		 * We'll still have the iolock to protect us.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
-		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
-
-		if ((zero_off + zero_len) > offset)
-			zero_len = offset - zero_off;
-
-		error = xfs_iozero(ip, zero_off, zero_len);
-		if (error) {
-			goto out_lock;
-		}
-
-		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
-		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-	}
-
-	return 0;
-
-out_lock:
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	ASSERT(error >= 0);
-	return error;
-}
-
-/*
- * Common pre-write limit and setup checks.
- *
- * Returns with iolock held according to @iolock.
- */
-STATIC ssize_t
-xfs_file_aio_write_checks(
-	struct file		*file,
-	loff_t			*pos,
-	size_t			*count,
-	int			*iolock)
-{
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		new_size;
-	int			error = 0;
-
-	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
-	if (error) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
-		*iolock = 0;
-		return error;
-	}
-
-	new_size = *pos + *count;
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
-
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
-
-	/*
-	 * If the offset is beyond the size of the file, we need to zero any
-	 * blocks that fall between the existing EOF and the start of this
-	 * write.
-	 */
-	if (*pos > ip->i_size)
-		error = -xfs_zero_eof(ip, *pos, ip->i_size);
-
-	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		return error;
-
-	/*
-	 * If we're writing the file then make sure to clear the setuid and
-	 * setgid bits if the process is not being run by root.  This keeps
-	 * people from modifying setuid and setgid binaries.
-	 */
-	return file_remove_suid(file);
-
-}
-
-/*
- * xfs_file_dio_aio_write - handle direct IO writes
- *
- * Lock the inode appropriately to prepare for and issue a direct IO write.
- * By separating it from the buffered write path we remove all the tricky to
- * follow locking changes and looping.
- *
- * If there are cached pages or we're extending the file, we need IOLOCK_EXCL
- * until we're sure the bytes at the new EOF have been zeroed and/or the cached
- * pages are flushed out.
- *
- * In most cases the direct IO writes will be done holding IOLOCK_SHARED
- * allowing them to be done in parallel with reads and other direct IO writes.
- * However, if the IO is not aligned to filesystem blocks, the direct IO layer
- * needs to do sub-block zeroing and that requires serialisation against other
- * direct IOs to the same block. In this case we need to serialise the
- * submission of the unaligned IOs so that we don't get racing block zeroing in
- * the dio layer.  To avoid the problem with aio, we also need to wait for
- * outstanding IOs to complete so that unwritten extent conversion is completed
- * before we try to map the overlapping block. This is currently implemented by
- * hitting it with a big hammer (i.e. xfs_ioend_wait()).
- *
- * Returns with locks held indicated by @iolock and errors indicated by
- * negative return values.
- */
-STATIC ssize_t
-xfs_file_dio_aio_write(
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
-	loff_t			pos,
-	size_t			ocount,
-	int			*iolock)
-{
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	ssize_t			ret = 0;
-	size_t			count = ocount;
-	int			unaligned_io = 0;
-	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
-					mp->m_rtdev_targp : mp->m_ddev_targp;
-
-	*iolock = 0;
-	if ((pos & target->bt_smask) || (count & target->bt_smask))
-		return -XFS_ERROR(EINVAL);
-
-	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
-		unaligned_io = 1;
-
-	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
-		*iolock = XFS_IOLOCK_EXCL;
-	else
-		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
-
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
-	if (ret)
-		return ret;
-
-	if (mapping->nrpages) {
-		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
-		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
-							FI_REMAPF_LOCKED);
-		if (ret)
-			return ret;
-	}
-
-	/*
-	 * If we are doing unaligned IO, wait for all other IO to drain,
-	 * otherwise demote the lock if we had to flush cached pages
-	 */
-	if (unaligned_io)
-		xfs_ioend_wait(ip);
-	else if (*iolock == XFS_IOLOCK_EXCL) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-		*iolock = XFS_IOLOCK_SHARED;
-	}
-
-	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_direct_write(iocb, iovp,
-			&nr_segs, pos, &iocb->ki_pos, count, ocount);
-
-	/* No fallback to buffered IO on errors for XFS. */
-	ASSERT(ret < 0 || ret == count);
-	return ret;
-}
-
-STATIC ssize_t
-xfs_file_buffered_aio_write(
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
-	loff_t			pos,
-	size_t			ocount,
-	int			*iolock)
-{
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	ssize_t			ret;
-	int			enospc = 0;
-	size_t			count = ocount;
-
-	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
-
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
-	if (ret)
-		return ret;
-
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = mapping->backing_dev_info;
-
-write_retry:
-	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
-			pos, &iocb->ki_pos, count, ret);
-	/*
-	 * if we just got an ENOSPC, flush the inode now we aren't holding any
-	 * page locks and retry *once*
-	 */
-	if (ret == -ENOSPC && !enospc) {
-		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-		if (ret)
-			return ret;
-		enospc = 1;
-		goto write_retry;
-	}
-	current->backing_dev_info = NULL;
-	return ret;
-}
-
-STATIC ssize_t
-xfs_file_aio_write(
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	ssize_t			ret;
-	int			iolock;
-	size_t			ocount = 0;
-
-	XFS_STATS_INC(xs_write_calls);
-
-	BUG_ON(iocb->ki_pos != pos);
-
-	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (ret)
-		return ret;
-
-	if (ocount == 0)
-		return 0;
-
-	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	if (unlikely(file->f_flags & O_DIRECT))
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
-	else
-		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
-
-	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
-
-	if (ret <= 0)
-		goto out_unlock;
-
-	/* Handle various SYNC-type writes */
-	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
-		loff_t end = pos + ret - 1;
-		int error, error2;
-
-		xfs_rw_iunlock(ip, iolock);
-		error = filemap_write_and_wait_range(mapping, pos, end);
-		xfs_rw_ilock(ip, iolock);
-
-		error2 = -xfs_file_fsync(file,
-					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (error)
-			ret = error;
-		else if (error2)
-			ret = error2;
-	}
-
-out_unlock:
-	xfs_aio_write_newsize_update(ip);
-	xfs_rw_iunlock(ip, iolock);
-	return ret;
-}
-
-STATIC long
-xfs_file_fallocate(
-	struct file	*file,
-	int		mode,
-	loff_t		offset,
-	loff_t		len)
-{
-	struct inode	*inode = file->f_path.dentry->d_inode;
-	long		error;
-	loff_t		new_size = 0;
-	xfs_flock64_t	bf;
-	xfs_inode_t	*ip = XFS_I(inode);
-	int		cmd = XFS_IOC_RESVSP;
-	int		attr_flags = XFS_ATTR_NOLOCK;
-
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
-	bf.l_whence = 0;
-	bf.l_start = offset;
-	bf.l_len = len;
-
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		cmd = XFS_IOC_UNRESVSP;
-
-	/* check the new inode size is valid before allocating */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    offset + len > i_size_read(inode)) {
-		new_size = offset + len;
-		error = inode_newsize_ok(inode, new_size);
-		if (error)
-			goto out_unlock;
-	}
-
-	if (file->f_flags & O_DSYNC)
-		attr_flags |= XFS_ATTR_SYNC;
-
-	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
-	if (error)
-		goto out_unlock;
-
-	/* Change file size if needed */
-	if (new_size) {
-		struct iattr iattr;
-
-		iattr.ia_valid = ATTR_SIZE;
-		iattr.ia_size = new_size;
-		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
-	}
-
-out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	return error;
-}
-
-
-STATIC int
-xfs_file_open(
-	struct inode	*inode,
-	struct file	*file)
-{
-	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
-	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
-		return -EIO;
-	return 0;
-}
-
-STATIC int
-xfs_dir_open(
-	struct inode	*inode,
-	struct file	*file)
-{
-	struct xfs_inode *ip = XFS_I(inode);
-	int		mode;
-	int		error;
-
-	error = xfs_file_open(inode, file);
-	if (error)
-		return error;
-
-	/*
-	 * If there are any blocks, read-ahead block 0 as we're almost
-	 * certain to have the next operation be a read there.
-	 */
-	mode = xfs_ilock_map_shared(ip);
-	if (ip->i_d.di_nextents > 0)
-		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
-	xfs_iunlock(ip, mode);
-	return 0;
-}
-
-STATIC int
-xfs_file_release(
-	struct inode	*inode,
-	struct file	*filp)
-{
-	return -xfs_release(XFS_I(inode));
-}
-
-STATIC int
-xfs_file_readdir(
-	struct file	*filp,
-	void		*dirent,
-	filldir_t	filldir)
-{
-	struct inode	*inode = filp->f_path.dentry->d_inode;
-	xfs_inode_t	*ip = XFS_I(inode);
-	int		error;
-	size_t		bufsize;
-
-	/*
-	 * The Linux API doesn't pass down the total size of the buffer
-	 * we read into down to the filesystem.  With the filldir concept
-	 * it's not needed for correct information, but the XFS dir2 leaf
-	 * code wants an estimate of the buffer size to calculate it's
-	 * readahead window and size the buffers used for mapping to
-	 * physical blocks.
-	 *
-	 * Try to give it an estimate that's good enough, maybe at some
-	 * point we can change the ->readdir prototype to include the
-	 * buffer size.  For now we use the current glibc buffer size.
-	 */
-	bufsize = (size_t)min_t(loff_t, 32768, ip->i_d.di_size);
-
-	error = xfs_readdir(ip, dirent, bufsize,
-				(xfs_off_t *)&filp->f_pos, filldir);
-	if (error)
-		return -error;
-	return 0;
-}
-
-STATIC int
-xfs_file_mmap(
-	struct file	*filp,
-	struct vm_area_struct *vma)
-{
-	vma->vm_ops = &xfs_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
-
-	file_accessed(filp);
-	return 0;
-}
-
-/*
- * mmap()d file has taken write protection fault and is being made
- * writable. We can set the page state up correctly for a writable
- * page, which means we can do correct delalloc accounting (ENOSPC
- * checking!) and unwritten extent mapping.
- */
-STATIC int
-xfs_vm_page_mkwrite(
-	struct vm_area_struct	*vma,
-	struct vm_fault		*vmf)
-{
-	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
-}
-
-const struct file_operations xfs_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= do_sync_read,
-	.write		= do_sync_write,
-	.aio_read	= xfs_file_aio_read,
-	.aio_write	= xfs_file_aio_write,
-	.splice_read	= xfs_file_splice_read,
-	.splice_write	= xfs_file_splice_write,
-	.unlocked_ioctl	= xfs_file_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= xfs_file_compat_ioctl,
-#endif
-	.mmap		= xfs_file_mmap,
-	.open		= xfs_file_open,
-	.release	= xfs_file_release,
-	.fsync		= xfs_file_fsync,
-	.fallocate	= xfs_file_fallocate,
-};
-
-const struct file_operations xfs_dir_file_operations = {
-	.open		= xfs_dir_open,
-	.read		= generic_read_dir,
-	.readdir	= xfs_file_readdir,
-	.llseek		= generic_file_llseek,
-	.unlocked_ioctl	= xfs_file_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= xfs_file_compat_ioctl,
-#endif
-	.fsync		= xfs_file_fsync,
-};
-
-static const struct vm_operations_struct xfs_file_vm_ops = {
-	.fault		= filemap_fault,
-	.page_mkwrite	= xfs_vm_page_mkwrite,
-};
diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
deleted file mode 100644
index ed88ed1..0000000
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005-2006 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_vnodeops.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_trace.h"
-
-/*
- * note: all filemap functions return negative error codes. These
- * need to be inverted before returning to the xfs core functions.
- */
-void
-xfs_tosspages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	/* can't toss partial tail pages, so mask them out */
-	last &= ~(PAGE_SIZE - 1);
-	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
-}
-
-int
-xfs_flushinval_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-
-	trace_xfs_pagecache_inval(ip, first, last);
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = filemap_write_and_wait_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (!ret)
-		truncate_inode_pages_range(mapping, first, last);
-	return -ret;
-}
-
-int
-xfs_flush_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-	int		ret2;
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = -filemap_fdatawrite_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (flags & XBF_ASYNC)
-		return ret;
-	ret2 = xfs_wait_on_pages(ip, first, last);
-	if (!ret)
-		ret = ret2;
-	return ret;
-}
-
-int
-xfs_wait_on_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
-		return -filemap_fdatawait_range(mapping, first,
-					last == -1 ? ip->i_size - 1 : last);
-	}
-	return 0;
-}
diff --git a/fs/xfs/linux-2.6/xfs_globals.c b/fs/xfs/linux-2.6/xfs_globals.c
deleted file mode 100644
index 76e81cf..0000000
--- a/fs/xfs/linux-2.6/xfs_globals.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_sysctl.h"
-
-/*
- * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
- * other XFS code uses these values.  Times are measured in centisecs (i.e.
- * 100ths of a second).
- */
-xfs_param_t xfs_params = {
-			  /*	MIN		DFLT		MAX	*/
-	.sgid_inherit	= {	0,		0,		1	},
-	.symlink_mode	= {	0,		0,		1	},
-	.panic_mask	= {	0,		0,		255	},
-	.error_level	= {	0,		3,		11	},
-	.syncd_timer	= {	1*100,		30*100,		7200*100},
-	.stats_clear	= {	0,		0,		1	},
-	.inherit_sync	= {	0,		1,		1	},
-	.inherit_nodump	= {	0,		1,		1	},
-	.inherit_noatim = {	0,		1,		1	},
-	.xfs_buf_timer	= {	100/2,		1*100,		30*100	},
-	.xfs_buf_age	= {	1*100,		15*100,		7200*100},
-	.inherit_nosym	= {	0,		0,		1	},
-	.rotorstep	= {	1,		1,		255	},
-	.inherit_nodfrg	= {	0,		1,		1	},
-	.fstrm_timer	= {	1,		30*100,		3600*100},
-};
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
deleted file mode 100644
index acca2c5..0000000
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ /dev/null
@@ -1,1556 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_ioctl.h"
-#include "xfs_rtalloc.h"
-#include "xfs_itable.h"
-#include "xfs_error.h"
-#include "xfs_attr.h"
-#include "xfs_bmap.h"
-#include "xfs_buf_item.h"
-#include "xfs_utils.h"
-#include "xfs_dfrag.h"
-#include "xfs_fsops.h"
-#include "xfs_vnodeops.h"
-#include "xfs_discard.h"
-#include "xfs_quota.h"
-#include "xfs_inode_item.h"
-#include "xfs_export.h"
-#include "xfs_trace.h"
-
-#include <linux/capability.h>
-#include <linux/dcache.h>
-#include <linux/mount.h>
-#include <linux/namei.h>
-#include <linux/pagemap.h>
-#include <linux/slab.h>
-#include <linux/exportfs.h>
-
-/*
- * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
- * a file or fs handle.
- *
- * XFS_IOC_PATH_TO_FSHANDLE
- *    returns fs handle for a mount point or path within that mount point
- * XFS_IOC_FD_TO_HANDLE
- *    returns full handle for a FD opened in user space
- * XFS_IOC_PATH_TO_HANDLE
- *    returns full handle for a path
- */
-int
-xfs_find_handle(
-	unsigned int		cmd,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	int			hsize;
-	xfs_handle_t		handle;
-	struct inode		*inode;
-	struct file		*file = NULL;
-	struct path		path;
-	int			error;
-	struct xfs_inode	*ip;
-
-	if (cmd == XFS_IOC_FD_TO_HANDLE) {
-		file = fget(hreq->fd);
-		if (!file)
-			return -EBADF;
-		inode = file->f_path.dentry->d_inode;
-	} else {
-		error = user_lpath((const char __user *)hreq->path, &path);
-		if (error)
-			return error;
-		inode = path.dentry->d_inode;
-	}
-	ip = XFS_I(inode);
-
-	/*
-	 * We can only generate handles for inodes residing on a XFS filesystem,
-	 * and only for regular files, directories or symbolic links.
-	 */
-	error = -EINVAL;
-	if (inode->i_sb->s_magic != XFS_SB_MAGIC)
-		goto out_put;
-
-	error = -EBADF;
-	if (!S_ISREG(inode->i_mode) &&
-	    !S_ISDIR(inode->i_mode) &&
-	    !S_ISLNK(inode->i_mode))
-		goto out_put;
-
-
-	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
-
-	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
-		/*
-		 * This handle only contains an fsid, zero the rest.
-		 */
-		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
-		hsize = sizeof(xfs_fsid_t);
-	} else {
-		int		lock_mode;
-
-		lock_mode = xfs_ilock_map_shared(ip);
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-					sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_gen = ip->i_d.di_gen;
-		handle.ha_fid.fid_ino = ip->i_ino;
-		xfs_iunlock_map_shared(ip, lock_mode);
-
-		hsize = XFS_HSIZE(handle);
-	}
-
-	error = -EFAULT;
-	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
-	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
-		goto out_put;
-
-	error = 0;
-
- out_put:
-	if (cmd == XFS_IOC_FD_TO_HANDLE)
-		fput(file);
-	else
-		path_put(&path);
-	return error;
-}
-
-/*
- * No need to do permission checks on the various pathname components
- * as the handle operations are privileged.
- */
-STATIC int
-xfs_handle_acceptable(
-	void			*context,
-	struct dentry		*dentry)
-{
-	return 1;
-}
-
-/*
- * Convert userspace handle data into a dentry.
- */
-struct dentry *
-xfs_handle_to_dentry(
-	struct file		*parfilp,
-	void __user		*uhandle,
-	u32			hlen)
-{
-	xfs_handle_t		handle;
-	struct xfs_fid64	fid;
-
-	/*
-	 * Only allow handle opens under a directory.
-	 */
-	if (!S_ISDIR(parfilp->f_path.dentry->d_inode->i_mode))
-		return ERR_PTR(-ENOTDIR);
-
-	if (hlen != sizeof(xfs_handle_t))
-		return ERR_PTR(-EINVAL);
-	if (copy_from_user(&handle, uhandle, hlen))
-		return ERR_PTR(-EFAULT);
-	if (handle.ha_fid.fid_len !=
-	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
-		return ERR_PTR(-EINVAL);
-
-	memset(&fid, 0, sizeof(struct fid));
-	fid.ino = handle.ha_fid.fid_ino;
-	fid.gen = handle.ha_fid.fid_gen;
-
-	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
-			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
-			xfs_handle_acceptable, NULL);
-}
-
-STATIC struct dentry *
-xfs_handlereq_to_dentry(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
-}
-
-int
-xfs_open_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	const struct cred	*cred = current_cred();
-	int			error;
-	int			fd;
-	int			permflag;
-	struct file		*filp;
-	struct inode		*inode;
-	struct dentry		*dentry;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-
-	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	inode = dentry->d_inode;
-
-	/* Restrict xfs_open_by_handle to directories & regular files. */
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
-		error = -XFS_ERROR(EPERM);
-		goto out_dput;
-	}
-
-#if BITS_PER_LONG != 32
-	hreq->oflags |= O_LARGEFILE;
-#endif
-
-	/* Put open permission in namei format. */
-	permflag = hreq->oflags;
-	if ((permflag+1) & O_ACCMODE)
-		permflag++;
-	if (permflag & O_TRUNC)
-		permflag |= 2;
-
-	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
-	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
-		error = -XFS_ERROR(EPERM);
-		goto out_dput;
-	}
-
-	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
-		error = -XFS_ERROR(EACCES);
-		goto out_dput;
-	}
-
-	/* Can't write directories. */
-	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
-		error = -XFS_ERROR(EISDIR);
-		goto out_dput;
-	}
-
-	fd = get_unused_fd();
-	if (fd < 0) {
-		error = fd;
-		goto out_dput;
-	}
-
-	filp = dentry_open(dentry, mntget(parfilp->f_path.mnt),
-			   hreq->oflags, cred);
-	if (IS_ERR(filp)) {
-		put_unused_fd(fd);
-		return PTR_ERR(filp);
-	}
-
-	if (inode->i_mode & S_IFREG) {
-		filp->f_flags |= O_NOATIME;
-		filp->f_mode |= FMODE_NOCMTIME;
-	}
-
-	fd_install(fd, filp);
-	return fd;
-
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-/*
- * This is a copy from fs/namei.c:vfs_readlink(), except for removing it's
- * unused first argument.
- */
-STATIC int
-do_readlink(
-	char __user		*buffer,
-	int			buflen,
-	const char		*link)
-{
-        int len;
-
-	len = PTR_ERR(link);
-	if (IS_ERR(link))
-		goto out;
-
-	len = strlen(link);
-	if (len > (unsigned) buflen)
-		len = buflen;
-	if (copy_to_user(buffer, link, len))
-		len = -EFAULT;
- out:
-	return len;
-}
-
-
-int
-xfs_readlink_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	struct dentry		*dentry;
-	__u32			olen;
-	void			*link;
-	int			error;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-
-	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	/* Restrict this handle operation to symlinks only. */
-	if (!S_ISLNK(dentry->d_inode->i_mode)) {
-		error = -XFS_ERROR(EINVAL);
-		goto out_dput;
-	}
-
-	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
-		error = -XFS_ERROR(EFAULT);
-		goto out_dput;
-	}
-
-	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link) {
-		error = -XFS_ERROR(ENOMEM);
-		goto out_dput;
-	}
-
-	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
-	if (error)
-		goto out_kfree;
-	error = do_readlink(hreq->ohandle, olen, link);
-	if (error)
-		goto out_kfree;
-
- out_kfree:
-	kfree(link);
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-STATIC int
-xfs_fssetdm_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	struct fsdmidata	fsd;
-	xfs_fsop_setdm_handlereq_t dmhreq;
-	struct dentry		*dentry;
-
-	if (!capable(CAP_MKNOD))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
-		error = -XFS_ERROR(EPERM);
-		goto out;
-	}
-
-	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
-		error = -XFS_ERROR(EFAULT);
-		goto out;
-	}
-
-	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
-				 fsd.fsd_dmstate);
-
- out:
-	dput(dentry);
-	return error;
-}
-
-STATIC int
-xfs_attrlist_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error = -ENOMEM;
-	attrlist_cursor_kern_t	*cursor;
-	xfs_fsop_attrlist_handlereq_t al_hreq;
-	struct dentry		*dentry;
-	char			*kbuf;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
-		return -XFS_ERROR(EINVAL);
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -XFS_ERROR(EINVAL);
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
-	if (!kbuf)
-		goto out_dput;
-
-	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
-	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
-		error = -EFAULT;
-
- out_kfree:
-	kfree(kbuf);
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-int
-xfs_attrmulti_attr_get(
-	struct inode		*inode,
-	unsigned char		*name,
-	unsigned char		__user *ubuf,
-	__uint32_t		*len,
-	__uint32_t		flags)
-{
-	unsigned char		*kbuf;
-	int			error = EFAULT;
-
-	if (*len > XATTR_SIZE_MAX)
-		return EINVAL;
-	kbuf = kmalloc(*len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
-
-	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
-	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(ubuf, kbuf, *len))
-		error = EFAULT;
-
- out_kfree:
-	kfree(kbuf);
-	return error;
-}
-
-int
-xfs_attrmulti_attr_set(
-	struct inode		*inode,
-	unsigned char		*name,
-	const unsigned char	__user *ubuf,
-	__uint32_t		len,
-	__uint32_t		flags)
-{
-	unsigned char		*kbuf;
-	int			error = EFAULT;
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return EPERM;
-	if (len > XATTR_SIZE_MAX)
-		return EINVAL;
-
-	kbuf = memdup_user(ubuf, len);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
-
-	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
-
-	return error;
-}
-
-int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	__uint32_t		flags)
-{
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return EPERM;
-	return xfs_attr_remove(XFS_I(inode), name, flags);
-}
-
-STATIC int
-xfs_attrmulti_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	xfs_attr_multiop_t	*ops;
-	xfs_fsop_attrmulti_handlereq_t am_hreq;
-	struct dentry		*dentry;
-	unsigned int		i, size;
-	unsigned char		*attr_name;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	/* overflow check */
-	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
-		return -E2BIG;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	error = E2BIG;
-	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
-	if (!size || size > 16 * PAGE_SIZE)
-		goto out_dput;
-
-	ops = memdup_user(am_hreq.ops, size);
-	if (IS_ERR(ops)) {
-		error = PTR_ERR(ops);
-		goto out_dput;
-	}
-
-	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
-	if (!attr_name)
-		goto out_kfree_ops;
-
-	error = 0;
-	for (i = 0; i < am_hreq.opcount; i++) {
-		ops[i].am_error = strncpy_from_user((char *)attr_name,
-				ops[i].am_attrname, MAXNAMELEN);
-		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
-		if (ops[i].am_error < 0)
-			break;
-
-		switch (ops[i].am_opcode) {
-		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(
-					dentry->d_inode, attr_name,
-					ops[i].am_attrvalue, &ops[i].am_length,
-					ops[i].am_flags);
-			break;
-		case ATTR_OP_SET:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					dentry->d_inode, attr_name,
-					ops[i].am_attrvalue, ops[i].am_length,
-					ops[i].am_flags);
-			mnt_drop_write(parfilp->f_path.mnt);
-			break;
-		case ATTR_OP_REMOVE:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					dentry->d_inode, attr_name,
-					ops[i].am_flags);
-			mnt_drop_write(parfilp->f_path.mnt);
-			break;
-		default:
-			ops[i].am_error = EINVAL;
-		}
-	}
-
-	if (copy_to_user(am_hreq.ops, ops, size))
-		error = XFS_ERROR(EFAULT);
-
-	kfree(attr_name);
- out_kfree_ops:
-	kfree(ops);
- out_dput:
-	dput(dentry);
-	return -error;
-}
-
-int
-xfs_ioc_space(
-	struct xfs_inode	*ip,
-	struct inode		*inode,
-	struct file		*filp,
-	int			ioflags,
-	unsigned int		cmd,
-	xfs_flock64_t		*bf)
-{
-	int			attr_flags = 0;
-	int			error;
-
-	/*
-	 * Only allow the sys admin to reserve space unless
-	 * unwritten extents are enabled.
-	 */
-	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-
-	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
-		return -XFS_ERROR(EPERM);
-
-	if (!(filp->f_mode & FMODE_WRITE))
-		return -XFS_ERROR(EBADF);
-
-	if (!S_ISREG(inode->i_mode))
-		return -XFS_ERROR(EINVAL);
-
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= XFS_ATTR_NONBLOCK;
-
-	if (filp->f_flags & O_DSYNC)
-		attr_flags |= XFS_ATTR_SYNC;
-
-	if (ioflags & IO_INVIS)
-		attr_flags |= XFS_ATTR_DMI;
-
-	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
-	return -error;
-}
-
-STATIC int
-xfs_ioc_bulkstat(
-	xfs_mount_t		*mp,
-	unsigned int		cmd,
-	void			__user *arg)
-{
-	xfs_fsop_bulkreq_t	bulkreq;
-	int			count;	/* # of records returned */
-	xfs_ino_t		inlast;	/* last inode number */
-	int			done;
-	int			error;
-
-	/* done = 1 if there are more stats to get and if bulkstat */
-	/* should be called again (unused here, but used in dmapi) */
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
-
-	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
-		return -XFS_ERROR(EFAULT);
-
-	if ((count = bulkreq.icount) <= 0)
-		return -XFS_ERROR(EINVAL);
-
-	if (bulkreq.ubuffer == NULL)
-		return -XFS_ERROR(EINVAL);
-
-	if (cmd == XFS_IOC_FSINUMBERS)
-		error = xfs_inumbers(mp, &inlast, &count,
-					bulkreq.ubuffer, xfs_inumbers_fmt);
-	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
-		error = xfs_bulkstat_single(mp, &inlast,
-						bulkreq.ubuffer, &done);
-	else	/* XFS_IOC_FSBULKSTAT */
-		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
-				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
-				     &done);
-
-	if (error)
-		return -error;
-
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -XFS_ERROR(EFAULT);
-
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -XFS_ERROR(EFAULT);
-	}
-
-	return 0;
-}
-
-STATIC int
-xfs_ioc_fsgeometry_v1(
-	xfs_mount_t		*mp,
-	void			__user *arg)
-{
-	xfs_fsop_geom_t         fsgeo;
-	int			error;
-
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
-	if (error)
-		return -error;
-
-	/*
-	 * Caller should have passed an argument of type
-	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
-	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
-	 */
-	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_ioc_fsgeometry(
-	xfs_mount_t		*mp,
-	void			__user *arg)
-{
-	xfs_fsop_geom_t		fsgeo;
-	int			error;
-
-	error = xfs_fs_geometry(mp, &fsgeo, 4);
-	if (error)
-		return -error;
-
-	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-/*
- * Linux extended inode flags interface.
- */
-
-STATIC unsigned int
-xfs_merge_ioc_xflags(
-	unsigned int	flags,
-	unsigned int	start)
-{
-	unsigned int	xflags = start;
-
-	if (flags & FS_IMMUTABLE_FL)
-		xflags |= XFS_XFLAG_IMMUTABLE;
-	else
-		xflags &= ~XFS_XFLAG_IMMUTABLE;
-	if (flags & FS_APPEND_FL)
-		xflags |= XFS_XFLAG_APPEND;
-	else
-		xflags &= ~XFS_XFLAG_APPEND;
-	if (flags & FS_SYNC_FL)
-		xflags |= XFS_XFLAG_SYNC;
-	else
-		xflags &= ~XFS_XFLAG_SYNC;
-	if (flags & FS_NOATIME_FL)
-		xflags |= XFS_XFLAG_NOATIME;
-	else
-		xflags &= ~XFS_XFLAG_NOATIME;
-	if (flags & FS_NODUMP_FL)
-		xflags |= XFS_XFLAG_NODUMP;
-	else
-		xflags &= ~XFS_XFLAG_NODUMP;
-
-	return xflags;
-}
-
-STATIC unsigned int
-xfs_di2lxflags(
-	__uint16_t	di_flags)
-{
-	unsigned int	flags = 0;
-
-	if (di_flags & XFS_DIFLAG_IMMUTABLE)
-		flags |= FS_IMMUTABLE_FL;
-	if (di_flags & XFS_DIFLAG_APPEND)
-		flags |= FS_APPEND_FL;
-	if (di_flags & XFS_DIFLAG_SYNC)
-		flags |= FS_SYNC_FL;
-	if (di_flags & XFS_DIFLAG_NOATIME)
-		flags |= FS_NOATIME_FL;
-	if (di_flags & XFS_DIFLAG_NODUMP)
-		flags |= FS_NODUMP_FL;
-	return flags;
-}
-
-STATIC int
-xfs_ioc_fsgetxattr(
-	xfs_inode_t		*ip,
-	int			attr,
-	void			__user *arg)
-{
-	struct fsxattr		fa;
-
-	memset(&fa, 0, sizeof(struct fsxattr));
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	fa.fsx_xflags = xfs_ip2xflags(ip);
-	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = xfs_get_projid(ip);
-
-	if (attr) {
-		if (ip->i_afp) {
-			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
-				fa.fsx_nextents = ip->i_afp->if_bytes /
-							sizeof(xfs_bmbt_rec_t);
-			else
-				fa.fsx_nextents = ip->i_d.di_anextents;
-		} else
-			fa.fsx_nextents = 0;
-	} else {
-		if (ip->i_df.if_flags & XFS_IFEXTENTS)
-			fa.fsx_nextents = ip->i_df.if_bytes /
-						sizeof(xfs_bmbt_rec_t);
-		else
-			fa.fsx_nextents = ip->i_d.di_nextents;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (copy_to_user(arg, &fa, sizeof(fa)))
-		return -EFAULT;
-	return 0;
-}
-
-STATIC void
-xfs_set_diflags(
-	struct xfs_inode	*ip,
-	unsigned int		xflags)
-{
-	unsigned int		di_flags;
-
-	/* can't set PREALLOC this way, just preserve it */
-	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
-	if (xflags & XFS_XFLAG_IMMUTABLE)
-		di_flags |= XFS_DIFLAG_IMMUTABLE;
-	if (xflags & XFS_XFLAG_APPEND)
-		di_flags |= XFS_DIFLAG_APPEND;
-	if (xflags & XFS_XFLAG_SYNC)
-		di_flags |= XFS_DIFLAG_SYNC;
-	if (xflags & XFS_XFLAG_NOATIME)
-		di_flags |= XFS_DIFLAG_NOATIME;
-	if (xflags & XFS_XFLAG_NODUMP)
-		di_flags |= XFS_DIFLAG_NODUMP;
-	if (xflags & XFS_XFLAG_PROJINHERIT)
-		di_flags |= XFS_DIFLAG_PROJINHERIT;
-	if (xflags & XFS_XFLAG_NODEFRAG)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (xflags & XFS_XFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
-	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
-		if (xflags & XFS_XFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (xflags & XFS_XFLAG_NOSYMLINKS)
-			di_flags |= XFS_DIFLAG_NOSYMLINKS;
-		if (xflags & XFS_XFLAG_EXTSZINHERIT)
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-	} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
-		if (xflags & XFS_XFLAG_REALTIME)
-			di_flags |= XFS_DIFLAG_REALTIME;
-		if (xflags & XFS_XFLAG_EXTSIZE)
-			di_flags |= XFS_DIFLAG_EXTSIZE;
-	}
-
-	ip->i_d.di_flags = di_flags;
-}
-
-STATIC void
-xfs_diflags_to_linux(
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-	unsigned int		xflags = xfs_ip2xflags(ip);
-
-	if (xflags & XFS_XFLAG_IMMUTABLE)
-		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
-	if (xflags & XFS_XFLAG_APPEND)
-		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
-	if (xflags & XFS_XFLAG_SYNC)
-		inode->i_flags |= S_SYNC;
-	else
-		inode->i_flags &= ~S_SYNC;
-	if (xflags & XFS_XFLAG_NOATIME)
-		inode->i_flags |= S_NOATIME;
-	else
-		inode->i_flags &= ~S_NOATIME;
-}
-
-#define FSX_PROJID	1
-#define FSX_EXTSIZE	2
-#define FSX_XFLAGS	4
-#define FSX_NONBLOCK	8
-
-STATIC int
-xfs_ioctl_setattr(
-	xfs_inode_t		*ip,
-	struct fsxattr		*fa,
-	int			mask)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	unsigned int		lock_flags = 0;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*olddquot = NULL;
-	int			code;
-
-	trace_xfs_ioctl_setattr(ip);
-
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	/*
-	 * Disallow 32bit project ids when projid32bit feature is not enabled.
-	 */
-	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
-			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return XFS_ERROR(EINVAL);
-
-	/*
-	 * If disk quotas is on, we make sure that the dquots do exist on disk,
-	 * before we start any other transactions. Trying to do this later
-	 * is messy. We don't care to take a readlock to look at the ids
-	 * in inode here, because we can't hold it across the trans_reserve.
-	 * If the IDs do change before we take the ilock, we're covered
-	 * because the i_*dquot fields will get updated anyway.
-	 */
-	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
-		if (code)
-			return code;
-	}
-
-	/*
-	 * For the other attributes, we acquire the inode lock and
-	 * first do an error checking pass.
-	 */
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
-	if (code)
-		goto error_return;
-
-	lock_flags = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, lock_flags);
-
-	/*
-	 * CAP_FOWNER overrides the following restrictions:
-	 *
-	 * The user ID of the calling process must be equal
-	 * to the file owner ID, except in cases where the
-	 * CAP_FSETID capability is applicable.
-	 */
-	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
-		code = XFS_ERROR(EPERM);
-		goto error_return;
-	}
-
-	/*
-	 * Do a quota reservation only if projid is actually going to change.
-	 */
-	if (mask & FSX_PROJID) {
-		if (XFS_IS_QUOTA_RUNNING(mp) &&
-		    XFS_IS_PQUOTA_ON(mp) &&
-		    xfs_get_projid(ip) != fa->fsx_projid) {
-			ASSERT(tp);
-			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
-			if (code)	/* out of quota */
-				goto error_return;
-		}
-	}
-
-	if (mask & FSX_EXTSIZE) {
-		/*
-		 * Can't change extent size if any extents are allocated.
-		 */
-		if (ip->i_d.di_nextents &&
-		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
-		     fa->fsx_extsize)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
-			goto error_return;
-		}
-
-		/*
-		 * Extent size must be a multiple of the appropriate block
-		 * size, if set at all. It must also be smaller than the
-		 * maximum extent size supported by the filesystem.
-		 *
-		 * Also, for non-realtime files, limit the extent size hint to
-		 * half the size of the AGs in the filesystem so alignment
-		 * doesn't result in extents larger than an AG.
-		 */
-		if (fa->fsx_extsize != 0) {
-			xfs_extlen_t    size;
-			xfs_fsblock_t   extsize_fsb;
-
-			extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-			if (extsize_fsb > MAXEXTLEN) {
-				code = XFS_ERROR(EINVAL);
-				goto error_return;
-			}
-
-			if (XFS_IS_REALTIME_INODE(ip) ||
-			    ((mask & FSX_XFLAGS) &&
-			    (fa->fsx_xflags & XFS_XFLAG_REALTIME))) {
-				size = mp->m_sb.sb_rextsize <<
-				       mp->m_sb.sb_blocklog;
-			} else {
-				size = mp->m_sb.sb_blocksize;
-				if (extsize_fsb > mp->m_sb.sb_agblocks / 2) {
-					code = XFS_ERROR(EINVAL);
-					goto error_return;
-				}
-			}
-
-			if (fa->fsx_extsize % size) {
-				code = XFS_ERROR(EINVAL);
-				goto error_return;
-			}
-		}
-	}
-
-
-	if (mask & FSX_XFLAGS) {
-		/*
-		 * Can't change realtime flag if any extents are allocated.
-		 */
-		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
-		    (XFS_IS_REALTIME_INODE(ip)) !=
-		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
-			goto error_return;
-		}
-
-		/*
-		 * If realtime flag is set then must have realtime data.
-		 */
-		if ((fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			if ((mp->m_sb.sb_rblocks == 0) ||
-			    (mp->m_sb.sb_rextsize == 0) ||
-			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
-				code = XFS_ERROR(EINVAL);
-				goto error_return;
-			}
-		}
-
-		/*
-		 * Can't modify an immutable/append-only file unless
-		 * we have appropriate permission.
-		 */
-		if ((ip->i_d.di_flags &
-				(XFS_DIFLAG_IMMUTABLE|XFS_DIFLAG_APPEND) ||
-		     (fa->fsx_xflags &
-				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
-		    !capable(CAP_LINUX_IMMUTABLE)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-	}
-
-	xfs_trans_ijoin(tp, ip);
-
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & FSX_PROJID) {
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
-
-		/*
-		 * Change the ownerships and register quota modifications
-		 * in the transaction.
-		 */
-		if (xfs_get_projid(ip) != fa->fsx_projid) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
-				olddquot = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
-			}
-			xfs_set_projid(ip, fa->fsx_projid);
-
-			/*
-			 * We may have to rev the inode as well as
-			 * the superblock version number since projids didn't
-			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
-			 */
-			if (ip->i_d.di_version == 1)
-				xfs_bump_ino_vers2(tp, ip);
-		}
-
-	}
-
-	if (mask & FSX_EXTSIZE)
-		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
-	if (mask & FSX_XFLAGS) {
-		xfs_set_diflags(ip, fa->fsx_xflags);
-		xfs_diflags_to_linux(ip);
-	}
-
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	XFS_STATS_INC(xs_ig_attrchg);
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
-	 * This is slightly sub-optimal in that truncates require
-	 * two sync transactions instead of one for wsync filesystems.
-	 * One for the truncate and one for the timestamps since we
-	 * don't want to change the timestamps unless we're sure the
-	 * truncate worked.  Truncates are less than 1% of the laddis
-	 * mix so this probably isn't worth the trouble to optimize.
-	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(tp);
-	code = xfs_trans_commit(tp, 0);
-	xfs_iunlock(ip, lock_flags);
-
-	/*
-	 * Release any dquot(s) the inode had kept before chown.
-	 */
-	xfs_qm_dqrele(olddquot);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-
-	return code;
-
- error_return:
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_trans_cancel(tp, 0);
-	if (lock_flags)
-		xfs_iunlock(ip, lock_flags);
-	return code;
-}
-
-STATIC int
-xfs_ioc_fssetxattr(
-	xfs_inode_t		*ip,
-	struct file		*filp,
-	void			__user *arg)
-{
-	struct fsxattr		fa;
-	unsigned int		mask;
-
-	if (copy_from_user(&fa, arg, sizeof(fa)))
-		return -EFAULT;
-
-	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		mask |= FSX_NONBLOCK;
-
-	return -xfs_ioctl_setattr(ip, &fa, mask);
-}
-
-STATIC int
-xfs_ioc_getxflags(
-	xfs_inode_t		*ip,
-	void			__user *arg)
-{
-	unsigned int		flags;
-
-	flags = xfs_di2lxflags(ip->i_d.di_flags);
-	if (copy_to_user(arg, &flags, sizeof(flags)))
-		return -EFAULT;
-	return 0;
-}
-
-STATIC int
-xfs_ioc_setxflags(
-	xfs_inode_t		*ip,
-	struct file		*filp,
-	void			__user *arg)
-{
-	struct fsxattr		fa;
-	unsigned int		flags;
-	unsigned int		mask;
-
-	if (copy_from_user(&flags, arg, sizeof(flags)))
-		return -EFAULT;
-
-	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
-		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL))
-		return -EOPNOTSUPP;
-
-	mask = FSX_XFLAGS;
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		mask |= FSX_NONBLOCK;
-	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
-
-	return -xfs_ioctl_setattr(ip, &fa, mask);
-}
-
-STATIC int
-xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
-{
-	struct getbmap __user	*base = *ap;
-
-	/* copy only getbmap portion (not getbmapx) */
-	if (copy_to_user(base, bmv, sizeof(struct getbmap)))
-		return XFS_ERROR(EFAULT);
-
-	*ap += sizeof(struct getbmap);
-	return 0;
-}
-
-STATIC int
-xfs_ioc_getbmap(
-	struct xfs_inode	*ip,
-	int			ioflags,
-	unsigned int		cmd,
-	void			__user *arg)
-{
-	struct getbmapx		bmx;
-	int			error;
-
-	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
-		return -XFS_ERROR(EFAULT);
-
-	if (bmx.bmv_count < 2)
-		return -XFS_ERROR(EINVAL);
-
-	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
-	if (ioflags & IO_INVIS)
-		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
-
-	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
-			    (struct getbmap *)arg+1);
-	if (error)
-		return -error;
-
-	/* copy back header - only size of getbmap */
-	if (copy_to_user(arg, &bmx, sizeof(struct getbmap)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
-{
-	struct getbmapx __user	*base = *ap;
-
-	if (copy_to_user(base, bmv, sizeof(struct getbmapx)))
-		return XFS_ERROR(EFAULT);
-
-	*ap += sizeof(struct getbmapx);
-	return 0;
-}
-
-STATIC int
-xfs_ioc_getbmapx(
-	struct xfs_inode	*ip,
-	void			__user *arg)
-{
-	struct getbmapx		bmx;
-	int			error;
-
-	if (copy_from_user(&bmx, arg, sizeof(bmx)))
-		return -XFS_ERROR(EFAULT);
-
-	if (bmx.bmv_count < 2)
-		return -XFS_ERROR(EINVAL);
-
-	if (bmx.bmv_iflags & (~BMV_IF_VALID))
-		return -XFS_ERROR(EINVAL);
-
-	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
-			    (struct getbmapx *)arg+1);
-	if (error)
-		return -error;
-
-	/* copy back header */
-	if (copy_to_user(arg, &bmx, sizeof(struct getbmapx)))
-		return -XFS_ERROR(EFAULT);
-
-	return 0;
-}
-
-/*
- * Note: some of the ioctl's return positive numbers as a
- * byte count indicating success, such as readlink_by_handle.
- * So we don't "sign flip" like most other routines.  This means
- * true errors need to be returned as a negative value.
- */
-long
-xfs_file_ioctl(
-	struct file		*filp,
-	unsigned int		cmd,
-	unsigned long		p)
-{
-	struct inode		*inode = filp->f_path.dentry->d_inode;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	void			__user *arg = (void __user *)p;
-	int			ioflags = 0;
-	int			error;
-
-	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	trace_xfs_file_ioctl(ip);
-
-	switch (cmd) {
-	case FITRIM:
-		return xfs_ioc_trim(mp, arg);
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-	case XFS_IOC_ZERO_RANGE: {
-		xfs_flock64_t		bf;
-
-		if (copy_from_user(&bf, arg, sizeof(bf)))
-			return -XFS_ERROR(EFAULT);
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
-	}
-	case XFS_IOC_DIOINFO: {
-		struct dioattr	da;
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
-
-		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
-		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-
-		if (copy_to_user(arg, &da, sizeof(da)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_FSBULKSTAT_SINGLE:
-	case XFS_IOC_FSBULKSTAT:
-	case XFS_IOC_FSINUMBERS:
-		return xfs_ioc_bulkstat(mp, cmd, arg);
-
-	case XFS_IOC_FSGEOMETRY_V1:
-		return xfs_ioc_fsgeometry_v1(mp, arg);
-
-	case XFS_IOC_FSGEOMETRY:
-		return xfs_ioc_fsgeometry(mp, arg);
-
-	case XFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
-
-	case XFS_IOC_FSGETXATTR:
-		return xfs_ioc_fsgetxattr(ip, 0, arg);
-	case XFS_IOC_FSGETXATTRA:
-		return xfs_ioc_fsgetxattr(ip, 1, arg);
-	case XFS_IOC_FSSETXATTR:
-		return xfs_ioc_fssetxattr(ip, filp, arg);
-	case XFS_IOC_GETXFLAGS:
-		return xfs_ioc_getxflags(ip, arg);
-	case XFS_IOC_SETXFLAGS:
-		return xfs_ioc_setxflags(ip, filp, arg);
-
-	case XFS_IOC_FSSETDM: {
-		struct fsdmidata	dmi;
-
-		if (copy_from_user(&dmi, arg, sizeof(dmi)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
-				dmi.fsd_dmstate);
-		return -error;
-	}
-
-	case XFS_IOC_GETBMAP:
-	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
-
-	case XFS_IOC_GETBMAPX:
-		return xfs_ioc_getbmapx(ip, arg);
-
-	case XFS_IOC_FD_TO_HANDLE:
-	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(hreq)))
-			return -XFS_ERROR(EFAULT);
-		return xfs_find_handle(cmd, &hreq);
-	}
-	case XFS_IOC_OPEN_BY_HANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -XFS_ERROR(EFAULT);
-		return xfs_open_by_handle(filp, &hreq);
-	}
-	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(filp, arg);
-
-	case XFS_IOC_READLINK_BY_HANDLE: {
-		xfs_fsop_handlereq_t	hreq;
-
-		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -XFS_ERROR(EFAULT);
-		return xfs_readlink_by_handle(filp, &hreq);
-	}
-	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(filp, arg);
-
-	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(filp, arg);
-
-	case XFS_IOC_SWAPEXT: {
-		struct xfs_swapext	sxp;
-
-		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
-			return -XFS_ERROR(EFAULT);
-		error = xfs_swapext(&sxp);
-		return -error;
-	}
-
-	case XFS_IOC_FSCOUNTS: {
-		xfs_fsop_counts_t out;
-
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_SET_RESBLKS: {
-		xfs_fsop_resblks_t inout;
-		__uint64_t	   in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
-			return -XFS_ERROR(EROFS);
-
-		if (copy_from_user(&inout, arg, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-
-		/* input parameter is passed in resblks field of structure */
-		in = inout.resblks;
-		error = xfs_reserve_blocks(mp, &in, &inout);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &inout, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_GET_RESBLKS: {
-		xfs_fsop_resblks_t out;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_reserve_blocks(mp, NULL, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-
-		return 0;
-	}
-
-	case XFS_IOC_FSGROWFSDATA: {
-		xfs_growfs_data_t in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_data(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSLOG: {
-		xfs_growfs_log_t in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_log(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSRT: {
-		xfs_growfs_rt_t in;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_rt(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_GOINGDOWN: {
-		__uint32_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (get_user(in, (__uint32_t __user *)arg))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_fs_goingdown(mp, in);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_INJECTION: {
-		xfs_error_injection_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_errortag_add(in.errtag, mp);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_CLEARALL:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_errortag_clearall(mp, 1);
-		return -error;
-
-	default:
-		return -ENOTTY;
-	}
-}
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.h b/fs/xfs/linux-2.6/xfs_ioctl.h
deleted file mode 100644
index d56173b..0000000
--- a/fs/xfs/linux-2.6/xfs_ioctl.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2008 Silicon Graphics, Inc.
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
-#ifndef __XFS_IOCTL_H__
-#define __XFS_IOCTL_H__
-
-extern int
-xfs_ioc_space(
-	struct xfs_inode	*ip,
-	struct inode		*inode,
-	struct file		*filp,
-	int			ioflags,
-	unsigned int		cmd,
-	xfs_flock64_t		*bf);
-
-extern int
-xfs_find_handle(
-	unsigned int		cmd,
-	xfs_fsop_handlereq_t	*hreq);
-
-extern int
-xfs_open_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq);
-
-extern int
-xfs_readlink_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq);
-
-extern int
-xfs_attrmulti_attr_get(
-	struct inode		*inode,
-	unsigned char		*name,
-	unsigned char		__user *ubuf,
-	__uint32_t		*len,
-	__uint32_t		flags);
-
-extern int
-xfs_attrmulti_attr_set(
-	struct inode		*inode,
-	unsigned char		*name,
-	const unsigned char	__user *ubuf,
-	__uint32_t		len,
-	__uint32_t		flags);
-
-extern int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	__uint32_t		flags);
-
-extern struct dentry *
-xfs_handle_to_dentry(
-	struct file		*parfilp,
-	void __user		*uhandle,
-	u32			hlen);
-
-extern long
-xfs_file_ioctl(
-	struct file		*filp,
-	unsigned int		cmd,
-	unsigned long		p);
-
-extern long
-xfs_file_compat_ioctl(
-	struct file		*file,
-	unsigned int		cmd,
-	unsigned long		arg);
-
-#endif
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
deleted file mode 100644
index 54e623b..0000000
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ /dev/null
@@ -1,672 +0,0 @@
-/*
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.
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
-#include <linux/compat.h>
-#include <linux/ioctl.h>
-#include <linux/mount.h>
-#include <linux/slab.h>
-#include <asm/uaccess.h>
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_vnode.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_itable.h"
-#include "xfs_error.h"
-#include "xfs_dfrag.h"
-#include "xfs_vnodeops.h"
-#include "xfs_fsops.h"
-#include "xfs_alloc.h"
-#include "xfs_rtalloc.h"
-#include "xfs_attr.h"
-#include "xfs_ioctl.h"
-#include "xfs_ioctl32.h"
-#include "xfs_trace.h"
-
-#define  _NATIVE_IOC(cmd, type) \
-	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
-
-#ifdef BROKEN_X86_ALIGNMENT
-STATIC int
-xfs_compat_flock64_copyin(
-	xfs_flock64_t		*bf,
-	compat_xfs_flock64_t	__user *arg32)
-{
-	if (get_user(bf->l_type,	&arg32->l_type) ||
-	    get_user(bf->l_whence,	&arg32->l_whence) ||
-	    get_user(bf->l_start,	&arg32->l_start) ||
-	    get_user(bf->l_len,		&arg32->l_len) ||
-	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
-	    get_user(bf->l_pid,		&arg32->l_pid) ||
-	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_compat_ioc_fsgeometry_v1(
-	struct xfs_mount	  *mp,
-	compat_xfs_fsop_geom_v1_t __user *arg32)
-{
-	xfs_fsop_geom_t		  fsgeo;
-	int			  error;
-
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
-	if (error)
-		return -error;
-	/* The 32-bit variant simply has some padding at the end */
-	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_compat_growfs_data_copyin(
-	struct xfs_growfs_data	 *in,
-	compat_xfs_growfs_data_t __user *arg32)
-{
-	if (get_user(in->newblocks, &arg32->newblocks) ||
-	    get_user(in->imaxpct,   &arg32->imaxpct))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_compat_growfs_rt_copyin(
-	struct xfs_growfs_rt	 *in,
-	compat_xfs_growfs_rt_t	__user *arg32)
-{
-	if (get_user(in->newblocks, &arg32->newblocks) ||
-	    get_user(in->extsize,   &arg32->extsize))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-STATIC int
-xfs_inumbers_fmt_compat(
-	void			__user *ubuffer,
-	const xfs_inogrp_t	*buffer,
-	long			count,
-	long			*written)
-{
-	compat_xfs_inogrp_t	__user *p32 = ubuffer;
-	long			i;
-
-	for (i = 0; i < count; i++) {
-		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
-		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
-		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -XFS_ERROR(EFAULT);
-	}
-	*written = count * sizeof(*p32);
-	return 0;
-}
-
-#else
-#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
-#endif	/* BROKEN_X86_ALIGNMENT */
-
-STATIC int
-xfs_ioctl32_bstime_copyin(
-	xfs_bstime_t		*bstime,
-	compat_xfs_bstime_t	__user *bstime32)
-{
-	compat_time_t		sec32;	/* tv_sec differs on 64 vs. 32 */
-
-	if (get_user(sec32,		&bstime32->tv_sec)	||
-	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
-		return -XFS_ERROR(EFAULT);
-	bstime->tv_sec = sec32;
-	return 0;
-}
-
-/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
-STATIC int
-xfs_ioctl32_bstat_copyin(
-	xfs_bstat_t		*bstat,
-	compat_xfs_bstat_t	__user *bstat32)
-{
-	if (get_user(bstat->bs_ino,	&bstat32->bs_ino)	||
-	    get_user(bstat->bs_mode,	&bstat32->bs_mode)	||
-	    get_user(bstat->bs_nlink,	&bstat32->bs_nlink)	||
-	    get_user(bstat->bs_uid,	&bstat32->bs_uid)	||
-	    get_user(bstat->bs_gid,	&bstat32->bs_gid)	||
-	    get_user(bstat->bs_rdev,	&bstat32->bs_rdev)	||
-	    get_user(bstat->bs_blksize,	&bstat32->bs_blksize)	||
-	    get_user(bstat->bs_size,	&bstat32->bs_size)	||
-	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
-	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
-	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
-	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
-	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
-	    get_user(bstat->bs_projid_lo, &bstat32->bs_projid_lo) ||
-	    get_user(bstat->bs_projid_hi, &bstat32->bs_projid_hi) ||
-	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
-	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
-	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-/* XFS_IOC_FSBULKSTAT and friends */
-
-STATIC int
-xfs_bstime_store_compat(
-	compat_xfs_bstime_t	__user *p32,
-	const xfs_bstime_t	*p)
-{
-	__s32			sec32;
-
-	sec32 = p->tv_sec;
-	if (put_user(sec32, &p32->tv_sec) ||
-	    put_user(p->tv_nsec, &p32->tv_nsec))
-		return -XFS_ERROR(EFAULT);
-	return 0;
-}
-
-/* Return 0 on success or positive error (to xfs_bulkstat()) */
-STATIC int
-xfs_bulkstat_one_fmt_compat(
-	void			__user *ubuffer,
-	int			ubsize,
-	int			*ubused,
-	const xfs_bstat_t	*buffer)
-{
-	compat_xfs_bstat_t	__user *p32 = ubuffer;
-
-	if (ubsize < sizeof(*p32))
-		return XFS_ERROR(ENOMEM);
-
-	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
-	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
-	    put_user(buffer->bs_nlink,	  &p32->bs_nlink)	||
-	    put_user(buffer->bs_uid,	  &p32->bs_uid)		||
-	    put_user(buffer->bs_gid,	  &p32->bs_gid)		||
-	    put_user(buffer->bs_rdev,	  &p32->bs_rdev)	||
-	    put_user(buffer->bs_blksize,  &p32->bs_blksize)	||
-	    put_user(buffer->bs_size,	  &p32->bs_size)	||
-	    xfs_bstime_store_compat(&p32->bs_atime, &buffer->bs_atime) ||
-	    xfs_bstime_store_compat(&p32->bs_mtime, &buffer->bs_mtime) ||
-	    xfs_bstime_store_compat(&p32->bs_ctime, &buffer->bs_ctime) ||
-	    put_user(buffer->bs_blocks,	  &p32->bs_blocks)	||
-	    put_user(buffer->bs_xflags,	  &p32->bs_xflags)	||
-	    put_user(buffer->bs_extsize,  &p32->bs_extsize)	||
-	    put_user(buffer->bs_extents,  &p32->bs_extents)	||
-	    put_user(buffer->bs_gen,	  &p32->bs_gen)		||
-	    put_user(buffer->bs_projid,	  &p32->bs_projid)	||
-	    put_user(buffer->bs_projid_hi,	&p32->bs_projid_hi)	||
-	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask)	||
-	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
-	    put_user(buffer->bs_aextents, &p32->bs_aextents))
-		return XFS_ERROR(EFAULT);
-	if (ubused)
-		*ubused = sizeof(*p32);
-	return 0;
-}
-
-STATIC int
-xfs_bulkstat_one_compat(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* buffer to place output in */
-	int		ubsize,		/* size of buffer */
-	int		*ubused,	/* bytes used by me */
-	int		*stat)		/* BULKSTAT_RV_... */
-{
-	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
-				    xfs_bulkstat_one_fmt_compat,
-				    ubused, stat);
-}
-
-/* copied from xfs_ioctl.c */
-STATIC int
-xfs_compat_ioc_bulkstat(
-	xfs_mount_t		  *mp,
-	unsigned int		  cmd,
-	compat_xfs_fsop_bulkreq_t __user *p32)
-{
-	u32			addr;
-	xfs_fsop_bulkreq_t	bulkreq;
-	int			count;	/* # of records returned */
-	xfs_ino_t		inlast;	/* last inode number */
-	int			done;
-	int			error;
-
-	/* done = 1 if there are more stats to get and if bulkstat */
-	/* should be called again (unused here, but used in dmapi) */
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
-
-	if (get_user(addr, &p32->lastip))
-		return -XFS_ERROR(EFAULT);
-	bulkreq.lastip = compat_ptr(addr);
-	if (get_user(bulkreq.icount, &p32->icount) ||
-	    get_user(addr, &p32->ubuffer))
-		return -XFS_ERROR(EFAULT);
-	bulkreq.ubuffer = compat_ptr(addr);
-	if (get_user(addr, &p32->ocount))
-		return -XFS_ERROR(EFAULT);
-	bulkreq.ocount = compat_ptr(addr);
-
-	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
-		return -XFS_ERROR(EFAULT);
-
-	if ((count = bulkreq.icount) <= 0)
-		return -XFS_ERROR(EINVAL);
-
-	if (bulkreq.ubuffer == NULL)
-		return -XFS_ERROR(EINVAL);
-
-	if (cmd == XFS_IOC_FSINUMBERS_32) {
-		error = xfs_inumbers(mp, &inlast, &count,
-				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
-	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
-		int res;
-
-		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), 0, &res);
-	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
-		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
-			bulkreq.ubuffer, &done);
-	} else
-		error = XFS_ERROR(EINVAL);
-	if (error)
-		return -error;
-
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -XFS_ERROR(EFAULT);
-
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -XFS_ERROR(EFAULT);
-	}
-
-	return 0;
-}
-
-STATIC int
-xfs_compat_handlereq_copyin(
-	xfs_fsop_handlereq_t		*hreq,
-	compat_xfs_fsop_handlereq_t	__user *arg32)
-{
-	compat_xfs_fsop_handlereq_t	hreq32;
-
-	if (copy_from_user(&hreq32, arg32, sizeof(compat_xfs_fsop_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	hreq->fd = hreq32.fd;
-	hreq->path = compat_ptr(hreq32.path);
-	hreq->oflags = hreq32.oflags;
-	hreq->ihandle = compat_ptr(hreq32.ihandle);
-	hreq->ihandlen = hreq32.ihandlen;
-	hreq->ohandle = compat_ptr(hreq32.ohandle);
-	hreq->ohandlen = compat_ptr(hreq32.ohandlen);
-
-	return 0;
-}
-
-STATIC struct dentry *
-xfs_compat_handlereq_to_dentry(
-	struct file		*parfilp,
-	compat_xfs_fsop_handlereq_t *hreq)
-{
-	return xfs_handle_to_dentry(parfilp,
-			compat_ptr(hreq->ihandle), hreq->ihandlen);
-}
-
-STATIC int
-xfs_compat_attrlist_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	attrlist_cursor_kern_t	*cursor;
-	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
-	struct dentry		*dentry;
-	char			*kbuf;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&al_hreq, arg,
-			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
-		return -XFS_ERROR(EINVAL);
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -XFS_ERROR(EINVAL);
-
-	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	error = -ENOMEM;
-	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
-	if (!kbuf)
-		goto out_dput;
-
-	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
-	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
-		error = -EFAULT;
-
- out_kfree:
-	kfree(kbuf);
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-STATIC int
-xfs_compat_attrmulti_by_handle(
-	struct file				*parfilp,
-	void					__user *arg)
-{
-	int					error;
-	compat_xfs_attr_multiop_t		*ops;
-	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
-	struct dentry				*dentry;
-	unsigned int				i, size;
-	unsigned char				*attr_name;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&am_hreq, arg,
-			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	/* overflow check */
-	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
-		return -E2BIG;
-
-	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	error = E2BIG;
-	size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
-	if (!size || size > 16 * PAGE_SIZE)
-		goto out_dput;
-
-	ops = memdup_user(compat_ptr(am_hreq.ops), size);
-	if (IS_ERR(ops)) {
-		error = PTR_ERR(ops);
-		goto out_dput;
-	}
-
-	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
-	if (!attr_name)
-		goto out_kfree_ops;
-
-	error = 0;
-	for (i = 0; i < am_hreq.opcount; i++) {
-		ops[i].am_error = strncpy_from_user((char *)attr_name,
-				compat_ptr(ops[i].am_attrname),
-				MAXNAMELEN);
-		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
-		if (ops[i].am_error < 0)
-			break;
-
-		switch (ops[i].am_opcode) {
-		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(
-					dentry->d_inode, attr_name,
-					compat_ptr(ops[i].am_attrvalue),
-					&ops[i].am_length, ops[i].am_flags);
-			break;
-		case ATTR_OP_SET:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					dentry->d_inode, attr_name,
-					compat_ptr(ops[i].am_attrvalue),
-					ops[i].am_length, ops[i].am_flags);
-			mnt_drop_write(parfilp->f_path.mnt);
-			break;
-		case ATTR_OP_REMOVE:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					dentry->d_inode, attr_name,
-					ops[i].am_flags);
-			mnt_drop_write(parfilp->f_path.mnt);
-			break;
-		default:
-			ops[i].am_error = EINVAL;
-		}
-	}
-
-	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
-		error = XFS_ERROR(EFAULT);
-
-	kfree(attr_name);
- out_kfree_ops:
-	kfree(ops);
- out_dput:
-	dput(dentry);
-	return -error;
-}
-
-STATIC int
-xfs_compat_fssetdm_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	struct fsdmidata	fsd;
-	compat_xfs_fsop_setdm_handlereq_t dmhreq;
-	struct dentry		*dentry;
-
-	if (!capable(CAP_MKNOD))
-		return -XFS_ERROR(EPERM);
-	if (copy_from_user(&dmhreq, arg,
-			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
-
-	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
-		error = -XFS_ERROR(EPERM);
-		goto out;
-	}
-
-	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
-		error = -XFS_ERROR(EFAULT);
-		goto out;
-	}
-
-	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
-				 fsd.fsd_dmstate);
-
-out:
-	dput(dentry);
-	return error;
-}
-
-long
-xfs_file_compat_ioctl(
-	struct file		*filp,
-	unsigned		cmd,
-	unsigned long		p)
-{
-	struct inode		*inode = filp->f_path.dentry->d_inode;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	void			__user *arg = (void __user *)p;
-	int			ioflags = 0;
-	int			error;
-
-	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	trace_xfs_file_compat_ioctl(ip);
-
-	switch (cmd) {
-	/* No size or alignment issues on any arch */
-	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY:
-	case XFS_IOC_FSGETXATTR:
-	case XFS_IOC_FSSETXATTR:
-	case XFS_IOC_FSGETXATTRA:
-	case XFS_IOC_FSSETDM:
-	case XFS_IOC_GETBMAP:
-	case XFS_IOC_GETBMAPA:
-	case XFS_IOC_GETBMAPX:
-	case XFS_IOC_FSCOUNTS:
-	case XFS_IOC_SET_RESBLKS:
-	case XFS_IOC_GET_RESBLKS:
-	case XFS_IOC_FSGROWFSLOG:
-	case XFS_IOC_GOINGDOWN:
-	case XFS_IOC_ERROR_INJECTION:
-	case XFS_IOC_ERROR_CLEARALL:
-		return xfs_file_ioctl(filp, cmd, p);
-#ifndef BROKEN_X86_ALIGNMENT
-	/* These are handled fine if no alignment issues */
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-	case XFS_IOC_FSGEOMETRY_V1:
-	case XFS_IOC_FSGROWFSDATA:
-	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_ZERO_RANGE:
-		return xfs_file_ioctl(filp, cmd, p);
-#else
-	case XFS_IOC_ALLOCSP_32:
-	case XFS_IOC_FREESP_32:
-	case XFS_IOC_ALLOCSP64_32:
-	case XFS_IOC_FREESP64_32:
-	case XFS_IOC_RESVSP_32:
-	case XFS_IOC_UNRESVSP_32:
-	case XFS_IOC_RESVSP64_32:
-	case XFS_IOC_UNRESVSP64_32:
-	case XFS_IOC_ZERO_RANGE_32: {
-		struct xfs_flock64	bf;
-
-		if (xfs_compat_flock64_copyin(&bf, arg))
-			return -XFS_ERROR(EFAULT);
-		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
-	}
-	case XFS_IOC_FSGEOMETRY_V1_32:
-		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
-	case XFS_IOC_FSGROWFSDATA_32: {
-		struct xfs_growfs_data	in;
-
-		if (xfs_compat_growfs_data_copyin(&in, arg))
-			return -XFS_ERROR(EFAULT);
-		error = xfs_growfs_data(mp, &in);
-		return -error;
-	}
-	case XFS_IOC_FSGROWFSRT_32: {
-		struct xfs_growfs_rt	in;
-
-		if (xfs_compat_growfs_rt_copyin(&in, arg))
-			return -XFS_ERROR(EFAULT);
-		error = xfs_growfs_rt(mp, &in);
-		return -error;
-	}
-#endif
-	/* long changes size, but xfs only copiese out 32 bits */
-	case XFS_IOC_GETXFLAGS_32:
-	case XFS_IOC_SETXFLAGS_32:
-	case XFS_IOC_GETVERSION_32:
-		cmd = _NATIVE_IOC(cmd, long);
-		return xfs_file_ioctl(filp, cmd, p);
-	case XFS_IOC_SWAPEXT_32: {
-		struct xfs_swapext	  sxp;
-		struct compat_xfs_swapext __user *sxu = arg;
-
-		/* Bulk copy in up to the sx_stat field, then copy bstat */
-		if (copy_from_user(&sxp, sxu,
-				   offsetof(struct xfs_swapext, sx_stat)) ||
-		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
-			return -XFS_ERROR(EFAULT);
-		error = xfs_swapext(&sxp);
-		return -error;
-	}
-	case XFS_IOC_FSBULKSTAT_32:
-	case XFS_IOC_FSBULKSTAT_SINGLE_32:
-	case XFS_IOC_FSINUMBERS_32:
-		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
-	case XFS_IOC_FD_TO_HANDLE_32:
-	case XFS_IOC_PATH_TO_HANDLE_32:
-	case XFS_IOC_PATH_TO_FSHANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
-		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
-		return xfs_find_handle(cmd, &hreq);
-	}
-	case XFS_IOC_OPEN_BY_HANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
-		return xfs_open_by_handle(filp, &hreq);
-	}
-	case XFS_IOC_READLINK_BY_HANDLE_32: {
-		struct xfs_fsop_handlereq	hreq;
-
-		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
-		return xfs_readlink_by_handle(filp, &hreq);
-	}
-	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
-		return xfs_compat_attrlist_by_handle(filp, arg);
-	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
-		return xfs_compat_attrmulti_by_handle(filp, arg);
-	case XFS_IOC_FSSETDM_BY_HANDLE_32:
-		return xfs_compat_fssetdm_by_handle(filp, arg);
-	default:
-		return -XFS_ERROR(ENOIOCTLCMD);
-	}
-}
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.h b/fs/xfs/linux-2.6/xfs_ioctl32.h
deleted file mode 100644
index 80f4060..0000000
--- a/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ /dev/null
@@ -1,237 +0,0 @@
-/*
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_IOCTL32_H__
-#define __XFS_IOCTL32_H__
-
-#include <linux/compat.h>
-
-/*
- * on 32-bit arches, ioctl argument structures may have different sizes
- * and/or alignment.  We define compat structures which match the
- * 32-bit sizes/alignments here, and their associated ioctl numbers.
- *
- * xfs_ioctl32.c contains routines to copy these structures in and out.
- */
-
-/* stock kernel-level ioctls we support */
-#define XFS_IOC_GETXFLAGS_32	FS_IOC32_GETFLAGS
-#define XFS_IOC_SETXFLAGS_32	FS_IOC32_SETFLAGS
-#define XFS_IOC_GETVERSION_32	FS_IOC32_GETVERSION
-
-/*
- * On intel, even if sizes match, alignment and/or padding may differ.
- */
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
-#define BROKEN_X86_ALIGNMENT
-#define __compat_packed __attribute__((packed))
-#else
-#define __compat_packed
-#endif
-
-typedef struct compat_xfs_bstime {
-	compat_time_t	tv_sec;		/* seconds		*/
-	__s32		tv_nsec;	/* and nanoseconds	*/
-} compat_xfs_bstime_t;
-
-typedef struct compat_xfs_bstat {
-	__u64		bs_ino;		/* inode number			*/
-	__u16		bs_mode;	/* type and mode		*/
-	__u16		bs_nlink;	/* number of links		*/
-	__u32		bs_uid;		/* user id			*/
-	__u32		bs_gid;		/* group id			*/
-	__u32		bs_rdev;	/* device value			*/
-	__s32		bs_blksize;	/* block size			*/
-	__s64		bs_size;	/* file size			*/
-	compat_xfs_bstime_t bs_atime;	/* access time			*/
-	compat_xfs_bstime_t bs_mtime;	/* modify time			*/
-	compat_xfs_bstime_t bs_ctime;	/* inode change time		*/
-	int64_t		bs_blocks;	/* number of blocks		*/
-	__u32		bs_xflags;	/* extended flags		*/
-	__s32		bs_extsize;	/* extent size			*/
-	__s32		bs_extents;	/* number of extents		*/
-	__u32		bs_gen;		/* generation count		*/
-	__u16		bs_projid_lo;	/* lower part of project id	*/
-#define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
-	__u16		bs_projid_hi;	/* high part of project id	*/
-	unsigned char	bs_pad[12];	/* pad space, unused		*/
-	__u32		bs_dmevmask;	/* DMIG event mask		*/
-	__u16		bs_dmstate;	/* DMIG state info		*/
-	__u16		bs_aextents;	/* attribute number of extents	*/
-} __compat_packed compat_xfs_bstat_t;
-
-typedef struct compat_xfs_fsop_bulkreq {
-	compat_uptr_t	lastip;		/* last inode # pointer		*/
-	__s32		icount;		/* count of entries in buffer	*/
-	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
-	compat_uptr_t	ocount;		/* output count pointer		*/
-} compat_xfs_fsop_bulkreq_t;
-
-#define XFS_IOC_FSBULKSTAT_32 \
-	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
-#define XFS_IOC_FSBULKSTAT_SINGLE_32 \
-	_IOWR('X', 102, struct compat_xfs_fsop_bulkreq)
-#define XFS_IOC_FSINUMBERS_32 \
-	_IOWR('X', 103, struct compat_xfs_fsop_bulkreq)
-
-typedef struct compat_xfs_fsop_handlereq {
-	__u32		fd;		/* fd for FD_TO_HANDLE		*/
-	compat_uptr_t	path;		/* user pathname		*/
-	__u32		oflags;		/* open flags			*/
-	compat_uptr_t	ihandle;	/* user supplied handle		*/
-	__u32		ihandlen;	/* user supplied length		*/
-	compat_uptr_t	ohandle;	/* user buffer for handle	*/
-	compat_uptr_t	ohandlen;	/* user buffer length		*/
-} compat_xfs_fsop_handlereq_t;
-
-#define XFS_IOC_PATH_TO_FSHANDLE_32 \
-	_IOWR('X', 104, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_PATH_TO_HANDLE_32 \
-	_IOWR('X', 105, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_FD_TO_HANDLE_32 \
-	_IOWR('X', 106, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_OPEN_BY_HANDLE_32 \
-	_IOWR('X', 107, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_READLINK_BY_HANDLE_32 \
-	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
-
-/* The bstat field in the swapext struct needs translation */
-typedef struct compat_xfs_swapext {
-	__int64_t		sx_version;	/* version */
-	__int64_t		sx_fdtarget;	/* fd of target file */
-	__int64_t		sx_fdtmp;	/* fd of tmp file */
-	xfs_off_t		sx_offset;	/* offset into file */
-	xfs_off_t		sx_length;	/* leng from offset */
-	char			sx_pad[16];	/* pad space, unused */
-	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
-} __compat_packed compat_xfs_swapext_t;
-
-#define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
-
-typedef struct compat_xfs_fsop_attrlist_handlereq {
-	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
-	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
-	__u32				flags;	/* which namespace to use */
-	__u32				buflen;	/* length of buffer supplied */
-	compat_uptr_t			buffer;	/* returned names */
-} __compat_packed compat_xfs_fsop_attrlist_handlereq_t;
-
-/* Note: actually this is read/write */
-#define XFS_IOC_ATTRLIST_BY_HANDLE_32 \
-	_IOW('X', 122, struct compat_xfs_fsop_attrlist_handlereq)
-
-/* am_opcodes defined in xfs_fs.h */
-typedef struct compat_xfs_attr_multiop {
-	__u32		am_opcode;
-	__s32		am_error;
-	compat_uptr_t	am_attrname;
-	compat_uptr_t	am_attrvalue;
-	__u32		am_length;
-	__u32		am_flags;
-} compat_xfs_attr_multiop_t;
-
-typedef struct compat_xfs_fsop_attrmulti_handlereq {
-	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
-	__u32				opcount;/* count of following multiop */
-	/* ptr to compat_xfs_attr_multiop */
-	compat_uptr_t			ops; /* attr_multi data */
-} compat_xfs_fsop_attrmulti_handlereq_t;
-
-#define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
-	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
-
-typedef struct compat_xfs_fsop_setdm_handlereq {
-	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
-	/* ptr to struct fsdmidata */
-	compat_uptr_t			data;	/* DMAPI data   */
-} compat_xfs_fsop_setdm_handlereq_t;
-
-#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
-	_IOW('X', 121, struct compat_xfs_fsop_setdm_handlereq)
-
-#ifdef BROKEN_X86_ALIGNMENT
-/* on ia32 l_start is on a 32-bit boundary */
-typedef struct compat_xfs_flock64 {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start	__attribute__((packed));
-			/* len == 0 means until end of file */
-	__s64		l_len __attribute__((packed));
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area */
-} compat_xfs_flock64_t;
-
-#define XFS_IOC_ALLOCSP_32	_IOW('X', 10, struct compat_xfs_flock64)
-#define XFS_IOC_FREESP_32	_IOW('X', 11, struct compat_xfs_flock64)
-#define XFS_IOC_ALLOCSP64_32	_IOW('X', 36, struct compat_xfs_flock64)
-#define XFS_IOC_FREESP64_32	_IOW('X', 37, struct compat_xfs_flock64)
-#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
-#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
-#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
-#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
-#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
-
-typedef struct compat_xfs_fsop_geom_v1 {
-	__u32		blocksize;	/* filesystem (data) block size */
-	__u32		rtextsize;	/* realtime extent size		*/
-	__u32		agblocks;	/* fsblocks in an AG		*/
-	__u32		agcount;	/* number of allocation groups	*/
-	__u32		logblocks;	/* fsblocks in the log		*/
-	__u32		sectsize;	/* (data) sector size, bytes	*/
-	__u32		inodesize;	/* inode size in bytes		*/
-	__u32		imaxpct;	/* max allowed inode space(%)	*/
-	__u64		datablocks;	/* fsblocks in data subvolume	*/
-	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
-	__u64		rtextents;	/* rt extents in realtime subvol*/
-	__u64		logstart;	/* starting fsblock of the log	*/
-	unsigned char	uuid[16];	/* unique id of the filesystem	*/
-	__u32		sunit;		/* stripe unit, fsblocks	*/
-	__u32		swidth;		/* stripe width, fsblocks	*/
-	__s32		version;	/* structure version		*/
-	__u32		flags;		/* superblock version flags	*/
-	__u32		logsectsize;	/* log sector size, bytes	*/
-	__u32		rtsectsize;	/* realtime sector size, bytes	*/
-	__u32		dirblocksize;	/* directory block size, bytes	*/
-} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
-
-#define XFS_IOC_FSGEOMETRY_V1_32  \
-	_IOR('X', 100, struct compat_xfs_fsop_geom_v1)
-
-typedef struct compat_xfs_inogrp {
-	__u64		xi_startino;	/* starting inode number	*/
-	__s32		xi_alloccount;	/* # bits set in allocmask	*/
-	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} __attribute__((packed)) compat_xfs_inogrp_t;
-
-/* These growfs input structures have padding on the end, so must translate */
-typedef struct compat_xfs_growfs_data {
-	__u64		newblocks;	/* new data subvol size, fsblocks */
-	__u32		imaxpct;	/* new inode space percentage limit */
-} __attribute__((packed)) compat_xfs_growfs_data_t;
-
-typedef struct compat_xfs_growfs_rt {
-	__u64		newblocks;	/* new realtime size, fsblocks */
-	__u32		extsize;	/* new realtime extent size, fsblocks */
-} __attribute__((packed)) compat_xfs_growfs_rt_t;
-
-#define XFS_IOC_FSGROWFSDATA_32 _IOW('X', 110, struct compat_xfs_growfs_data)
-#define XFS_IOC_FSGROWFSRT_32   _IOW('X', 112, struct compat_xfs_growfs_rt)
-
-#endif /* BROKEN_X86_ALIGNMENT */
-
-#endif /* __XFS_IOCTL32_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
deleted file mode 100644
index 501e4f6..0000000
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ /dev/null
@@ -1,1201 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_acl.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
-#include "xfs_error.h"
-#include "xfs_itable.h"
-#include "xfs_rw.h"
-#include "xfs_attr.h"
-#include "xfs_buf_item.h"
-#include "xfs_utils.h"
-#include "xfs_vnodeops.h"
-#include "xfs_inode_item.h"
-#include "xfs_trace.h"
-
-#include <linux/capability.h>
-#include <linux/xattr.h>
-#include <linux/namei.h>
-#include <linux/posix_acl.h>
-#include <linux/security.h>
-#include <linux/fiemap.h>
-#include <linux/slab.h>
-
-/*
- * Bring the timestamps in the XFS inode uptodate.
- *
- * Used before writing the inode to disk.
- */
-void
-xfs_synchronize_times(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
-	ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
-	ip->i_d.di_ctime.t_sec = (__int32_t)inode->i_ctime.tv_sec;
-	ip->i_d.di_ctime.t_nsec = (__int32_t)inode->i_ctime.tv_nsec;
-	ip->i_d.di_mtime.t_sec = (__int32_t)inode->i_mtime.tv_sec;
-	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
-}
-
-/*
- * If the linux inode is valid, mark it dirty.
- * Used when committing a dirty inode into a transaction so that
- * the inode will get written back by the linux code
- */
-void
-xfs_mark_inode_dirty_sync(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
-		mark_inode_dirty_sync(inode);
-}
-
-void
-xfs_mark_inode_dirty(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
-		mark_inode_dirty(inode);
-}
-
-/*
- * Hook in SELinux.  This is not quite correct yet, what we really need
- * here (as we do for default ACLs) is a mechanism by which creation of
- * these attrs can be journalled at inode creation time (along with the
- * inode, of course, such that log replay can't cause these to be lost).
- */
-STATIC int
-xfs_init_security(
-	struct inode	*inode,
-	struct inode	*dir,
-	const struct qstr *qstr)
-{
-	struct xfs_inode *ip = XFS_I(inode);
-	size_t		length;
-	void		*value;
-	unsigned char	*name;
-	int		error;
-
-	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
-					     &value, &length);
-	if (error) {
-		if (error == -EOPNOTSUPP)
-			return 0;
-		return -error;
-	}
-
-	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
-
-	kfree(name);
-	kfree(value);
-	return error;
-}
-
-static void
-xfs_dentry_to_name(
-	struct xfs_name	*namep,
-	struct dentry	*dentry)
-{
-	namep->name = dentry->d_name.name;
-	namep->len = dentry->d_name.len;
-}
-
-STATIC void
-xfs_cleanup_inode(
-	struct inode	*dir,
-	struct inode	*inode,
-	struct dentry	*dentry)
-{
-	struct xfs_name	teardown;
-
-	/* Oh, the horror.
-	 * If we can't add the ACL or we fail in
-	 * xfs_init_security we must back out.
-	 * ENOSPC can hit here, among other things.
-	 */
-	xfs_dentry_to_name(&teardown, dentry);
-
-	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
-	iput(inode);
-}
-
-STATIC int
-xfs_vn_mknod(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	int		mode,
-	dev_t		rdev)
-{
-	struct inode	*inode;
-	struct xfs_inode *ip = NULL;
-	struct posix_acl *default_acl = NULL;
-	struct xfs_name	name;
-	int		error;
-
-	/*
-	 * Irix uses Missed'em'V split, but doesn't want to see
-	 * the upper 5 bits of (14bit) major.
-	 */
-	if (S_ISCHR(mode) || S_ISBLK(mode)) {
-		if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
-			return -EINVAL;
-		rdev = sysv_encode_dev(rdev);
-	} else {
-		rdev = 0;
-	}
-
-	if (IS_POSIXACL(dir)) {
-		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
-		if (IS_ERR(default_acl))
-			return PTR_ERR(default_acl);
-
-		if (!default_acl)
-			mode &= ~current_umask();
-	}
-
-	xfs_dentry_to_name(&name, dentry);
-	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
-	if (unlikely(error))
-		goto out_free_acl;
-
-	inode = VFS_I(ip);
-
-	error = xfs_init_security(inode, dir, &dentry->d_name);
-	if (unlikely(error))
-		goto out_cleanup_inode;
-
-	if (default_acl) {
-		error = -xfs_inherit_acl(inode, default_acl);
-		if (unlikely(error))
-			goto out_cleanup_inode;
-		posix_acl_release(default_acl);
-	}
-
-
-	d_instantiate(dentry, inode);
-	return -error;
-
- out_cleanup_inode:
-	xfs_cleanup_inode(dir, inode, dentry);
- out_free_acl:
-	posix_acl_release(default_acl);
-	return -error;
-}
-
-STATIC int
-xfs_vn_create(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	int		mode,
-	struct nameidata *nd)
-{
-	return xfs_vn_mknod(dir, dentry, mode, 0);
-}
-
-STATIC int
-xfs_vn_mkdir(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	int		mode)
-{
-	return xfs_vn_mknod(dir, dentry, mode|S_IFDIR, 0);
-}
-
-STATIC struct dentry *
-xfs_vn_lookup(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	struct nameidata *nd)
-{
-	struct xfs_inode *cip;
-	struct xfs_name	name;
-	int		error;
-
-	if (dentry->d_name.len >= MAXNAMELEN)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	xfs_dentry_to_name(&name, dentry);
-	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
-	if (unlikely(error)) {
-		if (unlikely(error != ENOENT))
-			return ERR_PTR(-error);
-		d_add(dentry, NULL);
-		return NULL;
-	}
-
-	return d_splice_alias(VFS_I(cip), dentry);
-}
-
-STATIC struct dentry *
-xfs_vn_ci_lookup(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	struct nameidata *nd)
-{
-	struct xfs_inode *ip;
-	struct xfs_name	xname;
-	struct xfs_name ci_name;
-	struct qstr	dname;
-	int		error;
-
-	if (dentry->d_name.len >= MAXNAMELEN)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	xfs_dentry_to_name(&xname, dentry);
-	error = xfs_lookup(XFS_I(dir), &xname, &ip, &ci_name);
-	if (unlikely(error)) {
-		if (unlikely(error != ENOENT))
-			return ERR_PTR(-error);
-		/*
-		 * call d_add(dentry, NULL) here when d_drop_negative_children
-		 * is called in xfs_vn_mknod (ie. allow negative dentries
-		 * with CI filesystems).
-		 */
-		return NULL;
-	}
-
-	/* if exact match, just splice and exit */
-	if (!ci_name.name)
-		return d_splice_alias(VFS_I(ip), dentry);
-
-	/* else case-insensitive match... */
-	dname.name = ci_name.name;
-	dname.len = ci_name.len;
-	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
-	kmem_free(ci_name.name);
-	return dentry;
-}
-
-STATIC int
-xfs_vn_link(
-	struct dentry	*old_dentry,
-	struct inode	*dir,
-	struct dentry	*dentry)
-{
-	struct inode	*inode = old_dentry->d_inode;
-	struct xfs_name	name;
-	int		error;
-
-	xfs_dentry_to_name(&name, dentry);
-
-	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
-	if (unlikely(error))
-		return -error;
-
-	ihold(inode);
-	d_instantiate(dentry, inode);
-	return 0;
-}
-
-STATIC int
-xfs_vn_unlink(
-	struct inode	*dir,
-	struct dentry	*dentry)
-{
-	struct xfs_name	name;
-	int		error;
-
-	xfs_dentry_to_name(&name, dentry);
-
-	error = -xfs_remove(XFS_I(dir), &name, XFS_I(dentry->d_inode));
-	if (error)
-		return error;
-
-	/*
-	 * With unlink, the VFS makes the dentry "negative": no inode,
-	 * but still hashed. This is incompatible with case-insensitive
-	 * mode, so invalidate (unhash) the dentry in CI-mode.
-	 */
-	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
-		d_invalidate(dentry);
-	return 0;
-}
-
-STATIC int
-xfs_vn_symlink(
-	struct inode	*dir,
-	struct dentry	*dentry,
-	const char	*symname)
-{
-	struct inode	*inode;
-	struct xfs_inode *cip = NULL;
-	struct xfs_name	name;
-	int		error;
-	mode_t		mode;
-
-	mode = S_IFLNK |
-		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
-	xfs_dentry_to_name(&name, dentry);
-
-	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip);
-	if (unlikely(error))
-		goto out;
-
-	inode = VFS_I(cip);
-
-	error = xfs_init_security(inode, dir, &dentry->d_name);
-	if (unlikely(error))
-		goto out_cleanup_inode;
-
-	d_instantiate(dentry, inode);
-	return 0;
-
- out_cleanup_inode:
-	xfs_cleanup_inode(dir, inode, dentry);
- out:
-	return -error;
-}
-
-STATIC int
-xfs_vn_rename(
-	struct inode	*odir,
-	struct dentry	*odentry,
-	struct inode	*ndir,
-	struct dentry	*ndentry)
-{
-	struct inode	*new_inode = ndentry->d_inode;
-	struct xfs_name	oname;
-	struct xfs_name	nname;
-
-	xfs_dentry_to_name(&oname, odentry);
-	xfs_dentry_to_name(&nname, ndentry);
-
-	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
-			   XFS_I(ndir), &nname, new_inode ?
-			   			XFS_I(new_inode) : NULL);
-}
-
-/*
- * careful here - this function can get called recursively, so
- * we need to be very careful about how much stack we use.
- * uio is kmalloced for this reason...
- */
-STATIC void *
-xfs_vn_follow_link(
-	struct dentry		*dentry,
-	struct nameidata	*nd)
-{
-	char			*link;
-	int			error = -ENOMEM;
-
-	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link)
-		goto out_err;
-
-	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
-	if (unlikely(error))
-		goto out_kfree;
-
-	nd_set_link(nd, link);
-	return NULL;
-
- out_kfree:
-	kfree(link);
- out_err:
-	nd_set_link(nd, ERR_PTR(error));
-	return NULL;
-}
-
-STATIC void
-xfs_vn_put_link(
-	struct dentry	*dentry,
-	struct nameidata *nd,
-	void		*p)
-{
-	char		*s = nd_get_link(nd);
-
-	if (!IS_ERR(s))
-		kfree(s);
-}
-
-STATIC int
-xfs_vn_getattr(
-	struct vfsmount		*mnt,
-	struct dentry		*dentry,
-	struct kstat		*stat)
-{
-	struct inode		*inode = dentry->d_inode;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-
-	trace_xfs_getattr(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	stat->size = XFS_ISIZE(ip);
-	stat->dev = inode->i_sb->s_dev;
-	stat->mode = ip->i_d.di_mode;
-	stat->nlink = ip->i_d.di_nlink;
-	stat->uid = ip->i_d.di_uid;
-	stat->gid = ip->i_d.di_gid;
-	stat->ino = ip->i_ino;
-	stat->atime = inode->i_atime;
-	stat->mtime = inode->i_mtime;
-	stat->ctime = inode->i_ctime;
-	stat->blocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
-
-
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFBLK:
-	case S_IFCHR:
-		stat->blksize = BLKDEV_IOSIZE;
-		stat->rdev = MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
-				   sysv_minor(ip->i_df.if_u2.if_rdev));
-		break;
-	default:
-		if (XFS_IS_REALTIME_INODE(ip)) {
-			/*
-			 * If the file blocks are being allocated from a
-			 * realtime volume, then return the inode's realtime
-			 * extent size or the realtime volume's extent size.
-			 */
-			stat->blksize =
-				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
-		} else
-			stat->blksize = xfs_preferred_iosize(mp);
-		stat->rdev = 0;
-		break;
-	}
-
-	return 0;
-}
-
-int
-xfs_setattr_nonsize(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
-{
-	xfs_mount_t		*mp = ip->i_mount;
-	struct inode		*inode = VFS_I(ip);
-	int			mask = iattr->ia_valid;
-	xfs_trans_t		*tp;
-	int			error;
-	uid_t			uid = 0, iuid = 0;
-	gid_t			gid = 0, igid = 0;
-	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
-	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
-
-	trace_xfs_setattr(ip);
-
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	error = -inode_change_ok(inode, iattr);
-	if (error)
-		return XFS_ERROR(error);
-
-	ASSERT((mask & ATTR_SIZE) == 0);
-
-	/*
-	 * If disk quotas is on, we make sure that the dquots do exist on disk,
-	 * before we start any other transactions. Trying to do this later
-	 * is messy. We don't care to take a readlock to look at the ids
-	 * in inode here, because we can't hold it across the trans_reserve.
-	 * If the IDs do change before we take the ilock, we're covered
-	 * because the i_*dquot fields will get updated anyway.
-	 */
-	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
-		uint	qflags = 0;
-
-		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
-			uid = iattr->ia_uid;
-			qflags |= XFS_QMOPT_UQUOTA;
-		} else {
-			uid = ip->i_d.di_uid;
-		}
-		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
-			gid = iattr->ia_gid;
-			qflags |= XFS_QMOPT_GQUOTA;
-		}  else {
-			gid = ip->i_d.di_gid;
-		}
-
-		/*
-		 * We take a reference when we initialize udqp and gdqp,
-		 * so it is important that we never blindly double trip on
-		 * the same variable. See xfs_create() for an example.
-		 */
-		ASSERT(udqp == NULL);
-		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
-		if (error)
-			return error;
-	}
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
-	if (error)
-		goto out_dqrele;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
-		/*
-		 * These IDs could have changed since we last looked at them.
-		 * But, we're assured that if the ownership did change
-		 * while we didn't have the inode locked, inode's dquot(s)
-		 * would have changed also.
-		 */
-		iuid = ip->i_d.di_uid;
-		igid = ip->i_d.di_gid;
-		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
-		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
-
-		/*
-		 * Do a quota reservation only if uid/gid is actually
-		 * going to change.
-		 */
-		if (XFS_IS_QUOTA_RUNNING(mp) &&
-		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
-		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
-			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
-			if (error)	/* out of quota */
-				goto out_trans_cancel;
-		}
-	}
-
-	xfs_trans_ijoin(tp, ip);
-
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
-
-		/*
-		 * Change the ownerships and register quota modifications
-		 * in the transaction.
-		 */
-		if (iuid != uid) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
-				ASSERT(mask & ATTR_UID);
-				ASSERT(udqp);
-				olddquot1 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_udquot, udqp);
-			}
-			ip->i_d.di_uid = uid;
-			inode->i_uid = uid;
-		}
-		if (igid != gid) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(!XFS_IS_PQUOTA_ON(mp));
-				ASSERT(mask & ATTR_GID);
-				ASSERT(gdqp);
-				olddquot2 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
-			}
-			ip->i_d.di_gid = gid;
-			inode->i_gid = gid;
-		}
-	}
-
-	/*
-	 * Change file access modes.
-	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
-
-	/*
-	 * Change file access or modified times.
-	 */
-	if (mask & ATTR_ATIME) {
-		inode->i_atime = iattr->ia_atime;
-		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-	if (mask & ATTR_CTIME) {
-		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-	if (mask & ATTR_MTIME) {
-		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	XFS_STATS_INC(xs_ig_attrchg);
-
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Release any dquot(s) the inode had kept before chown.
-	 */
-	xfs_qm_dqrele(olddquot1);
-	xfs_qm_dqrele(olddquot2);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-
-	if (error)
-		return XFS_ERROR(error);
-
-	/*
-	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
-	 * 	     update.  We could avoid this with linked transactions
-	 * 	     and passing down the transaction pointer all the way
-	 *	     to attr_set.  No previous user of the generic
-	 * 	     Posix ACL code seems to care about this issue either.
-	 */
-	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
-		error = -xfs_acl_chmod(inode);
-		if (error)
-			return XFS_ERROR(error);
-	}
-
-	return 0;
-
-out_trans_cancel:
-	xfs_trans_cancel(tp, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out_dqrele:
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	return error;
-}
-
-/*
- * Truncate file.  Must have write permission and not be a directory.
- */
-int
-xfs_setattr_size(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct inode		*inode = VFS_I(ip);
-	int			mask = iattr->ia_valid;
-	struct xfs_trans	*tp;
-	int			error;
-	uint			lock_flags;
-	uint			commit_flags = 0;
-
-	trace_xfs_setattr(ip);
-
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	error = -inode_change_ok(inode, iattr);
-	if (error)
-		return XFS_ERROR(error);
-
-	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
-
-	lock_flags = XFS_ILOCK_EXCL;
-	if (!(flags & XFS_ATTR_NOLOCK))
-		lock_flags |= XFS_IOLOCK_EXCL;
-	xfs_ilock(ip, lock_flags);
-
-	/*
-	 * Short circuit the truncate case for zero length files.
-	 */
-	if (iattr->ia_size == 0 &&
-	    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
-		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
-			goto out_unlock;
-
-		/*
-		 * Use the regular setattr path to update the timestamps.
-		 */
-		xfs_iunlock(ip, lock_flags);
-		iattr->ia_valid &= ~ATTR_SIZE;
-		return xfs_setattr_nonsize(ip, iattr, 0);
-	}
-
-	/*
-	 * Make sure that the dquots are attached to the inode.
-	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
-	if (error)
-		goto out_unlock;
-
-	/*
-	 * Now we can make the changes.  Before we join the inode to the
-	 * transaction, take care of the part of the truncation that must be
-	 * done without the inode lock.  This needs to be done before joining
-	 * the inode to the transaction, because the inode cannot be unlocked
-	 * once it is a part of the transaction.
-	 */
-	if (iattr->ia_size > ip->i_size) {
-		/*
-		 * Do the first part of growing a file: zero any data in the
-		 * last block that is beyond the old EOF.  We need to do this
-		 * before the inode is joined to the transaction to modify
-		 * i_size.
-		 */
-		error = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
-		if (error)
-			goto out_unlock;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	lock_flags &= ~XFS_ILOCK_EXCL;
-
-	/*
-	 * We are going to log the inode size change in this transaction so
-	 * any previous writes that are beyond the on disk EOF and the new
-	 * EOF that have not been written out need to be written here.  If we
-	 * do not write the data out, we expose ourselves to the null files
-	 * problem.
-	 *
-	 * Only flush from the on disk size to the smaller of the in memory
-	 * file size or the new size as that's the range we really care about
-	 * here and prevents waiting for other data not within the range we
-	 * care about here.
-	 */
-	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
-		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size,
-					XBF_ASYNC, FI_NONE);
-		if (error)
-			goto out_unlock;
-	}
-
-	/*
-	 * Wait for all I/O to complete.
-	 */
-	xfs_ioend_wait(ip);
-
-	error = -block_truncate_page(inode->i_mapping, iattr->ia_size,
-				     xfs_get_blocks);
-	if (error)
-		goto out_unlock;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				 XFS_TRANS_PERM_LOG_RES,
-				 XFS_ITRUNCATE_LOG_COUNT);
-	if (error)
-		goto out_trans_cancel;
-
-	truncate_setsize(inode, iattr->ia_size);
-
-	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
-	lock_flags |= XFS_ILOCK_EXCL;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, ip);
-
-	/*
-	 * Only change the c/mtime if we are changing the size or we are
-	 * explicitly asked to change it.  This handles the semantic difference
-	 * between truncate() and ftruncate() as implemented in the VFS.
-	 *
-	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
-	 * special case where we need to update the times despite not having
-	 * these flags set.  For all other operations the VFS set these flags
-	 * explicitly if it wants a timestamp update.
-	 */
-	if (iattr->ia_size != ip->i_size &&
-	    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
-		iattr->ia_ctime = iattr->ia_mtime =
-			current_fs_time(inode->i_sb);
-		mask |= ATTR_CTIME | ATTR_MTIME;
-	}
-
-	if (iattr->ia_size > ip->i_size) {
-		ip->i_d.di_size = iattr->ia_size;
-		ip->i_size = iattr->ia_size;
-	} else if (iattr->ia_size <= ip->i_size ||
-		   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
-		error = xfs_itruncate_data(&tp, ip, iattr->ia_size);
-		if (error)
-			goto out_trans_abort;
-
-		/*
-		 * Truncated "down", so we're removing references to old data
-		 * here - if we delay flushing for a long time, we expose
-		 * ourselves unduly to the notorious NULL files problem.  So,
-		 * we mark this inode and flush it when the file is closed,
-		 * and do not wait the usual (long) time for writeout.
-		 */
-		xfs_iflags_set(ip, XFS_ITRUNCATED);
-	}
-
-	if (mask & ATTR_CTIME) {
-		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-	if (mask & ATTR_MTIME) {
-		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	XFS_STATS_INC(xs_ig_attrchg);
-
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(tp);
-
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-out_unlock:
-	if (lock_flags)
-		xfs_iunlock(ip, lock_flags);
-	return error;
-
-out_trans_abort:
-	commit_flags |= XFS_TRANS_ABORT;
-out_trans_cancel:
-	xfs_trans_cancel(tp, commit_flags);
-	goto out_unlock;
-}
-
-STATIC int
-xfs_vn_setattr(
-	struct dentry	*dentry,
-	struct iattr	*iattr)
-{
-	if (iattr->ia_valid & ATTR_SIZE)
-		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
-	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
-}
-
-#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
-
-/*
- * Call fiemap helper to fill in user data.
- * Returns positive errors to xfs_getbmap.
- */
-STATIC int
-xfs_fiemap_format(
-	void			**arg,
-	struct getbmapx		*bmv,
-	int			*full)
-{
-	int			error;
-	struct fiemap_extent_info *fieinfo = *arg;
-	u32			fiemap_flags = 0;
-	u64			logical, physical, length;
-
-	/* Do nothing for a hole */
-	if (bmv->bmv_block == -1LL)
-		return 0;
-
-	logical = BBTOB(bmv->bmv_offset);
-	physical = BBTOB(bmv->bmv_block);
-	length = BBTOB(bmv->bmv_length);
-
-	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
-		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
-	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
-		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
-		physical = 0;   /* no block yet */
-	}
-	if (bmv->bmv_oflags & BMV_OF_LAST)
-		fiemap_flags |= FIEMAP_EXTENT_LAST;
-
-	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
-	if (error > 0) {
-		error = 0;
-		*full = 1;	/* user array now full */
-	}
-
-	return -error;
-}
-
-STATIC int
-xfs_vn_fiemap(
-	struct inode		*inode,
-	struct fiemap_extent_info *fieinfo,
-	u64			start,
-	u64			length)
-{
-	xfs_inode_t		*ip = XFS_I(inode);
-	struct getbmapx		bm;
-	int			error;
-
-	error = fiemap_check_flags(fieinfo, XFS_FIEMAP_FLAGS);
-	if (error)
-		return error;
-
-	/* Set up bmap header for xfs internal routine */
-	bm.bmv_offset = BTOBB(start);
-	/* Special case for whole file */
-	if (length == FIEMAP_MAX_OFFSET)
-		bm.bmv_length = -1LL;
-	else
-		bm.bmv_length = BTOBB(length);
-
-	/* We add one because in getbmap world count includes the header */
-	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
-					fieinfo->fi_extents_max + 1;
-	bm.bmv_count = min_t(__s32, bm.bmv_count,
-			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
-	bm.bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
-	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
-		bm.bmv_iflags |= BMV_IF_ATTRFORK;
-	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
-		bm.bmv_iflags |= BMV_IF_DELALLOC;
-
-	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
-	if (error)
-		return -error;
-
-	return 0;
-}
-
-static const struct inode_operations xfs_inode_operations = {
-	.check_acl		= xfs_check_acl,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
-	.listxattr		= xfs_vn_listxattr,
-	.fiemap			= xfs_vn_fiemap,
-};
-
-static const struct inode_operations xfs_dir_inode_operations = {
-	.create			= xfs_vn_create,
-	.lookup			= xfs_vn_lookup,
-	.link			= xfs_vn_link,
-	.unlink			= xfs_vn_unlink,
-	.symlink		= xfs_vn_symlink,
-	.mkdir			= xfs_vn_mkdir,
-	/*
-	 * Yes, XFS uses the same method for rmdir and unlink.
-	 *
-	 * There are some subtile differences deeper in the code,
-	 * but we use S_ISDIR to check for those.
-	 */
-	.rmdir			= xfs_vn_unlink,
-	.mknod			= xfs_vn_mknod,
-	.rename			= xfs_vn_rename,
-	.check_acl		= xfs_check_acl,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
-	.listxattr		= xfs_vn_listxattr,
-};
-
-static const struct inode_operations xfs_dir_ci_inode_operations = {
-	.create			= xfs_vn_create,
-	.lookup			= xfs_vn_ci_lookup,
-	.link			= xfs_vn_link,
-	.unlink			= xfs_vn_unlink,
-	.symlink		= xfs_vn_symlink,
-	.mkdir			= xfs_vn_mkdir,
-	/*
-	 * Yes, XFS uses the same method for rmdir and unlink.
-	 *
-	 * There are some subtile differences deeper in the code,
-	 * but we use S_ISDIR to check for those.
-	 */
-	.rmdir			= xfs_vn_unlink,
-	.mknod			= xfs_vn_mknod,
-	.rename			= xfs_vn_rename,
-	.check_acl		= xfs_check_acl,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
-	.listxattr		= xfs_vn_listxattr,
-};
-
-static const struct inode_operations xfs_symlink_inode_operations = {
-	.readlink		= generic_readlink,
-	.follow_link		= xfs_vn_follow_link,
-	.put_link		= xfs_vn_put_link,
-	.check_acl		= xfs_check_acl,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
-	.listxattr		= xfs_vn_listxattr,
-};
-
-STATIC void
-xfs_diflags_to_iflags(
-	struct inode		*inode,
-	struct xfs_inode	*ip)
-{
-	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
-		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
-	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
-		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
-	if (ip->i_d.di_flags & XFS_DIFLAG_SYNC)
-		inode->i_flags |= S_SYNC;
-	else
-		inode->i_flags &= ~S_SYNC;
-	if (ip->i_d.di_flags & XFS_DIFLAG_NOATIME)
-		inode->i_flags |= S_NOATIME;
-	else
-		inode->i_flags &= ~S_NOATIME;
-}
-
-/*
- * Initialize the Linux inode, set up the operation vectors and
- * unlock the inode.
- *
- * When reading existing inodes from disk this is called directly
- * from xfs_iget, when creating a new inode it is called from
- * xfs_ialloc after setting up the inode.
- *
- * We are always called with an uninitialised linux inode here.
- * We need to initialise the necessary fields and take a reference
- * on it.
- */
-void
-xfs_setup_inode(
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = &ip->i_vnode;
-
-	inode->i_ino = ip->i_ino;
-	inode->i_state = I_NEW;
-
-	inode_sb_list_add(inode);
-	/* make the inode look hashed for the writeback code */
-	hlist_add_fake(&inode->i_hash);
-
-	inode->i_mode	= ip->i_d.di_mode;
-	inode->i_nlink	= ip->i_d.di_nlink;
-	inode->i_uid	= ip->i_d.di_uid;
-	inode->i_gid	= ip->i_d.di_gid;
-
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFBLK:
-	case S_IFCHR:
-		inode->i_rdev =
-			MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
-			      sysv_minor(ip->i_df.if_u2.if_rdev));
-		break;
-	default:
-		inode->i_rdev = 0;
-		break;
-	}
-
-	inode->i_generation = ip->i_d.di_gen;
-	i_size_write(inode, ip->i_d.di_size);
-	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
-	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
-	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
-	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
-	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
-	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
-	xfs_diflags_to_iflags(inode, ip);
-
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFREG:
-		inode->i_op = &xfs_inode_operations;
-		inode->i_fop = &xfs_file_operations;
-		inode->i_mapping->a_ops = &xfs_address_space_operations;
-		break;
-	case S_IFDIR:
-		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
-			inode->i_op = &xfs_dir_ci_inode_operations;
-		else
-			inode->i_op = &xfs_dir_inode_operations;
-		inode->i_fop = &xfs_dir_file_operations;
-		break;
-	case S_IFLNK:
-		inode->i_op = &xfs_symlink_inode_operations;
-		if (!(ip->i_df.if_flags & XFS_IFINLINE))
-			inode->i_mapping->a_ops = &xfs_address_space_operations;
-		break;
-	default:
-		inode->i_op = &xfs_inode_operations;
-		init_special_inode(inode, inode->i_mode, inode->i_rdev);
-		break;
-	}
-
-	xfs_iflags_clear(ip, XFS_INEW);
-	barrier();
-
-	unlock_new_inode(inode);
-}
diff --git a/fs/xfs/linux-2.6/xfs_iops.h b/fs/xfs/linux-2.6/xfs_iops.h
deleted file mode 100644
index ef41c92..0000000
--- a/fs/xfs/linux-2.6/xfs_iops.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_IOPS_H__
-#define __XFS_IOPS_H__
-
-struct xfs_inode;
-
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
-extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
-
-extern void xfs_setup_inode(struct xfs_inode *);
-
-#endif /* __XFS_IOPS_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
deleted file mode 100644
index d42f814..0000000
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ /dev/null
@@ -1,310 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_LINUX__
-#define __XFS_LINUX__
-
-#include <linux/types.h>
-
-/*
- * XFS_BIG_BLKNOS needs block layer disk addresses to be 64 bits.
- * XFS_BIG_INUMS requires XFS_BIG_BLKNOS to be set.
- */
-#if defined(CONFIG_LBDAF) || (BITS_PER_LONG == 64)
-# define XFS_BIG_BLKNOS	1
-# define XFS_BIG_INUMS	1
-#else
-# define XFS_BIG_BLKNOS	0
-# define XFS_BIG_INUMS	0
-#endif
-
-#include <xfs_types.h>
-
-#include <kmem.h>
-#include <mrlock.h>
-#include <time.h>
-
-#include <support/uuid.h>
-
-#include <linux/semaphore.h>
-#include <linux/mm.h>
-#include <linux/kernel.h>
-#include <linux/blkdev.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/file.h>
-#include <linux/swap.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/bitops.h>
-#include <linux/major.h>
-#include <linux/pagemap.h>
-#include <linux/vfs.h>
-#include <linux/seq_file.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/proc_fs.h>
-#include <linux/sort.h>
-#include <linux/cpu.h>
-#include <linux/notifier.h>
-#include <linux/delay.h>
-#include <linux/log2.h>
-#include <linux/spinlock.h>
-#include <linux/random.h>
-#include <linux/ctype.h>
-#include <linux/writeback.h>
-#include <linux/capability.h>
-#include <linux/list_sort.h>
-
-#include <asm/page.h>
-#include <asm/div64.h>
-#include <asm/param.h>
-#include <asm/uaccess.h>
-#include <asm/byteorder.h>
-#include <asm/unaligned.h>
-
-#include <xfs_vnode.h>
-#include <xfs_stats.h>
-#include <xfs_sysctl.h>
-#include <xfs_iops.h>
-#include <xfs_aops.h>
-#include <xfs_super.h>
-#include <xfs_buf.h>
-#include <xfs_message.h>
-
-#ifdef __BIG_ENDIAN
-#define XFS_NATIVE_HOST 1
-#else
-#undef XFS_NATIVE_HOST
-#endif
-
-/*
- * Feature macros (disable/enable)
- */
-#ifdef CONFIG_SMP
-#define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
-#else
-#undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
-#endif
-
-#define irix_sgid_inherit	xfs_params.sgid_inherit.val
-#define irix_symlink_mode	xfs_params.symlink_mode.val
-#define xfs_panic_mask		xfs_params.panic_mask.val
-#define xfs_error_level		xfs_params.error_level.val
-#define xfs_syncd_centisecs	xfs_params.syncd_timer.val
-#define xfs_stats_clear		xfs_params.stats_clear.val
-#define xfs_inherit_sync	xfs_params.inherit_sync.val
-#define xfs_inherit_nodump	xfs_params.inherit_nodump.val
-#define xfs_inherit_noatime	xfs_params.inherit_noatim.val
-#define xfs_buf_timer_centisecs	xfs_params.xfs_buf_timer.val
-#define xfs_buf_age_centisecs	xfs_params.xfs_buf_age.val
-#define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
-#define xfs_rotorstep		xfs_params.rotorstep.val
-#define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
-#define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
-
-#define current_cpu()		(raw_smp_processor_id())
-#define current_pid()		(current->pid)
-#define current_test_flags(f)	(current->flags & (f))
-#define current_set_flags_nested(sp, f)		\
-		(*(sp) = current->flags, current->flags |= (f))
-#define current_clear_flags_nested(sp, f)	\
-		(*(sp) = current->flags, current->flags &= ~(f))
-#define current_restore_flags_nested(sp, f)	\
-		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
-
-#define spinlock_destroy(lock)
-
-#define NBBY		8		/* number of bits per byte */
-
-/*
- * Size of block device i/o is parameterized here.
- * Currently the system supports page-sized i/o.
- */
-#define	BLKDEV_IOSHIFT		PAGE_CACHE_SHIFT
-#define	BLKDEV_IOSIZE		(1<<BLKDEV_IOSHIFT)
-/* number of BB's per block device block */
-#define	BLKDEV_BB		BTOBB(BLKDEV_IOSIZE)
-
-#define ENOATTR		ENODATA		/* Attribute not found */
-#define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
-
-#define SYNCHRONIZE()	barrier()
-#define __return_address __builtin_return_address(0)
-
-#define XFS_PROJID_DEFAULT	0
-#define MAXPATHLEN	1024
-
-#define MIN(a,b)	(min(a,b))
-#define MAX(a,b)	(max(a,b))
-#define howmany(x, y)	(((x)+((y)-1))/(y))
-
-/*
- * Various platform dependent calls that don't fit anywhere else
- */
-#define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
-#define xfs_stack_trace()	dump_stack()
-
-
-/* Move the kernel do_div definition off to one side */
-
-#if defined __i386__
-/* For ia32 we need to pull some tricks to get past various versions
- * of the compiler which do not like us using do_div in the middle
- * of large functions.
- */
-static inline __u32 xfs_do_div(void *a, __u32 b, int n)
-{
-	__u32	mod;
-
-	switch (n) {
-		case 4:
-			mod = *(__u32 *)a % b;
-			*(__u32 *)a = *(__u32 *)a / b;
-			return mod;
-		case 8:
-			{
-			unsigned long __upper, __low, __high, __mod;
-			__u64	c = *(__u64 *)a;
-			__upper = __high = c >> 32;
-			__low = c;
-			if (__high) {
-				__upper = __high % (b);
-				__high = __high / (b);
-			}
-			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
-			asm("":"=A" (c):"a" (__low),"d" (__high));
-			*(__u64 *)a = c;
-			return __mod;
-			}
-	}
-
-	/* NOTREACHED */
-	return 0;
-}
-
-/* Side effect free 64 bit mod operation */
-static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
-{
-	switch (n) {
-		case 4:
-			return *(__u32 *)a % b;
-		case 8:
-			{
-			unsigned long __upper, __low, __high, __mod;
-			__u64	c = *(__u64 *)a;
-			__upper = __high = c >> 32;
-			__low = c;
-			if (__high) {
-				__upper = __high % (b);
-				__high = __high / (b);
-			}
-			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
-			asm("":"=A" (c):"a" (__low),"d" (__high));
-			return __mod;
-			}
-	}
-
-	/* NOTREACHED */
-	return 0;
-}
-#else
-static inline __u32 xfs_do_div(void *a, __u32 b, int n)
-{
-	__u32	mod;
-
-	switch (n) {
-		case 4:
-			mod = *(__u32 *)a % b;
-			*(__u32 *)a = *(__u32 *)a / b;
-			return mod;
-		case 8:
-			mod = do_div(*(__u64 *)a, b);
-			return mod;
-	}
-
-	/* NOTREACHED */
-	return 0;
-}
-
-/* Side effect free 64 bit mod operation */
-static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
-{
-	switch (n) {
-		case 4:
-			return *(__u32 *)a % b;
-		case 8:
-			{
-			__u64	c = *(__u64 *)a;
-			return do_div(c, b);
-			}
-	}
-
-	/* NOTREACHED */
-	return 0;
-}
-#endif
-
-#undef do_div
-#define do_div(a, b)	xfs_do_div(&(a), (b), sizeof(a))
-#define do_mod(a, b)	xfs_do_mod(&(a), (b), sizeof(a))
-
-static inline __uint64_t roundup_64(__uint64_t x, __uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return(x * y);
-}
-
-static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x;
-}
-
-/* ARM old ABI has some weird alignment/padding */
-#if defined(__arm__) && !defined(__ARM_EABI__)
-#define __arch_pack __attribute__((packed))
-#else
-#define __arch_pack
-#endif
-
-#define ASSERT_ALWAYS(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
-
-#ifndef DEBUG
-#define ASSERT(expr)	((void)0)
-
-#ifndef STATIC
-# define STATIC static noinline
-#endif
-
-#else /* DEBUG */
-
-#define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
-
-#ifndef STATIC
-# define STATIC noinline
-#endif
-
-#endif /* DEBUG */
-
-#endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/linux-2.6/xfs_message.c b/fs/xfs/linux-2.6/xfs_message.c
deleted file mode 100644
index bd672de..0000000
--- a/fs/xfs/linux-2.6/xfs_message.c
+++ /dev/null
@@ -1,108 +0,0 @@
-/*
- * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
-
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-
-/*
- * XFS logging functions
- */
-static void
-__xfs_printk(
-	const char		*level,
-	const struct xfs_mount	*mp,
-	struct va_format	*vaf)
-{
-	if (mp && mp->m_fsname) {
-		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
-		return;
-	}
-	printk("%sXFS: %pV\n", level, vaf);
-}
-
-#define define_xfs_printk_level(func, kern_level)		\
-void func(const struct xfs_mount *mp, const char *fmt, ...)	\
-{								\
-	struct va_format	vaf;				\
-	va_list			args;				\
-								\
-	va_start(args, fmt);					\
-								\
-	vaf.fmt = fmt;						\
-	vaf.va = &args;						\
-								\
-	__xfs_printk(kern_level, mp, &vaf);			\
-	va_end(args);						\
-}								\
-
-define_xfs_printk_level(xfs_emerg, KERN_EMERG);
-define_xfs_printk_level(xfs_alert, KERN_ALERT);
-define_xfs_printk_level(xfs_crit, KERN_CRIT);
-define_xfs_printk_level(xfs_err, KERN_ERR);
-define_xfs_printk_level(xfs_warn, KERN_WARNING);
-define_xfs_printk_level(xfs_notice, KERN_NOTICE);
-define_xfs_printk_level(xfs_info, KERN_INFO);
-#ifdef DEBUG
-define_xfs_printk_level(xfs_debug, KERN_DEBUG);
-#endif
-
-void
-xfs_alert_tag(
-	const struct xfs_mount	*mp,
-	int			panic_tag,
-	const char		*fmt, ...)
-{
-	struct va_format	vaf;
-	va_list			args;
-	int			do_panic = 0;
-
-	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
-		xfs_alert(mp, "Transforming an alert into a BUG.");
-		do_panic = 1;
-	}
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	__xfs_printk(KERN_ALERT, mp, &vaf);
-	va_end(args);
-
-	BUG_ON(do_panic);
-}
-
-void
-assfail(char *expr, char *file, int line)
-{
-	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
-		expr, file, line);
-	BUG();
-}
-
-void
-xfs_hex_dump(void *p, int length)
-{
-	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p, length, 1);
-}
diff --git a/fs/xfs/linux-2.6/xfs_message.h b/fs/xfs/linux-2.6/xfs_message.h
deleted file mode 100644
index 7fb7ea0..0000000
--- a/fs/xfs/linux-2.6/xfs_message.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef __XFS_MESSAGE_H
-#define __XFS_MESSAGE_H 1
-
-struct xfs_mount;
-
-extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
-			 const char *fmt, ...)
-        __attribute__ ((format (printf, 3, 4)));
-extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-
-#ifdef DEBUG
-extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-#else
-static inline void
-__attribute__ ((format (printf, 2, 3)))
-xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
-{
-}
-#endif
-
-extern void assfail(char *expr, char *f, int l);
-
-extern void xfs_hex_dump(void *p, int length);
-
-#endif	/* __XFS_MESSAGE_H */
diff --git a/fs/xfs/linux-2.6/xfs_quotaops.c b/fs/xfs/linux-2.6/xfs_quotaops.c
deleted file mode 100644
index 29b9d64..0000000
--- a/fs/xfs/linux-2.6/xfs_quotaops.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Copyright (c) 2008, Christoph Hellwig
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
-#include "xfs.h"
-#include "xfs_sb.h"
-#include "xfs_inum.h"
-#include "xfs_log.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_quota.h"
-#include "xfs_trans.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "quota/xfs_qm.h"
-#include <linux/quota.h>
-
-
-STATIC int
-xfs_quota_type(int type)
-{
-	switch (type) {
-	case USRQUOTA:
-		return XFS_DQ_USER;
-	case GRPQUOTA:
-		return XFS_DQ_GROUP;
-	default:
-		return XFS_DQ_PROJ;
-	}
-}
-
-STATIC int
-xfs_fs_get_xstate(
-	struct super_block	*sb,
-	struct fs_quota_stat	*fqs)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	return -xfs_qm_scall_getqstat(mp, fqs);
-}
-
-STATIC int
-xfs_fs_set_xstate(
-	struct super_block	*sb,
-	unsigned int		uflags,
-	int			op)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-	unsigned int		flags = 0;
-
-	if (sb->s_flags & MS_RDONLY)
-		return -EROFS;
-	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-
-	if (uflags & FS_QUOTA_UDQ_ACCT)
-		flags |= XFS_UQUOTA_ACCT;
-	if (uflags & FS_QUOTA_PDQ_ACCT)
-		flags |= XFS_PQUOTA_ACCT;
-	if (uflags & FS_QUOTA_GDQ_ACCT)
-		flags |= XFS_GQUOTA_ACCT;
-	if (uflags & FS_QUOTA_UDQ_ENFD)
-		flags |= XFS_UQUOTA_ENFD;
-	if (uflags & (FS_QUOTA_PDQ_ENFD|FS_QUOTA_GDQ_ENFD))
-		flags |= XFS_OQUOTA_ENFD;
-
-	switch (op) {
-	case Q_XQUOTAON:
-		return -xfs_qm_scall_quotaon(mp, flags);
-	case Q_XQUOTAOFF:
-		if (!XFS_IS_QUOTA_ON(mp))
-			return -EINVAL;
-		return -xfs_qm_scall_quotaoff(mp, flags);
-	case Q_XQUOTARM:
-		if (XFS_IS_QUOTA_ON(mp))
-			return -EINVAL;
-		return -xfs_qm_scall_trunc_qfiles(mp, flags);
-	}
-
-	return -EINVAL;
-}
-
-STATIC int
-xfs_fs_get_dqblk(
-	struct super_block	*sb,
-	int			type,
-	qid_t			id,
-	struct fs_disk_quota	*fdq)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
-
-	return -xfs_qm_scall_getquota(mp, id, xfs_quota_type(type), fdq);
-}
-
-STATIC int
-xfs_fs_set_dqblk(
-	struct super_block	*sb,
-	int			type,
-	qid_t			id,
-	struct fs_disk_quota	*fdq)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (sb->s_flags & MS_RDONLY)
-		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
-
-	return -xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
-}
-
-const struct quotactl_ops xfs_quotactl_operations = {
-	.get_xstate		= xfs_fs_get_xstate,
-	.set_xstate		= xfs_fs_set_xstate,
-	.get_dqblk		= xfs_fs_get_dqblk,
-	.set_dqblk		= xfs_fs_set_dqblk,
-};
diff --git a/fs/xfs/linux-2.6/xfs_stats.c b/fs/xfs/linux-2.6/xfs_stats.c
deleted file mode 100644
index 76fdc58..0000000
--- a/fs/xfs/linux-2.6/xfs_stats.c
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include <linux/proc_fs.h>
-
-DEFINE_PER_CPU(struct xfsstats, xfsstats);
-
-static int xfs_stat_proc_show(struct seq_file *m, void *v)
-{
-	int		c, i, j, val;
-	__uint64_t	xs_xstrat_bytes = 0;
-	__uint64_t	xs_write_bytes = 0;
-	__uint64_t	xs_read_bytes = 0;
-
-	static const struct xstats_entry {
-		char	*desc;
-		int	endpoint;
-	} xstats[] = {
-		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
-		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
-		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
-		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
-		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
-		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
-		{ "ig",			XFSSTAT_END_INODE_OPS		},
-		{ "log",		XFSSTAT_END_LOG_OPS		},
-		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
-		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
-		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
-		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
-		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
-		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
-		{ "buf",		XFSSTAT_END_BUF			},
-		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
-		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
-		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
-		{ "ibt2",		XFSSTAT_END_IBT_V2		},
-	};
-
-	/* Loop over all stats groups */
-	for (i=j = 0; i < ARRAY_SIZE(xstats); i++) {
-		seq_printf(m, "%s", xstats[i].desc);
-		/* inner loop does each group */
-		while (j < xstats[i].endpoint) {
-			val = 0;
-			/* sum over all cpus */
-			for_each_possible_cpu(c)
-				val += *(((__u32*)&per_cpu(xfsstats, c) + j));
-			seq_printf(m, " %u", val);
-			j++;
-		}
-		seq_putc(m, '\n');
-	}
-	/* extra precision counters */
-	for_each_possible_cpu(i) {
-		xs_xstrat_bytes += per_cpu(xfsstats, i).xs_xstrat_bytes;
-		xs_write_bytes += per_cpu(xfsstats, i).xs_write_bytes;
-		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
-	}
-
-	seq_printf(m, "xpc %Lu %Lu %Lu\n",
-			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	seq_printf(m, "debug %u\n",
-#if defined(DEBUG)
-		1);
-#else
-		0);
-#endif
-	return 0;
-}
-
-static int xfs_stat_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xfs_stat_proc_show, NULL);
-}
-
-static const struct file_operations xfs_stat_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= xfs_stat_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-int
-xfs_init_procfs(void)
-{
-	if (!proc_mkdir("fs/xfs", NULL))
-		goto out;
-
-	if (!proc_create("fs/xfs/stat", 0, NULL,
-			 &xfs_stat_proc_fops))
-		goto out_remove_entry;
-	return 0;
-
- out_remove_entry:
-	remove_proc_entry("fs/xfs", NULL);
- out:
-	return -ENOMEM;
-}
-
-void
-xfs_cleanup_procfs(void)
-{
-	remove_proc_entry("fs/xfs/stat", NULL);
-	remove_proc_entry("fs/xfs", NULL);
-}
diff --git a/fs/xfs/linux-2.6/xfs_stats.h b/fs/xfs/linux-2.6/xfs_stats.h
deleted file mode 100644
index 736854b..0000000
--- a/fs/xfs/linux-2.6/xfs_stats.h
+++ /dev/null
@@ -1,223 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_STATS_H__
-#define __XFS_STATS_H__
-
-
-#if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
-
-#include <linux/percpu.h>
-
-/*
- * XFS global statistics
- */
-struct xfsstats {
-# define XFSSTAT_END_EXTENT_ALLOC	4
-	__uint32_t		xs_allocx;
-	__uint32_t		xs_allocb;
-	__uint32_t		xs_freex;
-	__uint32_t		xs_freeb;
-# define XFSSTAT_END_ALLOC_BTREE	(XFSSTAT_END_EXTENT_ALLOC+4)
-	__uint32_t		xs_abt_lookup;
-	__uint32_t		xs_abt_compare;
-	__uint32_t		xs_abt_insrec;
-	__uint32_t		xs_abt_delrec;
-# define XFSSTAT_END_BLOCK_MAPPING	(XFSSTAT_END_ALLOC_BTREE+7)
-	__uint32_t		xs_blk_mapr;
-	__uint32_t		xs_blk_mapw;
-	__uint32_t		xs_blk_unmap;
-	__uint32_t		xs_add_exlist;
-	__uint32_t		xs_del_exlist;
-	__uint32_t		xs_look_exlist;
-	__uint32_t		xs_cmp_exlist;
-# define XFSSTAT_END_BLOCK_MAP_BTREE	(XFSSTAT_END_BLOCK_MAPPING+4)
-	__uint32_t		xs_bmbt_lookup;
-	__uint32_t		xs_bmbt_compare;
-	__uint32_t		xs_bmbt_insrec;
-	__uint32_t		xs_bmbt_delrec;
-# define XFSSTAT_END_DIRECTORY_OPS	(XFSSTAT_END_BLOCK_MAP_BTREE+4)
-	__uint32_t		xs_dir_lookup;
-	__uint32_t		xs_dir_create;
-	__uint32_t		xs_dir_remove;
-	__uint32_t		xs_dir_getdents;
-# define XFSSTAT_END_TRANSACTIONS	(XFSSTAT_END_DIRECTORY_OPS+3)
-	__uint32_t		xs_trans_sync;
-	__uint32_t		xs_trans_async;
-	__uint32_t		xs_trans_empty;
-# define XFSSTAT_END_INODE_OPS		(XFSSTAT_END_TRANSACTIONS+7)
-	__uint32_t		xs_ig_attempts;
-	__uint32_t		xs_ig_found;
-	__uint32_t		xs_ig_frecycle;
-	__uint32_t		xs_ig_missed;
-	__uint32_t		xs_ig_dup;
-	__uint32_t		xs_ig_reclaims;
-	__uint32_t		xs_ig_attrchg;
-# define XFSSTAT_END_LOG_OPS		(XFSSTAT_END_INODE_OPS+5)
-	__uint32_t		xs_log_writes;
-	__uint32_t		xs_log_blocks;
-	__uint32_t		xs_log_noiclogs;
-	__uint32_t		xs_log_force;
-	__uint32_t		xs_log_force_sleep;
-# define XFSSTAT_END_TAIL_PUSHING	(XFSSTAT_END_LOG_OPS+10)
-	__uint32_t		xs_try_logspace;
-	__uint32_t		xs_sleep_logspace;
-	__uint32_t		xs_push_ail;
-	__uint32_t		xs_push_ail_success;
-	__uint32_t		xs_push_ail_pushbuf;
-	__uint32_t		xs_push_ail_pinned;
-	__uint32_t		xs_push_ail_locked;
-	__uint32_t		xs_push_ail_flushing;
-	__uint32_t		xs_push_ail_restarts;
-	__uint32_t		xs_push_ail_flush;
-# define XFSSTAT_END_WRITE_CONVERT	(XFSSTAT_END_TAIL_PUSHING+2)
-	__uint32_t		xs_xstrat_quick;
-	__uint32_t		xs_xstrat_split;
-# define XFSSTAT_END_READ_WRITE_OPS	(XFSSTAT_END_WRITE_CONVERT+2)
-	__uint32_t		xs_write_calls;
-	__uint32_t		xs_read_calls;
-# define XFSSTAT_END_ATTRIBUTE_OPS	(XFSSTAT_END_READ_WRITE_OPS+4)
-	__uint32_t		xs_attr_get;
-	__uint32_t		xs_attr_set;
-	__uint32_t		xs_attr_remove;
-	__uint32_t		xs_attr_list;
-# define XFSSTAT_END_INODE_CLUSTER	(XFSSTAT_END_ATTRIBUTE_OPS+3)
-	__uint32_t		xs_iflush_count;
-	__uint32_t		xs_icluster_flushcnt;
-	__uint32_t		xs_icluster_flushinode;
-# define XFSSTAT_END_VNODE_OPS		(XFSSTAT_END_INODE_CLUSTER+8)
-	__uint32_t		vn_active;	/* # vnodes not on free lists */
-	__uint32_t		vn_alloc;	/* # times vn_alloc called */
-	__uint32_t		vn_get;		/* # times vn_get called */
-	__uint32_t		vn_hold;	/* # times vn_hold called */
-	__uint32_t		vn_rele;	/* # times vn_rele called */
-	__uint32_t		vn_reclaim;	/* # times vn_reclaim called */
-	__uint32_t		vn_remove;	/* # times vn_remove called */
-	__uint32_t		vn_free;	/* # times vn_free called */
-#define XFSSTAT_END_BUF			(XFSSTAT_END_VNODE_OPS+9)
-	__uint32_t		xb_get;
-	__uint32_t		xb_create;
-	__uint32_t		xb_get_locked;
-	__uint32_t		xb_get_locked_waited;
-	__uint32_t		xb_busy_locked;
-	__uint32_t		xb_miss_locked;
-	__uint32_t		xb_page_retries;
-	__uint32_t		xb_page_found;
-	__uint32_t		xb_get_read;
-/* Version 2 btree counters */
-#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+15)
-	__uint32_t		xs_abtb_2_lookup;
-	__uint32_t		xs_abtb_2_compare;
-	__uint32_t		xs_abtb_2_insrec;
-	__uint32_t		xs_abtb_2_delrec;
-	__uint32_t		xs_abtb_2_newroot;
-	__uint32_t		xs_abtb_2_killroot;
-	__uint32_t		xs_abtb_2_increment;
-	__uint32_t		xs_abtb_2_decrement;
-	__uint32_t		xs_abtb_2_lshift;
-	__uint32_t		xs_abtb_2_rshift;
-	__uint32_t		xs_abtb_2_split;
-	__uint32_t		xs_abtb_2_join;
-	__uint32_t		xs_abtb_2_alloc;
-	__uint32_t		xs_abtb_2_free;
-	__uint32_t		xs_abtb_2_moves;
-#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+15)
-	__uint32_t		xs_abtc_2_lookup;
-	__uint32_t		xs_abtc_2_compare;
-	__uint32_t		xs_abtc_2_insrec;
-	__uint32_t		xs_abtc_2_delrec;
-	__uint32_t		xs_abtc_2_newroot;
-	__uint32_t		xs_abtc_2_killroot;
-	__uint32_t		xs_abtc_2_increment;
-	__uint32_t		xs_abtc_2_decrement;
-	__uint32_t		xs_abtc_2_lshift;
-	__uint32_t		xs_abtc_2_rshift;
-	__uint32_t		xs_abtc_2_split;
-	__uint32_t		xs_abtc_2_join;
-	__uint32_t		xs_abtc_2_alloc;
-	__uint32_t		xs_abtc_2_free;
-	__uint32_t		xs_abtc_2_moves;
-#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+15)
-	__uint32_t		xs_bmbt_2_lookup;
-	__uint32_t		xs_bmbt_2_compare;
-	__uint32_t		xs_bmbt_2_insrec;
-	__uint32_t		xs_bmbt_2_delrec;
-	__uint32_t		xs_bmbt_2_newroot;
-	__uint32_t		xs_bmbt_2_killroot;
-	__uint32_t		xs_bmbt_2_increment;
-	__uint32_t		xs_bmbt_2_decrement;
-	__uint32_t		xs_bmbt_2_lshift;
-	__uint32_t		xs_bmbt_2_rshift;
-	__uint32_t		xs_bmbt_2_split;
-	__uint32_t		xs_bmbt_2_join;
-	__uint32_t		xs_bmbt_2_alloc;
-	__uint32_t		xs_bmbt_2_free;
-	__uint32_t		xs_bmbt_2_moves;
-#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+15)
-	__uint32_t		xs_ibt_2_lookup;
-	__uint32_t		xs_ibt_2_compare;
-	__uint32_t		xs_ibt_2_insrec;
-	__uint32_t		xs_ibt_2_delrec;
-	__uint32_t		xs_ibt_2_newroot;
-	__uint32_t		xs_ibt_2_killroot;
-	__uint32_t		xs_ibt_2_increment;
-	__uint32_t		xs_ibt_2_decrement;
-	__uint32_t		xs_ibt_2_lshift;
-	__uint32_t		xs_ibt_2_rshift;
-	__uint32_t		xs_ibt_2_split;
-	__uint32_t		xs_ibt_2_join;
-	__uint32_t		xs_ibt_2_alloc;
-	__uint32_t		xs_ibt_2_free;
-	__uint32_t		xs_ibt_2_moves;
-/* Extra precision counters */
-	__uint64_t		xs_xstrat_bytes;
-	__uint64_t		xs_write_bytes;
-	__uint64_t		xs_read_bytes;
-};
-
-DECLARE_PER_CPU(struct xfsstats, xfsstats);
-
-/*
- * We don't disable preempt, not too worried about poking the
- * wrong CPU's stat for now (also aggregated before reporting).
- */
-#define XFS_STATS_INC(v)	(per_cpu(xfsstats, current_cpu()).v++)
-#define XFS_STATS_DEC(v)	(per_cpu(xfsstats, current_cpu()).v--)
-#define XFS_STATS_ADD(v, inc)	(per_cpu(xfsstats, current_cpu()).v += (inc))
-
-extern int xfs_init_procfs(void);
-extern void xfs_cleanup_procfs(void);
-
-
-#else	/* !CONFIG_PROC_FS */
-
-# define XFS_STATS_INC(count)
-# define XFS_STATS_DEC(count)
-# define XFS_STATS_ADD(count, inc)
-
-static inline int xfs_init_procfs(void)
-{
-	return 0;
-}
-
-static inline void xfs_cleanup_procfs(void)
-{
-}
-
-#endif	/* !CONFIG_PROC_FS */
-
-#endif /* __XFS_STATS_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
deleted file mode 100644
index 25fd2cd..0000000
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ /dev/null
@@ -1,1766 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-
-#include "xfs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
-#include "xfs_error.h"
-#include "xfs_itable.h"
-#include "xfs_fsops.h"
-#include "xfs_attr.h"
-#include "xfs_buf_item.h"
-#include "xfs_utils.h"
-#include "xfs_vnodeops.h"
-#include "xfs_log_priv.h"
-#include "xfs_trans_priv.h"
-#include "xfs_filestream.h"
-#include "xfs_da_btree.h"
-#include "xfs_extfree_item.h"
-#include "xfs_mru_cache.h"
-#include "xfs_inode_item.h"
-#include "xfs_sync.h"
-#include "xfs_trace.h"
-
-#include <linux/namei.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/mount.h>
-#include <linux/mempool.h>
-#include <linux/writeback.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-#include <linux/parser.h>
-
-static const struct super_operations xfs_super_operations;
-static kmem_zone_t *xfs_ioend_zone;
-mempool_t *xfs_ioend_pool;
-
-#define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
-#define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
-#define MNTOPT_LOGDEV	"logdev"	/* log device */
-#define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
-#define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
-#define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
-#define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
-#define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
-#define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
-#define MNTOPT_SWIDTH	"swidth"	/* data volume stripe width */
-#define MNTOPT_NOUUID	"nouuid"	/* ignore filesystem UUID */
-#define MNTOPT_MTPT	"mtpt"		/* filesystem mount point */
-#define MNTOPT_GRPID	"grpid"		/* group-ID from parent directory */
-#define MNTOPT_NOGRPID	"nogrpid"	/* group-ID from current process */
-#define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
-#define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
-#define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
-#define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
-#define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
-					 * unwritten extent conversion */
-#define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
-#define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
-#define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
-#define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
-#define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
-#define MNTOPT_NOLARGEIO   "nolargeio"	/* do not report large I/O sizes
-					 * in stat(). */
-#define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
-#define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
-#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
-#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
-#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
-#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
-#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
-#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
-#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
-#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
-#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
-#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
-#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
-#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
-#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
-#define MNTOPT_DELAYLOG    "delaylog"	/* Delayed logging enabled */
-#define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
-#define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
-#define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
-
-/*
- * Table driven mount option parser.
- *
- * Currently only used for remount, but it will be used for mount
- * in the future, too.
- */
-enum {
-	Opt_barrier, Opt_nobarrier, Opt_err
-};
-
-static const match_table_t tokens = {
-	{Opt_barrier, "barrier"},
-	{Opt_nobarrier, "nobarrier"},
-	{Opt_err, NULL}
-};
-
-
-STATIC unsigned long
-suffix_strtoul(char *s, char **endp, unsigned int base)
-{
-	int	last, shift_left_factor = 0;
-	char	*value = s;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
-}
-
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- *
- * Note that this function leaks the various device name allocations on
- * failure.  The caller takes care of them.
- */
-STATIC int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
-{
-	struct super_block	*sb = mp->m_super;
-	char			*this_char, *value, *eov;
-	int			dsunit = 0;
-	int			dswidth = 0;
-	int			iosize = 0;
-	__uint8_t		iosizelog = 0;
-
-	/*
-	 * set up the mount name first so all the errors will refer to the
-	 * correct device.
-	 */
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
-
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (sb->s_flags & MS_RDONLY)
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	if (sb->s_flags & MS_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (sb->s_flags & MS_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-
-	/*
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_BARRIER;
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-	mp->m_flags |= XFS_MOUNT_DELAYLOG;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-
-	if (!options)
-		goto done;
-
-	while ((this_char = strsep(&options, ",")) != NULL) {
-		if (!*this_char)
-			continue;
-		if ((value = strchr(this_char, '=')) != NULL)
-			*value++ = 0;
-
-		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logbufs = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
-			if (!mp->m_logname)
-				return ENOMEM;
-		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
-			return EINVAL;
-		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
-			if (!mp->m_rtname)
-				return ENOMEM;
-		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = simple_strtoul(value, &eov, 10);
-			iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = suffix_strtoul(value, &eov, 10);
-			iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
-			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
-			mp->m_flags |= XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
-			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
-			mp->m_flags |= XFS_MOUNT_WSYNC;
-		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
-			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
-			mp->m_flags |= XFS_MOUNT_NOALIGN;
-		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
-			mp->m_flags |= XFS_MOUNT_SWALLOC;
-		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dsunit = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dswidth = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-#if !XFS_BIG_INUMS
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
-			return EINVAL;
-#endif
-		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
-			mp->m_flags |= XFS_MOUNT_NOUUID;
-		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
-			mp->m_flags |= XFS_MOUNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
-			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
-			mp->m_flags |= XFS_MOUNT_IKEEP;
-		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
-			mp->m_flags &= ~XFS_MOUNT_IKEEP;
-		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
-			mp->m_flags |= XFS_MOUNT_ATTR2;
-		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
-			mp->m_flags &= ~XFS_MOUNT_ATTR2;
-			mp->m_flags |= XFS_MOUNT_NOATTR2;
-		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
-			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
-			   !strcmp(this_char, MNTOPT_UQUOTA) ||
-			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					 XFS_UQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
-			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
-			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					 XFS_OQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
-			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					 XFS_OQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
-			mp->m_flags |= XFS_MOUNT_DELAYLOG;
-		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
-			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
-		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
-			mp->m_flags |= XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, "ihashsize")) {
-			xfs_warn(mp,
-	"ihashsize no longer used, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisdsync")) {
-			xfs_warn(mp,
-	"osyncisdsync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisosync")) {
-			xfs_warn(mp,
-	"osyncisosync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "irixsgid")) {
-			xfs_warn(mp,
-	"irixsgid is now a sysctl(2) variable, option is deprecated.");
-		} else {
-			xfs_warn(mp, "unknown mount option [%s].", this_char);
-			return EINVAL;
-		}
-	}
-
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_warn(mp, "no-recovery mounts must be read-only.");
-		return EINVAL;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
-		xfs_warn(mp,
-	"sunit and swidth options incompatible with the noalign option");
-		return EINVAL;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_DISCARD) &&
-	    !(mp->m_flags & XFS_MOUNT_DELAYLOG)) {
-		xfs_warn(mp,
-	"the discard option is incompatible with the nodelaylog option");
-		return EINVAL;
-	}
-
-#ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
-		xfs_warn(mp, "quota support not available in this kernel.");
-		return EINVAL;
-	}
-#endif
-
-	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
-	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
-		xfs_warn(mp, "cannot mount with both project and group quota");
-		return EINVAL;
-	}
-
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
-		xfs_warn(mp, "sunit and swidth must be specified together");
-		return EINVAL;
-	}
-
-	if (dsunit && (dswidth % dsunit != 0)) {
-		xfs_warn(mp,
-	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
-		return EINVAL;
-	}
-
-done:
-	if (!(mp->m_flags & XFS_MOUNT_NOALIGN)) {
-		/*
-		 * At this point the superblock has not been read
-		 * in, therefore we do not know the block size.
-		 * Before the mount call ends we will convert
-		 * these to FSBs.
-		 */
-		if (dsunit) {
-			mp->m_dalign = dsunit;
-			mp->m_flags |= XFS_MOUNT_RETERR;
-		}
-
-		if (dswidth)
-			mp->m_swidth = dswidth;
-	}
-
-	if (mp->m_logbufs != -1 &&
-	    mp->m_logbufs != 0 &&
-	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
-	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
-		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
-			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return XFS_ERROR(EINVAL);
-	}
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return XFS_ERROR(EINVAL);
-	}
-
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
-			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
-			return XFS_ERROR(EINVAL);
-		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
-		mp->m_writeio_log = iosizelog;
-	}
-
-	return 0;
-}
-
-struct proc_xfs_info {
-	int	flag;
-	char	*str;
-};
-
-STATIC int
-xfs_showargs(
-	struct xfs_mount	*mp,
-	struct seq_file		*m)
-{
-	static struct proc_xfs_info xfs_info_set[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
-		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
-		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
-		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
-		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
-		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
-		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
-		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
-		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
-		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
-		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
-		{ 0, NULL }
-	};
-	static struct proc_xfs_info xfs_info_unset[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
-		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
-		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
-		{ 0, NULL }
-	};
-	struct proc_xfs_info	*xfs_infop;
-
-	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
-		if (mp->m_flags & xfs_infop->flag)
-			seq_puts(m, xfs_infop->str);
-	}
-	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
-		if (!(mp->m_flags & xfs_infop->flag))
-			seq_puts(m, xfs_infop->str);
-	}
-
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
-				(int)(1 << mp->m_writeio_log) >> 10);
-
-	if (mp->m_logbufs > 0)
-		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
-	if (mp->m_logbsize > 0)
-		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
-
-	if (mp->m_logname)
-		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
-	if (mp->m_rtname)
-		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
-
-	if (mp->m_dalign > 0)
-		seq_printf(m, "," MNTOPT_SUNIT "=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
-	if (mp->m_swidth > 0)
-		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
-				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
-
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_USRQUOTA);
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_UQUOTANOENF);
-
-	/* Either project or group quotas can be active, not both */
-
-	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_PRJQUOTA);
-		else
-			seq_puts(m, "," MNTOPT_PQUOTANOENF);
-	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_GRPQUOTA);
-		else
-			seq_puts(m, "," MNTOPT_GQUOTANOENF);
-	}
-
-	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
-		seq_puts(m, "," MNTOPT_NOQUOTA);
-
-	return 0;
-}
-__uint64_t
-xfs_max_file_offset(
-	unsigned int		blockshift)
-{
-	unsigned int		pagefactor = 1;
-	unsigned int		bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_write_begin does this in an [unsigned] long...
-	 *      page->index << (PAGE_CACHE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
-	 * Note1: get_block_t takes a long (implicit cast from above)
-	 * Note2: The Large Block Device (LBD and HAVE_SECTOR_T) patch
-	 * can optionally convert the [unsigned] long from above into
-	 * an [unsigned] long long.
-	 */
-
-#if BITS_PER_LONG == 32
-# if defined(CONFIG_LBDAF)
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_CACHE_SIZE;
-	bitshift = BITS_PER_LONG;
-# else
-	pagefactor = PAGE_CACHE_SIZE >> (PAGE_CACHE_SHIFT - blockshift);
-# endif
-#endif
-
-	return (((__uint64_t)pagefactor) << bitshift) - 1;
-}
-
-STATIC int
-xfs_blkdev_get(
-	xfs_mount_t		*mp,
-	const char		*name,
-	struct block_device	**bdevp)
-{
-	int			error = 0;
-
-	*bdevp = blkdev_get_by_path(name, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-				    mp);
-	if (IS_ERR(*bdevp)) {
-		error = PTR_ERR(*bdevp);
-		xfs_warn(mp, "Invalid device [%s], error=%d\n", name, error);
-	}
-
-	return -error;
-}
-
-STATIC void
-xfs_blkdev_put(
-	struct block_device	*bdev)
-{
-	if (bdev)
-		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-}
-
-void
-xfs_blkdev_issue_flush(
-	xfs_buftarg_t		*buftarg)
-{
-	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
-}
-
-STATIC void
-xfs_close_devices(
-	struct xfs_mount	*mp)
-{
-	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
-		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
-		xfs_free_buftarg(mp, mp->m_logdev_targp);
-		xfs_blkdev_put(logdev);
-	}
-	if (mp->m_rtdev_targp) {
-		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
-		xfs_free_buftarg(mp, mp->m_rtdev_targp);
-		xfs_blkdev_put(rtdev);
-	}
-	xfs_free_buftarg(mp, mp->m_ddev_targp);
-}
-
-/*
- * The file system configurations are:
- *	(1) device (partition) with data and internal log
- *	(2) logical volume with data and log subvolumes.
- *	(3) logical volume with data, log, and realtime subvolumes.
- *
- * We only have to handle opening the log and realtime volumes here if
- * they are present.  The data subvolume has already been opened by
- * get_sb_bdev() and is stored in sb->s_bdev.
- */
-STATIC int
-xfs_open_devices(
-	struct xfs_mount	*mp)
-{
-	struct block_device	*ddev = mp->m_super->s_bdev;
-	struct block_device	*logdev = NULL, *rtdev = NULL;
-	int			error;
-
-	/*
-	 * Open real time and log devices - order is important.
-	 */
-	if (mp->m_logname) {
-		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
-		if (error)
-			goto out;
-	}
-
-	if (mp->m_rtname) {
-		error = xfs_blkdev_get(mp, mp->m_rtname, &rtdev);
-		if (error)
-			goto out_close_logdev;
-
-		if (rtdev == ddev || rtdev == logdev) {
-			xfs_warn(mp,
-	"Cannot mount filesystem with identical rtdev and ddev/logdev.");
-			error = EINVAL;
-			goto out_close_rtdev;
-		}
-	}
-
-	/*
-	 * Setup xfs_mount buffer target pointers
-	 */
-	error = ENOMEM;
-	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, 0, mp->m_fsname);
-	if (!mp->m_ddev_targp)
-		goto out_close_rtdev;
-
-	if (rtdev) {
-		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, 1,
-							mp->m_fsname);
-		if (!mp->m_rtdev_targp)
-			goto out_free_ddev_targ;
-	}
-
-	if (logdev && logdev != ddev) {
-		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, 1,
-							mp->m_fsname);
-		if (!mp->m_logdev_targp)
-			goto out_free_rtdev_targ;
-	} else {
-		mp->m_logdev_targp = mp->m_ddev_targp;
-	}
-
-	return 0;
-
- out_free_rtdev_targ:
-	if (mp->m_rtdev_targp)
-		xfs_free_buftarg(mp, mp->m_rtdev_targp);
- out_free_ddev_targ:
-	xfs_free_buftarg(mp, mp->m_ddev_targp);
- out_close_rtdev:
-	if (rtdev)
-		xfs_blkdev_put(rtdev);
- out_close_logdev:
-	if (logdev && logdev != ddev)
-		xfs_blkdev_put(logdev);
- out:
-	return error;
-}
-
-/*
- * Setup xfs_mount buffer target pointers based on superblock
- */
-STATIC int
-xfs_setup_devices(
-	struct xfs_mount	*mp)
-{
-	int			error;
-
-	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
-				    mp->m_sb.sb_sectsize);
-	if (error)
-		return error;
-
-	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
-		unsigned int	log_sector_size = BBSIZE;
-
-		if (xfs_sb_version_hassector(&mp->m_sb))
-			log_sector_size = mp->m_sb.sb_logsectsize;
-		error = xfs_setsize_buftarg(mp->m_logdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    log_sector_size);
-		if (error)
-			return error;
-	}
-	if (mp->m_rtdev_targp) {
-		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    mp->m_sb.sb_sectsize);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
-/* Catch misguided souls that try to use this interface on XFS */
-STATIC struct inode *
-xfs_fs_alloc_inode(
-	struct super_block	*sb)
-{
-	BUG();
-	return NULL;
-}
-
-/*
- * Now that the generic code is guaranteed not to be accessing
- * the linux inode, we can reclaim the inode.
- */
-STATIC void
-xfs_fs_destroy_inode(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-
-	trace_xfs_destroy_inode(ip);
-
-	XFS_STATS_INC(vn_reclaim);
-
-	/* bad inode, get out here ASAP */
-	if (is_bad_inode(inode))
-		goto out_reclaim;
-
-	xfs_ioend_wait(ip);
-
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
-
-	/*
-	 * We should never get here with one of the reclaim flags already set.
-	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
-
-	/*
-	 * We always use background reclaim here because even if the
-	 * inode is clean, it still may be under IO and hence we have
-	 * to take the flush lock. The background reclaim path handles
-	 * this more efficiently than we can here, so simply let background
-	 * reclaim tear down all inodes.
-	 */
-out_reclaim:
-	xfs_inode_set_reclaim_tag(ip);
-}
-
-/*
- * Slab object creation initialisation for the XFS inode.
- * This covers only the idempotent fields in the XFS inode;
- * all other fields need to be initialised on allocation
- * from the slab. This avoids the need to repeatedly initialise
- * fields in the xfs inode that left in the initialise state
- * when freeing the inode.
- */
-STATIC void
-xfs_fs_inode_init_once(
-	void			*inode)
-{
-	struct xfs_inode	*ip = inode;
-
-	memset(ip, 0, sizeof(struct xfs_inode));
-
-	/* vfs inode */
-	inode_init_once(VFS_I(ip));
-
-	/* xfs inode */
-	atomic_set(&ip->i_iocount, 0);
-	atomic_set(&ip->i_pincount, 0);
-	spin_lock_init(&ip->i_flags_lock);
-	init_waitqueue_head(&ip->i_ipin_wait);
-	/*
-	 * Because we want to use a counting completion, complete
-	 * the flush completion once to allow a single access to
-	 * the flush completion without blocking.
-	 */
-	init_completion(&ip->i_flush);
-	complete(&ip->i_flush);
-
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-}
-
-/*
- * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
- * we catch unlogged VFS level updates to the inode.
- *
- * We need the barrier() to maintain correct ordering between unlogged
- * updates and the transaction commit code that clears the i_update_core
- * field. This requires all updates to be completed before marking the
- * inode dirty.
- */
-STATIC void
-xfs_fs_dirty_inode(
-	struct inode	*inode,
-	int		flags)
-{
-	barrier();
-	XFS_I(inode)->i_update_core = 1;
-}
-
-STATIC int
-xfs_log_inode(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		/* we need to return with the lock hold shared */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Note - it's possible that we might have pushed ourselves out of the
-	 * way during trans_reserve which would flush the inode.  But there's
-	 * no guarantee that the inode buffer has actually gone out yet (it's
-	 * delwri).  Plus the buffer could be pinned anyway if it's part of
-	 * an inode in another recent transaction.  So we play it safe and
-	 * fire off the transaction anyway.
-	 */
-	xfs_trans_ijoin(tp, ip);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
-	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
-
-	return error;
-}
-
-STATIC int
-xfs_fs_write_inode(
-	struct inode		*inode,
-	struct writeback_control *wbc)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = EAGAIN;
-
-	trace_xfs_write_inode(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		/*
-		 * Make sure the inode has made it it into the log.  Instead
-		 * of forcing it all the way to stable storage using a
-		 * synchronous transaction we let the log force inside the
-		 * ->sync_fs call do that for thus, which reduces the number
-		 * of synchronous log foces dramatically.
-		 */
-		xfs_ioend_wait(ip);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if (ip->i_update_core) {
-			error = xfs_log_inode(ip);
-			if (error)
-				goto out_unlock;
-		}
-	} else {
-		/*
-		 * We make this non-blocking if the inode is contended, return
-		 * EAGAIN to indicate to the caller that they did not succeed.
-		 * This prevents the flush path from blocking on inodes inside
-		 * another operation right now, they get caught later by
-		 * xfs_sync.
-		 */
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-			goto out;
-
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-			goto out_unlock;
-
-		/*
-		 * Now we have the flush lock and the inode is not pinned, we
-		 * can check if the inode is really clean as we know that
-		 * there are no pending transaction completions, it is not
-		 * waiting on the delayed write queue and there is no IO in
-		 * progress.
-		 */
-		if (xfs_inode_clean(ip)) {
-			xfs_ifunlock(ip);
-			error = 0;
-			goto out_unlock;
-		}
-		error = xfs_iflush(ip, SYNC_TRYLOCK);
-	}
-
- out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
- out:
-	/*
-	 * if we failed to write out the inode then mark
-	 * it dirty again so we'll try again later.
-	 */
-	if (error)
-		xfs_mark_inode_dirty_sync(ip);
-	return -error;
-}
-
-STATIC void
-xfs_fs_evict_inode(
-	struct inode		*inode)
-{
-	xfs_inode_t		*ip = XFS_I(inode);
-
-	trace_xfs_evict_inode(ip);
-
-	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
-	XFS_STATS_INC(vn_rele);
-	XFS_STATS_INC(vn_remove);
-	XFS_STATS_DEC(vn_active);
-
-	/*
-	 * The iolock is used by the file system to coordinate reads,
-	 * writes, and block truncates.  Up to this point the lock
-	 * protected concurrent accesses by users of the inode.  But
-	 * from here forward we're doing some final processing of the
-	 * inode because we're done with it, and although we reuse the
-	 * iolock for protection it is really a distinct lock class
-	 * (in the lockdep sense) from before.  To keep lockdep happy
-	 * (and basically indicate what we are doing), we explicitly
-	 * re-init the iolock here.
-	 */
-	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-	lockdep_set_class_and_name(&ip->i_iolock.mr_lock,
-			&xfs_iolock_reclaimable, "xfs_iolock_reclaimable");
-
-	xfs_inactive(ip);
-}
-
-STATIC void
-xfs_free_fsname(
-	struct xfs_mount	*mp)
-{
-	kfree(mp->m_fsname);
-	kfree(mp->m_rtname);
-	kfree(mp->m_logname);
-}
-
-STATIC void
-xfs_fs_put_super(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	/*
-	 * Unregister the memory shrinker before we tear down the mount
-	 * structure so we don't have memory reclaim racing with us here.
-	 */
-	xfs_inode_shrinker_unregister(mp);
-	xfs_syncd_stop(mp);
-
-	/*
-	 * Blow away any referenced inode in the filestreams cache.
-	 * This can and will cause log traffic as inodes go inactive
-	 * here.
-	 */
-	xfs_filestream_unmount(mp);
-
-	XFS_bflush(mp->m_ddev_targp);
-
-	xfs_unmountfs(mp);
-	xfs_freesb(mp);
-	xfs_icsb_destroy_counters(mp);
-	xfs_close_devices(mp);
-	xfs_free_fsname(mp);
-	kfree(mp);
-}
-
-STATIC int
-xfs_fs_sync_fs(
-	struct super_block	*sb,
-	int			wait)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-	int			error;
-
-	/*
-	 * Not much we can do for the first async pass.  Writing out the
-	 * superblock would be counter-productive as we are going to redirty
-	 * when writing out other data and metadata (and writing out a single
-	 * block is quite fast anyway).
-	 *
-	 * Try to asynchronously kick off quota syncing at least.
-	 */
-	if (!wait) {
-		xfs_qm_sync(mp, SYNC_TRYLOCK);
-		return 0;
-	}
-
-	error = xfs_quiesce_data(mp);
-	if (error)
-		return -error;
-
-	if (laptop_mode) {
-		/*
-		 * The disk must be active because we're syncing.
-		 * We schedule xfssyncd now (now that the disk is
-		 * active) instead of later (when it might not be).
-		 */
-		flush_delayed_work_sync(&mp->m_sync_work);
-	}
-
-	return 0;
-}
-
-STATIC int
-xfs_fs_statfs(
-	struct dentry		*dentry,
-	struct kstatfs		*statp)
-{
-	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
-	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
-	__uint64_t		fakeinos, id;
-	xfs_extlen_t		lsize;
-	__int64_t		ffree;
-
-	statp->f_type = XFS_SB_MAGIC;
-	statp->f_namelen = MAXNAMELEN - 1;
-
-	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
-	statp->f_fsid.val[0] = (u32)id;
-	statp->f_fsid.val[1] = (u32)(id >> 32);
-
-	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
-
-	spin_lock(&mp->m_sb_lock);
-	statp->f_bsize = sbp->sb_blocksize;
-	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
-	statp->f_bfree = statp->f_bavail =
-				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-	statp->f_files =
-	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
-	if (mp->m_maxicount)
-		statp->f_files = min_t(typeof(statp->f_files),
-					statp->f_files,
-					mp->m_maxicount);
-
-	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
-	statp->f_ffree = max_t(__int64_t, ffree, 0);
-
-	spin_unlock(&mp->m_sb_lock);
-
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		xfs_qm_statvfs(ip, statp);
-	return 0;
-}
-
-STATIC void
-xfs_save_resvblks(struct xfs_mount *mp)
-{
-	__uint64_t resblks = 0;
-
-	mp->m_resblks_save = mp->m_resblks;
-	xfs_reserve_blocks(mp, &resblks, NULL);
-}
-
-STATIC void
-xfs_restore_resvblks(struct xfs_mount *mp)
-{
-	__uint64_t resblks;
-
-	if (mp->m_resblks_save) {
-		resblks = mp->m_resblks_save;
-		mp->m_resblks_save = 0;
-	} else
-		resblks = xfs_default_resblks(mp);
-
-	xfs_reserve_blocks(mp, &resblks, NULL);
-}
-
-STATIC int
-xfs_fs_remount(
-	struct super_block	*sb,
-	int			*flags,
-	char			*options)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-	substring_t		args[MAX_OPT_ARGS];
-	char			*p;
-	int			error;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_barrier:
-			mp->m_flags |= XFS_MOUNT_BARRIER;
-			break;
-		case Opt_nobarrier:
-			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-			break;
-		default:
-			/*
-			 * Logically we would return an error here to prevent
-			 * users from believing they might have changed
-			 * mount options using remount which can't be changed.
-			 *
-			 * But unfortunately mount(8) adds all options from
-			 * mtab and fstab to the mount arguments in some cases
-			 * so we can't blindly reject options, but have to
-			 * check for each specified option if it actually
-			 * differs from the currently set option and only
-			 * reject it if that's the case.
-			 *
-			 * Until that is implemented we return success for
-			 * every remount request, and silently ignore all
-			 * options that we can't actually change.
-			 */
-#if 0
-			xfs_info(mp,
-		"mount option \"%s\" not supported for remount\n", p);
-			return -EINVAL;
-#else
-			break;
-#endif
-		}
-	}
-
-	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
-		/*
-		 * If this is the first remount to writeable state we
-		 * might have some superblock changes to update.
-		 */
-		if (mp->m_update_flags) {
-			error = xfs_mount_log_sb(mp, mp->m_update_flags);
-			if (error) {
-				xfs_warn(mp, "failed to write sb changes");
-				return error;
-			}
-			mp->m_update_flags = 0;
-		}
-
-		/*
-		 * Fill out the reserve pool if it is empty. Use the stashed
-		 * value if it is non-zero, otherwise go with the default.
-		 */
-		xfs_restore_resvblks(mp);
-	}
-
-	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
-		/*
-		 * After we have synced the data but before we sync the
-		 * metadata, we need to free up the reserve block pool so that
-		 * the used block count in the superblock on disk is correct at
-		 * the end of the remount. Stash the current reserve pool size
-		 * so that if we get remounted rw, we can return it to the same
-		 * size.
-		 */
-
-		xfs_quiesce_data(mp);
-		xfs_save_resvblks(mp);
-		xfs_quiesce_attr(mp);
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	}
-
-	return 0;
-}
-
-/*
- * Second stage of a freeze. The data is already frozen so we only
- * need to take care of the metadata. Once that's done write a dummy
- * record to dirty the log in case of a crash while frozen.
- */
-STATIC int
-xfs_fs_freeze(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	xfs_save_resvblks(mp);
-	xfs_quiesce_attr(mp);
-	return -xfs_fs_log_dummy(mp);
-}
-
-STATIC int
-xfs_fs_unfreeze(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	xfs_restore_resvblks(mp);
-	return 0;
-}
-
-STATIC int
-xfs_fs_show_options(
-	struct seq_file		*m,
-	struct vfsmount		*mnt)
-{
-	return -xfs_showargs(XFS_M(mnt->mnt_sb), m);
-}
-
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock _has_ now been read in.
- */
-STATIC int
-xfs_finish_flags(
-	struct xfs_mount	*mp)
-{
-	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
-	/* Fail a mount where the logbuf is smaller than the log stripe */
-	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
-		if (mp->m_logbsize <= 0 &&
-		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
-			mp->m_logbsize = mp->m_sb.sb_logsunit;
-		} else if (mp->m_logbsize > 0 &&
-			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
-			xfs_warn(mp,
-		"logbuf size must be greater than or equal to log stripe size");
-			return XFS_ERROR(EINVAL);
-		}
-	} else {
-		/* Fail a mount if the logbuf is larger than 32K */
-		if (mp->m_logbsize > XLOG_BIG_RECORD_BSIZE) {
-			xfs_warn(mp,
-		"logbuf size for version 1 logs must be 16K or 32K");
-			return XFS_ERROR(EINVAL);
-		}
-	}
-
-	/*
-	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
-	 * told by noattr2 to turn it off
-	 */
-	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
-	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-
-	/*
-	 * prohibit r/w mounts of read-only filesystems
-	 */
-	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
-		xfs_warn(mp,
-			"cannot mount a read-only filesystem as read-write");
-		return XFS_ERROR(EROFS);
-	}
-
-	return 0;
-}
-
-STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
-	int			silent)
-{
-	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
-	int			flags = 0, error = ENOMEM;
-
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
-	if (!mp)
-		goto out;
-
-	spin_lock_init(&mp->m_sb_lock);
-	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
-
-	mp->m_super = sb;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_fsname;
-
-	sb_min_blocksize(sb, BBSIZE);
-	sb->s_xattr = xfs_xattr_handlers;
-	sb->s_export_op = &xfs_export_operations;
-#ifdef CONFIG_XFS_QUOTA
-	sb->s_qcop = &xfs_quotactl_operations;
-#endif
-	sb->s_op = &xfs_super_operations;
-
-	if (silent)
-		flags |= XFS_MFSI_QUIET;
-
-	error = xfs_open_devices(mp);
-	if (error)
-		goto out_free_fsname;
-
-	error = xfs_icsb_init_counters(mp);
-	if (error)
-		goto out_close_devices;
-
-	error = xfs_readsb(mp, flags);
-	if (error)
-		goto out_destroy_counters;
-
-	error = xfs_finish_flags(mp);
-	if (error)
-		goto out_free_sb;
-
-	error = xfs_setup_devices(mp);
-	if (error)
-		goto out_free_sb;
-
-	error = xfs_filestream_mount(mp);
-	if (error)
-		goto out_free_sb;
-
-	/*
-	 * we must configure the block size in the superblock before we run the
-	 * full mount process as the mount process can lookup and cache inodes.
-	 * For the same reason we must also initialise the syncd and register
-	 * the inode cache shrinker so that inodes can be reclaimed during
-	 * operations like a quotacheck that iterate all inodes in the
-	 * filesystem.
-	 */
-	sb->s_magic = XFS_SB_MAGIC;
-	sb->s_blocksize = mp->m_sb.sb_blocksize;
-	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
-	sb->s_time_gran = 1;
-	set_posix_acl_flag(sb);
-
-	xfs_inode_shrinker_register(mp);
-
-	error = xfs_mountfs(mp);
-	if (error)
-		goto out_filestream_unmount;
-
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto out_unmount;
-
-	root = igrab(VFS_I(mp->m_rootip));
-	if (!root) {
-		error = ENOENT;
-		goto out_syncd_stop;
-	}
-	if (is_bad_inode(root)) {
-		error = EINVAL;
-		goto out_syncd_stop;
-	}
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
-		error = ENOMEM;
-		goto out_iput;
-	}
-
-	return 0;
-
- out_filestream_unmount:
-	xfs_inode_shrinker_unregister(mp);
-	xfs_filestream_unmount(mp);
- out_free_sb:
-	xfs_freesb(mp);
- out_destroy_counters:
-	xfs_icsb_destroy_counters(mp);
- out_close_devices:
-	xfs_close_devices(mp);
- out_free_fsname:
-	xfs_free_fsname(mp);
-	kfree(mp);
- out:
-	return -error;
-
- out_iput:
-	iput(root);
- out_syncd_stop:
-	xfs_syncd_stop(mp);
- out_unmount:
-	xfs_inode_shrinker_unregister(mp);
-
-	/*
-	 * Blow away any referenced inode in the filestreams cache.
-	 * This can and will cause log traffic as inodes go inactive
-	 * here.
-	 */
-	xfs_filestream_unmount(mp);
-
-	XFS_bflush(mp->m_ddev_targp);
-
-	xfs_unmountfs(mp);
-	goto out_free_sb;
-}
-
-STATIC struct dentry *
-xfs_fs_mount(
-	struct file_system_type	*fs_type,
-	int			flags,
-	const char		*dev_name,
-	void			*data)
-{
-	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
-}
-
-static const struct super_operations xfs_super_operations = {
-	.alloc_inode		= xfs_fs_alloc_inode,
-	.destroy_inode		= xfs_fs_destroy_inode,
-	.dirty_inode		= xfs_fs_dirty_inode,
-	.write_inode		= xfs_fs_write_inode,
-	.evict_inode		= xfs_fs_evict_inode,
-	.put_super		= xfs_fs_put_super,
-	.sync_fs		= xfs_fs_sync_fs,
-	.freeze_fs		= xfs_fs_freeze,
-	.unfreeze_fs		= xfs_fs_unfreeze,
-	.statfs			= xfs_fs_statfs,
-	.remount_fs		= xfs_fs_remount,
-	.show_options		= xfs_fs_show_options,
-};
-
-static struct file_system_type xfs_fs_type = {
-	.owner			= THIS_MODULE,
-	.name			= "xfs",
-	.mount			= xfs_fs_mount,
-	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
-};
-
-STATIC int __init
-xfs_init_zones(void)
-{
-
-	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
-	if (!xfs_ioend_zone)
-		goto out;
-
-	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
-						  xfs_ioend_zone);
-	if (!xfs_ioend_pool)
-		goto out_destroy_ioend_zone;
-
-	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
-						"xfs_log_ticket");
-	if (!xfs_log_ticket_zone)
-		goto out_destroy_ioend_pool;
-
-	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
-						"xfs_bmap_free_item");
-	if (!xfs_bmap_free_item_zone)
-		goto out_destroy_log_ticket_zone;
-
-	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
-						"xfs_btree_cur");
-	if (!xfs_btree_cur_zone)
-		goto out_destroy_bmap_free_item_zone;
-
-	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
-						"xfs_da_state");
-	if (!xfs_da_state_zone)
-		goto out_destroy_btree_cur_zone;
-
-	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
-	if (!xfs_dabuf_zone)
-		goto out_destroy_da_state_zone;
-
-	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
-	if (!xfs_ifork_zone)
-		goto out_destroy_dabuf_zone;
-
-	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
-	if (!xfs_trans_zone)
-		goto out_destroy_ifork_zone;
-
-	xfs_log_item_desc_zone =
-		kmem_zone_init(sizeof(struct xfs_log_item_desc),
-			       "xfs_log_item_desc");
-	if (!xfs_log_item_desc_zone)
-		goto out_destroy_trans_zone;
-
-	/*
-	 * The size of the zone allocated buf log item is the maximum
-	 * size possible under XFS.  This wastes a little bit of memory,
-	 * but it is much faster.
-	 */
-	xfs_buf_item_zone = kmem_zone_init((sizeof(xfs_buf_log_item_t) +
-				(((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) /
-				  NBWORD) * sizeof(int))), "xfs_buf_item");
-	if (!xfs_buf_item_zone)
-		goto out_destroy_log_item_desc_zone;
-
-	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
-			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
-				 sizeof(xfs_extent_t))), "xfs_efd_item");
-	if (!xfs_efd_zone)
-		goto out_destroy_buf_item_zone;
-
-	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
-			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
-				sizeof(xfs_extent_t))), "xfs_efi_item");
-	if (!xfs_efi_zone)
-		goto out_destroy_efd_zone;
-
-	xfs_inode_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
-			xfs_fs_inode_init_once);
-	if (!xfs_inode_zone)
-		goto out_destroy_efi_zone;
-
-	xfs_ili_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
-	if (!xfs_ili_zone)
-		goto out_destroy_inode_zone;
-
-	return 0;
-
- out_destroy_inode_zone:
-	kmem_zone_destroy(xfs_inode_zone);
- out_destroy_efi_zone:
-	kmem_zone_destroy(xfs_efi_zone);
- out_destroy_efd_zone:
-	kmem_zone_destroy(xfs_efd_zone);
- out_destroy_buf_item_zone:
-	kmem_zone_destroy(xfs_buf_item_zone);
- out_destroy_log_item_desc_zone:
-	kmem_zone_destroy(xfs_log_item_desc_zone);
- out_destroy_trans_zone:
-	kmem_zone_destroy(xfs_trans_zone);
- out_destroy_ifork_zone:
-	kmem_zone_destroy(xfs_ifork_zone);
- out_destroy_dabuf_zone:
-	kmem_zone_destroy(xfs_dabuf_zone);
- out_destroy_da_state_zone:
-	kmem_zone_destroy(xfs_da_state_zone);
- out_destroy_btree_cur_zone:
-	kmem_zone_destroy(xfs_btree_cur_zone);
- out_destroy_bmap_free_item_zone:
-	kmem_zone_destroy(xfs_bmap_free_item_zone);
- out_destroy_log_ticket_zone:
-	kmem_zone_destroy(xfs_log_ticket_zone);
- out_destroy_ioend_pool:
-	mempool_destroy(xfs_ioend_pool);
- out_destroy_ioend_zone:
-	kmem_zone_destroy(xfs_ioend_zone);
- out:
-	return -ENOMEM;
-}
-
-STATIC void
-xfs_destroy_zones(void)
-{
-	kmem_zone_destroy(xfs_ili_zone);
-	kmem_zone_destroy(xfs_inode_zone);
-	kmem_zone_destroy(xfs_efi_zone);
-	kmem_zone_destroy(xfs_efd_zone);
-	kmem_zone_destroy(xfs_buf_item_zone);
-	kmem_zone_destroy(xfs_log_item_desc_zone);
-	kmem_zone_destroy(xfs_trans_zone);
-	kmem_zone_destroy(xfs_ifork_zone);
-	kmem_zone_destroy(xfs_dabuf_zone);
-	kmem_zone_destroy(xfs_da_state_zone);
-	kmem_zone_destroy(xfs_btree_cur_zone);
-	kmem_zone_destroy(xfs_bmap_free_item_zone);
-	kmem_zone_destroy(xfs_log_ticket_zone);
-	mempool_destroy(xfs_ioend_pool);
-	kmem_zone_destroy(xfs_ioend_zone);
-
-}
-
-STATIC int __init
-xfs_init_workqueues(void)
-{
-	/*
-	 * max_active is set to 8 to give enough concurency to allow
-	 * multiple work operations on each CPU to run. This allows multiple
-	 * filesystems to be running sync work concurrently, and scales with
-	 * the number of CPUs in the system.
-	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
-	if (!xfs_syncd_wq)
-		goto out;
-
-	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
-	if (!xfs_ail_wq)
-		goto out_destroy_syncd;
-
-	return 0;
-
-out_destroy_syncd:
-	destroy_workqueue(xfs_syncd_wq);
-out:
-	return -ENOMEM;
-}
-
-STATIC void
-xfs_destroy_workqueues(void)
-{
-	destroy_workqueue(xfs_ail_wq);
-	destroy_workqueue(xfs_syncd_wq);
-}
-
-STATIC int __init
-init_xfs_fs(void)
-{
-	int			error;
-
-	printk(KERN_INFO XFS_VERSION_STRING " with "
-			 XFS_BUILD_OPTIONS " enabled\n");
-
-	xfs_ioend_init();
-	xfs_dir_startup();
-
-	error = xfs_init_zones();
-	if (error)
-		goto out;
-
-	error = xfs_init_workqueues();
-	if (error)
-		goto out_destroy_zones;
-
-	error = xfs_mru_cache_init();
-	if (error)
-		goto out_destroy_wq;
-
-	error = xfs_filestream_init();
-	if (error)
-		goto out_mru_cache_uninit;
-
-	error = xfs_buf_init();
-	if (error)
-		goto out_filestream_uninit;
-
-	error = xfs_init_procfs();
-	if (error)
-		goto out_buf_terminate;
-
-	error = xfs_sysctl_register();
-	if (error)
-		goto out_cleanup_procfs;
-
-	vfs_initquota();
-
-	error = register_filesystem(&xfs_fs_type);
-	if (error)
-		goto out_sysctl_unregister;
-	return 0;
-
- out_sysctl_unregister:
-	xfs_sysctl_unregister();
- out_cleanup_procfs:
-	xfs_cleanup_procfs();
- out_buf_terminate:
-	xfs_buf_terminate();
- out_filestream_uninit:
-	xfs_filestream_uninit();
- out_mru_cache_uninit:
-	xfs_mru_cache_uninit();
- out_destroy_wq:
-	xfs_destroy_workqueues();
- out_destroy_zones:
-	xfs_destroy_zones();
- out:
-	return error;
-}
-
-STATIC void __exit
-exit_xfs_fs(void)
-{
-	vfs_exitquota();
-	unregister_filesystem(&xfs_fs_type);
-	xfs_sysctl_unregister();
-	xfs_cleanup_procfs();
-	xfs_buf_terminate();
-	xfs_filestream_uninit();
-	xfs_mru_cache_uninit();
-	xfs_destroy_workqueues();
-	xfs_destroy_zones();
-}
-
-module_init(init_xfs_fs);
-module_exit(exit_xfs_fs);
-
-MODULE_AUTHOR("Silicon Graphics, Inc.");
-MODULE_DESCRIPTION(XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled");
-MODULE_LICENSE("GPL");
diff --git a/fs/xfs/linux-2.6/xfs_super.h b/fs/xfs/linux-2.6/xfs_super.h
deleted file mode 100644
index 50a3266..0000000
--- a/fs/xfs/linux-2.6/xfs_super.h
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_SUPER_H__
-#define __XFS_SUPER_H__
-
-#include <linux/exportfs.h>
-
-#ifdef CONFIG_XFS_QUOTA
-extern void xfs_qm_init(void);
-extern void xfs_qm_exit(void);
-# define vfs_initquota()	xfs_qm_init()
-# define vfs_exitquota()	xfs_qm_exit()
-#else
-# define vfs_initquota()	do { } while (0)
-# define vfs_exitquota()	do { } while (0)
-#endif
-
-#ifdef CONFIG_XFS_POSIX_ACL
-# define XFS_ACL_STRING		"ACLs, "
-# define set_posix_acl_flag(sb)	((sb)->s_flags |= MS_POSIXACL)
-#else
-# define XFS_ACL_STRING
-# define set_posix_acl_flag(sb)	do { } while (0)
-#endif
-
-#define XFS_SECURITY_STRING	"security attributes, "
-
-#ifdef CONFIG_XFS_RT
-# define XFS_REALTIME_STRING	"realtime, "
-#else
-# define XFS_REALTIME_STRING
-#endif
-
-#if XFS_BIG_BLKNOS
-# if XFS_BIG_INUMS
-#  define XFS_BIGFS_STRING	"large block/inode numbers, "
-# else
-#  define XFS_BIGFS_STRING	"large block numbers, "
-# endif
-#else
-# define XFS_BIGFS_STRING
-#endif
-
-#ifdef DEBUG
-# define XFS_DBG_STRING		"debug"
-#else
-# define XFS_DBG_STRING		"no debug"
-#endif
-
-#define XFS_VERSION_STRING	"SGI XFS"
-#define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
-				XFS_SECURITY_STRING \
-				XFS_REALTIME_STRING \
-				XFS_BIGFS_STRING \
-				XFS_DBG_STRING /* DBG must be last */
-
-struct xfs_inode;
-struct xfs_mount;
-struct xfs_buftarg;
-struct block_device;
-
-extern __uint64_t xfs_max_file_offset(unsigned int);
-
-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
-
-extern const struct export_operations xfs_export_operations;
-extern const struct xattr_handler *xfs_xattr_handlers[];
-extern const struct quotactl_ops xfs_quotactl_operations;
-
-#define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
-
-#endif	/* __XFS_SUPER_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
deleted file mode 100644
index 5cc158e..0000000
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ /dev/null
@@ -1,1082 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_dinode.h"
-#include "xfs_error.h"
-#include "xfs_filestream.h"
-#include "xfs_vnodeops.h"
-#include "xfs_inode_item.h"
-#include "xfs_quota.h"
-#include "xfs_trace.h"
-#include "xfs_fsops.h"
-
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-
-struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
-
-/*
- * The inode lookup is done in batches to keep the amount of lock traffic and
- * radix tree lookups to a minimum. The batch size is a trade off between
- * lookup reduction and stack usage. This is in the reclaim path, so we can't
- * be too greedy.
- */
-#define XFS_LOOKUP_BATCH	32
-
-STATIC int
-xfs_inode_ag_walk_grab(
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(rcu_read_lock_held());
-
-	/*
-	 * check for stale RCU freed inode
-	 *
-	 * If the inode has been reallocated, it doesn't matter if it's not in
-	 * the AG we are walking - we are walking for writeback, so if it
-	 * passes all the "valid inode" checks and is dirty, then we'll write
-	 * it back anyway.  If it has been reallocated and still being
-	 * initialised, the XFS_INEW check below will catch it.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
-		goto out_unlock_noent;
-
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
-		goto out_unlock_noent;
-	spin_unlock(&ip->i_flags_lock);
-
-	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return EFSCORRUPTED;
-
-	/* If we can't grab the inode, it must on it's way to reclaim. */
-	if (!igrab(inode))
-		return ENOENT;
-
-	if (is_bad_inode(inode)) {
-		IRELE(ip);
-		return ENOENT;
-	}
-
-	/* inode is valid */
-	return 0;
-
-out_unlock_noent:
-	spin_unlock(&ip->i_flags_lock);
-	return ENOENT;
-}
-
-STATIC int
-xfs_inode_ag_walk(
-	struct xfs_mount	*mp,
-	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags),
-	int			flags)
-{
-	uint32_t		first_index;
-	int			last_error = 0;
-	int			skipped;
-	int			done;
-	int			nr_found;
-
-restart:
-	done = 0;
-	skipped = 0;
-	first_index = 0;
-	nr_found = 0;
-	do {
-		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-		int		error = 0;
-		int		i;
-
-		rcu_read_lock();
-		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		if (!nr_found) {
-			rcu_read_unlock();
-			break;
-		}
-
-		/*
-		 * Grab the inodes before we drop the lock. if we found
-		 * nothing, nr == 0 and the loop will be skipped.
-		 */
-		for (i = 0; i < nr_found; i++) {
-			struct xfs_inode *ip = batch[i];
-
-			if (done || xfs_inode_ag_walk_grab(ip))
-				batch[i] = NULL;
-
-			/*
-			 * Update the index for the next lookup. Catch
-			 * overflows into the next AG range which can occur if
-			 * we have inodes in the last block of the AG and we
-			 * are currently pointing to the last inode.
-			 *
-			 * Because we may see inodes that are from the wrong AG
-			 * due to RCU freeing and reallocation, only update the
-			 * index if it lies in this AG. It was a race that lead
-			 * us to see this inode, so another lookup from the
-			 * same index will not find it again.
-			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
-				continue;
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = 1;
-		}
-
-		/* unlock now we've grabbed the inodes. */
-		rcu_read_unlock();
-
-		for (i = 0; i < nr_found; i++) {
-			if (!batch[i])
-				continue;
-			error = execute(batch[i], pag, flags);
-			IRELE(batch[i]);
-			if (error == EAGAIN) {
-				skipped++;
-				continue;
-			}
-			if (error && last_error != EFSCORRUPTED)
-				last_error = error;
-		}
-
-		/* bail out if the filesystem is corrupted.  */
-		if (error == EFSCORRUPTED)
-			break;
-
-	} while (nr_found && !done);
-
-	if (skipped) {
-		delay(1);
-		goto restart;
-	}
-	return last_error;
-}
-
-int
-xfs_inode_ag_iterator(
-	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags),
-	int			flags)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_perag_get(mp, ag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == EFSCORRUPTED)
-				break;
-		}
-	}
-	return XFS_ERROR(last_error);
-}
-
-STATIC int
-xfs_sync_inode_data(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct address_space *mapping = inode->i_mapping;
-	int			error = 0;
-
-	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
-		goto out_wait;
-
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (flags & SYNC_TRYLOCK)
-			goto out_wait;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-
-	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
-				0 : XBF_ASYNC, FI_NONE);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
- out_wait:
-	if (flags & SYNC_WAIT)
-		xfs_ioend_wait(ip);
-	return error;
-}
-
-STATIC int
-xfs_sync_inode_attr(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			flags)
-{
-	int			error = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_inode_clean(ip))
-		goto out_unlock;
-	if (!xfs_iflock_nowait(ip)) {
-		if (!(flags & SYNC_WAIT))
-			goto out_unlock;
-		xfs_iflock(ip);
-	}
-
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		goto out_unlock;
-	}
-
-	error = xfs_iflush(ip, flags);
-
-	/*
-	 * We don't want to try again on non-blocking flushes that can't run
-	 * again immediately. If an inode really must be written, then that's
-	 * what the SYNC_WAIT flag is for.
-	 */
-	if (error == EAGAIN) {
-		ASSERT(!(flags & SYNC_WAIT));
-		error = 0;
-	}
-
- out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
-}
-
-/*
- * Write out pagecache data for the whole filesystem.
- */
-STATIC int
-xfs_sync_data(
-	struct xfs_mount	*mp,
-	int			flags)
-{
-	int			error;
-
-	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
-
-	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
-	if (error)
-		return XFS_ERROR(error);
-
-	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
-	return 0;
-}
-
-/*
- * Write out inode metadata (attributes) for the whole filesystem.
- */
-STATIC int
-xfs_sync_attr(
-	struct xfs_mount	*mp,
-	int			flags)
-{
-	ASSERT((flags & ~SYNC_WAIT) == 0);
-
-	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags);
-}
-
-STATIC int
-xfs_sync_fsdata(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buf		*bp;
-
-	/*
-	 * If the buffer is pinned then push on the log so we won't get stuck
-	 * waiting in the write for someone, maybe ourselves, to flush the log.
-	 *
-	 * Even though we just pushed the log above, we did not have the
-	 * superblock buffer locked at that point so it can become pinned in
-	 * between there and here.
-	 */
-	bp = xfs_getsb(mp, 0);
-	if (XFS_BUF_ISPINNED(bp))
-		xfs_log_force(mp, 0);
-
-	return xfs_bwrite(mp, bp);
-}
-
-/*
- * When remounting a filesystem read-only or freezing the filesystem, we have
- * two phases to execute. This first phase is syncing the data before we
- * quiesce the filesystem, and the second is flushing all the inodes out after
- * we've waited for all the transactions created by the first phase to
- * complete. The second phase ensures that the inodes are written to their
- * location on disk rather than just existing in transactions in the log. This
- * means after a quiesce there is no log replay required to write the inodes to
- * disk (this is the main difference between a sync and a quiesce).
- */
-/*
- * First stage of freeze - no writers will make progress now we are here,
- * so we flush delwri and delalloc buffers here, then wait for all I/O to
- * complete.  Data is frozen at that point. Metadata is not frozen,
- * transactions can still occur here so don't bother flushing the buftarg
- * because it'll just get dirty again.
- */
-int
-xfs_quiesce_data(
-	struct xfs_mount	*mp)
-{
-	int			error, error2 = 0;
-
-	xfs_qm_sync(mp, SYNC_TRYLOCK);
-	xfs_qm_sync(mp, SYNC_WAIT);
-
-	/* force out the newly dirtied log buffers */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp);
-
-	/* make sure all delwri buffers are written out */
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
-	/* mark the log as covered if needed */
-	if (xfs_log_need_covered(mp))
-		error2 = xfs_fs_log_dummy(mp);
-
-	/* flush data-only devices */
-	if (mp->m_rtdev_targp)
-		XFS_bflush(mp->m_rtdev_targp);
-
-	return error ? error : error2;
-}
-
-STATIC void
-xfs_quiesce_fs(
-	struct xfs_mount	*mp)
-{
-	int	count = 0, pincount;
-
-	xfs_reclaim_inodes(mp, 0);
-	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-
-	/*
-	 * This loop must run at least twice.  The first instance of the loop
-	 * will flush most meta data but that will generate more meta data
-	 * (typically directory updates).  Which then must be flushed and
-	 * logged before we can write the unmount record. We also so sync
-	 * reclaim of inodes to catch any that the above delwri flush skipped.
-	 */
-	do {
-		xfs_reclaim_inodes(mp, SYNC_WAIT);
-		xfs_sync_attr(mp, SYNC_WAIT);
-		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-		if (!pincount) {
-			delay(50);
-			count++;
-		}
-	} while (count < 2);
-}
-
-/*
- * Second stage of a quiesce. The data is already synced, now we have to take
- * care of the metadata. New transactions are already blocked, so we need to
- * wait for any remaining transactions to drain out before proceeding.
- */
-void
-xfs_quiesce_attr(
-	struct xfs_mount	*mp)
-{
-	int	error = 0;
-
-	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
-
-	/* flush inodes and push all remaining buffers out to disk */
-	xfs_quiesce_fs(mp);
-
-	/*
-	 * Just warn here till VFS can correctly support
-	 * read-only remount without racing.
-	 */
-	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
-
-	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp);
-	if (error)
-		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
-				"Frozen image may not be consistent.");
-	xfs_log_unmount_write(mp);
-	xfs_unmountfs_writesb(mp);
-}
-
-static void
-xfs_syncd_queue_sync(
-	struct xfs_mount        *mp)
-{
-	queue_delayed_work(xfs_syncd_wq, &mp->m_sync_work,
-				msecs_to_jiffies(xfs_syncd_centisecs * 10));
-}
-
-/*
- * Every sync period we need to unpin all items, reclaim inodes and sync
- * disk quotas.  We might need to cover the log to indicate that the
- * filesystem is idle and not frozen.
- */
-STATIC void
-xfs_sync_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_sync_work);
-	int		error;
-
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		/* dgc: errors ignored here */
-		if (mp->m_super->s_frozen == SB_UNFROZEN &&
-		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
-		else
-			xfs_log_force(mp, 0);
-		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
-	}
-
-	/* queue us up again */
-	xfs_syncd_queue_sync(mp);
-}
-
-/*
- * Queue a new inode reclaim pass if there are reclaimable inodes and there
- * isn't a reclaim pass already in progress. By default it runs every 5s based
- * on the xfs syncd work default of 30s. Perhaps this should have it's own
- * tunable, but that can be done if this method proves to be ineffective or too
- * aggressive.
- */
-static void
-xfs_syncd_queue_reclaim(
-	struct xfs_mount        *mp)
-{
-
-	/*
-	 * We can have inodes enter reclaim after we've shut down the syncd
-	 * workqueue during unmount, so don't allow reclaim work to be queued
-	 * during unmount.
-	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE))
-		return;
-
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
-		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
-			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
-	}
-	rcu_read_unlock();
-}
-
-/*
- * This is a fast pass over the inode cache to try to get reclaim moving on as
- * many inodes as possible in a short period of time. It kicks itself every few
- * seconds, as well as being kicked by the inode cache shrinker when memory
- * goes low. It scans as quickly as possible avoiding locked inodes or those
- * already being flushed, and once done schedules a future pass.
- */
-STATIC void
-xfs_reclaim_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_reclaim_work);
-
-	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
-	xfs_syncd_queue_reclaim(mp);
-}
-
-/*
- * Flush delayed allocate data, attempting to free up reserved space
- * from existing allocations.  At this point a new allocation attempt
- * has failed with ENOSPC and we are in the process of scratching our
- * heads, looking about for more room.
- *
- * Queue a new data flush if there isn't one already in progress and
- * wait for completion of the flush. This means that we only ever have one
- * inode flush in progress no matter how many ENOSPC events are occurring and
- * so will prevent the system from bogging down due to every concurrent
- * ENOSPC event scanning all the active inodes in the system for writeback.
- */
-void
-xfs_flush_inodes(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	queue_work(xfs_syncd_wq, &mp->m_flush_work);
-	flush_work_sync(&mp->m_flush_work);
-}
-
-STATIC void
-xfs_flush_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(work,
-					struct xfs_mount, m_flush_work);
-
-	xfs_sync_data(mp, SYNC_TRYLOCK);
-	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
-}
-
-int
-xfs_syncd_init(
-	struct xfs_mount	*mp)
-{
-	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
-	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
-	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-
-	xfs_syncd_queue_sync(mp);
-	xfs_syncd_queue_reclaim(mp);
-
-	return 0;
-}
-
-void
-xfs_syncd_stop(
-	struct xfs_mount	*mp)
-{
-	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	cancel_work_sync(&mp->m_flush_work);
-}
-
-void
-__xfs_inode_set_reclaim_tag(
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip)
-{
-	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			   XFS_ICI_RECLAIM_TAG);
-
-	if (!pag->pag_ici_reclaimable) {
-		/* propagate the reclaim tag up into the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
-				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				XFS_ICI_RECLAIM_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-
-		/* schedule periodic background inode reclaim */
-		xfs_syncd_queue_reclaim(ip->i_mount);
-
-		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
-							-1, _RET_IP_);
-	}
-	pag->pag_ici_reclaimable++;
-}
-
-/*
- * We set the inode flag atomically with the radix tree tag.
- * Once we get tag lookups on the radix tree, this inode flag
- * can go away.
- */
-void
-xfs_inode_set_reclaim_tag(
-	xfs_inode_t	*ip)
-{
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	spin_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	__xfs_inode_set_reclaim_tag(pag, ip);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-	spin_unlock(&ip->i_flags_lock);
-	spin_unlock(&pag->pag_ici_lock);
-	xfs_perag_put(pag);
-}
-
-STATIC void
-__xfs_inode_clear_reclaim(
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
-{
-	pag->pag_ici_reclaimable--;
-	if (!pag->pag_ici_reclaimable) {
-		/* clear the reclaim tag from the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
-				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				XFS_ICI_RECLAIM_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-		trace_xfs_perag_clear_reclaim(ip->i_mount, pag->pag_agno,
-							-1, _RET_IP_);
-	}
-}
-
-void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_inode_clear_reclaim(pag, ip);
-}
-
-/*
- * Grab the inode for reclaim exclusively.
- * Return 0 if we grabbed it, non-zero otherwise.
- */
-STATIC int
-xfs_reclaim_inode_grab(
-	struct xfs_inode	*ip,
-	int			flags)
-{
-	ASSERT(rcu_read_lock_held());
-
-	/* quick check for stale RCU freed inode */
-	if (!ip->i_ino)
-		return 1;
-
-	/*
-	 * do some unlocked checks first to avoid unnecessary lock traffic.
-	 * The first is a flush lock check, the second is a already in reclaim
-	 * check. Only do these checks if we are not going to block on locks.
-	 */
-	if ((flags & SYNC_TRYLOCK) &&
-	    (!ip->i_flush.done || __xfs_iflags_test(ip, XFS_IRECLAIM))) {
-		return 1;
-	}
-
-	/*
-	 * The radix tree lock here protects a thread in xfs_iget from racing
-	 * with us starting reclaim on the inode.  Once we have the
-	 * XFS_IRECLAIM flag set it will not touch us.
-	 *
-	 * Due to RCU lookup, we may find inodes that have been freed and only
-	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
-	 * aren't candidates for reclaim at all, so we must check the
-	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		/* not a reclaim candidate. */
-		spin_unlock(&ip->i_flags_lock);
-		return 1;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	return 0;
-}
-
-/*
- * Inodes in different states need to be treated differently, and the return
- * value of xfs_iflush is not sufficient to get this right. The following table
- * lists the inode states and the reclaim actions necessary for non-blocking
- * reclaim:
- *
- *
- *	inode state	     iflush ret		required action
- *      ---------------      ----------         ---------------
- *	bad			-		reclaim
- *	shutdown		EIO		unpin and reclaim
- *	clean, unpinned		0		reclaim
- *	stale, unpinned		0		reclaim
- *	clean, pinned(*)	0		requeue
- *	stale, pinned		EAGAIN		requeue
- *	dirty, delwri ok	0		requeue
- *	dirty, delwri blocked	EAGAIN		requeue
- *	dirty, sync flush	0		reclaim
- *
- * (*) dgc: I don't think the clean, pinned state is possible but it gets
- * handled anyway given the order of checks implemented.
- *
- * As can be seen from the table, the return value of xfs_iflush() is not
- * sufficient to correctly decide the reclaim action here. The checks in
- * xfs_iflush() might look like duplicates, but they are not.
- *
- * Also, because we get the flush lock first, we know that any inode that has
- * been flushed delwri has had the flush completed by the time we check that
- * the inode is clean. The clean inode check needs to be done before flushing
- * the inode delwri otherwise we would loop forever requeuing clean inodes as
- * we cannot tell apart a successful delwri flush and a clean inode from the
- * return value of xfs_iflush().
- *
- * Note that because the inode is flushed delayed write by background
- * writeback, the flush lock may already be held here and waiting on it can
- * result in very long latencies. Hence for sync reclaims, where we wait on the
- * flush lock, the caller should push out delayed write inodes first before
- * trying to reclaim them to minimise the amount of time spent waiting. For
- * background relaim, we just requeue the inode for the next pass.
- *
- * Hence the order of actions after gaining the locks should be:
- *	bad		=> reclaim
- *	shutdown	=> unpin and reclaim
- *	pinned, delwri	=> requeue
- *	pinned, sync	=> unpin
- *	stale		=> reclaim
- *	clean		=> reclaim
- *	dirty, delwri	=> flush and requeue
- *	dirty, sync	=> flush, wait and reclaim
- */
-STATIC int
-xfs_reclaim_inode(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			sync_mode)
-{
-	int	error;
-
-restart:
-	error = 0;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (!xfs_iflock_nowait(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
-			goto out;
-		xfs_iflock(ip);
-	}
-
-	if (is_bad_inode(VFS_I(ip)))
-		goto reclaim;
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		xfs_iunpin_wait(ip);
-		goto reclaim;
-	}
-	if (xfs_ipincount(ip)) {
-		if (!(sync_mode & SYNC_WAIT)) {
-			xfs_ifunlock(ip);
-			goto out;
-		}
-		xfs_iunpin_wait(ip);
-	}
-	if (xfs_iflags_test(ip, XFS_ISTALE))
-		goto reclaim;
-	if (xfs_inode_clean(ip))
-		goto reclaim;
-
-	/*
-	 * Now we have an inode that needs flushing.
-	 *
-	 * We do a nonblocking flush here even if we are doing a SYNC_WAIT
-	 * reclaim as we can deadlock with inode cluster removal.
-	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
-	 * ip->i_lock, and we are doing the exact opposite here. As a result,
-	 * doing a blocking xfs_itobp() to get the cluster buffer will result
-	 * in an ABBA deadlock with xfs_ifree_cluster().
-	 *
-	 * As xfs_ifree_cluser() must gather all inodes that are active in the
-	 * cache to mark them stale, if we hit this case we don't actually want
-	 * to do IO here - we want the inode marked stale so we can simply
-	 * reclaim it. Hence if we get an EAGAIN error on a SYNC_WAIT flush,
-	 * just unlock the inode, back off and try again. Hopefully the next
-	 * pass through will see the stale flag set on the inode.
-	 */
-	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
-	if (sync_mode & SYNC_WAIT) {
-		if (error == EAGAIN) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			/* backoff longer than in xfs_ifree_cluster */
-			delay(2);
-			goto restart;
-		}
-		xfs_iflock(ip);
-		goto reclaim;
-	}
-
-	/*
-	 * When we have to flush an inode but don't have SYNC_WAIT set, we
-	 * flush the inode out using a delwri buffer and wait for the next
-	 * call into reclaim to find it in a clean state instead of waiting for
-	 * it now. We also don't return errors here - if the error is transient
-	 * then the next reclaim pass will flush the inode, and if the error
-	 * is permanent then the next sync reclaim will reclaim the inode and
-	 * pass on the error.
-	 */
-	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		xfs_warn(ip->i_mount,
-			"inode 0x%llx background reclaim flush failed with %d",
-			(long long)ip->i_ino, error);
-	}
-out:
-	xfs_iflags_clear(ip, XFS_IRECLAIM);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	/*
-	 * We could return EAGAIN here to make reclaim rescan the inode tree in
-	 * a short while. However, this just burns CPU time scanning the tree
-	 * waiting for IO to complete and xfssyncd never goes back to the idle
-	 * state. Instead, return 0 to let the next scheduled background reclaim
-	 * attempt to reclaim the inode again.
-	 */
-	return 0;
-
-reclaim:
-	xfs_ifunlock(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	XFS_STATS_INC(xs_ig_reclaims);
-	/*
-	 * Remove the inode from the per-AG radix tree.
-	 *
-	 * Because radix_tree_delete won't complain even if the item was never
-	 * added to the tree assert that it's been there before to catch
-	 * problems with the inode life time early on.
-	 */
-	spin_lock(&pag->pag_ici_lock);
-	if (!radix_tree_delete(&pag->pag_ici_root,
-				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
-		ASSERT(0);
-	__xfs_inode_clear_reclaim(pag, ip);
-	spin_unlock(&pag->pag_ici_lock);
-
-	/*
-	 * Here we do an (almost) spurious inode lock in order to coordinate
-	 * with inode cache radix tree lookups.  This is because the lookup
-	 * can reference the inodes in the cache without taking references.
-	 *
-	 * We make that OK here by ensuring that we wait until the inode is
-	 * unlocked after the lookup before we go ahead and free it.  We get
-	 * both the ilock and the iolock because the code may need to drop the
-	 * ilock one but will still hold the iolock.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	xfs_inode_free(ip);
-	return error;
-
-}
-
-/*
- * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
- * corrupted, we still want to try to reclaim all the inodes. If we don't,
- * then a shut down during filesystem unmount reclaim walk leak all the
- * unreclaimed inodes.
- */
-int
-xfs_reclaim_inodes_ag(
-	struct xfs_mount	*mp,
-	int			flags,
-	int			*nr_to_scan)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-	int			trylock = flags & SYNC_TRYLOCK;
-	int			skipped;
-
-restart:
-	ag = 0;
-	skipped = 0;
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
-		unsigned long	first_index = 0;
-		int		done = 0;
-		int		nr_found = 0;
-
-		ag = pag->pag_agno + 1;
-
-		if (trylock) {
-			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
-				skipped++;
-				xfs_perag_put(pag);
-				continue;
-			}
-			first_index = pag->pag_ici_reclaim_cursor;
-		} else
-			mutex_lock(&pag->pag_ici_reclaim_lock);
-
-		do {
-			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-			int	i;
-
-			rcu_read_lock();
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH,
-					XFS_ICI_RECLAIM_TAG);
-			if (!nr_found) {
-				done = 1;
-				rcu_read_unlock();
-				break;
-			}
-
-			/*
-			 * Grab the inodes before we drop the lock. if we found
-			 * nothing, nr == 0 and the loop will be skipped.
-			 */
-			for (i = 0; i < nr_found; i++) {
-				struct xfs_inode *ip = batch[i];
-
-				if (done || xfs_reclaim_inode_grab(ip, flags))
-					batch[i] = NULL;
-
-				/*
-				 * Update the index for the next lookup. Catch
-				 * overflows into the next AG range which can
-				 * occur if we have inodes in the last block of
-				 * the AG and we are currently pointing to the
-				 * last inode.
-				 *
-				 * Because we may see inodes that are from the
-				 * wrong AG due to RCU freeing and
-				 * reallocation, only update the index if it
-				 * lies in this AG. It was a race that lead us
-				 * to see this inode, so another lookup from
-				 * the same index will not find it again.
-				 */
-				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
-								pag->pag_agno)
-					continue;
-				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-					done = 1;
-			}
-
-			/* unlock now we've grabbed the inodes. */
-			rcu_read_unlock();
-
-			for (i = 0; i < nr_found; i++) {
-				if (!batch[i])
-					continue;
-				error = xfs_reclaim_inode(batch[i], pag, flags);
-				if (error && last_error != EFSCORRUPTED)
-					last_error = error;
-			}
-
-			*nr_to_scan -= XFS_LOOKUP_BATCH;
-
-		} while (nr_found && !done && *nr_to_scan > 0);
-
-		if (trylock && !done)
-			pag->pag_ici_reclaim_cursor = first_index;
-		else
-			pag->pag_ici_reclaim_cursor = 0;
-		mutex_unlock(&pag->pag_ici_reclaim_lock);
-		xfs_perag_put(pag);
-	}
-
-	/*
-	 * if we skipped any AG, and we still have scan count remaining, do
-	 * another pass this time using blocking reclaim semantics (i.e
-	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
-	 * ensure that when we get more reclaimers than AGs we block rather
-	 * than spin trying to execute reclaim.
-	 */
-	if (trylock && skipped && *nr_to_scan > 0) {
-		trylock = 0;
-		goto restart;
-	}
-	return XFS_ERROR(last_error);
-}
-
-int
-xfs_reclaim_inodes(
-	xfs_mount_t	*mp,
-	int		mode)
-{
-	int		nr_to_scan = INT_MAX;
-
-	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
-}
-
-/*
- * Inode cache shrinker.
- *
- * When called we make sure that there is a background (fast) inode reclaim in
- * progress, while we will throttle the speed of reclaim via doiing synchronous
- * reclaim of inodes. That means if we come across dirty inodes, we wait for
- * them to be cleaned, which we hope will not be very long due to the
- * background walker having already kicked the IO off on those dirty inodes.
- */
-static int
-xfs_reclaim_inode_shrink(
-	struct shrinker	*shrink,
-	struct shrink_control *sc)
-{
-	struct xfs_mount *mp;
-	struct xfs_perag *pag;
-	xfs_agnumber_t	ag;
-	int		reclaimable;
-	int nr_to_scan = sc->nr_to_scan;
-	gfp_t gfp_mask = sc->gfp_mask;
-
-	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
-	if (nr_to_scan) {
-		/* kick background reclaimer and push the AIL */
-		xfs_syncd_queue_reclaim(mp);
-		xfs_ail_push_all(mp->m_ail);
-
-		if (!(gfp_mask & __GFP_FS))
-			return -1;
-
-		xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
-					&nr_to_scan);
-		/* terminate if we don't exhaust the scan */
-		if (nr_to_scan > 0)
-			return -1;
-       }
-
-	reclaimable = 0;
-	ag = 0;
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
-		ag = pag->pag_agno + 1;
-		reclaimable += pag->pag_ici_reclaimable;
-		xfs_perag_put(pag);
-	}
-	return reclaimable;
-}
-
-void
-xfs_inode_shrinker_register(
-	struct xfs_mount	*mp)
-{
-	mp->m_inode_shrink.shrink = xfs_reclaim_inode_shrink;
-	mp->m_inode_shrink.seeks = DEFAULT_SEEKS;
-	register_shrinker(&mp->m_inode_shrink);
-}
-
-void
-xfs_inode_shrinker_unregister(
-	struct xfs_mount	*mp)
-{
-	unregister_shrinker(&mp->m_inode_shrink);
-}
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
deleted file mode 100644
index e914fd6..0000000
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#ifndef XFS_SYNC_H
-#define XFS_SYNC_H 1
-
-struct xfs_mount;
-struct xfs_perag;
-
-#define SYNC_WAIT		0x0001	/* wait for i/o to complete */
-#define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
-
-extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
-
-int xfs_syncd_init(struct xfs_mount *mp);
-void xfs_syncd_stop(struct xfs_mount *mp);
-
-int xfs_quiesce_data(struct xfs_mount *mp);
-void xfs_quiesce_attr(struct xfs_mount *mp);
-
-void xfs_flush_inodes(struct xfs_inode *ip);
-
-int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
-
-void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
-void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
-				struct xfs_inode *ip);
-
-int xfs_sync_inode_grab(struct xfs_inode *ip);
-int xfs_inode_ag_iterator(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags);
-
-void xfs_inode_shrinker_register(struct xfs_mount *mp);
-void xfs_inode_shrinker_unregister(struct xfs_mount *mp);
-
-#endif
diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
deleted file mode 100644
index ee2d2ad..0000000
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- * Copyright (c) 2001-2005 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include <linux/sysctl.h>
-#include <linux/proc_fs.h>
-#include "xfs_error.h"
-
-static struct ctl_table_header *xfs_table_header;
-
-#ifdef CONFIG_PROC_FS
-STATIC int
-xfs_stats_clear_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
-{
-	int		c, ret, *valp = ctl->data;
-	__uint32_t	vn_active;
-
-	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
-
-	if (!ret && write && *valp) {
-		xfs_notice(NULL, "Clearing xfsstats");
-		for_each_possible_cpu(c) {
-			preempt_disable();
-			/* save vn_active, it's a universal truth! */
-			vn_active = per_cpu(xfsstats, c).vn_active;
-			memset(&per_cpu(xfsstats, c), 0,
-			       sizeof(struct xfsstats));
-			per_cpu(xfsstats, c).vn_active = vn_active;
-			preempt_enable();
-		}
-		xfs_stats_clear = 0;
-	}
-
-	return ret;
-}
-
-STATIC int
-xfs_panic_mask_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
-{
-	int		ret, *valp = ctl->data;
-
-	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
-	if (!ret && write) {
-		xfs_panic_mask = *valp;
-#ifdef DEBUG
-		xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
-#endif
-	}
-	return ret;
-}
-#endif /* CONFIG_PROC_FS */
-
-static ctl_table xfs_table[] = {
-	{
-		.procname	= "irix_sgid_inherit",
-		.data		= &xfs_params.sgid_inherit.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.sgid_inherit.min,
-		.extra2		= &xfs_params.sgid_inherit.max
-	},
-	{
-		.procname	= "irix_symlink_mode",
-		.data		= &xfs_params.symlink_mode.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.symlink_mode.min,
-		.extra2		= &xfs_params.symlink_mode.max
-	},
-	{
-		.procname	= "panic_mask",
-		.data		= &xfs_params.panic_mask.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= xfs_panic_mask_proc_handler,
-		.extra1		= &xfs_params.panic_mask.min,
-		.extra2		= &xfs_params.panic_mask.max
-	},
-
-	{
-		.procname	= "error_level",
-		.data		= &xfs_params.error_level.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.error_level.min,
-		.extra2		= &xfs_params.error_level.max
-	},
-	{
-		.procname	= "xfssyncd_centisecs",
-		.data		= &xfs_params.syncd_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.syncd_timer.min,
-		.extra2		= &xfs_params.syncd_timer.max
-	},
-	{
-		.procname	= "inherit_sync",
-		.data		= &xfs_params.inherit_sync.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.inherit_sync.min,
-		.extra2		= &xfs_params.inherit_sync.max
-	},
-	{
-		.procname	= "inherit_nodump",
-		.data		= &xfs_params.inherit_nodump.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.inherit_nodump.min,
-		.extra2		= &xfs_params.inherit_nodump.max
-	},
-	{
-		.procname	= "inherit_noatime",
-		.data		= &xfs_params.inherit_noatim.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.inherit_noatim.min,
-		.extra2		= &xfs_params.inherit_noatim.max
-	},
-	{
-		.procname	= "xfsbufd_centisecs",
-		.data		= &xfs_params.xfs_buf_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_timer.min,
-		.extra2		= &xfs_params.xfs_buf_timer.max
-	},
-	{
-		.procname	= "age_buffer_centisecs",
-		.data		= &xfs_params.xfs_buf_age.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_age.min,
-		.extra2		= &xfs_params.xfs_buf_age.max
-	},
-	{
-		.procname	= "inherit_nosymlinks",
-		.data		= &xfs_params.inherit_nosym.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.inherit_nosym.min,
-		.extra2		= &xfs_params.inherit_nosym.max
-	},
-	{
-		.procname	= "rotorstep",
-		.data		= &xfs_params.rotorstep.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.rotorstep.min,
-		.extra2		= &xfs_params.rotorstep.max
-	},
-	{
-		.procname	= "inherit_nodefrag",
-		.data		= &xfs_params.inherit_nodfrg.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.inherit_nodfrg.min,
-		.extra2		= &xfs_params.inherit_nodfrg.max
-	},
-	{
-		.procname	= "filestream_centisecs",
-		.data		= &xfs_params.fstrm_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.fstrm_timer.min,
-		.extra2		= &xfs_params.fstrm_timer.max,
-	},
-	/* please keep this the last entry */
-#ifdef CONFIG_PROC_FS
-	{
-		.procname	= "stats_clear",
-		.data		= &xfs_params.stats_clear.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= xfs_stats_clear_proc_handler,
-		.extra1		= &xfs_params.stats_clear.min,
-		.extra2		= &xfs_params.stats_clear.max
-	},
-#endif /* CONFIG_PROC_FS */
-
-	{}
-};
-
-static ctl_table xfs_dir_table[] = {
-	{
-		.procname	= "xfs",
-		.mode		= 0555,
-		.child		= xfs_table
-	},
-	{}
-};
-
-static ctl_table xfs_root_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= xfs_dir_table
-	},
-	{}
-};
-
-int
-xfs_sysctl_register(void)
-{
-	xfs_table_header = register_sysctl_table(xfs_root_table);
-	if (!xfs_table_header)
-		return -ENOMEM;
-	return 0;
-}
-
-void
-xfs_sysctl_unregister(void)
-{
-	unregister_sysctl_table(xfs_table_header);
-}
diff --git a/fs/xfs/linux-2.6/xfs_sysctl.h b/fs/xfs/linux-2.6/xfs_sysctl.h
deleted file mode 100644
index b9937d4..0000000
--- a/fs/xfs/linux-2.6/xfs_sysctl.h
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * Copyright (c) 2001-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_SYSCTL_H__
-#define __XFS_SYSCTL_H__
-
-#include <linux/sysctl.h>
-
-/*
- * Tunable xfs parameters
- */
-
-typedef struct xfs_sysctl_val {
-	int min;
-	int val;
-	int max;
-} xfs_sysctl_val_t;
-
-typedef struct xfs_param {
-	xfs_sysctl_val_t sgid_inherit;	/* Inherit S_ISGID if process' GID is
-					 * not a member of parent dir GID. */
-	xfs_sysctl_val_t symlink_mode;	/* Link creat mode affected by umask */
-	xfs_sysctl_val_t panic_mask;	/* bitmask to cause panic on errors. */
-	xfs_sysctl_val_t error_level;	/* Degree of reporting for problems  */
-	xfs_sysctl_val_t syncd_timer;	/* Interval between xfssyncd wakeups */
-	xfs_sysctl_val_t stats_clear;	/* Reset all XFS statistics to zero. */
-	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
-	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
-	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
-	xfs_sysctl_val_t xfs_buf_timer;	/* Interval between xfsbufd wakeups. */
-	xfs_sysctl_val_t xfs_buf_age;	/* Metadata buffer age before flush. */
-	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
-	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
-	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
-	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
-} xfs_param_t;
-
-/*
- * xfs_error_level:
- *
- * How much error reporting will be done when internal problems are
- * encountered.  These problems normally return an EFSCORRUPTED to their
- * caller, with no other information reported.
- *
- * 0	No error reports
- * 1	Report EFSCORRUPTED errors that will cause a filesystem shutdown
- * 5	Report all EFSCORRUPTED errors (all of the above errors, plus any
- *	additional errors that are known to not cause shutdowns)
- *
- * xfs_panic_mask bit 0x8 turns the error reports into panics
- */
-
-enum {
-	/* XFS_REFCACHE_SIZE = 1 */
-	/* XFS_REFCACHE_PURGE = 2 */
-	/* XFS_RESTRICT_CHOWN = 3 */
-	XFS_SGID_INHERIT = 4,
-	XFS_SYMLINK_MODE = 5,
-	XFS_PANIC_MASK = 6,
-	XFS_ERRLEVEL = 7,
-	XFS_SYNCD_TIMER = 8,
-	/* XFS_PROBE_DMAPI = 9 */
-	/* XFS_PROBE_IOOPS = 10 */
-	/* XFS_PROBE_QUOTA = 11 */
-	XFS_STATS_CLEAR = 12,
-	XFS_INHERIT_SYNC = 13,
-	XFS_INHERIT_NODUMP = 14,
-	XFS_INHERIT_NOATIME = 15,
-	XFS_BUF_TIMER = 16,
-	XFS_BUF_AGE = 17,
-	/* XFS_IO_BYPASS = 18 */
-	XFS_INHERIT_NOSYM = 19,
-	XFS_ROTORSTEP = 20,
-	XFS_INHERIT_NODFRG = 21,
-	XFS_FILESTREAM_TIMER = 22,
-};
-
-extern xfs_param_t	xfs_params;
-
-#ifdef CONFIG_SYSCTL
-extern int xfs_sysctl_register(void);
-extern void xfs_sysctl_unregister(void);
-#else
-# define xfs_sysctl_register()		(0)
-# define xfs_sysctl_unregister()	do { } while (0)
-#endif /* CONFIG_SYSCTL */
-
-#endif /* __XFS_SYSCTL_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
deleted file mode 100644
index 88d25d4..0000000
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (c) 2009, Christoph Hellwig
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_mount.h"
-#include "xfs_ialloc.h"
-#include "xfs_itable.h"
-#include "xfs_alloc.h"
-#include "xfs_bmap.h"
-#include "xfs_attr.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_log_priv.h"
-#include "xfs_buf_item.h"
-#include "xfs_quota.h"
-#include "xfs_iomap.h"
-#include "xfs_aops.h"
-#include "quota/xfs_dquot_item.h"
-#include "quota/xfs_dquot.h"
-#include "xfs_log_recover.h"
-#include "xfs_inode_item.h"
-
-/*
- * We include this last to have the helpers above available for the trace
- * event implementations.
- */
-#define CREATE_TRACE_POINTS
-#include "xfs_trace.h"
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
deleted file mode 100644
index fda0708..0000000
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ /dev/null
@@ -1,1746 +0,0 @@
-/*
- * Copyright (c) 2009, Christoph Hellwig
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
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM xfs
-
-#if !defined(_TRACE_XFS_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_XFS_H
-
-#include <linux/tracepoint.h>
-
-struct xfs_agf;
-struct xfs_alloc_arg;
-struct xfs_attr_list_context;
-struct xfs_buf_log_item;
-struct xfs_da_args;
-struct xfs_da_node_entry;
-struct xfs_dquot;
-struct xlog_ticket;
-struct log;
-struct xlog_recover;
-struct xlog_recover_item;
-struct xfs_buf_log_format;
-struct xfs_inode_log_format;
-
-DECLARE_EVENT_CLASS(xfs_attr_list_class,
-	TP_PROTO(struct xfs_attr_list_context *ctx),
-	TP_ARGS(ctx),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(u32, hashval)
-		__field(u32, blkno)
-		__field(u32, offset)
-		__field(void *, alist)
-		__field(int, bufsize)
-		__field(int, count)
-		__field(int, firstu)
-		__field(int, dupcnt)
-		__field(int, flags)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
-		__entry->ino = ctx->dp->i_ino;
-		__entry->hashval = ctx->cursor->hashval;
-		__entry->blkno = ctx->cursor->blkno;
-		__entry->offset = ctx->cursor->offset;
-		__entry->alist = ctx->alist;
-		__entry->bufsize = ctx->bufsize;
-		__entry->count = ctx->count;
-		__entry->firstu = ctx->firstu;
-		__entry->flags = ctx->flags;
-	),
-	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist 0x%p size %u count %u firstu %u flags %d %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		   __entry->ino,
-		   __entry->hashval,
-		   __entry->blkno,
-		   __entry->offset,
-		   __entry->dupcnt,
-		   __entry->alist,
-		   __entry->bufsize,
-		   __entry->count,
-		   __entry->firstu,
-		   __entry->flags,
-		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
-	)
-)
-
-#define DEFINE_ATTR_LIST_EVENT(name) \
-DEFINE_EVENT(xfs_attr_list_class, name, \
-	TP_PROTO(struct xfs_attr_list_context *ctx), \
-	TP_ARGS(ctx))
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
-
-DECLARE_EVENT_CLASS(xfs_perag_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
-		 unsigned long caller_ip),
-	TP_ARGS(mp, agno, refcount, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(int, refcount)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->refcount = refcount;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d agno %u refcount %d caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->refcount,
-		  (char *)__entry->caller_ip)
-);
-
-#define DEFINE_PERAG_REF_EVENT(name)	\
-DEFINE_EVENT(xfs_perag_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
-		 unsigned long caller_ip),					\
-	TP_ARGS(mp, agno, refcount, caller_ip))
-DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
-DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
-
-TRACE_EVENT(xfs_attr_list_node_descend,
-	TP_PROTO(struct xfs_attr_list_context *ctx,
-		 struct xfs_da_node_entry *btree),
-	TP_ARGS(ctx, btree),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(u32, hashval)
-		__field(u32, blkno)
-		__field(u32, offset)
-		__field(void *, alist)
-		__field(int, bufsize)
-		__field(int, count)
-		__field(int, firstu)
-		__field(int, dupcnt)
-		__field(int, flags)
-		__field(u32, bt_hashval)
-		__field(u32, bt_before)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
-		__entry->ino = ctx->dp->i_ino;
-		__entry->hashval = ctx->cursor->hashval;
-		__entry->blkno = ctx->cursor->blkno;
-		__entry->offset = ctx->cursor->offset;
-		__entry->alist = ctx->alist;
-		__entry->bufsize = ctx->bufsize;
-		__entry->count = ctx->count;
-		__entry->firstu = ctx->firstu;
-		__entry->flags = ctx->flags;
-		__entry->bt_hashval = be32_to_cpu(btree->hashval);
-		__entry->bt_before = be32_to_cpu(btree->before);
-	),
-	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist 0x%p size %u count %u firstu %u flags %d %s "
-		  "node hashval %u, node before %u",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		   __entry->ino,
-		   __entry->hashval,
-		   __entry->blkno,
-		   __entry->offset,
-		   __entry->dupcnt,
-		   __entry->alist,
-		   __entry->bufsize,
-		   __entry->count,
-		   __entry->firstu,
-		   __entry->flags,
-		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
-		   __entry->bt_hashval,
-		   __entry->bt_before)
-);
-
-TRACE_EVENT(xfs_iext_insert,
-	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx,
-		 struct xfs_bmbt_irec *r, int state, unsigned long caller_ip),
-	TP_ARGS(ip, idx, r, state, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_extnum_t, idx)
-		__field(xfs_fileoff_t, startoff)
-		__field(xfs_fsblock_t, startblock)
-		__field(xfs_filblks_t, blockcount)
-		__field(xfs_exntst_t, state)
-		__field(int, bmap_state)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->idx = idx;
-		__entry->startoff = r->br_startoff;
-		__entry->startblock = r->br_startblock;
-		__entry->blockcount = r->br_blockcount;
-		__entry->state = r->br_state;
-		__entry->bmap_state = state;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %lld count %lld flag %d caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
-		  (long)__entry->idx,
-		  __entry->startoff,
-		  (__int64_t)__entry->startblock,
-		  __entry->blockcount,
-		  __entry->state,
-		  (char *)__entry->caller_ip)
-);
-
-DECLARE_EVENT_CLASS(xfs_bmap_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state,
-		 unsigned long caller_ip),
-	TP_ARGS(ip, idx, state, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_extnum_t, idx)
-		__field(xfs_fileoff_t, startoff)
-		__field(xfs_fsblock_t, startblock)
-		__field(xfs_filblks_t, blockcount)
-		__field(xfs_exntst_t, state)
-		__field(int, bmap_state)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		struct xfs_ifork	*ifp = (state & BMAP_ATTRFORK) ?
-						ip->i_afp : &ip->i_df;
-		struct xfs_bmbt_irec	r;
-
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r);
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->idx = idx;
-		__entry->startoff = r.br_startoff;
-		__entry->startblock = r.br_startblock;
-		__entry->blockcount = r.br_blockcount;
-		__entry->state = r.br_state;
-		__entry->bmap_state = state;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %lld count %lld flag %d caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
-		  (long)__entry->idx,
-		  __entry->startoff,
-		  (__int64_t)__entry->startblock,
-		  __entry->blockcount,
-		  __entry->state,
-		  (char *)__entry->caller_ip)
-)
-
-#define DEFINE_BMAP_EVENT(name) \
-DEFINE_EVENT(xfs_bmap_class, name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
-		 unsigned long caller_ip), \
-	TP_ARGS(ip, idx, state, caller_ip))
-DEFINE_BMAP_EVENT(xfs_iext_remove);
-DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
-DEFINE_BMAP_EVENT(xfs_bmap_post_update);
-DEFINE_BMAP_EVENT(xfs_extlist);
-
-DECLARE_EVENT_CLASS(xfs_buf_class,
-	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip),
-	TP_ARGS(bp, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
-		__field(int, hold)
-		__field(int, pincount)
-		__field(unsigned, lockval)
-		__field(unsigned, flags)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
-		__entry->hold = atomic_read(&bp->b_hold);
-		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
-		__entry->flags = bp->b_flags;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
-		  __entry->hold,
-		  __entry->pincount,
-		  __entry->lockval,
-		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
-		  (void *)__entry->caller_ip)
-)
-
-#define DEFINE_BUF_EVENT(name) \
-DEFINE_EVENT(xfs_buf_class, name, \
-	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip), \
-	TP_ARGS(bp, caller_ip))
-DEFINE_BUF_EVENT(xfs_buf_init);
-DEFINE_BUF_EVENT(xfs_buf_free);
-DEFINE_BUF_EVENT(xfs_buf_hold);
-DEFINE_BUF_EVENT(xfs_buf_rele);
-DEFINE_BUF_EVENT(xfs_buf_iodone);
-DEFINE_BUF_EVENT(xfs_buf_iorequest);
-DEFINE_BUF_EVENT(xfs_buf_bawrite);
-DEFINE_BUF_EVENT(xfs_buf_bdwrite);
-DEFINE_BUF_EVENT(xfs_buf_lock);
-DEFINE_BUF_EVENT(xfs_buf_lock_done);
-DEFINE_BUF_EVENT(xfs_buf_trylock);
-DEFINE_BUF_EVENT(xfs_buf_unlock);
-DEFINE_BUF_EVENT(xfs_buf_iowait);
-DEFINE_BUF_EVENT(xfs_buf_iowait_done);
-DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_split);
-DEFINE_BUF_EVENT(xfs_buf_get_uncached);
-DEFINE_BUF_EVENT(xfs_bdstrat_shut);
-DEFINE_BUF_EVENT(xfs_buf_item_relse);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
-DEFINE_BUF_EVENT(xfs_buf_error_relse);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
-
-/* not really buffer traces, but the buf provides useful information */
-DEFINE_BUF_EVENT(xfs_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_reset_dqcounts);
-DEFINE_BUF_EVENT(xfs_inode_item_push);
-
-/* pass flags explicitly */
-DECLARE_EVENT_CLASS(xfs_buf_flags_class,
-	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip),
-	TP_ARGS(bp, flags, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
-		__field(int, hold)
-		__field(int, pincount)
-		__field(unsigned, lockval)
-		__field(unsigned, flags)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
-		__entry->flags = flags;
-		__entry->hold = atomic_read(&bp->b_hold);
-		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
-		  __entry->hold,
-		  __entry->pincount,
-		  __entry->lockval,
-		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
-		  (void *)__entry->caller_ip)
-)
-
-#define DEFINE_BUF_FLAGS_EVENT(name) \
-DEFINE_EVENT(xfs_buf_flags_class, name, \
-	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
-	TP_ARGS(bp, flags, caller_ip))
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
-
-TRACE_EVENT(xfs_buf_ioerror,
-	TP_PROTO(struct xfs_buf *bp, int error, unsigned long caller_ip),
-	TP_ARGS(bp, error, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
-		__field(unsigned, flags)
-		__field(int, hold)
-		__field(int, pincount)
-		__field(unsigned, lockval)
-		__field(int, error)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
-		__entry->hold = atomic_read(&bp->b_hold);
-		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
-		__entry->error = error;
-		__entry->flags = bp->b_flags;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d error %d flags %s caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
-		  __entry->hold,
-		  __entry->pincount,
-		  __entry->lockval,
-		  __entry->error,
-		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
-		  (void *)__entry->caller_ip)
-);
-
-DECLARE_EVENT_CLASS(xfs_buf_item_class,
-	TP_PROTO(struct xfs_buf_log_item *bip),
-	TP_ARGS(bip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_daddr_t, buf_bno)
-		__field(size_t, buf_len)
-		__field(int, buf_hold)
-		__field(int, buf_pincount)
-		__field(int, buf_lockval)
-		__field(unsigned, buf_flags)
-		__field(unsigned, bli_recur)
-		__field(int, bli_refcount)
-		__field(unsigned, bli_flags)
-		__field(void *, li_desc)
-		__field(unsigned, li_flags)
-	),
-	TP_fast_assign(
-		__entry->dev = bip->bli_buf->b_target->bt_dev;
-		__entry->bli_flags = bip->bli_flags;
-		__entry->bli_recur = bip->bli_recur;
-		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
-		__entry->buf_bno = bip->bli_buf->b_bn;
-		__entry->buf_len = bip->bli_buf->b_buffer_length;
-		__entry->buf_flags = bip->bli_buf->b_flags;
-		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
-		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
-		__entry->buf_lockval = bip->bli_buf->b_sema.count;
-		__entry->li_desc = bip->bli_item.li_desc;
-		__entry->li_flags = bip->bli_item.li_flags;
-	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s recur %d refcount %d bliflags %s "
-		  "lidesc 0x%p liflags %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->buf_bno,
-		  __entry->buf_len,
-		  __entry->buf_hold,
-		  __entry->buf_pincount,
-		  __entry->buf_lockval,
-		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
-		  __entry->bli_recur,
-		  __entry->bli_refcount,
-		  __print_flags(__entry->bli_flags, "|", XFS_BLI_FLAGS),
-		  __entry->li_desc,
-		  __print_flags(__entry->li_flags, "|", XFS_LI_FLAGS))
-)
-
-#define DEFINE_BUF_ITEM_EVENT(name) \
-DEFINE_EVENT(xfs_buf_item_class, name, \
-	TP_PROTO(struct xfs_buf_log_item *bip), \
-	TP_ARGS(bip))
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
-
-DECLARE_EVENT_CLASS(xfs_lock_class,
-	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
-		 unsigned long caller_ip),
-	TP_ARGS(ip,  lock_flags, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(int, lock_flags)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lock_flags = lock_flags;
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
-		  (void *)__entry->caller_ip)
-)
-
-#define DEFINE_LOCK_EVENT(name) \
-DEFINE_EVENT(xfs_lock_class, name, \
-	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
-		 unsigned long caller_ip), \
-	TP_ARGS(ip,  lock_flags, caller_ip))
-DEFINE_LOCK_EVENT(xfs_ilock);
-DEFINE_LOCK_EVENT(xfs_ilock_nowait);
-DEFINE_LOCK_EVENT(xfs_ilock_demote);
-DEFINE_LOCK_EVENT(xfs_iunlock);
-
-DECLARE_EVENT_CLASS(xfs_inode_class,
-	TP_PROTO(struct xfs_inode *ip),
-	TP_ARGS(ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-	),
-	TP_printk("dev %d:%d ino 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino)
-)
-
-#define DEFINE_INODE_EVENT(name) \
-DEFINE_EVENT(xfs_inode_class, name, \
-	TP_PROTO(struct xfs_inode *ip), \
-	TP_ARGS(ip))
-DEFINE_INODE_EVENT(xfs_iget_skip);
-DEFINE_INODE_EVENT(xfs_iget_reclaim);
-DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
-DEFINE_INODE_EVENT(xfs_iget_hit);
-DEFINE_INODE_EVENT(xfs_iget_miss);
-
-DEFINE_INODE_EVENT(xfs_getattr);
-DEFINE_INODE_EVENT(xfs_setattr);
-DEFINE_INODE_EVENT(xfs_readlink);
-DEFINE_INODE_EVENT(xfs_alloc_file_space);
-DEFINE_INODE_EVENT(xfs_free_file_space);
-DEFINE_INODE_EVENT(xfs_readdir);
-#ifdef CONFIG_XFS_POSIX_ACL
-DEFINE_INODE_EVENT(xfs_check_acl);
-#endif
-DEFINE_INODE_EVENT(xfs_vm_bmap);
-DEFINE_INODE_EVENT(xfs_file_ioctl);
-DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
-DEFINE_INODE_EVENT(xfs_ioctl_setattr);
-DEFINE_INODE_EVENT(xfs_file_fsync);
-DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_write_inode);
-DEFINE_INODE_EVENT(xfs_evict_inode);
-
-DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
-DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
-
-DECLARE_EVENT_CLASS(xfs_iref_class,
-	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-	TP_ARGS(ip, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(int, count)
-		__field(int, pincount)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->count = atomic_read(&VFS_I(ip)->i_count);
-		__entry->pincount = atomic_read(&ip->i_pincount);
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->count,
-		  __entry->pincount,
-		  (char *)__entry->caller_ip)
-)
-
-#define DEFINE_IREF_EVENT(name) \
-DEFINE_EVENT(xfs_iref_class, name, \
-	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
-	TP_ARGS(ip, caller_ip))
-DEFINE_IREF_EVENT(xfs_ihold);
-DEFINE_IREF_EVENT(xfs_irele);
-DEFINE_IREF_EVENT(xfs_inode_pin);
-DEFINE_IREF_EVENT(xfs_inode_unpin);
-DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
-
-DECLARE_EVENT_CLASS(xfs_namespace_class,
-	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
-	TP_ARGS(dp, name),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, dp_ino)
-		__dynamic_array(char, name, name->len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(dp)->i_sb->s_dev;
-		__entry->dp_ino = dp->i_ino;
-		memcpy(__get_str(name), name->name, name->len);
-	),
-	TP_printk("dev %d:%d dp ino 0x%llx name %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->dp_ino,
-		  __get_str(name))
-)
-
-#define DEFINE_NAMESPACE_EVENT(name) \
-DEFINE_EVENT(xfs_namespace_class, name, \
-	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
-	TP_ARGS(dp, name))
-DEFINE_NAMESPACE_EVENT(xfs_remove);
-DEFINE_NAMESPACE_EVENT(xfs_link);
-DEFINE_NAMESPACE_EVENT(xfs_lookup);
-DEFINE_NAMESPACE_EVENT(xfs_create);
-DEFINE_NAMESPACE_EVENT(xfs_symlink);
-
-TRACE_EVENT(xfs_rename,
-	TP_PROTO(struct xfs_inode *src_dp, struct xfs_inode *target_dp,
-		 struct xfs_name *src_name, struct xfs_name *target_name),
-	TP_ARGS(src_dp, target_dp, src_name, target_name),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, src_dp_ino)
-		__field(xfs_ino_t, target_dp_ino)
-		__dynamic_array(char, src_name, src_name->len)
-		__dynamic_array(char, target_name, target_name->len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
-		__entry->src_dp_ino = src_dp->i_ino;
-		__entry->target_dp_ino = target_dp->i_ino;
-		memcpy(__get_str(src_name), src_name->name, src_name->len);
-		memcpy(__get_str(target_name), target_name->name, target_name->len);
-	),
-	TP_printk("dev %d:%d src dp ino 0x%llx target dp ino 0x%llx"
-		  " src name %s target name %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->src_dp_ino,
-		  __entry->target_dp_ino,
-		  __get_str(src_name),
-		  __get_str(target_name))
-)
-
-DECLARE_EVENT_CLASS(xfs_dquot_class,
-	TP_PROTO(struct xfs_dquot *dqp),
-	TP_ARGS(dqp),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(u32, id)
-		__field(unsigned, flags)
-		__field(unsigned, nrefs)
-		__field(unsigned long long, res_bcount)
-		__field(unsigned long long, bcount)
-		__field(unsigned long long, icount)
-		__field(unsigned long long, blk_hardlimit)
-		__field(unsigned long long, blk_softlimit)
-		__field(unsigned long long, ino_hardlimit)
-		__field(unsigned long long, ino_softlimit)
-	), \
-	TP_fast_assign(
-		__entry->dev = dqp->q_mount->m_super->s_dev;
-		__entry->id = be32_to_cpu(dqp->q_core.d_id);
-		__entry->flags = dqp->dq_flags;
-		__entry->nrefs = dqp->q_nrefs;
-		__entry->res_bcount = dqp->q_res_bcount;
-		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
-		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
-		__entry->blk_hardlimit =
-			be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-		__entry->blk_softlimit =
-			be64_to_cpu(dqp->q_core.d_blk_softlimit);
-		__entry->ino_hardlimit =
-			be64_to_cpu(dqp->q_core.d_ino_hardlimit);
-		__entry->ino_softlimit =
-			be64_to_cpu(dqp->q_core.d_ino_softlimit);
-	),
-	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
-		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
-		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->id,
-		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
-		  __entry->nrefs,
-		  __entry->res_bcount,
-		  __entry->bcount,
-		  __entry->blk_hardlimit,
-		  __entry->blk_softlimit,
-		  __entry->icount,
-		  __entry->ino_hardlimit,
-		  __entry->ino_softlimit)
-)
-
-#define DEFINE_DQUOT_EVENT(name) \
-DEFINE_EVENT(xfs_dquot_class, name, \
-	TP_PROTO(struct xfs_dquot *dqp), \
-	TP_ARGS(dqp))
-DEFINE_DQUOT_EVENT(xfs_dqadjust);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
-DEFINE_DQUOT_EVENT(xfs_dqattach_found);
-DEFINE_DQUOT_EVENT(xfs_dqattach_get);
-DEFINE_DQUOT_EVENT(xfs_dqinit);
-DEFINE_DQUOT_EVENT(xfs_dqreuse);
-DEFINE_DQUOT_EVENT(xfs_dqalloc);
-DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
-DEFINE_DQUOT_EVENT(xfs_dqread);
-DEFINE_DQUOT_EVENT(xfs_dqread_fail);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
-DEFINE_DQUOT_EVENT(xfs_dqget_hit);
-DEFINE_DQUOT_EVENT(xfs_dqget_miss);
-DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_wait);
-DEFINE_DQUOT_EVENT(xfs_dqput_free);
-DEFINE_DQUOT_EVENT(xfs_dqrele);
-DEFINE_DQUOT_EVENT(xfs_dqflush);
-DEFINE_DQUOT_EVENT(xfs_dqflush_force);
-DEFINE_DQUOT_EVENT(xfs_dqflush_done);
-
-DECLARE_EVENT_CLASS(xfs_loggrant_class,
-	TP_PROTO(struct log *log, struct xlog_ticket *tic),
-	TP_ARGS(log, tic),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(unsigned, trans_type)
-		__field(char, ocnt)
-		__field(char, cnt)
-		__field(int, curr_res)
-		__field(int, unit_res)
-		__field(unsigned int, flags)
-		__field(int, reserveq)
-		__field(int, writeq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
-		__field(int, curr_cycle)
-		__field(int, curr_block)
-		__field(xfs_lsn_t, tail_lsn)
-	),
-	TP_fast_assign(
-		__entry->dev = log->l_mp->m_super->s_dev;
-		__entry->trans_type = tic->t_trans_type;
-		__entry->ocnt = tic->t_ocnt;
-		__entry->cnt = tic->t_cnt;
-		__entry->curr_res = tic->t_curr_res;
-		__entry->unit_res = tic->t_unit_res;
-		__entry->flags = tic->t_flags;
-		__entry->reserveq = list_empty(&log->l_reserveq);
-		__entry->writeq = list_empty(&log->l_writeq);
-		xlog_crack_grant_head(&log->l_grant_reserve_head,
-				&__entry->grant_reserve_cycle,
-				&__entry->grant_reserve_bytes);
-		xlog_crack_grant_head(&log->l_grant_write_head,
-				&__entry->grant_write_cycle,
-				&__entry->grant_write_bytes);
-		__entry->curr_cycle = log->l_curr_cycle;
-		__entry->curr_block = log->l_curr_block;
-		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
-	),
-	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
-		  "t_unit_res %u t_flags %s reserveq %s "
-		  "writeq %s grant_reserve_cycle %d "
-		  "grant_reserve_bytes %d grant_write_cycle %d "
-		  "grant_write_bytes %d curr_cycle %d curr_block %d "
-		  "tail_cycle %d tail_block %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->trans_type, XFS_TRANS_TYPES),
-		  __entry->ocnt,
-		  __entry->cnt,
-		  __entry->curr_res,
-		  __entry->unit_res,
-		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
-		  __entry->reserveq ? "empty" : "active",
-		  __entry->writeq ? "empty" : "active",
-		  __entry->grant_reserve_cycle,
-		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
-		  __entry->grant_write_bytes,
-		  __entry->curr_cycle,
-		  __entry->curr_block,
-		  CYCLE_LSN(__entry->tail_lsn),
-		  BLOCK_LSN(__entry->tail_lsn)
-	)
-)
-
-#define DEFINE_LOGGRANT_EVENT(name) \
-DEFINE_EVENT(xfs_loggrant_class, name, \
-	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
-	TP_ARGS(log, tic))
-DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
-DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
-DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
-DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
-
-DECLARE_EVENT_CLASS(xfs_file_class,
-	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
-	TP_ARGS(ip, count, offset, flags),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_fsize_t, new_size)
-		__field(loff_t, offset)
-		__field(size_t, count)
-		__field(int, flags)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
-		__entry->offset = offset;
-		__entry->count = count;
-		__entry->flags = flags;
-	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
-		  "offset 0x%llx count 0x%zx ioflags %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->new_size,
-		  __entry->offset,
-		  __entry->count,
-		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
-)
-
-#define DEFINE_RW_EVENT(name)		\
-DEFINE_EVENT(xfs_file_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
-	TP_ARGS(ip, count, offset, flags))
-DEFINE_RW_EVENT(xfs_file_read);
-DEFINE_RW_EVENT(xfs_file_buffered_write);
-DEFINE_RW_EVENT(xfs_file_direct_write);
-DEFINE_RW_EVENT(xfs_file_splice_read);
-DEFINE_RW_EVENT(xfs_file_splice_write);
-
-DECLARE_EVENT_CLASS(xfs_page_class,
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
-	TP_ARGS(inode, page, off),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(pgoff_t, pgoff)
-		__field(loff_t, size)
-		__field(unsigned long, offset)
-		__field(int, delalloc)
-		__field(int, unwritten)
-	),
-	TP_fast_assign(
-		int delalloc = -1, unwritten = -1;
-
-		if (page_has_buffers(page))
-			xfs_count_page_state(page, &delalloc, &unwritten);
-		__entry->dev = inode->i_sb->s_dev;
-		__entry->ino = XFS_I(inode)->i_ino;
-		__entry->pgoff = page_offset(page);
-		__entry->size = i_size_read(inode);
-		__entry->offset = off;
-		__entry->delalloc = delalloc;
-		__entry->unwritten = unwritten;
-	),
-	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
-		  "delalloc %d unwritten %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->pgoff,
-		  __entry->size,
-		  __entry->offset,
-		  __entry->delalloc,
-		  __entry->unwritten)
-)
-
-#define DEFINE_PAGE_EVENT(name)		\
-DEFINE_EVENT(xfs_page_class, name,	\
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
-	TP_ARGS(inode, page, off))
-DEFINE_PAGE_EVENT(xfs_writepage);
-DEFINE_PAGE_EVENT(xfs_releasepage);
-DEFINE_PAGE_EVENT(xfs_invalidatepage);
-
-DECLARE_EVENT_CLASS(xfs_imap_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
-		 int type, struct xfs_bmbt_irec *irec),
-	TP_ARGS(ip, offset, count, type, irec),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(loff_t, size)
-		__field(loff_t, new_size)
-		__field(loff_t, offset)
-		__field(size_t, count)
-		__field(int, type)
-		__field(xfs_fileoff_t, startoff)
-		__field(xfs_fsblock_t, startblock)
-		__field(xfs_filblks_t, blockcount)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
-		__entry->offset = offset;
-		__entry->count = count;
-		__entry->type = type;
-		__entry->startoff = irec ? irec->br_startoff : 0;
-		__entry->startblock = irec ? irec->br_startblock : 0;
-		__entry->blockcount = irec ? irec->br_blockcount : 0;
-	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
-		  "offset 0x%llx count %zd type %s "
-		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->new_size,
-		  __entry->offset,
-		  __entry->count,
-		  __print_symbolic(__entry->type, XFS_IO_TYPES),
-		  __entry->startoff,
-		  (__int64_t)__entry->startblock,
-		  __entry->blockcount)
-)
-
-#define DEFINE_IOMAP_EVENT(name)	\
-DEFINE_EVENT(xfs_imap_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
-		 int type, struct xfs_bmbt_irec *irec),		\
-	TP_ARGS(ip, offset, count, type, irec))
-DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
-DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
-DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
-DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
-
-DECLARE_EVENT_CLASS(xfs_simple_io_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
-	TP_ARGS(ip, offset, count),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(loff_t, isize)
-		__field(loff_t, disize)
-		__field(loff_t, new_size)
-		__field(loff_t, offset)
-		__field(size_t, count)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->isize = ip->i_size;
-		__entry->disize = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
-		__entry->offset = offset;
-		__entry->count = count;
-	),
-	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx new_size 0x%llx "
-		  "offset 0x%llx count %zd",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->isize,
-		  __entry->disize,
-		  __entry->new_size,
-		  __entry->offset,
-		  __entry->count)
-);
-
-#define DEFINE_SIMPLE_IO_EVENT(name)	\
-DEFINE_EVENT(xfs_simple_io_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
-	TP_ARGS(ip, offset, count))
-DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
-DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
-DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
-DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
-
-DECLARE_EVENT_CLASS(xfs_itrunc_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-	TP_ARGS(ip, new_size),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_fsize_t, new_size)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->new_size = new_size;
-	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->new_size)
-)
-
-#define DEFINE_ITRUNC_EVENT(name) \
-DEFINE_EVENT(xfs_itrunc_class, name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
-	TP_ARGS(ip, new_size))
-DEFINE_ITRUNC_EVENT(xfs_itruncate_data_start);
-DEFINE_ITRUNC_EVENT(xfs_itruncate_data_end);
-
-TRACE_EVENT(xfs_pagecache_inval,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
-	TP_ARGS(ip, start, finish),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_off_t, start)
-		__field(xfs_off_t, finish)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->start = start;
-		__entry->finish = finish;
-	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx start 0x%llx finish 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->start,
-		  __entry->finish)
-);
-
-TRACE_EVENT(xfs_bunmap,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
-		 int flags, unsigned long caller_ip),
-	TP_ARGS(ip, bno, len, flags, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_fileoff_t, bno)
-		__field(xfs_filblks_t, len)
-		__field(unsigned long, caller_ip)
-		__field(int, flags)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->bno = bno;
-		__entry->len = len;
-		__entry->caller_ip = caller_ip;
-		__entry->flags = flags;
-	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
-		  "flags %s caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->bno,
-		  __entry->len,
-		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
-		  (void *)__entry->caller_ip)
-
-);
-
-DECLARE_EVENT_CLASS(xfs_busy_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len)
-);
-#define DEFINE_BUSY_EVENT(name) \
-DEFINE_EVENT(xfs_busy_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
-DEFINE_BUSY_EVENT(xfs_alloc_busy);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
-DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
-
-TRACE_EVENT(xfs_alloc_busy_trim,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
-		 xfs_agblock_t tbno, xfs_extlen_t tlen),
-	TP_ARGS(mp, agno, agbno, len, tbno, tlen),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-		__field(xfs_agblock_t, tbno)
-		__field(xfs_extlen_t, tlen)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->tbno = tbno;
-		__entry->tlen = tlen;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u tbno %u tlen %u",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len,
-		  __entry->tbno,
-		  __entry->tlen)
-);
-
-TRACE_EVENT(xfs_trans_commit_lsn,
-	TP_PROTO(struct xfs_trans *trans),
-	TP_ARGS(trans),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(struct xfs_trans *, tp)
-		__field(xfs_lsn_t, lsn)
-	),
-	TP_fast_assign(
-		__entry->dev = trans->t_mountp->m_super->s_dev;
-		__entry->tp = trans;
-		__entry->lsn = trans->t_commit_lsn;
-	),
-	TP_printk("dev %d:%d trans 0x%p commit_lsn 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->tp,
-		  __entry->lsn)
-);
-
-TRACE_EVENT(xfs_agf,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
-		 unsigned long caller_ip),
-	TP_ARGS(mp, agf, flags, caller_ip),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(int, flags)
-		__field(__u32, length)
-		__field(__u32, bno_root)
-		__field(__u32, cnt_root)
-		__field(__u32, bno_level)
-		__field(__u32, cnt_level)
-		__field(__u32, flfirst)
-		__field(__u32, fllast)
-		__field(__u32, flcount)
-		__field(__u32, freeblks)
-		__field(__u32, longest)
-		__field(unsigned long, caller_ip)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = be32_to_cpu(agf->agf_seqno),
-		__entry->flags = flags;
-		__entry->length = be32_to_cpu(agf->agf_length),
-		__entry->bno_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-		__entry->cnt_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-		__entry->bno_level =
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-		__entry->cnt_level =
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
-		__entry->flfirst = be32_to_cpu(agf->agf_flfirst),
-		__entry->fllast = be32_to_cpu(agf->agf_fllast),
-		__entry->flcount = be32_to_cpu(agf->agf_flcount),
-		__entry->freeblks = be32_to_cpu(agf->agf_freeblks),
-		__entry->longest = be32_to_cpu(agf->agf_longest);
-		__entry->caller_ip = caller_ip;
-	),
-	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
-		  "levels b %u c %u flfirst %u fllast %u flcount %u "
-		  "freeblks %u longest %u caller %pf",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
-		  __entry->length,
-		  __entry->bno_root,
-		  __entry->cnt_root,
-		  __entry->bno_level,
-		  __entry->cnt_level,
-		  __entry->flfirst,
-		  __entry->fllast,
-		  __entry->flcount,
-		  __entry->freeblks,
-		  __entry->longest,
-		  (void *)__entry->caller_ip)
-);
-
-TRACE_EVENT(xfs_free_extent,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, bool isfl, int haveleft, int haveright),
-	TP_ARGS(mp, agno, agbno, len, isfl, haveleft, haveright),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-		__field(int, isfl)
-		__field(int, haveleft)
-		__field(int, haveright)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->isfl = isfl;
-		__entry->haveleft = haveleft;
-		__entry->haveright = haveright;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u isfl %d %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len,
-		  __entry->isfl,
-		  __entry->haveleft ?
-			(__entry->haveright ? "both" : "left") :
-			(__entry->haveright ? "right" : "none"))
-
-);
-
-DECLARE_EVENT_CLASS(xfs_alloc_class,
-	TP_PROTO(struct xfs_alloc_arg *args),
-	TP_ARGS(args),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, minlen)
-		__field(xfs_extlen_t, maxlen)
-		__field(xfs_extlen_t, mod)
-		__field(xfs_extlen_t, prod)
-		__field(xfs_extlen_t, minleft)
-		__field(xfs_extlen_t, total)
-		__field(xfs_extlen_t, alignment)
-		__field(xfs_extlen_t, minalignslop)
-		__field(xfs_extlen_t, len)
-		__field(short, type)
-		__field(short, otype)
-		__field(char, wasdel)
-		__field(char, wasfromfl)
-		__field(char, isfl)
-		__field(char, userdata)
-		__field(xfs_fsblock_t, firstblock)
-	),
-	TP_fast_assign(
-		__entry->dev = args->mp->m_super->s_dev;
-		__entry->agno = args->agno;
-		__entry->agbno = args->agbno;
-		__entry->minlen = args->minlen;
-		__entry->maxlen = args->maxlen;
-		__entry->mod = args->mod;
-		__entry->prod = args->prod;
-		__entry->minleft = args->minleft;
-		__entry->total = args->total;
-		__entry->alignment = args->alignment;
-		__entry->minalignslop = args->minalignslop;
-		__entry->len = args->len;
-		__entry->type = args->type;
-		__entry->otype = args->otype;
-		__entry->wasdel = args->wasdel;
-		__entry->wasfromfl = args->wasfromfl;
-		__entry->isfl = args->isfl;
-		__entry->userdata = args->userdata;
-		__entry->firstblock = args->firstblock;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
-		  "prod %u minleft %u total %u alignment %u minalignslop %u "
-		  "len %u type %s otype %s wasdel %d wasfromfl %d isfl %d "
-		  "userdata %d firstblock 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->minlen,
-		  __entry->maxlen,
-		  __entry->mod,
-		  __entry->prod,
-		  __entry->minleft,
-		  __entry->total,
-		  __entry->alignment,
-		  __entry->minalignslop,
-		  __entry->len,
-		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
-		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
-		  __entry->wasdel,
-		  __entry->wasfromfl,
-		  __entry->isfl,
-		  __entry->userdata,
-		  (unsigned long long)__entry->firstblock)
-)
-
-#define DEFINE_ALLOC_EVENT(name) \
-DEFINE_EVENT(xfs_alloc_class, name, \
-	TP_PROTO(struct xfs_alloc_arg *args), \
-	TP_ARGS(args))
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_busy);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
-
-DECLARE_EVENT_CLASS(xfs_dir2_class,
-	TP_PROTO(struct xfs_da_args *args),
-	TP_ARGS(args),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__dynamic_array(char, name, args->namelen)
-		__field(int, namelen)
-		__field(xfs_dahash_t, hashval)
-		__field(xfs_ino_t, inumber)
-		__field(int, op_flags)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
-		if (args->namelen)
-			memcpy(__get_str(name), args->name, args->namelen);
-		__entry->namelen = args->namelen;
-		__entry->hashval = args->hashval;
-		__entry->inumber = args->inumber;
-		__entry->op_flags = args->op_flags;
-	),
-	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x "
-		  "inumber 0x%llx op_flags %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->namelen,
-		  __entry->namelen ? __get_str(name) : NULL,
-		  __entry->namelen,
-		  __entry->hashval,
-		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
-)
-
-#define DEFINE_DIR2_EVENT(name) \
-DEFINE_EVENT(xfs_dir2_class, name, \
-	TP_PROTO(struct xfs_da_args *args), \
-	TP_ARGS(args))
-DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_create);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_block_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_block_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_block_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_block_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node);
-DEFINE_DIR2_EVENT(xfs_dir2_node_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_node_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
-
-DECLARE_EVENT_CLASS(xfs_dir2_space_class,
-	TP_PROTO(struct xfs_da_args *args, int idx),
-	TP_ARGS(args, idx),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(int, op_flags)
-		__field(int, idx)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
-		__entry->op_flags = args->op_flags;
-		__entry->idx = idx;
-	),
-	TP_printk("dev %d:%d ino 0x%llx op_flags %s index %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
-		  __entry->idx)
-)
-
-#define DEFINE_DIR2_SPACE_EVENT(name) \
-DEFINE_EVENT(xfs_dir2_space_class, name, \
-	TP_PROTO(struct xfs_da_args *args, int idx), \
-	TP_ARGS(args, idx))
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode);
-
-TRACE_EVENT(xfs_dir2_leafn_moveents,
-	TP_PROTO(struct xfs_da_args *args, int src_idx, int dst_idx, int count),
-	TP_ARGS(args, src_idx, dst_idx, count),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(int, op_flags)
-		__field(int, src_idx)
-		__field(int, dst_idx)
-		__field(int, count)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
-		__entry->op_flags = args->op_flags;
-		__entry->src_idx = src_idx;
-		__entry->dst_idx = dst_idx;
-		__entry->count = count;
-	),
-	TP_printk("dev %d:%d ino 0x%llx op_flags %s "
-		  "src_idx %d dst_idx %d count %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
-		  __entry->src_idx,
-		  __entry->dst_idx,
-		  __entry->count)
-);
-
-#define XFS_SWAPEXT_INODES \
-	{ 0,	"target" }, \
-	{ 1,	"temp" }
-
-#define XFS_INODE_FORMAT_STR \
-	{ 0,	"invalid" }, \
-	{ 1,	"local" }, \
-	{ 2,	"extent" }, \
-	{ 3,	"btree" }
-
-DECLARE_EVENT_CLASS(xfs_swap_extent_class,
-	TP_PROTO(struct xfs_inode *ip, int which),
-	TP_ARGS(ip, which),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(int, which)
-		__field(xfs_ino_t, ino)
-		__field(int, format)
-		__field(int, nex)
-		__field(int, max_nex)
-		__field(int, broot_size)
-		__field(int, fork_off)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->which = which;
-		__entry->ino = ip->i_ino;
-		__entry->format = ip->i_d.di_format;
-		__entry->nex = ip->i_d.di_nextents;
-		__entry->max_nex = ip->i_df.if_ext_max;
-		__entry->broot_size = ip->i_df.if_broot_bytes;
-		__entry->fork_off = XFS_IFORK_BOFF(ip);
-	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
-		  "Max in-fork extents %d, broot size %d, fork offset %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
-		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
-		  __entry->nex,
-		  __entry->max_nex,
-		  __entry->broot_size,
-		  __entry->fork_off)
-)
-
-#define DEFINE_SWAPEXT_EVENT(name) \
-DEFINE_EVENT(xfs_swap_extent_class, name, \
-	TP_PROTO(struct xfs_inode *ip, int which), \
-	TP_ARGS(ip, which))
-
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
-
-DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
-	TP_PROTO(struct log *log, struct xlog_recover *trans,
-		struct xlog_recover_item *item, int pass),
-	TP_ARGS(log, trans, item, pass),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(unsigned long, item)
-		__field(xlog_tid_t, tid)
-		__field(int, type)
-		__field(int, pass)
-		__field(int, count)
-		__field(int, total)
-	),
-	TP_fast_assign(
-		__entry->dev = log->l_mp->m_super->s_dev;
-		__entry->item = (unsigned long)item;
-		__entry->tid = trans->r_log_tid;
-		__entry->type = ITEM_TYPE(item);
-		__entry->pass = pass;
-		__entry->count = item->ri_cnt;
-		__entry->total = item->ri_total;
-	),
-	TP_printk("dev %d:%d trans 0x%x, pass %d, item 0x%p, item type %s "
-		  "item region count/total %d/%d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->tid,
-		  __entry->pass,
-		  (void *)__entry->item,
-		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
-		  __entry->count,
-		  __entry->total)
-)
-
-#define DEFINE_LOG_RECOVER_ITEM(name) \
-DEFINE_EVENT(xfs_log_recover_item_class, name, \
-	TP_PROTO(struct log *log, struct xlog_recover *trans, \
-		struct xlog_recover_item *item, int pass), \
-	TP_ARGS(log, trans, item, pass))
-
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
-
-DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
-	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
-	TP_ARGS(log, buf_f),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(__int64_t, blkno)
-		__field(unsigned short, len)
-		__field(unsigned short, flags)
-		__field(unsigned short, size)
-		__field(unsigned int, map_size)
-	),
-	TP_fast_assign(
-		__entry->dev = log->l_mp->m_super->s_dev;
-		__entry->blkno = buf_f->blf_blkno;
-		__entry->len = buf_f->blf_len;
-		__entry->flags = buf_f->blf_flags;
-		__entry->size = buf_f->blf_size;
-		__entry->map_size = buf_f->blf_map_size;
-	),
-	TP_printk("dev %d:%d blkno 0x%llx, len %u, flags 0x%x, size %d, "
-			"map_size %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->blkno,
-		  __entry->len,
-		  __entry->flags,
-		  __entry->size,
-		  __entry->map_size)
-)
-
-#define DEFINE_LOG_RECOVER_BUF_ITEM(name) \
-DEFINE_EVENT(xfs_log_recover_buf_item_class, name, \
-	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
-	TP_ARGS(log, buf_f))
-
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
-
-DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
-	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
-	TP_ARGS(log, in_f),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(unsigned short, size)
-		__field(int, fields)
-		__field(unsigned short, asize)
-		__field(unsigned short, dsize)
-		__field(__int64_t, blkno)
-		__field(int, len)
-		__field(int, boffset)
-	),
-	TP_fast_assign(
-		__entry->dev = log->l_mp->m_super->s_dev;
-		__entry->ino = in_f->ilf_ino;
-		__entry->size = in_f->ilf_size;
-		__entry->fields = in_f->ilf_fields;
-		__entry->asize = in_f->ilf_asize;
-		__entry->dsize = in_f->ilf_dsize;
-		__entry->blkno = in_f->ilf_blkno;
-		__entry->len = in_f->ilf_len;
-		__entry->boffset = in_f->ilf_boffset;
-	),
-	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
-			"dsize %d, blkno 0x%llx, len %d, boffset %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->fields,
-		  __entry->asize,
-		  __entry->dsize,
-		  __entry->blkno,
-		  __entry->len,
-		  __entry->boffset)
-)
-#define DEFINE_LOG_RECOVER_INO_ITEM(name) \
-DEFINE_EVENT(xfs_log_recover_ino_item_class, name, \
-	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
-	TP_ARGS(log, in_f))
-
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
-
-DECLARE_EVENT_CLASS(xfs_discard_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u\n",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len)
-)
-
-#define DEFINE_DISCARD_EVENT(name) \
-DEFINE_EVENT(xfs_discard_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
-DEFINE_DISCARD_EVENT(xfs_discard_extent);
-DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
-DEFINE_DISCARD_EVENT(xfs_discard_exclude);
-DEFINE_DISCARD_EVENT(xfs_discard_busy);
-
-#endif /* _TRACE_XFS_H */
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#define TRACE_INCLUDE_FILE xfs_trace
-#include <trace/define_trace.h>
diff --git a/fs/xfs/linux-2.6/xfs_vnode.h b/fs/xfs/linux-2.6/xfs_vnode.h
deleted file mode 100644
index 7c220b4..0000000
--- a/fs/xfs/linux-2.6/xfs_vnode.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_VNODE_H__
-#define __XFS_VNODE_H__
-
-#include "xfs_fs.h"
-
-struct file;
-struct xfs_inode;
-struct xfs_iomap;
-struct attrlist_cursor_kern;
-
-/*
- * Return values for xfs_inactive.  A return value of
- * VN_INACTIVE_NOCACHE implies that the file system behavior
- * has disassociated its state and bhv_desc_t from the vnode.
- */
-#define	VN_INACTIVE_CACHE	0
-#define	VN_INACTIVE_NOCACHE	1
-
-/*
- * Flags for read/write calls - same values as IRIX
- */
-#define IO_ISDIRECT	0x00004		/* bypass page cache */
-#define IO_INVIS	0x00020		/* don't update inode timestamps */
-
-#define XFS_IO_FLAGS \
-	{ IO_ISDIRECT,	"DIRECT" }, \
-	{ IO_INVIS,	"INVIS"}
-
-/*
- * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
- */
-#define FI_NONE			0	/* none */
-#define FI_REMAPF		1	/* Do a remapf prior to the operation */
-#define FI_REMAPF_LOCKED	2	/* Do a remapf prior to the operation.
-					   Prevent VM access to the pages until
-					   the operation completes. */
-
-/*
- * Some useful predicates.
- */
-#define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
-#define VN_CACHED(vp)	(vp->i_mapping->nrpages)
-#define VN_DIRTY(vp)	mapping_tagged(vp->i_mapping, \
-					PAGECACHE_TAG_DIRTY)
-
-
-#endif	/* __XFS_VNODE_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_xattr.c b/fs/xfs/linux-2.6/xfs_xattr.c
deleted file mode 100644
index 87d3e03..0000000
--- a/fs/xfs/linux-2.6/xfs_xattr.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/*
- * Copyright (C) 2008 Christoph Hellwig.
- * Portions Copyright (C) 2000-2008 Silicon Graphics, Inc.
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
-
-#include "xfs.h"
-#include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_attr.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_acl.h"
-#include "xfs_vnodeops.h"
-
-#include <linux/posix_acl_xattr.h>
-#include <linux/xattr.h>
-
-
-static int
-xfs_xattr_get(struct dentry *dentry, const char *name,
-		void *value, size_t size, int xflags)
-{
-	struct xfs_inode *ip = XFS_I(dentry->d_inode);
-	int error, asize = size;
-
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (!size) {
-		xflags |= ATTR_KERNOVAL;
-		value = NULL;
-	}
-
-	error = -xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
-	if (error)
-		return error;
-	return asize;
-}
-
-static int
-xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
-		size_t size, int flags, int xflags)
-{
-	struct xfs_inode *ip = XFS_I(dentry->d_inode);
-
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (flags & XATTR_CREATE)
-		xflags |= ATTR_CREATE;
-	if (flags & XATTR_REPLACE)
-		xflags |= ATTR_REPLACE;
-
-	if (!value)
-		return -xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	return -xfs_attr_set(ip, (unsigned char *)name,
-				(void *)value, size, xflags);
-}
-
-static const struct xattr_handler xfs_xattr_user_handler = {
-	.prefix	= XATTR_USER_PREFIX,
-	.flags	= 0, /* no flags implies user namespace */
-	.get	= xfs_xattr_get,
-	.set	= xfs_xattr_set,
-};
-
-static const struct xattr_handler xfs_xattr_trusted_handler = {
-	.prefix	= XATTR_TRUSTED_PREFIX,
-	.flags	= ATTR_ROOT,
-	.get	= xfs_xattr_get,
-	.set	= xfs_xattr_set,
-};
-
-static const struct xattr_handler xfs_xattr_security_handler = {
-	.prefix	= XATTR_SECURITY_PREFIX,
-	.flags	= ATTR_SECURE,
-	.get	= xfs_xattr_get,
-	.set	= xfs_xattr_set,
-};
-
-const struct xattr_handler *xfs_xattr_handlers[] = {
-	&xfs_xattr_user_handler,
-	&xfs_xattr_trusted_handler,
-	&xfs_xattr_security_handler,
-#ifdef CONFIG_XFS_POSIX_ACL
-	&xfs_xattr_acl_access_handler,
-	&xfs_xattr_acl_default_handler,
-#endif
-	NULL
-};
-
-static unsigned int xfs_xattr_prefix_len(int flags)
-{
-	if (flags & XFS_ATTR_SECURE)
-		return sizeof("security");
-	else if (flags & XFS_ATTR_ROOT)
-		return sizeof("trusted");
-	else
-		return sizeof("user");
-}
-
-static const char *xfs_xattr_prefix(int flags)
-{
-	if (flags & XFS_ATTR_SECURE)
-		return xfs_xattr_security_handler.prefix;
-	else if (flags & XFS_ATTR_ROOT)
-		return xfs_xattr_trusted_handler.prefix;
-	else
-		return xfs_xattr_user_handler.prefix;
-}
-
-static int
-xfs_xattr_put_listent(
-	struct xfs_attr_list_context *context,
-	int		flags,
-	unsigned char	*name,
-	int		namelen,
-	int		valuelen,
-	unsigned char	*value)
-{
-	unsigned int prefix_len = xfs_xattr_prefix_len(flags);
-	char *offset;
-	int arraytop;
-
-	ASSERT(context->count >= 0);
-
-	/*
-	 * Only show root namespace entries if we are actually allowed to
-	 * see them.
-	 */
-	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
-		return 0;
-
-	arraytop = context->count + prefix_len + namelen + 1;
-	if (arraytop > context->firstu) {
-		context->count = -1;	/* insufficient space */
-		return 1;
-	}
-	offset = (char *)context->alist + context->count;
-	strncpy(offset, xfs_xattr_prefix(flags), prefix_len);
-	offset += prefix_len;
-	strncpy(offset, (char *)name, namelen);			/* real name */
-	offset += namelen;
-	*offset = '\0';
-	context->count += prefix_len + namelen + 1;
-	return 0;
-}
-
-static int
-xfs_xattr_put_listent_sizes(
-	struct xfs_attr_list_context *context,
-	int		flags,
-	unsigned char	*name,
-	int		namelen,
-	int		valuelen,
-	unsigned char	*value)
-{
-	context->count += xfs_xattr_prefix_len(flags) + namelen + 1;
-	return 0;
-}
-
-static int
-list_one_attr(const char *name, const size_t len, void *data,
-		size_t size, ssize_t *result)
-{
-	char *p = data + *result;
-
-	*result += len;
-	if (!size)
-		return 0;
-	if (*result > size)
-		return -ERANGE;
-
-	strcpy(p, name);
-	return 0;
-}
-
-ssize_t
-xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
-{
-	struct xfs_attr_list_context context;
-	struct attrlist_cursor_kern cursor = { 0 };
-	struct inode		*inode = dentry->d_inode;
-	int			error;
-
-	/*
-	 * First read the regular on-disk attributes.
-	 */
-	memset(&context, 0, sizeof(context));
-	context.dp = XFS_I(inode);
-	context.cursor = &cursor;
-	context.resynch = 1;
-	context.alist = data;
-	context.bufsize = size;
-	context.firstu = context.bufsize;
-
-	if (size)
-		context.put_listent = xfs_xattr_put_listent;
-	else
-		context.put_listent = xfs_xattr_put_listent_sizes;
-
-	xfs_attr_list_int(&context);
-	if (context.count < 0)
-		return -ERANGE;
-
-	/*
-	 * Then add the two synthetic ACL attributes.
-	 */
-	if (posix_acl_access_exists(inode)) {
-		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
-				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
-				data, size, &context.count);
-		if (error)
-			return error;
-	}
-
-	if (posix_acl_default_exists(inode)) {
-		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
-				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
-				data, size, &context.count);
-		if (error)
-			return error;
-	}
-
-	return context.count;
-}
diff --git a/fs/xfs/linux/kmem.c b/fs/xfs/linux/kmem.c
new file mode 100644
index 0000000..a907de5
--- /dev/null
+++ b/fs/xfs/linux/kmem.c
@@ -0,0 +1,132 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/swap.h>
+#include <linux/blkdev.h>
+#include <linux/backing-dev.h>
+#include "time.h"
+#include "kmem.h"
+#include "xfs_message.h"
+
+/*
+ * Greedy allocation.  May fail and may return vmalloced memory.
+ *
+ * Must be freed using kmem_free_large.
+ */
+void *
+kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
+{
+	void		*ptr;
+	size_t		kmsize = maxsize;
+
+	while (!(ptr = kmem_zalloc_large(kmsize))) {
+		if ((kmsize >>= 1) <= minsize)
+			kmsize = minsize;
+	}
+	if (ptr)
+		*size = kmsize;
+	return ptr;
+}
+
+void *
+kmem_alloc(size_t size, unsigned int __nocast flags)
+{
+	int	retries = 0;
+	gfp_t	lflags = kmem_flags_convert(flags);
+	void	*ptr;
+
+	do {
+		ptr = kmalloc(size, lflags);
+		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+			return ptr;
+		if (!(++retries % 100))
+			xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
+					__func__, lflags);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+	} while (1);
+}
+
+void *
+kmem_zalloc(size_t size, unsigned int __nocast flags)
+{
+	void	*ptr;
+
+	ptr = kmem_alloc(size, flags);
+	if (ptr)
+		memset((char *)ptr, 0, (int)size);
+	return ptr;
+}
+
+void
+kmem_free(const void *ptr)
+{
+	if (!is_vmalloc_addr(ptr)) {
+		kfree(ptr);
+	} else {
+		vfree(ptr);
+	}
+}
+
+void *
+kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
+	     unsigned int __nocast flags)
+{
+	void	*new;
+
+	new = kmem_alloc(newsize, flags);
+	if (ptr) {
+		if (new)
+			memcpy(new, ptr,
+				((oldsize < newsize) ? oldsize : newsize));
+		kmem_free(ptr);
+	}
+	return new;
+}
+
+void *
+kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
+{
+	int	retries = 0;
+	gfp_t	lflags = kmem_flags_convert(flags);
+	void	*ptr;
+
+	do {
+		ptr = kmem_cache_alloc(zone, lflags);
+		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+			return ptr;
+		if (!(++retries % 100))
+			xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
+					__func__, lflags);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+	} while (1);
+}
+
+void *
+kmem_zone_zalloc(kmem_zone_t *zone, unsigned int __nocast flags)
+{
+	void	*ptr;
+
+	ptr = kmem_zone_alloc(zone, flags);
+	if (ptr)
+		memset((char *)ptr, 0, kmem_cache_size(zone));
+	return ptr;
+}
diff --git a/fs/xfs/linux/kmem.h b/fs/xfs/linux/kmem.h
new file mode 100644
index 0000000..f7c8f7a
--- /dev/null
+++ b/fs/xfs/linux/kmem.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SUPPORT_KMEM_H__
+#define __XFS_SUPPORT_KMEM_H__
+
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+
+/*
+ * General memory allocation interfaces
+ */
+
+#define KM_SLEEP	0x0001u
+#define KM_NOSLEEP	0x0002u
+#define KM_NOFS		0x0004u
+#define KM_MAYFAIL	0x0008u
+
+/*
+ * We use a special process flag to avoid recursive callbacks into
+ * the filesystem during transactions.  We will also issue our own
+ * warnings, so we explicitly skip any generic ones (silly of us).
+ */
+static inline gfp_t
+kmem_flags_convert(unsigned int __nocast flags)
+{
+	gfp_t	lflags;
+
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+
+	if (flags & KM_NOSLEEP) {
+		lflags = GFP_ATOMIC | __GFP_NOWARN;
+	} else {
+		lflags = GFP_KERNEL | __GFP_NOWARN;
+		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+			lflags &= ~__GFP_FS;
+	}
+	return lflags;
+}
+
+extern void *kmem_alloc(size_t, unsigned int __nocast);
+extern void *kmem_zalloc(size_t, unsigned int __nocast);
+extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
+extern void  kmem_free(const void *);
+
+static inline void *kmem_zalloc_large(size_t size)
+{
+	void *ptr;
+
+	ptr = vmalloc(size);
+	if (ptr)
+		memset(ptr, 0, size);
+	return ptr;
+}
+static inline void kmem_free_large(void *ptr)
+{
+	vfree(ptr);
+}
+
+extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
+
+/*
+ * Zone interfaces
+ */
+
+#define KM_ZONE_HWALIGN	SLAB_HWCACHE_ALIGN
+#define KM_ZONE_RECLAIM	SLAB_RECLAIM_ACCOUNT
+#define KM_ZONE_SPREAD	SLAB_MEM_SPREAD
+
+#define kmem_zone	kmem_cache
+#define kmem_zone_t	struct kmem_cache
+
+static inline kmem_zone_t *
+kmem_zone_init(int size, char *zone_name)
+{
+	return kmem_cache_create(zone_name, size, 0, 0, NULL);
+}
+
+static inline kmem_zone_t *
+kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
+		     void (*construct)(void *))
+{
+	return kmem_cache_create(zone_name, size, 0, flags, construct);
+}
+
+static inline void
+kmem_zone_free(kmem_zone_t *zone, void *ptr)
+{
+	kmem_cache_free(zone, ptr);
+}
+
+static inline void
+kmem_zone_destroy(kmem_zone_t *zone)
+{
+	if (zone)
+		kmem_cache_destroy(zone);
+}
+
+extern void *kmem_zone_alloc(kmem_zone_t *, unsigned int __nocast);
+extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
+
+static inline int
+kmem_shake_allow(gfp_t gfp_mask)
+{
+	return ((gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS));
+}
+
+#endif /* __XFS_SUPPORT_KMEM_H__ */
diff --git a/fs/xfs/linux/mrlock.h b/fs/xfs/linux/mrlock.h
new file mode 100644
index 0000000..ff6a198
--- /dev/null
+++ b/fs/xfs/linux/mrlock.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SUPPORT_MRLOCK_H__
+#define __XFS_SUPPORT_MRLOCK_H__
+
+#include <linux/rwsem.h>
+
+typedef struct {
+	struct rw_semaphore	mr_lock;
+#ifdef DEBUG
+	int			mr_writer;
+#endif
+} mrlock_t;
+
+#ifdef DEBUG
+#define mrinit(mrp, name)	\
+	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
+#else
+#define mrinit(mrp, name)	\
+	do { init_rwsem(&(mrp)->mr_lock); } while (0)
+#endif
+
+#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
+#define mrfree(mrp)		do { } while (0)
+
+static inline void mraccess_nested(mrlock_t *mrp, int subclass)
+{
+	down_read_nested(&mrp->mr_lock, subclass);
+}
+
+static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
+{
+	down_write_nested(&mrp->mr_lock, subclass);
+#ifdef DEBUG
+	mrp->mr_writer = 1;
+#endif
+}
+
+static inline int mrtryaccess(mrlock_t *mrp)
+{
+	return down_read_trylock(&mrp->mr_lock);
+}
+
+static inline int mrtryupdate(mrlock_t *mrp)
+{
+	if (!down_write_trylock(&mrp->mr_lock))
+		return 0;
+#ifdef DEBUG
+	mrp->mr_writer = 1;
+#endif
+	return 1;
+}
+
+static inline void mrunlock_excl(mrlock_t *mrp)
+{
+#ifdef DEBUG
+	mrp->mr_writer = 0;
+#endif
+	up_write(&mrp->mr_lock);
+}
+
+static inline void mrunlock_shared(mrlock_t *mrp)
+{
+	up_read(&mrp->mr_lock);
+}
+
+static inline void mrdemote(mrlock_t *mrp)
+{
+#ifdef DEBUG
+	mrp->mr_writer = 0;
+#endif
+	downgrade_write(&mrp->mr_lock);
+}
+
+#endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/linux/time.h b/fs/xfs/linux/time.h
new file mode 100644
index 0000000..387e695
--- /dev/null
+++ b/fs/xfs/linux/time.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SUPPORT_TIME_H__
+#define __XFS_SUPPORT_TIME_H__
+
+#include <linux/sched.h>
+#include <linux/time.h>
+
+typedef struct timespec timespec_t;
+
+static inline void delay(long ticks)
+{
+	schedule_timeout_uninterruptible(ticks);
+}
+
+static inline void nanotime(struct timespec *tvp)
+{
+	*tvp = CURRENT_TIME;
+}
+
+#endif /* __XFS_SUPPORT_TIME_H__ */
diff --git a/fs/xfs/linux/xfs_acl.c b/fs/xfs/linux/xfs_acl.c
new file mode 100644
index 0000000..115ac69
--- /dev/null
+++ b/fs/xfs/linux/xfs_acl.c
@@ -0,0 +1,462 @@
+/*
+ * Copyright (c) 2008, Christoph Hellwig
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_acl.h"
+#include "xfs_attr.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_vnodeops.h"
+#include "xfs_trace.h"
+#include <linux/slab.h>
+#include <linux/xattr.h>
+#include <linux/posix_acl_xattr.h>
+
+
+/*
+ * Locking scheme:
+ *  - all ACL updates are protected by inode->i_mutex, which is taken before
+ *    calling into this file.
+ */
+
+STATIC struct posix_acl *
+xfs_acl_from_disk(struct xfs_acl *aclp)
+{
+	struct posix_acl_entry *acl_e;
+	struct posix_acl *acl;
+	struct xfs_acl_entry *ace;
+	int count, i;
+
+	count = be32_to_cpu(aclp->acl_cnt);
+
+	acl = posix_acl_alloc(count, GFP_KERNEL);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < count; i++) {
+		acl_e = &acl->a_entries[i];
+		ace = &aclp->acl_entry[i];
+
+		/*
+		 * The tag is 32 bits on disk and 16 bits in core.
+		 *
+		 * Because every access to it goes through the core
+		 * format first this is not a problem.
+		 */
+		acl_e->e_tag = be32_to_cpu(ace->ae_tag);
+		acl_e->e_perm = be16_to_cpu(ace->ae_perm);
+
+		switch (acl_e->e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			acl_e->e_id = ACL_UNDEFINED_ID;
+			break;
+		default:
+			goto fail;
+		}
+	}
+	return acl;
+
+fail:
+	posix_acl_release(acl);
+	return ERR_PTR(-EINVAL);
+}
+
+STATIC void
+xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
+{
+	const struct posix_acl_entry *acl_e;
+	struct xfs_acl_entry *ace;
+	int i;
+
+	aclp->acl_cnt = cpu_to_be32(acl->a_count);
+	for (i = 0; i < acl->a_count; i++) {
+		ace = &aclp->acl_entry[i];
+		acl_e = &acl->a_entries[i];
+
+		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
+		ace->ae_id = cpu_to_be32(acl_e->e_id);
+		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
+	}
+}
+
+struct posix_acl *
+xfs_get_acl(struct inode *inode, int type)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl *acl;
+	struct xfs_acl *xfs_acl;
+	int len = sizeof(struct xfs_acl);
+	unsigned char *ea_name;
+	int error;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_name = SGI_ACL_FILE;
+		break;
+	case ACL_TYPE_DEFAULT:
+		ea_name = SGI_ACL_DEFAULT;
+		break;
+	default:
+		BUG();
+	}
+
+	/*
+	 * If we have a cached ACLs value just return it, not need to
+	 * go out to the disk.
+	 */
+
+	xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+	if (!xfs_acl)
+		return ERR_PTR(-ENOMEM);
+
+	error = -xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
+							&len, ATTR_ROOT);
+	if (error) {
+		/*
+		 * If the attribute doesn't exist make sure we have a negative
+		 * cache entry, for any other error assume it is transient and
+		 * leave the cache entry as ACL_NOT_CACHED.
+		 */
+		if (error == -ENOATTR) {
+			acl = NULL;
+			goto out_update_cache;
+		}
+		goto out;
+	}
+
+	acl = xfs_acl_from_disk(xfs_acl);
+	if (IS_ERR(acl))
+		goto out;
+
+ out_update_cache:
+	set_cached_acl(inode, type, acl);
+ out:
+	kfree(xfs_acl);
+	return acl;
+}
+
+STATIC int
+xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	unsigned char *ea_name;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_name = SGI_ACL_FILE;
+		break;
+	case ACL_TYPE_DEFAULT:
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		ea_name = SGI_ACL_DEFAULT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
+		struct xfs_acl *xfs_acl;
+		int len;
+
+		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+		if (!xfs_acl)
+			return -ENOMEM;
+
+		xfs_acl_to_disk(xfs_acl, acl);
+		len = sizeof(struct xfs_acl) -
+			(sizeof(struct xfs_acl_entry) *
+			 (XFS_ACL_MAX_ENTRIES - acl->a_count));
+
+		error = -xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
+				len, ATTR_ROOT);
+
+		kfree(xfs_acl);
+	} else {
+		/*
+		 * A NULL ACL argument means we want to remove the ACL.
+		 */
+		error = -xfs_attr_remove(ip, ea_name, ATTR_ROOT);
+
+		/*
+		 * If the attribute didn't exist to start with that's fine.
+		 */
+		if (error == -ENOATTR)
+			error = 0;
+	}
+
+	if (!error)
+		set_cached_acl(inode, type, acl);
+	return error;
+}
+
+int
+xfs_check_acl(struct inode *inode, int mask, unsigned int flags)
+{
+	struct xfs_inode *ip;
+	struct posix_acl *acl;
+	int error = -EAGAIN;
+
+	ip = XFS_I(inode);
+	trace_xfs_check_acl(ip);
+
+	/*
+	 * If there is no attribute fork no ACL exists on this inode and
+	 * we can skip the whole exercise.
+	 */
+	if (!XFS_IFORK_Q(ip))
+		return -EAGAIN;
+
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
+
+	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		error = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+	}
+
+	return error;
+}
+
+static int
+xfs_set_mode(struct inode *inode, mode_t mode)
+{
+	int error = 0;
+
+	if (mode != inode->i_mode) {
+		struct iattr iattr;
+
+		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
+		iattr.ia_mode = mode;
+		iattr.ia_ctime = current_fs_time(inode->i_sb);
+
+		error = -xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
+	}
+
+	return error;
+}
+
+static int
+xfs_acl_exists(struct inode *inode, unsigned char *name)
+{
+	int len = sizeof(struct xfs_acl);
+
+	return (xfs_attr_get(XFS_I(inode), name, NULL, &len,
+			    ATTR_ROOT|ATTR_KERNOVAL) == 0);
+}
+
+int
+posix_acl_access_exists(struct inode *inode)
+{
+	return xfs_acl_exists(inode, SGI_ACL_FILE);
+}
+
+int
+posix_acl_default_exists(struct inode *inode)
+{
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
+}
+
+/*
+ * No need for i_mutex because the inode is not yet exposed to the VFS.
+ */
+int
+xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl)
+{
+	struct posix_acl *clone;
+	mode_t mode;
+	int error = 0, inherit = 0;
+
+	if (S_ISDIR(inode->i_mode)) {
+		error = xfs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl);
+		if (error)
+			return error;
+	}
+
+	clone = posix_acl_clone(default_acl, GFP_KERNEL);
+	if (!clone)
+		return -ENOMEM;
+
+	mode = inode->i_mode;
+	error = posix_acl_create_masq(clone, &mode);
+	if (error < 0)
+		goto out_release_clone;
+
+	/*
+	 * If posix_acl_create_masq returns a positive value we need to
+	 * inherit a permission that can't be represented using the Unix
+	 * mode bits and we actually need to set an ACL.
+	 */
+	if (error > 0)
+		inherit = 1;
+
+	error = xfs_set_mode(inode, mode);
+	if (error)
+		goto out_release_clone;
+
+	if (inherit)
+		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
+
+ out_release_clone:
+	posix_acl_release(clone);
+	return error;
+}
+
+int
+xfs_acl_chmod(struct inode *inode)
+{
+	struct posix_acl *acl, *clone;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+
+	error = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!error)
+		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
+
+	posix_acl_release(clone);
+	return error;
+}
+
+static int
+xfs_xattr_acl_get(struct dentry *dentry, const char *name,
+		void *value, size_t size, int type)
+{
+	struct posix_acl *acl;
+	int error;
+
+	acl = xfs_get_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	error = posix_acl_to_xattr(acl, value, size);
+	posix_acl_release(acl);
+
+	return error;
+}
+
+static int
+xfs_xattr_acl_set(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
+{
+	struct inode *inode = dentry->d_inode;
+	struct posix_acl *acl = NULL;
+	int error = 0;
+
+	if (flags & XATTR_CREATE)
+		return -EINVAL;
+	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
+		return value ? -EACCES : 0;
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+		return -EPERM;
+
+	if (!value)
+		goto set_acl;
+
+	acl = posix_acl_from_xattr(value, size);
+	if (!acl) {
+		/*
+		 * acl_set_file(3) may request that we set default ACLs with
+		 * zero length -- defend (gracefully) against that here.
+		 */
+		goto out;
+	}
+	if (IS_ERR(acl)) {
+		error = PTR_ERR(acl);
+		goto out;
+	}
+
+	error = posix_acl_valid(acl);
+	if (error)
+		goto out_release;
+
+	error = -EINVAL;
+	if (acl->a_count > XFS_ACL_MAX_ENTRIES)
+		goto out_release;
+
+	if (type == ACL_TYPE_ACCESS) {
+		mode_t mode = inode->i_mode;
+		error = posix_acl_equiv_mode(acl, &mode);
+
+		if (error <= 0) {
+			posix_acl_release(acl);
+			acl = NULL;
+
+			if (error < 0)
+				return error;
+		}
+
+		error = xfs_set_mode(inode, mode);
+		if (error)
+			goto out_release;
+	}
+
+ set_acl:
+	error = xfs_set_acl(inode, type, acl);
+ out_release:
+	posix_acl_release(acl);
+ out:
+	return error;
+}
+
+const struct xattr_handler xfs_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
+
+const struct xattr_handler xfs_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
diff --git a/fs/xfs/linux/xfs_aops.c b/fs/xfs/linux/xfs_aops.c
new file mode 100644
index 0000000..26384fe
--- /dev/null
+++ b/fs/xfs/linux/xfs_aops.c
@@ -0,0 +1,1496 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_trans.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_rw.h"
+#include "xfs_iomap.h"
+#include "xfs_vnodeops.h"
+#include "xfs_trace.h"
+#include "xfs_bmap.h"
+#include <linux/gfp.h>
+#include <linux/mpage.h>
+#include <linux/pagevec.h>
+#include <linux/writeback.h>
+
+
+/*
+ * Prime number of hash buckets since address is used as the key.
+ */
+#define NVSYNC		37
+#define to_ioend_wq(v)	(&xfs_ioend_wq[((unsigned long)v) % NVSYNC])
+static wait_queue_head_t xfs_ioend_wq[NVSYNC];
+
+void __init
+xfs_ioend_init(void)
+{
+	int i;
+
+	for (i = 0; i < NVSYNC; i++)
+		init_waitqueue_head(&xfs_ioend_wq[i]);
+}
+
+void
+xfs_ioend_wait(
+	xfs_inode_t	*ip)
+{
+	wait_queue_head_t *wq = to_ioend_wq(ip);
+
+	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
+}
+
+STATIC void
+xfs_ioend_wake(
+	xfs_inode_t	*ip)
+{
+	if (atomic_dec_and_test(&ip->i_iocount))
+		wake_up(to_ioend_wq(ip));
+}
+
+void
+xfs_count_page_state(
+	struct page		*page,
+	int			*delalloc,
+	int			*unwritten)
+{
+	struct buffer_head	*bh, *head;
+
+	*delalloc = *unwritten = 0;
+
+	bh = head = page_buffers(page);
+	do {
+		if (buffer_unwritten(bh))
+			(*unwritten) = 1;
+		else if (buffer_delay(bh))
+			(*delalloc) = 1;
+	} while ((bh = bh->b_this_page) != head);
+}
+
+STATIC struct block_device *
+xfs_find_bdev_for_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		return mp->m_rtdev_targp->bt_bdev;
+	else
+		return mp->m_ddev_targp->bt_bdev;
+}
+
+/*
+ * We're now finished for good with this ioend structure.
+ * Update the page state via the associated buffer_heads,
+ * release holds on the inode and bio, and finally free
+ * up memory.  Do not use the ioend after this.
+ */
+STATIC void
+xfs_destroy_ioend(
+	xfs_ioend_t		*ioend)
+{
+	struct buffer_head	*bh, *next;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+
+	for (bh = ioend->io_buffer_head; bh; bh = next) {
+		next = bh->b_private;
+		bh->b_end_io(bh, !ioend->io_error);
+	}
+
+	/*
+	 * Volume managers supporting multiple paths can send back ENODEV
+	 * when the final path disappears.  In this case continuing to fill
+	 * the page cache with dirty data which cannot be written out is
+	 * evil, so prevent that.
+	 */
+	if (unlikely(ioend->io_error == -ENODEV)) {
+		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ,
+				      __FILE__, __LINE__);
+	}
+
+	xfs_ioend_wake(ip);
+	mempool_free(ioend, xfs_ioend_pool);
+}
+
+/*
+ * If the end of the current ioend is beyond the current EOF,
+ * return the new EOF value, otherwise zero.
+ */
+STATIC xfs_fsize_t
+xfs_ioend_new_eof(
+	xfs_ioend_t		*ioend)
+{
+	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	xfs_fsize_t		isize;
+	xfs_fsize_t		bsize;
+
+	bsize = ioend->io_offset + ioend->io_size;
+	isize = MAX(ip->i_size, ip->i_new_size);
+	isize = MIN(isize, bsize);
+	return isize > ip->i_d.di_size ? isize : 0;
+}
+
+/*
+ * Update on-disk file size now that data has been written to disk.  The
+ * current in-memory file size is i_size.  If a write is beyond eof i_new_size
+ * will be the intended file size until i_size is updated.  If this write does
+ * not extend all the way to the valid file size then restrict this update to
+ * the end of the write.
+ *
+ * This function does not block as blocking on the inode lock in IO completion
+ * can lead to IO completion order dependency deadlocks.. If it can't get the
+ * inode ilock it will return EAGAIN. Callers must handle this.
+ */
+STATIC int
+xfs_setfilesize(
+	xfs_ioend_t		*ioend)
+{
+	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	xfs_fsize_t		isize;
+
+	if (unlikely(ioend->io_error))
+		return 0;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return EAGAIN;
+
+	isize = xfs_ioend_new_eof(ioend);
+	if (isize) {
+		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+		ip->i_d.di_size = isize;
+		xfs_mark_inode_dirty(ip);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Schedule IO completion handling on the final put of an ioend.
+ */
+STATIC void
+xfs_finish_ioend(
+	struct xfs_ioend	*ioend)
+{
+	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		if (ioend->io_type == IO_UNWRITTEN)
+			queue_work(xfsconvertd_workqueue, &ioend->io_work);
+		else
+			queue_work(xfsdatad_workqueue, &ioend->io_work);
+	}
+}
+
+/*
+ * IO write completion.
+ */
+STATIC void
+xfs_end_io(
+	struct work_struct *work)
+{
+	xfs_ioend_t	*ioend = container_of(work, xfs_ioend_t, io_work);
+	struct xfs_inode *ip = XFS_I(ioend->io_inode);
+	int		error = 0;
+
+	/*
+	 * For unwritten extents we need to issue transactions to convert a
+	 * range to normal written extens after the data I/O has finished.
+	 */
+	if (ioend->io_type == IO_UNWRITTEN &&
+	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
+
+		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
+						 ioend->io_size);
+		if (error)
+			ioend->io_error = error;
+	}
+
+	/*
+	 * We might have to update the on-disk file size after extending
+	 * writes.
+	 */
+	error = xfs_setfilesize(ioend);
+	ASSERT(!error || error == EAGAIN);
+
+	/*
+	 * If we didn't complete processing of the ioend, requeue it to the
+	 * tail of the workqueue for another attempt later. Otherwise destroy
+	 * it.
+	 */
+	if (error == EAGAIN) {
+		atomic_inc(&ioend->io_remaining);
+		xfs_finish_ioend(ioend);
+		/* ensure we don't spin on blocked ioends */
+		delay(1);
+	} else {
+		if (ioend->io_iocb)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
+		xfs_destroy_ioend(ioend);
+	}
+}
+
+/*
+ * Call IO completion handling in caller context on the final put of an ioend.
+ */
+STATIC void
+xfs_finish_ioend_sync(
+	struct xfs_ioend	*ioend)
+{
+	if (atomic_dec_and_test(&ioend->io_remaining))
+		xfs_end_io(&ioend->io_work);
+}
+
+/*
+ * Allocate and initialise an IO completion structure.
+ * We need to track unwritten extent write completion here initially.
+ * We'll need to extend this for updating the ondisk inode size later
+ * (vs. incore size).
+ */
+STATIC xfs_ioend_t *
+xfs_alloc_ioend(
+	struct inode		*inode,
+	unsigned int		type)
+{
+	xfs_ioend_t		*ioend;
+
+	ioend = mempool_alloc(xfs_ioend_pool, GFP_NOFS);
+
+	/*
+	 * Set the count to 1 initially, which will prevent an I/O
+	 * completion callback from happening before we have started
+	 * all the I/O from calling the completion routine too early.
+	 */
+	atomic_set(&ioend->io_remaining, 1);
+	ioend->io_error = 0;
+	ioend->io_list = NULL;
+	ioend->io_type = type;
+	ioend->io_inode = inode;
+	ioend->io_buffer_head = NULL;
+	ioend->io_buffer_tail = NULL;
+	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
+	ioend->io_offset = 0;
+	ioend->io_size = 0;
+	ioend->io_iocb = NULL;
+	ioend->io_result = 0;
+
+	INIT_WORK(&ioend->io_work, xfs_end_io);
+	return ioend;
+}
+
+STATIC int
+xfs_map_blocks(
+	struct inode		*inode,
+	loff_t			offset,
+	struct xfs_bmbt_irec	*imap,
+	int			type,
+	int			nonblocking)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	ssize_t			count = 1 << inode->i_blkbits;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error = 0;
+	int			bmapi_flags = XFS_BMAPI_ENTIRE;
+	int			nimaps = 1;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	if (type == IO_UNWRITTEN)
+		bmapi_flags |= XFS_BMAPI_IGSTATE;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		if (nonblocking)
+			return -XFS_ERROR(EAGAIN);
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+	}
+
+	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	       (ip->i_df.if_flags & XFS_IFEXTENTS));
+	ASSERT(offset <= mp->m_maxioffset);
+
+	if (offset + count > mp->m_maxioffset)
+		count = mp->m_maxioffset - offset;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
+			  bmapi_flags,  NULL, 0, imap, &nimaps, NULL);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (error)
+		return -XFS_ERROR(error);
+
+	if (type == IO_DELALLOC &&
+	    (!nimaps || isnullstartblock(imap->br_startblock))) {
+		error = xfs_iomap_write_allocate(ip, offset, count, imap);
+		if (!error)
+			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
+		return -XFS_ERROR(error);
+	}
+
+#ifdef DEBUG
+	if (type == IO_UNWRITTEN) {
+		ASSERT(nimaps);
+		ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+		ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
+	}
+#endif
+	if (nimaps)
+		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+	return 0;
+}
+
+STATIC int
+xfs_imap_valid(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	offset >>= inode->i_blkbits;
+
+	return offset >= imap->br_startoff &&
+		offset < imap->br_startoff + imap->br_blockcount;
+}
+
+/*
+ * BIO completion handler for buffered IO.
+ */
+STATIC void
+xfs_end_bio(
+	struct bio		*bio,
+	int			error)
+{
+	xfs_ioend_t		*ioend = bio->bi_private;
+
+	ASSERT(atomic_read(&bio->bi_cnt) >= 1);
+	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
+
+	/* Toss bio and pass work off to an xfsdatad thread */
+	bio->bi_private = NULL;
+	bio->bi_end_io = NULL;
+	bio_put(bio);
+
+	xfs_finish_ioend(ioend);
+}
+
+STATIC void
+xfs_submit_ioend_bio(
+	struct writeback_control *wbc,
+	xfs_ioend_t		*ioend,
+	struct bio		*bio)
+{
+	atomic_inc(&ioend->io_remaining);
+	bio->bi_private = ioend;
+	bio->bi_end_io = xfs_end_bio;
+
+	/*
+	 * If the I/O is beyond EOF we mark the inode dirty immediately
+	 * but don't update the inode size until I/O completion.
+	 */
+	if (xfs_ioend_new_eof(ioend))
+		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
+
+	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
+}
+
+STATIC struct bio *
+xfs_alloc_ioend_bio(
+	struct buffer_head	*bh)
+{
+	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
+	struct bio		*bio = bio_alloc(GFP_NOIO, nvecs);
+
+	ASSERT(bio->bi_private == NULL);
+	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_bdev = bh->b_bdev;
+	return bio;
+}
+
+STATIC void
+xfs_start_buffer_writeback(
+	struct buffer_head	*bh)
+{
+	ASSERT(buffer_mapped(bh));
+	ASSERT(buffer_locked(bh));
+	ASSERT(!buffer_delay(bh));
+	ASSERT(!buffer_unwritten(bh));
+
+	mark_buffer_async_write(bh);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
+}
+
+STATIC void
+xfs_start_page_writeback(
+	struct page		*page,
+	int			clear_dirty,
+	int			buffers)
+{
+	ASSERT(PageLocked(page));
+	ASSERT(!PageWriteback(page));
+	if (clear_dirty)
+		clear_page_dirty_for_io(page);
+	set_page_writeback(page);
+	unlock_page(page);
+	/* If no buffers on the page are to be written, finish it here */
+	if (!buffers)
+		end_page_writeback(page);
+}
+
+static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
+{
+	return bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
+}
+
+/*
+ * Submit all of the bios for all of the ioends we have saved up, covering the
+ * initial writepage page and also any probed pages.
+ *
+ * Because we may have multiple ioends spanning a page, we need to start
+ * writeback on all the buffers before we submit them for I/O. If we mark the
+ * buffers as we got, then we can end up with a page that only has buffers
+ * marked async write and I/O complete on can occur before we mark the other
+ * buffers async write.
+ *
+ * The end result of this is that we trip a bug in end_page_writeback() because
+ * we call it twice for the one page as the code in end_buffer_async_write()
+ * assumes that all buffers on the page are started at the same time.
+ *
+ * The fix is two passes across the ioend list - one to start writeback on the
+ * buffer_heads, and then submit them for I/O on the second pass.
+ */
+STATIC void
+xfs_submit_ioend(
+	struct writeback_control *wbc,
+	xfs_ioend_t		*ioend)
+{
+	xfs_ioend_t		*head = ioend;
+	xfs_ioend_t		*next;
+	struct buffer_head	*bh;
+	struct bio		*bio;
+	sector_t		lastblock = 0;
+
+	/* Pass 1 - start writeback */
+	do {
+		next = ioend->io_list;
+		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private)
+			xfs_start_buffer_writeback(bh);
+	} while ((ioend = next) != NULL);
+
+	/* Pass 2 - submit I/O */
+	ioend = head;
+	do {
+		next = ioend->io_list;
+		bio = NULL;
+
+		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
+
+			if (!bio) {
+ retry:
+				bio = xfs_alloc_ioend_bio(bh);
+			} else if (bh->b_blocknr != lastblock + 1) {
+				xfs_submit_ioend_bio(wbc, ioend, bio);
+				goto retry;
+			}
+
+			if (bio_add_buffer(bio, bh) != bh->b_size) {
+				xfs_submit_ioend_bio(wbc, ioend, bio);
+				goto retry;
+			}
+
+			lastblock = bh->b_blocknr;
+		}
+		if (bio)
+			xfs_submit_ioend_bio(wbc, ioend, bio);
+		xfs_finish_ioend(ioend);
+	} while ((ioend = next) != NULL);
+}
+
+/*
+ * Cancel submission of all buffer_heads so far in this endio.
+ * Toss the endio too.  Only ever called for the initial page
+ * in a writepage request, so only ever one page.
+ */
+STATIC void
+xfs_cancel_ioend(
+	xfs_ioend_t		*ioend)
+{
+	xfs_ioend_t		*next;
+	struct buffer_head	*bh, *next_bh;
+
+	do {
+		next = ioend->io_list;
+		bh = ioend->io_buffer_head;
+		do {
+			next_bh = bh->b_private;
+			clear_buffer_async_write(bh);
+			unlock_buffer(bh);
+		} while ((bh = next_bh) != NULL);
+
+		xfs_ioend_wake(XFS_I(ioend->io_inode));
+		mempool_free(ioend, xfs_ioend_pool);
+	} while ((ioend = next) != NULL);
+}
+
+/*
+ * Test to see if we've been building up a completion structure for
+ * earlier buffers -- if so, we try to append to this ioend if we
+ * can, otherwise we finish off any current ioend and start another.
+ * Return true if we've finished the given ioend.
+ */
+STATIC void
+xfs_add_to_ioend(
+	struct inode		*inode,
+	struct buffer_head	*bh,
+	xfs_off_t		offset,
+	unsigned int		type,
+	xfs_ioend_t		**result,
+	int			need_ioend)
+{
+	xfs_ioend_t		*ioend = *result;
+
+	if (!ioend || need_ioend || type != ioend->io_type) {
+		xfs_ioend_t	*previous = *result;
+
+		ioend = xfs_alloc_ioend(inode, type);
+		ioend->io_offset = offset;
+		ioend->io_buffer_head = bh;
+		ioend->io_buffer_tail = bh;
+		if (previous)
+			previous->io_list = ioend;
+		*result = ioend;
+	} else {
+		ioend->io_buffer_tail->b_private = bh;
+		ioend->io_buffer_tail = bh;
+	}
+
+	bh->b_private = NULL;
+	ioend->io_size += bh->b_size;
+}
+
+STATIC void
+xfs_map_buffer(
+	struct inode		*inode,
+	struct buffer_head	*bh,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	sector_t		bn;
+	struct xfs_mount	*m = XFS_I(inode)->i_mount;
+	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap->br_startoff);
+	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
+
+	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
+
+	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
+	      ((offset - iomap_offset) >> inode->i_blkbits);
+
+	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
+
+	bh->b_blocknr = bn;
+	set_buffer_mapped(bh);
+}
+
+STATIC void
+xfs_map_at_offset(
+	struct inode		*inode,
+	struct buffer_head	*bh,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
+
+	xfs_map_buffer(inode, bh, imap, offset);
+	set_buffer_mapped(bh);
+	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
+}
+
+/*
+ * Test if a given page is suitable for writing as part of an unwritten
+ * or delayed allocate extent.
+ */
+STATIC int
+xfs_is_delayed_page(
+	struct page		*page,
+	unsigned int		type)
+{
+	if (PageWriteback(page))
+		return 0;
+
+	if (page->mapping && page_has_buffers(page)) {
+		struct buffer_head	*bh, *head;
+		int			acceptable = 0;
+
+		bh = head = page_buffers(page);
+		do {
+			if (buffer_unwritten(bh))
+				acceptable = (type == IO_UNWRITTEN);
+			else if (buffer_delay(bh))
+				acceptable = (type == IO_DELALLOC);
+			else if (buffer_dirty(bh) && buffer_mapped(bh))
+				acceptable = (type == IO_OVERWRITE);
+			else
+				break;
+		} while ((bh = bh->b_this_page) != head);
+
+		if (acceptable)
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Allocate & map buffers for page given the extent map. Write it out.
+ * except for the original page of a writepage, this is called on
+ * delalloc/unwritten pages only, for the original page it is possible
+ * that the page has no mapping at all.
+ */
+STATIC int
+xfs_convert_page(
+	struct inode		*inode,
+	struct page		*page,
+	loff_t			tindex,
+	struct xfs_bmbt_irec	*imap,
+	xfs_ioend_t		**ioendp,
+	struct writeback_control *wbc)
+{
+	struct buffer_head	*bh, *head;
+	xfs_off_t		end_offset;
+	unsigned long		p_offset;
+	unsigned int		type;
+	int			len, page_dirty;
+	int			count = 0, done = 0, uptodate = 1;
+ 	xfs_off_t		offset = page_offset(page);
+
+	if (page->index != tindex)
+		goto fail;
+	if (!trylock_page(page))
+		goto fail;
+	if (PageWriteback(page))
+		goto fail_unlock_page;
+	if (page->mapping != inode->i_mapping)
+		goto fail_unlock_page;
+	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
+		goto fail_unlock_page;
+
+	/*
+	 * page_dirty is initially a count of buffers on the page before
+	 * EOF and is decremented as we move each into a cleanable state.
+	 *
+	 * Derivation:
+	 *
+	 * End offset is the highest offset that this page should represent.
+	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
+	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
+	 * hence give us the correct page_dirty count. On any other page,
+	 * it will be zero and in that case we need page_dirty to be the
+	 * count of buffers on the page.
+	 */
+	end_offset = min_t(unsigned long long,
+			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
+			i_size_read(inode));
+
+	len = 1 << inode->i_blkbits;
+	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
+					PAGE_CACHE_SIZE);
+	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
+	page_dirty = p_offset / len;
+
+	bh = head = page_buffers(page);
+	do {
+		if (offset >= end_offset)
+			break;
+		if (!buffer_uptodate(bh))
+			uptodate = 0;
+		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
+			done = 1;
+			continue;
+		}
+
+		if (buffer_unwritten(bh) || buffer_delay(bh) ||
+		    buffer_mapped(bh)) {
+			if (buffer_unwritten(bh))
+				type = IO_UNWRITTEN;
+			else if (buffer_delay(bh))
+				type = IO_DELALLOC;
+			else
+				type = IO_OVERWRITE;
+
+			if (!xfs_imap_valid(inode, imap, offset)) {
+				done = 1;
+				continue;
+			}
+
+			lock_buffer(bh);
+			if (type != IO_OVERWRITE)
+				xfs_map_at_offset(inode, bh, imap, offset);
+			xfs_add_to_ioend(inode, bh, offset, type,
+					 ioendp, done);
+
+			page_dirty--;
+			count++;
+		} else {
+			done = 1;
+		}
+	} while (offset += len, (bh = bh->b_this_page) != head);
+
+	if (uptodate && bh == head)
+		SetPageUptodate(page);
+
+	if (count) {
+		if (--wbc->nr_to_write <= 0 &&
+		    wbc->sync_mode == WB_SYNC_NONE)
+			done = 1;
+	}
+	xfs_start_page_writeback(page, !page_dirty, count);
+
+	return done;
+ fail_unlock_page:
+	unlock_page(page);
+ fail:
+	return 1;
+}
+
+/*
+ * Convert & write out a cluster of pages in the same extent as defined
+ * by mp and following the start page.
+ */
+STATIC void
+xfs_cluster_write(
+	struct inode		*inode,
+	pgoff_t			tindex,
+	struct xfs_bmbt_irec	*imap,
+	xfs_ioend_t		**ioendp,
+	struct writeback_control *wbc,
+	pgoff_t			tlast)
+{
+	struct pagevec		pvec;
+	int			done = 0, i;
+
+	pagevec_init(&pvec, 0);
+	while (!done && tindex <= tlast) {
+		unsigned len = min_t(pgoff_t, PAGEVEC_SIZE, tlast - tindex + 1);
+
+		if (!pagevec_lookup(&pvec, inode->i_mapping, tindex, len))
+			break;
+
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
+					imap, ioendp, wbc);
+			if (done)
+				break;
+		}
+
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
+STATIC void
+xfs_vm_invalidatepage(
+	struct page		*page,
+	unsigned long		offset)
+{
+	trace_xfs_invalidatepage(page->mapping->host, page, offset);
+	block_invalidatepage(page, offset);
+}
+
+/*
+ * If the page has delalloc buffers on it, we need to punch them out before we
+ * invalidate the page. If we don't, we leave a stale delalloc mapping on the
+ * inode that can trip a BUG() in xfs_get_blocks() later on if a direct IO read
+ * is done on that same region - the delalloc extent is returned when none is
+ * supposed to be there.
+ *
+ * We prevent this by truncating away the delalloc regions on the page before
+ * invalidating it. Because they are delalloc, we can do this without needing a
+ * transaction. Indeed - if we get ENOSPC errors, we have to be able to do this
+ * truncation without a transaction as there is no space left for block
+ * reservation (typically why we see a ENOSPC in writeback).
+ *
+ * This is not a performance critical path, so for now just do the punching a
+ * buffer head at a time.
+ */
+STATIC void
+xfs_aops_discard_page(
+	struct page		*page)
+{
+	struct inode		*inode = page->mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct buffer_head	*bh, *head;
+	loff_t			offset = page_offset(page);
+
+	if (!xfs_is_delayed_page(page, IO_DELALLOC))
+		goto out_invalidate;
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto out_invalidate;
+
+	xfs_alert(ip->i_mount,
+		"page discard on page %p, inode 0x%llx, offset %llu.",
+			page, ip->i_ino, offset);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	bh = head = page_buffers(page);
+	do {
+		int		error;
+		xfs_fileoff_t	start_fsb;
+
+		if (!buffer_delay(bh))
+			goto next_buffer;
+
+		start_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_alert(ip->i_mount,
+			"page discard unable to remove delalloc mapping.");
+			}
+			break;
+		}
+next_buffer:
+		offset += 1 << inode->i_blkbits;
+
+	} while ((bh = bh->b_this_page) != head);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_invalidate:
+	xfs_vm_invalidatepage(page, 0);
+	return;
+}
+
+/*
+ * Write out a dirty page.
+ *
+ * For delalloc space on the page we need to allocate space and flush it.
+ * For unwritten space on the page we need to start the conversion to
+ * regular allocated space.
+ * For any other dirty buffer heads on the page we should flush them.
+ */
+STATIC int
+xfs_vm_writepage(
+	struct page		*page,
+	struct writeback_control *wbc)
+{
+	struct inode		*inode = page->mapping->host;
+	struct buffer_head	*bh, *head;
+	struct xfs_bmbt_irec	imap;
+	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
+	loff_t			offset;
+	unsigned int		type;
+	__uint64_t              end_offset;
+	pgoff_t                 end_index, last_index;
+	ssize_t			len;
+	int			err, imap_valid = 0, uptodate = 1;
+	int			count = 0;
+	int			nonblocking = 0;
+
+	trace_xfs_writepage(inode, page, 0);
+
+	ASSERT(page_has_buffers(page));
+
+	/*
+	 * Refuse to write the page out if we are called from reclaim context.
+	 *
+	 * This avoids stack overflows when called from deeply used stacks in
+	 * random callers for direct reclaim or memcg reclaim.  We explicitly
+	 * allow reclaim from kswapd as the stack usage there is relatively low.
+	 *
+	 * This should really be done by the core VM, but until that happens
+	 * filesystems like XFS, btrfs and ext4 have to take care of this
+	 * by themselves.
+	 */
+	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
+		goto redirty;
+
+	/*
+	 * Given that we do not allow direct reclaim to call us, we should
+	 * never be called while in a filesystem transaction.
+	 */
+	if (WARN_ON(current->flags & PF_FSTRANS))
+		goto redirty;
+
+	/* Is this page beyond the end of the file? */
+	offset = i_size_read(inode);
+	end_index = offset >> PAGE_CACHE_SHIFT;
+	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
+	if (page->index >= end_index) {
+		if ((page->index >= end_index + 1) ||
+		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
+			unlock_page(page);
+			return 0;
+		}
+	}
+
+	end_offset = min_t(unsigned long long,
+			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
+			offset);
+	len = 1 << inode->i_blkbits;
+
+	bh = head = page_buffers(page);
+	offset = page_offset(page);
+	type = IO_OVERWRITE;
+
+	if (wbc->sync_mode == WB_SYNC_NONE)
+		nonblocking = 1;
+
+	do {
+		int new_ioend = 0;
+
+		if (offset >= end_offset)
+			break;
+		if (!buffer_uptodate(bh))
+			uptodate = 0;
+
+		/*
+		 * set_page_dirty dirties all buffers in a page, independent
+		 * of their state.  The dirty state however is entirely
+		 * meaningless for holes (!mapped && uptodate), so skip
+		 * buffers covering holes here.
+		 */
+		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
+			imap_valid = 0;
+			continue;
+		}
+
+		if (buffer_unwritten(bh)) {
+			if (type != IO_UNWRITTEN) {
+				type = IO_UNWRITTEN;
+				imap_valid = 0;
+			}
+		} else if (buffer_delay(bh)) {
+			if (type != IO_DELALLOC) {
+				type = IO_DELALLOC;
+				imap_valid = 0;
+			}
+		} else if (buffer_uptodate(bh)) {
+			if (type != IO_OVERWRITE) {
+				type = IO_OVERWRITE;
+				imap_valid = 0;
+			}
+		} else {
+			if (PageUptodate(page)) {
+				ASSERT(buffer_mapped(bh));
+				imap_valid = 0;
+			}
+			continue;
+		}
+
+		if (imap_valid)
+			imap_valid = xfs_imap_valid(inode, &imap, offset);
+		if (!imap_valid) {
+			/*
+			 * If we didn't have a valid mapping then we need to
+			 * put the new mapping into a separate ioend structure.
+			 * This ensures non-contiguous extents always have
+			 * separate ioends, which is particularly important
+			 * for unwritten extent conversion at I/O completion
+			 * time.
+			 */
+			new_ioend = 1;
+			err = xfs_map_blocks(inode, offset, &imap, type,
+					     nonblocking);
+			if (err)
+				goto error;
+			imap_valid = xfs_imap_valid(inode, &imap, offset);
+		}
+		if (imap_valid) {
+			lock_buffer(bh);
+			if (type != IO_OVERWRITE)
+				xfs_map_at_offset(inode, bh, &imap, offset);
+			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
+					 new_ioend);
+			count++;
+		}
+
+		if (!iohead)
+			iohead = ioend;
+
+	} while (offset += len, ((bh = bh->b_this_page) != head));
+
+	if (uptodate && bh == head)
+		SetPageUptodate(page);
+
+	xfs_start_page_writeback(page, 1, count);
+
+	if (ioend && imap_valid) {
+		xfs_off_t		end_index;
+
+		end_index = imap.br_startoff + imap.br_blockcount;
+
+		/* to bytes */
+		end_index <<= inode->i_blkbits;
+
+		/* to pages */
+		end_index = (end_index - 1) >> PAGE_CACHE_SHIFT;
+
+		/* check against file size */
+		if (end_index > last_index)
+			end_index = last_index;
+
+		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
+				  wbc, end_index);
+	}
+
+	if (iohead)
+		xfs_submit_ioend(wbc, iohead);
+
+	return 0;
+
+error:
+	if (iohead)
+		xfs_cancel_ioend(iohead);
+
+	if (err == -EAGAIN)
+		goto redirty;
+
+	xfs_aops_discard_page(page);
+	ClearPageUptodate(page);
+	unlock_page(page);
+	return err;
+
+redirty:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return 0;
+}
+
+STATIC int
+xfs_vm_writepages(
+	struct address_space	*mapping,
+	struct writeback_control *wbc)
+{
+	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	return generic_writepages(mapping, wbc);
+}
+
+/*
+ * Called to move a page into cleanable state - and from there
+ * to be released. The page should already be clean. We always
+ * have buffer heads in this call.
+ *
+ * Returns 1 if the page is ok to release, 0 otherwise.
+ */
+STATIC int
+xfs_vm_releasepage(
+	struct page		*page,
+	gfp_t			gfp_mask)
+{
+	int			delalloc, unwritten;
+
+	trace_xfs_releasepage(page->mapping->host, page, 0);
+
+	xfs_count_page_state(page, &delalloc, &unwritten);
+
+	if (WARN_ON(delalloc))
+		return 0;
+	if (WARN_ON(unwritten))
+		return 0;
+
+	return try_to_free_buffers(page);
+}
+
+STATIC int
+__xfs_get_blocks(
+	struct inode		*inode,
+	sector_t		iblock,
+	struct buffer_head	*bh_result,
+	int			create,
+	int			direct)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error = 0;
+	int			lockmode = 0;
+	struct xfs_bmbt_irec	imap;
+	int			nimaps = 1;
+	xfs_off_t		offset;
+	ssize_t			size;
+	int			new = 0;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	offset = (xfs_off_t)iblock << inode->i_blkbits;
+	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
+	size = bh_result->b_size;
+
+	if (!create && direct && offset >= i_size_read(inode))
+		return 0;
+
+	if (create) {
+		lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lockmode);
+	} else {
+		lockmode = xfs_ilock_map_shared(ip);
+	}
+
+	ASSERT(offset <= mp->m_maxioffset);
+	if (offset + size > mp->m_maxioffset)
+		size = mp->m_maxioffset - offset;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+
+	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
+			  XFS_BMAPI_ENTIRE,  NULL, 0, &imap, &nimaps, NULL);
+	if (error)
+		goto out_unlock;
+
+	if (create &&
+	    (!nimaps ||
+	     (imap.br_startblock == HOLESTARTBLOCK ||
+	      imap.br_startblock == DELAYSTARTBLOCK))) {
+		if (direct) {
+			error = xfs_iomap_write_direct(ip, offset, size,
+						       &imap, nimaps);
+		} else {
+			error = xfs_iomap_write_delay(ip, offset, size, &imap);
+		}
+		if (error)
+			goto out_unlock;
+
+		trace_xfs_get_blocks_alloc(ip, offset, size, 0, &imap);
+	} else if (nimaps) {
+		trace_xfs_get_blocks_found(ip, offset, size, 0, &imap);
+	} else {
+		trace_xfs_get_blocks_notfound(ip, offset, size);
+		goto out_unlock;
+	}
+	xfs_iunlock(ip, lockmode);
+
+	if (imap.br_startblock != HOLESTARTBLOCK &&
+	    imap.br_startblock != DELAYSTARTBLOCK) {
+		/*
+		 * For unwritten extents do not report a disk address on
+		 * the read case (treat as if we're reading into a hole).
+		 */
+		if (create || !ISUNWRITTEN(&imap))
+			xfs_map_buffer(inode, bh_result, &imap, offset);
+		if (create && ISUNWRITTEN(&imap)) {
+			if (direct)
+				bh_result->b_private = inode;
+			set_buffer_unwritten(bh_result);
+		}
+	}
+
+	/*
+	 * If this is a realtime file, data may be on a different device.
+	 * to that pointed to from the buffer_head b_bdev currently.
+	 */
+	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
+
+	/*
+	 * If we previously allocated a block out beyond eof and we are now
+	 * coming back to use it then we will need to flag it as new even if it
+	 * has a disk address.
+	 *
+	 * With sub-block writes into unwritten extents we also need to mark
+	 * the buffer as new so that the unwritten parts of the buffer gets
+	 * correctly zeroed.
+	 */
+	if (create &&
+	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
+	     (offset >= i_size_read(inode)) ||
+	     (new || ISUNWRITTEN(&imap))))
+		set_buffer_new(bh_result);
+
+	if (imap.br_startblock == DELAYSTARTBLOCK) {
+		BUG_ON(direct);
+		if (create) {
+			set_buffer_uptodate(bh_result);
+			set_buffer_mapped(bh_result);
+			set_buffer_delay(bh_result);
+		}
+	}
+
+	/*
+	 * If this is O_DIRECT or the mpage code calling tell them how large
+	 * the mapping is, so that we can avoid repeated get_blocks calls.
+	 */
+	if (direct || size > (1 << inode->i_blkbits)) {
+		xfs_off_t		mapping_size;
+
+		mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
+		mapping_size <<= inode->i_blkbits;
+
+		ASSERT(mapping_size > 0);
+		if (mapping_size > size)
+			mapping_size = size;
+		if (mapping_size > LONG_MAX)
+			mapping_size = LONG_MAX;
+
+		bh_result->b_size = mapping_size;
+	}
+
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+	return -error;
+}
+
+int
+xfs_get_blocks(
+	struct inode		*inode,
+	sector_t		iblock,
+	struct buffer_head	*bh_result,
+	int			create)
+{
+	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
+}
+
+STATIC int
+xfs_get_blocks_direct(
+	struct inode		*inode,
+	sector_t		iblock,
+	struct buffer_head	*bh_result,
+	int			create)
+{
+	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
+}
+
+/*
+ * Complete a direct I/O write request.
+ *
+ * If the private argument is non-NULL __xfs_get_blocks signals us that we
+ * need to issue a transaction to convert the range from unwritten to written
+ * extents.  In case this is regular synchronous I/O we just call xfs_end_io
+ * to do this and we are done.  But in case this was a successful AIO
+ * request this handler is called from interrupt context, from which we
+ * can't start transactions.  In that case offload the I/O completion to
+ * the workqueues we also use for buffered I/O completion.
+ */
+STATIC void
+xfs_end_io_direct_write(
+	struct kiocb		*iocb,
+	loff_t			offset,
+	ssize_t			size,
+	void			*private,
+	int			ret,
+	bool			is_async)
+{
+	struct xfs_ioend	*ioend = iocb->private;
+
+	/*
+	 * blockdev_direct_IO can return an error even after the I/O
+	 * completion handler was called.  Thus we need to protect
+	 * against double-freeing.
+	 */
+	iocb->private = NULL;
+
+	ioend->io_offset = offset;
+	ioend->io_size = size;
+	if (private && size > 0)
+		ioend->io_type = IO_UNWRITTEN;
+
+	if (is_async) {
+		/*
+		 * If we are converting an unwritten extent we need to delay
+		 * the AIO completion until after the unwrittent extent
+		 * conversion has completed, otherwise do it ASAP.
+		 */
+		if (ioend->io_type == IO_UNWRITTEN) {
+			ioend->io_iocb = iocb;
+			ioend->io_result = ret;
+		} else {
+			aio_complete(iocb, ret, 0);
+		}
+		xfs_finish_ioend(ioend);
+	} else {
+		xfs_finish_ioend_sync(ioend);
+	}
+}
+
+STATIC ssize_t
+xfs_vm_direct_IO(
+	int			rw,
+	struct kiocb		*iocb,
+	const struct iovec	*iov,
+	loff_t			offset,
+	unsigned long		nr_segs)
+{
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
+	ssize_t			ret;
+
+	if (rw & WRITE) {
+		iocb->private = xfs_alloc_ioend(inode, IO_DIRECT);
+
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
+					    offset, nr_segs,
+					    xfs_get_blocks_direct,
+					    xfs_end_io_direct_write, NULL, 0);
+		if (ret != -EIOCBQUEUED && iocb->private)
+			xfs_destroy_ioend(iocb->private);
+	} else {
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
+					    offset, nr_segs,
+					    xfs_get_blocks_direct,
+					    NULL, NULL, 0);
+	}
+
+	return ret;
+}
+
+STATIC void
+xfs_vm_write_failed(
+	struct address_space	*mapping,
+	loff_t			to)
+{
+	struct inode		*inode = mapping->host;
+
+	if (to > inode->i_size) {
+		/*
+		 * punch out the delalloc blocks we have already allocated. We
+		 * don't call xfs_setattr() to do this as we may be in the
+		 * middle of a multi-iovec write and so the vfs inode->i_size
+		 * will not match the xfs ip->i_size and so it will zero too
+		 * much. Hence we jus truncate the page cache to zero what is
+		 * necessary and punch the delalloc blocks directly.
+		 */
+		struct xfs_inode	*ip = XFS_I(inode);
+		xfs_fileoff_t		start_fsb;
+		xfs_fileoff_t		end_fsb;
+		int			error;
+
+		truncate_pagecache(inode, to, inode->i_size);
+
+		/*
+		 * Check if there are any blocks that are outside of i_size
+		 * that need to be trimmed back.
+		 */
+		start_fsb = XFS_B_TO_FSB(ip->i_mount, inode->i_size) + 1;
+		end_fsb = XFS_B_TO_FSB(ip->i_mount, to);
+		if (end_fsb <= start_fsb)
+			return;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+							end_fsb - start_fsb);
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_alert(ip->i_mount,
+			"xfs_vm_write_failed: unable to clean up ino %lld",
+						ip->i_ino);
+			}
+		}
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+}
+
+STATIC int
+xfs_vm_write_begin(
+	struct file		*file,
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len,
+	unsigned		flags,
+	struct page		**pagep,
+	void			**fsdata)
+{
+	int			ret;
+
+	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS,
+				pagep, xfs_get_blocks);
+	if (unlikely(ret))
+		xfs_vm_write_failed(mapping, pos + len);
+	return ret;
+}
+
+STATIC int
+xfs_vm_write_end(
+	struct file		*file,
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len,
+	unsigned		copied,
+	struct page		*page,
+	void			*fsdata)
+{
+	int			ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (unlikely(ret < len))
+		xfs_vm_write_failed(mapping, pos + len);
+	return ret;
+}
+
+STATIC sector_t
+xfs_vm_bmap(
+	struct address_space	*mapping,
+	sector_t		block)
+{
+	struct inode		*inode = (struct inode *)mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	trace_xfs_vm_bmap(XFS_I(inode));
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	return generic_block_bmap(mapping, block, xfs_get_blocks);
+}
+
+STATIC int
+xfs_vm_readpage(
+	struct file		*unused,
+	struct page		*page)
+{
+	return mpage_readpage(page, xfs_get_blocks);
+}
+
+STATIC int
+xfs_vm_readpages(
+	struct file		*unused,
+	struct address_space	*mapping,
+	struct list_head	*pages,
+	unsigned		nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
+}
+
+const struct address_space_operations xfs_address_space_operations = {
+	.readpage		= xfs_vm_readpage,
+	.readpages		= xfs_vm_readpages,
+	.writepage		= xfs_vm_writepage,
+	.writepages		= xfs_vm_writepages,
+	.releasepage		= xfs_vm_releasepage,
+	.invalidatepage		= xfs_vm_invalidatepage,
+	.write_begin		= xfs_vm_write_begin,
+	.write_end		= xfs_vm_write_end,
+	.bmap			= xfs_vm_bmap,
+	.direct_IO		= xfs_vm_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
+	.error_remove_page	= generic_error_remove_page,
+};
diff --git a/fs/xfs/linux/xfs_aops.h b/fs/xfs/linux/xfs_aops.h
new file mode 100644
index 0000000..71f721e
--- /dev/null
+++ b/fs/xfs/linux/xfs_aops.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c) 2005-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_AOPS_H__
+#define __XFS_AOPS_H__
+
+extern struct workqueue_struct *xfsdatad_workqueue;
+extern struct workqueue_struct *xfsconvertd_workqueue;
+extern mempool_t *xfs_ioend_pool;
+
+/*
+ * Types of I/O for bmap clustering and I/O completion tracking.
+ */
+enum {
+	IO_DIRECT = 0,	/* special case for direct I/O ioends */
+	IO_DELALLOC,	/* mapping covers delalloc region */
+	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
+	IO_OVERWRITE,	/* mapping covers already allocated extent */
+};
+
+#define XFS_IO_TYPES \
+	{ 0,			"" }, \
+	{ IO_DELALLOC,		"delalloc" }, \
+	{ IO_UNWRITTEN,		"unwritten" }, \
+	{ IO_OVERWRITE,		"overwrite" }
+
+/*
+ * xfs_ioend struct manages large extent writes for XFS.
+ * It can manage several multi-page bio's at once.
+ */
+typedef struct xfs_ioend {
+	struct xfs_ioend	*io_list;	/* next ioend in chain */
+	unsigned int		io_type;	/* delalloc / unwritten */
+	int			io_error;	/* I/O error code */
+	atomic_t		io_remaining;	/* hold count */
+	struct inode		*io_inode;	/* file being written to */
+	struct buffer_head	*io_buffer_head;/* buffer linked list head */
+	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
+	size_t			io_size;	/* size of the extent */
+	xfs_off_t		io_offset;	/* offset in the file */
+	struct work_struct	io_work;	/* xfsdatad work queue */
+	struct kiocb		*io_iocb;
+	int			io_result;
+} xfs_ioend_t;
+
+extern const struct address_space_operations xfs_address_space_operations;
+extern int xfs_get_blocks(struct inode *, sector_t, struct buffer_head *, int);
+
+extern void xfs_ioend_init(void);
+extern void xfs_ioend_wait(struct xfs_inode *);
+
+extern void xfs_count_page_state(struct page *, int *, int *);
+
+#endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/linux/xfs_buf.c b/fs/xfs/linux/xfs_buf.c
new file mode 100644
index 0000000..b2b4119
--- /dev/null
+++ b/fs/xfs/linux/xfs_buf.c
@@ -0,0 +1,1874 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/pagemap.h>
+#include <linux/init.h>
+#include <linux/vmalloc.h>
+#include <linux/bio.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include <linux/workqueue.h>
+#include <linux/percpu.h>
+#include <linux/blkdev.h>
+#include <linux/hash.h>
+#include <linux/kthread.h>
+#include <linux/migrate.h>
+#include <linux/backing-dev.h>
+#include <linux/freezer.h>
+
+#include "xfs_sb.h"
+#include "xfs_inum.h"
+#include "xfs_log.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+
+static kmem_zone_t *xfs_buf_zone;
+STATIC int xfsbufd(void *);
+STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
+
+static struct workqueue_struct *xfslogd_workqueue;
+struct workqueue_struct *xfsdatad_workqueue;
+struct workqueue_struct *xfsconvertd_workqueue;
+
+#ifdef XFS_BUF_LOCK_TRACKING
+# define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
+# define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
+# define XB_GET_OWNER(bp)	((bp)->b_last_holder)
+#else
+# define XB_SET_OWNER(bp)	do { } while (0)
+# define XB_CLEAR_OWNER(bp)	do { } while (0)
+# define XB_GET_OWNER(bp)	do { } while (0)
+#endif
+
+#define xb_to_gfp(flags) \
+	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : \
+	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN)
+
+#define xb_to_km(flags) \
+	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)
+
+#define xfs_buf_allocate(flags) \
+	kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags))
+#define xfs_buf_deallocate(bp) \
+	kmem_zone_free(xfs_buf_zone, (bp));
+
+static inline int
+xfs_buf_is_vmapped(
+	struct xfs_buf	*bp)
+{
+	/*
+	 * Return true if the buffer is vmapped.
+	 *
+	 * The XBF_MAPPED flag is set if the buffer should be mapped, but the
+	 * code is clever enough to know it doesn't have to map a single page,
+	 * so the check has to be both for XBF_MAPPED and bp->b_page_count > 1.
+	 */
+	return (bp->b_flags & XBF_MAPPED) && bp->b_page_count > 1;
+}
+
+static inline int
+xfs_buf_vmap_len(
+	struct xfs_buf	*bp)
+{
+	return (bp->b_page_count * PAGE_SIZE) - bp->b_offset;
+}
+
+/*
+ * xfs_buf_lru_add - add a buffer to the LRU.
+ *
+ * The LRU takes a new reference to the buffer so that it will only be freed
+ * once the shrinker takes the buffer off the LRU.
+ */
+STATIC void
+xfs_buf_lru_add(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+
+	spin_lock(&btp->bt_lru_lock);
+	if (list_empty(&bp->b_lru)) {
+		atomic_inc(&bp->b_hold);
+		list_add_tail(&bp->b_lru, &btp->bt_lru);
+		btp->bt_lru_nr++;
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+/*
+ * xfs_buf_lru_del - remove a buffer from the LRU
+ *
+ * The unlocked check is safe here because it only occurs when there are not
+ * b_lru_ref counts left on the inode under the pag->pag_buf_lock. it is there
+ * to optimise the shrinker removing the buffer from the LRU and calling
+ * xfs_buf_free(). i.e. it removes an unnecessary round trip on the
+ * bt_lru_lock.
+ */
+STATIC void
+xfs_buf_lru_del(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+
+	if (list_empty(&bp->b_lru))
+		return;
+
+	spin_lock(&btp->bt_lru_lock);
+	if (!list_empty(&bp->b_lru)) {
+		list_del_init(&bp->b_lru);
+		btp->bt_lru_nr--;
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+/*
+ * When we mark a buffer stale, we remove the buffer from the LRU and clear the
+ * b_lru_ref count so that the buffer is freed immediately when the buffer
+ * reference count falls to zero. If the buffer is already on the LRU, we need
+ * to remove the reference that LRU holds on the buffer.
+ *
+ * This prevents build-up of stale buffers on the LRU.
+ */
+void
+xfs_buf_stale(
+	struct xfs_buf	*bp)
+{
+	bp->b_flags |= XBF_STALE;
+	atomic_set(&(bp)->b_lru_ref, 0);
+	if (!list_empty(&bp->b_lru)) {
+		struct xfs_buftarg *btp = bp->b_target;
+
+		spin_lock(&btp->bt_lru_lock);
+		if (!list_empty(&bp->b_lru)) {
+			list_del_init(&bp->b_lru);
+			btp->bt_lru_nr--;
+			atomic_dec(&bp->b_hold);
+		}
+		spin_unlock(&btp->bt_lru_lock);
+	}
+	ASSERT(atomic_read(&bp->b_hold) >= 1);
+}
+
+STATIC void
+_xfs_buf_initialize(
+	xfs_buf_t		*bp,
+	xfs_buftarg_t		*target,
+	xfs_off_t		range_base,
+	size_t			range_length,
+	xfs_buf_flags_t		flags)
+{
+	/*
+	 * We don't want certain flags to appear in b_flags.
+	 */
+	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
+
+	memset(bp, 0, sizeof(xfs_buf_t));
+	atomic_set(&bp->b_hold, 1);
+	atomic_set(&bp->b_lru_ref, 1);
+	init_completion(&bp->b_iowait);
+	INIT_LIST_HEAD(&bp->b_lru);
+	INIT_LIST_HEAD(&bp->b_list);
+	RB_CLEAR_NODE(&bp->b_rbnode);
+	sema_init(&bp->b_sema, 0); /* held, no waiters */
+	XB_SET_OWNER(bp);
+	bp->b_target = target;
+	bp->b_file_offset = range_base;
+	/*
+	 * Set buffer_length and count_desired to the same value initially.
+	 * I/O routines should use count_desired, which will be the same in
+	 * most cases but may be reset (e.g. XFS recovery).
+	 */
+	bp->b_buffer_length = bp->b_count_desired = range_length;
+	bp->b_flags = flags;
+	bp->b_bn = XFS_BUF_DADDR_NULL;
+	atomic_set(&bp->b_pin_count, 0);
+	init_waitqueue_head(&bp->b_waiters);
+
+	XFS_STATS_INC(xb_create);
+
+	trace_xfs_buf_init(bp, _RET_IP_);
+}
+
+/*
+ *	Allocate a page array capable of holding a specified number
+ *	of pages, and point the page buf at it.
+ */
+STATIC int
+_xfs_buf_get_pages(
+	xfs_buf_t		*bp,
+	int			page_count,
+	xfs_buf_flags_t		flags)
+{
+	/* Make sure that we have a page list */
+	if (bp->b_pages == NULL) {
+		bp->b_offset = xfs_buf_poff(bp->b_file_offset);
+		bp->b_page_count = page_count;
+		if (page_count <= XB_PAGES) {
+			bp->b_pages = bp->b_page_array;
+		} else {
+			bp->b_pages = kmem_alloc(sizeof(struct page *) *
+					page_count, xb_to_km(flags));
+			if (bp->b_pages == NULL)
+				return -ENOMEM;
+		}
+		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
+	}
+	return 0;
+}
+
+/*
+ *	Frees b_pages if it was allocated.
+ */
+STATIC void
+_xfs_buf_free_pages(
+	xfs_buf_t	*bp)
+{
+	if (bp->b_pages != bp->b_page_array) {
+		kmem_free(bp->b_pages);
+		bp->b_pages = NULL;
+	}
+}
+
+/*
+ *	Releases the specified buffer.
+ *
+ * 	The modification state of any associated pages is left unchanged.
+ * 	The buffer most not be on any hash - use xfs_buf_rele instead for
+ * 	hashed and refcounted buffers
+ */
+void
+xfs_buf_free(
+	xfs_buf_t		*bp)
+{
+	trace_xfs_buf_free(bp, _RET_IP_);
+
+	ASSERT(list_empty(&bp->b_lru));
+
+	if (bp->b_flags & _XBF_PAGES) {
+		uint		i;
+
+		if (xfs_buf_is_vmapped(bp))
+			vm_unmap_ram(bp->b_addr - bp->b_offset,
+					bp->b_page_count);
+
+		for (i = 0; i < bp->b_page_count; i++) {
+			struct page	*page = bp->b_pages[i];
+
+			__free_page(page);
+		}
+	} else if (bp->b_flags & _XBF_KMEM)
+		kmem_free(bp->b_addr);
+	_xfs_buf_free_pages(bp);
+	xfs_buf_deallocate(bp);
+}
+
+/*
+ * Allocates all the pages for buffer in question and builds it's page list.
+ */
+STATIC int
+xfs_buf_allocate_memory(
+	xfs_buf_t		*bp,
+	uint			flags)
+{
+	size_t			size = bp->b_count_desired;
+	size_t			nbytes, offset;
+	gfp_t			gfp_mask = xb_to_gfp(flags);
+	unsigned short		page_count, i;
+	xfs_off_t		end;
+	int			error;
+
+	/*
+	 * for buffers that are contained within a single page, just allocate
+	 * the memory from the heap - there's no need for the complexity of
+	 * page arrays to keep allocation down to order 0.
+	 */
+	if (bp->b_buffer_length < PAGE_SIZE) {
+		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
+		if (!bp->b_addr) {
+			/* low memory - use alloc_page loop instead */
+			goto use_alloc_page;
+		}
+
+		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
+								PAGE_MASK) !=
+		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
+			/* b_addr spans two pages - use alloc_page instead */
+			kmem_free(bp->b_addr);
+			bp->b_addr = NULL;
+			goto use_alloc_page;
+		}
+		bp->b_offset = offset_in_page(bp->b_addr);
+		bp->b_pages = bp->b_page_array;
+		bp->b_pages[0] = virt_to_page(bp->b_addr);
+		bp->b_page_count = 1;
+		bp->b_flags |= XBF_MAPPED | _XBF_KMEM;
+		return 0;
+	}
+
+use_alloc_page:
+	end = bp->b_file_offset + bp->b_buffer_length;
+	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
+	error = _xfs_buf_get_pages(bp, page_count, flags);
+	if (unlikely(error))
+		return error;
+
+	offset = bp->b_offset;
+	bp->b_flags |= _XBF_PAGES;
+
+	for (i = 0; i < bp->b_page_count; i++) {
+		struct page	*page;
+		uint		retries = 0;
+retry:
+		page = alloc_page(gfp_mask);
+		if (unlikely(page == NULL)) {
+			if (flags & XBF_READ_AHEAD) {
+				bp->b_page_count = i;
+				error = ENOMEM;
+				goto out_free_pages;
+			}
+
+			/*
+			 * This could deadlock.
+			 *
+			 * But until all the XFS lowlevel code is revamped to
+			 * handle buffer allocation failures we can't do much.
+			 */
+			if (!(++retries % 100))
+				xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
+					__func__, gfp_mask);
+
+			XFS_STATS_INC(xb_page_retries);
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			goto retry;
+		}
+
+		XFS_STATS_INC(xb_page_found);
+
+		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
+		size -= nbytes;
+		bp->b_pages[i] = page;
+		offset = 0;
+	}
+	return 0;
+
+out_free_pages:
+	for (i = 0; i < bp->b_page_count; i++)
+		__free_page(bp->b_pages[i]);
+	return error;
+}
+
+/*
+ *	Map buffer into kernel address-space if necessary.
+ */
+STATIC int
+_xfs_buf_map_pages(
+	xfs_buf_t		*bp,
+	uint			flags)
+{
+	ASSERT(bp->b_flags & _XBF_PAGES);
+	if (bp->b_page_count == 1) {
+		/* A single page buffer is always mappable */
+		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
+		bp->b_flags |= XBF_MAPPED;
+	} else if (flags & XBF_MAPPED) {
+		int retried = 0;
+
+		do {
+			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
+						-1, PAGE_KERNEL);
+			if (bp->b_addr)
+				break;
+			vm_unmap_aliases();
+		} while (retried++ <= 1);
+
+		if (!bp->b_addr)
+			return -ENOMEM;
+		bp->b_addr += bp->b_offset;
+		bp->b_flags |= XBF_MAPPED;
+	}
+
+	return 0;
+}
+
+/*
+ *	Finding and Reading Buffers
+ */
+
+/*
+ *	Look up, and creates if absent, a lockable buffer for
+ *	a given range of an inode.  The buffer is returned
+ *	locked.	 If other overlapping buffers exist, they are
+ *	released before the new buffer is created and locked,
+ *	which may imply that this call will block until those buffers
+ *	are unlocked.  No I/O is implied by this call.
+ */
+xfs_buf_t *
+_xfs_buf_find(
+	xfs_buftarg_t		*btp,	/* block device target		*/
+	xfs_off_t		ioff,	/* starting offset of range	*/
+	size_t			isize,	/* length of range		*/
+	xfs_buf_flags_t		flags,
+	xfs_buf_t		*new_bp)
+{
+	xfs_off_t		range_base;
+	size_t			range_length;
+	struct xfs_perag	*pag;
+	struct rb_node		**rbp;
+	struct rb_node		*parent;
+	xfs_buf_t		*bp;
+
+	range_base = (ioff << BBSHIFT);
+	range_length = (isize << BBSHIFT);
+
+	/* Check for IOs smaller than the sector size / not sector aligned */
+	ASSERT(!(range_length < (1 << btp->bt_sshift)));
+	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
+
+	/* get tree root */
+	pag = xfs_perag_get(btp->bt_mount,
+				xfs_daddr_to_agno(btp->bt_mount, ioff));
+
+	/* walk tree */
+	spin_lock(&pag->pag_buf_lock);
+	rbp = &pag->pag_buf_tree.rb_node;
+	parent = NULL;
+	bp = NULL;
+	while (*rbp) {
+		parent = *rbp;
+		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
+
+		if (range_base < bp->b_file_offset)
+			rbp = &(*rbp)->rb_left;
+		else if (range_base > bp->b_file_offset)
+			rbp = &(*rbp)->rb_right;
+		else {
+			/*
+			 * found a block offset match. If the range doesn't
+			 * match, the only way this is allowed is if the buffer
+			 * in the cache is stale and the transaction that made
+			 * it stale has not yet committed. i.e. we are
+			 * reallocating a busy extent. Skip this buffer and
+			 * continue searching to the right for an exact match.
+			 */
+			if (bp->b_buffer_length != range_length) {
+				ASSERT(bp->b_flags & XBF_STALE);
+				rbp = &(*rbp)->rb_right;
+				continue;
+			}
+			atomic_inc(&bp->b_hold);
+			goto found;
+		}
+	}
+
+	/* No match found */
+	if (new_bp) {
+		_xfs_buf_initialize(new_bp, btp, range_base,
+				range_length, flags);
+		rb_link_node(&new_bp->b_rbnode, parent, rbp);
+		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
+		/* the buffer keeps the perag reference until it is freed */
+		new_bp->b_pag = pag;
+		spin_unlock(&pag->pag_buf_lock);
+	} else {
+		XFS_STATS_INC(xb_miss_locked);
+		spin_unlock(&pag->pag_buf_lock);
+		xfs_perag_put(pag);
+	}
+	return new_bp;
+
+found:
+	spin_unlock(&pag->pag_buf_lock);
+	xfs_perag_put(pag);
+
+	if (!xfs_buf_trylock(bp)) {
+		if (flags & XBF_TRYLOCK) {
+			xfs_buf_rele(bp);
+			XFS_STATS_INC(xb_busy_locked);
+			return NULL;
+		}
+		xfs_buf_lock(bp);
+		XFS_STATS_INC(xb_get_locked_waited);
+	}
+
+	/*
+	 * if the buffer is stale, clear all the external state associated with
+	 * it. We need to keep flags such as how we allocated the buffer memory
+	 * intact here.
+	 */
+	if (bp->b_flags & XBF_STALE) {
+		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
+		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
+	}
+
+	trace_xfs_buf_find(bp, flags, _RET_IP_);
+	XFS_STATS_INC(xb_get_locked);
+	return bp;
+}
+
+/*
+ *	Assembles a buffer covering the specified range.
+ *	Storage in memory for all portions of the buffer will be allocated,
+ *	although backing storage may not be.
+ */
+xfs_buf_t *
+xfs_buf_get(
+	xfs_buftarg_t		*target,/* target for buffer		*/
+	xfs_off_t		ioff,	/* starting offset of range	*/
+	size_t			isize,	/* length of range		*/
+	xfs_buf_flags_t		flags)
+{
+	xfs_buf_t		*bp, *new_bp;
+	int			error = 0;
+
+	new_bp = xfs_buf_allocate(flags);
+	if (unlikely(!new_bp))
+		return NULL;
+
+	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
+	if (bp == new_bp) {
+		error = xfs_buf_allocate_memory(bp, flags);
+		if (error)
+			goto no_buffer;
+	} else {
+		xfs_buf_deallocate(new_bp);
+		if (unlikely(bp == NULL))
+			return NULL;
+	}
+
+	if (!(bp->b_flags & XBF_MAPPED)) {
+		error = _xfs_buf_map_pages(bp, flags);
+		if (unlikely(error)) {
+			xfs_warn(target->bt_mount,
+				"%s: failed to map pages\n", __func__);
+			goto no_buffer;
+		}
+	}
+
+	XFS_STATS_INC(xb_get);
+
+	/*
+	 * Always fill in the block number now, the mapped cases can do
+	 * their own overlay of this later.
+	 */
+	bp->b_bn = ioff;
+	bp->b_count_desired = bp->b_buffer_length;
+
+	trace_xfs_buf_get(bp, flags, _RET_IP_);
+	return bp;
+
+ no_buffer:
+	if (flags & (XBF_LOCK | XBF_TRYLOCK))
+		xfs_buf_unlock(bp);
+	xfs_buf_rele(bp);
+	return NULL;
+}
+
+STATIC int
+_xfs_buf_read(
+	xfs_buf_t		*bp,
+	xfs_buf_flags_t		flags)
+{
+	int			status;
+
+	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
+	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
+
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
+	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
+
+	status = xfs_buf_iorequest(bp);
+	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
+		return status;
+	return xfs_buf_iowait(bp);
+}
+
+xfs_buf_t *
+xfs_buf_read(
+	xfs_buftarg_t		*target,
+	xfs_off_t		ioff,
+	size_t			isize,
+	xfs_buf_flags_t		flags)
+{
+	xfs_buf_t		*bp;
+
+	flags |= XBF_READ;
+
+	bp = xfs_buf_get(target, ioff, isize, flags);
+	if (bp) {
+		trace_xfs_buf_read(bp, flags, _RET_IP_);
+
+		if (!XFS_BUF_ISDONE(bp)) {
+			XFS_STATS_INC(xb_get_read);
+			_xfs_buf_read(bp, flags);
+		} else if (flags & XBF_ASYNC) {
+			/*
+			 * Read ahead call which is already satisfied,
+			 * drop the buffer
+			 */
+			goto no_buffer;
+		} else {
+			/* We do not want read in the flags */
+			bp->b_flags &= ~XBF_READ;
+		}
+	}
+
+	return bp;
+
+ no_buffer:
+	if (flags & (XBF_LOCK | XBF_TRYLOCK))
+		xfs_buf_unlock(bp);
+	xfs_buf_rele(bp);
+	return NULL;
+}
+
+/*
+ *	If we are not low on memory then do the readahead in a deadlock
+ *	safe manner.
+ */
+void
+xfs_buf_readahead(
+	xfs_buftarg_t		*target,
+	xfs_off_t		ioff,
+	size_t			isize)
+{
+	if (bdi_read_congested(target->bt_bdi))
+		return;
+
+	xfs_buf_read(target, ioff, isize,
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
+}
+
+/*
+ * Read an uncached buffer from disk. Allocates and returns a locked
+ * buffer containing the disk contents or nothing.
+ */
+struct xfs_buf *
+xfs_buf_read_uncached(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		daddr,
+	size_t			length,
+	int			flags)
+{
+	xfs_buf_t		*bp;
+	int			error;
+
+	bp = xfs_buf_get_uncached(target, length, flags);
+	if (!bp)
+		return NULL;
+
+	/* set up the buffer for a read IO */
+	XFS_BUF_SET_ADDR(bp, daddr);
+	XFS_BUF_READ(bp);
+	XFS_BUF_BUSY(bp);
+
+	xfsbdstrat(mp, bp);
+	error = xfs_buf_iowait(bp);
+	if (error || bp->b_error) {
+		xfs_buf_relse(bp);
+		return NULL;
+	}
+	return bp;
+}
+
+xfs_buf_t *
+xfs_buf_get_empty(
+	size_t			len,
+	xfs_buftarg_t		*target)
+{
+	xfs_buf_t		*bp;
+
+	bp = xfs_buf_allocate(0);
+	if (bp)
+		_xfs_buf_initialize(bp, target, 0, len, 0);
+	return bp;
+}
+
+/*
+ * Return a buffer allocated as an empty buffer and associated to external
+ * memory via xfs_buf_associate_memory() back to it's empty state.
+ */
+void
+xfs_buf_set_empty(
+	struct xfs_buf		*bp,
+	size_t			len)
+{
+	if (bp->b_pages)
+		_xfs_buf_free_pages(bp);
+
+	bp->b_pages = NULL;
+	bp->b_page_count = 0;
+	bp->b_addr = NULL;
+	bp->b_file_offset = 0;
+	bp->b_buffer_length = bp->b_count_desired = len;
+	bp->b_bn = XFS_BUF_DADDR_NULL;
+	bp->b_flags &= ~XBF_MAPPED;
+}
+
+static inline struct page *
+mem_to_page(
+	void			*addr)
+{
+	if ((!is_vmalloc_addr(addr))) {
+		return virt_to_page(addr);
+	} else {
+		return vmalloc_to_page(addr);
+	}
+}
+
+int
+xfs_buf_associate_memory(
+	xfs_buf_t		*bp,
+	void			*mem,
+	size_t			len)
+{
+	int			rval;
+	int			i = 0;
+	unsigned long		pageaddr;
+	unsigned long		offset;
+	size_t			buflen;
+	int			page_count;
+
+	pageaddr = (unsigned long)mem & PAGE_MASK;
+	offset = (unsigned long)mem - pageaddr;
+	buflen = PAGE_ALIGN(len + offset);
+	page_count = buflen >> PAGE_SHIFT;
+
+	/* Free any previous set of page pointers */
+	if (bp->b_pages)
+		_xfs_buf_free_pages(bp);
+
+	bp->b_pages = NULL;
+	bp->b_addr = mem;
+
+	rval = _xfs_buf_get_pages(bp, page_count, XBF_DONT_BLOCK);
+	if (rval)
+		return rval;
+
+	bp->b_offset = offset;
+
+	for (i = 0; i < bp->b_page_count; i++) {
+		bp->b_pages[i] = mem_to_page((void *)pageaddr);
+		pageaddr += PAGE_SIZE;
+	}
+
+	bp->b_count_desired = len;
+	bp->b_buffer_length = buflen;
+	bp->b_flags |= XBF_MAPPED;
+
+	return 0;
+}
+
+xfs_buf_t *
+xfs_buf_get_uncached(
+	struct xfs_buftarg	*target,
+	size_t			len,
+	int			flags)
+{
+	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int			error, i;
+	xfs_buf_t		*bp;
+
+	bp = xfs_buf_allocate(0);
+	if (unlikely(bp == NULL))
+		goto fail;
+	_xfs_buf_initialize(bp, target, 0, len, 0);
+
+	error = _xfs_buf_get_pages(bp, page_count, 0);
+	if (error)
+		goto fail_free_buf;
+
+	for (i = 0; i < page_count; i++) {
+		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
+		if (!bp->b_pages[i])
+			goto fail_free_mem;
+	}
+	bp->b_flags |= _XBF_PAGES;
+
+	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
+	if (unlikely(error)) {
+		xfs_warn(target->bt_mount,
+			"%s: failed to map pages\n", __func__);
+		goto fail_free_mem;
+	}
+
+	trace_xfs_buf_get_uncached(bp, _RET_IP_);
+	return bp;
+
+ fail_free_mem:
+	while (--i >= 0)
+		__free_page(bp->b_pages[i]);
+	_xfs_buf_free_pages(bp);
+ fail_free_buf:
+	xfs_buf_deallocate(bp);
+ fail:
+	return NULL;
+}
+
+/*
+ *	Increment reference count on buffer, to hold the buffer concurrently
+ *	with another thread which may release (free) the buffer asynchronously.
+ *	Must hold the buffer already to call this function.
+ */
+void
+xfs_buf_hold(
+	xfs_buf_t		*bp)
+{
+	trace_xfs_buf_hold(bp, _RET_IP_);
+	atomic_inc(&bp->b_hold);
+}
+
+/*
+ *	Releases a hold on the specified buffer.  If the
+ *	the hold count is 1, calls xfs_buf_free.
+ */
+void
+xfs_buf_rele(
+	xfs_buf_t		*bp)
+{
+	struct xfs_perag	*pag = bp->b_pag;
+
+	trace_xfs_buf_rele(bp, _RET_IP_);
+
+	if (!pag) {
+		ASSERT(list_empty(&bp->b_lru));
+		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
+		if (atomic_dec_and_test(&bp->b_hold))
+			xfs_buf_free(bp);
+		return;
+	}
+
+	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
+
+	ASSERT(atomic_read(&bp->b_hold) > 0);
+	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
+		if (!(bp->b_flags & XBF_STALE) &&
+			   atomic_read(&bp->b_lru_ref)) {
+			xfs_buf_lru_add(bp);
+			spin_unlock(&pag->pag_buf_lock);
+		} else {
+			xfs_buf_lru_del(bp);
+			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
+			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
+			spin_unlock(&pag->pag_buf_lock);
+			xfs_perag_put(pag);
+			xfs_buf_free(bp);
+		}
+	}
+}
+
+
+/*
+ *	Lock a buffer object, if it is not already locked.
+ *
+ *	If we come across a stale, pinned, locked buffer, we know that we are
+ *	being asked to lock a buffer that has been reallocated. Because it is
+ *	pinned, we know that the log has not been pushed to disk and hence it
+ *	will still be locked.  Rather than continuing to have trylock attempts
+ *	fail until someone else pushes the log, push it ourselves before
+ *	returning.  This means that the xfsaild will not get stuck trying
+ *	to push on stale inode buffers.
+ */
+int
+xfs_buf_trylock(
+	struct xfs_buf		*bp)
+{
+	int			locked;
+
+	locked = down_trylock(&bp->b_sema) == 0;
+	if (locked)
+		XB_SET_OWNER(bp);
+	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+		xfs_log_force(bp->b_target->bt_mount, 0);
+
+	trace_xfs_buf_trylock(bp, _RET_IP_);
+	return locked;
+}
+
+/*
+ *	Lock a buffer object.
+ *
+ *	If we come across a stale, pinned, locked buffer, we know that we
+ *	are being asked to lock a buffer that has been reallocated. Because
+ *	it is pinned, we know that the log has not been pushed to disk and
+ *	hence it will still be locked. Rather than sleeping until someone
+ *	else pushes the log, push it ourselves before trying to get the lock.
+ */
+void
+xfs_buf_lock(
+	struct xfs_buf		*bp)
+{
+	trace_xfs_buf_lock(bp, _RET_IP_);
+
+	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+		xfs_log_force(bp->b_target->bt_mount, 0);
+	down(&bp->b_sema);
+	XB_SET_OWNER(bp);
+
+	trace_xfs_buf_lock_done(bp, _RET_IP_);
+}
+
+/*
+ *	Releases the lock on the buffer object.
+ *	If the buffer is marked delwri but is not queued, do so before we
+ *	unlock the buffer as we need to set flags correctly.  We also need to
+ *	take a reference for the delwri queue because the unlocker is going to
+ *	drop their's and they don't know we just queued it.
+ */
+void
+xfs_buf_unlock(
+	struct xfs_buf		*bp)
+{
+	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
+		atomic_inc(&bp->b_hold);
+		bp->b_flags |= XBF_ASYNC;
+		xfs_buf_delwri_queue(bp, 0);
+	}
+
+	XB_CLEAR_OWNER(bp);
+	up(&bp->b_sema);
+
+	trace_xfs_buf_unlock(bp, _RET_IP_);
+}
+
+STATIC void
+xfs_buf_wait_unpin(
+	xfs_buf_t		*bp)
+{
+	DECLARE_WAITQUEUE	(wait, current);
+
+	if (atomic_read(&bp->b_pin_count) == 0)
+		return;
+
+	add_wait_queue(&bp->b_waiters, &wait);
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&bp->b_pin_count) == 0)
+			break;
+		io_schedule();
+	}
+	remove_wait_queue(&bp->b_waiters, &wait);
+	set_current_state(TASK_RUNNING);
+}
+
+/*
+ *	Buffer Utility Routines
+ */
+
+STATIC void
+xfs_buf_iodone_work(
+	struct work_struct	*work)
+{
+	xfs_buf_t		*bp =
+		container_of(work, xfs_buf_t, b_iodone_work);
+
+	if (bp->b_iodone)
+		(*(bp->b_iodone))(bp);
+	else if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+}
+
+void
+xfs_buf_ioend(
+	xfs_buf_t		*bp,
+	int			schedule)
+{
+	trace_xfs_buf_iodone(bp, _RET_IP_);
+
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+	if (bp->b_error == 0)
+		bp->b_flags |= XBF_DONE;
+
+	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
+		if (schedule) {
+			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
+			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
+		} else {
+			xfs_buf_iodone_work(&bp->b_iodone_work);
+		}
+	} else {
+		complete(&bp->b_iowait);
+	}
+}
+
+void
+xfs_buf_ioerror(
+	xfs_buf_t		*bp,
+	int			error)
+{
+	ASSERT(error >= 0 && error <= 0xffff);
+	bp->b_error = (unsigned short)error;
+	trace_xfs_buf_ioerror(bp, error, _RET_IP_);
+}
+
+int
+xfs_bwrite(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	int			error;
+
+	bp->b_flags |= XBF_WRITE;
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
+
+	xfs_buf_delwri_dequeue(bp);
+	xfs_bdstrat_cb(bp);
+
+	error = xfs_buf_iowait(bp);
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	xfs_buf_relse(bp);
+	return error;
+}
+
+void
+xfs_bdwrite(
+	void			*mp,
+	struct xfs_buf		*bp)
+{
+	trace_xfs_buf_bdwrite(bp, _RET_IP_);
+
+	bp->b_flags &= ~XBF_READ;
+	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
+
+	xfs_buf_delwri_queue(bp, 1);
+}
+
+/*
+ * Called when we want to stop a buffer from getting written or read.
+ * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
+ * so that the proper iodone callbacks get called.
+ */
+STATIC int
+xfs_bioerror(
+	xfs_buf_t *bp)
+{
+#ifdef XFSERRORDEBUG
+	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
+#endif
+
+	/*
+	 * No need to wait until the buffer is unpinned, we aren't flushing it.
+	 */
+	XFS_BUF_ERROR(bp, EIO);
+
+	/*
+	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
+	 */
+	XFS_BUF_UNREAD(bp);
+	XFS_BUF_UNDELAYWRITE(bp);
+	XFS_BUF_UNDONE(bp);
+	XFS_BUF_STALE(bp);
+
+	xfs_buf_ioend(bp, 0);
+
+	return EIO;
+}
+
+/*
+ * Same as xfs_bioerror, except that we are releasing the buffer
+ * here ourselves, and avoiding the xfs_buf_ioend call.
+ * This is meant for userdata errors; metadata bufs come with
+ * iodone functions attached, so that we can track down errors.
+ */
+STATIC int
+xfs_bioerror_relse(
+	struct xfs_buf	*bp)
+{
+	int64_t		fl = XFS_BUF_BFLAGS(bp);
+	/*
+	 * No need to wait until the buffer is unpinned.
+	 * We aren't flushing it.
+	 *
+	 * chunkhold expects B_DONE to be set, whether
+	 * we actually finish the I/O or not. We don't want to
+	 * change that interface.
+	 */
+	XFS_BUF_UNREAD(bp);
+	XFS_BUF_UNDELAYWRITE(bp);
+	XFS_BUF_DONE(bp);
+	XFS_BUF_STALE(bp);
+	bp->b_iodone = NULL;
+	if (!(fl & XBF_ASYNC)) {
+		/*
+		 * Mark b_error and B_ERROR _both_.
+		 * Lot's of chunkcache code assumes that.
+		 * There's no reason to mark error for
+		 * ASYNC buffers.
+		 */
+		XFS_BUF_ERROR(bp, EIO);
+		XFS_BUF_FINISH_IOWAIT(bp);
+	} else {
+		xfs_buf_relse(bp);
+	}
+
+	return EIO;
+}
+
+
+/*
+ * All xfs metadata buffers except log state machine buffers
+ * get this attached as their b_bdstrat callback function.
+ * This is so that we can catch a buffer
+ * after prematurely unpinning it to forcibly shutdown the filesystem.
+ */
+int
+xfs_bdstrat_cb(
+	struct xfs_buf	*bp)
+{
+	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		trace_xfs_bdstrat_shut(bp, _RET_IP_);
+		/*
+		 * Metadata write that didn't get logged but
+		 * written delayed anyway. These aren't associated
+		 * with a transaction, and can be ignored.
+		 */
+		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
+			return xfs_bioerror_relse(bp);
+		else
+			return xfs_bioerror(bp);
+	}
+
+	xfs_buf_iorequest(bp);
+	return 0;
+}
+
+/*
+ * Wrapper around bdstrat so that we can stop data from going to disk in case
+ * we are shutting down the filesystem.  Typically user data goes thru this
+ * path; one of the exceptions is the superblock.
+ */
+void
+xfsbdstrat(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		trace_xfs_bdstrat_shut(bp, _RET_IP_);
+		xfs_bioerror_relse(bp);
+		return;
+	}
+
+	xfs_buf_iorequest(bp);
+}
+
+STATIC void
+_xfs_buf_ioend(
+	xfs_buf_t		*bp,
+	int			schedule)
+{
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend(bp, schedule);
+}
+
+STATIC void
+xfs_buf_bio_end_io(
+	struct bio		*bio,
+	int			error)
+{
+	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
+
+	xfs_buf_ioerror(bp, -error);
+
+	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
+
+	_xfs_buf_ioend(bp, 1);
+	bio_put(bio);
+}
+
+STATIC void
+_xfs_buf_ioapply(
+	xfs_buf_t		*bp)
+{
+	int			rw, map_i, total_nr_pages, nr_pages;
+	struct bio		*bio;
+	int			offset = bp->b_offset;
+	int			size = bp->b_count_desired;
+	sector_t		sector = bp->b_bn;
+
+	total_nr_pages = bp->b_page_count;
+	map_i = 0;
+
+	if (bp->b_flags & XBF_WRITE) {
+		if (bp->b_flags & XBF_SYNCIO)
+			rw = WRITE_SYNC;
+		else
+			rw = WRITE;
+		if (bp->b_flags & XBF_FUA)
+			rw |= REQ_FUA;
+		if (bp->b_flags & XBF_FLUSH)
+			rw |= REQ_FLUSH;
+	} else if (bp->b_flags & XBF_READ_AHEAD) {
+		rw = READA;
+	} else {
+		rw = READ;
+	}
+
+next_chunk:
+	atomic_inc(&bp->b_io_remaining);
+	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
+	if (nr_pages > total_nr_pages)
+		nr_pages = total_nr_pages;
+
+	bio = bio_alloc(GFP_NOIO, nr_pages);
+	bio->bi_bdev = bp->b_target->bt_bdev;
+	bio->bi_sector = sector;
+	bio->bi_end_io = xfs_buf_bio_end_io;
+	bio->bi_private = bp;
+
+
+	for (; size && nr_pages; nr_pages--, map_i++) {
+		int	rbytes, nbytes = PAGE_SIZE - offset;
+
+		if (nbytes > size)
+			nbytes = size;
+
+		rbytes = bio_add_page(bio, bp->b_pages[map_i], nbytes, offset);
+		if (rbytes < nbytes)
+			break;
+
+		offset = 0;
+		sector += nbytes >> BBSHIFT;
+		size -= nbytes;
+		total_nr_pages--;
+	}
+
+	if (likely(bio->bi_size)) {
+		if (xfs_buf_is_vmapped(bp)) {
+			flush_kernel_vmap_range(bp->b_addr,
+						xfs_buf_vmap_len(bp));
+		}
+		submit_bio(rw, bio);
+		if (size)
+			goto next_chunk;
+	} else {
+		xfs_buf_ioerror(bp, EIO);
+		bio_put(bio);
+	}
+}
+
+int
+xfs_buf_iorequest(
+	xfs_buf_t		*bp)
+{
+	trace_xfs_buf_iorequest(bp, _RET_IP_);
+
+	if (bp->b_flags & XBF_DELWRI) {
+		xfs_buf_delwri_queue(bp, 1);
+		return 0;
+	}
+
+	if (bp->b_flags & XBF_WRITE) {
+		xfs_buf_wait_unpin(bp);
+	}
+
+	xfs_buf_hold(bp);
+
+	/* Set the count to 1 initially, this will stop an I/O
+	 * completion callout which happens before we have started
+	 * all the I/O from calling xfs_buf_ioend too early.
+	 */
+	atomic_set(&bp->b_io_remaining, 1);
+	_xfs_buf_ioapply(bp);
+	_xfs_buf_ioend(bp, 0);
+
+	xfs_buf_rele(bp);
+	return 0;
+}
+
+/*
+ *	Waits for I/O to complete on the buffer supplied.
+ *	It returns immediately if no I/O is pending.
+ *	It returns the I/O error code, if any, or 0 if there was no error.
+ */
+int
+xfs_buf_iowait(
+	xfs_buf_t		*bp)
+{
+	trace_xfs_buf_iowait(bp, _RET_IP_);
+
+	wait_for_completion(&bp->b_iowait);
+
+	trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	return bp->b_error;
+}
+
+xfs_caddr_t
+xfs_buf_offset(
+	xfs_buf_t		*bp,
+	size_t			offset)
+{
+	struct page		*page;
+
+	if (bp->b_flags & XBF_MAPPED)
+		return XFS_BUF_PTR(bp) + offset;
+
+	offset += bp->b_offset;
+	page = bp->b_pages[offset >> PAGE_SHIFT];
+	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_SIZE-1));
+}
+
+/*
+ *	Move data into or out of a buffer.
+ */
+void
+xfs_buf_iomove(
+	xfs_buf_t		*bp,	/* buffer to process		*/
+	size_t			boff,	/* starting buffer offset	*/
+	size_t			bsize,	/* length to copy		*/
+	void			*data,	/* data address			*/
+	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
+{
+	size_t			bend, cpoff, csize;
+	struct page		*page;
+
+	bend = boff + bsize;
+	while (boff < bend) {
+		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
+		cpoff = xfs_buf_poff(boff + bp->b_offset);
+		csize = min_t(size_t,
+			      PAGE_SIZE-cpoff, bp->b_count_desired-boff);
+
+		ASSERT(((csize + cpoff) <= PAGE_SIZE));
+
+		switch (mode) {
+		case XBRW_ZERO:
+			memset(page_address(page) + cpoff, 0, csize);
+			break;
+		case XBRW_READ:
+			memcpy(data, page_address(page) + cpoff, csize);
+			break;
+		case XBRW_WRITE:
+			memcpy(page_address(page) + cpoff, data, csize);
+		}
+
+		boff += csize;
+		data += csize;
+	}
+}
+
+/*
+ *	Handling of buffer targets (buftargs).
+ */
+
+/*
+ * Wait for any bufs with callbacks that have been submitted but have not yet
+ * returned. These buffers will have an elevated hold count, so wait on those
+ * while freeing all the buffers only held by the LRU.
+ */
+void
+xfs_wait_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	struct xfs_buf		*bp;
+
+restart:
+	spin_lock(&btp->bt_lru_lock);
+	while (!list_empty(&btp->bt_lru)) {
+		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
+		if (atomic_read(&bp->b_hold) > 1) {
+			spin_unlock(&btp->bt_lru_lock);
+			delay(100);
+			goto restart;
+		}
+		/*
+		 * clear the LRU reference count so the bufer doesn't get
+		 * ignored in xfs_buf_rele().
+		 */
+		atomic_set(&bp->b_lru_ref, 0);
+		spin_unlock(&btp->bt_lru_lock);
+		xfs_buf_rele(bp);
+		spin_lock(&btp->bt_lru_lock);
+	}
+	spin_unlock(&btp->bt_lru_lock);
+}
+
+int
+xfs_buftarg_shrink(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_buftarg	*btp = container_of(shrink,
+					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buf		*bp;
+	int nr_to_scan = sc->nr_to_scan;
+	LIST_HEAD(dispose);
+
+	if (!nr_to_scan)
+		return btp->bt_lru_nr;
+
+	spin_lock(&btp->bt_lru_lock);
+	while (!list_empty(&btp->bt_lru)) {
+		if (nr_to_scan-- <= 0)
+			break;
+
+		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
+
+		/*
+		 * Decrement the b_lru_ref count unless the value is already
+		 * zero. If the value is already zero, we need to reclaim the
+		 * buffer, otherwise it gets another trip through the LRU.
+		 */
+		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+			list_move_tail(&bp->b_lru, &btp->bt_lru);
+			continue;
+		}
+
+		/*
+		 * remove the buffer from the LRU now to avoid needing another
+		 * lock round trip inside xfs_buf_rele().
+		 */
+		list_move(&bp->b_lru, &dispose);
+		btp->bt_lru_nr--;
+	}
+	spin_unlock(&btp->bt_lru_lock);
+
+	while (!list_empty(&dispose)) {
+		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
+		list_del_init(&bp->b_lru);
+		xfs_buf_rele(bp);
+	}
+
+	return btp->bt_lru_nr;
+}
+
+void
+xfs_free_buftarg(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*btp)
+{
+	unregister_shrinker(&btp->bt_shrinker);
+
+	xfs_flush_buftarg(btp, 1);
+	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		xfs_blkdev_issue_flush(btp);
+
+	kthread_stop(btp->bt_task);
+	kmem_free(btp);
+}
+
+STATIC int
+xfs_setsize_buftarg_flags(
+	xfs_buftarg_t		*btp,
+	unsigned int		blocksize,
+	unsigned int		sectorsize,
+	int			verbose)
+{
+	btp->bt_bsize = blocksize;
+	btp->bt_sshift = ffs(sectorsize) - 1;
+	btp->bt_smask = sectorsize - 1;
+
+	if (set_blocksize(btp->bt_bdev, sectorsize)) {
+		xfs_warn(btp->bt_mount,
+			"Cannot set_blocksize to %u on device %s\n",
+			sectorsize, XFS_BUFTARG_NAME(btp));
+		return EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ *	When allocating the initial buffer target we have not yet
+ *	read in the superblock, so don't know what sized sectors
+ *	are being used is at this early stage.  Play safe.
+ */
+STATIC int
+xfs_setsize_buftarg_early(
+	xfs_buftarg_t		*btp,
+	struct block_device	*bdev)
+{
+	return xfs_setsize_buftarg_flags(btp,
+			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
+}
+
+int
+xfs_setsize_buftarg(
+	xfs_buftarg_t		*btp,
+	unsigned int		blocksize,
+	unsigned int		sectorsize)
+{
+	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
+}
+
+STATIC int
+xfs_alloc_delwrite_queue(
+	xfs_buftarg_t		*btp,
+	const char		*fsname)
+{
+	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
+	spin_lock_init(&btp->bt_delwrite_lock);
+	btp->bt_flags = 0;
+	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
+	if (IS_ERR(btp->bt_task))
+		return PTR_ERR(btp->bt_task);
+	return 0;
+}
+
+xfs_buftarg_t *
+xfs_alloc_buftarg(
+	struct xfs_mount	*mp,
+	struct block_device	*bdev,
+	int			external,
+	const char		*fsname)
+{
+	xfs_buftarg_t		*btp;
+
+	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
+
+	btp->bt_mount = mp;
+	btp->bt_dev =  bdev->bd_dev;
+	btp->bt_bdev = bdev;
+	btp->bt_bdi = blk_get_backing_dev_info(bdev);
+	if (!btp->bt_bdi)
+		goto error;
+
+	INIT_LIST_HEAD(&btp->bt_lru);
+	spin_lock_init(&btp->bt_lru_lock);
+	if (xfs_setsize_buftarg_early(btp, bdev))
+		goto error;
+	if (xfs_alloc_delwrite_queue(btp, fsname))
+		goto error;
+	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
+	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&btp->bt_shrinker);
+	return btp;
+
+error:
+	kmem_free(btp);
+	return NULL;
+}
+
+
+/*
+ *	Delayed write buffer handling
+ */
+STATIC void
+xfs_buf_delwri_queue(
+	xfs_buf_t		*bp,
+	int			unlock)
+{
+	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
+	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
+
+	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
+
+	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
+
+	spin_lock(dwlk);
+	/* If already in the queue, dequeue and place at tail */
+	if (!list_empty(&bp->b_list)) {
+		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+		if (unlock)
+			atomic_dec(&bp->b_hold);
+		list_del(&bp->b_list);
+	}
+
+	if (list_empty(dwq)) {
+		/* start xfsbufd as it is about to have something to do */
+		wake_up_process(bp->b_target->bt_task);
+	}
+
+	bp->b_flags |= _XBF_DELWRI_Q;
+	list_add_tail(&bp->b_list, dwq);
+	bp->b_queuetime = jiffies;
+	spin_unlock(dwlk);
+
+	if (unlock)
+		xfs_buf_unlock(bp);
+}
+
+void
+xfs_buf_delwri_dequeue(
+	xfs_buf_t		*bp)
+{
+	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
+	int			dequeued = 0;
+
+	spin_lock(dwlk);
+	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
+		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+		list_del_init(&bp->b_list);
+		dequeued = 1;
+	}
+	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
+	spin_unlock(dwlk);
+
+	if (dequeued)
+		xfs_buf_rele(bp);
+
+	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
+}
+
+/*
+ * If a delwri buffer needs to be pushed before it has aged out, then promote
+ * it to the head of the delwri queue so that it will be flushed on the next
+ * xfsbufd run. We do this by resetting the queuetime of the buffer to be older
+ * than the age currently needed to flush the buffer. Hence the next time the
+ * xfsbufd sees it is guaranteed to be considered old enough to flush.
+ */
+void
+xfs_buf_delwri_promote(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
+
+	ASSERT(bp->b_flags & XBF_DELWRI);
+	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+
+	/*
+	 * Check the buffer age before locking the delayed write queue as we
+	 * don't need to promote buffers that are already past the flush age.
+	 */
+	if (bp->b_queuetime < jiffies - age)
+		return;
+	bp->b_queuetime = jiffies - age;
+	spin_lock(&btp->bt_delwrite_lock);
+	list_move(&bp->b_list, &btp->bt_delwrite_queue);
+	spin_unlock(&btp->bt_delwrite_lock);
+}
+
+STATIC void
+xfs_buf_runall_queues(
+	struct workqueue_struct	*queue)
+{
+	flush_workqueue(queue);
+}
+
+/*
+ * Move as many buffers as specified to the supplied list
+ * idicating if we skipped any buffers to prevent deadlocks.
+ */
+STATIC int
+xfs_buf_delwri_split(
+	xfs_buftarg_t	*target,
+	struct list_head *list,
+	unsigned long	age)
+{
+	xfs_buf_t	*bp, *n;
+	struct list_head *dwq = &target->bt_delwrite_queue;
+	spinlock_t	*dwlk = &target->bt_delwrite_lock;
+	int		skipped = 0;
+	int		force;
+
+	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
+	INIT_LIST_HEAD(list);
+	spin_lock(dwlk);
+	list_for_each_entry_safe(bp, n, dwq, b_list) {
+		ASSERT(bp->b_flags & XBF_DELWRI);
+
+		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
+			if (!force &&
+			    time_before(jiffies, bp->b_queuetime + age)) {
+				xfs_buf_unlock(bp);
+				break;
+			}
+
+			bp->b_flags &= ~(XBF_DELWRI | _XBF_DELWRI_Q);
+			bp->b_flags |= XBF_WRITE;
+			list_move_tail(&bp->b_list, list);
+			trace_xfs_buf_delwri_split(bp, _RET_IP_);
+		} else
+			skipped++;
+	}
+	spin_unlock(dwlk);
+
+	return skipped;
+
+}
+
+/*
+ * Compare function is more complex than it needs to be because
+ * the return value is only 32 bits and we are doing comparisons
+ * on 64 bit values
+ */
+static int
+xfs_buf_cmp(
+	void		*priv,
+	struct list_head *a,
+	struct list_head *b)
+{
+	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
+	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
+	xfs_daddr_t		diff;
+
+	diff = ap->b_bn - bp->b_bn;
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
+STATIC int
+xfsbufd(
+	void		*data)
+{
+	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
+
+	current->flags |= PF_MEMALLOC;
+
+	set_freezable();
+
+	do {
+		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
+		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
+		struct list_head tmp;
+		struct blk_plug plug;
+
+		if (unlikely(freezing(current))) {
+			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
+			refrigerator();
+		} else {
+			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
+		}
+
+		/* sleep for a long time if there is nothing to do. */
+		if (list_empty(&target->bt_delwrite_queue))
+			tout = MAX_SCHEDULE_TIMEOUT;
+		schedule_timeout_interruptible(tout);
+
+		xfs_buf_delwri_split(target, &tmp, age);
+		list_sort(NULL, &tmp, xfs_buf_cmp);
+
+		blk_start_plug(&plug);
+		while (!list_empty(&tmp)) {
+			struct xfs_buf *bp;
+			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
+			list_del_init(&bp->b_list);
+			xfs_bdstrat_cb(bp);
+		}
+		blk_finish_plug(&plug);
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/*
+ *	Go through all incore buffers, and release buffers if they belong to
+ *	the given device. This is used in filesystem error handling to
+ *	preserve the consistency of its metadata.
+ */
+int
+xfs_flush_buftarg(
+	xfs_buftarg_t	*target,
+	int		wait)
+{
+	xfs_buf_t	*bp;
+	int		pincount = 0;
+	LIST_HEAD(tmp_list);
+	LIST_HEAD(wait_list);
+	struct blk_plug plug;
+
+	xfs_buf_runall_queues(xfsconvertd_workqueue);
+	xfs_buf_runall_queues(xfsdatad_workqueue);
+	xfs_buf_runall_queues(xfslogd_workqueue);
+
+	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
+	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
+
+	/*
+	 * Dropped the delayed write list lock, now walk the temporary list.
+	 * All I/O is issued async and then if we need to wait for completion
+	 * we do that after issuing all the IO.
+	 */
+	list_sort(NULL, &tmp_list, xfs_buf_cmp);
+
+	blk_start_plug(&plug);
+	while (!list_empty(&tmp_list)) {
+		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
+		ASSERT(target == bp->b_target);
+		list_del_init(&bp->b_list);
+		if (wait) {
+			bp->b_flags &= ~XBF_ASYNC;
+			list_add(&bp->b_list, &wait_list);
+		}
+		xfs_bdstrat_cb(bp);
+	}
+	blk_finish_plug(&plug);
+
+	if (wait) {
+		/* Wait for IO to complete. */
+		while (!list_empty(&wait_list)) {
+			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
+
+			list_del_init(&bp->b_list);
+			xfs_buf_iowait(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+
+	return pincount;
+}
+
+int __init
+xfs_buf_init(void)
+{
+	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
+						KM_ZONE_HWALIGN, NULL);
+	if (!xfs_buf_zone)
+		goto out;
+
+	xfslogd_workqueue = alloc_workqueue("xfslogd",
+					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+	if (!xfslogd_workqueue)
+		goto out_free_buf_zone;
+
+	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
+	if (!xfsdatad_workqueue)
+		goto out_destroy_xfslogd_workqueue;
+
+	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
+						WQ_MEM_RECLAIM, 1);
+	if (!xfsconvertd_workqueue)
+		goto out_destroy_xfsdatad_workqueue;
+
+	return 0;
+
+ out_destroy_xfsdatad_workqueue:
+	destroy_workqueue(xfsdatad_workqueue);
+ out_destroy_xfslogd_workqueue:
+	destroy_workqueue(xfslogd_workqueue);
+ out_free_buf_zone:
+	kmem_zone_destroy(xfs_buf_zone);
+ out:
+	return -ENOMEM;
+}
+
+void
+xfs_buf_terminate(void)
+{
+	destroy_workqueue(xfsconvertd_workqueue);
+	destroy_workqueue(xfsdatad_workqueue);
+	destroy_workqueue(xfslogd_workqueue);
+	kmem_zone_destroy(xfs_buf_zone);
+}
+
+#ifdef CONFIG_KDB_MODULES
+struct list_head *
+xfs_get_buftarg_list(void)
+{
+	return &xfs_buftarg_list;
+}
+#endif
diff --git a/fs/xfs/linux/xfs_buf.h b/fs/xfs/linux/xfs_buf.h
new file mode 100644
index 0000000..6a83b46
--- /dev/null
+++ b/fs/xfs/linux/xfs_buf.h
@@ -0,0 +1,336 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_BUF_H__
+#define __XFS_BUF_H__
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <asm/system.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/uio.h>
+
+/*
+ *	Base types
+ */
+
+#define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
+
+#define xfs_buf_ctob(pp)	((pp) * PAGE_CACHE_SIZE)
+#define xfs_buf_btoc(dd)	(((dd) + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT)
+#define xfs_buf_btoct(dd)	((dd) >> PAGE_CACHE_SHIFT)
+#define xfs_buf_poff(aa)	((aa) & ~PAGE_CACHE_MASK)
+
+typedef enum {
+	XBRW_READ = 1,			/* transfer into target memory */
+	XBRW_WRITE = 2,			/* transfer from target memory */
+	XBRW_ZERO = 3,			/* Zero target memory */
+} xfs_buf_rw_t;
+
+#define XBF_READ	(1 << 0) /* buffer intended for reading from device */
+#define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
+#define XBF_MAPPED	(1 << 3) /* buffer mapped (b_addr valid) */
+#define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
+#define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
+#define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
+#define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
+
+/* I/O hints for the BIO layer */
+#define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
+#define XBF_FUA		(1 << 11)/* force cache write through mode */
+#define XBF_FLUSH	(1 << 12)/* flush the disk cache before a write */
+
+/* flags used only as arguments to access routines */
+#define XBF_LOCK	(1 << 15)/* lock requested */
+#define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
+#define XBF_DONT_BLOCK	(1 << 17)/* do not block in current thread */
+
+/* flags used only internally */
+#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
+#define _XBF_KMEM	(1 << 21)/* backed by heap memory */
+#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
+
+typedef unsigned int xfs_buf_flags_t;
+
+#define XFS_BUF_FLAGS \
+	{ XBF_READ,		"READ" }, \
+	{ XBF_WRITE,		"WRITE" }, \
+	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
+	{ XBF_MAPPED,		"MAPPED" }, \
+	{ XBF_ASYNC,		"ASYNC" }, \
+	{ XBF_DONE,		"DONE" }, \
+	{ XBF_DELWRI,		"DELWRI" }, \
+	{ XBF_STALE,		"STALE" }, \
+	{ XBF_SYNCIO,		"SYNCIO" }, \
+	{ XBF_FUA,		"FUA" }, \
+	{ XBF_FLUSH,		"FLUSH" }, \
+	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
+	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
+	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
+	{ _XBF_PAGES,		"PAGES" }, \
+	{ _XBF_KMEM,		"KMEM" }, \
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
+
+typedef enum {
+	XBT_FORCE_SLEEP = 0,
+	XBT_FORCE_FLUSH = 1,
+} xfs_buftarg_flags_t;
+
+typedef struct xfs_buftarg {
+	dev_t			bt_dev;
+	struct block_device	*bt_bdev;
+	struct backing_dev_info	*bt_bdi;
+	struct xfs_mount	*bt_mount;
+	unsigned int		bt_bsize;
+	unsigned int		bt_sshift;
+	size_t			bt_smask;
+
+	/* per device delwri queue */
+	struct task_struct	*bt_task;
+	struct list_head	bt_delwrite_queue;
+	spinlock_t		bt_delwrite_lock;
+	unsigned long		bt_flags;
+
+	/* LRU control structures */
+	struct shrinker		bt_shrinker;
+	struct list_head	bt_lru;
+	spinlock_t		bt_lru_lock;
+	unsigned int		bt_lru_nr;
+} xfs_buftarg_t;
+
+struct xfs_buf;
+typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
+
+#define XB_PAGES	2
+
+typedef struct xfs_buf {
+	/*
+	 * first cacheline holds all the fields needed for an uncontended cache
+	 * hit to be fully processed. The semaphore straddles the cacheline
+	 * boundary, but the counter and lock sits on the first cacheline,
+	 * which is the only bit that is touched if we hit the semaphore
+	 * fast-path on locking.
+	 */
+	struct rb_node		b_rbnode;	/* rbtree node */
+	xfs_off_t		b_file_offset;	/* offset in file */
+	size_t			b_buffer_length;/* size of buffer in bytes */
+	atomic_t		b_hold;		/* reference count */
+	atomic_t		b_lru_ref;	/* lru reclaim ref count */
+	xfs_buf_flags_t		b_flags;	/* status flags */
+	struct semaphore	b_sema;		/* semaphore for lockables */
+
+	struct list_head	b_lru;		/* lru list */
+	wait_queue_head_t	b_waiters;	/* unpin waiters */
+	struct list_head	b_list;
+	struct xfs_perag	*b_pag;		/* contains rbtree root */
+	xfs_buftarg_t		*b_target;	/* buffer target (device) */
+	xfs_daddr_t		b_bn;		/* block number for I/O */
+	size_t			b_count_desired;/* desired transfer size */
+	void			*b_addr;	/* virtual address of buffer */
+	struct work_struct	b_iodone_work;
+	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
+	struct completion	b_iowait;	/* queue for I/O waiters */
+	void			*b_fspriv;
+	struct xfs_trans	*b_transp;
+	struct page		**b_pages;	/* array of page pointers */
+	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	unsigned long		b_queuetime;	/* time buffer was queued */
+	atomic_t		b_pin_count;	/* pin count */
+	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
+	unsigned int		b_page_count;	/* size of page array */
+	unsigned int		b_offset;	/* page offset in first page */
+	unsigned short		b_error;	/* error code on I/O */
+#ifdef XFS_BUF_LOCK_TRACKING
+	int			b_last_holder;
+#endif
+} xfs_buf_t;
+
+
+/* Finding and Reading Buffers */
+extern xfs_buf_t *_xfs_buf_find(xfs_buftarg_t *, xfs_off_t, size_t,
+				xfs_buf_flags_t, xfs_buf_t *);
+#define xfs_incore(buftarg,blkno,len,lockit) \
+	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
+
+extern xfs_buf_t *xfs_buf_get(xfs_buftarg_t *, xfs_off_t, size_t,
+				xfs_buf_flags_t);
+extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
+				xfs_buf_flags_t);
+
+extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
+extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
+extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
+extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
+extern void xfs_buf_hold(xfs_buf_t *);
+extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t);
+struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
+				struct xfs_buftarg *target,
+				xfs_daddr_t daddr, size_t length, int flags);
+
+/* Releasing Buffers */
+extern void xfs_buf_free(xfs_buf_t *);
+extern void xfs_buf_rele(xfs_buf_t *);
+
+/* Locking and Unlocking Buffers */
+extern int xfs_buf_trylock(xfs_buf_t *);
+extern void xfs_buf_lock(xfs_buf_t *);
+extern void xfs_buf_unlock(xfs_buf_t *);
+#define xfs_buf_islocked(bp) \
+	((bp)->b_sema.count <= 0)
+
+/* Buffer Read and Write Routines */
+extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
+extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
+
+extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
+extern int xfs_bdstrat_cb(struct xfs_buf *);
+
+extern void xfs_buf_ioend(xfs_buf_t *,	int);
+extern void xfs_buf_ioerror(xfs_buf_t *, int);
+extern int xfs_buf_iorequest(xfs_buf_t *);
+extern int xfs_buf_iowait(xfs_buf_t *);
+extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
+				xfs_buf_rw_t);
+#define xfs_buf_zero(bp, off, len) \
+	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
+
+static inline int xfs_buf_geterror(xfs_buf_t *bp)
+{
+	return bp ? bp->b_error : ENOMEM;
+}
+
+/* Buffer Utility Routines */
+extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
+
+/* Delayed Write Buffer Routines */
+extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
+extern void xfs_buf_delwri_promote(xfs_buf_t *);
+
+/* Buffer Daemon Setup Routines */
+extern int xfs_buf_init(void);
+extern void xfs_buf_terminate(void);
+
+#define xfs_buf_target_name(target)	\
+	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
+
+
+#define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
+#define XFS_BUF_ZEROFLAGS(bp) \
+	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
+			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
+
+void xfs_buf_stale(struct xfs_buf *bp);
+#define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
+#define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
+#define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
+#define XFS_BUF_SUPER_STALE(bp)	do {				\
+					XFS_BUF_STALE(bp);	\
+					xfs_buf_delwri_dequeue(bp);	\
+					XFS_BUF_DONE(bp);	\
+				} while (0)
+
+#define XFS_BUF_DELAYWRITE(bp)		((bp)->b_flags |= XBF_DELWRI)
+#define XFS_BUF_UNDELAYWRITE(bp)	xfs_buf_delwri_dequeue(bp)
+#define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
+
+#define XFS_BUF_ERROR(bp,no)	xfs_buf_ioerror(bp,no)
+#define XFS_BUF_GETERROR(bp)	xfs_buf_geterror(bp)
+#define XFS_BUF_ISERROR(bp)	(xfs_buf_geterror(bp) ? 1 : 0)
+
+#define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
+#define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
+#define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
+
+#define XFS_BUF_BUSY(bp)	do { } while (0)
+#define XFS_BUF_UNBUSY(bp)	do { } while (0)
+#define XFS_BUF_ISBUSY(bp)	(1)
+
+#define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
+#define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
+#define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
+
+#define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
+#define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
+#define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
+#define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
+
+#define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
+#define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
+#define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
+
+#define XFS_BUF_SET_START(bp)			do { } while (0)
+
+#define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
+#define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
+#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
+#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
+#define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
+#define XFS_BUF_SET_OFFSET(bp, off)	((bp)->b_file_offset = (off))
+#define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
+#define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
+#define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
+#define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
+
+static inline void
+xfs_buf_set_ref(
+	struct xfs_buf	*bp,
+	int		lru_ref)
+{
+	atomic_set(&bp->b_lru_ref, lru_ref);
+}
+#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
+#define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
+
+#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
+
+#define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
+
+#define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
+#define XFS_BUF_TARGET(bp)		((bp)->b_target)
+#define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
+
+static inline void xfs_buf_relse(xfs_buf_t *bp)
+{
+	xfs_buf_unlock(bp);
+	xfs_buf_rele(bp);
+}
+
+/*
+ *	Handling of buftargs.
+ */
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
+			struct block_device *, int, const char *);
+extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
+extern void xfs_wait_buftarg(xfs_buftarg_t *);
+extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
+extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
+
+#ifdef CONFIG_KDB_MODULES
+extern struct list_head *xfs_get_buftarg_list(void);
+#endif
+
+#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
+#define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
+
+#define xfs_binval(buftarg)		xfs_flush_buftarg(buftarg, 1)
+#define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
+
+#endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/linux/xfs_discard.c b/fs/xfs/linux/xfs_discard.c
new file mode 100644
index 0000000..244e797
--- /dev/null
+++ b/fs/xfs/linux/xfs_discard.c
@@ -0,0 +1,222 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_sb.h"
+#include "xfs_inum.h"
+#include "xfs_log.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_quota.h"
+#include "xfs_trans.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_discard.h"
+#include "xfs_trace.h"
+
+STATIC int
+xfs_trim_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_fsblock_t		start,
+	xfs_fsblock_t		len,
+	xfs_fsblock_t		minlen,
+	__uint64_t		*blocks_trimmed)
+{
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
+	int			error;
+	int			i;
+
+	pag = xfs_perag_get(mp, agno);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error || !agbp)
+		goto out_put_perag;
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
+
+	/*
+	 * Force out the log.  This means any transactions that might have freed
+	 * space before we took the AGF buffer lock are now on disk, and the
+	 * volatile disk cache is flushed.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * Look up the longest btree in the AGF and start with it.
+	 */
+	error = xfs_alloc_lookup_le(cur, 0,
+				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+	if (error)
+		goto out_del_cursor;
+
+	/*
+	 * Loop until we are done with all extents that are large
+	 * enough to be worth discarding.
+	 */
+	while (i) {
+		xfs_agblock_t fbno;
+		xfs_extlen_t flen;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto out_del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
+		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+
+		/*
+		 * Too small?  Give up.
+		 */
+		if (flen < minlen) {
+			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
+			goto out_del_cursor;
+		}
+
+		/*
+		 * If the extent is entirely outside of the range we are
+		 * supposed to discard skip it.  Do not bother to trim
+		 * down partially overlapping ranges for now.
+		 */
+		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
+		    XFS_AGB_TO_FSB(mp, agno, fbno) >= start + len) {
+			trace_xfs_discard_exclude(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		/*
+		 * If any blocks in the range are still busy, skip the
+		 * discard and try again the next time.
+		 */
+		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
+			trace_xfs_discard_busy(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		trace_xfs_discard_extent(mp, agno, fbno, flen);
+		error = -blkdev_issue_discard(bdev,
+				XFS_AGB_TO_DADDR(mp, agno, fbno),
+				XFS_FSB_TO_BB(mp, flen),
+				GFP_NOFS, 0);
+		if (error)
+			goto out_del_cursor;
+		*blocks_trimmed += flen;
+
+next_extent:
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto out_del_cursor;
+	}
+
+out_del_cursor:
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+out_put_perag:
+	xfs_perag_put(pag);
+	return error;
+}
+
+int
+xfs_ioc_trim(
+	struct xfs_mount		*mp,
+	struct fstrim_range __user	*urange)
+{
+	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
+	unsigned int		granularity = q->limits.discard_granularity;
+	struct fstrim_range	range;
+	xfs_fsblock_t		start, len, minlen;
+	xfs_agnumber_t		start_agno, end_agno, agno;
+	__uint64_t		blocks_trimmed = 0;
+	int			error, last_error = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (!blk_queue_discard(q))
+		return -XFS_ERROR(EOPNOTSUPP);
+	if (copy_from_user(&range, urange, sizeof(range)))
+		return -XFS_ERROR(EFAULT);
+
+	/*
+	 * Truncating down the len isn't actually quite correct, but using
+	 * XFS_B_TO_FSB would mean we trivially get overflows for values
+	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
+	 * used by the fstrim application.  In the end it really doesn't
+	 * matter as trimming blocks is an advisory interface.
+	 */
+	start = XFS_B_TO_FSBT(mp, range.start);
+	len = XFS_B_TO_FSBT(mp, range.len);
+	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
+
+	start_agno = XFS_FSB_TO_AGNO(mp, start);
+	if (start_agno >= mp->m_sb.sb_agcount)
+		return -XFS_ERROR(EINVAL);
+
+	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
+	if (end_agno >= mp->m_sb.sb_agcount)
+		end_agno = mp->m_sb.sb_agcount - 1;
+
+	for (agno = start_agno; agno <= end_agno; agno++) {
+		error = -xfs_trim_extents(mp, agno, start, len, minlen,
+					  &blocks_trimmed);
+		if (error)
+			last_error = error;
+	}
+
+	if (last_error)
+		return last_error;
+
+	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
+	if (copy_to_user(urange, &range, sizeof(range)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+int
+xfs_discard_extents(
+	struct xfs_mount	*mp,
+	struct list_head	*list)
+{
+	struct xfs_busy_extent	*busyp;
+	int			error = 0;
+
+	list_for_each_entry(busyp, list, list) {
+		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+					 busyp->length);
+
+		error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, 0);
+		if (error && error != EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for extent [0x%llu,%u], error %d",
+				 (unsigned long long)busyp->bno,
+				 busyp->length,
+				 error);
+			return error;
+		}
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/linux/xfs_discard.h b/fs/xfs/linux/xfs_discard.h
new file mode 100644
index 0000000..344879a
--- /dev/null
+++ b/fs/xfs/linux/xfs_discard.h
@@ -0,0 +1,10 @@
+#ifndef XFS_DISCARD_H
+#define XFS_DISCARD_H 1
+
+struct fstrim_range;
+struct list_head;
+
+extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
+extern int	xfs_discard_extents(struct xfs_mount *, struct list_head *);
+
+#endif /* XFS_DISCARD_H */
diff --git a/fs/xfs/linux/xfs_export.c b/fs/xfs/linux/xfs_export.c
new file mode 100644
index 0000000..75e5d32
--- /dev/null
+++ b/fs/xfs/linux/xfs_export.c
@@ -0,0 +1,250 @@
+/*
+ * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_types.h"
+#include "xfs_inum.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_mount.h"
+#include "xfs_export.h"
+#include "xfs_vnodeops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_trace.h"
+
+/*
+ * Note that we only accept fileids which are long enough rather than allow
+ * the parent generation number to default to zero.  XFS considers zero a
+ * valid generation number not an invalid/wildcard value.
+ */
+static int xfs_fileid_length(int fileid_type)
+{
+	switch (fileid_type) {
+	case FILEID_INO32_GEN:
+		return 2;
+	case FILEID_INO32_GEN_PARENT:
+		return 4;
+	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
+		return 3;
+	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
+		return 6;
+	}
+	return 255; /* invalid */
+}
+
+STATIC int
+xfs_fs_encode_fh(
+	struct dentry		*dentry,
+	__u32			*fh,
+	int			*max_len,
+	int			connectable)
+{
+	struct fid		*fid = (struct fid *)fh;
+	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
+	struct inode		*inode = dentry->d_inode;
+	int			fileid_type;
+	int			len;
+
+	/* Directories don't need their parent encoded, they have ".." */
+	if (S_ISDIR(inode->i_mode) || !connectable)
+		fileid_type = FILEID_INO32_GEN;
+	else
+		fileid_type = FILEID_INO32_GEN_PARENT;
+
+	/*
+	 * If the the filesystem may contain 64bit inode numbers, we need
+	 * to use larger file handles that can represent them.
+	 *
+	 * While we only allocate inodes that do not fit into 32 bits any
+	 * large enough filesystem may contain them, thus the slightly
+	 * confusing looking conditional below.
+	 */
+	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS) ||
+	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
+		fileid_type |= XFS_FILEID_TYPE_64FLAG;
+
+	/*
+	 * Only encode if there is enough space given.  In practice
+	 * this means we can't export a filesystem with 64bit inodes
+	 * over NFSv2 with the subtree_check export option; the other
+	 * seven combinations work.  The real answer is "don't use v2".
+	 */
+	len = xfs_fileid_length(fileid_type);
+	if (*max_len < len) {
+		*max_len = len;
+		return 255;
+	}
+	*max_len = len;
+
+	switch (fileid_type) {
+	case FILEID_INO32_GEN_PARENT:
+		spin_lock(&dentry->d_lock);
+		fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
+		spin_unlock(&dentry->d_lock);
+		/*FALLTHRU*/
+	case FILEID_INO32_GEN:
+		fid->i32.ino = inode->i_ino;
+		fid->i32.gen = inode->i_generation;
+		break;
+	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
+		spin_lock(&dentry->d_lock);
+		fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
+		spin_unlock(&dentry->d_lock);
+		/*FALLTHRU*/
+	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
+		fid64->ino = inode->i_ino;
+		fid64->gen = inode->i_generation;
+		break;
+	}
+
+	return fileid_type;
+}
+
+STATIC struct inode *
+xfs_nfs_get_inode(
+	struct super_block	*sb,
+	u64			ino,
+	u32			generation)
+ {
+ 	xfs_mount_t		*mp = XFS_M(sb);
+	xfs_inode_t		*ip;
+	int			error;
+
+	/*
+	 * NFS can sometimes send requests for ino 0.  Fail them gracefully.
+	 */
+	if (ino == 0)
+		return ERR_PTR(-ESTALE);
+
+	/*
+	 * The XFS_IGET_UNTRUSTED means that an invalid inode number is just
+	 * fine and not an indication of a corrupted filesystem as clients can
+	 * send invalid file handles and we have to handle it gracefully..
+	 */
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error) {
+		/*
+		 * EINVAL means the inode cluster doesn't exist anymore.
+		 * This implies the filehandle is stale, so we should
+		 * translate it here.
+		 * We don't use ESTALE directly down the chain to not
+		 * confuse applications using bulkstat that expect EINVAL.
+		 */
+		if (error == EINVAL || error == ENOENT)
+			error = ESTALE;
+		return ERR_PTR(-error);
+	}
+
+	if (ip->i_d.di_gen != generation) {
+		IRELE(ip);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return VFS_I(ip);
+}
+
+STATIC struct dentry *
+xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		 int fh_len, int fileid_type)
+{
+	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
+	struct inode		*inode = NULL;
+
+	if (fh_len < xfs_fileid_length(fileid_type))
+		return NULL;
+
+	switch (fileid_type) {
+	case FILEID_INO32_GEN_PARENT:
+	case FILEID_INO32_GEN:
+		inode = xfs_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen);
+		break;
+	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
+	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
+		inode = xfs_nfs_get_inode(sb, fid64->ino, fid64->gen);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
+STATIC struct dentry *
+xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		 int fh_len, int fileid_type)
+{
+	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
+	struct inode		*inode = NULL;
+
+	switch (fileid_type) {
+	case FILEID_INO32_GEN_PARENT:
+		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
+					      fid->i32.parent_gen);
+		break;
+	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
+		inode = xfs_nfs_get_inode(sb, fid64->parent_ino,
+					      fid64->parent_gen);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
+STATIC struct dentry *
+xfs_fs_get_parent(
+	struct dentry		*child)
+{
+	int			error;
+	struct xfs_inode	*cip;
+
+	error = xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip, NULL);
+	if (unlikely(error))
+		return ERR_PTR(-error);
+
+	return d_obtain_alias(VFS_I(cip));
+}
+
+STATIC int
+xfs_fs_nfs_commit_metadata(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip)) {
+		error = _xfs_log_force_lsn(mp, ip->i_itemp->ili_last_lsn,
+				XFS_LOG_SYNC, NULL);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	return error;
+}
+
+const struct export_operations xfs_export_operations = {
+	.encode_fh		= xfs_fs_encode_fh,
+	.fh_to_dentry		= xfs_fs_fh_to_dentry,
+	.fh_to_parent		= xfs_fs_fh_to_parent,
+	.get_parent		= xfs_fs_get_parent,
+	.commit_metadata	= xfs_fs_nfs_commit_metadata,
+};
diff --git a/fs/xfs/linux/xfs_export.h b/fs/xfs/linux/xfs_export.h
new file mode 100644
index 0000000..3272b6a
--- /dev/null
+++ b/fs/xfs/linux/xfs_export.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_EXPORT_H__
+#define __XFS_EXPORT_H__
+
+/*
+ * Common defines for code related to exporting XFS filesystems over NFS.
+ *
+ * The NFS fileid goes out on the wire as an array of
+ * 32bit unsigned ints in host order.  There are 5 possible
+ * formats.
+ *
+ * (1)	fileid_type=0x00
+ *	(no fileid data; handled by the generic code)
+ *
+ * (2)	fileid_type=0x01
+ *	inode-num
+ *	generation
+ *
+ * (3)	fileid_type=0x02
+ *	inode-num
+ *	generation
+ *	parent-inode-num
+ *	parent-generation
+ *
+ * (4)	fileid_type=0x81
+ *	inode-num-lo32
+ *	inode-num-hi32
+ *	generation
+ *
+ * (5)	fileid_type=0x82
+ *	inode-num-lo32
+ *	inode-num-hi32
+ *	generation
+ *	parent-inode-num-lo32
+ *	parent-inode-num-hi32
+ *	parent-generation
+ *
+ * Note, the NFS filehandle also includes an fsid portion which
+ * may have an inode number in it.  That number is hardcoded to
+ * 32bits and there is no way for XFS to intercept it.  In
+ * practice this means when exporting an XFS filesystem with 64bit
+ * inodes you should either export the mountpoint (rather than
+ * a subdirectory) or use the "fsid" export option.
+ */
+
+struct xfs_fid64 {
+	u64 ino;
+	u32 gen;
+	u64 parent_ino;
+	u32 parent_gen;
+} __attribute__((packed));
+
+/* This flag goes on the wire.  Don't play with it. */
+#define XFS_FILEID_TYPE_64FLAG	0x80	/* NFS fileid has 64bit inodes */
+
+#endif	/* __XFS_EXPORT_H__ */
diff --git a/fs/xfs/linux/xfs_file.c b/fs/xfs/linux/xfs_file.c
new file mode 100644
index 0000000..8073f61
--- /dev/null
+++ b/fs/xfs/linux/xfs_file.c
@@ -0,0 +1,1092 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_trans.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_vnodeops.h"
+#include "xfs_da_btree.h"
+#include "xfs_ioctl.h"
+#include "xfs_trace.h"
+
+#include <linux/dcache.h>
+#include <linux/falloc.h>
+
+static const struct vm_operations_struct xfs_file_vm_ops;
+
+/*
+ * Locking primitives for read and write IO paths to ensure we consistently use
+ * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
+ */
+static inline void
+xfs_rw_ilock(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_lock(&VFS_I(ip)->i_mutex);
+	xfs_ilock(ip, type);
+}
+
+static inline void
+xfs_rw_iunlock(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	xfs_iunlock(ip, type);
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_unlock(&VFS_I(ip)->i_mutex);
+}
+
+static inline void
+xfs_rw_ilock_demote(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	xfs_ilock_demote(ip, type);
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_unlock(&VFS_I(ip)->i_mutex);
+}
+
+/*
+ *	xfs_iozero
+ *
+ *	xfs_iozero clears the specified range of buffer supplied,
+ *	and marks all the affected blocks as valid and modified.  If
+ *	an affected block is not allocated, it will be allocated.  If
+ *	an affected block is not completely overwritten, and is not
+ *	valid before the operation, it will be read from disk before
+ *	being partially zeroed.
+ */
+STATIC int
+xfs_iozero(
+	struct xfs_inode	*ip,	/* inode			*/
+	loff_t			pos,	/* offset in file		*/
+	size_t			count)	/* size of data to zero		*/
+{
+	struct page		*page;
+	struct address_space	*mapping;
+	int			status;
+
+	mapping = VFS_I(ip)->i_mapping;
+	do {
+		unsigned offset, bytes;
+		void *fsdata;
+
+		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
+		bytes = PAGE_CACHE_SIZE - offset;
+		if (bytes > count)
+			bytes = count;
+
+		status = pagecache_write_begin(NULL, mapping, pos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
+		if (status)
+			break;
+
+		zero_user(page, offset, bytes);
+
+		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
+					page, fsdata);
+		WARN_ON(status <= 0); /* can't return less than zero! */
+		pos += bytes;
+		count -= bytes;
+		status = 0;
+	} while (count);
+
+	return (-status);
+}
+
+STATIC int
+xfs_file_fsync(
+	struct file		*file,
+	int			datasync)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error = 0;
+	int			log_flushed = 0;
+
+	trace_xfs_file_fsync(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+
+	xfs_ioend_wait(ip);
+
+	if (mp->m_flags & XFS_MOUNT_BARRIER) {
+		/*
+		 * If we have an RT and/or log subvolume we need to make sure
+		 * to flush the write cache the device used for file data
+		 * first.  This is to ensure newly written file data make
+		 * it to disk before logging the new inode size in case of
+		 * an extending write.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip))
+			xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+		else if (mp->m_logdev_targp != mp->m_ddev_targp)
+			xfs_blkdev_issue_flush(mp->m_ddev_targp);
+	}
+
+	/*
+	 * We always need to make sure that the required inode state is safe on
+	 * disk.  The inode might be clean but we still might need to force the
+	 * log because of committed transactions that haven't hit the disk yet.
+	 * Likewise, there could be unflushed non-transactional changes to the
+	 * inode core that have to go to disk and this requires us to issue
+	 * a synchronous transaction to capture these changes correctly.
+	 *
+	 * This code relies on the assumption that if the i_update_core field
+	 * of the inode is clear and the inode is unpinned then it is clean
+	 * and no action is required.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+
+	/*
+	 * First check if the VFS inode is marked dirty.  All the dirtying
+	 * of non-transactional updates no goes through mark_inode_dirty*,
+	 * which allows us to distinguish beteeen pure timestamp updates
+	 * and i_size updates which need to be caught for fdatasync.
+	 * After that also theck for the dirty state in the XFS inode, which
+	 * might gets cleared when the inode gets written out via the AIL
+	 * or xfs_iflush_cluster.
+	 */
+	if (((inode->i_state & I_DIRTY_DATASYNC) ||
+	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
+	    ip->i_update_core) {
+		/*
+		 * Kick off a transaction to log the inode core to get the
+		 * updates.  The sync transaction will also force the log.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+		error = xfs_trans_reserve(tp, 0,
+				XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+		if (error) {
+			xfs_trans_cancel(tp, 0);
+			return -error;
+		}
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+		/*
+		 * Note - it's possible that we might have pushed ourselves out
+		 * of the way during trans_reserve which would flush the inode.
+		 * But there's no guarantee that the inode buffer has actually
+		 * gone out yet (it's delwri).	Plus the buffer could be pinned
+		 * anyway if it's part of an inode in another recent
+		 * transaction.	 So we play it safe and fire off the
+		 * transaction anyway.
+		 */
+		xfs_trans_ijoin(tp, ip);
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		xfs_trans_set_sync(tp);
+		error = _xfs_trans_commit(tp, 0, &log_flushed);
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	} else {
+		/*
+		 * Timestamps/size haven't changed since last inode flush or
+		 * inode transaction commit.  That means either nothing got
+		 * written or a transaction committed which caught the updates.
+		 * If the latter happened and the transaction hasn't hit the
+		 * disk yet, the inode will be still be pinned.  If it is,
+		 * force the log.
+		 */
+		if (xfs_ipincount(ip)) {
+			error = _xfs_log_force_lsn(mp,
+					ip->i_itemp->ili_last_lsn,
+					XFS_LOG_SYNC, &log_flushed);
+		}
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	}
+
+	/*
+	 * If we only have a single device, and the log force about was
+	 * a no-op we might have to flush the data device cache here.
+	 * This can only happen for fdatasync/O_DSYNC if we were overwriting
+	 * an already allocated file and thus do not have any metadata to
+	 * commit.
+	 */
+	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
+	    mp->m_logdev_targp == mp->m_ddev_targp &&
+	    !XFS_IS_REALTIME_INODE(ip) &&
+	    !log_flushed)
+		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+
+	return -error;
+}
+
+STATIC ssize_t
+xfs_file_aio_read(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos)
+{
+	struct file		*file = iocb->ki_filp;
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	size_t			size = 0;
+	ssize_t			ret = 0;
+	int			ioflags = 0;
+	xfs_fsize_t		n;
+	unsigned long		seg;
+
+	XFS_STATS_INC(xs_read_calls);
+
+	BUG_ON(iocb->ki_pos != pos);
+
+	if (unlikely(file->f_flags & O_DIRECT))
+		ioflags |= IO_ISDIRECT;
+	if (file->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	/* START copy & waste from filemap.c */
+	for (seg = 0; seg < nr_segs; seg++) {
+		const struct iovec *iv = &iovp[seg];
+
+		/*
+		 * If any segment has a negative length, or the cumulative
+		 * length ever wraps negative then return -EINVAL.
+		 */
+		size += iv->iov_len;
+		if (unlikely((ssize_t)(size|iv->iov_len) < 0))
+			return XFS_ERROR(-EINVAL);
+	}
+	/* END copy & waste from filemap.c */
+
+	if (unlikely(ioflags & IO_ISDIRECT)) {
+		xfs_buftarg_t	*target =
+			XFS_IS_REALTIME_INODE(ip) ?
+				mp->m_rtdev_targp : mp->m_ddev_targp;
+		if ((iocb->ki_pos & target->bt_smask) ||
+		    (size & target->bt_smask)) {
+			if (iocb->ki_pos == ip->i_size)
+				return 0;
+			return -XFS_ERROR(EINVAL);
+		}
+	}
+
+	n = XFS_MAXIOFFSET(mp) - iocb->ki_pos;
+	if (n <= 0 || size == 0)
+		return 0;
+
+	if (n < size)
+		size = n;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	if (unlikely(ioflags & IO_ISDIRECT)) {
+		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+
+		if (inode->i_mapping->nrpages) {
+			ret = -xfs_flushinval_pages(ip,
+					(iocb->ki_pos & PAGE_CACHE_MASK),
+					-1, FI_REMAPF_LOCKED);
+			if (ret) {
+				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
+				return ret;
+			}
+		}
+		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+	} else
+		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+
+	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
+
+	ret = generic_file_aio_read(iocb, iovp, nr_segs, iocb->ki_pos);
+	if (ret > 0)
+		XFS_STATS_ADD(xs_read_bytes, ret);
+
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_splice_read(
+	struct file		*infilp,
+	loff_t			*ppos,
+	struct pipe_inode_info	*pipe,
+	size_t			count,
+	unsigned int		flags)
+{
+	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
+	int			ioflags = 0;
+	ssize_t			ret;
+
+	XFS_STATS_INC(xs_read_calls);
+
+	if (infilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+
+	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
+
+	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
+	if (ret > 0)
+		XFS_STATS_ADD(xs_read_bytes, ret);
+
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	return ret;
+}
+
+STATIC void
+xfs_aio_write_isize_update(
+	struct inode	*inode,
+	loff_t		*ppos,
+	ssize_t		bytes_written)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fsize_t		isize = i_size_read(inode);
+
+	if (bytes_written > 0)
+		XFS_STATS_ADD(xs_write_bytes, bytes_written);
+
+	if (unlikely(bytes_written < 0 && bytes_written != -EFAULT &&
+					*ppos > isize))
+		*ppos = isize;
+
+	if (*ppos > ip->i_size) {
+		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
+		if (*ppos > ip->i_size)
+			ip->i_size = *ppos;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+}
+
+/*
+ * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
+ * part of the I/O may have been written to disk before the error occurred.  In
+ * this case the on-disk file size may have been adjusted beyond the in-memory
+ * file size and now needs to be truncated back.
+ */
+STATIC void
+xfs_aio_write_newsize_update(
+	struct xfs_inode	*ip)
+{
+	if (ip->i_new_size) {
+		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
+		ip->i_new_size = 0;
+		if (ip->i_d.di_size > ip->i_size)
+			ip->i_d.di_size = ip->i_size;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+}
+
+/*
+ * xfs_file_splice_write() does not use xfs_rw_ilock() because
+ * generic_file_splice_write() takes the i_mutex itself. This, in theory,
+ * couuld cause lock inversions between the aio_write path and the splice path
+ * if someone is doing concurrent splice(2) based writes and write(2) based
+ * writes to the same inode. The only real way to fix this is to re-implement
+ * the generic code here with correct locking orders.
+ */
+STATIC ssize_t
+xfs_file_splice_write(
+	struct pipe_inode_info	*pipe,
+	struct file		*outfilp,
+	loff_t			*ppos,
+	size_t			count,
+	unsigned int		flags)
+{
+	struct inode		*inode = outfilp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fsize_t		new_size;
+	int			ioflags = 0;
+	ssize_t			ret;
+
+	XFS_STATS_INC(xs_write_calls);
+
+	if (outfilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	new_size = *ppos + count;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (new_size > ip->i_size)
+		ip->i_new_size = new_size;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
+
+	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+
+	xfs_aio_write_isize_update(inode, ppos, ret);
+	xfs_aio_write_newsize_update(ip);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return ret;
+}
+
+/*
+ * This routine is called to handle zeroing any space in the last
+ * block of the file that is beyond the EOF.  We do this since the
+ * size is being increased without writing anything to that block
+ * and we don't want anyone to read the garbage on the disk.
+ */
+STATIC int				/* error (positive) */
+xfs_zero_last_block(
+	xfs_inode_t	*ip,
+	xfs_fsize_t	offset,
+	xfs_fsize_t	isize)
+{
+	xfs_fileoff_t	last_fsb;
+	xfs_mount_t	*mp = ip->i_mount;
+	int		nimaps;
+	int		zero_offset;
+	int		zero_len;
+	int		error = 0;
+	xfs_bmbt_irec_t	imap;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
+	if (zero_offset == 0) {
+		/*
+		 * There are no extra bytes in the last block on disk to
+		 * zero, so return.
+		 */
+		return 0;
+	}
+
+	last_fsb = XFS_B_TO_FSBT(mp, isize);
+	nimaps = 1;
+	error = xfs_bmapi(NULL, ip, last_fsb, 1, 0, NULL, 0, &imap,
+			  &nimaps, NULL);
+	if (error) {
+		return error;
+	}
+	ASSERT(nimaps > 0);
+	/*
+	 * If the block underlying isize is just a hole, then there
+	 * is nothing to zero.
+	 */
+	if (imap.br_startblock == HOLESTARTBLOCK) {
+		return 0;
+	}
+	/*
+	 * Zero the part of the last block beyond the EOF, and write it
+	 * out sync.  We need to drop the ilock while we do this so we
+	 * don't deadlock when the buffer cache calls back to us.
+	 */
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	zero_len = mp->m_sb.sb_blocksize - zero_offset;
+	if (isize + zero_len > offset)
+		zero_len = offset - isize;
+	error = xfs_iozero(ip, isize, zero_len);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	ASSERT(error >= 0);
+	return error;
+}
+
+/*
+ * Zero any on disk space between the current EOF and the new,
+ * larger EOF.  This handles the normal case of zeroing the remainder
+ * of the last block in the file and the unusual case of zeroing blocks
+ * out beyond the size of the file.  This second case only happens
+ * with fixed size extents and when the system crashes before the inode
+ * size was updated but after blocks were allocated.  If fill is set,
+ * then any holes in the range are filled and zeroed.  If not, the holes
+ * are left alone as holes.
+ */
+
+int					/* error (positive) */
+xfs_zero_eof(
+	xfs_inode_t	*ip,
+	xfs_off_t	offset,		/* starting I/O offset */
+	xfs_fsize_t	isize)		/* current inode size */
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_fileoff_t	start_zero_fsb;
+	xfs_fileoff_t	end_zero_fsb;
+	xfs_fileoff_t	zero_count_fsb;
+	xfs_fileoff_t	last_fsb;
+	xfs_fileoff_t	zero_off;
+	xfs_fsize_t	zero_len;
+	int		nimaps;
+	int		error = 0;
+	xfs_bmbt_irec_t	imap;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+	ASSERT(offset > isize);
+
+	/*
+	 * First handle zeroing the block on which isize resides.
+	 * We only zero a part of that block so it is handled specially.
+	 */
+	error = xfs_zero_last_block(ip, offset, isize);
+	if (error) {
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+		return error;
+	}
+
+	/*
+	 * Calculate the range between the new size and the old
+	 * where blocks needing to be zeroed may exist.  To get the
+	 * block where the last byte in the file currently resides,
+	 * we need to subtract one from the size and truncate back
+	 * to a block boundary.  We subtract 1 in case the size is
+	 * exactly on a block boundary.
+	 */
+	last_fsb = isize ? XFS_B_TO_FSBT(mp, isize - 1) : (xfs_fileoff_t)-1;
+	start_zero_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
+	end_zero_fsb = XFS_B_TO_FSBT(mp, offset - 1);
+	ASSERT((xfs_sfiloff_t)last_fsb < (xfs_sfiloff_t)start_zero_fsb);
+	if (last_fsb == end_zero_fsb) {
+		/*
+		 * The size was only incremented on its last block.
+		 * We took care of that above, so just return.
+		 */
+		return 0;
+	}
+
+	ASSERT(start_zero_fsb <= end_zero_fsb);
+	while (start_zero_fsb <= end_zero_fsb) {
+		nimaps = 1;
+		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
+		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
+				  0, NULL, 0, &imap, &nimaps, NULL);
+		if (error) {
+			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+			return error;
+		}
+		ASSERT(nimaps > 0);
+
+		if (imap.br_state == XFS_EXT_UNWRITTEN ||
+		    imap.br_startblock == HOLESTARTBLOCK) {
+			/*
+			 * This loop handles initializing pages that were
+			 * partially initialized by the code below this
+			 * loop. It basically zeroes the part of the page
+			 * that sits on a hole and sets the page as P_HOLE
+			 * and calls remapf if it is a mapped file.
+			 */
+			start_zero_fsb = imap.br_startoff + imap.br_blockcount;
+			ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
+			continue;
+		}
+
+		/*
+		 * There are blocks we need to zero.
+		 * Drop the inode lock while we're doing the I/O.
+		 * We'll still have the iolock to protect us.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
+		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
+
+		if ((zero_off + zero_len) > offset)
+			zero_len = offset - zero_off;
+
+		error = xfs_iozero(ip, zero_off, zero_len);
+		if (error) {
+			goto out_lock;
+		}
+
+		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
+		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+	}
+
+	return 0;
+
+out_lock:
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	ASSERT(error >= 0);
+	return error;
+}
+
+/*
+ * Common pre-write limit and setup checks.
+ *
+ * Returns with iolock held according to @iolock.
+ */
+STATIC ssize_t
+xfs_file_aio_write_checks(
+	struct file		*file,
+	loff_t			*pos,
+	size_t			*count,
+	int			*iolock)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fsize_t		new_size;
+	int			error = 0;
+
+	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
+	if (error) {
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
+		*iolock = 0;
+		return error;
+	}
+
+	new_size = *pos + *count;
+	if (new_size > ip->i_size)
+		ip->i_new_size = new_size;
+
+	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
+		file_update_time(file);
+
+	/*
+	 * If the offset is beyond the size of the file, we need to zero any
+	 * blocks that fall between the existing EOF and the start of this
+	 * write.
+	 */
+	if (*pos > ip->i_size)
+		error = -xfs_zero_eof(ip, *pos, ip->i_size);
+
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	/*
+	 * If we're writing the file then make sure to clear the setuid and
+	 * setgid bits if the process is not being run by root.  This keeps
+	 * people from modifying setuid and setgid binaries.
+	 */
+	return file_remove_suid(file);
+
+}
+
+/*
+ * xfs_file_dio_aio_write - handle direct IO writes
+ *
+ * Lock the inode appropriately to prepare for and issue a direct IO write.
+ * By separating it from the buffered write path we remove all the tricky to
+ * follow locking changes and looping.
+ *
+ * If there are cached pages or we're extending the file, we need IOLOCK_EXCL
+ * until we're sure the bytes at the new EOF have been zeroed and/or the cached
+ * pages are flushed out.
+ *
+ * In most cases the direct IO writes will be done holding IOLOCK_SHARED
+ * allowing them to be done in parallel with reads and other direct IO writes.
+ * However, if the IO is not aligned to filesystem blocks, the direct IO layer
+ * needs to do sub-block zeroing and that requires serialisation against other
+ * direct IOs to the same block. In this case we need to serialise the
+ * submission of the unaligned IOs so that we don't get racing block zeroing in
+ * the dio layer.  To avoid the problem with aio, we also need to wait for
+ * outstanding IOs to complete so that unwritten extent conversion is completed
+ * before we try to map the overlapping block. This is currently implemented by
+ * hitting it with a big hammer (i.e. xfs_ioend_wait()).
+ *
+ * Returns with locks held indicated by @iolock and errors indicated by
+ * negative return values.
+ */
+STATIC ssize_t
+xfs_file_dio_aio_write(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos,
+	size_t			ocount,
+	int			*iolock)
+{
+	struct file		*file = iocb->ki_filp;
+	struct address_space	*mapping = file->f_mapping;
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	ssize_t			ret = 0;
+	size_t			count = ocount;
+	int			unaligned_io = 0;
+	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
+					mp->m_rtdev_targp : mp->m_ddev_targp;
+
+	*iolock = 0;
+	if ((pos & target->bt_smask) || (count & target->bt_smask))
+		return -XFS_ERROR(EINVAL);
+
+	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+		unaligned_io = 1;
+
+	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
+		*iolock = XFS_IOLOCK_EXCL;
+	else
+		*iolock = XFS_IOLOCK_SHARED;
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (ret)
+		return ret;
+
+	if (mapping->nrpages) {
+		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
+		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
+							FI_REMAPF_LOCKED);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * If we are doing unaligned IO, wait for all other IO to drain,
+	 * otherwise demote the lock if we had to flush cached pages
+	 */
+	if (unaligned_io)
+		xfs_ioend_wait(ip);
+	else if (*iolock == XFS_IOLOCK_EXCL) {
+		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		*iolock = XFS_IOLOCK_SHARED;
+	}
+
+	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
+	ret = generic_file_direct_write(iocb, iovp,
+			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+
+	/* No fallback to buffered IO on errors for XFS. */
+	ASSERT(ret < 0 || ret == count);
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_buffered_aio_write(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos,
+	size_t			ocount,
+	int			*iolock)
+{
+	struct file		*file = iocb->ki_filp;
+	struct address_space	*mapping = file->f_mapping;
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	ssize_t			ret;
+	int			enospc = 0;
+	size_t			count = ocount;
+
+	*iolock = XFS_IOLOCK_EXCL;
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (ret)
+		return ret;
+
+	/* We can write back this queue in page reclaim */
+	current->backing_dev_info = mapping->backing_dev_info;
+
+write_retry:
+	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
+	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
+			pos, &iocb->ki_pos, count, ret);
+	/*
+	 * if we just got an ENOSPC, flush the inode now we aren't holding any
+	 * page locks and retry *once*
+	 */
+	if (ret == -ENOSPC && !enospc) {
+		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		if (ret)
+			return ret;
+		enospc = 1;
+		goto write_retry;
+	}
+	current->backing_dev_info = NULL;
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_aio_write(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos)
+{
+	struct file		*file = iocb->ki_filp;
+	struct address_space	*mapping = file->f_mapping;
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	ssize_t			ret;
+	int			iolock;
+	size_t			ocount = 0;
+
+	XFS_STATS_INC(xs_write_calls);
+
+	BUG_ON(iocb->ki_pos != pos);
+
+	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
+	if (ret)
+		return ret;
+
+	if (ocount == 0)
+		return 0;
+
+	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	if (unlikely(file->f_flags & O_DIRECT))
+		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
+						ocount, &iolock);
+	else
+		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
+						ocount, &iolock);
+
+	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
+
+	if (ret <= 0)
+		goto out_unlock;
+
+	/* Handle various SYNC-type writes */
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
+		loff_t end = pos + ret - 1;
+		int error, error2;
+
+		xfs_rw_iunlock(ip, iolock);
+		error = filemap_write_and_wait_range(mapping, pos, end);
+		xfs_rw_ilock(ip, iolock);
+
+		error2 = -xfs_file_fsync(file,
+					 (file->f_flags & __O_SYNC) ? 0 : 1);
+		if (error)
+			ret = error;
+		else if (error2)
+			ret = error2;
+	}
+
+out_unlock:
+	xfs_aio_write_newsize_update(ip);
+	xfs_rw_iunlock(ip, iolock);
+	return ret;
+}
+
+STATIC long
+xfs_file_fallocate(
+	struct file	*file,
+	int		mode,
+	loff_t		offset,
+	loff_t		len)
+{
+	struct inode	*inode = file->f_path.dentry->d_inode;
+	long		error;
+	loff_t		new_size = 0;
+	xfs_flock64_t	bf;
+	xfs_inode_t	*ip = XFS_I(inode);
+	int		cmd = XFS_IOC_RESVSP;
+	int		attr_flags = XFS_ATTR_NOLOCK;
+
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
+	bf.l_whence = 0;
+	bf.l_start = offset;
+	bf.l_len = len;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = XFS_IOC_UNRESVSP;
+
+	/* check the new inode size is valid before allocating */
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + len > i_size_read(inode)) {
+		new_size = offset + len;
+		error = inode_newsize_ok(inode, new_size);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
+	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
+	if (error)
+		goto out_unlock;
+
+	/* Change file size if needed */
+	if (new_size) {
+		struct iattr iattr;
+
+		iattr.ia_valid = ATTR_SIZE;
+		iattr.ia_size = new_size;
+		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
+	}
+
+out_unlock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
+
+STATIC int
+xfs_file_open(
+	struct inode	*inode,
+	struct file	*file)
+{
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+		return -EFBIG;
+	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
+		return -EIO;
+	return 0;
+}
+
+STATIC int
+xfs_dir_open(
+	struct inode	*inode,
+	struct file	*file)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	int		mode;
+	int		error;
+
+	error = xfs_file_open(inode, file);
+	if (error)
+		return error;
+
+	/*
+	 * If there are any blocks, read-ahead block 0 as we're almost
+	 * certain to have the next operation be a read there.
+	 */
+	mode = xfs_ilock_map_shared(ip);
+	if (ip->i_d.di_nextents > 0)
+		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
+	xfs_iunlock(ip, mode);
+	return 0;
+}
+
+STATIC int
+xfs_file_release(
+	struct inode	*inode,
+	struct file	*filp)
+{
+	return -xfs_release(XFS_I(inode));
+}
+
+STATIC int
+xfs_file_readdir(
+	struct file	*filp,
+	void		*dirent,
+	filldir_t	filldir)
+{
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+	xfs_inode_t	*ip = XFS_I(inode);
+	int		error;
+	size_t		bufsize;
+
+	/*
+	 * The Linux API doesn't pass down the total size of the buffer
+	 * we read into down to the filesystem.  With the filldir concept
+	 * it's not needed for correct information, but the XFS dir2 leaf
+	 * code wants an estimate of the buffer size to calculate it's
+	 * readahead window and size the buffers used for mapping to
+	 * physical blocks.
+	 *
+	 * Try to give it an estimate that's good enough, maybe at some
+	 * point we can change the ->readdir prototype to include the
+	 * buffer size.  For now we use the current glibc buffer size.
+	 */
+	bufsize = (size_t)min_t(loff_t, 32768, ip->i_d.di_size);
+
+	error = xfs_readdir(ip, dirent, bufsize,
+				(xfs_off_t *)&filp->f_pos, filldir);
+	if (error)
+		return -error;
+	return 0;
+}
+
+STATIC int
+xfs_file_mmap(
+	struct file	*filp,
+	struct vm_area_struct *vma)
+{
+	vma->vm_ops = &xfs_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+
+	file_accessed(filp);
+	return 0;
+}
+
+/*
+ * mmap()d file has taken write protection fault and is being made
+ * writable. We can set the page state up correctly for a writable
+ * page, which means we can do correct delalloc accounting (ENOSPC
+ * checking!) and unwritten extent mapping.
+ */
+STATIC int
+xfs_vm_page_mkwrite(
+	struct vm_area_struct	*vma,
+	struct vm_fault		*vmf)
+{
+	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
+}
+
+const struct file_operations xfs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= xfs_file_aio_read,
+	.aio_write	= xfs_file_aio_write,
+	.splice_read	= xfs_file_splice_read,
+	.splice_write	= xfs_file_splice_write,
+	.unlocked_ioctl	= xfs_file_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= xfs_file_compat_ioctl,
+#endif
+	.mmap		= xfs_file_mmap,
+	.open		= xfs_file_open,
+	.release	= xfs_file_release,
+	.fsync		= xfs_file_fsync,
+	.fallocate	= xfs_file_fallocate,
+};
+
+const struct file_operations xfs_dir_file_operations = {
+	.open		= xfs_dir_open,
+	.read		= generic_read_dir,
+	.readdir	= xfs_file_readdir,
+	.llseek		= generic_file_llseek,
+	.unlocked_ioctl	= xfs_file_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= xfs_file_compat_ioctl,
+#endif
+	.fsync		= xfs_file_fsync,
+};
+
+static const struct vm_operations_struct xfs_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= xfs_vm_page_mkwrite,
+};
diff --git a/fs/xfs/linux/xfs_fs_subr.c b/fs/xfs/linux/xfs_fs_subr.c
new file mode 100644
index 0000000..ed88ed1
--- /dev/null
+++ b/fs/xfs/linux/xfs_fs_subr.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2000-2002,2005-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_vnodeops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+
+/*
+ * note: all filemap functions return negative error codes. These
+ * need to be inverted before returning to the xfs core functions.
+ */
+void
+xfs_tosspages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	/* can't toss partial tail pages, so mask them out */
+	last &= ~(PAGE_SIZE - 1);
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
+}
+
+int
+xfs_flushinval_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+	int		ret = 0;
+
+	trace_xfs_pagecache_inval(ip, first, last);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = filemap_write_and_wait_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	if (!ret)
+		truncate_inode_pages_range(mapping, first, last);
+	return -ret;
+}
+
+int
+xfs_flush_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	uint64_t	flags,
+	int		fiopt)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+	int		ret = 0;
+	int		ret2;
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = -filemap_fdatawrite_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	if (flags & XBF_ASYNC)
+		return ret;
+	ret2 = xfs_wait_on_pages(ip, first, last);
+	if (!ret)
+		ret = ret2;
+	return ret;
+}
+
+int
+xfs_wait_on_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+		return -filemap_fdatawait_range(mapping, first,
+					last == -1 ? ip->i_size - 1 : last);
+	}
+	return 0;
+}
diff --git a/fs/xfs/linux/xfs_globals.c b/fs/xfs/linux/xfs_globals.c
new file mode 100644
index 0000000..76e81cf
--- /dev/null
+++ b/fs/xfs/linux/xfs_globals.c
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_sysctl.h"
+
+/*
+ * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
+ * other XFS code uses these values.  Times are measured in centisecs (i.e.
+ * 100ths of a second).
+ */
+xfs_param_t xfs_params = {
+			  /*	MIN		DFLT		MAX	*/
+	.sgid_inherit	= {	0,		0,		1	},
+	.symlink_mode	= {	0,		0,		1	},
+	.panic_mask	= {	0,		0,		255	},
+	.error_level	= {	0,		3,		11	},
+	.syncd_timer	= {	1*100,		30*100,		7200*100},
+	.stats_clear	= {	0,		0,		1	},
+	.inherit_sync	= {	0,		1,		1	},
+	.inherit_nodump	= {	0,		1,		1	},
+	.inherit_noatim = {	0,		1,		1	},
+	.xfs_buf_timer	= {	100/2,		1*100,		30*100	},
+	.xfs_buf_age	= {	1*100,		15*100,		7200*100},
+	.inherit_nosym	= {	0,		0,		1	},
+	.rotorstep	= {	1,		1,		255	},
+	.inherit_nodfrg	= {	0,		1,		1	},
+	.fstrm_timer	= {	1,		30*100,		3600*100},
+};
diff --git a/fs/xfs/linux/xfs_ioctl.c b/fs/xfs/linux/xfs_ioctl.c
new file mode 100644
index 0000000..acca2c5
--- /dev/null
+++ b/fs/xfs/linux/xfs_ioctl.c
@@ -0,0 +1,1556 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_alloc.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_ioctl.h"
+#include "xfs_rtalloc.h"
+#include "xfs_itable.h"
+#include "xfs_error.h"
+#include "xfs_attr.h"
+#include "xfs_bmap.h"
+#include "xfs_buf_item.h"
+#include "xfs_utils.h"
+#include "xfs_dfrag.h"
+#include "xfs_fsops.h"
+#include "xfs_vnodeops.h"
+#include "xfs_discard.h"
+#include "xfs_quota.h"
+#include "xfs_inode_item.h"
+#include "xfs_export.h"
+#include "xfs_trace.h"
+
+#include <linux/capability.h>
+#include <linux/dcache.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/exportfs.h>
+
+/*
+ * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
+ * a file or fs handle.
+ *
+ * XFS_IOC_PATH_TO_FSHANDLE
+ *    returns fs handle for a mount point or path within that mount point
+ * XFS_IOC_FD_TO_HANDLE
+ *    returns full handle for a FD opened in user space
+ * XFS_IOC_PATH_TO_HANDLE
+ *    returns full handle for a path
+ */
+int
+xfs_find_handle(
+	unsigned int		cmd,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	int			hsize;
+	xfs_handle_t		handle;
+	struct inode		*inode;
+	struct file		*file = NULL;
+	struct path		path;
+	int			error;
+	struct xfs_inode	*ip;
+
+	if (cmd == XFS_IOC_FD_TO_HANDLE) {
+		file = fget(hreq->fd);
+		if (!file)
+			return -EBADF;
+		inode = file->f_path.dentry->d_inode;
+	} else {
+		error = user_lpath((const char __user *)hreq->path, &path);
+		if (error)
+			return error;
+		inode = path.dentry->d_inode;
+	}
+	ip = XFS_I(inode);
+
+	/*
+	 * We can only generate handles for inodes residing on a XFS filesystem,
+	 * and only for regular files, directories or symbolic links.
+	 */
+	error = -EINVAL;
+	if (inode->i_sb->s_magic != XFS_SB_MAGIC)
+		goto out_put;
+
+	error = -EBADF;
+	if (!S_ISREG(inode->i_mode) &&
+	    !S_ISDIR(inode->i_mode) &&
+	    !S_ISLNK(inode->i_mode))
+		goto out_put;
+
+
+	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
+
+	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
+		/*
+		 * This handle only contains an fsid, zero the rest.
+		 */
+		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
+		hsize = sizeof(xfs_fsid_t);
+	} else {
+		int		lock_mode;
+
+		lock_mode = xfs_ilock_map_shared(ip);
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+					sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_gen = ip->i_d.di_gen;
+		handle.ha_fid.fid_ino = ip->i_ino;
+		xfs_iunlock_map_shared(ip, lock_mode);
+
+		hsize = XFS_HSIZE(handle);
+	}
+
+	error = -EFAULT;
+	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
+	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
+		goto out_put;
+
+	error = 0;
+
+ out_put:
+	if (cmd == XFS_IOC_FD_TO_HANDLE)
+		fput(file);
+	else
+		path_put(&path);
+	return error;
+}
+
+/*
+ * No need to do permission checks on the various pathname components
+ * as the handle operations are privileged.
+ */
+STATIC int
+xfs_handle_acceptable(
+	void			*context,
+	struct dentry		*dentry)
+{
+	return 1;
+}
+
+/*
+ * Convert userspace handle data into a dentry.
+ */
+struct dentry *
+xfs_handle_to_dentry(
+	struct file		*parfilp,
+	void __user		*uhandle,
+	u32			hlen)
+{
+	xfs_handle_t		handle;
+	struct xfs_fid64	fid;
+
+	/*
+	 * Only allow handle opens under a directory.
+	 */
+	if (!S_ISDIR(parfilp->f_path.dentry->d_inode->i_mode))
+		return ERR_PTR(-ENOTDIR);
+
+	if (hlen != sizeof(xfs_handle_t))
+		return ERR_PTR(-EINVAL);
+	if (copy_from_user(&handle, uhandle, hlen))
+		return ERR_PTR(-EFAULT);
+	if (handle.ha_fid.fid_len !=
+	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
+		return ERR_PTR(-EINVAL);
+
+	memset(&fid, 0, sizeof(struct fid));
+	fid.ino = handle.ha_fid.fid_ino;
+	fid.gen = handle.ha_fid.fid_gen;
+
+	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
+			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
+			xfs_handle_acceptable, NULL);
+}
+
+STATIC struct dentry *
+xfs_handlereq_to_dentry(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
+}
+
+int
+xfs_open_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	const struct cred	*cred = current_cred();
+	int			error;
+	int			fd;
+	int			permflag;
+	struct file		*filp;
+	struct inode		*inode;
+	struct dentry		*dentry;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	inode = dentry->d_inode;
+
+	/* Restrict xfs_open_by_handle to directories & regular files. */
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
+		error = -XFS_ERROR(EPERM);
+		goto out_dput;
+	}
+
+#if BITS_PER_LONG != 32
+	hreq->oflags |= O_LARGEFILE;
+#endif
+
+	/* Put open permission in namei format. */
+	permflag = hreq->oflags;
+	if ((permflag+1) & O_ACCMODE)
+		permflag++;
+	if (permflag & O_TRUNC)
+		permflag |= 2;
+
+	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
+	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
+		error = -XFS_ERROR(EPERM);
+		goto out_dput;
+	}
+
+	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+		error = -XFS_ERROR(EACCES);
+		goto out_dput;
+	}
+
+	/* Can't write directories. */
+	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
+		error = -XFS_ERROR(EISDIR);
+		goto out_dput;
+	}
+
+	fd = get_unused_fd();
+	if (fd < 0) {
+		error = fd;
+		goto out_dput;
+	}
+
+	filp = dentry_open(dentry, mntget(parfilp->f_path.mnt),
+			   hreq->oflags, cred);
+	if (IS_ERR(filp)) {
+		put_unused_fd(fd);
+		return PTR_ERR(filp);
+	}
+
+	if (inode->i_mode & S_IFREG) {
+		filp->f_flags |= O_NOATIME;
+		filp->f_mode |= FMODE_NOCMTIME;
+	}
+
+	fd_install(fd, filp);
+	return fd;
+
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+/*
+ * This is a copy from fs/namei.c:vfs_readlink(), except for removing it's
+ * unused first argument.
+ */
+STATIC int
+do_readlink(
+	char __user		*buffer,
+	int			buflen,
+	const char		*link)
+{
+        int len;
+
+	len = PTR_ERR(link);
+	if (IS_ERR(link))
+		goto out;
+
+	len = strlen(link);
+	if (len > (unsigned) buflen)
+		len = buflen;
+	if (copy_to_user(buffer, link, len))
+		len = -EFAULT;
+ out:
+	return len;
+}
+
+
+int
+xfs_readlink_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	struct dentry		*dentry;
+	__u32			olen;
+	void			*link;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	/* Restrict this handle operation to symlinks only. */
+	if (!S_ISLNK(dentry->d_inode->i_mode)) {
+		error = -XFS_ERROR(EINVAL);
+		goto out_dput;
+	}
+
+	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
+		error = -XFS_ERROR(EFAULT);
+		goto out_dput;
+	}
+
+	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
+	if (!link) {
+		error = -XFS_ERROR(ENOMEM);
+		goto out_dput;
+	}
+
+	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
+	if (error)
+		goto out_kfree;
+	error = do_readlink(hreq->ohandle, olen, link);
+	if (error)
+		goto out_kfree;
+
+ out_kfree:
+	kfree(link);
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+STATIC int
+xfs_fssetdm_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error;
+	struct fsdmidata	fsd;
+	xfs_fsop_setdm_handlereq_t dmhreq;
+	struct dentry		*dentry;
+
+	if (!capable(CAP_MKNOD))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
+		error = -XFS_ERROR(EPERM);
+		goto out;
+	}
+
+	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
+		error = -XFS_ERROR(EFAULT);
+		goto out;
+	}
+
+	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
+				 fsd.fsd_dmstate);
+
+ out:
+	dput(dentry);
+	return error;
+}
+
+STATIC int
+xfs_attrlist_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error = -ENOMEM;
+	attrlist_cursor_kern_t	*cursor;
+	xfs_fsop_attrlist_handlereq_t al_hreq;
+	struct dentry		*dentry;
+	char			*kbuf;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+	if (al_hreq.buflen > XATTR_LIST_MAX)
+		return -XFS_ERROR(EINVAL);
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -XFS_ERROR(EINVAL);
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
+	if (!kbuf)
+		goto out_dput;
+
+	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
+	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
+					al_hreq.flags, cursor);
+	if (error)
+		goto out_kfree;
+
+	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
+		error = -EFAULT;
+
+ out_kfree:
+	kfree(kbuf);
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+int
+xfs_attrmulti_attr_get(
+	struct inode		*inode,
+	unsigned char		*name,
+	unsigned char		__user *ubuf,
+	__uint32_t		*len,
+	__uint32_t		flags)
+{
+	unsigned char		*kbuf;
+	int			error = EFAULT;
+
+	if (*len > XATTR_SIZE_MAX)
+		return EINVAL;
+	kbuf = kmalloc(*len, GFP_KERNEL);
+	if (!kbuf)
+		return ENOMEM;
+
+	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
+	if (error)
+		goto out_kfree;
+
+	if (copy_to_user(ubuf, kbuf, *len))
+		error = EFAULT;
+
+ out_kfree:
+	kfree(kbuf);
+	return error;
+}
+
+int
+xfs_attrmulti_attr_set(
+	struct inode		*inode,
+	unsigned char		*name,
+	const unsigned char	__user *ubuf,
+	__uint32_t		len,
+	__uint32_t		flags)
+{
+	unsigned char		*kbuf;
+	int			error = EFAULT;
+
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+		return EPERM;
+	if (len > XATTR_SIZE_MAX)
+		return EINVAL;
+
+	kbuf = memdup_user(ubuf, len);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+
+	return error;
+}
+
+int
+xfs_attrmulti_attr_remove(
+	struct inode		*inode,
+	unsigned char		*name,
+	__uint32_t		flags)
+{
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+		return EPERM;
+	return xfs_attr_remove(XFS_I(inode), name, flags);
+}
+
+STATIC int
+xfs_attrmulti_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error;
+	xfs_attr_multiop_t	*ops;
+	xfs_fsop_attrmulti_handlereq_t am_hreq;
+	struct dentry		*dentry;
+	unsigned int		i, size;
+	unsigned char		*attr_name;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
+		return -E2BIG;
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	error = E2BIG;
+	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
+	if (!size || size > 16 * PAGE_SIZE)
+		goto out_dput;
+
+	ops = memdup_user(am_hreq.ops, size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
+		goto out_dput;
+	}
+
+	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
+	if (!attr_name)
+		goto out_kfree_ops;
+
+	error = 0;
+	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_error = strncpy_from_user((char *)attr_name,
+				ops[i].am_attrname, MAXNAMELEN);
+		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
+			error = -ERANGE;
+		if (ops[i].am_error < 0)
+			break;
+
+		switch (ops[i].am_opcode) {
+		case ATTR_OP_GET:
+			ops[i].am_error = xfs_attrmulti_attr_get(
+					dentry->d_inode, attr_name,
+					ops[i].am_attrvalue, &ops[i].am_length,
+					ops[i].am_flags);
+			break;
+		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					dentry->d_inode, attr_name,
+					ops[i].am_attrvalue, ops[i].am_length,
+					ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
+			break;
+		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
+			ops[i].am_error = xfs_attrmulti_attr_remove(
+					dentry->d_inode, attr_name,
+					ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
+			break;
+		default:
+			ops[i].am_error = EINVAL;
+		}
+	}
+
+	if (copy_to_user(am_hreq.ops, ops, size))
+		error = XFS_ERROR(EFAULT);
+
+	kfree(attr_name);
+ out_kfree_ops:
+	kfree(ops);
+ out_dput:
+	dput(dentry);
+	return -error;
+}
+
+int
+xfs_ioc_space(
+	struct xfs_inode	*ip,
+	struct inode		*inode,
+	struct file		*filp,
+	int			ioflags,
+	unsigned int		cmd,
+	xfs_flock64_t		*bf)
+{
+	int			attr_flags = 0;
+	int			error;
+
+	/*
+	 * Only allow the sys admin to reserve space unless
+	 * unwritten extents are enabled.
+	 */
+	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
+	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
+		return -XFS_ERROR(EPERM);
+
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -XFS_ERROR(EBADF);
+
+	if (!S_ISREG(inode->i_mode))
+		return -XFS_ERROR(EINVAL);
+
+	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
+		attr_flags |= XFS_ATTR_NONBLOCK;
+
+	if (filp->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
+	if (ioflags & IO_INVIS)
+		attr_flags |= XFS_ATTR_DMI;
+
+	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
+	return -error;
+}
+
+STATIC int
+xfs_ioc_bulkstat(
+	xfs_mount_t		*mp,
+	unsigned int		cmd,
+	void			__user *arg)
+{
+	xfs_fsop_bulkreq_t	bulkreq;
+	int			count;	/* # of records returned */
+	xfs_ino_t		inlast;	/* last inode number */
+	int			done;
+	int			error;
+
+	/* done = 1 if there are more stats to get and if bulkstat */
+	/* should be called again (unused here, but used in dmapi) */
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
+		return -XFS_ERROR(EFAULT);
+
+	if ((count = bulkreq.icount) <= 0)
+		return -XFS_ERROR(EINVAL);
+
+	if (bulkreq.ubuffer == NULL)
+		return -XFS_ERROR(EINVAL);
+
+	if (cmd == XFS_IOC_FSINUMBERS)
+		error = xfs_inumbers(mp, &inlast, &count,
+					bulkreq.ubuffer, xfs_inumbers_fmt);
+	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
+		error = xfs_bulkstat_single(mp, &inlast,
+						bulkreq.ubuffer, &done);
+	else	/* XFS_IOC_FSBULKSTAT */
+		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
+				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
+				     &done);
+
+	if (error)
+		return -error;
+
+	if (bulkreq.ocount != NULL) {
+		if (copy_to_user(bulkreq.lastip, &inlast,
+						sizeof(xfs_ino_t)))
+			return -XFS_ERROR(EFAULT);
+
+		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+			return -XFS_ERROR(EFAULT);
+	}
+
+	return 0;
+}
+
+STATIC int
+xfs_ioc_fsgeometry_v1(
+	xfs_mount_t		*mp,
+	void			__user *arg)
+{
+	xfs_fsop_geom_t         fsgeo;
+	int			error;
+
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	if (error)
+		return -error;
+
+	/*
+	 * Caller should have passed an argument of type
+	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
+	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
+	 */
+	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_ioc_fsgeometry(
+	xfs_mount_t		*mp,
+	void			__user *arg)
+{
+	xfs_fsop_geom_t		fsgeo;
+	int			error;
+
+	error = xfs_fs_geometry(mp, &fsgeo, 4);
+	if (error)
+		return -error;
+
+	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+/*
+ * Linux extended inode flags interface.
+ */
+
+STATIC unsigned int
+xfs_merge_ioc_xflags(
+	unsigned int	flags,
+	unsigned int	start)
+{
+	unsigned int	xflags = start;
+
+	if (flags & FS_IMMUTABLE_FL)
+		xflags |= XFS_XFLAG_IMMUTABLE;
+	else
+		xflags &= ~XFS_XFLAG_IMMUTABLE;
+	if (flags & FS_APPEND_FL)
+		xflags |= XFS_XFLAG_APPEND;
+	else
+		xflags &= ~XFS_XFLAG_APPEND;
+	if (flags & FS_SYNC_FL)
+		xflags |= XFS_XFLAG_SYNC;
+	else
+		xflags &= ~XFS_XFLAG_SYNC;
+	if (flags & FS_NOATIME_FL)
+		xflags |= XFS_XFLAG_NOATIME;
+	else
+		xflags &= ~XFS_XFLAG_NOATIME;
+	if (flags & FS_NODUMP_FL)
+		xflags |= XFS_XFLAG_NODUMP;
+	else
+		xflags &= ~XFS_XFLAG_NODUMP;
+
+	return xflags;
+}
+
+STATIC unsigned int
+xfs_di2lxflags(
+	__uint16_t	di_flags)
+{
+	unsigned int	flags = 0;
+
+	if (di_flags & XFS_DIFLAG_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+	if (di_flags & XFS_DIFLAG_APPEND)
+		flags |= FS_APPEND_FL;
+	if (di_flags & XFS_DIFLAG_SYNC)
+		flags |= FS_SYNC_FL;
+	if (di_flags & XFS_DIFLAG_NOATIME)
+		flags |= FS_NOATIME_FL;
+	if (di_flags & XFS_DIFLAG_NODUMP)
+		flags |= FS_NODUMP_FL;
+	return flags;
+}
+
+STATIC int
+xfs_ioc_fsgetxattr(
+	xfs_inode_t		*ip,
+	int			attr,
+	void			__user *arg)
+{
+	struct fsxattr		fa;
+
+	memset(&fa, 0, sizeof(struct fsxattr));
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	fa.fsx_xflags = xfs_ip2xflags(ip);
+	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa.fsx_projid = xfs_get_projid(ip);
+
+	if (attr) {
+		if (ip->i_afp) {
+			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
+				fa.fsx_nextents = ip->i_afp->if_bytes /
+							sizeof(xfs_bmbt_rec_t);
+			else
+				fa.fsx_nextents = ip->i_d.di_anextents;
+		} else
+			fa.fsx_nextents = 0;
+	} else {
+		if (ip->i_df.if_flags & XFS_IFEXTENTS)
+			fa.fsx_nextents = ip->i_df.if_bytes /
+						sizeof(xfs_bmbt_rec_t);
+		else
+			fa.fsx_nextents = ip->i_d.di_nextents;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (copy_to_user(arg, &fa, sizeof(fa)))
+		return -EFAULT;
+	return 0;
+}
+
+STATIC void
+xfs_set_diflags(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	unsigned int		di_flags;
+
+	/* can't set PREALLOC this way, just preserve it */
+	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+	if (xflags & XFS_XFLAG_IMMUTABLE)
+		di_flags |= XFS_DIFLAG_IMMUTABLE;
+	if (xflags & XFS_XFLAG_APPEND)
+		di_flags |= XFS_DIFLAG_APPEND;
+	if (xflags & XFS_XFLAG_SYNC)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if (xflags & XFS_XFLAG_NOATIME)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if (xflags & XFS_XFLAG_NODUMP)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if (xflags & XFS_XFLAG_PROJINHERIT)
+		di_flags |= XFS_DIFLAG_PROJINHERIT;
+	if (xflags & XFS_XFLAG_NODEFRAG)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (xflags & XFS_XFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
+		if (xflags & XFS_XFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (xflags & XFS_XFLAG_NOSYMLINKS)
+			di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		if (xflags & XFS_XFLAG_EXTSZINHERIT)
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+	} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
+		if (xflags & XFS_XFLAG_REALTIME)
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (xflags & XFS_XFLAG_EXTSIZE)
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+	}
+
+	ip->i_d.di_flags = di_flags;
+}
+
+STATIC void
+xfs_diflags_to_linux(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+	unsigned int		xflags = xfs_ip2xflags(ip);
+
+	if (xflags & XFS_XFLAG_IMMUTABLE)
+		inode->i_flags |= S_IMMUTABLE;
+	else
+		inode->i_flags &= ~S_IMMUTABLE;
+	if (xflags & XFS_XFLAG_APPEND)
+		inode->i_flags |= S_APPEND;
+	else
+		inode->i_flags &= ~S_APPEND;
+	if (xflags & XFS_XFLAG_SYNC)
+		inode->i_flags |= S_SYNC;
+	else
+		inode->i_flags &= ~S_SYNC;
+	if (xflags & XFS_XFLAG_NOATIME)
+		inode->i_flags |= S_NOATIME;
+	else
+		inode->i_flags &= ~S_NOATIME;
+}
+
+#define FSX_PROJID	1
+#define FSX_EXTSIZE	2
+#define FSX_XFLAGS	4
+#define FSX_NONBLOCK	8
+
+STATIC int
+xfs_ioctl_setattr(
+	xfs_inode_t		*ip,
+	struct fsxattr		*fa,
+	int			mask)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	unsigned int		lock_flags = 0;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*olddquot = NULL;
+	int			code;
+
+	trace_xfs_ioctl_setattr(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	/*
+	 * Disallow 32bit project ids when projid32bit feature is not enabled.
+	 */
+	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
+			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+		return XFS_ERROR(EINVAL);
+
+	/*
+	 * If disk quotas is on, we make sure that the dquots do exist on disk,
+	 * before we start any other transactions. Trying to do this later
+	 * is messy. We don't care to take a readlock to look at the ids
+	 * in inode here, because we can't hold it across the trans_reserve.
+	 * If the IDs do change before we take the ilock, we're covered
+	 * because the i_*dquot fields will get updated anyway.
+	 */
+	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
+		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
+					 ip->i_d.di_gid, fa->fsx_projid,
+					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
+		if (code)
+			return code;
+	}
+
+	/*
+	 * For the other attributes, we acquire the inode lock and
+	 * first do an error checking pass.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (code)
+		goto error_return;
+
+	lock_flags = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lock_flags);
+
+	/*
+	 * CAP_FOWNER overrides the following restrictions:
+	 *
+	 * The user ID of the calling process must be equal
+	 * to the file owner ID, except in cases where the
+	 * CAP_FSETID capability is applicable.
+	 */
+	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+		code = XFS_ERROR(EPERM);
+		goto error_return;
+	}
+
+	/*
+	 * Do a quota reservation only if projid is actually going to change.
+	 */
+	if (mask & FSX_PROJID) {
+		if (XFS_IS_QUOTA_RUNNING(mp) &&
+		    XFS_IS_PQUOTA_ON(mp) &&
+		    xfs_get_projid(ip) != fa->fsx_projid) {
+			ASSERT(tp);
+			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+						capable(CAP_FOWNER) ?
+						XFS_QMOPT_FORCE_RES : 0);
+			if (code)	/* out of quota */
+				goto error_return;
+		}
+	}
+
+	if (mask & FSX_EXTSIZE) {
+		/*
+		 * Can't change extent size if any extents are allocated.
+		 */
+		if (ip->i_d.di_nextents &&
+		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
+		     fa->fsx_extsize)) {
+			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			goto error_return;
+		}
+
+		/*
+		 * Extent size must be a multiple of the appropriate block
+		 * size, if set at all. It must also be smaller than the
+		 * maximum extent size supported by the filesystem.
+		 *
+		 * Also, for non-realtime files, limit the extent size hint to
+		 * half the size of the AGs in the filesystem so alignment
+		 * doesn't result in extents larger than an AG.
+		 */
+		if (fa->fsx_extsize != 0) {
+			xfs_extlen_t    size;
+			xfs_fsblock_t   extsize_fsb;
+
+			extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
+			if (extsize_fsb > MAXEXTLEN) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+
+			if (XFS_IS_REALTIME_INODE(ip) ||
+			    ((mask & FSX_XFLAGS) &&
+			    (fa->fsx_xflags & XFS_XFLAG_REALTIME))) {
+				size = mp->m_sb.sb_rextsize <<
+				       mp->m_sb.sb_blocklog;
+			} else {
+				size = mp->m_sb.sb_blocksize;
+				if (extsize_fsb > mp->m_sb.sb_agblocks / 2) {
+					code = XFS_ERROR(EINVAL);
+					goto error_return;
+				}
+			}
+
+			if (fa->fsx_extsize % size) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+		}
+	}
+
+
+	if (mask & FSX_XFLAGS) {
+		/*
+		 * Can't change realtime flag if any extents are allocated.
+		 */
+		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
+		    (XFS_IS_REALTIME_INODE(ip)) !=
+		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			goto error_return;
+		}
+
+		/*
+		 * If realtime flag is set then must have realtime data.
+		 */
+		if ((fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+			if ((mp->m_sb.sb_rblocks == 0) ||
+			    (mp->m_sb.sb_rextsize == 0) ||
+			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+		}
+
+		/*
+		 * Can't modify an immutable/append-only file unless
+		 * we have appropriate permission.
+		 */
+		if ((ip->i_d.di_flags &
+				(XFS_DIFLAG_IMMUTABLE|XFS_DIFLAG_APPEND) ||
+		     (fa->fsx_xflags &
+				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
+		    !capable(CAP_LINUX_IMMUTABLE)) {
+			code = XFS_ERROR(EPERM);
+			goto error_return;
+		}
+	}
+
+	xfs_trans_ijoin(tp, ip);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 */
+	if (mask & FSX_PROJID) {
+		/*
+		 * CAP_FSETID overrides the following restrictions:
+		 *
+		 * The set-user-ID and set-group-ID bits of a file will be
+		 * cleared upon successful return from chown()
+		 */
+		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
+		    !capable(CAP_FSETID))
+			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
+
+		/*
+		 * Change the ownerships and register quota modifications
+		 * in the transaction.
+		 */
+		if (xfs_get_projid(ip) != fa->fsx_projid) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
+				olddquot = xfs_qm_vop_chown(tp, ip,
+							&ip->i_gdquot, gdqp);
+			}
+			xfs_set_projid(ip, fa->fsx_projid);
+
+			/*
+			 * We may have to rev the inode as well as
+			 * the superblock version number since projids didn't
+			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
+			 */
+			if (ip->i_d.di_version == 1)
+				xfs_bump_ino_vers2(tp, ip);
+		}
+
+	}
+
+	if (mask & FSX_EXTSIZE)
+		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+	if (mask & FSX_XFLAGS) {
+		xfs_set_diflags(ip, fa->fsx_xflags);
+		xfs_diflags_to_linux(ip);
+	}
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 * This is slightly sub-optimal in that truncates require
+	 * two sync transactions instead of one for wsync filesystems.
+	 * One for the truncate and one for the timestamps since we
+	 * don't want to change the timestamps unless we're sure the
+	 * truncate worked.  Truncates are less than 1% of the laddis
+	 * mix so this probably isn't worth the trouble to optimize.
+	 */
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+	code = xfs_trans_commit(tp, 0);
+	xfs_iunlock(ip, lock_flags);
+
+	/*
+	 * Release any dquot(s) the inode had kept before chown.
+	 */
+	xfs_qm_dqrele(olddquot);
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+
+	return code;
+
+ error_return:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_trans_cancel(tp, 0);
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
+	return code;
+}
+
+STATIC int
+xfs_ioc_fssetxattr(
+	xfs_inode_t		*ip,
+	struct file		*filp,
+	void			__user *arg)
+{
+	struct fsxattr		fa;
+	unsigned int		mask;
+
+	if (copy_from_user(&fa, arg, sizeof(fa)))
+		return -EFAULT;
+
+	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
+	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
+		mask |= FSX_NONBLOCK;
+
+	return -xfs_ioctl_setattr(ip, &fa, mask);
+}
+
+STATIC int
+xfs_ioc_getxflags(
+	xfs_inode_t		*ip,
+	void			__user *arg)
+{
+	unsigned int		flags;
+
+	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		return -EFAULT;
+	return 0;
+}
+
+STATIC int
+xfs_ioc_setxflags(
+	xfs_inode_t		*ip,
+	struct file		*filp,
+	void			__user *arg)
+{
+	struct fsxattr		fa;
+	unsigned int		flags;
+	unsigned int		mask;
+
+	if (copy_from_user(&flags, arg, sizeof(flags)))
+		return -EFAULT;
+
+	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
+		      FS_NOATIME_FL | FS_NODUMP_FL | \
+		      FS_SYNC_FL))
+		return -EOPNOTSUPP;
+
+	mask = FSX_XFLAGS;
+	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
+		mask |= FSX_NONBLOCK;
+	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
+
+	return -xfs_ioctl_setattr(ip, &fa, mask);
+}
+
+STATIC int
+xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
+{
+	struct getbmap __user	*base = *ap;
+
+	/* copy only getbmap portion (not getbmapx) */
+	if (copy_to_user(base, bmv, sizeof(struct getbmap)))
+		return XFS_ERROR(EFAULT);
+
+	*ap += sizeof(struct getbmap);
+	return 0;
+}
+
+STATIC int
+xfs_ioc_getbmap(
+	struct xfs_inode	*ip,
+	int			ioflags,
+	unsigned int		cmd,
+	void			__user *arg)
+{
+	struct getbmapx		bmx;
+	int			error;
+
+	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
+		return -XFS_ERROR(EFAULT);
+
+	if (bmx.bmv_count < 2)
+		return -XFS_ERROR(EINVAL);
+
+	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
+	if (ioflags & IO_INVIS)
+		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
+
+	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
+			    (struct getbmap *)arg+1);
+	if (error)
+		return -error;
+
+	/* copy back header - only size of getbmap */
+	if (copy_to_user(arg, &bmx, sizeof(struct getbmap)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
+{
+	struct getbmapx __user	*base = *ap;
+
+	if (copy_to_user(base, bmv, sizeof(struct getbmapx)))
+		return XFS_ERROR(EFAULT);
+
+	*ap += sizeof(struct getbmapx);
+	return 0;
+}
+
+STATIC int
+xfs_ioc_getbmapx(
+	struct xfs_inode	*ip,
+	void			__user *arg)
+{
+	struct getbmapx		bmx;
+	int			error;
+
+	if (copy_from_user(&bmx, arg, sizeof(bmx)))
+		return -XFS_ERROR(EFAULT);
+
+	if (bmx.bmv_count < 2)
+		return -XFS_ERROR(EINVAL);
+
+	if (bmx.bmv_iflags & (~BMV_IF_VALID))
+		return -XFS_ERROR(EINVAL);
+
+	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
+			    (struct getbmapx *)arg+1);
+	if (error)
+		return -error;
+
+	/* copy back header */
+	if (copy_to_user(arg, &bmx, sizeof(struct getbmapx)))
+		return -XFS_ERROR(EFAULT);
+
+	return 0;
+}
+
+/*
+ * Note: some of the ioctl's return positive numbers as a
+ * byte count indicating success, such as readlink_by_handle.
+ * So we don't "sign flip" like most other routines.  This means
+ * true errors need to be returned as a negative value.
+ */
+long
+xfs_file_ioctl(
+	struct file		*filp,
+	unsigned int		cmd,
+	unsigned long		p)
+{
+	struct inode		*inode = filp->f_path.dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	void			__user *arg = (void __user *)p;
+	int			ioflags = 0;
+	int			error;
+
+	if (filp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	trace_xfs_file_ioctl(ip);
+
+	switch (cmd) {
+	case FITRIM:
+		return xfs_ioc_trim(mp, arg);
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP64:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_ZERO_RANGE: {
+		xfs_flock64_t		bf;
+
+		if (copy_from_user(&bf, arg, sizeof(bf)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+	}
+	case XFS_IOC_DIOINFO: {
+		struct dioattr	da;
+		xfs_buftarg_t	*target =
+			XFS_IS_REALTIME_INODE(ip) ?
+			mp->m_rtdev_targp : mp->m_ddev_targp;
+
+		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
+		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
+
+		if (copy_to_user(arg, &da, sizeof(da)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_FSBULKSTAT_SINGLE:
+	case XFS_IOC_FSBULKSTAT:
+	case XFS_IOC_FSINUMBERS:
+		return xfs_ioc_bulkstat(mp, cmd, arg);
+
+	case XFS_IOC_FSGEOMETRY_V1:
+		return xfs_ioc_fsgeometry_v1(mp, arg);
+
+	case XFS_IOC_FSGEOMETRY:
+		return xfs_ioc_fsgeometry(mp, arg);
+
+	case XFS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *)arg);
+
+	case XFS_IOC_FSGETXATTR:
+		return xfs_ioc_fsgetxattr(ip, 0, arg);
+	case XFS_IOC_FSGETXATTRA:
+		return xfs_ioc_fsgetxattr(ip, 1, arg);
+	case XFS_IOC_FSSETXATTR:
+		return xfs_ioc_fssetxattr(ip, filp, arg);
+	case XFS_IOC_GETXFLAGS:
+		return xfs_ioc_getxflags(ip, arg);
+	case XFS_IOC_SETXFLAGS:
+		return xfs_ioc_setxflags(ip, filp, arg);
+
+	case XFS_IOC_FSSETDM: {
+		struct fsdmidata	dmi;
+
+		if (copy_from_user(&dmi, arg, sizeof(dmi)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
+				dmi.fsd_dmstate);
+		return -error;
+	}
+
+	case XFS_IOC_GETBMAP:
+	case XFS_IOC_GETBMAPA:
+		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
+
+	case XFS_IOC_GETBMAPX:
+		return xfs_ioc_getbmapx(ip, arg);
+
+	case XFS_IOC_FD_TO_HANDLE:
+	case XFS_IOC_PATH_TO_HANDLE:
+	case XFS_IOC_PATH_TO_FSHANDLE: {
+		xfs_fsop_handlereq_t	hreq;
+
+		if (copy_from_user(&hreq, arg, sizeof(hreq)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_find_handle(cmd, &hreq);
+	}
+	case XFS_IOC_OPEN_BY_HANDLE: {
+		xfs_fsop_handlereq_t	hreq;
+
+		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_open_by_handle(filp, &hreq);
+	}
+	case XFS_IOC_FSSETDM_BY_HANDLE:
+		return xfs_fssetdm_by_handle(filp, arg);
+
+	case XFS_IOC_READLINK_BY_HANDLE: {
+		xfs_fsop_handlereq_t	hreq;
+
+		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
+			return -XFS_ERROR(EFAULT);
+		return xfs_readlink_by_handle(filp, &hreq);
+	}
+	case XFS_IOC_ATTRLIST_BY_HANDLE:
+		return xfs_attrlist_by_handle(filp, arg);
+
+	case XFS_IOC_ATTRMULTI_BY_HANDLE:
+		return xfs_attrmulti_by_handle(filp, arg);
+
+	case XFS_IOC_SWAPEXT: {
+		struct xfs_swapext	sxp;
+
+		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_swapext(&sxp);
+		return -error;
+	}
+
+	case XFS_IOC_FSCOUNTS: {
+		xfs_fsop_counts_t out;
+
+		error = xfs_fs_counts(mp, &out);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &out, sizeof(out)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_SET_RESBLKS: {
+		xfs_fsop_resblks_t inout;
+		__uint64_t	   in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			return -XFS_ERROR(EROFS);
+
+		if (copy_from_user(&inout, arg, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		/* input parameter is passed in resblks field of structure */
+		in = inout.resblks;
+		error = xfs_reserve_blocks(mp, &in, &inout);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &inout, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_GET_RESBLKS: {
+		xfs_fsop_resblks_t out;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		error = xfs_reserve_blocks(mp, NULL, &out);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &out, sizeof(out)))
+			return -XFS_ERROR(EFAULT);
+
+		return 0;
+	}
+
+	case XFS_IOC_FSGROWFSDATA: {
+		xfs_growfs_data_t in;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_data(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_FSGROWFSLOG: {
+		xfs_growfs_log_t in;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_log(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_FSGROWFSRT: {
+		xfs_growfs_rt_t in;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_growfs_rt(mp, &in);
+		return -error;
+	}
+
+	case XFS_IOC_GOINGDOWN: {
+		__uint32_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (get_user(in, (__uint32_t __user *)arg))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_fs_goingdown(mp, in);
+		return -error;
+	}
+
+	case XFS_IOC_ERROR_INJECTION: {
+		xfs_error_injection_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_errortag_add(in.errtag, mp);
+		return -error;
+	}
+
+	case XFS_IOC_ERROR_CLEARALL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		error = xfs_errortag_clearall(mp, 1);
+		return -error;
+
+	default:
+		return -ENOTTY;
+	}
+}
diff --git a/fs/xfs/linux/xfs_ioctl.h b/fs/xfs/linux/xfs_ioctl.h
new file mode 100644
index 0000000..d56173b
--- /dev/null
+++ b/fs/xfs/linux/xfs_ioctl.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_IOCTL_H__
+#define __XFS_IOCTL_H__
+
+extern int
+xfs_ioc_space(
+	struct xfs_inode	*ip,
+	struct inode		*inode,
+	struct file		*filp,
+	int			ioflags,
+	unsigned int		cmd,
+	xfs_flock64_t		*bf);
+
+extern int
+xfs_find_handle(
+	unsigned int		cmd,
+	xfs_fsop_handlereq_t	*hreq);
+
+extern int
+xfs_open_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq);
+
+extern int
+xfs_readlink_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq);
+
+extern int
+xfs_attrmulti_attr_get(
+	struct inode		*inode,
+	unsigned char		*name,
+	unsigned char		__user *ubuf,
+	__uint32_t		*len,
+	__uint32_t		flags);
+
+extern int
+xfs_attrmulti_attr_set(
+	struct inode		*inode,
+	unsigned char		*name,
+	const unsigned char	__user *ubuf,
+	__uint32_t		len,
+	__uint32_t		flags);
+
+extern int
+xfs_attrmulti_attr_remove(
+	struct inode		*inode,
+	unsigned char		*name,
+	__uint32_t		flags);
+
+extern struct dentry *
+xfs_handle_to_dentry(
+	struct file		*parfilp,
+	void __user		*uhandle,
+	u32			hlen);
+
+extern long
+xfs_file_ioctl(
+	struct file		*filp,
+	unsigned int		cmd,
+	unsigned long		p);
+
+extern long
+xfs_file_compat_ioctl(
+	struct file		*file,
+	unsigned int		cmd,
+	unsigned long		arg);
+
+#endif
diff --git a/fs/xfs/linux/xfs_ioctl32.c b/fs/xfs/linux/xfs_ioctl32.c
new file mode 100644
index 0000000..54e623b
--- /dev/null
+++ b/fs/xfs/linux/xfs_ioctl32.c
@@ -0,0 +1,672 @@
+/*
+ * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/compat.h>
+#include <linux/ioctl.h>
+#include <linux/mount.h>
+#include <linux/slab.h>
+#include <asm/uaccess.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_vnode.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_itable.h"
+#include "xfs_error.h"
+#include "xfs_dfrag.h"
+#include "xfs_vnodeops.h"
+#include "xfs_fsops.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_ioctl32.h"
+#include "xfs_trace.h"
+
+#define  _NATIVE_IOC(cmd, type) \
+	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
+
+#ifdef BROKEN_X86_ALIGNMENT
+STATIC int
+xfs_compat_flock64_copyin(
+	xfs_flock64_t		*bf,
+	compat_xfs_flock64_t	__user *arg32)
+{
+	if (get_user(bf->l_type,	&arg32->l_type) ||
+	    get_user(bf->l_whence,	&arg32->l_whence) ||
+	    get_user(bf->l_start,	&arg32->l_start) ||
+	    get_user(bf->l_len,		&arg32->l_len) ||
+	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
+	    get_user(bf->l_pid,		&arg32->l_pid) ||
+	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_compat_ioc_fsgeometry_v1(
+	struct xfs_mount	  *mp,
+	compat_xfs_fsop_geom_v1_t __user *arg32)
+{
+	xfs_fsop_geom_t		  fsgeo;
+	int			  error;
+
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	if (error)
+		return -error;
+	/* The 32-bit variant simply has some padding at the end */
+	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_compat_growfs_data_copyin(
+	struct xfs_growfs_data	 *in,
+	compat_xfs_growfs_data_t __user *arg32)
+{
+	if (get_user(in->newblocks, &arg32->newblocks) ||
+	    get_user(in->imaxpct,   &arg32->imaxpct))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_compat_growfs_rt_copyin(
+	struct xfs_growfs_rt	 *in,
+	compat_xfs_growfs_rt_t	__user *arg32)
+{
+	if (get_user(in->newblocks, &arg32->newblocks) ||
+	    get_user(in->extsize,   &arg32->extsize))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_inumbers_fmt_compat(
+	void			__user *ubuffer,
+	const xfs_inogrp_t	*buffer,
+	long			count,
+	long			*written)
+{
+	compat_xfs_inogrp_t	__user *p32 = ubuffer;
+	long			i;
+
+	for (i = 0; i < count; i++) {
+		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
+		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
+		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
+			return -XFS_ERROR(EFAULT);
+	}
+	*written = count * sizeof(*p32);
+	return 0;
+}
+
+#else
+#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
+#endif	/* BROKEN_X86_ALIGNMENT */
+
+STATIC int
+xfs_ioctl32_bstime_copyin(
+	xfs_bstime_t		*bstime,
+	compat_xfs_bstime_t	__user *bstime32)
+{
+	compat_time_t		sec32;	/* tv_sec differs on 64 vs. 32 */
+
+	if (get_user(sec32,		&bstime32->tv_sec)	||
+	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
+		return -XFS_ERROR(EFAULT);
+	bstime->tv_sec = sec32;
+	return 0;
+}
+
+/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
+STATIC int
+xfs_ioctl32_bstat_copyin(
+	xfs_bstat_t		*bstat,
+	compat_xfs_bstat_t	__user *bstat32)
+{
+	if (get_user(bstat->bs_ino,	&bstat32->bs_ino)	||
+	    get_user(bstat->bs_mode,	&bstat32->bs_mode)	||
+	    get_user(bstat->bs_nlink,	&bstat32->bs_nlink)	||
+	    get_user(bstat->bs_uid,	&bstat32->bs_uid)	||
+	    get_user(bstat->bs_gid,	&bstat32->bs_gid)	||
+	    get_user(bstat->bs_rdev,	&bstat32->bs_rdev)	||
+	    get_user(bstat->bs_blksize,	&bstat32->bs_blksize)	||
+	    get_user(bstat->bs_size,	&bstat32->bs_size)	||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
+	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
+	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
+	    get_user(bstat->bs_projid_lo, &bstat32->bs_projid_lo) ||
+	    get_user(bstat->bs_projid_hi, &bstat32->bs_projid_hi) ||
+	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
+	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
+	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+/* XFS_IOC_FSBULKSTAT and friends */
+
+STATIC int
+xfs_bstime_store_compat(
+	compat_xfs_bstime_t	__user *p32,
+	const xfs_bstime_t	*p)
+{
+	__s32			sec32;
+
+	sec32 = p->tv_sec;
+	if (put_user(sec32, &p32->tv_sec) ||
+	    put_user(p->tv_nsec, &p32->tv_nsec))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+/* Return 0 on success or positive error (to xfs_bulkstat()) */
+STATIC int
+xfs_bulkstat_one_fmt_compat(
+	void			__user *ubuffer,
+	int			ubsize,
+	int			*ubused,
+	const xfs_bstat_t	*buffer)
+{
+	compat_xfs_bstat_t	__user *p32 = ubuffer;
+
+	if (ubsize < sizeof(*p32))
+		return XFS_ERROR(ENOMEM);
+
+	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
+	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
+	    put_user(buffer->bs_nlink,	  &p32->bs_nlink)	||
+	    put_user(buffer->bs_uid,	  &p32->bs_uid)		||
+	    put_user(buffer->bs_gid,	  &p32->bs_gid)		||
+	    put_user(buffer->bs_rdev,	  &p32->bs_rdev)	||
+	    put_user(buffer->bs_blksize,  &p32->bs_blksize)	||
+	    put_user(buffer->bs_size,	  &p32->bs_size)	||
+	    xfs_bstime_store_compat(&p32->bs_atime, &buffer->bs_atime) ||
+	    xfs_bstime_store_compat(&p32->bs_mtime, &buffer->bs_mtime) ||
+	    xfs_bstime_store_compat(&p32->bs_ctime, &buffer->bs_ctime) ||
+	    put_user(buffer->bs_blocks,	  &p32->bs_blocks)	||
+	    put_user(buffer->bs_xflags,	  &p32->bs_xflags)	||
+	    put_user(buffer->bs_extsize,  &p32->bs_extsize)	||
+	    put_user(buffer->bs_extents,  &p32->bs_extents)	||
+	    put_user(buffer->bs_gen,	  &p32->bs_gen)		||
+	    put_user(buffer->bs_projid,	  &p32->bs_projid)	||
+	    put_user(buffer->bs_projid_hi,	&p32->bs_projid_hi)	||
+	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask)	||
+	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
+	    put_user(buffer->bs_aextents, &p32->bs_aextents))
+		return XFS_ERROR(EFAULT);
+	if (ubused)
+		*ubused = sizeof(*p32);
+	return 0;
+}
+
+STATIC int
+xfs_bulkstat_one_compat(
+	xfs_mount_t	*mp,		/* mount point for filesystem */
+	xfs_ino_t	ino,		/* inode number to get data for */
+	void		__user *buffer,	/* buffer to place output in */
+	int		ubsize,		/* size of buffer */
+	int		*ubused,	/* bytes used by me */
+	int		*stat)		/* BULKSTAT_RV_... */
+{
+	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
+				    xfs_bulkstat_one_fmt_compat,
+				    ubused, stat);
+}
+
+/* copied from xfs_ioctl.c */
+STATIC int
+xfs_compat_ioc_bulkstat(
+	xfs_mount_t		  *mp,
+	unsigned int		  cmd,
+	compat_xfs_fsop_bulkreq_t __user *p32)
+{
+	u32			addr;
+	xfs_fsop_bulkreq_t	bulkreq;
+	int			count;	/* # of records returned */
+	xfs_ino_t		inlast;	/* last inode number */
+	int			done;
+	int			error;
+
+	/* done = 1 if there are more stats to get and if bulkstat */
+	/* should be called again (unused here, but used in dmapi) */
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
+	if (get_user(addr, &p32->lastip))
+		return -XFS_ERROR(EFAULT);
+	bulkreq.lastip = compat_ptr(addr);
+	if (get_user(bulkreq.icount, &p32->icount) ||
+	    get_user(addr, &p32->ubuffer))
+		return -XFS_ERROR(EFAULT);
+	bulkreq.ubuffer = compat_ptr(addr);
+	if (get_user(addr, &p32->ocount))
+		return -XFS_ERROR(EFAULT);
+	bulkreq.ocount = compat_ptr(addr);
+
+	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
+		return -XFS_ERROR(EFAULT);
+
+	if ((count = bulkreq.icount) <= 0)
+		return -XFS_ERROR(EINVAL);
+
+	if (bulkreq.ubuffer == NULL)
+		return -XFS_ERROR(EINVAL);
+
+	if (cmd == XFS_IOC_FSINUMBERS_32) {
+		error = xfs_inumbers(mp, &inlast, &count,
+				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
+	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
+		int res;
+
+		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
+				sizeof(compat_xfs_bstat_t), 0, &res);
+	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
+		error = xfs_bulkstat(mp, &inlast, &count,
+			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
+			bulkreq.ubuffer, &done);
+	} else
+		error = XFS_ERROR(EINVAL);
+	if (error)
+		return -error;
+
+	if (bulkreq.ocount != NULL) {
+		if (copy_to_user(bulkreq.lastip, &inlast,
+						sizeof(xfs_ino_t)))
+			return -XFS_ERROR(EFAULT);
+
+		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+			return -XFS_ERROR(EFAULT);
+	}
+
+	return 0;
+}
+
+STATIC int
+xfs_compat_handlereq_copyin(
+	xfs_fsop_handlereq_t		*hreq,
+	compat_xfs_fsop_handlereq_t	__user *arg32)
+{
+	compat_xfs_fsop_handlereq_t	hreq32;
+
+	if (copy_from_user(&hreq32, arg32, sizeof(compat_xfs_fsop_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	hreq->fd = hreq32.fd;
+	hreq->path = compat_ptr(hreq32.path);
+	hreq->oflags = hreq32.oflags;
+	hreq->ihandle = compat_ptr(hreq32.ihandle);
+	hreq->ihandlen = hreq32.ihandlen;
+	hreq->ohandle = compat_ptr(hreq32.ohandle);
+	hreq->ohandlen = compat_ptr(hreq32.ohandlen);
+
+	return 0;
+}
+
+STATIC struct dentry *
+xfs_compat_handlereq_to_dentry(
+	struct file		*parfilp,
+	compat_xfs_fsop_handlereq_t *hreq)
+{
+	return xfs_handle_to_dentry(parfilp,
+			compat_ptr(hreq->ihandle), hreq->ihandlen);
+}
+
+STATIC int
+xfs_compat_attrlist_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error;
+	attrlist_cursor_kern_t	*cursor;
+	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
+	struct dentry		*dentry;
+	char			*kbuf;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&al_hreq, arg,
+			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+	if (al_hreq.buflen > XATTR_LIST_MAX)
+		return -XFS_ERROR(EINVAL);
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -XFS_ERROR(EINVAL);
+
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	error = -ENOMEM;
+	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
+	if (!kbuf)
+		goto out_dput;
+
+	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
+	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
+					al_hreq.flags, cursor);
+	if (error)
+		goto out_kfree;
+
+	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
+		error = -EFAULT;
+
+ out_kfree:
+	kfree(kbuf);
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+STATIC int
+xfs_compat_attrmulti_by_handle(
+	struct file				*parfilp,
+	void					__user *arg)
+{
+	int					error;
+	compat_xfs_attr_multiop_t		*ops;
+	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
+	struct dentry				*dentry;
+	unsigned int				i, size;
+	unsigned char				*attr_name;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&am_hreq, arg,
+			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
+		return -E2BIG;
+
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	error = E2BIG;
+	size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
+	if (!size || size > 16 * PAGE_SIZE)
+		goto out_dput;
+
+	ops = memdup_user(compat_ptr(am_hreq.ops), size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
+		goto out_dput;
+	}
+
+	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
+	if (!attr_name)
+		goto out_kfree_ops;
+
+	error = 0;
+	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_error = strncpy_from_user((char *)attr_name,
+				compat_ptr(ops[i].am_attrname),
+				MAXNAMELEN);
+		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
+			error = -ERANGE;
+		if (ops[i].am_error < 0)
+			break;
+
+		switch (ops[i].am_opcode) {
+		case ATTR_OP_GET:
+			ops[i].am_error = xfs_attrmulti_attr_get(
+					dentry->d_inode, attr_name,
+					compat_ptr(ops[i].am_attrvalue),
+					&ops[i].am_length, ops[i].am_flags);
+			break;
+		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					dentry->d_inode, attr_name,
+					compat_ptr(ops[i].am_attrvalue),
+					ops[i].am_length, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
+			break;
+		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
+			ops[i].am_error = xfs_attrmulti_attr_remove(
+					dentry->d_inode, attr_name,
+					ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
+			break;
+		default:
+			ops[i].am_error = EINVAL;
+		}
+	}
+
+	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
+		error = XFS_ERROR(EFAULT);
+
+	kfree(attr_name);
+ out_kfree_ops:
+	kfree(ops);
+ out_dput:
+	dput(dentry);
+	return -error;
+}
+
+STATIC int
+xfs_compat_fssetdm_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error;
+	struct fsdmidata	fsd;
+	compat_xfs_fsop_setdm_handlereq_t dmhreq;
+	struct dentry		*dentry;
+
+	if (!capable(CAP_MKNOD))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&dmhreq, arg,
+			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
+		error = -XFS_ERROR(EPERM);
+		goto out;
+	}
+
+	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
+		error = -XFS_ERROR(EFAULT);
+		goto out;
+	}
+
+	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
+				 fsd.fsd_dmstate);
+
+out:
+	dput(dentry);
+	return error;
+}
+
+long
+xfs_file_compat_ioctl(
+	struct file		*filp,
+	unsigned		cmd,
+	unsigned long		p)
+{
+	struct inode		*inode = filp->f_path.dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	void			__user *arg = (void __user *)p;
+	int			ioflags = 0;
+	int			error;
+
+	if (filp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	trace_xfs_file_compat_ioctl(ip);
+
+	switch (cmd) {
+	/* No size or alignment issues on any arch */
+	case XFS_IOC_DIOINFO:
+	case XFS_IOC_FSGEOMETRY:
+	case XFS_IOC_FSGETXATTR:
+	case XFS_IOC_FSSETXATTR:
+	case XFS_IOC_FSGETXATTRA:
+	case XFS_IOC_FSSETDM:
+	case XFS_IOC_GETBMAP:
+	case XFS_IOC_GETBMAPA:
+	case XFS_IOC_GETBMAPX:
+	case XFS_IOC_FSCOUNTS:
+	case XFS_IOC_SET_RESBLKS:
+	case XFS_IOC_GET_RESBLKS:
+	case XFS_IOC_FSGROWFSLOG:
+	case XFS_IOC_GOINGDOWN:
+	case XFS_IOC_ERROR_INJECTION:
+	case XFS_IOC_ERROR_CLEARALL:
+		return xfs_file_ioctl(filp, cmd, p);
+#ifndef BROKEN_X86_ALIGNMENT
+	/* These are handled fine if no alignment issues */
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP64:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
+	case XFS_IOC_FSGROWFSDATA:
+	case XFS_IOC_FSGROWFSRT:
+	case XFS_IOC_ZERO_RANGE:
+		return xfs_file_ioctl(filp, cmd, p);
+#else
+	case XFS_IOC_ALLOCSP_32:
+	case XFS_IOC_FREESP_32:
+	case XFS_IOC_ALLOCSP64_32:
+	case XFS_IOC_FREESP64_32:
+	case XFS_IOC_RESVSP_32:
+	case XFS_IOC_UNRESVSP_32:
+	case XFS_IOC_RESVSP64_32:
+	case XFS_IOC_UNRESVSP64_32:
+	case XFS_IOC_ZERO_RANGE_32: {
+		struct xfs_flock64	bf;
+
+		if (xfs_compat_flock64_copyin(&bf, arg))
+			return -XFS_ERROR(EFAULT);
+		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+	}
+	case XFS_IOC_FSGEOMETRY_V1_32:
+		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
+	case XFS_IOC_FSGROWFSDATA_32: {
+		struct xfs_growfs_data	in;
+
+		if (xfs_compat_growfs_data_copyin(&in, arg))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_growfs_data(mp, &in);
+		return -error;
+	}
+	case XFS_IOC_FSGROWFSRT_32: {
+		struct xfs_growfs_rt	in;
+
+		if (xfs_compat_growfs_rt_copyin(&in, arg))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_growfs_rt(mp, &in);
+		return -error;
+	}
+#endif
+	/* long changes size, but xfs only copiese out 32 bits */
+	case XFS_IOC_GETXFLAGS_32:
+	case XFS_IOC_SETXFLAGS_32:
+	case XFS_IOC_GETVERSION_32:
+		cmd = _NATIVE_IOC(cmd, long);
+		return xfs_file_ioctl(filp, cmd, p);
+	case XFS_IOC_SWAPEXT_32: {
+		struct xfs_swapext	  sxp;
+		struct compat_xfs_swapext __user *sxu = arg;
+
+		/* Bulk copy in up to the sx_stat field, then copy bstat */
+		if (copy_from_user(&sxp, sxu,
+				   offsetof(struct xfs_swapext, sx_stat)) ||
+		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_swapext(&sxp);
+		return -error;
+	}
+	case XFS_IOC_FSBULKSTAT_32:
+	case XFS_IOC_FSBULKSTAT_SINGLE_32:
+	case XFS_IOC_FSINUMBERS_32:
+		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
+	case XFS_IOC_FD_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_FSHANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
+		return xfs_find_handle(cmd, &hreq);
+	}
+	case XFS_IOC_OPEN_BY_HANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
+		return xfs_open_by_handle(filp, &hreq);
+	}
+	case XFS_IOC_READLINK_BY_HANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
+		return xfs_readlink_by_handle(filp, &hreq);
+	}
+	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
+		return xfs_compat_attrlist_by_handle(filp, arg);
+	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
+		return xfs_compat_attrmulti_by_handle(filp, arg);
+	case XFS_IOC_FSSETDM_BY_HANDLE_32:
+		return xfs_compat_fssetdm_by_handle(filp, arg);
+	default:
+		return -XFS_ERROR(ENOIOCTLCMD);
+	}
+}
diff --git a/fs/xfs/linux/xfs_ioctl32.h b/fs/xfs/linux/xfs_ioctl32.h
new file mode 100644
index 0000000..80f4060
--- /dev/null
+++ b/fs/xfs/linux/xfs_ioctl32.h
@@ -0,0 +1,237 @@
+/*
+ * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_IOCTL32_H__
+#define __XFS_IOCTL32_H__
+
+#include <linux/compat.h>
+
+/*
+ * on 32-bit arches, ioctl argument structures may have different sizes
+ * and/or alignment.  We define compat structures which match the
+ * 32-bit sizes/alignments here, and their associated ioctl numbers.
+ *
+ * xfs_ioctl32.c contains routines to copy these structures in and out.
+ */
+
+/* stock kernel-level ioctls we support */
+#define XFS_IOC_GETXFLAGS_32	FS_IOC32_GETFLAGS
+#define XFS_IOC_SETXFLAGS_32	FS_IOC32_SETFLAGS
+#define XFS_IOC_GETVERSION_32	FS_IOC32_GETVERSION
+
+/*
+ * On intel, even if sizes match, alignment and/or padding may differ.
+ */
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#define BROKEN_X86_ALIGNMENT
+#define __compat_packed __attribute__((packed))
+#else
+#define __compat_packed
+#endif
+
+typedef struct compat_xfs_bstime {
+	compat_time_t	tv_sec;		/* seconds		*/
+	__s32		tv_nsec;	/* and nanoseconds	*/
+} compat_xfs_bstime_t;
+
+typedef struct compat_xfs_bstat {
+	__u64		bs_ino;		/* inode number			*/
+	__u16		bs_mode;	/* type and mode		*/
+	__u16		bs_nlink;	/* number of links		*/
+	__u32		bs_uid;		/* user id			*/
+	__u32		bs_gid;		/* group id			*/
+	__u32		bs_rdev;	/* device value			*/
+	__s32		bs_blksize;	/* block size			*/
+	__s64		bs_size;	/* file size			*/
+	compat_xfs_bstime_t bs_atime;	/* access time			*/
+	compat_xfs_bstime_t bs_mtime;	/* modify time			*/
+	compat_xfs_bstime_t bs_ctime;	/* inode change time		*/
+	int64_t		bs_blocks;	/* number of blocks		*/
+	__u32		bs_xflags;	/* extended flags		*/
+	__s32		bs_extsize;	/* extent size			*/
+	__s32		bs_extents;	/* number of extents		*/
+	__u32		bs_gen;		/* generation count		*/
+	__u16		bs_projid_lo;	/* lower part of project id	*/
+#define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
+	__u16		bs_projid_hi;	/* high part of project id	*/
+	unsigned char	bs_pad[12];	/* pad space, unused		*/
+	__u32		bs_dmevmask;	/* DMIG event mask		*/
+	__u16		bs_dmstate;	/* DMIG state info		*/
+	__u16		bs_aextents;	/* attribute number of extents	*/
+} __compat_packed compat_xfs_bstat_t;
+
+typedef struct compat_xfs_fsop_bulkreq {
+	compat_uptr_t	lastip;		/* last inode # pointer		*/
+	__s32		icount;		/* count of entries in buffer	*/
+	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
+	compat_uptr_t	ocount;		/* output count pointer		*/
+} compat_xfs_fsop_bulkreq_t;
+
+#define XFS_IOC_FSBULKSTAT_32 \
+	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSBULKSTAT_SINGLE_32 \
+	_IOWR('X', 102, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSINUMBERS_32 \
+	_IOWR('X', 103, struct compat_xfs_fsop_bulkreq)
+
+typedef struct compat_xfs_fsop_handlereq {
+	__u32		fd;		/* fd for FD_TO_HANDLE		*/
+	compat_uptr_t	path;		/* user pathname		*/
+	__u32		oflags;		/* open flags			*/
+	compat_uptr_t	ihandle;	/* user supplied handle		*/
+	__u32		ihandlen;	/* user supplied length		*/
+	compat_uptr_t	ohandle;	/* user buffer for handle	*/
+	compat_uptr_t	ohandlen;	/* user buffer length		*/
+} compat_xfs_fsop_handlereq_t;
+
+#define XFS_IOC_PATH_TO_FSHANDLE_32 \
+	_IOWR('X', 104, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_PATH_TO_HANDLE_32 \
+	_IOWR('X', 105, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_FD_TO_HANDLE_32 \
+	_IOWR('X', 106, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_OPEN_BY_HANDLE_32 \
+	_IOWR('X', 107, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_READLINK_BY_HANDLE_32 \
+	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
+
+/* The bstat field in the swapext struct needs translation */
+typedef struct compat_xfs_swapext {
+	__int64_t		sx_version;	/* version */
+	__int64_t		sx_fdtarget;	/* fd of target file */
+	__int64_t		sx_fdtmp;	/* fd of tmp file */
+	xfs_off_t		sx_offset;	/* offset into file */
+	xfs_off_t		sx_length;	/* leng from offset */
+	char			sx_pad[16];	/* pad space, unused */
+	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+} __compat_packed compat_xfs_swapext_t;
+
+#define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
+
+typedef struct compat_xfs_fsop_attrlist_handlereq {
+	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
+	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
+	__u32				flags;	/* which namespace to use */
+	__u32				buflen;	/* length of buffer supplied */
+	compat_uptr_t			buffer;	/* returned names */
+} __compat_packed compat_xfs_fsop_attrlist_handlereq_t;
+
+/* Note: actually this is read/write */
+#define XFS_IOC_ATTRLIST_BY_HANDLE_32 \
+	_IOW('X', 122, struct compat_xfs_fsop_attrlist_handlereq)
+
+/* am_opcodes defined in xfs_fs.h */
+typedef struct compat_xfs_attr_multiop {
+	__u32		am_opcode;
+	__s32		am_error;
+	compat_uptr_t	am_attrname;
+	compat_uptr_t	am_attrvalue;
+	__u32		am_length;
+	__u32		am_flags;
+} compat_xfs_attr_multiop_t;
+
+typedef struct compat_xfs_fsop_attrmulti_handlereq {
+	struct compat_xfs_fsop_handlereq hreq; /* handle interface structure */
+	__u32				opcount;/* count of following multiop */
+	/* ptr to compat_xfs_attr_multiop */
+	compat_uptr_t			ops; /* attr_multi data */
+} compat_xfs_fsop_attrmulti_handlereq_t;
+
+#define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
+	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
+
+typedef struct compat_xfs_fsop_setdm_handlereq {
+	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
+	/* ptr to struct fsdmidata */
+	compat_uptr_t			data;	/* DMAPI data   */
+} compat_xfs_fsop_setdm_handlereq_t;
+
+#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
+	_IOW('X', 121, struct compat_xfs_fsop_setdm_handlereq)
+
+#ifdef BROKEN_X86_ALIGNMENT
+/* on ia32 l_start is on a 32-bit boundary */
+typedef struct compat_xfs_flock64 {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start	__attribute__((packed));
+			/* len == 0 means until end of file */
+	__s64		l_len __attribute__((packed));
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area */
+} compat_xfs_flock64_t;
+
+#define XFS_IOC_ALLOCSP_32	_IOW('X', 10, struct compat_xfs_flock64)
+#define XFS_IOC_FREESP_32	_IOW('X', 11, struct compat_xfs_flock64)
+#define XFS_IOC_ALLOCSP64_32	_IOW('X', 36, struct compat_xfs_flock64)
+#define XFS_IOC_FREESP64_32	_IOW('X', 37, struct compat_xfs_flock64)
+#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
+#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
+#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
+#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
+#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
+
+typedef struct compat_xfs_fsop_geom_v1 {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
+
+#define XFS_IOC_FSGEOMETRY_V1_32  \
+	_IOR('X', 100, struct compat_xfs_fsop_geom_v1)
+
+typedef struct compat_xfs_inogrp {
+	__u64		xi_startino;	/* starting inode number	*/
+	__s32		xi_alloccount;	/* # bits set in allocmask	*/
+	__u64		xi_allocmask;	/* mask of allocated inodes	*/
+} __attribute__((packed)) compat_xfs_inogrp_t;
+
+/* These growfs input structures have padding on the end, so must translate */
+typedef struct compat_xfs_growfs_data {
+	__u64		newblocks;	/* new data subvol size, fsblocks */
+	__u32		imaxpct;	/* new inode space percentage limit */
+} __attribute__((packed)) compat_xfs_growfs_data_t;
+
+typedef struct compat_xfs_growfs_rt {
+	__u64		newblocks;	/* new realtime size, fsblocks */
+	__u32		extsize;	/* new realtime extent size, fsblocks */
+} __attribute__((packed)) compat_xfs_growfs_rt_t;
+
+#define XFS_IOC_FSGROWFSDATA_32 _IOW('X', 110, struct compat_xfs_growfs_data)
+#define XFS_IOC_FSGROWFSRT_32   _IOW('X', 112, struct compat_xfs_growfs_rt)
+
+#endif /* BROKEN_X86_ALIGNMENT */
+
+#endif /* __XFS_IOCTL32_H__ */
diff --git a/fs/xfs/linux/xfs_iops.c b/fs/xfs/linux/xfs_iops.c
new file mode 100644
index 0000000..501e4f6
--- /dev/null
+++ b/fs/xfs/linux/xfs_iops.c
@@ -0,0 +1,1201 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_acl.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_alloc.h"
+#include "xfs_quota.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_bmap.h"
+#include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_itable.h"
+#include "xfs_rw.h"
+#include "xfs_attr.h"
+#include "xfs_buf_item.h"
+#include "xfs_utils.h"
+#include "xfs_vnodeops.h"
+#include "xfs_inode_item.h"
+#include "xfs_trace.h"
+
+#include <linux/capability.h>
+#include <linux/xattr.h>
+#include <linux/namei.h>
+#include <linux/posix_acl.h>
+#include <linux/security.h>
+#include <linux/fiemap.h>
+#include <linux/slab.h>
+
+/*
+ * Bring the timestamps in the XFS inode uptodate.
+ *
+ * Used before writing the inode to disk.
+ */
+void
+xfs_synchronize_times(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
+	ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
+	ip->i_d.di_ctime.t_sec = (__int32_t)inode->i_ctime.tv_sec;
+	ip->i_d.di_ctime.t_nsec = (__int32_t)inode->i_ctime.tv_nsec;
+	ip->i_d.di_mtime.t_sec = (__int32_t)inode->i_mtime.tv_sec;
+	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
+}
+
+/*
+ * If the linux inode is valid, mark it dirty.
+ * Used when committing a dirty inode into a transaction so that
+ * the inode will get written back by the linux code
+ */
+void
+xfs_mark_inode_dirty_sync(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
+		mark_inode_dirty_sync(inode);
+}
+
+void
+xfs_mark_inode_dirty(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
+		mark_inode_dirty(inode);
+}
+
+/*
+ * Hook in SELinux.  This is not quite correct yet, what we really need
+ * here (as we do for default ACLs) is a mechanism by which creation of
+ * these attrs can be journalled at inode creation time (along with the
+ * inode, of course, such that log replay can't cause these to be lost).
+ */
+STATIC int
+xfs_init_security(
+	struct inode	*inode,
+	struct inode	*dir,
+	const struct qstr *qstr)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	size_t		length;
+	void		*value;
+	unsigned char	*name;
+	int		error;
+
+	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
+					     &value, &length);
+	if (error) {
+		if (error == -EOPNOTSUPP)
+			return 0;
+		return -error;
+	}
+
+	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
+
+	kfree(name);
+	kfree(value);
+	return error;
+}
+
+static void
+xfs_dentry_to_name(
+	struct xfs_name	*namep,
+	struct dentry	*dentry)
+{
+	namep->name = dentry->d_name.name;
+	namep->len = dentry->d_name.len;
+}
+
+STATIC void
+xfs_cleanup_inode(
+	struct inode	*dir,
+	struct inode	*inode,
+	struct dentry	*dentry)
+{
+	struct xfs_name	teardown;
+
+	/* Oh, the horror.
+	 * If we can't add the ACL or we fail in
+	 * xfs_init_security we must back out.
+	 * ENOSPC can hit here, among other things.
+	 */
+	xfs_dentry_to_name(&teardown, dentry);
+
+	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
+	iput(inode);
+}
+
+STATIC int
+xfs_vn_mknod(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	int		mode,
+	dev_t		rdev)
+{
+	struct inode	*inode;
+	struct xfs_inode *ip = NULL;
+	struct posix_acl *default_acl = NULL;
+	struct xfs_name	name;
+	int		error;
+
+	/*
+	 * Irix uses Missed'em'V split, but doesn't want to see
+	 * the upper 5 bits of (14bit) major.
+	 */
+	if (S_ISCHR(mode) || S_ISBLK(mode)) {
+		if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
+			return -EINVAL;
+		rdev = sysv_encode_dev(rdev);
+	} else {
+		rdev = 0;
+	}
+
+	if (IS_POSIXACL(dir)) {
+		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(default_acl))
+			return PTR_ERR(default_acl);
+
+		if (!default_acl)
+			mode &= ~current_umask();
+	}
+
+	xfs_dentry_to_name(&name, dentry);
+	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
+	if (unlikely(error))
+		goto out_free_acl;
+
+	inode = VFS_I(ip);
+
+	error = xfs_init_security(inode, dir, &dentry->d_name);
+	if (unlikely(error))
+		goto out_cleanup_inode;
+
+	if (default_acl) {
+		error = -xfs_inherit_acl(inode, default_acl);
+		if (unlikely(error))
+			goto out_cleanup_inode;
+		posix_acl_release(default_acl);
+	}
+
+
+	d_instantiate(dentry, inode);
+	return -error;
+
+ out_cleanup_inode:
+	xfs_cleanup_inode(dir, inode, dentry);
+ out_free_acl:
+	posix_acl_release(default_acl);
+	return -error;
+}
+
+STATIC int
+xfs_vn_create(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	int		mode,
+	struct nameidata *nd)
+{
+	return xfs_vn_mknod(dir, dentry, mode, 0);
+}
+
+STATIC int
+xfs_vn_mkdir(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	int		mode)
+{
+	return xfs_vn_mknod(dir, dentry, mode|S_IFDIR, 0);
+}
+
+STATIC struct dentry *
+xfs_vn_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	struct xfs_inode *cip;
+	struct xfs_name	name;
+	int		error;
+
+	if (dentry->d_name.len >= MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	xfs_dentry_to_name(&name, dentry);
+	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
+	if (unlikely(error)) {
+		if (unlikely(error != ENOENT))
+			return ERR_PTR(-error);
+		d_add(dentry, NULL);
+		return NULL;
+	}
+
+	return d_splice_alias(VFS_I(cip), dentry);
+}
+
+STATIC struct dentry *
+xfs_vn_ci_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	struct xfs_inode *ip;
+	struct xfs_name	xname;
+	struct xfs_name ci_name;
+	struct qstr	dname;
+	int		error;
+
+	if (dentry->d_name.len >= MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	xfs_dentry_to_name(&xname, dentry);
+	error = xfs_lookup(XFS_I(dir), &xname, &ip, &ci_name);
+	if (unlikely(error)) {
+		if (unlikely(error != ENOENT))
+			return ERR_PTR(-error);
+		/*
+		 * call d_add(dentry, NULL) here when d_drop_negative_children
+		 * is called in xfs_vn_mknod (ie. allow negative dentries
+		 * with CI filesystems).
+		 */
+		return NULL;
+	}
+
+	/* if exact match, just splice and exit */
+	if (!ci_name.name)
+		return d_splice_alias(VFS_I(ip), dentry);
+
+	/* else case-insensitive match... */
+	dname.name = ci_name.name;
+	dname.len = ci_name.len;
+	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
+	kmem_free(ci_name.name);
+	return dentry;
+}
+
+STATIC int
+xfs_vn_link(
+	struct dentry	*old_dentry,
+	struct inode	*dir,
+	struct dentry	*dentry)
+{
+	struct inode	*inode = old_dentry->d_inode;
+	struct xfs_name	name;
+	int		error;
+
+	xfs_dentry_to_name(&name, dentry);
+
+	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
+	if (unlikely(error))
+		return -error;
+
+	ihold(inode);
+	d_instantiate(dentry, inode);
+	return 0;
+}
+
+STATIC int
+xfs_vn_unlink(
+	struct inode	*dir,
+	struct dentry	*dentry)
+{
+	struct xfs_name	name;
+	int		error;
+
+	xfs_dentry_to_name(&name, dentry);
+
+	error = -xfs_remove(XFS_I(dir), &name, XFS_I(dentry->d_inode));
+	if (error)
+		return error;
+
+	/*
+	 * With unlink, the VFS makes the dentry "negative": no inode,
+	 * but still hashed. This is incompatible with case-insensitive
+	 * mode, so invalidate (unhash) the dentry in CI-mode.
+	 */
+	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+		d_invalidate(dentry);
+	return 0;
+}
+
+STATIC int
+xfs_vn_symlink(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	const char	*symname)
+{
+	struct inode	*inode;
+	struct xfs_inode *cip = NULL;
+	struct xfs_name	name;
+	int		error;
+	mode_t		mode;
+
+	mode = S_IFLNK |
+		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
+	xfs_dentry_to_name(&name, dentry);
+
+	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip);
+	if (unlikely(error))
+		goto out;
+
+	inode = VFS_I(cip);
+
+	error = xfs_init_security(inode, dir, &dentry->d_name);
+	if (unlikely(error))
+		goto out_cleanup_inode;
+
+	d_instantiate(dentry, inode);
+	return 0;
+
+ out_cleanup_inode:
+	xfs_cleanup_inode(dir, inode, dentry);
+ out:
+	return -error;
+}
+
+STATIC int
+xfs_vn_rename(
+	struct inode	*odir,
+	struct dentry	*odentry,
+	struct inode	*ndir,
+	struct dentry	*ndentry)
+{
+	struct inode	*new_inode = ndentry->d_inode;
+	struct xfs_name	oname;
+	struct xfs_name	nname;
+
+	xfs_dentry_to_name(&oname, odentry);
+	xfs_dentry_to_name(&nname, ndentry);
+
+	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
+			   XFS_I(ndir), &nname, new_inode ?
+			   			XFS_I(new_inode) : NULL);
+}
+
+/*
+ * careful here - this function can get called recursively, so
+ * we need to be very careful about how much stack we use.
+ * uio is kmalloced for this reason...
+ */
+STATIC void *
+xfs_vn_follow_link(
+	struct dentry		*dentry,
+	struct nameidata	*nd)
+{
+	char			*link;
+	int			error = -ENOMEM;
+
+	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
+	if (!link)
+		goto out_err;
+
+	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
+	if (unlikely(error))
+		goto out_kfree;
+
+	nd_set_link(nd, link);
+	return NULL;
+
+ out_kfree:
+	kfree(link);
+ out_err:
+	nd_set_link(nd, ERR_PTR(error));
+	return NULL;
+}
+
+STATIC void
+xfs_vn_put_link(
+	struct dentry	*dentry,
+	struct nameidata *nd,
+	void		*p)
+{
+	char		*s = nd_get_link(nd);
+
+	if (!IS_ERR(s))
+		kfree(s);
+}
+
+STATIC int
+xfs_vn_getattr(
+	struct vfsmount		*mnt,
+	struct dentry		*dentry,
+	struct kstat		*stat)
+{
+	struct inode		*inode = dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	trace_xfs_getattr(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	stat->size = XFS_ISIZE(ip);
+	stat->dev = inode->i_sb->s_dev;
+	stat->mode = ip->i_d.di_mode;
+	stat->nlink = ip->i_d.di_nlink;
+	stat->uid = ip->i_d.di_uid;
+	stat->gid = ip->i_d.di_gid;
+	stat->ino = ip->i_ino;
+	stat->atime = inode->i_atime;
+	stat->mtime = inode->i_mtime;
+	stat->ctime = inode->i_ctime;
+	stat->blocks =
+		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFBLK:
+	case S_IFCHR:
+		stat->blksize = BLKDEV_IOSIZE;
+		stat->rdev = MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
+				   sysv_minor(ip->i_df.if_u2.if_rdev));
+		break;
+	default:
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			/*
+			 * If the file blocks are being allocated from a
+			 * realtime volume, then return the inode's realtime
+			 * extent size or the realtime volume's extent size.
+			 */
+			stat->blksize =
+				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
+		} else
+			stat->blksize = xfs_preferred_iosize(mp);
+		stat->rdev = 0;
+		break;
+	}
+
+	return 0;
+}
+
+int
+xfs_setattr_nonsize(
+	struct xfs_inode	*ip,
+	struct iattr		*iattr,
+	int			flags)
+{
+	xfs_mount_t		*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			mask = iattr->ia_valid;
+	xfs_trans_t		*tp;
+	int			error;
+	uid_t			uid = 0, iuid = 0;
+	gid_t			gid = 0, igid = 0;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
+	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+
+	trace_xfs_setattr(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	error = -inode_change_ok(inode, iattr);
+	if (error)
+		return XFS_ERROR(error);
+
+	ASSERT((mask & ATTR_SIZE) == 0);
+
+	/*
+	 * If disk quotas is on, we make sure that the dquots do exist on disk,
+	 * before we start any other transactions. Trying to do this later
+	 * is messy. We don't care to take a readlock to look at the ids
+	 * in inode here, because we can't hold it across the trans_reserve.
+	 * If the IDs do change before we take the ilock, we're covered
+	 * because the i_*dquot fields will get updated anyway.
+	 */
+	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
+		uint	qflags = 0;
+
+		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
+			uid = iattr->ia_uid;
+			qflags |= XFS_QMOPT_UQUOTA;
+		} else {
+			uid = ip->i_d.di_uid;
+		}
+		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
+			gid = iattr->ia_gid;
+			qflags |= XFS_QMOPT_GQUOTA;
+		}  else {
+			gid = ip->i_d.di_gid;
+		}
+
+		/*
+		 * We take a reference when we initialize udqp and gdqp,
+		 * so it is important that we never blindly double trip on
+		 * the same variable. See xfs_create() for an example.
+		 */
+		ASSERT(udqp == NULL);
+		ASSERT(gdqp == NULL);
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
+					 qflags, &udqp, &gdqp);
+		if (error)
+			return error;
+	}
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error)
+		goto out_dqrele;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 */
+	if (mask & (ATTR_UID|ATTR_GID)) {
+		/*
+		 * These IDs could have changed since we last looked at them.
+		 * But, we're assured that if the ownership did change
+		 * while we didn't have the inode locked, inode's dquot(s)
+		 * would have changed also.
+		 */
+		iuid = ip->i_d.di_uid;
+		igid = ip->i_d.di_gid;
+		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
+		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
+
+		/*
+		 * Do a quota reservation only if uid/gid is actually
+		 * going to change.
+		 */
+		if (XFS_IS_QUOTA_RUNNING(mp) &&
+		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
+		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
+			ASSERT(tp);
+			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+						capable(CAP_FOWNER) ?
+						XFS_QMOPT_FORCE_RES : 0);
+			if (error)	/* out of quota */
+				goto out_trans_cancel;
+		}
+	}
+
+	xfs_trans_ijoin(tp, ip);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 */
+	if (mask & (ATTR_UID|ATTR_GID)) {
+		/*
+		 * CAP_FSETID overrides the following restrictions:
+		 *
+		 * The set-user-ID and set-group-ID bits of a file will be
+		 * cleared upon successful return from chown()
+		 */
+		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
+		    !capable(CAP_FSETID))
+			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
+
+		/*
+		 * Change the ownerships and register quota modifications
+		 * in the transaction.
+		 */
+		if (iuid != uid) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
+				ASSERT(mask & ATTR_UID);
+				ASSERT(udqp);
+				olddquot1 = xfs_qm_vop_chown(tp, ip,
+							&ip->i_udquot, udqp);
+			}
+			ip->i_d.di_uid = uid;
+			inode->i_uid = uid;
+		}
+		if (igid != gid) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
+				ASSERT(!XFS_IS_PQUOTA_ON(mp));
+				ASSERT(mask & ATTR_GID);
+				ASSERT(gdqp);
+				olddquot2 = xfs_qm_vop_chown(tp, ip,
+							&ip->i_gdquot, gdqp);
+			}
+			ip->i_d.di_gid = gid;
+			inode->i_gid = gid;
+		}
+	}
+
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+
+		ip->i_d.di_mode &= S_IFMT;
+		ip->i_d.di_mode |= mode & ~S_IFMT;
+
+		inode->i_mode &= S_IFMT;
+		inode->i_mode |= mode & ~S_IFMT;
+	}
+
+	/*
+	 * Change file access or modified times.
+	 */
+	if (mask & ATTR_ATIME) {
+		inode->i_atime = iattr->ia_atime;
+		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_CTIME) {
+		inode->i_ctime = iattr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Release any dquot(s) the inode had kept before chown.
+	 */
+	xfs_qm_dqrele(olddquot1);
+	xfs_qm_dqrele(olddquot2);
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+
+	if (error)
+		return XFS_ERROR(error);
+
+	/*
+	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
+	 * 	     update.  We could avoid this with linked transactions
+	 * 	     and passing down the transaction pointer all the way
+	 *	     to attr_set.  No previous user of the generic
+	 * 	     Posix ACL code seems to care about this issue either.
+	 */
+	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
+		error = -xfs_acl_chmod(inode);
+		if (error)
+			return XFS_ERROR(error);
+	}
+
+	return 0;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp, 0);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	return error;
+}
+
+/*
+ * Truncate file.  Must have write permission and not be a directory.
+ */
+int
+xfs_setattr_size(
+	struct xfs_inode	*ip,
+	struct iattr		*iattr,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			mask = iattr->ia_valid;
+	struct xfs_trans	*tp;
+	int			error;
+	uint			lock_flags;
+	uint			commit_flags = 0;
+
+	trace_xfs_setattr(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	error = -inode_change_ok(inode, iattr);
+	if (error)
+		return XFS_ERROR(error);
+
+	ASSERT(S_ISREG(ip->i_d.di_mode));
+	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
+			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+
+	lock_flags = XFS_ILOCK_EXCL;
+	if (!(flags & XFS_ATTR_NOLOCK))
+		lock_flags |= XFS_IOLOCK_EXCL;
+	xfs_ilock(ip, lock_flags);
+
+	/*
+	 * Short circuit the truncate case for zero length files.
+	 */
+	if (iattr->ia_size == 0 &&
+	    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
+		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
+			goto out_unlock;
+
+		/*
+		 * Use the regular setattr path to update the timestamps.
+		 */
+		xfs_iunlock(ip, lock_flags);
+		iattr->ia_valid &= ~ATTR_SIZE;
+		return xfs_setattr_nonsize(ip, iattr, 0);
+	}
+
+	/*
+	 * Make sure that the dquots are attached to the inode.
+	 */
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * Now we can make the changes.  Before we join the inode to the
+	 * transaction, take care of the part of the truncation that must be
+	 * done without the inode lock.  This needs to be done before joining
+	 * the inode to the transaction, because the inode cannot be unlocked
+	 * once it is a part of the transaction.
+	 */
+	if (iattr->ia_size > ip->i_size) {
+		/*
+		 * Do the first part of growing a file: zero any data in the
+		 * last block that is beyond the old EOF.  We need to do this
+		 * before the inode is joined to the transaction to modify
+		 * i_size.
+		 */
+		error = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
+		if (error)
+			goto out_unlock;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	lock_flags &= ~XFS_ILOCK_EXCL;
+
+	/*
+	 * We are going to log the inode size change in this transaction so
+	 * any previous writes that are beyond the on disk EOF and the new
+	 * EOF that have not been written out need to be written here.  If we
+	 * do not write the data out, we expose ourselves to the null files
+	 * problem.
+	 *
+	 * Only flush from the on disk size to the smaller of the in memory
+	 * file size or the new size as that's the range we really care about
+	 * here and prevents waiting for other data not within the range we
+	 * care about here.
+	 */
+	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
+		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size,
+					XBF_ASYNC, FI_NONE);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * Wait for all I/O to complete.
+	 */
+	xfs_ioend_wait(ip);
+
+	error = -block_truncate_page(inode->i_mapping, iattr->ia_size,
+				     xfs_get_blocks);
+	if (error)
+		goto out_unlock;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
+	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
+				 XFS_TRANS_PERM_LOG_RES,
+				 XFS_ITRUNCATE_LOG_COUNT);
+	if (error)
+		goto out_trans_cancel;
+
+	truncate_setsize(inode, iattr->ia_size);
+
+	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
+	lock_flags |= XFS_ILOCK_EXCL;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, ip);
+
+	/*
+	 * Only change the c/mtime if we are changing the size or we are
+	 * explicitly asked to change it.  This handles the semantic difference
+	 * between truncate() and ftruncate() as implemented in the VFS.
+	 *
+	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
+	 * special case where we need to update the times despite not having
+	 * these flags set.  For all other operations the VFS set these flags
+	 * explicitly if it wants a timestamp update.
+	 */
+	if (iattr->ia_size != ip->i_size &&
+	    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
+		iattr->ia_ctime = iattr->ia_mtime =
+			current_fs_time(inode->i_sb);
+		mask |= ATTR_CTIME | ATTR_MTIME;
+	}
+
+	if (iattr->ia_size > ip->i_size) {
+		ip->i_d.di_size = iattr->ia_size;
+		ip->i_size = iattr->ia_size;
+	} else if (iattr->ia_size <= ip->i_size ||
+		   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
+		error = xfs_itruncate_data(&tp, ip, iattr->ia_size);
+		if (error)
+			goto out_trans_abort;
+
+		/*
+		 * Truncated "down", so we're removing references to old data
+		 * here - if we delay flushing for a long time, we expose
+		 * ourselves unduly to the notorious NULL files problem.  So,
+		 * we mark this inode and flush it when the file is closed,
+		 * and do not wait the usual (long) time for writeout.
+		 */
+		xfs_iflags_set(ip, XFS_ITRUNCATED);
+	}
+
+	if (mask & ATTR_CTIME) {
+		inode->i_ctime = iattr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+out_unlock:
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
+	return error;
+
+out_trans_abort:
+	commit_flags |= XFS_TRANS_ABORT;
+out_trans_cancel:
+	xfs_trans_cancel(tp, commit_flags);
+	goto out_unlock;
+}
+
+STATIC int
+xfs_vn_setattr(
+	struct dentry	*dentry,
+	struct iattr	*iattr)
+{
+	if (iattr->ia_valid & ATTR_SIZE)
+		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
+	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
+}
+
+#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
+
+/*
+ * Call fiemap helper to fill in user data.
+ * Returns positive errors to xfs_getbmap.
+ */
+STATIC int
+xfs_fiemap_format(
+	void			**arg,
+	struct getbmapx		*bmv,
+	int			*full)
+{
+	int			error;
+	struct fiemap_extent_info *fieinfo = *arg;
+	u32			fiemap_flags = 0;
+	u64			logical, physical, length;
+
+	/* Do nothing for a hole */
+	if (bmv->bmv_block == -1LL)
+		return 0;
+
+	logical = BBTOB(bmv->bmv_offset);
+	physical = BBTOB(bmv->bmv_block);
+	length = BBTOB(bmv->bmv_length);
+
+	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
+		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
+	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		physical = 0;   /* no block yet */
+	}
+	if (bmv->bmv_oflags & BMV_OF_LAST)
+		fiemap_flags |= FIEMAP_EXTENT_LAST;
+
+	error = fiemap_fill_next_extent(fieinfo, logical, physical,
+					length, fiemap_flags);
+	if (error > 0) {
+		error = 0;
+		*full = 1;	/* user array now full */
+	}
+
+	return -error;
+}
+
+STATIC int
+xfs_vn_fiemap(
+	struct inode		*inode,
+	struct fiemap_extent_info *fieinfo,
+	u64			start,
+	u64			length)
+{
+	xfs_inode_t		*ip = XFS_I(inode);
+	struct getbmapx		bm;
+	int			error;
+
+	error = fiemap_check_flags(fieinfo, XFS_FIEMAP_FLAGS);
+	if (error)
+		return error;
+
+	/* Set up bmap header for xfs internal routine */
+	bm.bmv_offset = BTOBB(start);
+	/* Special case for whole file */
+	if (length == FIEMAP_MAX_OFFSET)
+		bm.bmv_length = -1LL;
+	else
+		bm.bmv_length = BTOBB(length);
+
+	/* We add one because in getbmap world count includes the header */
+	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
+					fieinfo->fi_extents_max + 1;
+	bm.bmv_count = min_t(__s32, bm.bmv_count,
+			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
+	bm.bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
+	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
+		bm.bmv_iflags |= BMV_IF_ATTRFORK;
+	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
+		bm.bmv_iflags |= BMV_IF_DELALLOC;
+
+	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
+	if (error)
+		return -error;
+
+	return 0;
+}
+
+static const struct inode_operations xfs_inode_operations = {
+	.check_acl		= xfs_check_acl,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+	.fiemap			= xfs_vn_fiemap,
+};
+
+static const struct inode_operations xfs_dir_inode_operations = {
+	.create			= xfs_vn_create,
+	.lookup			= xfs_vn_lookup,
+	.link			= xfs_vn_link,
+	.unlink			= xfs_vn_unlink,
+	.symlink		= xfs_vn_symlink,
+	.mkdir			= xfs_vn_mkdir,
+	/*
+	 * Yes, XFS uses the same method for rmdir and unlink.
+	 *
+	 * There are some subtile differences deeper in the code,
+	 * but we use S_ISDIR to check for those.
+	 */
+	.rmdir			= xfs_vn_unlink,
+	.mknod			= xfs_vn_mknod,
+	.rename			= xfs_vn_rename,
+	.check_acl		= xfs_check_acl,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+};
+
+static const struct inode_operations xfs_dir_ci_inode_operations = {
+	.create			= xfs_vn_create,
+	.lookup			= xfs_vn_ci_lookup,
+	.link			= xfs_vn_link,
+	.unlink			= xfs_vn_unlink,
+	.symlink		= xfs_vn_symlink,
+	.mkdir			= xfs_vn_mkdir,
+	/*
+	 * Yes, XFS uses the same method for rmdir and unlink.
+	 *
+	 * There are some subtile differences deeper in the code,
+	 * but we use S_ISDIR to check for those.
+	 */
+	.rmdir			= xfs_vn_unlink,
+	.mknod			= xfs_vn_mknod,
+	.rename			= xfs_vn_rename,
+	.check_acl		= xfs_check_acl,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+};
+
+static const struct inode_operations xfs_symlink_inode_operations = {
+	.readlink		= generic_readlink,
+	.follow_link		= xfs_vn_follow_link,
+	.put_link		= xfs_vn_put_link,
+	.check_acl		= xfs_check_acl,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+};
+
+STATIC void
+xfs_diflags_to_iflags(
+	struct inode		*inode,
+	struct xfs_inode	*ip)
+{
+	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+		inode->i_flags |= S_IMMUTABLE;
+	else
+		inode->i_flags &= ~S_IMMUTABLE;
+	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+		inode->i_flags |= S_APPEND;
+	else
+		inode->i_flags &= ~S_APPEND;
+	if (ip->i_d.di_flags & XFS_DIFLAG_SYNC)
+		inode->i_flags |= S_SYNC;
+	else
+		inode->i_flags &= ~S_SYNC;
+	if (ip->i_d.di_flags & XFS_DIFLAG_NOATIME)
+		inode->i_flags |= S_NOATIME;
+	else
+		inode->i_flags &= ~S_NOATIME;
+}
+
+/*
+ * Initialize the Linux inode, set up the operation vectors and
+ * unlock the inode.
+ *
+ * When reading existing inodes from disk this is called directly
+ * from xfs_iget, when creating a new inode it is called from
+ * xfs_ialloc after setting up the inode.
+ *
+ * We are always called with an uninitialised linux inode here.
+ * We need to initialise the necessary fields and take a reference
+ * on it.
+ */
+void
+xfs_setup_inode(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = &ip->i_vnode;
+
+	inode->i_ino = ip->i_ino;
+	inode->i_state = I_NEW;
+
+	inode_sb_list_add(inode);
+	/* make the inode look hashed for the writeback code */
+	hlist_add_fake(&inode->i_hash);
+
+	inode->i_mode	= ip->i_d.di_mode;
+	inode->i_nlink	= ip->i_d.di_nlink;
+	inode->i_uid	= ip->i_d.di_uid;
+	inode->i_gid	= ip->i_d.di_gid;
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFBLK:
+	case S_IFCHR:
+		inode->i_rdev =
+			MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
+			      sysv_minor(ip->i_df.if_u2.if_rdev));
+		break;
+	default:
+		inode->i_rdev = 0;
+		break;
+	}
+
+	inode->i_generation = ip->i_d.di_gen;
+	i_size_write(inode, ip->i_d.di_size);
+	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
+	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
+	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
+	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
+	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
+	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
+	xfs_diflags_to_iflags(inode, ip);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_op = &xfs_inode_operations;
+		inode->i_fop = &xfs_file_operations;
+		inode->i_mapping->a_ops = &xfs_address_space_operations;
+		break;
+	case S_IFDIR:
+		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+			inode->i_op = &xfs_dir_ci_inode_operations;
+		else
+			inode->i_op = &xfs_dir_inode_operations;
+		inode->i_fop = &xfs_dir_file_operations;
+		break;
+	case S_IFLNK:
+		inode->i_op = &xfs_symlink_inode_operations;
+		if (!(ip->i_df.if_flags & XFS_IFINLINE))
+			inode->i_mapping->a_ops = &xfs_address_space_operations;
+		break;
+	default:
+		inode->i_op = &xfs_inode_operations;
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+		break;
+	}
+
+	xfs_iflags_clear(ip, XFS_INEW);
+	barrier();
+
+	unlock_new_inode(inode);
+}
diff --git a/fs/xfs/linux/xfs_iops.h b/fs/xfs/linux/xfs_iops.h
new file mode 100644
index 0000000..ef41c92
--- /dev/null
+++ b/fs/xfs/linux/xfs_iops.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_IOPS_H__
+#define __XFS_IOPS_H__
+
+struct xfs_inode;
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
+
+extern void xfs_setup_inode(struct xfs_inode *);
+
+#endif /* __XFS_IOPS_H__ */
diff --git a/fs/xfs/linux/xfs_linux.h b/fs/xfs/linux/xfs_linux.h
new file mode 100644
index 0000000..d42f814
--- /dev/null
+++ b/fs/xfs/linux/xfs_linux.h
@@ -0,0 +1,310 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_LINUX__
+#define __XFS_LINUX__
+
+#include <linux/types.h>
+
+/*
+ * XFS_BIG_BLKNOS needs block layer disk addresses to be 64 bits.
+ * XFS_BIG_INUMS requires XFS_BIG_BLKNOS to be set.
+ */
+#if defined(CONFIG_LBDAF) || (BITS_PER_LONG == 64)
+# define XFS_BIG_BLKNOS	1
+# define XFS_BIG_INUMS	1
+#else
+# define XFS_BIG_BLKNOS	0
+# define XFS_BIG_INUMS	0
+#endif
+
+#include <xfs_types.h>
+
+#include <kmem.h>
+#include <mrlock.h>
+#include <time.h>
+
+#include <support/uuid.h>
+
+#include <linux/semaphore.h>
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/file.h>
+#include <linux/swap.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/major.h>
+#include <linux/pagemap.h>
+#include <linux/vfs.h>
+#include <linux/seq_file.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/proc_fs.h>
+#include <linux/sort.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
+#include <linux/delay.h>
+#include <linux/log2.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+#include <linux/ctype.h>
+#include <linux/writeback.h>
+#include <linux/capability.h>
+#include <linux/list_sort.h>
+
+#include <asm/page.h>
+#include <asm/div64.h>
+#include <asm/param.h>
+#include <asm/uaccess.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#include <xfs_vnode.h>
+#include <xfs_stats.h>
+#include <xfs_sysctl.h>
+#include <xfs_iops.h>
+#include <xfs_aops.h>
+#include <xfs_super.h>
+#include <xfs_buf.h>
+#include <xfs_message.h>
+
+#ifdef __BIG_ENDIAN
+#define XFS_NATIVE_HOST 1
+#else
+#undef XFS_NATIVE_HOST
+#endif
+
+/*
+ * Feature macros (disable/enable)
+ */
+#ifdef CONFIG_SMP
+#define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
+#else
+#undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
+#endif
+
+#define irix_sgid_inherit	xfs_params.sgid_inherit.val
+#define irix_symlink_mode	xfs_params.symlink_mode.val
+#define xfs_panic_mask		xfs_params.panic_mask.val
+#define xfs_error_level		xfs_params.error_level.val
+#define xfs_syncd_centisecs	xfs_params.syncd_timer.val
+#define xfs_stats_clear		xfs_params.stats_clear.val
+#define xfs_inherit_sync	xfs_params.inherit_sync.val
+#define xfs_inherit_nodump	xfs_params.inherit_nodump.val
+#define xfs_inherit_noatime	xfs_params.inherit_noatim.val
+#define xfs_buf_timer_centisecs	xfs_params.xfs_buf_timer.val
+#define xfs_buf_age_centisecs	xfs_params.xfs_buf_age.val
+#define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
+#define xfs_rotorstep		xfs_params.rotorstep.val
+#define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
+#define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
+
+#define current_cpu()		(raw_smp_processor_id())
+#define current_pid()		(current->pid)
+#define current_test_flags(f)	(current->flags & (f))
+#define current_set_flags_nested(sp, f)		\
+		(*(sp) = current->flags, current->flags |= (f))
+#define current_clear_flags_nested(sp, f)	\
+		(*(sp) = current->flags, current->flags &= ~(f))
+#define current_restore_flags_nested(sp, f)	\
+		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
+
+#define spinlock_destroy(lock)
+
+#define NBBY		8		/* number of bits per byte */
+
+/*
+ * Size of block device i/o is parameterized here.
+ * Currently the system supports page-sized i/o.
+ */
+#define	BLKDEV_IOSHIFT		PAGE_CACHE_SHIFT
+#define	BLKDEV_IOSIZE		(1<<BLKDEV_IOSHIFT)
+/* number of BB's per block device block */
+#define	BLKDEV_BB		BTOBB(BLKDEV_IOSIZE)
+
+#define ENOATTR		ENODATA		/* Attribute not found */
+#define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
+#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+
+#define SYNCHRONIZE()	barrier()
+#define __return_address __builtin_return_address(0)
+
+#define XFS_PROJID_DEFAULT	0
+#define MAXPATHLEN	1024
+
+#define MIN(a,b)	(min(a,b))
+#define MAX(a,b)	(max(a,b))
+#define howmany(x, y)	(((x)+((y)-1))/(y))
+
+/*
+ * Various platform dependent calls that don't fit anywhere else
+ */
+#define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
+#define xfs_stack_trace()	dump_stack()
+
+
+/* Move the kernel do_div definition off to one side */
+
+#if defined __i386__
+/* For ia32 we need to pull some tricks to get past various versions
+ * of the compiler which do not like us using do_div in the middle
+ * of large functions.
+ */
+static inline __u32 xfs_do_div(void *a, __u32 b, int n)
+{
+	__u32	mod;
+
+	switch (n) {
+		case 4:
+			mod = *(__u32 *)a % b;
+			*(__u32 *)a = *(__u32 *)a / b;
+			return mod;
+		case 8:
+			{
+			unsigned long __upper, __low, __high, __mod;
+			__u64	c = *(__u64 *)a;
+			__upper = __high = c >> 32;
+			__low = c;
+			if (__high) {
+				__upper = __high % (b);
+				__high = __high / (b);
+			}
+			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
+			asm("":"=A" (c):"a" (__low),"d" (__high));
+			*(__u64 *)a = c;
+			return __mod;
+			}
+	}
+
+	/* NOTREACHED */
+	return 0;
+}
+
+/* Side effect free 64 bit mod operation */
+static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
+{
+	switch (n) {
+		case 4:
+			return *(__u32 *)a % b;
+		case 8:
+			{
+			unsigned long __upper, __low, __high, __mod;
+			__u64	c = *(__u64 *)a;
+			__upper = __high = c >> 32;
+			__low = c;
+			if (__high) {
+				__upper = __high % (b);
+				__high = __high / (b);
+			}
+			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
+			asm("":"=A" (c):"a" (__low),"d" (__high));
+			return __mod;
+			}
+	}
+
+	/* NOTREACHED */
+	return 0;
+}
+#else
+static inline __u32 xfs_do_div(void *a, __u32 b, int n)
+{
+	__u32	mod;
+
+	switch (n) {
+		case 4:
+			mod = *(__u32 *)a % b;
+			*(__u32 *)a = *(__u32 *)a / b;
+			return mod;
+		case 8:
+			mod = do_div(*(__u64 *)a, b);
+			return mod;
+	}
+
+	/* NOTREACHED */
+	return 0;
+}
+
+/* Side effect free 64 bit mod operation */
+static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
+{
+	switch (n) {
+		case 4:
+			return *(__u32 *)a % b;
+		case 8:
+			{
+			__u64	c = *(__u64 *)a;
+			return do_div(c, b);
+			}
+	}
+
+	/* NOTREACHED */
+	return 0;
+}
+#endif
+
+#undef do_div
+#define do_div(a, b)	xfs_do_div(&(a), (b), sizeof(a))
+#define do_mod(a, b)	xfs_do_mod(&(a), (b), sizeof(a))
+
+static inline __uint64_t roundup_64(__uint64_t x, __uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return(x * y);
+}
+
+static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x;
+}
+
+/* ARM old ABI has some weird alignment/padding */
+#if defined(__arm__) && !defined(__ARM_EABI__)
+#define __arch_pack __attribute__((packed))
+#else
+#define __arch_pack
+#endif
+
+#define ASSERT_ALWAYS(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+
+#ifndef DEBUG
+#define ASSERT(expr)	((void)0)
+
+#ifndef STATIC
+# define STATIC static noinline
+#endif
+
+#else /* DEBUG */
+
+#define ASSERT(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+
+#ifndef STATIC
+# define STATIC noinline
+#endif
+
+#endif /* DEBUG */
+
+#endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/linux/xfs_message.c b/fs/xfs/linux/xfs_message.c
new file mode 100644
index 0000000..bd672de
--- /dev/null
+++ b/fs/xfs/linux/xfs_message.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+
+/*
+ * XFS logging functions
+ */
+static void
+__xfs_printk(
+	const char		*level,
+	const struct xfs_mount	*mp,
+	struct va_format	*vaf)
+{
+	if (mp && mp->m_fsname) {
+		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
+		return;
+	}
+	printk("%sXFS: %pV\n", level, vaf);
+}
+
+#define define_xfs_printk_level(func, kern_level)		\
+void func(const struct xfs_mount *mp, const char *fmt, ...)	\
+{								\
+	struct va_format	vaf;				\
+	va_list			args;				\
+								\
+	va_start(args, fmt);					\
+								\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+								\
+	__xfs_printk(kern_level, mp, &vaf);			\
+	va_end(args);						\
+}								\
+
+define_xfs_printk_level(xfs_emerg, KERN_EMERG);
+define_xfs_printk_level(xfs_alert, KERN_ALERT);
+define_xfs_printk_level(xfs_crit, KERN_CRIT);
+define_xfs_printk_level(xfs_err, KERN_ERR);
+define_xfs_printk_level(xfs_warn, KERN_WARNING);
+define_xfs_printk_level(xfs_notice, KERN_NOTICE);
+define_xfs_printk_level(xfs_info, KERN_INFO);
+#ifdef DEBUG
+define_xfs_printk_level(xfs_debug, KERN_DEBUG);
+#endif
+
+void
+xfs_alert_tag(
+	const struct xfs_mount	*mp,
+	int			panic_tag,
+	const char		*fmt, ...)
+{
+	struct va_format	vaf;
+	va_list			args;
+	int			do_panic = 0;
+
+	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
+		xfs_alert(mp, "Transforming an alert into a BUG.");
+		do_panic = 1;
+	}
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	__xfs_printk(KERN_ALERT, mp, &vaf);
+	va_end(args);
+
+	BUG_ON(do_panic);
+}
+
+void
+assfail(char *expr, char *file, int line)
+{
+	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
+		expr, file, line);
+	BUG();
+}
+
+void
+xfs_hex_dump(void *p, int length)
+{
+	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p, length, 1);
+}
diff --git a/fs/xfs/linux/xfs_message.h b/fs/xfs/linux/xfs_message.h
new file mode 100644
index 0000000..7fb7ea0
--- /dev/null
+++ b/fs/xfs/linux/xfs_message.h
@@ -0,0 +1,39 @@
+#ifndef __XFS_MESSAGE_H
+#define __XFS_MESSAGE_H 1
+
+struct xfs_mount;
+
+extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
+			 const char *fmt, ...)
+        __attribute__ ((format (printf, 3, 4)));
+extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+
+#ifdef DEBUG
+extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+#else
+static inline void
+__attribute__ ((format (printf, 2, 3)))
+xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+{
+}
+#endif
+
+extern void assfail(char *expr, char *f, int l);
+
+extern void xfs_hex_dump(void *p, int length);
+
+#endif	/* __XFS_MESSAGE_H */
diff --git a/fs/xfs/linux/xfs_quotaops.c b/fs/xfs/linux/xfs_quotaops.c
new file mode 100644
index 0000000..29b9d64
--- /dev/null
+++ b/fs/xfs/linux/xfs_quotaops.c
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2008, Christoph Hellwig
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_sb.h"
+#include "xfs_inum.h"
+#include "xfs_log.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_quota.h"
+#include "xfs_trans.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "quota/xfs_qm.h"
+#include <linux/quota.h>
+
+
+STATIC int
+xfs_quota_type(int type)
+{
+	switch (type) {
+	case USRQUOTA:
+		return XFS_DQ_USER;
+	case GRPQUOTA:
+		return XFS_DQ_GROUP;
+	default:
+		return XFS_DQ_PROJ;
+	}
+}
+
+STATIC int
+xfs_fs_get_xstate(
+	struct super_block	*sb,
+	struct fs_quota_stat	*fqs)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	return -xfs_qm_scall_getqstat(mp, fqs);
+}
+
+STATIC int
+xfs_fs_set_xstate(
+	struct super_block	*sb,
+	unsigned int		uflags,
+	int			op)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	unsigned int		flags = 0;
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+
+	if (uflags & FS_QUOTA_UDQ_ACCT)
+		flags |= XFS_UQUOTA_ACCT;
+	if (uflags & FS_QUOTA_PDQ_ACCT)
+		flags |= XFS_PQUOTA_ACCT;
+	if (uflags & FS_QUOTA_GDQ_ACCT)
+		flags |= XFS_GQUOTA_ACCT;
+	if (uflags & FS_QUOTA_UDQ_ENFD)
+		flags |= XFS_UQUOTA_ENFD;
+	if (uflags & (FS_QUOTA_PDQ_ENFD|FS_QUOTA_GDQ_ENFD))
+		flags |= XFS_OQUOTA_ENFD;
+
+	switch (op) {
+	case Q_XQUOTAON:
+		return -xfs_qm_scall_quotaon(mp, flags);
+	case Q_XQUOTAOFF:
+		if (!XFS_IS_QUOTA_ON(mp))
+			return -EINVAL;
+		return -xfs_qm_scall_quotaoff(mp, flags);
+	case Q_XQUOTARM:
+		if (XFS_IS_QUOTA_ON(mp))
+			return -EINVAL;
+		return -xfs_qm_scall_trunc_qfiles(mp, flags);
+	}
+
+	return -EINVAL;
+}
+
+STATIC int
+xfs_fs_get_dqblk(
+	struct super_block	*sb,
+	int			type,
+	qid_t			id,
+	struct fs_disk_quota	*fdq)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+
+	return -xfs_qm_scall_getquota(mp, id, xfs_quota_type(type), fdq);
+}
+
+STATIC int
+xfs_fs_set_dqblk(
+	struct super_block	*sb,
+	int			type,
+	qid_t			id,
+	struct fs_disk_quota	*fdq)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+
+	return -xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
+}
+
+const struct quotactl_ops xfs_quotactl_operations = {
+	.get_xstate		= xfs_fs_get_xstate,
+	.set_xstate		= xfs_fs_set_xstate,
+	.get_dqblk		= xfs_fs_get_dqblk,
+	.set_dqblk		= xfs_fs_set_dqblk,
+};
diff --git a/fs/xfs/linux/xfs_stats.c b/fs/xfs/linux/xfs_stats.c
new file mode 100644
index 0000000..76fdc58
--- /dev/null
+++ b/fs/xfs/linux/xfs_stats.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include <linux/proc_fs.h>
+
+DEFINE_PER_CPU(struct xfsstats, xfsstats);
+
+static int xfs_stat_proc_show(struct seq_file *m, void *v)
+{
+	int		c, i, j, val;
+	__uint64_t	xs_xstrat_bytes = 0;
+	__uint64_t	xs_write_bytes = 0;
+	__uint64_t	xs_read_bytes = 0;
+
+	static const struct xstats_entry {
+		char	*desc;
+		int	endpoint;
+	} xstats[] = {
+		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
+		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
+		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
+		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
+		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
+		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
+		{ "ig",			XFSSTAT_END_INODE_OPS		},
+		{ "log",		XFSSTAT_END_LOG_OPS		},
+		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
+		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
+		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
+		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
+		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
+		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
+		{ "buf",		XFSSTAT_END_BUF			},
+		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
+		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
+		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
+		{ "ibt2",		XFSSTAT_END_IBT_V2		},
+	};
+
+	/* Loop over all stats groups */
+	for (i=j = 0; i < ARRAY_SIZE(xstats); i++) {
+		seq_printf(m, "%s", xstats[i].desc);
+		/* inner loop does each group */
+		while (j < xstats[i].endpoint) {
+			val = 0;
+			/* sum over all cpus */
+			for_each_possible_cpu(c)
+				val += *(((__u32*)&per_cpu(xfsstats, c) + j));
+			seq_printf(m, " %u", val);
+			j++;
+		}
+		seq_putc(m, '\n');
+	}
+	/* extra precision counters */
+	for_each_possible_cpu(i) {
+		xs_xstrat_bytes += per_cpu(xfsstats, i).xs_xstrat_bytes;
+		xs_write_bytes += per_cpu(xfsstats, i).xs_write_bytes;
+		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
+	}
+
+	seq_printf(m, "xpc %Lu %Lu %Lu\n",
+			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	seq_printf(m, "debug %u\n",
+#if defined(DEBUG)
+		1);
+#else
+		0);
+#endif
+	return 0;
+}
+
+static int xfs_stat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, xfs_stat_proc_show, NULL);
+}
+
+static const struct file_operations xfs_stat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xfs_stat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int
+xfs_init_procfs(void)
+{
+	if (!proc_mkdir("fs/xfs", NULL))
+		goto out;
+
+	if (!proc_create("fs/xfs/stat", 0, NULL,
+			 &xfs_stat_proc_fops))
+		goto out_remove_entry;
+	return 0;
+
+ out_remove_entry:
+	remove_proc_entry("fs/xfs", NULL);
+ out:
+	return -ENOMEM;
+}
+
+void
+xfs_cleanup_procfs(void)
+{
+	remove_proc_entry("fs/xfs/stat", NULL);
+	remove_proc_entry("fs/xfs", NULL);
+}
diff --git a/fs/xfs/linux/xfs_stats.h b/fs/xfs/linux/xfs_stats.h
new file mode 100644
index 0000000..736854b
--- /dev/null
+++ b/fs/xfs/linux/xfs_stats.h
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_STATS_H__
+#define __XFS_STATS_H__
+
+
+#if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
+
+#include <linux/percpu.h>
+
+/*
+ * XFS global statistics
+ */
+struct xfsstats {
+# define XFSSTAT_END_EXTENT_ALLOC	4
+	__uint32_t		xs_allocx;
+	__uint32_t		xs_allocb;
+	__uint32_t		xs_freex;
+	__uint32_t		xs_freeb;
+# define XFSSTAT_END_ALLOC_BTREE	(XFSSTAT_END_EXTENT_ALLOC+4)
+	__uint32_t		xs_abt_lookup;
+	__uint32_t		xs_abt_compare;
+	__uint32_t		xs_abt_insrec;
+	__uint32_t		xs_abt_delrec;
+# define XFSSTAT_END_BLOCK_MAPPING	(XFSSTAT_END_ALLOC_BTREE+7)
+	__uint32_t		xs_blk_mapr;
+	__uint32_t		xs_blk_mapw;
+	__uint32_t		xs_blk_unmap;
+	__uint32_t		xs_add_exlist;
+	__uint32_t		xs_del_exlist;
+	__uint32_t		xs_look_exlist;
+	__uint32_t		xs_cmp_exlist;
+# define XFSSTAT_END_BLOCK_MAP_BTREE	(XFSSTAT_END_BLOCK_MAPPING+4)
+	__uint32_t		xs_bmbt_lookup;
+	__uint32_t		xs_bmbt_compare;
+	__uint32_t		xs_bmbt_insrec;
+	__uint32_t		xs_bmbt_delrec;
+# define XFSSTAT_END_DIRECTORY_OPS	(XFSSTAT_END_BLOCK_MAP_BTREE+4)
+	__uint32_t		xs_dir_lookup;
+	__uint32_t		xs_dir_create;
+	__uint32_t		xs_dir_remove;
+	__uint32_t		xs_dir_getdents;
+# define XFSSTAT_END_TRANSACTIONS	(XFSSTAT_END_DIRECTORY_OPS+3)
+	__uint32_t		xs_trans_sync;
+	__uint32_t		xs_trans_async;
+	__uint32_t		xs_trans_empty;
+# define XFSSTAT_END_INODE_OPS		(XFSSTAT_END_TRANSACTIONS+7)
+	__uint32_t		xs_ig_attempts;
+	__uint32_t		xs_ig_found;
+	__uint32_t		xs_ig_frecycle;
+	__uint32_t		xs_ig_missed;
+	__uint32_t		xs_ig_dup;
+	__uint32_t		xs_ig_reclaims;
+	__uint32_t		xs_ig_attrchg;
+# define XFSSTAT_END_LOG_OPS		(XFSSTAT_END_INODE_OPS+5)
+	__uint32_t		xs_log_writes;
+	__uint32_t		xs_log_blocks;
+	__uint32_t		xs_log_noiclogs;
+	__uint32_t		xs_log_force;
+	__uint32_t		xs_log_force_sleep;
+# define XFSSTAT_END_TAIL_PUSHING	(XFSSTAT_END_LOG_OPS+10)
+	__uint32_t		xs_try_logspace;
+	__uint32_t		xs_sleep_logspace;
+	__uint32_t		xs_push_ail;
+	__uint32_t		xs_push_ail_success;
+	__uint32_t		xs_push_ail_pushbuf;
+	__uint32_t		xs_push_ail_pinned;
+	__uint32_t		xs_push_ail_locked;
+	__uint32_t		xs_push_ail_flushing;
+	__uint32_t		xs_push_ail_restarts;
+	__uint32_t		xs_push_ail_flush;
+# define XFSSTAT_END_WRITE_CONVERT	(XFSSTAT_END_TAIL_PUSHING+2)
+	__uint32_t		xs_xstrat_quick;
+	__uint32_t		xs_xstrat_split;
+# define XFSSTAT_END_READ_WRITE_OPS	(XFSSTAT_END_WRITE_CONVERT+2)
+	__uint32_t		xs_write_calls;
+	__uint32_t		xs_read_calls;
+# define XFSSTAT_END_ATTRIBUTE_OPS	(XFSSTAT_END_READ_WRITE_OPS+4)
+	__uint32_t		xs_attr_get;
+	__uint32_t		xs_attr_set;
+	__uint32_t		xs_attr_remove;
+	__uint32_t		xs_attr_list;
+# define XFSSTAT_END_INODE_CLUSTER	(XFSSTAT_END_ATTRIBUTE_OPS+3)
+	__uint32_t		xs_iflush_count;
+	__uint32_t		xs_icluster_flushcnt;
+	__uint32_t		xs_icluster_flushinode;
+# define XFSSTAT_END_VNODE_OPS		(XFSSTAT_END_INODE_CLUSTER+8)
+	__uint32_t		vn_active;	/* # vnodes not on free lists */
+	__uint32_t		vn_alloc;	/* # times vn_alloc called */
+	__uint32_t		vn_get;		/* # times vn_get called */
+	__uint32_t		vn_hold;	/* # times vn_hold called */
+	__uint32_t		vn_rele;	/* # times vn_rele called */
+	__uint32_t		vn_reclaim;	/* # times vn_reclaim called */
+	__uint32_t		vn_remove;	/* # times vn_remove called */
+	__uint32_t		vn_free;	/* # times vn_free called */
+#define XFSSTAT_END_BUF			(XFSSTAT_END_VNODE_OPS+9)
+	__uint32_t		xb_get;
+	__uint32_t		xb_create;
+	__uint32_t		xb_get_locked;
+	__uint32_t		xb_get_locked_waited;
+	__uint32_t		xb_busy_locked;
+	__uint32_t		xb_miss_locked;
+	__uint32_t		xb_page_retries;
+	__uint32_t		xb_page_found;
+	__uint32_t		xb_get_read;
+/* Version 2 btree counters */
+#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+15)
+	__uint32_t		xs_abtb_2_lookup;
+	__uint32_t		xs_abtb_2_compare;
+	__uint32_t		xs_abtb_2_insrec;
+	__uint32_t		xs_abtb_2_delrec;
+	__uint32_t		xs_abtb_2_newroot;
+	__uint32_t		xs_abtb_2_killroot;
+	__uint32_t		xs_abtb_2_increment;
+	__uint32_t		xs_abtb_2_decrement;
+	__uint32_t		xs_abtb_2_lshift;
+	__uint32_t		xs_abtb_2_rshift;
+	__uint32_t		xs_abtb_2_split;
+	__uint32_t		xs_abtb_2_join;
+	__uint32_t		xs_abtb_2_alloc;
+	__uint32_t		xs_abtb_2_free;
+	__uint32_t		xs_abtb_2_moves;
+#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+15)
+	__uint32_t		xs_abtc_2_lookup;
+	__uint32_t		xs_abtc_2_compare;
+	__uint32_t		xs_abtc_2_insrec;
+	__uint32_t		xs_abtc_2_delrec;
+	__uint32_t		xs_abtc_2_newroot;
+	__uint32_t		xs_abtc_2_killroot;
+	__uint32_t		xs_abtc_2_increment;
+	__uint32_t		xs_abtc_2_decrement;
+	__uint32_t		xs_abtc_2_lshift;
+	__uint32_t		xs_abtc_2_rshift;
+	__uint32_t		xs_abtc_2_split;
+	__uint32_t		xs_abtc_2_join;
+	__uint32_t		xs_abtc_2_alloc;
+	__uint32_t		xs_abtc_2_free;
+	__uint32_t		xs_abtc_2_moves;
+#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+15)
+	__uint32_t		xs_bmbt_2_lookup;
+	__uint32_t		xs_bmbt_2_compare;
+	__uint32_t		xs_bmbt_2_insrec;
+	__uint32_t		xs_bmbt_2_delrec;
+	__uint32_t		xs_bmbt_2_newroot;
+	__uint32_t		xs_bmbt_2_killroot;
+	__uint32_t		xs_bmbt_2_increment;
+	__uint32_t		xs_bmbt_2_decrement;
+	__uint32_t		xs_bmbt_2_lshift;
+	__uint32_t		xs_bmbt_2_rshift;
+	__uint32_t		xs_bmbt_2_split;
+	__uint32_t		xs_bmbt_2_join;
+	__uint32_t		xs_bmbt_2_alloc;
+	__uint32_t		xs_bmbt_2_free;
+	__uint32_t		xs_bmbt_2_moves;
+#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+15)
+	__uint32_t		xs_ibt_2_lookup;
+	__uint32_t		xs_ibt_2_compare;
+	__uint32_t		xs_ibt_2_insrec;
+	__uint32_t		xs_ibt_2_delrec;
+	__uint32_t		xs_ibt_2_newroot;
+	__uint32_t		xs_ibt_2_killroot;
+	__uint32_t		xs_ibt_2_increment;
+	__uint32_t		xs_ibt_2_decrement;
+	__uint32_t		xs_ibt_2_lshift;
+	__uint32_t		xs_ibt_2_rshift;
+	__uint32_t		xs_ibt_2_split;
+	__uint32_t		xs_ibt_2_join;
+	__uint32_t		xs_ibt_2_alloc;
+	__uint32_t		xs_ibt_2_free;
+	__uint32_t		xs_ibt_2_moves;
+/* Extra precision counters */
+	__uint64_t		xs_xstrat_bytes;
+	__uint64_t		xs_write_bytes;
+	__uint64_t		xs_read_bytes;
+};
+
+DECLARE_PER_CPU(struct xfsstats, xfsstats);
+
+/*
+ * We don't disable preempt, not too worried about poking the
+ * wrong CPU's stat for now (also aggregated before reporting).
+ */
+#define XFS_STATS_INC(v)	(per_cpu(xfsstats, current_cpu()).v++)
+#define XFS_STATS_DEC(v)	(per_cpu(xfsstats, current_cpu()).v--)
+#define XFS_STATS_ADD(v, inc)	(per_cpu(xfsstats, current_cpu()).v += (inc))
+
+extern int xfs_init_procfs(void);
+extern void xfs_cleanup_procfs(void);
+
+
+#else	/* !CONFIG_PROC_FS */
+
+# define XFS_STATS_INC(count)
+# define XFS_STATS_DEC(count)
+# define XFS_STATS_ADD(count, inc)
+
+static inline int xfs_init_procfs(void)
+{
+	return 0;
+}
+
+static inline void xfs_cleanup_procfs(void)
+{
+}
+
+#endif	/* !CONFIG_PROC_FS */
+
+#endif /* __XFS_STATS_H__ */
diff --git a/fs/xfs/linux/xfs_super.c b/fs/xfs/linux/xfs_super.c
new file mode 100644
index 0000000..25fd2cd
--- /dev/null
+++ b/fs/xfs/linux/xfs_super.c
@@ -0,0 +1,1766 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_alloc.h"
+#include "xfs_quota.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_bmap.h"
+#include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_itable.h"
+#include "xfs_fsops.h"
+#include "xfs_attr.h"
+#include "xfs_buf_item.h"
+#include "xfs_utils.h"
+#include "xfs_vnodeops.h"
+#include "xfs_log_priv.h"
+#include "xfs_trans_priv.h"
+#include "xfs_filestream.h"
+#include "xfs_da_btree.h"
+#include "xfs_extfree_item.h"
+#include "xfs_mru_cache.h"
+#include "xfs_inode_item.h"
+#include "xfs_sync.h"
+#include "xfs_trace.h"
+
+#include <linux/namei.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/mount.h>
+#include <linux/mempool.h>
+#include <linux/writeback.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/parser.h>
+
+static const struct super_operations xfs_super_operations;
+static kmem_zone_t *xfs_ioend_zone;
+mempool_t *xfs_ioend_pool;
+
+#define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
+#define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
+#define MNTOPT_LOGDEV	"logdev"	/* log device */
+#define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
+#define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
+#define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
+#define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
+#define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
+#define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
+#define MNTOPT_SWIDTH	"swidth"	/* data volume stripe width */
+#define MNTOPT_NOUUID	"nouuid"	/* ignore filesystem UUID */
+#define MNTOPT_MTPT	"mtpt"		/* filesystem mount point */
+#define MNTOPT_GRPID	"grpid"		/* group-ID from parent directory */
+#define MNTOPT_NOGRPID	"nogrpid"	/* group-ID from current process */
+#define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
+#define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
+#define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
+#define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
+#define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
+					 * unwritten extent conversion */
+#define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
+#define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
+#define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
+#define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
+#define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
+#define MNTOPT_NOLARGEIO   "nolargeio"	/* do not report large I/O sizes
+					 * in stat(). */
+#define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
+#define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
+#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
+#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
+#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
+#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
+#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
+#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
+#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
+#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
+#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
+#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
+#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
+#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
+#define MNTOPT_DELAYLOG    "delaylog"	/* Delayed logging enabled */
+#define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
+#define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
+#define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
+
+/*
+ * Table driven mount option parser.
+ *
+ * Currently only used for remount, but it will be used for mount
+ * in the future, too.
+ */
+enum {
+	Opt_barrier, Opt_nobarrier, Opt_err
+};
+
+static const match_table_t tokens = {
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
+	{Opt_err, NULL}
+};
+
+
+STATIC unsigned long
+suffix_strtoul(char *s, char **endp, unsigned int base)
+{
+	int	last, shift_left_factor = 0;
+	char	*value = s;
+
+	last = strlen(value) - 1;
+	if (value[last] == 'K' || value[last] == 'k') {
+		shift_left_factor = 10;
+		value[last] = '\0';
+	}
+	if (value[last] == 'M' || value[last] == 'm') {
+		shift_left_factor = 20;
+		value[last] = '\0';
+	}
+	if (value[last] == 'G' || value[last] == 'g') {
+		shift_left_factor = 30;
+		value[last] = '\0';
+	}
+
+	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
+}
+
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock has _not_ yet been read in.
+ *
+ * Note that this function leaks the various device name allocations on
+ * failure.  The caller takes care of them.
+ */
+STATIC int
+xfs_parseargs(
+	struct xfs_mount	*mp,
+	char			*options)
+{
+	struct super_block	*sb = mp->m_super;
+	char			*this_char, *value, *eov;
+	int			dsunit = 0;
+	int			dswidth = 0;
+	int			iosize = 0;
+	__uint8_t		iosizelog = 0;
+
+	/*
+	 * set up the mount name first so all the errors will refer to the
+	 * correct device.
+	 */
+	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
+	if (!mp->m_fsname)
+		return ENOMEM;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (sb->s_flags & MS_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (sb->s_flags & MS_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (sb->s_flags & MS_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_BARRIER;
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	mp->m_flags |= XFS_MOUNT_DELAYLOG;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	if (!options)
+		goto done;
+
+	while ((this_char = strsep(&options, ",")) != NULL) {
+		if (!*this_char)
+			continue;
+		if ((value = strchr(this_char, '=')) != NULL)
+			*value++ = 0;
+
+		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_logbufs = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_logname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+			if (!mp->m_logname)
+				return ENOMEM;
+		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
+			xfs_warn(mp, "%s option not allowed on this system",
+				this_char);
+			return EINVAL;
+		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+			if (!mp->m_rtname)
+				return ENOMEM;
+		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			iosize = simple_strtoul(value, &eov, 10);
+			iosizelog = ffs(iosize) - 1;
+		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			iosize = suffix_strtoul(value, &eov, 10);
+			iosizelog = ffs(iosize) - 1;
+		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
+			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
+			mp->m_flags |= XFS_MOUNT_GRPID;
+		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
+			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
+			mp->m_flags &= ~XFS_MOUNT_GRPID;
+		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
+			mp->m_flags |= XFS_MOUNT_WSYNC;
+		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
+			mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
+			mp->m_flags |= XFS_MOUNT_NOALIGN;
+		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
+			mp->m_flags |= XFS_MOUNT_SWALLOC;
+		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			dsunit = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
+			if (!value || !*value) {
+				xfs_warn(mp, "%s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
+			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+#if !XFS_BIG_INUMS
+			xfs_warn(mp, "%s option not allowed on this system",
+				this_char);
+			return EINVAL;
+#endif
+		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
+			mp->m_flags |= XFS_MOUNT_NOUUID;
+		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
+			mp->m_flags |= XFS_MOUNT_BARRIER;
+		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
+			mp->m_flags &= ~XFS_MOUNT_BARRIER;
+		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
+			mp->m_flags |= XFS_MOUNT_IKEEP;
+		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
+			mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
+			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
+		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
+			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
+			mp->m_flags |= XFS_MOUNT_ATTR2;
+		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
+			mp->m_flags &= ~XFS_MOUNT_ATTR2;
+			mp->m_flags |= XFS_MOUNT_NOATTR2;
+		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
+			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
+			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
+		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
+			   !strcmp(this_char, MNTOPT_UQUOTA) ||
+			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
+			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+					 XFS_UQUOTA_ENFD);
+		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
+			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
+			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
+			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
+			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+					 XFS_OQUOTA_ENFD);
+		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
+			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
+		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
+			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
+			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+					 XFS_OQUOTA_ENFD);
+		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
+			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
+		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
+			mp->m_flags |= XFS_MOUNT_DELAYLOG;
+		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
+			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
+		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+			mp->m_flags |= XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, "ihashsize")) {
+			xfs_warn(mp,
+	"ihashsize no longer used, option is deprecated.");
+		} else if (!strcmp(this_char, "osyncisdsync")) {
+			xfs_warn(mp,
+	"osyncisdsync has no effect, option is deprecated.");
+		} else if (!strcmp(this_char, "osyncisosync")) {
+			xfs_warn(mp,
+	"osyncisosync has no effect, option is deprecated.");
+		} else if (!strcmp(this_char, "irixsgid")) {
+			xfs_warn(mp,
+	"irixsgid is now a sysctl(2) variable, option is deprecated.");
+		} else {
+			xfs_warn(mp, "unknown mount option [%s].", this_char);
+			return EINVAL;
+		}
+	}
+
+	/*
+	 * no recovery flag requires a read-only mount
+	 */
+	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_warn(mp, "no-recovery mounts must be read-only.");
+		return EINVAL;
+	}
+
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+		xfs_warn(mp,
+	"sunit and swidth options incompatible with the noalign option");
+		return EINVAL;
+	}
+
+	if ((mp->m_flags & XFS_MOUNT_DISCARD) &&
+	    !(mp->m_flags & XFS_MOUNT_DELAYLOG)) {
+		xfs_warn(mp,
+	"the discard option is incompatible with the nodelaylog option");
+		return EINVAL;
+	}
+
+#ifndef CONFIG_XFS_QUOTA
+	if (XFS_IS_QUOTA_RUNNING(mp)) {
+		xfs_warn(mp, "quota support not available in this kernel.");
+		return EINVAL;
+	}
+#endif
+
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
+		xfs_warn(mp, "cannot mount with both project and group quota");
+		return EINVAL;
+	}
+
+	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+		xfs_warn(mp, "sunit and swidth must be specified together");
+		return EINVAL;
+	}
+
+	if (dsunit && (dswidth % dsunit != 0)) {
+		xfs_warn(mp,
+	"stripe width (%d) must be a multiple of the stripe unit (%d)",
+			dswidth, dsunit);
+		return EINVAL;
+	}
+
+done:
+	if (!(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+		/*
+		 * At this point the superblock has not been read
+		 * in, therefore we do not know the block size.
+		 * Before the mount call ends we will convert
+		 * these to FSBs.
+		 */
+		if (dsunit) {
+			mp->m_dalign = dsunit;
+			mp->m_flags |= XFS_MOUNT_RETERR;
+		}
+
+		if (dswidth)
+			mp->m_swidth = dswidth;
+	}
+
+	if (mp->m_logbufs != -1 &&
+	    mp->m_logbufs != 0 &&
+	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
+	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
+		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
+			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
+		return XFS_ERROR(EINVAL);
+	}
+	if (mp->m_logbsize != -1 &&
+	    mp->m_logbsize !=  0 &&
+	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
+	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(mp->m_logbsize))) {
+		xfs_warn(mp,
+			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+			mp->m_logbsize);
+		return XFS_ERROR(EINVAL);
+	}
+
+	if (iosizelog) {
+		if (iosizelog > XFS_MAX_IO_LOG ||
+		    iosizelog < XFS_MIN_IO_LOG) {
+			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
+				iosizelog, XFS_MIN_IO_LOG,
+				XFS_MAX_IO_LOG);
+			return XFS_ERROR(EINVAL);
+		}
+
+		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+		mp->m_readio_log = iosizelog;
+		mp->m_writeio_log = iosizelog;
+	}
+
+	return 0;
+}
+
+struct proc_xfs_info {
+	int	flag;
+	char	*str;
+};
+
+STATIC int
+xfs_showargs(
+	struct xfs_mount	*mp,
+	struct seq_file		*m)
+{
+	static struct proc_xfs_info xfs_info_set[] = {
+		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
+		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
+		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
+		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
+		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
+		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
+		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
+		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
+		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
+		{ 0, NULL }
+	};
+	static struct proc_xfs_info xfs_info_unset[] = {
+		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
+		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
+		{ 0, NULL }
+	};
+	struct proc_xfs_info	*xfs_infop;
+
+	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
+		if (mp->m_flags & xfs_infop->flag)
+			seq_puts(m, xfs_infop->str);
+	}
+	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
+		if (!(mp->m_flags & xfs_infop->flag))
+			seq_puts(m, xfs_infop->str);
+	}
+
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
+				(int)(1 << mp->m_writeio_log) >> 10);
+
+	if (mp->m_logbufs > 0)
+		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
+	if (mp->m_logbsize > 0)
+		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
+
+	if (mp->m_logname)
+		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
+	if (mp->m_rtname)
+		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
+
+	if (mp->m_dalign > 0)
+		seq_printf(m, "," MNTOPT_SUNIT "=%d",
+				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
+	if (mp->m_swidth > 0)
+		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
+				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
+
+	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_USRQUOTA);
+	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_UQUOTANOENF);
+
+	/* Either project or group quotas can be active, not both */
+
+	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_PRJQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_PQUOTANOENF);
+	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_GRPQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_GQUOTANOENF);
+	}
+
+	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
+		seq_puts(m, "," MNTOPT_NOQUOTA);
+
+	return 0;
+}
+__uint64_t
+xfs_max_file_offset(
+	unsigned int		blockshift)
+{
+	unsigned int		pagefactor = 1;
+	unsigned int		bitshift = BITS_PER_LONG - 1;
+
+	/* Figure out maximum filesize, on Linux this can depend on
+	 * the filesystem blocksize (on 32 bit platforms).
+	 * __block_write_begin does this in an [unsigned] long...
+	 *      page->index << (PAGE_CACHE_SHIFT - bbits)
+	 * So, for page sized blocks (4K on 32 bit platforms),
+	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
+	 *      (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
+	 * but for smaller blocksizes it is less (bbits = log2 bsize).
+	 * Note1: get_block_t takes a long (implicit cast from above)
+	 * Note2: The Large Block Device (LBD and HAVE_SECTOR_T) patch
+	 * can optionally convert the [unsigned] long from above into
+	 * an [unsigned] long long.
+	 */
+
+#if BITS_PER_LONG == 32
+# if defined(CONFIG_LBDAF)
+	ASSERT(sizeof(sector_t) == 8);
+	pagefactor = PAGE_CACHE_SIZE;
+	bitshift = BITS_PER_LONG;
+# else
+	pagefactor = PAGE_CACHE_SIZE >> (PAGE_CACHE_SHIFT - blockshift);
+# endif
+#endif
+
+	return (((__uint64_t)pagefactor) << bitshift) - 1;
+}
+
+STATIC int
+xfs_blkdev_get(
+	xfs_mount_t		*mp,
+	const char		*name,
+	struct block_device	**bdevp)
+{
+	int			error = 0;
+
+	*bdevp = blkdev_get_by_path(name, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				    mp);
+	if (IS_ERR(*bdevp)) {
+		error = PTR_ERR(*bdevp);
+		xfs_warn(mp, "Invalid device [%s], error=%d\n", name, error);
+	}
+
+	return -error;
+}
+
+STATIC void
+xfs_blkdev_put(
+	struct block_device	*bdev)
+{
+	if (bdev)
+		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+}
+
+void
+xfs_blkdev_issue_flush(
+	xfs_buftarg_t		*buftarg)
+{
+	blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
+}
+
+STATIC void
+xfs_close_devices(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
+		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
+		xfs_free_buftarg(mp, mp->m_logdev_targp);
+		xfs_blkdev_put(logdev);
+	}
+	if (mp->m_rtdev_targp) {
+		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
+		xfs_free_buftarg(mp, mp->m_rtdev_targp);
+		xfs_blkdev_put(rtdev);
+	}
+	xfs_free_buftarg(mp, mp->m_ddev_targp);
+}
+
+/*
+ * The file system configurations are:
+ *	(1) device (partition) with data and internal log
+ *	(2) logical volume with data and log subvolumes.
+ *	(3) logical volume with data, log, and realtime subvolumes.
+ *
+ * We only have to handle opening the log and realtime volumes here if
+ * they are present.  The data subvolume has already been opened by
+ * get_sb_bdev() and is stored in sb->s_bdev.
+ */
+STATIC int
+xfs_open_devices(
+	struct xfs_mount	*mp)
+{
+	struct block_device	*ddev = mp->m_super->s_bdev;
+	struct block_device	*logdev = NULL, *rtdev = NULL;
+	int			error;
+
+	/*
+	 * Open real time and log devices - order is important.
+	 */
+	if (mp->m_logname) {
+		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
+		if (error)
+			goto out;
+	}
+
+	if (mp->m_rtname) {
+		error = xfs_blkdev_get(mp, mp->m_rtname, &rtdev);
+		if (error)
+			goto out_close_logdev;
+
+		if (rtdev == ddev || rtdev == logdev) {
+			xfs_warn(mp,
+	"Cannot mount filesystem with identical rtdev and ddev/logdev.");
+			error = EINVAL;
+			goto out_close_rtdev;
+		}
+	}
+
+	/*
+	 * Setup xfs_mount buffer target pointers
+	 */
+	error = ENOMEM;
+	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, 0, mp->m_fsname);
+	if (!mp->m_ddev_targp)
+		goto out_close_rtdev;
+
+	if (rtdev) {
+		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, 1,
+							mp->m_fsname);
+		if (!mp->m_rtdev_targp)
+			goto out_free_ddev_targ;
+	}
+
+	if (logdev && logdev != ddev) {
+		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, 1,
+							mp->m_fsname);
+		if (!mp->m_logdev_targp)
+			goto out_free_rtdev_targ;
+	} else {
+		mp->m_logdev_targp = mp->m_ddev_targp;
+	}
+
+	return 0;
+
+ out_free_rtdev_targ:
+	if (mp->m_rtdev_targp)
+		xfs_free_buftarg(mp, mp->m_rtdev_targp);
+ out_free_ddev_targ:
+	xfs_free_buftarg(mp, mp->m_ddev_targp);
+ out_close_rtdev:
+	if (rtdev)
+		xfs_blkdev_put(rtdev);
+ out_close_logdev:
+	if (logdev && logdev != ddev)
+		xfs_blkdev_put(logdev);
+ out:
+	return error;
+}
+
+/*
+ * Setup xfs_mount buffer target pointers based on superblock
+ */
+STATIC int
+xfs_setup_devices(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
+				    mp->m_sb.sb_sectsize);
+	if (error)
+		return error;
+
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
+		unsigned int	log_sector_size = BBSIZE;
+
+		if (xfs_sb_version_hassector(&mp->m_sb))
+			log_sector_size = mp->m_sb.sb_logsectsize;
+		error = xfs_setsize_buftarg(mp->m_logdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    log_sector_size);
+		if (error)
+			return error;
+	}
+	if (mp->m_rtdev_targp) {
+		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    mp->m_sb.sb_sectsize);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Catch misguided souls that try to use this interface on XFS */
+STATIC struct inode *
+xfs_fs_alloc_inode(
+	struct super_block	*sb)
+{
+	BUG();
+	return NULL;
+}
+
+/*
+ * Now that the generic code is guaranteed not to be accessing
+ * the linux inode, we can reclaim the inode.
+ */
+STATIC void
+xfs_fs_destroy_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	trace_xfs_destroy_inode(ip);
+
+	XFS_STATS_INC(vn_reclaim);
+
+	/* bad inode, get out here ASAP */
+	if (is_bad_inode(inode))
+		goto out_reclaim;
+
+	xfs_ioend_wait(ip);
+
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * We always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
+	 */
+out_reclaim:
+	xfs_inode_set_reclaim_tag(ip);
+}
+
+/*
+ * Slab object creation initialisation for the XFS inode.
+ * This covers only the idempotent fields in the XFS inode;
+ * all other fields need to be initialised on allocation
+ * from the slab. This avoids the need to repeatedly initialise
+ * fields in the xfs inode that left in the initialise state
+ * when freeing the inode.
+ */
+STATIC void
+xfs_fs_inode_init_once(
+	void			*inode)
+{
+	struct xfs_inode	*ip = inode;
+
+	memset(ip, 0, sizeof(struct xfs_inode));
+
+	/* vfs inode */
+	inode_init_once(VFS_I(ip));
+
+	/* xfs inode */
+	atomic_set(&ip->i_iocount, 0);
+	atomic_set(&ip->i_pincount, 0);
+	spin_lock_init(&ip->i_flags_lock);
+	init_waitqueue_head(&ip->i_ipin_wait);
+	/*
+	 * Because we want to use a counting completion, complete
+	 * the flush completion once to allow a single access to
+	 * the flush completion without blocking.
+	 */
+	init_completion(&ip->i_flush);
+	complete(&ip->i_flush);
+
+	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
+		     "xfsino", ip->i_ino);
+}
+
+/*
+ * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
+ * we catch unlogged VFS level updates to the inode.
+ *
+ * We need the barrier() to maintain correct ordering between unlogged
+ * updates and the transaction commit code that clears the i_update_core
+ * field. This requires all updates to be completed before marking the
+ * inode dirty.
+ */
+STATIC void
+xfs_fs_dirty_inode(
+	struct inode	*inode,
+	int		flags)
+{
+	barrier();
+	XFS_I(inode)->i_update_core = 1;
+}
+
+STATIC int
+xfs_log_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		/* we need to return with the lock hold shared */
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Note - it's possible that we might have pushed ourselves out of the
+	 * way during trans_reserve which would flush the inode.  But there's
+	 * no guarantee that the inode buffer has actually gone out yet (it's
+	 * delwri).  Plus the buffer could be pinned anyway if it's part of
+	 * an inode in another recent transaction.  So we play it safe and
+	 * fire off the transaction anyway.
+	 */
+	xfs_trans_ijoin(tp, ip);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp, 0);
+	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
+STATIC int
+xfs_fs_write_inode(
+	struct inode		*inode,
+	struct writeback_control *wbc)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = EAGAIN;
+
+	trace_xfs_write_inode(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	if (wbc->sync_mode == WB_SYNC_ALL) {
+		/*
+		 * Make sure the inode has made it it into the log.  Instead
+		 * of forcing it all the way to stable storage using a
+		 * synchronous transaction we let the log force inside the
+		 * ->sync_fs call do that for thus, which reduces the number
+		 * of synchronous log foces dramatically.
+		 */
+		xfs_ioend_wait(ip);
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		if (ip->i_update_core) {
+			error = xfs_log_inode(ip);
+			if (error)
+				goto out_unlock;
+		}
+	} else {
+		/*
+		 * We make this non-blocking if the inode is contended, return
+		 * EAGAIN to indicate to the caller that they did not succeed.
+		 * This prevents the flush path from blocking on inodes inside
+		 * another operation right now, they get caught later by
+		 * xfs_sync.
+		 */
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+			goto out;
+
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+			goto out_unlock;
+
+		/*
+		 * Now we have the flush lock and the inode is not pinned, we
+		 * can check if the inode is really clean as we know that
+		 * there are no pending transaction completions, it is not
+		 * waiting on the delayed write queue and there is no IO in
+		 * progress.
+		 */
+		if (xfs_inode_clean(ip)) {
+			xfs_ifunlock(ip);
+			error = 0;
+			goto out_unlock;
+		}
+		error = xfs_iflush(ip, SYNC_TRYLOCK);
+	}
+
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+ out:
+	/*
+	 * if we failed to write out the inode then mark
+	 * it dirty again so we'll try again later.
+	 */
+	if (error)
+		xfs_mark_inode_dirty_sync(ip);
+	return -error;
+}
+
+STATIC void
+xfs_fs_evict_inode(
+	struct inode		*inode)
+{
+	xfs_inode_t		*ip = XFS_I(inode);
+
+	trace_xfs_evict_inode(ip);
+
+	truncate_inode_pages(&inode->i_data, 0);
+	end_writeback(inode);
+	XFS_STATS_INC(vn_rele);
+	XFS_STATS_INC(vn_remove);
+	XFS_STATS_DEC(vn_active);
+
+	/*
+	 * The iolock is used by the file system to coordinate reads,
+	 * writes, and block truncates.  Up to this point the lock
+	 * protected concurrent accesses by users of the inode.  But
+	 * from here forward we're doing some final processing of the
+	 * inode because we're done with it, and although we reuse the
+	 * iolock for protection it is really a distinct lock class
+	 * (in the lockdep sense) from before.  To keep lockdep happy
+	 * (and basically indicate what we are doing), we explicitly
+	 * re-init the iolock here.
+	 */
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+	lockdep_set_class_and_name(&ip->i_iolock.mr_lock,
+			&xfs_iolock_reclaimable, "xfs_iolock_reclaimable");
+
+	xfs_inactive(ip);
+}
+
+STATIC void
+xfs_free_fsname(
+	struct xfs_mount	*mp)
+{
+	kfree(mp->m_fsname);
+	kfree(mp->m_rtname);
+	kfree(mp->m_logname);
+}
+
+STATIC void
+xfs_fs_put_super(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	/*
+	 * Unregister the memory shrinker before we tear down the mount
+	 * structure so we don't have memory reclaim racing with us here.
+	 */
+	xfs_inode_shrinker_unregister(mp);
+	xfs_syncd_stop(mp);
+
+	/*
+	 * Blow away any referenced inode in the filestreams cache.
+	 * This can and will cause log traffic as inodes go inactive
+	 * here.
+	 */
+	xfs_filestream_unmount(mp);
+
+	XFS_bflush(mp->m_ddev_targp);
+
+	xfs_unmountfs(mp);
+	xfs_freesb(mp);
+	xfs_icsb_destroy_counters(mp);
+	xfs_close_devices(mp);
+	xfs_free_fsname(mp);
+	kfree(mp);
+}
+
+STATIC int
+xfs_fs_sync_fs(
+	struct super_block	*sb,
+	int			wait)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
+
+	/*
+	 * Not much we can do for the first async pass.  Writing out the
+	 * superblock would be counter-productive as we are going to redirty
+	 * when writing out other data and metadata (and writing out a single
+	 * block is quite fast anyway).
+	 *
+	 * Try to asynchronously kick off quota syncing at least.
+	 */
+	if (!wait) {
+		xfs_qm_sync(mp, SYNC_TRYLOCK);
+		return 0;
+	}
+
+	error = xfs_quiesce_data(mp);
+	if (error)
+		return -error;
+
+	if (laptop_mode) {
+		/*
+		 * The disk must be active because we're syncing.
+		 * We schedule xfssyncd now (now that the disk is
+		 * active) instead of later (when it might not be).
+		 */
+		flush_delayed_work_sync(&mp->m_sync_work);
+	}
+
+	return 0;
+}
+
+STATIC int
+xfs_fs_statfs(
+	struct dentry		*dentry,
+	struct kstatfs		*statp)
+{
+	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
+	xfs_sb_t		*sbp = &mp->m_sb;
+	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	__uint64_t		fakeinos, id;
+	xfs_extlen_t		lsize;
+	__int64_t		ffree;
+
+	statp->f_type = XFS_SB_MAGIC;
+	statp->f_namelen = MAXNAMELEN - 1;
+
+	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
+	statp->f_fsid.val[0] = (u32)id;
+	statp->f_fsid.val[1] = (u32)(id >> 32);
+
+	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+
+	spin_lock(&mp->m_sb_lock);
+	statp->f_bsize = sbp->sb_blocksize;
+	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
+	statp->f_blocks = sbp->sb_dblocks - lsize;
+	statp->f_bfree = statp->f_bavail =
+				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	fakeinos = statp->f_bfree << sbp->sb_inopblog;
+	statp->f_files =
+	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
+	if (mp->m_maxicount)
+		statp->f_files = min_t(typeof(statp->f_files),
+					statp->f_files,
+					mp->m_maxicount);
+
+	/* make sure statp->f_ffree does not underflow */
+	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+	statp->f_ffree = max_t(__int64_t, ffree, 0);
+
+	spin_unlock(&mp->m_sb_lock);
+
+	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
+			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		xfs_qm_statvfs(ip, statp);
+	return 0;
+}
+
+STATIC void
+xfs_save_resvblks(struct xfs_mount *mp)
+{
+	__uint64_t resblks = 0;
+
+	mp->m_resblks_save = mp->m_resblks;
+	xfs_reserve_blocks(mp, &resblks, NULL);
+}
+
+STATIC void
+xfs_restore_resvblks(struct xfs_mount *mp)
+{
+	__uint64_t resblks;
+
+	if (mp->m_resblks_save) {
+		resblks = mp->m_resblks_save;
+		mp->m_resblks_save = 0;
+	} else
+		resblks = xfs_default_resblks(mp);
+
+	xfs_reserve_blocks(mp, &resblks, NULL);
+}
+
+STATIC int
+xfs_fs_remount(
+	struct super_block	*sb,
+	int			*flags,
+	char			*options)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	substring_t		args[MAX_OPT_ARGS];
+	char			*p;
+	int			error;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_barrier:
+			mp->m_flags |= XFS_MOUNT_BARRIER;
+			break;
+		case Opt_nobarrier:
+			mp->m_flags &= ~XFS_MOUNT_BARRIER;
+			break;
+		default:
+			/*
+			 * Logically we would return an error here to prevent
+			 * users from believing they might have changed
+			 * mount options using remount which can't be changed.
+			 *
+			 * But unfortunately mount(8) adds all options from
+			 * mtab and fstab to the mount arguments in some cases
+			 * so we can't blindly reject options, but have to
+			 * check for each specified option if it actually
+			 * differs from the currently set option and only
+			 * reject it if that's the case.
+			 *
+			 * Until that is implemented we return success for
+			 * every remount request, and silently ignore all
+			 * options that we can't actually change.
+			 */
+#if 0
+			xfs_info(mp,
+		"mount option \"%s\" not supported for remount\n", p);
+			return -EINVAL;
+#else
+			break;
+#endif
+		}
+	}
+
+	/* ro -> rw */
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
+		mp->m_flags &= ~XFS_MOUNT_RDONLY;
+
+		/*
+		 * If this is the first remount to writeable state we
+		 * might have some superblock changes to update.
+		 */
+		if (mp->m_update_flags) {
+			error = xfs_mount_log_sb(mp, mp->m_update_flags);
+			if (error) {
+				xfs_warn(mp, "failed to write sb changes");
+				return error;
+			}
+			mp->m_update_flags = 0;
+		}
+
+		/*
+		 * Fill out the reserve pool if it is empty. Use the stashed
+		 * value if it is non-zero, otherwise go with the default.
+		 */
+		xfs_restore_resvblks(mp);
+	}
+
+	/* rw -> ro */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
+		/*
+		 * After we have synced the data but before we sync the
+		 * metadata, we need to free up the reserve block pool so that
+		 * the used block count in the superblock on disk is correct at
+		 * the end of the remount. Stash the current reserve pool size
+		 * so that if we get remounted rw, we can return it to the same
+		 * size.
+		 */
+
+		xfs_quiesce_data(mp);
+		xfs_save_resvblks(mp);
+		xfs_quiesce_attr(mp);
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	}
+
+	return 0;
+}
+
+/*
+ * Second stage of a freeze. The data is already frozen so we only
+ * need to take care of the metadata. Once that's done write a dummy
+ * record to dirty the log in case of a crash while frozen.
+ */
+STATIC int
+xfs_fs_freeze(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	xfs_save_resvblks(mp);
+	xfs_quiesce_attr(mp);
+	return -xfs_fs_log_dummy(mp);
+}
+
+STATIC int
+xfs_fs_unfreeze(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	xfs_restore_resvblks(mp);
+	return 0;
+}
+
+STATIC int
+xfs_fs_show_options(
+	struct seq_file		*m,
+	struct vfsmount		*mnt)
+{
+	return -xfs_showargs(XFS_M(mnt->mnt_sb), m);
+}
+
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock _has_ now been read in.
+ */
+STATIC int
+xfs_finish_flags(
+	struct xfs_mount	*mp)
+{
+	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
+
+	/* Fail a mount where the logbuf is smaller than the log stripe */
+	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+		if (mp->m_logbsize <= 0 &&
+		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
+			mp->m_logbsize = mp->m_sb.sb_logsunit;
+		} else if (mp->m_logbsize > 0 &&
+			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
+			xfs_warn(mp,
+		"logbuf size must be greater than or equal to log stripe size");
+			return XFS_ERROR(EINVAL);
+		}
+	} else {
+		/* Fail a mount if the logbuf is larger than 32K */
+		if (mp->m_logbsize > XLOG_BIG_RECORD_BSIZE) {
+			xfs_warn(mp,
+		"logbuf size for version 1 logs must be 16K or 32K");
+			return XFS_ERROR(EINVAL);
+		}
+	}
+
+	/*
+	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
+	 * told by noattr2 to turn it off
+	 */
+	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+
+	/*
+	 * prohibit r/w mounts of read-only filesystems
+	 */
+	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
+		xfs_warn(mp,
+			"cannot mount a read-only filesystem as read-write");
+		return XFS_ERROR(EROFS);
+	}
+
+	return 0;
+}
+
+STATIC int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct inode		*root;
+	struct xfs_mount	*mp = NULL;
+	int			flags = 0, error = ENOMEM;
+
+	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
+	if (!mp)
+		goto out;
+
+	spin_lock_init(&mp->m_sb_lock);
+	mutex_init(&mp->m_growlock);
+	atomic_set(&mp->m_active_trans, 0);
+
+	mp->m_super = sb;
+	sb->s_fs_info = mp;
+
+	error = xfs_parseargs(mp, (char *)data);
+	if (error)
+		goto out_free_fsname;
+
+	sb_min_blocksize(sb, BBSIZE);
+	sb->s_xattr = xfs_xattr_handlers;
+	sb->s_export_op = &xfs_export_operations;
+#ifdef CONFIG_XFS_QUOTA
+	sb->s_qcop = &xfs_quotactl_operations;
+#endif
+	sb->s_op = &xfs_super_operations;
+
+	if (silent)
+		flags |= XFS_MFSI_QUIET;
+
+	error = xfs_open_devices(mp);
+	if (error)
+		goto out_free_fsname;
+
+	error = xfs_icsb_init_counters(mp);
+	if (error)
+		goto out_close_devices;
+
+	error = xfs_readsb(mp, flags);
+	if (error)
+		goto out_destroy_counters;
+
+	error = xfs_finish_flags(mp);
+	if (error)
+		goto out_free_sb;
+
+	error = xfs_setup_devices(mp);
+	if (error)
+		goto out_free_sb;
+
+	error = xfs_filestream_mount(mp);
+	if (error)
+		goto out_free_sb;
+
+	/*
+	 * we must configure the block size in the superblock before we run the
+	 * full mount process as the mount process can lookup and cache inodes.
+	 * For the same reason we must also initialise the syncd and register
+	 * the inode cache shrinker so that inodes can be reclaimed during
+	 * operations like a quotacheck that iterate all inodes in the
+	 * filesystem.
+	 */
+	sb->s_magic = XFS_SB_MAGIC;
+	sb->s_blocksize = mp->m_sb.sb_blocksize;
+	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
+	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_time_gran = 1;
+	set_posix_acl_flag(sb);
+
+	xfs_inode_shrinker_register(mp);
+
+	error = xfs_mountfs(mp);
+	if (error)
+		goto out_filestream_unmount;
+
+	error = xfs_syncd_init(mp);
+	if (error)
+		goto out_unmount;
+
+	root = igrab(VFS_I(mp->m_rootip));
+	if (!root) {
+		error = ENOENT;
+		goto out_syncd_stop;
+	}
+	if (is_bad_inode(root)) {
+		error = EINVAL;
+		goto out_syncd_stop;
+	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		error = ENOMEM;
+		goto out_iput;
+	}
+
+	return 0;
+
+ out_filestream_unmount:
+	xfs_inode_shrinker_unregister(mp);
+	xfs_filestream_unmount(mp);
+ out_free_sb:
+	xfs_freesb(mp);
+ out_destroy_counters:
+	xfs_icsb_destroy_counters(mp);
+ out_close_devices:
+	xfs_close_devices(mp);
+ out_free_fsname:
+	xfs_free_fsname(mp);
+	kfree(mp);
+ out:
+	return -error;
+
+ out_iput:
+	iput(root);
+ out_syncd_stop:
+	xfs_syncd_stop(mp);
+ out_unmount:
+	xfs_inode_shrinker_unregister(mp);
+
+	/*
+	 * Blow away any referenced inode in the filestreams cache.
+	 * This can and will cause log traffic as inodes go inactive
+	 * here.
+	 */
+	xfs_filestream_unmount(mp);
+
+	XFS_bflush(mp->m_ddev_targp);
+
+	xfs_unmountfs(mp);
+	goto out_free_sb;
+}
+
+STATIC struct dentry *
+xfs_fs_mount(
+	struct file_system_type	*fs_type,
+	int			flags,
+	const char		*dev_name,
+	void			*data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
+}
+
+static const struct super_operations xfs_super_operations = {
+	.alloc_inode		= xfs_fs_alloc_inode,
+	.destroy_inode		= xfs_fs_destroy_inode,
+	.dirty_inode		= xfs_fs_dirty_inode,
+	.write_inode		= xfs_fs_write_inode,
+	.evict_inode		= xfs_fs_evict_inode,
+	.put_super		= xfs_fs_put_super,
+	.sync_fs		= xfs_fs_sync_fs,
+	.freeze_fs		= xfs_fs_freeze,
+	.unfreeze_fs		= xfs_fs_unfreeze,
+	.statfs			= xfs_fs_statfs,
+	.remount_fs		= xfs_fs_remount,
+	.show_options		= xfs_fs_show_options,
+};
+
+static struct file_system_type xfs_fs_type = {
+	.owner			= THIS_MODULE,
+	.name			= "xfs",
+	.mount			= xfs_fs_mount,
+	.kill_sb		= kill_block_super,
+	.fs_flags		= FS_REQUIRES_DEV,
+};
+
+STATIC int __init
+xfs_init_zones(void)
+{
+
+	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
+	if (!xfs_ioend_zone)
+		goto out;
+
+	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
+						  xfs_ioend_zone);
+	if (!xfs_ioend_pool)
+		goto out_destroy_ioend_zone;
+
+	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
+						"xfs_log_ticket");
+	if (!xfs_log_ticket_zone)
+		goto out_destroy_ioend_pool;
+
+	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
+						"xfs_bmap_free_item");
+	if (!xfs_bmap_free_item_zone)
+		goto out_destroy_log_ticket_zone;
+
+	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
+						"xfs_btree_cur");
+	if (!xfs_btree_cur_zone)
+		goto out_destroy_bmap_free_item_zone;
+
+	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
+						"xfs_da_state");
+	if (!xfs_da_state_zone)
+		goto out_destroy_btree_cur_zone;
+
+	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
+	if (!xfs_dabuf_zone)
+		goto out_destroy_da_state_zone;
+
+	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
+	if (!xfs_ifork_zone)
+		goto out_destroy_dabuf_zone;
+
+	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
+	if (!xfs_trans_zone)
+		goto out_destroy_ifork_zone;
+
+	xfs_log_item_desc_zone =
+		kmem_zone_init(sizeof(struct xfs_log_item_desc),
+			       "xfs_log_item_desc");
+	if (!xfs_log_item_desc_zone)
+		goto out_destroy_trans_zone;
+
+	/*
+	 * The size of the zone allocated buf log item is the maximum
+	 * size possible under XFS.  This wastes a little bit of memory,
+	 * but it is much faster.
+	 */
+	xfs_buf_item_zone = kmem_zone_init((sizeof(xfs_buf_log_item_t) +
+				(((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) /
+				  NBWORD) * sizeof(int))), "xfs_buf_item");
+	if (!xfs_buf_item_zone)
+		goto out_destroy_log_item_desc_zone;
+
+	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
+			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
+				 sizeof(xfs_extent_t))), "xfs_efd_item");
+	if (!xfs_efd_zone)
+		goto out_destroy_buf_item_zone;
+
+	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
+			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
+				sizeof(xfs_extent_t))), "xfs_efi_item");
+	if (!xfs_efi_zone)
+		goto out_destroy_efd_zone;
+
+	xfs_inode_zone =
+		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
+			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
+			xfs_fs_inode_init_once);
+	if (!xfs_inode_zone)
+		goto out_destroy_efi_zone;
+
+	xfs_ili_zone =
+		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
+					KM_ZONE_SPREAD, NULL);
+	if (!xfs_ili_zone)
+		goto out_destroy_inode_zone;
+
+	return 0;
+
+ out_destroy_inode_zone:
+	kmem_zone_destroy(xfs_inode_zone);
+ out_destroy_efi_zone:
+	kmem_zone_destroy(xfs_efi_zone);
+ out_destroy_efd_zone:
+	kmem_zone_destroy(xfs_efd_zone);
+ out_destroy_buf_item_zone:
+	kmem_zone_destroy(xfs_buf_item_zone);
+ out_destroy_log_item_desc_zone:
+	kmem_zone_destroy(xfs_log_item_desc_zone);
+ out_destroy_trans_zone:
+	kmem_zone_destroy(xfs_trans_zone);
+ out_destroy_ifork_zone:
+	kmem_zone_destroy(xfs_ifork_zone);
+ out_destroy_dabuf_zone:
+	kmem_zone_destroy(xfs_dabuf_zone);
+ out_destroy_da_state_zone:
+	kmem_zone_destroy(xfs_da_state_zone);
+ out_destroy_btree_cur_zone:
+	kmem_zone_destroy(xfs_btree_cur_zone);
+ out_destroy_bmap_free_item_zone:
+	kmem_zone_destroy(xfs_bmap_free_item_zone);
+ out_destroy_log_ticket_zone:
+	kmem_zone_destroy(xfs_log_ticket_zone);
+ out_destroy_ioend_pool:
+	mempool_destroy(xfs_ioend_pool);
+ out_destroy_ioend_zone:
+	kmem_zone_destroy(xfs_ioend_zone);
+ out:
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_destroy_zones(void)
+{
+	kmem_zone_destroy(xfs_ili_zone);
+	kmem_zone_destroy(xfs_inode_zone);
+	kmem_zone_destroy(xfs_efi_zone);
+	kmem_zone_destroy(xfs_efd_zone);
+	kmem_zone_destroy(xfs_buf_item_zone);
+	kmem_zone_destroy(xfs_log_item_desc_zone);
+	kmem_zone_destroy(xfs_trans_zone);
+	kmem_zone_destroy(xfs_ifork_zone);
+	kmem_zone_destroy(xfs_dabuf_zone);
+	kmem_zone_destroy(xfs_da_state_zone);
+	kmem_zone_destroy(xfs_btree_cur_zone);
+	kmem_zone_destroy(xfs_bmap_free_item_zone);
+	kmem_zone_destroy(xfs_log_ticket_zone);
+	mempool_destroy(xfs_ioend_pool);
+	kmem_zone_destroy(xfs_ioend_zone);
+
+}
+
+STATIC int __init
+xfs_init_workqueues(void)
+{
+	/*
+	 * max_active is set to 8 to give enough concurency to allow
+	 * multiple work operations on each CPU to run. This allows multiple
+	 * filesystems to be running sync work concurrently, and scales with
+	 * the number of CPUs in the system.
+	 */
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
+	if (!xfs_syncd_wq)
+		goto out;
+
+	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
+	if (!xfs_ail_wq)
+		goto out_destroy_syncd;
+
+	return 0;
+
+out_destroy_syncd:
+	destroy_workqueue(xfs_syncd_wq);
+out:
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_destroy_workqueues(void)
+{
+	destroy_workqueue(xfs_ail_wq);
+	destroy_workqueue(xfs_syncd_wq);
+}
+
+STATIC int __init
+init_xfs_fs(void)
+{
+	int			error;
+
+	printk(KERN_INFO XFS_VERSION_STRING " with "
+			 XFS_BUILD_OPTIONS " enabled\n");
+
+	xfs_ioend_init();
+	xfs_dir_startup();
+
+	error = xfs_init_zones();
+	if (error)
+		goto out;
+
+	error = xfs_init_workqueues();
+	if (error)
+		goto out_destroy_zones;
+
+	error = xfs_mru_cache_init();
+	if (error)
+		goto out_destroy_wq;
+
+	error = xfs_filestream_init();
+	if (error)
+		goto out_mru_cache_uninit;
+
+	error = xfs_buf_init();
+	if (error)
+		goto out_filestream_uninit;
+
+	error = xfs_init_procfs();
+	if (error)
+		goto out_buf_terminate;
+
+	error = xfs_sysctl_register();
+	if (error)
+		goto out_cleanup_procfs;
+
+	vfs_initquota();
+
+	error = register_filesystem(&xfs_fs_type);
+	if (error)
+		goto out_sysctl_unregister;
+	return 0;
+
+ out_sysctl_unregister:
+	xfs_sysctl_unregister();
+ out_cleanup_procfs:
+	xfs_cleanup_procfs();
+ out_buf_terminate:
+	xfs_buf_terminate();
+ out_filestream_uninit:
+	xfs_filestream_uninit();
+ out_mru_cache_uninit:
+	xfs_mru_cache_uninit();
+ out_destroy_wq:
+	xfs_destroy_workqueues();
+ out_destroy_zones:
+	xfs_destroy_zones();
+ out:
+	return error;
+}
+
+STATIC void __exit
+exit_xfs_fs(void)
+{
+	vfs_exitquota();
+	unregister_filesystem(&xfs_fs_type);
+	xfs_sysctl_unregister();
+	xfs_cleanup_procfs();
+	xfs_buf_terminate();
+	xfs_filestream_uninit();
+	xfs_mru_cache_uninit();
+	xfs_destroy_workqueues();
+	xfs_destroy_zones();
+}
+
+module_init(init_xfs_fs);
+module_exit(exit_xfs_fs);
+
+MODULE_AUTHOR("Silicon Graphics, Inc.");
+MODULE_DESCRIPTION(XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled");
+MODULE_LICENSE("GPL");
diff --git a/fs/xfs/linux/xfs_super.h b/fs/xfs/linux/xfs_super.h
new file mode 100644
index 0000000..50a3266
--- /dev/null
+++ b/fs/xfs/linux/xfs_super.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SUPER_H__
+#define __XFS_SUPER_H__
+
+#include <linux/exportfs.h>
+
+#ifdef CONFIG_XFS_QUOTA
+extern void xfs_qm_init(void);
+extern void xfs_qm_exit(void);
+# define vfs_initquota()	xfs_qm_init()
+# define vfs_exitquota()	xfs_qm_exit()
+#else
+# define vfs_initquota()	do { } while (0)
+# define vfs_exitquota()	do { } while (0)
+#endif
+
+#ifdef CONFIG_XFS_POSIX_ACL
+# define XFS_ACL_STRING		"ACLs, "
+# define set_posix_acl_flag(sb)	((sb)->s_flags |= MS_POSIXACL)
+#else
+# define XFS_ACL_STRING
+# define set_posix_acl_flag(sb)	do { } while (0)
+#endif
+
+#define XFS_SECURITY_STRING	"security attributes, "
+
+#ifdef CONFIG_XFS_RT
+# define XFS_REALTIME_STRING	"realtime, "
+#else
+# define XFS_REALTIME_STRING
+#endif
+
+#if XFS_BIG_BLKNOS
+# if XFS_BIG_INUMS
+#  define XFS_BIGFS_STRING	"large block/inode numbers, "
+# else
+#  define XFS_BIGFS_STRING	"large block numbers, "
+# endif
+#else
+# define XFS_BIGFS_STRING
+#endif
+
+#ifdef DEBUG
+# define XFS_DBG_STRING		"debug"
+#else
+# define XFS_DBG_STRING		"no debug"
+#endif
+
+#define XFS_VERSION_STRING	"SGI XFS"
+#define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
+				XFS_SECURITY_STRING \
+				XFS_REALTIME_STRING \
+				XFS_BIGFS_STRING \
+				XFS_DBG_STRING /* DBG must be last */
+
+struct xfs_inode;
+struct xfs_mount;
+struct xfs_buftarg;
+struct block_device;
+
+extern __uint64_t xfs_max_file_offset(unsigned int);
+
+extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
+
+extern const struct export_operations xfs_export_operations;
+extern const struct xattr_handler *xfs_xattr_handlers[];
+extern const struct quotactl_ops xfs_quotactl_operations;
+
+#define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
+
+#endif	/* __XFS_SUPER_H__ */
diff --git a/fs/xfs/linux/xfs_sync.c b/fs/xfs/linux/xfs_sync.c
new file mode 100644
index 0000000..5cc158e
--- /dev/null
+++ b/fs/xfs/linux/xfs_sync.c
@@ -0,0 +1,1082 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_dinode.h"
+#include "xfs_error.h"
+#include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
+#include "xfs_inode_item.h"
+#include "xfs_quota.h"
+#include "xfs_trace.h"
+#include "xfs_fsops.h"
+
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
+struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
+
+/*
+ * The inode lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage. This is in the reclaim path, so we can't
+ * be too greedy.
+ */
+#define XFS_LOOKUP_BATCH	32
+
+STATIC int
+xfs_inode_ag_walk_grab(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	ASSERT(rcu_read_lock_held());
+
+	/*
+	 * check for stale RCU freed inode
+	 *
+	 * If the inode has been reallocated, it doesn't matter if it's not in
+	 * the AG we are walking - we are walking for writeback, so if it
+	 * passes all the "valid inode" checks and is dirty, then we'll write
+	 * it back anyway.  If it has been reallocated and still being
+	 * initialised, the XFS_INEW check below will catch it.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock_noent;
+	spin_unlock(&ip->i_flags_lock);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return EFSCORRUPTED;
+
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		return ENOENT;
+
+	if (is_bad_inode(inode)) {
+		IRELE(ip);
+		return ENOENT;
+	}
+
+	/* inode is valid */
+	return 0;
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return ENOENT;
+}
+
+STATIC int
+xfs_inode_ag_walk(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, int flags),
+	int			flags)
+{
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+	int			done;
+	int			nr_found;
+
+restart:
+	done = 0;
+	skipped = 0;
+	first_index = 0;
+	nr_found = 0;
+	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		int		error = 0;
+		int		i;
+
+		rcu_read_lock();
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH);
+		if (!nr_found) {
+			rcu_read_unlock();
+			break;
+		}
+
+		/*
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
+		 */
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (done || xfs_inode_ag_walk_grab(ip))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch
+			 * overflows into the next AG range which can occur if
+			 * we have inodes in the last block of the AG and we
+			 * are currently pointing to the last inode.
+			 *
+			 * Because we may see inodes that are from the wrong AG
+			 * due to RCU freeing and reallocation, only update the
+			 * index if it lies in this AG. It was a race that lead
+			 * us to see this inode, so another lookup from the
+			 * same index will not find it again.
+			 */
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+				continue;
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = 1;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		rcu_read_unlock();
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			error = execute(batch[i], pag, flags);
+			IRELE(batch[i]);
+			if (error == EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
+		}
+
+		/* bail out if the filesystem is corrupted.  */
+		if (error == EFSCORRUPTED)
+			break;
+
+	} while (nr_found && !done);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+	return last_error;
+}
+
+int
+xfs_inode_ag_iterator(
+	struct xfs_mount	*mp,
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, int flags),
+	int			flags)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_perag_get(mp, ag))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_inode_ag_walk(mp, pag, execute, flags);
+		xfs_perag_put(pag);
+		if (error) {
+			last_error = error;
+			if (error == EFSCORRUPTED)
+				break;
+		}
+	}
+	return XFS_ERROR(last_error);
+}
+
+STATIC int
+xfs_sync_inode_data(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct address_space *mapping = inode->i_mapping;
+	int			error = 0;
+
+	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		goto out_wait;
+
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+		if (flags & SYNC_TRYLOCK)
+			goto out_wait;
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
+
+	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
+				0 : XBF_ASYNC, FI_NONE);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+ out_wait:
+	if (flags & SYNC_WAIT)
+		xfs_ioend_wait(ip);
+	return error;
+}
+
+STATIC int
+xfs_sync_inode_attr(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_inode_clean(ip))
+		goto out_unlock;
+	if (!xfs_iflock_nowait(ip)) {
+		if (!(flags & SYNC_WAIT))
+			goto out_unlock;
+		xfs_iflock(ip);
+	}
+
+	if (xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
+		goto out_unlock;
+	}
+
+	error = xfs_iflush(ip, flags);
+
+	/*
+	 * We don't want to try again on non-blocking flushes that can't run
+	 * again immediately. If an inode really must be written, then that's
+	 * what the SYNC_WAIT flag is for.
+	 */
+	if (error == EAGAIN) {
+		ASSERT(!(flags & SYNC_WAIT));
+		error = 0;
+	}
+
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
+/*
+ * Write out pagecache data for the whole filesystem.
+ */
+STATIC int
+xfs_sync_data(
+	struct xfs_mount	*mp,
+	int			flags)
+{
+	int			error;
+
+	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
+
+	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
+	if (error)
+		return XFS_ERROR(error);
+
+	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
+	return 0;
+}
+
+/*
+ * Write out inode metadata (attributes) for the whole filesystem.
+ */
+STATIC int
+xfs_sync_attr(
+	struct xfs_mount	*mp,
+	int			flags)
+{
+	ASSERT((flags & ~SYNC_WAIT) == 0);
+
+	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags);
+}
+
+STATIC int
+xfs_sync_fsdata(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+
+	/*
+	 * If the buffer is pinned then push on the log so we won't get stuck
+	 * waiting in the write for someone, maybe ourselves, to flush the log.
+	 *
+	 * Even though we just pushed the log above, we did not have the
+	 * superblock buffer locked at that point so it can become pinned in
+	 * between there and here.
+	 */
+	bp = xfs_getsb(mp, 0);
+	if (XFS_BUF_ISPINNED(bp))
+		xfs_log_force(mp, 0);
+
+	return xfs_bwrite(mp, bp);
+}
+
+/*
+ * When remounting a filesystem read-only or freezing the filesystem, we have
+ * two phases to execute. This first phase is syncing the data before we
+ * quiesce the filesystem, and the second is flushing all the inodes out after
+ * we've waited for all the transactions created by the first phase to
+ * complete. The second phase ensures that the inodes are written to their
+ * location on disk rather than just existing in transactions in the log. This
+ * means after a quiesce there is no log replay required to write the inodes to
+ * disk (this is the main difference between a sync and a quiesce).
+ */
+/*
+ * First stage of freeze - no writers will make progress now we are here,
+ * so we flush delwri and delalloc buffers here, then wait for all I/O to
+ * complete.  Data is frozen at that point. Metadata is not frozen,
+ * transactions can still occur here so don't bother flushing the buftarg
+ * because it'll just get dirty again.
+ */
+int
+xfs_quiesce_data(
+	struct xfs_mount	*mp)
+{
+	int			error, error2 = 0;
+
+	xfs_qm_sync(mp, SYNC_TRYLOCK);
+	xfs_qm_sync(mp, SYNC_WAIT);
+
+	/* force out the newly dirtied log buffers */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/* write superblock and hoover up shutdown errors */
+	error = xfs_sync_fsdata(mp);
+
+	/* make sure all delwri buffers are written out */
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
+
+	/* mark the log as covered if needed */
+	if (xfs_log_need_covered(mp))
+		error2 = xfs_fs_log_dummy(mp);
+
+	/* flush data-only devices */
+	if (mp->m_rtdev_targp)
+		XFS_bflush(mp->m_rtdev_targp);
+
+	return error ? error : error2;
+}
+
+STATIC void
+xfs_quiesce_fs(
+	struct xfs_mount	*mp)
+{
+	int	count = 0, pincount;
+
+	xfs_reclaim_inodes(mp, 0);
+	xfs_flush_buftarg(mp->m_ddev_targp, 0);
+
+	/*
+	 * This loop must run at least twice.  The first instance of the loop
+	 * will flush most meta data but that will generate more meta data
+	 * (typically directory updates).  Which then must be flushed and
+	 * logged before we can write the unmount record. We also so sync
+	 * reclaim of inodes to catch any that the above delwri flush skipped.
+	 */
+	do {
+		xfs_reclaim_inodes(mp, SYNC_WAIT);
+		xfs_sync_attr(mp, SYNC_WAIT);
+		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+		if (!pincount) {
+			delay(50);
+			count++;
+		}
+	} while (count < 2);
+}
+
+/*
+ * Second stage of a quiesce. The data is already synced, now we have to take
+ * care of the metadata. New transactions are already blocked, so we need to
+ * wait for any remaining transactions to drain out before proceeding.
+ */
+void
+xfs_quiesce_attr(
+	struct xfs_mount	*mp)
+{
+	int	error = 0;
+
+	/* wait for all modifications to complete */
+	while (atomic_read(&mp->m_active_trans) > 0)
+		delay(100);
+
+	/* flush inodes and push all remaining buffers out to disk */
+	xfs_quiesce_fs(mp);
+
+	/*
+	 * Just warn here till VFS can correctly support
+	 * read-only remount without racing.
+	 */
+	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
+
+	/* Push the superblock and write an unmount record */
+	error = xfs_log_sbcount(mp);
+	if (error)
+		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
+				"Frozen image may not be consistent.");
+	xfs_log_unmount_write(mp);
+	xfs_unmountfs_writesb(mp);
+}
+
+static void
+xfs_syncd_queue_sync(
+	struct xfs_mount        *mp)
+{
+	queue_delayed_work(xfs_syncd_wq, &mp->m_sync_work,
+				msecs_to_jiffies(xfs_syncd_centisecs * 10));
+}
+
+/*
+ * Every sync period we need to unpin all items, reclaim inodes and sync
+ * disk quotas.  We might need to cover the log to indicate that the
+ * filesystem is idle and not frozen.
+ */
+STATIC void
+xfs_sync_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_sync_work);
+	int		error;
+
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* dgc: errors ignored here */
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+
+		/* start pushing all the metadata that is currently dirty */
+		xfs_ail_push_all(mp->m_ail);
+	}
+
+	/* queue us up again */
+	xfs_syncd_queue_sync(mp);
+}
+
+/*
+ * Queue a new inode reclaim pass if there are reclaimable inodes and there
+ * isn't a reclaim pass already in progress. By default it runs every 5s based
+ * on the xfs syncd work default of 30s. Perhaps this should have it's own
+ * tunable, but that can be done if this method proves to be ineffective or too
+ * aggressive.
+ */
+static void
+xfs_syncd_queue_reclaim(
+	struct xfs_mount        *mp)
+{
+
+	/*
+	 * We can have inodes enter reclaim after we've shut down the syncd
+	 * workqueue during unmount, so don't allow reclaim work to be queued
+	 * during unmount.
+	 */
+	if (!(mp->m_super->s_flags & MS_ACTIVE))
+		return;
+
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
+		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
+			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * This is a fast pass over the inode cache to try to get reclaim moving on as
+ * many inodes as possible in a short period of time. It kicks itself every few
+ * seconds, as well as being kicked by the inode cache shrinker when memory
+ * goes low. It scans as quickly as possible avoiding locked inodes or those
+ * already being flushed, and once done schedules a future pass.
+ */
+STATIC void
+xfs_reclaim_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_reclaim_work);
+
+	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
+	xfs_syncd_queue_reclaim(mp);
+}
+
+/*
+ * Flush delayed allocate data, attempting to free up reserved space
+ * from existing allocations.  At this point a new allocation attempt
+ * has failed with ENOSPC and we are in the process of scratching our
+ * heads, looking about for more room.
+ *
+ * Queue a new data flush if there isn't one already in progress and
+ * wait for completion of the flush. This means that we only ever have one
+ * inode flush in progress no matter how many ENOSPC events are occurring and
+ * so will prevent the system from bogging down due to every concurrent
+ * ENOSPC event scanning all the active inodes in the system for writeback.
+ */
+void
+xfs_flush_inodes(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	queue_work(xfs_syncd_wq, &mp->m_flush_work);
+	flush_work_sync(&mp->m_flush_work);
+}
+
+STATIC void
+xfs_flush_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(work,
+					struct xfs_mount, m_flush_work);
+
+	xfs_sync_data(mp, SYNC_TRYLOCK);
+	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
+}
+
+int
+xfs_syncd_init(
+	struct xfs_mount	*mp)
+{
+	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
+	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+
+	xfs_syncd_queue_sync(mp);
+	xfs_syncd_queue_reclaim(mp);
+
+	return 0;
+}
+
+void
+xfs_syncd_stop(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_work_sync(&mp->m_flush_work);
+}
+
+void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	radix_tree_tag_set(&pag->pag_ici_root,
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_RECLAIM_TAG);
+
+	if (!pag->pag_ici_reclaimable) {
+		/* propagate the reclaim tag up into the perag radix tree */
+		spin_lock(&ip->i_mount->m_perag_lock);
+		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
+				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				XFS_ICI_RECLAIM_TAG);
+		spin_unlock(&ip->i_mount->m_perag_lock);
+
+		/* schedule periodic background inode reclaim */
+		xfs_syncd_queue_reclaim(ip->i_mount);
+
+		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
+							-1, _RET_IP_);
+	}
+	pag->pag_ici_reclaimable++;
+}
+
+/*
+ * We set the inode flag atomically with the radix tree tag.
+ * Once we get tag lookups on the radix tree, this inode flag
+ * can go away.
+ */
+void
+xfs_inode_set_reclaim_tag(
+	xfs_inode_t	*ip)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+	__xfs_inode_set_reclaim_tag(pag, ip);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
+STATIC void
+__xfs_inode_clear_reclaim(
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	pag->pag_ici_reclaimable--;
+	if (!pag->pag_ici_reclaimable) {
+		/* clear the reclaim tag from the perag radix tree */
+		spin_lock(&ip->i_mount->m_perag_lock);
+		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
+				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				XFS_ICI_RECLAIM_TAG);
+		spin_unlock(&ip->i_mount->m_perag_lock);
+		trace_xfs_perag_clear_reclaim(ip->i_mount, pag->pag_agno,
+							-1, _RET_IP_);
+	}
+}
+
+void
+__xfs_inode_clear_reclaim_tag(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	__xfs_inode_clear_reclaim(pag, ip);
+}
+
+/*
+ * Grab the inode for reclaim exclusively.
+ * Return 0 if we grabbed it, non-zero otherwise.
+ */
+STATIC int
+xfs_reclaim_inode_grab(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	ASSERT(rcu_read_lock_held());
+
+	/* quick check for stale RCU freed inode */
+	if (!ip->i_ino)
+		return 1;
+
+	/*
+	 * do some unlocked checks first to avoid unnecessary lock traffic.
+	 * The first is a flush lock check, the second is a already in reclaim
+	 * check. Only do these checks if we are not going to block on locks.
+	 */
+	if ((flags & SYNC_TRYLOCK) &&
+	    (!ip->i_flush.done || __xfs_iflags_test(ip, XFS_IRECLAIM))) {
+		return 1;
+	}
+
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 *
+	 * Due to RCU lookup, we may find inodes that have been freed and only
+	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
+	 * aren't candidates for reclaim at all, so we must check the
+	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) ||
+	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* not a reclaim candidate. */
+		spin_unlock(&ip->i_flags_lock);
+		return 1;
+	}
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	return 0;
+}
+
+/*
+ * Inodes in different states need to be treated differently, and the return
+ * value of xfs_iflush is not sufficient to get this right. The following table
+ * lists the inode states and the reclaim actions necessary for non-blocking
+ * reclaim:
+ *
+ *
+ *	inode state	     iflush ret		required action
+ *      ---------------      ----------         ---------------
+ *	bad			-		reclaim
+ *	shutdown		EIO		unpin and reclaim
+ *	clean, unpinned		0		reclaim
+ *	stale, unpinned		0		reclaim
+ *	clean, pinned(*)	0		requeue
+ *	stale, pinned		EAGAIN		requeue
+ *	dirty, delwri ok	0		requeue
+ *	dirty, delwri blocked	EAGAIN		requeue
+ *	dirty, sync flush	0		reclaim
+ *
+ * (*) dgc: I don't think the clean, pinned state is possible but it gets
+ * handled anyway given the order of checks implemented.
+ *
+ * As can be seen from the table, the return value of xfs_iflush() is not
+ * sufficient to correctly decide the reclaim action here. The checks in
+ * xfs_iflush() might look like duplicates, but they are not.
+ *
+ * Also, because we get the flush lock first, we know that any inode that has
+ * been flushed delwri has had the flush completed by the time we check that
+ * the inode is clean. The clean inode check needs to be done before flushing
+ * the inode delwri otherwise we would loop forever requeuing clean inodes as
+ * we cannot tell apart a successful delwri flush and a clean inode from the
+ * return value of xfs_iflush().
+ *
+ * Note that because the inode is flushed delayed write by background
+ * writeback, the flush lock may already be held here and waiting on it can
+ * result in very long latencies. Hence for sync reclaims, where we wait on the
+ * flush lock, the caller should push out delayed write inodes first before
+ * trying to reclaim them to minimise the amount of time spent waiting. For
+ * background relaim, we just requeue the inode for the next pass.
+ *
+ * Hence the order of actions after gaining the locks should be:
+ *	bad		=> reclaim
+ *	shutdown	=> unpin and reclaim
+ *	pinned, delwri	=> requeue
+ *	pinned, sync	=> unpin
+ *	stale		=> reclaim
+ *	clean		=> reclaim
+ *	dirty, delwri	=> flush and requeue
+ *	dirty, sync	=> flush, wait and reclaim
+ */
+STATIC int
+xfs_reclaim_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			sync_mode)
+{
+	int	error;
+
+restart:
+	error = 0;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (!xfs_iflock_nowait(ip)) {
+		if (!(sync_mode & SYNC_WAIT))
+			goto out;
+		xfs_iflock(ip);
+	}
+
+	if (is_bad_inode(VFS_I(ip)))
+		goto reclaim;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		xfs_iunpin_wait(ip);
+		goto reclaim;
+	}
+	if (xfs_ipincount(ip)) {
+		if (!(sync_mode & SYNC_WAIT)) {
+			xfs_ifunlock(ip);
+			goto out;
+		}
+		xfs_iunpin_wait(ip);
+	}
+	if (xfs_iflags_test(ip, XFS_ISTALE))
+		goto reclaim;
+	if (xfs_inode_clean(ip))
+		goto reclaim;
+
+	/*
+	 * Now we have an inode that needs flushing.
+	 *
+	 * We do a nonblocking flush here even if we are doing a SYNC_WAIT
+	 * reclaim as we can deadlock with inode cluster removal.
+	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
+	 * ip->i_lock, and we are doing the exact opposite here. As a result,
+	 * doing a blocking xfs_itobp() to get the cluster buffer will result
+	 * in an ABBA deadlock with xfs_ifree_cluster().
+	 *
+	 * As xfs_ifree_cluser() must gather all inodes that are active in the
+	 * cache to mark them stale, if we hit this case we don't actually want
+	 * to do IO here - we want the inode marked stale so we can simply
+	 * reclaim it. Hence if we get an EAGAIN error on a SYNC_WAIT flush,
+	 * just unlock the inode, back off and try again. Hopefully the next
+	 * pass through will see the stale flag set on the inode.
+	 */
+	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
+	if (sync_mode & SYNC_WAIT) {
+		if (error == EAGAIN) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			/* backoff longer than in xfs_ifree_cluster */
+			delay(2);
+			goto restart;
+		}
+		xfs_iflock(ip);
+		goto reclaim;
+	}
+
+	/*
+	 * When we have to flush an inode but don't have SYNC_WAIT set, we
+	 * flush the inode out using a delwri buffer and wait for the next
+	 * call into reclaim to find it in a clean state instead of waiting for
+	 * it now. We also don't return errors here - if the error is transient
+	 * then the next reclaim pass will flush the inode, and if the error
+	 * is permanent then the next sync reclaim will reclaim the inode and
+	 * pass on the error.
+	 */
+	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		xfs_warn(ip->i_mount,
+			"inode 0x%llx background reclaim flush failed with %d",
+			(long long)ip->i_ino, error);
+	}
+out:
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * We could return EAGAIN here to make reclaim rescan the inode tree in
+	 * a short while. However, this just burns CPU time scanning the tree
+	 * waiting for IO to complete and xfssyncd never goes back to the idle
+	 * state. Instead, return 0 to let the next scheduled background reclaim
+	 * attempt to reclaim the inode again.
+	 */
+	return 0;
+
+reclaim:
+	xfs_ifunlock(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	XFS_STATS_INC(xs_ig_reclaims);
+	/*
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
+	 */
+	spin_lock(&pag->pag_ici_lock);
+	if (!radix_tree_delete(&pag->pag_ici_root,
+				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
+		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
+	spin_unlock(&pag->pag_ici_lock);
+
+	/*
+	 * Here we do an (almost) spurious inode lock in order to coordinate
+	 * with inode cache radix tree lookups.  This is because the lookup
+	 * can reference the inodes in the cache without taking references.
+	 *
+	 * We make that OK here by ensuring that we wait until the inode is
+	 * unlocked after the lookup before we go ahead and free it.  We get
+	 * both the ilock and the iolock because the code may need to drop the
+	 * ilock one but will still hold the iolock.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_qm_dqdetach(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	xfs_inode_free(ip);
+	return error;
+
+}
+
+/*
+ * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
+ * corrupted, we still want to try to reclaim all the inodes. If we don't,
+ * then a shut down during filesystem unmount reclaim walk leak all the
+ * unreclaimed inodes.
+ */
+int
+xfs_reclaim_inodes_ag(
+	struct xfs_mount	*mp,
+	int			flags,
+	int			*nr_to_scan)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+	int			trylock = flags & SYNC_TRYLOCK;
+	int			skipped;
+
+restart:
+	ag = 0;
+	skipped = 0;
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
+		unsigned long	first_index = 0;
+		int		done = 0;
+		int		nr_found = 0;
+
+		ag = pag->pag_agno + 1;
+
+		if (trylock) {
+			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
+				skipped++;
+				xfs_perag_put(pag);
+				continue;
+			}
+			first_index = pag->pag_ici_reclaim_cursor;
+		} else
+			mutex_lock(&pag->pag_ici_reclaim_lock);
+
+		do {
+			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+			int	i;
+
+			rcu_read_lock();
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH,
+					XFS_ICI_RECLAIM_TAG);
+			if (!nr_found) {
+				done = 1;
+				rcu_read_unlock();
+				break;
+			}
+
+			/*
+			 * Grab the inodes before we drop the lock. if we found
+			 * nothing, nr == 0 and the loop will be skipped.
+			 */
+			for (i = 0; i < nr_found; i++) {
+				struct xfs_inode *ip = batch[i];
+
+				if (done || xfs_reclaim_inode_grab(ip, flags))
+					batch[i] = NULL;
+
+				/*
+				 * Update the index for the next lookup. Catch
+				 * overflows into the next AG range which can
+				 * occur if we have inodes in the last block of
+				 * the AG and we are currently pointing to the
+				 * last inode.
+				 *
+				 * Because we may see inodes that are from the
+				 * wrong AG due to RCU freeing and
+				 * reallocation, only update the index if it
+				 * lies in this AG. It was a race that lead us
+				 * to see this inode, so another lookup from
+				 * the same index will not find it again.
+				 */
+				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
+								pag->pag_agno)
+					continue;
+				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+					done = 1;
+			}
+
+			/* unlock now we've grabbed the inodes. */
+			rcu_read_unlock();
+
+			for (i = 0; i < nr_found; i++) {
+				if (!batch[i])
+					continue;
+				error = xfs_reclaim_inode(batch[i], pag, flags);
+				if (error && last_error != EFSCORRUPTED)
+					last_error = error;
+			}
+
+			*nr_to_scan -= XFS_LOOKUP_BATCH;
+
+		} while (nr_found && !done && *nr_to_scan > 0);
+
+		if (trylock && !done)
+			pag->pag_ici_reclaim_cursor = first_index;
+		else
+			pag->pag_ici_reclaim_cursor = 0;
+		mutex_unlock(&pag->pag_ici_reclaim_lock);
+		xfs_perag_put(pag);
+	}
+
+	/*
+	 * if we skipped any AG, and we still have scan count remaining, do
+	 * another pass this time using blocking reclaim semantics (i.e
+	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
+	 * ensure that when we get more reclaimers than AGs we block rather
+	 * than spin trying to execute reclaim.
+	 */
+	if (trylock && skipped && *nr_to_scan > 0) {
+		trylock = 0;
+		goto restart;
+	}
+	return XFS_ERROR(last_error);
+}
+
+int
+xfs_reclaim_inodes(
+	xfs_mount_t	*mp,
+	int		mode)
+{
+	int		nr_to_scan = INT_MAX;
+
+	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+}
+
+/*
+ * Inode cache shrinker.
+ *
+ * When called we make sure that there is a background (fast) inode reclaim in
+ * progress, while we will throttle the speed of reclaim via doiing synchronous
+ * reclaim of inodes. That means if we come across dirty inodes, we wait for
+ * them to be cleaned, which we hope will not be very long due to the
+ * background walker having already kicked the IO off on those dirty inodes.
+ */
+static int
+xfs_reclaim_inode_shrink(
+	struct shrinker	*shrink,
+	struct shrink_control *sc)
+{
+	struct xfs_mount *mp;
+	struct xfs_perag *pag;
+	xfs_agnumber_t	ag;
+	int		reclaimable;
+	int nr_to_scan = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
+
+	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
+	if (nr_to_scan) {
+		/* kick background reclaimer and push the AIL */
+		xfs_syncd_queue_reclaim(mp);
+		xfs_ail_push_all(mp->m_ail);
+
+		if (!(gfp_mask & __GFP_FS))
+			return -1;
+
+		xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
+					&nr_to_scan);
+		/* terminate if we don't exhaust the scan */
+		if (nr_to_scan > 0)
+			return -1;
+       }
+
+	reclaimable = 0;
+	ag = 0;
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
+		ag = pag->pag_agno + 1;
+		reclaimable += pag->pag_ici_reclaimable;
+		xfs_perag_put(pag);
+	}
+	return reclaimable;
+}
+
+void
+xfs_inode_shrinker_register(
+	struct xfs_mount	*mp)
+{
+	mp->m_inode_shrink.shrink = xfs_reclaim_inode_shrink;
+	mp->m_inode_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&mp->m_inode_shrink);
+}
+
+void
+xfs_inode_shrinker_unregister(
+	struct xfs_mount	*mp)
+{
+	unregister_shrinker(&mp->m_inode_shrink);
+}
diff --git a/fs/xfs/linux/xfs_sync.h b/fs/xfs/linux/xfs_sync.h
new file mode 100644
index 0000000..e914fd6
--- /dev/null
+++ b/fs/xfs/linux/xfs_sync.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef XFS_SYNC_H
+#define XFS_SYNC_H 1
+
+struct xfs_mount;
+struct xfs_perag;
+
+#define SYNC_WAIT		0x0001	/* wait for i/o to complete */
+#define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
+
+extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
+
+int xfs_syncd_init(struct xfs_mount *mp);
+void xfs_syncd_stop(struct xfs_mount *mp);
+
+int xfs_quiesce_data(struct xfs_mount *mp);
+void xfs_quiesce_attr(struct xfs_mount *mp);
+
+void xfs_flush_inodes(struct xfs_inode *ip);
+
+int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
+
+void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
+				struct xfs_inode *ip);
+
+int xfs_sync_inode_grab(struct xfs_inode *ip);
+int xfs_inode_ag_iterator(struct xfs_mount *mp,
+	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
+	int flags);
+
+void xfs_inode_shrinker_register(struct xfs_mount *mp);
+void xfs_inode_shrinker_unregister(struct xfs_mount *mp);
+
+#endif
diff --git a/fs/xfs/linux/xfs_sysctl.c b/fs/xfs/linux/xfs_sysctl.c
new file mode 100644
index 0000000..ee2d2ad
--- /dev/null
+++ b/fs/xfs/linux/xfs_sysctl.c
@@ -0,0 +1,252 @@
+/*
+ * Copyright (c) 2001-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include "xfs_error.h"
+
+static struct ctl_table_header *xfs_table_header;
+
+#ifdef CONFIG_PROC_FS
+STATIC int
+xfs_stats_clear_proc_handler(
+	ctl_table	*ctl,
+	int		write,
+	void		__user *buffer,
+	size_t		*lenp,
+	loff_t		*ppos)
+{
+	int		c, ret, *valp = ctl->data;
+	__uint32_t	vn_active;
+
+	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
+
+	if (!ret && write && *valp) {
+		xfs_notice(NULL, "Clearing xfsstats");
+		for_each_possible_cpu(c) {
+			preempt_disable();
+			/* save vn_active, it's a universal truth! */
+			vn_active = per_cpu(xfsstats, c).vn_active;
+			memset(&per_cpu(xfsstats, c), 0,
+			       sizeof(struct xfsstats));
+			per_cpu(xfsstats, c).vn_active = vn_active;
+			preempt_enable();
+		}
+		xfs_stats_clear = 0;
+	}
+
+	return ret;
+}
+
+STATIC int
+xfs_panic_mask_proc_handler(
+	ctl_table	*ctl,
+	int		write,
+	void		__user *buffer,
+	size_t		*lenp,
+	loff_t		*ppos)
+{
+	int		ret, *valp = ctl->data;
+
+	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
+	if (!ret && write) {
+		xfs_panic_mask = *valp;
+#ifdef DEBUG
+		xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
+#endif
+	}
+	return ret;
+}
+#endif /* CONFIG_PROC_FS */
+
+static ctl_table xfs_table[] = {
+	{
+		.procname	= "irix_sgid_inherit",
+		.data		= &xfs_params.sgid_inherit.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.sgid_inherit.min,
+		.extra2		= &xfs_params.sgid_inherit.max
+	},
+	{
+		.procname	= "irix_symlink_mode",
+		.data		= &xfs_params.symlink_mode.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.symlink_mode.min,
+		.extra2		= &xfs_params.symlink_mode.max
+	},
+	{
+		.procname	= "panic_mask",
+		.data		= &xfs_params.panic_mask.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= xfs_panic_mask_proc_handler,
+		.extra1		= &xfs_params.panic_mask.min,
+		.extra2		= &xfs_params.panic_mask.max
+	},
+
+	{
+		.procname	= "error_level",
+		.data		= &xfs_params.error_level.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.error_level.min,
+		.extra2		= &xfs_params.error_level.max
+	},
+	{
+		.procname	= "xfssyncd_centisecs",
+		.data		= &xfs_params.syncd_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.syncd_timer.min,
+		.extra2		= &xfs_params.syncd_timer.max
+	},
+	{
+		.procname	= "inherit_sync",
+		.data		= &xfs_params.inherit_sync.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inherit_sync.min,
+		.extra2		= &xfs_params.inherit_sync.max
+	},
+	{
+		.procname	= "inherit_nodump",
+		.data		= &xfs_params.inherit_nodump.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inherit_nodump.min,
+		.extra2		= &xfs_params.inherit_nodump.max
+	},
+	{
+		.procname	= "inherit_noatime",
+		.data		= &xfs_params.inherit_noatim.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inherit_noatim.min,
+		.extra2		= &xfs_params.inherit_noatim.max
+	},
+	{
+		.procname	= "xfsbufd_centisecs",
+		.data		= &xfs_params.xfs_buf_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.xfs_buf_timer.min,
+		.extra2		= &xfs_params.xfs_buf_timer.max
+	},
+	{
+		.procname	= "age_buffer_centisecs",
+		.data		= &xfs_params.xfs_buf_age.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.xfs_buf_age.min,
+		.extra2		= &xfs_params.xfs_buf_age.max
+	},
+	{
+		.procname	= "inherit_nosymlinks",
+		.data		= &xfs_params.inherit_nosym.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inherit_nosym.min,
+		.extra2		= &xfs_params.inherit_nosym.max
+	},
+	{
+		.procname	= "rotorstep",
+		.data		= &xfs_params.rotorstep.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.rotorstep.min,
+		.extra2		= &xfs_params.rotorstep.max
+	},
+	{
+		.procname	= "inherit_nodefrag",
+		.data		= &xfs_params.inherit_nodfrg.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inherit_nodfrg.min,
+		.extra2		= &xfs_params.inherit_nodfrg.max
+	},
+	{
+		.procname	= "filestream_centisecs",
+		.data		= &xfs_params.fstrm_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.fstrm_timer.min,
+		.extra2		= &xfs_params.fstrm_timer.max,
+	},
+	/* please keep this the last entry */
+#ifdef CONFIG_PROC_FS
+	{
+		.procname	= "stats_clear",
+		.data		= &xfs_params.stats_clear.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= xfs_stats_clear_proc_handler,
+		.extra1		= &xfs_params.stats_clear.min,
+		.extra2		= &xfs_params.stats_clear.max
+	},
+#endif /* CONFIG_PROC_FS */
+
+	{}
+};
+
+static ctl_table xfs_dir_table[] = {
+	{
+		.procname	= "xfs",
+		.mode		= 0555,
+		.child		= xfs_table
+	},
+	{}
+};
+
+static ctl_table xfs_root_table[] = {
+	{
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= xfs_dir_table
+	},
+	{}
+};
+
+int
+xfs_sysctl_register(void)
+{
+	xfs_table_header = register_sysctl_table(xfs_root_table);
+	if (!xfs_table_header)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_sysctl_unregister(void)
+{
+	unregister_sysctl_table(xfs_table_header);
+}
diff --git a/fs/xfs/linux/xfs_sysctl.h b/fs/xfs/linux/xfs_sysctl.h
new file mode 100644
index 0000000..b9937d4
--- /dev/null
+++ b/fs/xfs/linux/xfs_sysctl.h
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2001-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SYSCTL_H__
+#define __XFS_SYSCTL_H__
+
+#include <linux/sysctl.h>
+
+/*
+ * Tunable xfs parameters
+ */
+
+typedef struct xfs_sysctl_val {
+	int min;
+	int val;
+	int max;
+} xfs_sysctl_val_t;
+
+typedef struct xfs_param {
+	xfs_sysctl_val_t sgid_inherit;	/* Inherit S_ISGID if process' GID is
+					 * not a member of parent dir GID. */
+	xfs_sysctl_val_t symlink_mode;	/* Link creat mode affected by umask */
+	xfs_sysctl_val_t panic_mask;	/* bitmask to cause panic on errors. */
+	xfs_sysctl_val_t error_level;	/* Degree of reporting for problems  */
+	xfs_sysctl_val_t syncd_timer;	/* Interval between xfssyncd wakeups */
+	xfs_sysctl_val_t stats_clear;	/* Reset all XFS statistics to zero. */
+	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
+	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
+	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
+	xfs_sysctl_val_t xfs_buf_timer;	/* Interval between xfsbufd wakeups. */
+	xfs_sysctl_val_t xfs_buf_age;	/* Metadata buffer age before flush. */
+	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
+	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
+	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
+	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
+} xfs_param_t;
+
+/*
+ * xfs_error_level:
+ *
+ * How much error reporting will be done when internal problems are
+ * encountered.  These problems normally return an EFSCORRUPTED to their
+ * caller, with no other information reported.
+ *
+ * 0	No error reports
+ * 1	Report EFSCORRUPTED errors that will cause a filesystem shutdown
+ * 5	Report all EFSCORRUPTED errors (all of the above errors, plus any
+ *	additional errors that are known to not cause shutdowns)
+ *
+ * xfs_panic_mask bit 0x8 turns the error reports into panics
+ */
+
+enum {
+	/* XFS_REFCACHE_SIZE = 1 */
+	/* XFS_REFCACHE_PURGE = 2 */
+	/* XFS_RESTRICT_CHOWN = 3 */
+	XFS_SGID_INHERIT = 4,
+	XFS_SYMLINK_MODE = 5,
+	XFS_PANIC_MASK = 6,
+	XFS_ERRLEVEL = 7,
+	XFS_SYNCD_TIMER = 8,
+	/* XFS_PROBE_DMAPI = 9 */
+	/* XFS_PROBE_IOOPS = 10 */
+	/* XFS_PROBE_QUOTA = 11 */
+	XFS_STATS_CLEAR = 12,
+	XFS_INHERIT_SYNC = 13,
+	XFS_INHERIT_NODUMP = 14,
+	XFS_INHERIT_NOATIME = 15,
+	XFS_BUF_TIMER = 16,
+	XFS_BUF_AGE = 17,
+	/* XFS_IO_BYPASS = 18 */
+	XFS_INHERIT_NOSYM = 19,
+	XFS_ROTORSTEP = 20,
+	XFS_INHERIT_NODFRG = 21,
+	XFS_FILESTREAM_TIMER = 22,
+};
+
+extern xfs_param_t	xfs_params;
+
+#ifdef CONFIG_SYSCTL
+extern int xfs_sysctl_register(void);
+extern void xfs_sysctl_unregister(void);
+#else
+# define xfs_sysctl_register()		(0)
+# define xfs_sysctl_unregister()	do { } while (0)
+#endif /* CONFIG_SYSCTL */
+
+#endif /* __XFS_SYSCTL_H__ */
diff --git a/fs/xfs/linux/xfs_trace.c b/fs/xfs/linux/xfs_trace.c
new file mode 100644
index 0000000..88d25d4
--- /dev/null
+++ b/fs/xfs/linux/xfs_trace.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2009, Christoph Hellwig
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_mount.h"
+#include "xfs_ialloc.h"
+#include "xfs_itable.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_log_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_quota.h"
+#include "xfs_iomap.h"
+#include "xfs_aops.h"
+#include "quota/xfs_dquot_item.h"
+#include "quota/xfs_dquot.h"
+#include "xfs_log_recover.h"
+#include "xfs_inode_item.h"
+
+/*
+ * We include this last to have the helpers above available for the trace
+ * event implementations.
+ */
+#define CREATE_TRACE_POINTS
+#include "xfs_trace.h"
diff --git a/fs/xfs/linux/xfs_trace.h b/fs/xfs/linux/xfs_trace.h
new file mode 100644
index 0000000..fda0708
--- /dev/null
+++ b/fs/xfs/linux/xfs_trace.h
@@ -0,0 +1,1746 @@
+/*
+ * Copyright (c) 2009, Christoph Hellwig
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xfs
+
+#if !defined(_TRACE_XFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_XFS_H
+
+#include <linux/tracepoint.h>
+
+struct xfs_agf;
+struct xfs_alloc_arg;
+struct xfs_attr_list_context;
+struct xfs_buf_log_item;
+struct xfs_da_args;
+struct xfs_da_node_entry;
+struct xfs_dquot;
+struct xlog_ticket;
+struct log;
+struct xlog_recover;
+struct xlog_recover_item;
+struct xfs_buf_log_format;
+struct xfs_inode_log_format;
+
+DECLARE_EVENT_CLASS(xfs_attr_list_class,
+	TP_PROTO(struct xfs_attr_list_context *ctx),
+	TP_ARGS(ctx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(u32, hashval)
+		__field(u32, blkno)
+		__field(u32, offset)
+		__field(void *, alist)
+		__field(int, bufsize)
+		__field(int, count)
+		__field(int, firstu)
+		__field(int, dupcnt)
+		__field(int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
+		__entry->ino = ctx->dp->i_ino;
+		__entry->hashval = ctx->cursor->hashval;
+		__entry->blkno = ctx->cursor->blkno;
+		__entry->offset = ctx->cursor->offset;
+		__entry->alist = ctx->alist;
+		__entry->bufsize = ctx->bufsize;
+		__entry->count = ctx->count;
+		__entry->firstu = ctx->firstu;
+		__entry->flags = ctx->flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
+		  "alist 0x%p size %u count %u firstu %u flags %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->ino,
+		   __entry->hashval,
+		   __entry->blkno,
+		   __entry->offset,
+		   __entry->dupcnt,
+		   __entry->alist,
+		   __entry->bufsize,
+		   __entry->count,
+		   __entry->firstu,
+		   __entry->flags,
+		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
+	)
+)
+
+#define DEFINE_ATTR_LIST_EVENT(name) \
+DEFINE_EVENT(xfs_attr_list_class, name, \
+	TP_PROTO(struct xfs_attr_list_context *ctx), \
+	TP_ARGS(ctx))
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
+
+DECLARE_EVENT_CLASS(xfs_perag_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, refcount, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->refcount = refcount;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u refcount %d caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_PERAG_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_perag_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
+		 unsigned long caller_ip),					\
+	TP_ARGS(mp, agno, refcount, caller_ip))
+DEFINE_PERAG_REF_EVENT(xfs_perag_get);
+DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_put);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
+
+TRACE_EVENT(xfs_attr_list_node_descend,
+	TP_PROTO(struct xfs_attr_list_context *ctx,
+		 struct xfs_da_node_entry *btree),
+	TP_ARGS(ctx, btree),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(u32, hashval)
+		__field(u32, blkno)
+		__field(u32, offset)
+		__field(void *, alist)
+		__field(int, bufsize)
+		__field(int, count)
+		__field(int, firstu)
+		__field(int, dupcnt)
+		__field(int, flags)
+		__field(u32, bt_hashval)
+		__field(u32, bt_before)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
+		__entry->ino = ctx->dp->i_ino;
+		__entry->hashval = ctx->cursor->hashval;
+		__entry->blkno = ctx->cursor->blkno;
+		__entry->offset = ctx->cursor->offset;
+		__entry->alist = ctx->alist;
+		__entry->bufsize = ctx->bufsize;
+		__entry->count = ctx->count;
+		__entry->firstu = ctx->firstu;
+		__entry->flags = ctx->flags;
+		__entry->bt_hashval = be32_to_cpu(btree->hashval);
+		__entry->bt_before = be32_to_cpu(btree->before);
+	),
+	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
+		  "alist 0x%p size %u count %u firstu %u flags %d %s "
+		  "node hashval %u, node before %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->ino,
+		   __entry->hashval,
+		   __entry->blkno,
+		   __entry->offset,
+		   __entry->dupcnt,
+		   __entry->alist,
+		   __entry->bufsize,
+		   __entry->count,
+		   __entry->firstu,
+		   __entry->flags,
+		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
+		   __entry->bt_hashval,
+		   __entry->bt_before)
+);
+
+TRACE_EVENT(xfs_iext_insert,
+	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx,
+		 struct xfs_bmbt_irec *r, int state, unsigned long caller_ip),
+	TP_ARGS(ip, idx, r, state, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_extnum_t, idx)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+		__field(int, bmap_state)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->idx = idx;
+		__entry->startoff = r->br_startoff;
+		__entry->startblock = r->br_startblock;
+		__entry->blockcount = r->br_blockcount;
+		__entry->state = r->br_state;
+		__entry->bmap_state = state;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
+		  "offset %lld block %lld count %lld flag %d caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
+		  (long)__entry->idx,
+		  __entry->startoff,
+		  (__int64_t)__entry->startblock,
+		  __entry->blockcount,
+		  __entry->state,
+		  (char *)__entry->caller_ip)
+);
+
+DECLARE_EVENT_CLASS(xfs_bmap_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state,
+		 unsigned long caller_ip),
+	TP_ARGS(ip, idx, state, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_extnum_t, idx)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+		__field(int, bmap_state)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		struct xfs_ifork	*ifp = (state & BMAP_ATTRFORK) ?
+						ip->i_afp : &ip->i_df;
+		struct xfs_bmbt_irec	r;
+
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r);
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->idx = idx;
+		__entry->startoff = r.br_startoff;
+		__entry->startblock = r.br_startblock;
+		__entry->blockcount = r.br_blockcount;
+		__entry->state = r.br_state;
+		__entry->bmap_state = state;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
+		  "offset %lld block %lld count %lld flag %d caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
+		  (long)__entry->idx,
+		  __entry->startoff,
+		  (__int64_t)__entry->startblock,
+		  __entry->blockcount,
+		  __entry->state,
+		  (char *)__entry->caller_ip)
+)
+
+#define DEFINE_BMAP_EVENT(name) \
+DEFINE_EVENT(xfs_bmap_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
+		 unsigned long caller_ip), \
+	TP_ARGS(ip, idx, state, caller_ip))
+DEFINE_BMAP_EVENT(xfs_iext_remove);
+DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
+DEFINE_BMAP_EVENT(xfs_bmap_post_update);
+DEFINE_BMAP_EVENT(xfs_extlist);
+
+DECLARE_EVENT_CLASS(xfs_buf_class,
+	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip),
+	TP_ARGS(bp, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, bno)
+		__field(size_t, buffer_length)
+		__field(int, hold)
+		__field(int, pincount)
+		__field(unsigned, lockval)
+		__field(unsigned, flags)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = bp->b_target->bt_dev;
+		__entry->bno = bp->b_bn;
+		__entry->buffer_length = bp->b_buffer_length;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->pincount = atomic_read(&bp->b_pin_count);
+		__entry->lockval = bp->b_sema.count;
+		__entry->flags = bp->b_flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+		  "lock %d flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->bno,
+		  __entry->buffer_length,
+		  __entry->hold,
+		  __entry->pincount,
+		  __entry->lockval,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  (void *)__entry->caller_ip)
+)
+
+#define DEFINE_BUF_EVENT(name) \
+DEFINE_EVENT(xfs_buf_class, name, \
+	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip), \
+	TP_ARGS(bp, caller_ip))
+DEFINE_BUF_EVENT(xfs_buf_init);
+DEFINE_BUF_EVENT(xfs_buf_free);
+DEFINE_BUF_EVENT(xfs_buf_hold);
+DEFINE_BUF_EVENT(xfs_buf_rele);
+DEFINE_BUF_EVENT(xfs_buf_iodone);
+DEFINE_BUF_EVENT(xfs_buf_iorequest);
+DEFINE_BUF_EVENT(xfs_buf_bawrite);
+DEFINE_BUF_EVENT(xfs_buf_bdwrite);
+DEFINE_BUF_EVENT(xfs_buf_lock);
+DEFINE_BUF_EVENT(xfs_buf_lock_done);
+DEFINE_BUF_EVENT(xfs_buf_trylock);
+DEFINE_BUF_EVENT(xfs_buf_unlock);
+DEFINE_BUF_EVENT(xfs_buf_iowait);
+DEFINE_BUF_EVENT(xfs_buf_iowait_done);
+DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
+DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
+DEFINE_BUF_EVENT(xfs_buf_delwri_split);
+DEFINE_BUF_EVENT(xfs_buf_get_uncached);
+DEFINE_BUF_EVENT(xfs_bdstrat_shut);
+DEFINE_BUF_EVENT(xfs_buf_item_relse);
+DEFINE_BUF_EVENT(xfs_buf_item_iodone);
+DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
+DEFINE_BUF_EVENT(xfs_buf_error_relse);
+DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
+DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
+
+/* not really buffer traces, but the buf provides useful information */
+DEFINE_BUF_EVENT(xfs_btree_corrupt);
+DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
+DEFINE_BUF_EVENT(xfs_reset_dqcounts);
+DEFINE_BUF_EVENT(xfs_inode_item_push);
+
+/* pass flags explicitly */
+DECLARE_EVENT_CLASS(xfs_buf_flags_class,
+	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip),
+	TP_ARGS(bp, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, bno)
+		__field(size_t, buffer_length)
+		__field(int, hold)
+		__field(int, pincount)
+		__field(unsigned, lockval)
+		__field(unsigned, flags)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = bp->b_target->bt_dev;
+		__entry->bno = bp->b_bn;
+		__entry->buffer_length = bp->b_buffer_length;
+		__entry->flags = flags;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->pincount = atomic_read(&bp->b_pin_count);
+		__entry->lockval = bp->b_sema.count;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+		  "lock %d flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->bno,
+		  __entry->buffer_length,
+		  __entry->hold,
+		  __entry->pincount,
+		  __entry->lockval,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  (void *)__entry->caller_ip)
+)
+
+#define DEFINE_BUF_FLAGS_EVENT(name) \
+DEFINE_EVENT(xfs_buf_flags_class, name, \
+	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
+	TP_ARGS(bp, flags, caller_ip))
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
+
+TRACE_EVENT(xfs_buf_ioerror,
+	TP_PROTO(struct xfs_buf *bp, int error, unsigned long caller_ip),
+	TP_ARGS(bp, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, bno)
+		__field(size_t, buffer_length)
+		__field(unsigned, flags)
+		__field(int, hold)
+		__field(int, pincount)
+		__field(unsigned, lockval)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = bp->b_target->bt_dev;
+		__entry->bno = bp->b_bn;
+		__entry->buffer_length = bp->b_buffer_length;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->pincount = atomic_read(&bp->b_pin_count);
+		__entry->lockval = bp->b_sema.count;
+		__entry->error = error;
+		__entry->flags = bp->b_flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+		  "lock %d error %d flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->bno,
+		  __entry->buffer_length,
+		  __entry->hold,
+		  __entry->pincount,
+		  __entry->lockval,
+		  __entry->error,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  (void *)__entry->caller_ip)
+);
+
+DECLARE_EVENT_CLASS(xfs_buf_item_class,
+	TP_PROTO(struct xfs_buf_log_item *bip),
+	TP_ARGS(bip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, buf_bno)
+		__field(size_t, buf_len)
+		__field(int, buf_hold)
+		__field(int, buf_pincount)
+		__field(int, buf_lockval)
+		__field(unsigned, buf_flags)
+		__field(unsigned, bli_recur)
+		__field(int, bli_refcount)
+		__field(unsigned, bli_flags)
+		__field(void *, li_desc)
+		__field(unsigned, li_flags)
+	),
+	TP_fast_assign(
+		__entry->dev = bip->bli_buf->b_target->bt_dev;
+		__entry->bli_flags = bip->bli_flags;
+		__entry->bli_recur = bip->bli_recur;
+		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
+		__entry->buf_bno = bip->bli_buf->b_bn;
+		__entry->buf_len = bip->bli_buf->b_buffer_length;
+		__entry->buf_flags = bip->bli_buf->b_flags;
+		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
+		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
+		__entry->buf_lockval = bip->bli_buf->b_sema.count;
+		__entry->li_desc = bip->bli_item.li_desc;
+		__entry->li_flags = bip->bli_item.li_flags;
+	),
+	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+		  "lock %d flags %s recur %d refcount %d bliflags %s "
+		  "lidesc 0x%p liflags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->buf_bno,
+		  __entry->buf_len,
+		  __entry->buf_hold,
+		  __entry->buf_pincount,
+		  __entry->buf_lockval,
+		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
+		  __entry->bli_recur,
+		  __entry->bli_refcount,
+		  __print_flags(__entry->bli_flags, "|", XFS_BLI_FLAGS),
+		  __entry->li_desc,
+		  __print_flags(__entry->li_flags, "|", XFS_LI_FLAGS))
+)
+
+#define DEFINE_BUF_ITEM_EVENT(name) \
+DEFINE_EVENT(xfs_buf_item_class, name, \
+	TP_PROTO(struct xfs_buf_log_item *bip), \
+	TP_ARGS(bip))
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
+
+DECLARE_EVENT_CLASS(xfs_lock_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
+		 unsigned long caller_ip),
+	TP_ARGS(ip,  lock_flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, lock_flags)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lock_flags = lock_flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
+		  (void *)__entry->caller_ip)
+)
+
+#define DEFINE_LOCK_EVENT(name) \
+DEFINE_EVENT(xfs_lock_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
+		 unsigned long caller_ip), \
+	TP_ARGS(ip,  lock_flags, caller_ip))
+DEFINE_LOCK_EVENT(xfs_ilock);
+DEFINE_LOCK_EVENT(xfs_ilock_nowait);
+DEFINE_LOCK_EVENT(xfs_ilock_demote);
+DEFINE_LOCK_EVENT(xfs_iunlock);
+
+DECLARE_EVENT_CLASS(xfs_inode_class,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+)
+
+#define DEFINE_INODE_EVENT(name) \
+DEFINE_EVENT(xfs_inode_class, name, \
+	TP_PROTO(struct xfs_inode *ip), \
+	TP_ARGS(ip))
+DEFINE_INODE_EVENT(xfs_iget_skip);
+DEFINE_INODE_EVENT(xfs_iget_reclaim);
+DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_hit);
+DEFINE_INODE_EVENT(xfs_iget_miss);
+
+DEFINE_INODE_EVENT(xfs_getattr);
+DEFINE_INODE_EVENT(xfs_setattr);
+DEFINE_INODE_EVENT(xfs_readlink);
+DEFINE_INODE_EVENT(xfs_alloc_file_space);
+DEFINE_INODE_EVENT(xfs_free_file_space);
+DEFINE_INODE_EVENT(xfs_readdir);
+#ifdef CONFIG_XFS_POSIX_ACL
+DEFINE_INODE_EVENT(xfs_check_acl);
+#endif
+DEFINE_INODE_EVENT(xfs_vm_bmap);
+DEFINE_INODE_EVENT(xfs_file_ioctl);
+DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
+DEFINE_INODE_EVENT(xfs_ioctl_setattr);
+DEFINE_INODE_EVENT(xfs_file_fsync);
+DEFINE_INODE_EVENT(xfs_destroy_inode);
+DEFINE_INODE_EVENT(xfs_write_inode);
+DEFINE_INODE_EVENT(xfs_evict_inode);
+
+DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
+DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
+
+DECLARE_EVENT_CLASS(xfs_iref_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
+	TP_ARGS(ip, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, count)
+		__field(int, pincount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->pincount = atomic_read(&ip->i_pincount);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->count,
+		  __entry->pincount,
+		  (char *)__entry->caller_ip)
+)
+
+#define DEFINE_IREF_EVENT(name) \
+DEFINE_EVENT(xfs_iref_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
+	TP_ARGS(ip, caller_ip))
+DEFINE_IREF_EVENT(xfs_ihold);
+DEFINE_IREF_EVENT(xfs_irele);
+DEFINE_IREF_EVENT(xfs_inode_pin);
+DEFINE_IREF_EVENT(xfs_inode_unpin);
+DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+
+DECLARE_EVENT_CLASS(xfs_namespace_class,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
+	TP_ARGS(dp, name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dp_ino)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(dp)->i_sb->s_dev;
+		__entry->dp_ino = dp->i_ino;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d dp ino 0x%llx name %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dp_ino,
+		  __get_str(name))
+)
+
+#define DEFINE_NAMESPACE_EVENT(name) \
+DEFINE_EVENT(xfs_namespace_class, name, \
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
+	TP_ARGS(dp, name))
+DEFINE_NAMESPACE_EVENT(xfs_remove);
+DEFINE_NAMESPACE_EVENT(xfs_link);
+DEFINE_NAMESPACE_EVENT(xfs_lookup);
+DEFINE_NAMESPACE_EVENT(xfs_create);
+DEFINE_NAMESPACE_EVENT(xfs_symlink);
+
+TRACE_EVENT(xfs_rename,
+	TP_PROTO(struct xfs_inode *src_dp, struct xfs_inode *target_dp,
+		 struct xfs_name *src_name, struct xfs_name *target_name),
+	TP_ARGS(src_dp, target_dp, src_name, target_name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_dp_ino)
+		__field(xfs_ino_t, target_dp_ino)
+		__dynamic_array(char, src_name, src_name->len)
+		__dynamic_array(char, target_name, target_name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
+		__entry->src_dp_ino = src_dp->i_ino;
+		__entry->target_dp_ino = target_dp->i_ino;
+		memcpy(__get_str(src_name), src_name->name, src_name->len);
+		memcpy(__get_str(target_name), target_name->name, target_name->len);
+	),
+	TP_printk("dev %d:%d src dp ino 0x%llx target dp ino 0x%llx"
+		  " src name %s target name %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->src_dp_ino,
+		  __entry->target_dp_ino,
+		  __get_str(src_name),
+		  __get_str(target_name))
+)
+
+DECLARE_EVENT_CLASS(xfs_dquot_class,
+	TP_PROTO(struct xfs_dquot *dqp),
+	TP_ARGS(dqp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u32, id)
+		__field(unsigned, flags)
+		__field(unsigned, nrefs)
+		__field(unsigned long long, res_bcount)
+		__field(unsigned long long, bcount)
+		__field(unsigned long long, icount)
+		__field(unsigned long long, blk_hardlimit)
+		__field(unsigned long long, blk_softlimit)
+		__field(unsigned long long, ino_hardlimit)
+		__field(unsigned long long, ino_softlimit)
+	), \
+	TP_fast_assign(
+		__entry->dev = dqp->q_mount->m_super->s_dev;
+		__entry->id = be32_to_cpu(dqp->q_core.d_id);
+		__entry->flags = dqp->dq_flags;
+		__entry->nrefs = dqp->q_nrefs;
+		__entry->res_bcount = dqp->q_res_bcount;
+		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
+		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
+		__entry->blk_hardlimit =
+			be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+		__entry->blk_softlimit =
+			be64_to_cpu(dqp->q_core.d_blk_softlimit);
+		__entry->ino_hardlimit =
+			be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+		__entry->ino_softlimit =
+			be64_to_cpu(dqp->q_core.d_ino_softlimit);
+	),
+	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
+		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
+		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->id,
+		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
+		  __entry->nrefs,
+		  __entry->res_bcount,
+		  __entry->bcount,
+		  __entry->blk_hardlimit,
+		  __entry->blk_softlimit,
+		  __entry->icount,
+		  __entry->ino_hardlimit,
+		  __entry->ino_softlimit)
+)
+
+#define DEFINE_DQUOT_EVENT(name) \
+DEFINE_EVENT(xfs_dquot_class, name, \
+	TP_PROTO(struct xfs_dquot *dqp), \
+	TP_ARGS(dqp))
+DEFINE_DQUOT_EVENT(xfs_dqadjust);
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
+DEFINE_DQUOT_EVENT(xfs_dqattach_found);
+DEFINE_DQUOT_EVENT(xfs_dqattach_get);
+DEFINE_DQUOT_EVENT(xfs_dqinit);
+DEFINE_DQUOT_EVENT(xfs_dqreuse);
+DEFINE_DQUOT_EVENT(xfs_dqalloc);
+DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
+DEFINE_DQUOT_EVENT(xfs_dqread);
+DEFINE_DQUOT_EVENT(xfs_dqread_fail);
+DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
+DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
+DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
+DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
+DEFINE_DQUOT_EVENT(xfs_dqget_hit);
+DEFINE_DQUOT_EVENT(xfs_dqget_miss);
+DEFINE_DQUOT_EVENT(xfs_dqput);
+DEFINE_DQUOT_EVENT(xfs_dqput_wait);
+DEFINE_DQUOT_EVENT(xfs_dqput_free);
+DEFINE_DQUOT_EVENT(xfs_dqrele);
+DEFINE_DQUOT_EVENT(xfs_dqflush);
+DEFINE_DQUOT_EVENT(xfs_dqflush_force);
+DEFINE_DQUOT_EVENT(xfs_dqflush_done);
+
+DECLARE_EVENT_CLASS(xfs_loggrant_class,
+	TP_PROTO(struct log *log, struct xlog_ticket *tic),
+	TP_ARGS(log, tic),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned, trans_type)
+		__field(char, ocnt)
+		__field(char, cnt)
+		__field(int, curr_res)
+		__field(int, unit_res)
+		__field(unsigned int, flags)
+		__field(int, reserveq)
+		__field(int, writeq)
+		__field(int, grant_reserve_cycle)
+		__field(int, grant_reserve_bytes)
+		__field(int, grant_write_cycle)
+		__field(int, grant_write_bytes)
+		__field(int, curr_cycle)
+		__field(int, curr_block)
+		__field(xfs_lsn_t, tail_lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->trans_type = tic->t_trans_type;
+		__entry->ocnt = tic->t_ocnt;
+		__entry->cnt = tic->t_cnt;
+		__entry->curr_res = tic->t_curr_res;
+		__entry->unit_res = tic->t_unit_res;
+		__entry->flags = tic->t_flags;
+		__entry->reserveq = list_empty(&log->l_reserveq);
+		__entry->writeq = list_empty(&log->l_writeq);
+		xlog_crack_grant_head(&log->l_grant_reserve_head,
+				&__entry->grant_reserve_cycle,
+				&__entry->grant_reserve_bytes);
+		xlog_crack_grant_head(&log->l_grant_write_head,
+				&__entry->grant_write_cycle,
+				&__entry->grant_write_bytes);
+		__entry->curr_cycle = log->l_curr_cycle;
+		__entry->curr_block = log->l_curr_block;
+		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
+	),
+	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
+		  "t_unit_res %u t_flags %s reserveq %s "
+		  "writeq %s grant_reserve_cycle %d "
+		  "grant_reserve_bytes %d grant_write_cycle %d "
+		  "grant_write_bytes %d curr_cycle %d curr_block %d "
+		  "tail_cycle %d tail_block %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->trans_type, XFS_TRANS_TYPES),
+		  __entry->ocnt,
+		  __entry->cnt,
+		  __entry->curr_res,
+		  __entry->unit_res,
+		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
+		  __entry->reserveq ? "empty" : "active",
+		  __entry->writeq ? "empty" : "active",
+		  __entry->grant_reserve_cycle,
+		  __entry->grant_reserve_bytes,
+		  __entry->grant_write_cycle,
+		  __entry->grant_write_bytes,
+		  __entry->curr_cycle,
+		  __entry->curr_block,
+		  CYCLE_LSN(__entry->tail_lsn),
+		  BLOCK_LSN(__entry->tail_lsn)
+	)
+)
+
+#define DEFINE_LOGGRANT_EVENT(name) \
+DEFINE_EVENT(xfs_loggrant_class, name, \
+	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
+	TP_ARGS(log, tic))
+DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
+DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
+DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+
+DECLARE_EVENT_CLASS(xfs_file_class,
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
+	TP_ARGS(ip, count, offset, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count 0x%zx ioflags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
+)
+
+#define DEFINE_RW_EVENT(name)		\
+DEFINE_EVENT(xfs_file_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
+	TP_ARGS(ip, count, offset, flags))
+DEFINE_RW_EVENT(xfs_file_read);
+DEFINE_RW_EVENT(xfs_file_buffered_write);
+DEFINE_RW_EVENT(xfs_file_direct_write);
+DEFINE_RW_EVENT(xfs_file_splice_read);
+DEFINE_RW_EVENT(xfs_file_splice_write);
+
+DECLARE_EVENT_CLASS(xfs_page_class,
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
+	TP_ARGS(inode, page, off),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(pgoff_t, pgoff)
+		__field(loff_t, size)
+		__field(unsigned long, offset)
+		__field(int, delalloc)
+		__field(int, unwritten)
+	),
+	TP_fast_assign(
+		int delalloc = -1, unwritten = -1;
+
+		if (page_has_buffers(page))
+			xfs_count_page_state(page, &delalloc, &unwritten);
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = XFS_I(inode)->i_ino;
+		__entry->pgoff = page_offset(page);
+		__entry->size = i_size_read(inode);
+		__entry->offset = off;
+		__entry->delalloc = delalloc;
+		__entry->unwritten = unwritten;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
+		  "delalloc %d unwritten %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pgoff,
+		  __entry->size,
+		  __entry->offset,
+		  __entry->delalloc,
+		  __entry->unwritten)
+)
+
+#define DEFINE_PAGE_EVENT(name)		\
+DEFINE_EVENT(xfs_page_class, name,	\
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
+	TP_ARGS(inode, page, off))
+DEFINE_PAGE_EVENT(xfs_writepage);
+DEFINE_PAGE_EVENT(xfs_releasepage);
+DEFINE_PAGE_EVENT(xfs_invalidatepage);
+
+DECLARE_EVENT_CLASS(xfs_imap_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
+		 int type, struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, offset, count, type, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(loff_t, size)
+		__field(loff_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, type)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->type = type;
+		__entry->startoff = irec ? irec->br_startoff : 0;
+		__entry->startblock = irec ? irec->br_startblock : 0;
+		__entry->blockcount = irec ? irec->br_blockcount : 0;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count %zd type %s "
+		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_symbolic(__entry->type, XFS_IO_TYPES),
+		  __entry->startoff,
+		  (__int64_t)__entry->startblock,
+		  __entry->blockcount)
+)
+
+#define DEFINE_IOMAP_EVENT(name)	\
+DEFINE_EVENT(xfs_imap_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
+		 int type, struct xfs_bmbt_irec *irec),		\
+	TP_ARGS(ip, offset, count, type, irec))
+DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
+DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
+DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
+DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
+
+DECLARE_EVENT_CLASS(xfs_simple_io_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
+	TP_ARGS(ip, offset, count),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(loff_t, isize)
+		__field(loff_t, disize)
+		__field(loff_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->isize = ip->i_size;
+		__entry->disize = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+	),
+	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count %zd",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->isize,
+		  __entry->disize,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count)
+);
+
+#define DEFINE_SIMPLE_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_simple_io_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
+	TP_ARGS(ip, offset, count))
+DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
+DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
+DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
+DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
+
+DECLARE_EVENT_CLASS(xfs_itrunc_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
+	TP_ARGS(ip, new_size),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = new_size;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size)
+)
+
+#define DEFINE_ITRUNC_EVENT(name) \
+DEFINE_EVENT(xfs_itrunc_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
+	TP_ARGS(ip, new_size))
+DEFINE_ITRUNC_EVENT(xfs_itruncate_data_start);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_data_end);
+
+TRACE_EVENT(xfs_pagecache_inval,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
+	TP_ARGS(ip, start, finish),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_off_t, start)
+		__field(xfs_off_t, finish)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->start = start;
+		__entry->finish = finish;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx start 0x%llx finish 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->start,
+		  __entry->finish)
+);
+
+TRACE_EVENT(xfs_bunmap,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
+		 int flags, unsigned long caller_ip),
+	TP_ARGS(ip, bno, len, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fileoff_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(unsigned long, caller_ip)
+		__field(int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->caller_ip = caller_ip;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
+		  "flags %s caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->bno,
+		  __entry->len,
+		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
+		  (void *)__entry->caller_ip)
+
+);
+
+DECLARE_EVENT_CLASS(xfs_busy_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_BUSY_EVENT(name) \
+DEFINE_EVENT(xfs_busy_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_BUSY_EVENT(xfs_alloc_busy);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
+
+TRACE_EVENT(xfs_alloc_busy_trim,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_agblock_t tbno, xfs_extlen_t tlen),
+	TP_ARGS(mp, agno, agbno, len, tbno, tlen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(xfs_agblock_t, tbno)
+		__field(xfs_extlen_t, tlen)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->tbno = tbno;
+		__entry->tlen = tlen;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u tbno %u tlen %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->tbno,
+		  __entry->tlen)
+);
+
+TRACE_EVENT(xfs_trans_commit_lsn,
+	TP_PROTO(struct xfs_trans *trans),
+	TP_ARGS(trans),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(struct xfs_trans *, tp)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = trans->t_mountp->m_super->s_dev;
+		__entry->tp = trans;
+		__entry->lsn = trans->t_commit_lsn;
+	),
+	TP_printk("dev %d:%d trans 0x%p commit_lsn 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tp,
+		  __entry->lsn)
+);
+
+TRACE_EVENT(xfs_agf,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agf, flags, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, flags)
+		__field(__u32, length)
+		__field(__u32, bno_root)
+		__field(__u32, cnt_root)
+		__field(__u32, bno_level)
+		__field(__u32, cnt_level)
+		__field(__u32, flfirst)
+		__field(__u32, fllast)
+		__field(__u32, flcount)
+		__field(__u32, freeblks)
+		__field(__u32, longest)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = be32_to_cpu(agf->agf_seqno),
+		__entry->flags = flags;
+		__entry->length = be32_to_cpu(agf->agf_length),
+		__entry->bno_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
+		__entry->cnt_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
+		__entry->bno_level =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
+		__entry->cnt_level =
+				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		__entry->flfirst = be32_to_cpu(agf->agf_flfirst),
+		__entry->fllast = be32_to_cpu(agf->agf_fllast),
+		__entry->flcount = be32_to_cpu(agf->agf_flcount),
+		__entry->freeblks = be32_to_cpu(agf->agf_freeblks),
+		__entry->longest = be32_to_cpu(agf->agf_longest);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
+		  "levels b %u c %u flfirst %u fllast %u flcount %u "
+		  "freeblks %u longest %u caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
+		  __entry->length,
+		  __entry->bno_root,
+		  __entry->cnt_root,
+		  __entry->bno_level,
+		  __entry->cnt_level,
+		  __entry->flfirst,
+		  __entry->fllast,
+		  __entry->flcount,
+		  __entry->freeblks,
+		  __entry->longest,
+		  (void *)__entry->caller_ip)
+);
+
+TRACE_EVENT(xfs_free_extent,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, bool isfl, int haveleft, int haveright),
+	TP_ARGS(mp, agno, agbno, len, isfl, haveleft, haveright),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int, isfl)
+		__field(int, haveleft)
+		__field(int, haveright)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->isfl = isfl;
+		__entry->haveleft = haveleft;
+		__entry->haveright = haveright;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u isfl %d %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->isfl,
+		  __entry->haveleft ?
+			(__entry->haveright ? "both" : "left") :
+			(__entry->haveright ? "right" : "none"))
+
+);
+
+DECLARE_EVENT_CLASS(xfs_alloc_class,
+	TP_PROTO(struct xfs_alloc_arg *args),
+	TP_ARGS(args),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, minlen)
+		__field(xfs_extlen_t, maxlen)
+		__field(xfs_extlen_t, mod)
+		__field(xfs_extlen_t, prod)
+		__field(xfs_extlen_t, minleft)
+		__field(xfs_extlen_t, total)
+		__field(xfs_extlen_t, alignment)
+		__field(xfs_extlen_t, minalignslop)
+		__field(xfs_extlen_t, len)
+		__field(short, type)
+		__field(short, otype)
+		__field(char, wasdel)
+		__field(char, wasfromfl)
+		__field(char, isfl)
+		__field(char, userdata)
+		__field(xfs_fsblock_t, firstblock)
+	),
+	TP_fast_assign(
+		__entry->dev = args->mp->m_super->s_dev;
+		__entry->agno = args->agno;
+		__entry->agbno = args->agbno;
+		__entry->minlen = args->minlen;
+		__entry->maxlen = args->maxlen;
+		__entry->mod = args->mod;
+		__entry->prod = args->prod;
+		__entry->minleft = args->minleft;
+		__entry->total = args->total;
+		__entry->alignment = args->alignment;
+		__entry->minalignslop = args->minalignslop;
+		__entry->len = args->len;
+		__entry->type = args->type;
+		__entry->otype = args->otype;
+		__entry->wasdel = args->wasdel;
+		__entry->wasfromfl = args->wasfromfl;
+		__entry->isfl = args->isfl;
+		__entry->userdata = args->userdata;
+		__entry->firstblock = args->firstblock;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
+		  "prod %u minleft %u total %u alignment %u minalignslop %u "
+		  "len %u type %s otype %s wasdel %d wasfromfl %d isfl %d "
+		  "userdata %d firstblock 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->minlen,
+		  __entry->maxlen,
+		  __entry->mod,
+		  __entry->prod,
+		  __entry->minleft,
+		  __entry->total,
+		  __entry->alignment,
+		  __entry->minalignslop,
+		  __entry->len,
+		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
+		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
+		  __entry->wasdel,
+		  __entry->wasfromfl,
+		  __entry->isfl,
+		  __entry->userdata,
+		  (unsigned long long)__entry->firstblock)
+)
+
+#define DEFINE_ALLOC_EVENT(name) \
+DEFINE_EVENT(xfs_alloc_class, name, \
+	TP_PROTO(struct xfs_alloc_arg *args), \
+	TP_ARGS(args))
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_busy);
+DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
+DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
+DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
+DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
+
+DECLARE_EVENT_CLASS(xfs_dir2_class,
+	TP_PROTO(struct xfs_da_args *args),
+	TP_ARGS(args),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__dynamic_array(char, name, args->namelen)
+		__field(int, namelen)
+		__field(xfs_dahash_t, hashval)
+		__field(xfs_ino_t, inumber)
+		__field(int, op_flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		if (args->namelen)
+			memcpy(__get_str(name), args->name, args->namelen);
+		__entry->namelen = args->namelen;
+		__entry->hashval = args->hashval;
+		__entry->inumber = args->inumber;
+		__entry->op_flags = args->op_flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x "
+		  "inumber 0x%llx op_flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->namelen,
+		  __entry->namelen ? __get_str(name) : NULL,
+		  __entry->namelen,
+		  __entry->hashval,
+		  __entry->inumber,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+)
+
+#define DEFINE_DIR2_EVENT(name) \
+DEFINE_EVENT(xfs_dir2_class, name, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args))
+DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_create);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_replace);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_removename);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block);
+DEFINE_DIR2_EVENT(xfs_dir2_block_addname);
+DEFINE_DIR2_EVENT(xfs_dir2_block_lookup);
+DEFINE_DIR2_EVENT(xfs_dir2_block_replace);
+DEFINE_DIR2_EVENT(xfs_dir2_block_removename);
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf);
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block);
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node);
+DEFINE_DIR2_EVENT(xfs_dir2_node_addname);
+DEFINE_DIR2_EVENT(xfs_dir2_node_lookup);
+DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
+DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
+DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
+
+DECLARE_EVENT_CLASS(xfs_dir2_space_class,
+	TP_PROTO(struct xfs_da_args *args, int idx),
+	TP_ARGS(args, idx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, op_flags)
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		__entry->op_flags = args->op_flags;
+		__entry->idx = idx;
+	),
+	TP_printk("dev %d:%d ino 0x%llx op_flags %s index %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->idx)
+)
+
+#define DEFINE_DIR2_SPACE_EVENT(name) \
+DEFINE_EVENT(xfs_dir2_space_class, name, \
+	TP_PROTO(struct xfs_da_args *args, int idx), \
+	TP_ARGS(args, idx))
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add);
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove);
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode);
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode);
+
+TRACE_EVENT(xfs_dir2_leafn_moveents,
+	TP_PROTO(struct xfs_da_args *args, int src_idx, int dst_idx, int count),
+	TP_ARGS(args, src_idx, dst_idx, count),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, op_flags)
+		__field(int, src_idx)
+		__field(int, dst_idx)
+		__field(int, count)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
+		__entry->ino = args->dp->i_ino;
+		__entry->op_flags = args->op_flags;
+		__entry->src_idx = src_idx;
+		__entry->dst_idx = dst_idx;
+		__entry->count = count;
+	),
+	TP_printk("dev %d:%d ino 0x%llx op_flags %s "
+		  "src_idx %d dst_idx %d count %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->src_idx,
+		  __entry->dst_idx,
+		  __entry->count)
+);
+
+#define XFS_SWAPEXT_INODES \
+	{ 0,	"target" }, \
+	{ 1,	"temp" }
+
+#define XFS_INODE_FORMAT_STR \
+	{ 0,	"invalid" }, \
+	{ 1,	"local" }, \
+	{ 2,	"extent" }, \
+	{ 3,	"btree" }
+
+DECLARE_EVENT_CLASS(xfs_swap_extent_class,
+	TP_PROTO(struct xfs_inode *ip, int which),
+	TP_ARGS(ip, which),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, which)
+		__field(xfs_ino_t, ino)
+		__field(int, format)
+		__field(int, nex)
+		__field(int, max_nex)
+		__field(int, broot_size)
+		__field(int, fork_off)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->which = which;
+		__entry->ino = ip->i_ino;
+		__entry->format = ip->i_d.di_format;
+		__entry->nex = ip->i_d.di_nextents;
+		__entry->max_nex = ip->i_df.if_ext_max;
+		__entry->broot_size = ip->i_df.if_broot_bytes;
+		__entry->fork_off = XFS_IFORK_BOFF(ip);
+	),
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+		  "Max in-fork extents %d, broot size %d, fork offset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
+		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
+		  __entry->nex,
+		  __entry->max_nex,
+		  __entry->broot_size,
+		  __entry->fork_off)
+)
+
+#define DEFINE_SWAPEXT_EVENT(name) \
+DEFINE_EVENT(xfs_swap_extent_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int which), \
+	TP_ARGS(ip, which))
+
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
+
+DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
+	TP_PROTO(struct log *log, struct xlog_recover *trans,
+		struct xlog_recover_item *item, int pass),
+	TP_ARGS(log, trans, item, pass),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, item)
+		__field(xlog_tid_t, tid)
+		__field(int, type)
+		__field(int, pass)
+		__field(int, count)
+		__field(int, total)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->item = (unsigned long)item;
+		__entry->tid = trans->r_log_tid;
+		__entry->type = ITEM_TYPE(item);
+		__entry->pass = pass;
+		__entry->count = item->ri_cnt;
+		__entry->total = item->ri_total;
+	),
+	TP_printk("dev %d:%d trans 0x%x, pass %d, item 0x%p, item type %s "
+		  "item region count/total %d/%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tid,
+		  __entry->pass,
+		  (void *)__entry->item,
+		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
+		  __entry->count,
+		  __entry->total)
+)
+
+#define DEFINE_LOG_RECOVER_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_item_class, name, \
+	TP_PROTO(struct log *log, struct xlog_recover *trans, \
+		struct xlog_recover_item *item, int pass), \
+	TP_ARGS(log, trans, item, pass))
+
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
+
+DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
+	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
+	TP_ARGS(log, buf_f),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(__int64_t, blkno)
+		__field(unsigned short, len)
+		__field(unsigned short, flags)
+		__field(unsigned short, size)
+		__field(unsigned int, map_size)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->blkno = buf_f->blf_blkno;
+		__entry->len = buf_f->blf_len;
+		__entry->flags = buf_f->blf_flags;
+		__entry->size = buf_f->blf_size;
+		__entry->map_size = buf_f->blf_map_size;
+	),
+	TP_printk("dev %d:%d blkno 0x%llx, len %u, flags 0x%x, size %d, "
+			"map_size %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->blkno,
+		  __entry->len,
+		  __entry->flags,
+		  __entry->size,
+		  __entry->map_size)
+)
+
+#define DEFINE_LOG_RECOVER_BUF_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_buf_item_class, name, \
+	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
+	TP_ARGS(log, buf_f))
+
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
+
+DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
+	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
+	TP_ARGS(log, in_f),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned short, size)
+		__field(int, fields)
+		__field(unsigned short, asize)
+		__field(unsigned short, dsize)
+		__field(__int64_t, blkno)
+		__field(int, len)
+		__field(int, boffset)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->ino = in_f->ilf_ino;
+		__entry->size = in_f->ilf_size;
+		__entry->fields = in_f->ilf_fields;
+		__entry->asize = in_f->ilf_asize;
+		__entry->dsize = in_f->ilf_dsize;
+		__entry->blkno = in_f->ilf_blkno;
+		__entry->len = in_f->ilf_len;
+		__entry->boffset = in_f->ilf_boffset;
+	),
+	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
+			"dsize %d, blkno 0x%llx, len %d, boffset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->fields,
+		  __entry->asize,
+		  __entry->dsize,
+		  __entry->blkno,
+		  __entry->len,
+		  __entry->boffset)
+)
+#define DEFINE_LOG_RECOVER_INO_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_ino_item_class, name, \
+	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
+	TP_ARGS(log, in_f))
+
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
+
+DECLARE_EVENT_CLASS(xfs_discard_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+)
+
+#define DEFINE_DISCARD_EVENT(name) \
+DEFINE_EVENT(xfs_discard_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_DISCARD_EVENT(xfs_discard_extent);
+DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
+DEFINE_DISCARD_EVENT(xfs_discard_exclude);
+DEFINE_DISCARD_EVENT(xfs_discard_busy);
+
+#endif /* _TRACE_XFS_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE xfs_trace
+#include <trace/define_trace.h>
diff --git a/fs/xfs/linux/xfs_vnode.h b/fs/xfs/linux/xfs_vnode.h
new file mode 100644
index 0000000..7c220b4
--- /dev/null
+++ b/fs/xfs/linux/xfs_vnode.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_VNODE_H__
+#define __XFS_VNODE_H__
+
+#include "xfs_fs.h"
+
+struct file;
+struct xfs_inode;
+struct xfs_iomap;
+struct attrlist_cursor_kern;
+
+/*
+ * Return values for xfs_inactive.  A return value of
+ * VN_INACTIVE_NOCACHE implies that the file system behavior
+ * has disassociated its state and bhv_desc_t from the vnode.
+ */
+#define	VN_INACTIVE_CACHE	0
+#define	VN_INACTIVE_NOCACHE	1
+
+/*
+ * Flags for read/write calls - same values as IRIX
+ */
+#define IO_ISDIRECT	0x00004		/* bypass page cache */
+#define IO_INVIS	0x00020		/* don't update inode timestamps */
+
+#define XFS_IO_FLAGS \
+	{ IO_ISDIRECT,	"DIRECT" }, \
+	{ IO_INVIS,	"INVIS"}
+
+/*
+ * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
+ */
+#define FI_NONE			0	/* none */
+#define FI_REMAPF		1	/* Do a remapf prior to the operation */
+#define FI_REMAPF_LOCKED	2	/* Do a remapf prior to the operation.
+					   Prevent VM access to the pages until
+					   the operation completes. */
+
+/*
+ * Some useful predicates.
+ */
+#define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
+#define VN_CACHED(vp)	(vp->i_mapping->nrpages)
+#define VN_DIRTY(vp)	mapping_tagged(vp->i_mapping, \
+					PAGECACHE_TAG_DIRTY)
+
+
+#endif	/* __XFS_VNODE_H__ */
diff --git a/fs/xfs/linux/xfs_xattr.c b/fs/xfs/linux/xfs_xattr.c
new file mode 100644
index 0000000..87d3e03
--- /dev/null
+++ b/fs/xfs/linux/xfs_xattr.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (C) 2008 Christoph Hellwig.
+ * Portions Copyright (C) 2000-2008 Silicon Graphics, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_acl.h"
+#include "xfs_vnodeops.h"
+
+#include <linux/posix_acl_xattr.h>
+#include <linux/xattr.h>
+
+
+static int
+xfs_xattr_get(struct dentry *dentry, const char *name,
+		void *value, size_t size, int xflags)
+{
+	struct xfs_inode *ip = XFS_I(dentry->d_inode);
+	int error, asize = size;
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	/* Convert Linux syscall to XFS internal ATTR flags */
+	if (!size) {
+		xflags |= ATTR_KERNOVAL;
+		value = NULL;
+	}
+
+	error = -xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
+	if (error)
+		return error;
+	return asize;
+}
+
+static int
+xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags, int xflags)
+{
+	struct xfs_inode *ip = XFS_I(dentry->d_inode);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	/* Convert Linux syscall to XFS internal ATTR flags */
+	if (flags & XATTR_CREATE)
+		xflags |= ATTR_CREATE;
+	if (flags & XATTR_REPLACE)
+		xflags |= ATTR_REPLACE;
+
+	if (!value)
+		return -xfs_attr_remove(ip, (unsigned char *)name, xflags);
+	return -xfs_attr_set(ip, (unsigned char *)name,
+				(void *)value, size, xflags);
+}
+
+static const struct xattr_handler xfs_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.flags	= 0, /* no flags implies user namespace */
+	.get	= xfs_xattr_get,
+	.set	= xfs_xattr_set,
+};
+
+static const struct xattr_handler xfs_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.flags	= ATTR_ROOT,
+	.get	= xfs_xattr_get,
+	.set	= xfs_xattr_set,
+};
+
+static const struct xattr_handler xfs_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.flags	= ATTR_SECURE,
+	.get	= xfs_xattr_get,
+	.set	= xfs_xattr_set,
+};
+
+const struct xattr_handler *xfs_xattr_handlers[] = {
+	&xfs_xattr_user_handler,
+	&xfs_xattr_trusted_handler,
+	&xfs_xattr_security_handler,
+#ifdef CONFIG_XFS_POSIX_ACL
+	&xfs_xattr_acl_access_handler,
+	&xfs_xattr_acl_default_handler,
+#endif
+	NULL
+};
+
+static unsigned int xfs_xattr_prefix_len(int flags)
+{
+	if (flags & XFS_ATTR_SECURE)
+		return sizeof("security");
+	else if (flags & XFS_ATTR_ROOT)
+		return sizeof("trusted");
+	else
+		return sizeof("user");
+}
+
+static const char *xfs_xattr_prefix(int flags)
+{
+	if (flags & XFS_ATTR_SECURE)
+		return xfs_xattr_security_handler.prefix;
+	else if (flags & XFS_ATTR_ROOT)
+		return xfs_xattr_trusted_handler.prefix;
+	else
+		return xfs_xattr_user_handler.prefix;
+}
+
+static int
+xfs_xattr_put_listent(
+	struct xfs_attr_list_context *context,
+	int		flags,
+	unsigned char	*name,
+	int		namelen,
+	int		valuelen,
+	unsigned char	*value)
+{
+	unsigned int prefix_len = xfs_xattr_prefix_len(flags);
+	char *offset;
+	int arraytop;
+
+	ASSERT(context->count >= 0);
+
+	/*
+	 * Only show root namespace entries if we are actually allowed to
+	 * see them.
+	 */
+	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
+		return 0;
+
+	arraytop = context->count + prefix_len + namelen + 1;
+	if (arraytop > context->firstu) {
+		context->count = -1;	/* insufficient space */
+		return 1;
+	}
+	offset = (char *)context->alist + context->count;
+	strncpy(offset, xfs_xattr_prefix(flags), prefix_len);
+	offset += prefix_len;
+	strncpy(offset, (char *)name, namelen);			/* real name */
+	offset += namelen;
+	*offset = '\0';
+	context->count += prefix_len + namelen + 1;
+	return 0;
+}
+
+static int
+xfs_xattr_put_listent_sizes(
+	struct xfs_attr_list_context *context,
+	int		flags,
+	unsigned char	*name,
+	int		namelen,
+	int		valuelen,
+	unsigned char	*value)
+{
+	context->count += xfs_xattr_prefix_len(flags) + namelen + 1;
+	return 0;
+}
+
+static int
+list_one_attr(const char *name, const size_t len, void *data,
+		size_t size, ssize_t *result)
+{
+	char *p = data + *result;
+
+	*result += len;
+	if (!size)
+		return 0;
+	if (*result > size)
+		return -ERANGE;
+
+	strcpy(p, name);
+	return 0;
+}
+
+ssize_t
+xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
+{
+	struct xfs_attr_list_context context;
+	struct attrlist_cursor_kern cursor = { 0 };
+	struct inode		*inode = dentry->d_inode;
+	int			error;
+
+	/*
+	 * First read the regular on-disk attributes.
+	 */
+	memset(&context, 0, sizeof(context));
+	context.dp = XFS_I(inode);
+	context.cursor = &cursor;
+	context.resynch = 1;
+	context.alist = data;
+	context.bufsize = size;
+	context.firstu = context.bufsize;
+
+	if (size)
+		context.put_listent = xfs_xattr_put_listent;
+	else
+		context.put_listent = xfs_xattr_put_listent_sizes;
+
+	xfs_attr_list_int(&context);
+	if (context.count < 0)
+		return -ERANGE;
+
+	/*
+	 * Then add the two synthetic ACL attributes.
+	 */
+	if (posix_acl_access_exists(inode)) {
+		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
+				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
+				data, size, &context.count);
+		if (error)
+			return error;
+	}
+
+	if (posix_acl_default_exists(inode)) {
+		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
+				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
+				data, size, &context.count);
+		if (error)
+			return error;
+	}
+
+	return context.count;
+}
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index 53ec3ea..c30ce0f 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -24,5 +24,5 @@
 #define XFS_BUF_LOCK_TRACKING 1
 #endif
 
-#include <linux-2.6/xfs_linux.h>
+#include <linux/xfs_linux.h>
 #endif	/* __XFS_H__ */
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
