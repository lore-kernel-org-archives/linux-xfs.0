Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 16:02:39 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB802UaG018209
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 16:02:32 -0800
Subject: [PATCH] fix header issue, bump version, update Debian packaging
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-oQyJxFaQuqTyCRVJilb/"
Date: Fri, 08 Dec 2006 11:01:33 +1100
Message-Id: <1165536093.30459.48.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bnaujok@sgi.com, chatz@sgi.com
Cc: xfs@oss.sgi.com

--=-oQyJxFaQuqTyCRVJilb/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Here's a patch which reverts the header rename (since we simply can't
go moving headers that we install in <xfs/...> between minor releases)
and updates the Debian packaging info so I can get a new version into
the Debian archives.  Please apply - thanks.

cheers.

-- 
Nathan

--=-oQyJxFaQuqTyCRVJilb/
Content-Disposition: attachment; filename=fix-list-header-and-bump-debs
Content-Type: text/x-patch; name=fix-list-header-and-bump-debs; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: xfsprogs/VERSION
===================================================================
--- xfsprogs.orig/VERSION	2006-12-08 08:28:47.457518250 +1100
+++ xfsprogs/VERSION	2006-12-08 08:28:55.254005500 +1100
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=8
-PKG_REVISION=17
+PKG_REVISION=18
 PKG_BUILD=1
Index: xfsprogs/debian/changelog
===================================================================
--- xfsprogs.orig/debian/changelog	2006-12-08 08:28:47.549524000 +1100
+++ xfsprogs/debian/changelog	2006-12-08 10:06:07.942525750 +1100
@@ -1,3 +1,9 @@
+xfsprogs (2.8.18-1) unstable; urgency=low
+
+  * New upstream release (closes: #399888)
+
+ -- Nathan Scott <nathans@debian.org>  Fri, 08 Dec 2006 08:30:29 +1100
+
 xfsprogs (2.8.12-1) unstable; urgency=low
 
   * New upstream release.
Index: xfsprogs/doc/CHANGES
===================================================================
--- xfsprogs.orig/doc/CHANGES	2006-12-08 08:28:47.481519750 +1100
+++ xfsprogs/doc/CHANGES	2006-12-08 09:26:19.197238500 +1100
@@ -1,4 +1,11 @@
-xfsprogs-2.8.17
+xfsprogs-2.8.18 (8 December 2006)
+	- <xfs/list.h> is an installed file, we cannot simply rename it,
+	  as other applications using it (accidentally or not) may break.
+	  The xfs_list.h name was inconsistent with everything else too.
+	- Fix "pointer targets in assignment differ in signedness" warnings
+	- Update Debian packaging.
+
+xfsprogs-2.8.17 (?)
 	- Fix up libxfs SEGV when attempting to mount a non-XFS filesystem.
 	  Thanks to Utako Kuzaka <utako@tnes.nec.co.jp> for this.
 	- Fix up xfs_repair aborting if it finds an inode with an invalid 
Index: xfsprogs/include/Makefile
===================================================================
--- xfsprogs.orig/include/Makefile	2006-12-08 08:28:47.569525250 +1100
+++ xfsprogs/include/Makefile	2006-12-08 08:30:58.893732500 +1100
@@ -18,14 +18,14 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-HFILES = cache.h handle.h jdm.h libxfs.h libxlog.h parent.h xfs.h xqm.h \
+HFILES = cache.h handle.h jdm.h list.h libxfs.h libxlog.h parent.h xfs.h xqm.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
 	xfs_buf_item.h xfs_da_btree.h xfs_dfrag.h xfs_dinode.h \
 	xfs_dir2.h xfs_dir2_block.h xfs_dir2_data.h xfs_dir2_leaf.h \
 	xfs_dir2_node.h xfs_dir2_sf.h xfs_dir_leaf.h xfs_dir_sf.h \
 	xfs_extfree_item.h xfs_fs.h xfs_ialloc.h xfs_ialloc_btree.h \
-	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h xfs_list.h \
+	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_mount.h xfs_quota.h \
 	xfs_rtalloc.h xfs_sb.h xfs_trans.h xfs_trans_space.h xfs_types.h
 
Index: xfsprogs/include/list.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs/include/list.h	2006-12-08 08:31:11.694532500 +1100
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2006 Silicon Graphics, Inc.
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
+#ifndef __LIST_H__
+#define __LIST_H__
+
+/*
+ * Simple, generic doubly-linked list implementation.
+ */
+
+struct list_head {
+	struct list_head *next;
+	struct list_head *prev;
+};
+
+static inline void list_head_init(struct list_head *list)
+{
+	list->next = list->prev = list;
+}
+
+static inline void list_head_destroy(struct list_head *list)
+{
+	list->next = list->prev = NULL;
+}
+
+static inline void __list_add(struct list_head *add,
+			      struct list_head *prev, struct list_head *next)
+{
+	next->prev = add;
+	add->next = next;
+	add->prev = prev;
+	prev->next = add;
+}
+
+static inline void list_add(struct list_head *add, struct list_head *head)
+{
+	__list_add(add, head, head->next);
+}
+
+static inline void list_add_tail(struct list_head *add, struct list_head *head)
+{
+	__list_add(add, head->prev, head);
+}
+
+static inline void __list_del(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+static inline void list_del_init(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	list_head_init(entry);
+}
+
+static inline void list_move(struct list_head *list, struct list_head *head)
+{
+	__list_del(list->prev, list->next);
+	list_add(list, head);
+}
+
+static inline void list_move_tail(struct list_head *list, struct list_head *head)
+{
+	__list_del(list->prev, list->next);
+	list_add_tail(list, head);
+}
+
+static inline int list_empty(const struct list_head *head)
+{
+	return head->next == head;
+}
+
+#endif	/* __LIST_H__ */
Index: xfsprogs/include/xfs_list.h
===================================================================
--- xfsprogs.orig/include/xfs_list.h	2006-12-08 08:28:47.637529500 +1100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,88 +0,0 @@
-/*
- * Copyright (c) 2006 Silicon Graphics, Inc.
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
-#ifndef __LIST_H__
-#define __LIST_H__
-
-/*
- * Simple, generic doubly-linked list implementation.
- */
-
-struct list_head {
-	struct list_head *next;
-	struct list_head *prev;
-};
-
-static inline void list_head_init(struct list_head *list)
-{
-	list->next = list->prev = list;
-}
-
-static inline void list_head_destroy(struct list_head *list)
-{
-	list->next = list->prev = NULL;
-}
-
-static inline void __list_add(struct list_head *add,
-			      struct list_head *prev, struct list_head *next)
-{
-	next->prev = add;
-	add->next = next;
-	add->prev = prev;
-	prev->next = add;
-}
-
-static inline void list_add(struct list_head *add, struct list_head *head)
-{
-	__list_add(add, head, head->next);
-}
-
-static inline void list_add_tail(struct list_head *add, struct list_head *head)
-{
-	__list_add(add, head->prev, head);
-}
-
-static inline void __list_del(struct list_head *prev, struct list_head *next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-static inline void list_del_init(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	list_head_init(entry);
-}
-
-static inline void list_move(struct list_head *list, struct list_head *head)
-{
-	__list_del(list->prev, list->next);
-	list_add(list, head);
-}
-
-static inline void list_move_tail(struct list_head *list, struct list_head *head)
-{
-	__list_del(list->prev, list->next);
-	list_add_tail(list, head);
-}
-
-static inline int list_empty(const struct list_head *head)
-{
-	return head->next == head;
-}
-
-#endif	/* __LIST_H__ */
Index: xfsprogs/include/libxfs.h
===================================================================
--- xfsprogs.orig/include/libxfs.h	2006-12-08 08:34:46.039928250 +1100
+++ xfsprogs/include/libxfs.h	2006-12-08 10:05:46.501185750 +1100
@@ -24,7 +24,7 @@
 #include <xfs/platform_defs.h>
 
 #include <pthread.h>
-#include <xfs/xfs_list.h>
+#include <xfs/list.h>
 #include <xfs/cache.h>
 
 #include <xfs/xfs_fs.h>
Index: xfsprogs/libxfs/cache.c
===================================================================
--- xfsprogs.orig/libxfs/cache.c	2006-12-08 08:35:35.479018000 +1100
+++ xfsprogs/libxfs/cache.c	2006-12-08 08:35:40.991362500 +1100
@@ -23,7 +23,7 @@
 #include <pthread.h>
 
 #include <xfs/platform_defs.h>
-#include <xfs/xfs_list.h>
+#include <xfs/list.h>
 #include <xfs/cache.h>
 
 #define CACHE_DEBUG 1

--=-oQyJxFaQuqTyCRVJilb/--
