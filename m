Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 15:03:04 -0800 (PST)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0MN2rqw012230
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 15:02:54 -0800
Received: from agami.com ([192.168.168.140])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l0MMhVEB015240
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 14:43:34 -0800
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l0MMhUd5008501
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 14:43:30 -0800
Message-ID: <45B53E11.8080406@agami.com>
Date: Mon, 22 Jan 2007 14:43:29 -0800
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: xfs_repair speedup changes
Content-Type: multipart/mixed;
 boundary="------------090708000700070403030802"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Chandan Talukdar <chandan@agami.com>

This is a multi-part message in MIME format.
--------------090708000700070403030802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi everyone,

agami Systems started on a project to speed up xfs_repair before
we knew that SGI was working on the same task.  Similar to SGI's
solution, our approach uses readahead to shorten the runtime.  Agami
also wanted to change the existing code as little as possible.

By releasing this patch, we hope to start a discussion which will
lead to continued improvements in xfs_repair runtimes.  Our patch
has a couple of ideas which should benefit SGI's code.  Using our
NAS platform which has 4 CPUs and runs XFS over software RAID5,
we have seen 5 to 8 times speedup, depending on resources allocated
to a run.  The test filesystem had 1.4TB of data with 24M files.
Unfortunately, I have not been able to run the latest CVS code
against our system due to kernel differences.

SGI's advantages
----------------
1. User space cache with maximum number of entries
    a. means that xfs_repair will cause less interference
       with other mounted filesystems.
    b. allows tracking of cache behavior.
2. Rewrite phase7 to eliminate unnecessary transaction overhead.

agami's advantages
------------------
1. Doesn't depend on AIO & generic DIO working correctly.  Will
    work with older linux kernels.
2.  Parallelism model provides additional benefits
     a. In phases 3 and 4, many threads can be used to prefetch
        inode blocks regardless of AG count.
     b. By processing one AG at a time, drives spend less time seeking
        when multiple AGs are placed on a single drive due to the volume
        geometry.
     c. By placing each prefetch in its own thread, more parallelism
        is achieved especially when retrieving directory blocks.

Chandan Talukdar performed all the xfs_repair work over last summer.
Because the work was done on an old base, I have ported it forward to
a CVS date of May 17, 2006.  I chose this date because it allows a
cleaner patch to be delivered.

I would like to hear suggestions for how to proceed.

     Michael Nishimoto

--------------090708000700070403030802
Content-Type: text/plain;
 name="xfs_repair.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair.patch"

diff -Nru xfsprogs-old/include/builddefs.in xfsprogs-new2/include/builddefs.in
--- xfsprogs-old/include/builddefs.in	2006-04-27 21:02:55.000000000 -0700
+++ xfsprogs-new2/include/builddefs.in	2007-01-12 13:58:43.000000000 -0800
@@ -106,7 +106,7 @@
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) -funsigned-char -fno-strict-aliasing -Wall \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
-	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
+	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -pthread
 
 # First, Global, Platform, Local CFLAGS
 CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
diff -Nru xfsprogs-old/libxfs/xfs.h xfsprogs-new2/libxfs/xfs.h
--- xfsprogs-old/libxfs/xfs.h	2006-05-02 08:35:40.000000000 -0700
+++ xfsprogs-new2/libxfs/xfs.h	2007-01-05 12:08:33.000000000 -0800
@@ -94,6 +94,7 @@
 #define xfs_itobp			libxfs_itobp
 #define xfs_ichgtime			libxfs_ichgtime
 #define xfs_bmapi			libxfs_bmapi
+#define xfs_bmapi_single		libxfs_bmapi_single
 #define xfs_bmap_finish			libxfs_bmap_finish
 #define xfs_bmap_del_free		libxfs_bmap_del_free
 #define xfs_bunmapi			libxfs_bunmapi
diff -Nru xfsprogs-old/repair/dino_chunks.c xfsprogs-new2/repair/dino_chunks.c
--- xfsprogs-old/repair/dino_chunks.c	2005-11-11 06:27:22.000000000 -0800
+++ xfsprogs-new2/repair/dino_chunks.c	2007-01-05 12:10:12.000000000 -0800
@@ -920,7 +920,38 @@
 	ino_tree_node_t *ino_rec, *first_ino_rec, *prev_ino_rec;
 
 	first_ino_rec = ino_rec = findfirst_inode_rec(agno);
+#ifdef PHASE_3_4
+	ino_tree_node_t *first_ra_rec, *ra_rec;
+	int iters = 0;
+	int chunklen = BBTOB(XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)));
+
+	first_ra_rec = ra_rec = first_ino_rec;
+	/*
+	 * before we start processing, insert 'rahead' number of
+	 * nodes into the read ahead queue.  call insert_nodes()
+	 * with readdirblks set to 1 implying that the directory
+	 * blocks of the directory inodes within this chunk should
+	 * also be read in.
+	 */
+	if (insert_nodes(rahead, agno, &first_ra_rec, &ra_rec, 1, chunklen))
+		do_error(_("failed to allocate memory.  aborting\n"));
+#endif
 	while (ino_rec != NULL)  {
+#ifdef PHASE_3_4
+		iters++;
+		/*
+		 * after a set of 'radelta' number of nodes have been processed,
+		 * insert another 'radelta' nodes into the read ahead queue.
+		 * call insert_nodes() with readdirblks set to 1 implying that
+		 * the directory blocks of the directory inodes within this
+		 * chunk should also be read in.
+		 */
+		if (iters % radelta == 0) {
+			if (insert_nodes(radelta, agno, &first_ra_rec,
+			                 &ra_rec, 1, chunklen))
+			  do_error(_("failed to allocate memory.  aborting\n"));
+		}
+#endif
 		/*
 		 * paranoia - step through inode records until we step
 		 * through a full allocation of inodes.  this could
diff -Nru xfsprogs-old/repair/globals.h xfsprogs-new2/repair/globals.h
--- xfsprogs-old/repair/globals.h	2005-11-11 06:27:22.000000000 -0800
+++ xfsprogs-new2/repair/globals.h	2007-01-08 14:04:14.000000000 -0800
@@ -193,4 +193,10 @@
 EXTERN __uint32_t	sb_unit;
 EXTERN __uint32_t	sb_width;
 
+/* Used to increase performance by doing readahead */
+
+EXTERN int		numthreads;
+EXTERN int		rahead;
+EXTERN int		radelta;
+
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff -Nru xfsprogs-old/repair/Makefile xfsprogs-new2/repair/Makefile
--- xfsprogs-old/repair/Makefile	2005-11-11 06:27:22.000000000 -0800
+++ xfsprogs-new2/repair/Makefile	2007-01-12 16:09:54.000000000 -0800
@@ -14,13 +14,18 @@
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c dino_chunks.c \
 	dinode.c dir.c dir2.c dir_stack.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c io.c phase1.c \
-	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c rt.c sb.c \
-	scan.c versions.c xfs_repair.c
+	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c queue.c rt.c \
+	sb.c scan.c threads.c versions.c xfs_repair.c
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static
 
+# PHASE_3_4: Enable read ahead for phase 3 and 4
+# PHASE_6: Enable read ahead for phase 6
+# PHASE_7: Enable read ahead for phase 7
+CFLAGS	+= -DPHASE_3_4 -DPHASE_6 -DPHASE_7
+
 default: $(LTCOMMAND)
 
 globals.o: globals.h
diff -Nru xfsprogs-old/repair/phase6.c xfsprogs-new2/repair/phase6.c
--- xfsprogs-old/repair/phase6.c	2006-05-12 09:03:02.000000000 -0700
+++ xfsprogs-new2/repair/phase6.c	2007-01-17 14:15:14.000000000 -0800
@@ -28,10 +28,18 @@
 #include "err_protos.h"
 #include "dinode.h"
 #include "versions.h"
+#ifdef PHASE_6
+#include <pthread.h>
+#include "queue.h"
+#include "threads.h"
+#endif
 
 static struct cred zerocr;
 static struct fsxattr zerofsx;
 static int orphanage_entered;
+#ifdef PHASE_6  
+static queue_t		dir_queue;
+#endif
 
 /*
  * Data structures and routines to keep track of directory entries
@@ -1476,8 +1484,33 @@
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
 
-			if (!is_inode_refchecked(lino, irec, ino_offset))
+			if (!is_inode_refchecked(lino, irec, ino_offset)) {
+#ifdef PHASE_6
+				qnode_t	*node;
+				node = alloc_qnode(&Q, sizeof(rahead_t));
+				if (node != NULL) {
+					rahead_t *nd = (rahead_t *)(node->data);
+					nd->type = IDIR;
+					nd->u_ra.ino = lino;
+					nd->readdirblks = 1;
+					queue_insert(&Q, node);
+				} else {
+					do_error(_("failed to allocate memory. "
+						   "aborting\n"));
+				}
+				node = alloc_qnode(&dir_queue,
+						   sizeof(xfs_ino_t));
+				if (node != NULL) {
+					*((xfs_ino_t*)(node->data)) = lino;
+					queue_insert(&dir_queue, node);
+				} else {
+					do_error("failed to allocate memory.  "
+						 "aborting\n");
+				}
+#else
 				push_dir(stack, lino);
+#endif
+			}
 		} else  {
 			junkit = 1;
 			do_warn(
@@ -2037,9 +2070,38 @@
 			add_inode_ref(current_irec, current_ino_offset);
 			if (!is_inode_refchecked(
 				INT_GET(dep->inumber, ARCH_CONVERT), irec,
-					ino_offset))
+				ino_offset)) {
+#ifdef PHASE_6
+				qnode_t	*node;
+				node = alloc_qnode(&Q, sizeof(rahead_t));
+				if (node != NULL) {
+					rahead_t *ra= (rahead_t *)(node->data);
+					ra->type = IDIR;
+					ra->u_ra.ino = INT_GET(dep->inumber,
+							       ARCH_CONVERT);
+					ra->readdirblks = 1;
+					queue_insert(&Q, node);
+				} else {
+					do_error(_("failed to allocate memory."
+						   " aborting\n"));
+				}
+
+				node = alloc_qnode(&dir_queue,
+						   sizeof(xfs_ino_t));
+				if (node != NULL) {
+					xfs_ino_t*ino=(xfs_ino_t*)(node->data);
+					*ino = INT_GET(dep->inumber,
+						       ARCH_CONVERT);
+					queue_insert(&dir_queue, node);
+				} else {
+					do_error("failed to allocate memory. "
+						 "aborting\n");
+				}
+#else
 				push_dir(stack,
-					INT_GET(dep->inumber, ARCH_CONVERT));
+					 INT_GET(dep->inumber, ARCH_CONVERT));
+#endif
+			}
 		} else  {
 			junkit = 1;
 			do_warn(
@@ -2944,8 +3006,34 @@
 				add_inode_ref(current_irec, current_ino_offset);
 
 				if (!is_inode_refchecked(lino, irec,
-						ino_offset))
+							 ino_offset)) {
+#ifdef PHASE_6
+					qnode_t	*node;
+					node= alloc_qnode(&Q,sizeof(rahead_t));
+					if (node != NULL) {
+						rahead_t *ra =
+						      (rahead_t *)(node->data);
+						ra->type = IDIR;
+						ra->u_ra.ino = lino;
+						ra->readdirblks = 1;
+						queue_insert(&Q, node);
+					} else {
+			do_error(_("failed to allocate memory.  aborting\n"));
+					}
+
+					node = alloc_qnode(&dir_queue,
+							   sizeof(xfs_ino_t));
+					if (node != NULL) {
+						*((xfs_ino_t *)(node->data)) =
+							lino;
+						queue_insert(&dir_queue, node);
+					} else {
+			do_error("failed to allocate memory.  aborting\n");
+					}
+#else
 					push_dir(stack, lino);
+#endif
+				}
 			} else  {
 				junkit = 1;
 				do_warn(
@@ -3339,8 +3427,35 @@
 				add_inode_ref(current_irec, current_ino_offset);
 
 				if (!is_inode_refchecked(lino, irec,
-						ino_offset))
+							 ino_offset)) {
+#ifdef PHASE_6
+					qnode_t	*node;
+					node = alloc_qnode(&Q,
+							   sizeof(rahead_t));
+					if (node != NULL) {
+						rahead_t *ra =
+						       (rahead_t*)(node->data);
+						ra->type = IDIR;
+						ra->u_ra.ino = lino;
+						ra->readdirblks = 1;
+						queue_insert(&Q, node);
+					} else {
+			do_error(_("failed to allocate memory.  aborting\n"));
+					}
+
+					node = alloc_qnode(&dir_queue,
+							   sizeof(xfs_ino_t));
+					if (node != NULL) {
+						*((xfs_ino_t*)(node->data)) =
+							lino;
+						queue_insert(&dir_queue, node);
+					} else {
+			do_error("failed to allocate memory.  aborting\n");
+					}
+#else
 					push_dir(stack, lino);
+#endif
+				}
 			} else  {
 				junkit = 1;
 				do_warn(_("entry \"%s\" in directory inode %llu"
@@ -3466,6 +3581,21 @@
 	int			ino_offset, need_dot, committed;
 	int			dirty, num_illegal, error, nres;
 
+#ifdef PHASE_6
+	/*
+	 * pull directory inode # off directory queue
+	 *
+	 * open up directory inode, check all entries,
+	 * then call prune_dir_entries to remove all
+	 * remaining illegal directory entries.
+	 */
+	qnode_t		*node;
+	while (queue_remove(&dir_queue, &node, 0)) {
+		wake_if_sleeping();
+
+		ino = *((xfs_ino_t*)(node->data));
+		free_qnode(&dir_queue, node);
+#else
 	/*
 	 * pull directory inode # off directory stack
 	 *
@@ -3474,7 +3604,8 @@
 	 * remaining illegal directory entries.
 	 */
 
-	while ((ino = pop_dir(stack)) != NULLFSINO)  {
+	while ((ino = pop_dir(stack)) != NULLFSINO) {
+#endif
 		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, ino),
 					XFS_INO_TO_AGINO(mp, ino));
 		ASSERT(irec != NULL);
@@ -3953,7 +4084,19 @@
 		orphanage_ino = mk_orphanage(mp);
 	}
 
+#ifdef PHASE_6
+	/*
+	 * when the read ahead code is enabled, we do the namespace walk
+	 * in a breadth first manner as opposed to the depth first model
+	 * used earlier.  to implement BF traversal, we will be using a 
+	 * queue.  this queue is named 'dir_queue', and will be used in
+	 * process_dirstack().  note that this should not be confused
+	 * with the read ahead queue named 'Q'.
+	 */
+	queue_init(&dir_queue);
+#else
 	dir_stack_init(&stack);
+#endif
 
 	mark_standalone_inodes(mp);
 
@@ -3963,7 +4106,34 @@
 	if (!need_root_inode)  {
 		do_log(_("        - traversing filesystem starting at / ... \n"));
 
+#ifdef PHASE_6
+		qnode_t	*node;
+		/*
+		 * insert root dir in the read ahead queue
+		 */
+		node = alloc_qnode(&Q, sizeof(rahead_t));
+		if (node != NULL) {
+			rahead_t *ra = (rahead_t *)(node->data);
+			ra->type = IDIR;
+			ra->u_ra.ino = mp->m_sb.sb_rootino;
+			ra->readdirblks = 1;
+			queue_insert(&Q, node);
+		} else {
+			do_error(_("failed to allocate memory.  aborting\n"));
+		}
+		/*
+		 * insert root dir into the directory processing queue
+		 */
+		node = alloc_qnode(&dir_queue, sizeof(xfs_ino_t));
+		if (node != NULL) {
+			*((xfs_ino_t*)(node->data)) = mp->m_sb.sb_rootino;
+			queue_insert(&dir_queue, node);
+		} else {
+			do_error("failed to allocate memory.  aborting\n");
+		}
+#else
 		push_dir(&stack, mp->m_sb.sb_rootino);
+#endif
 		process_dirstack(mp, &stack);
 
 		do_log(_("        - traversal finished ... \n"));
@@ -4017,9 +4187,33 @@
 				ino = XFS_AGINO_TO_INO(mp, i,
 						j + irec->ino_startnum);
 				if (inode_isadir(irec, j) &&
-						!is_inode_refchecked(ino,
-							irec, j)) {
+				    !is_inode_refchecked(ino, irec, j)) {
+#ifdef PHASE_6
+					qnode_t *node;
+					node=alloc_qnode(&Q, sizeof(rahead_t));
+					if (node != NULL) {
+						rahead_t *ra =
+						      (rahead_t *)(node->data);
+						ra->type = IDIR;
+						ra->u_ra.ino = ino;
+						ra->readdirblks = 1;
+						queue_insert(&Q, node);
+					} else {
+			do_error(_("failed to allocate memory.  aborting\n"));
+					}
+
+					node = alloc_qnode(&dir_queue,
+							   sizeof(xfs_ino_t));
+					if (node != NULL) {
+						*((xfs_ino_t*)(node->data)) =
+							ino;
+						queue_insert(&dir_queue, node);
+					} else {
+			do_error("failed to allocate memory.  aborting\n");
+					}
+#else
 					push_dir(&stack, ino);
+#endif
 					process_dirstack(mp, &stack);
 				}
 			}
diff -Nru xfsprogs-old/repair/phase7.c xfsprogs-new2/repair/phase7.c
--- xfsprogs-old/repair/phase7.c	2005-11-11 06:27:22.000000000 -0800
+++ xfsprogs-new2/repair/phase7.c	2007-01-06 08:38:12.000000000 -0800
@@ -25,6 +25,10 @@
 #include "err_protos.h"
 #include "dinode.h"
 #include "versions.h"
+#ifdef PHASE_7
+#include "queue.h"
+#include "threads.h"
+#endif
 
 /* dinoc is a pointer to the IN-CORE dinode core */
 void
@@ -91,8 +95,45 @@
 	 */
 	for (i = 0; i < glob_agcount; i++)  {
 		irec = findfirst_inode_rec(i);
+#ifdef PHASE_7
+		int             iter = 0;
+		ino_tree_node_t	*ra_irec;
+		ino_tree_node_t	*ra_first_irec;
+		int chunklen = BBTOB(XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)));
+
+		ra_first_irec = ra_irec = irec;
+		/*
+		 * before we start processing, insert 'rahead' number of
+		 * nodes into the read ahead queue.  call insert_nodes()
+		 * with readdirblks set to 0 implying that the directory
+		 * blocks of the directory inodes within this chunk should
+		 * not be read in.  that's because phase 7 looks into only
+		 * the inode structure.
+		 */
+		if (insert_nodes(rahead, i, &ra_first_irec, &ra_irec,
+				 0, chunklen))
+			do_error(_("failed to allocate memory.  aborting\n"));
+#endif
 
 		while (irec != NULL)  {
+#ifdef PHASE_7
+			iter++;
+			/*
+			 * after a set of 'radelta' num of nodes have been 
+			 * processed, insert another 'radelta' nodes into the 
+			 * read ahead queue.  call insert_nodes() with 
+			 * readdirblks set to 0 implying that the directory 
+			 * blocks of the directory inodes within this chunk 
+			 * should not be read in.  that's because phase 7
+			 * looks into only the inode structure.
+			 */
+			if (iter % radelta == 0) {
+				if (insert_nodes(radelta, i, &ra_first_irec,
+						 &ra_irec, 0, chunklen))
+					do_error(_("failed to allocate memory. "
+						   "aborting\n"));
+			}
+#endif
 			for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
 				ASSERT(is_inode_confirmed(irec, j));
 
diff -Nru xfsprogs-old/repair/queue.c xfsprogs-new2/repair/queue.c
--- xfsprogs-old/repair/queue.c	1969-12-31 16:00:00.000000000 -0800
+++ xfsprogs-new2/repair/queue.c	2007-01-22 11:32:23.000000000 -0800
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2006-2007 agami Systems, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public 
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Contact information:
+ *  agami Systems, Inc.,
+ *  1269 Innsbruck Drive,
+ *  Sunnyvale, CA  94089, or:
+ *
+ * http://www.agami.com 
+ */ 
+
+#include <libxfs.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include "queue.h"
+
+/*
+ * The routines in this file implement a generic queue data structure 
+ */
+
+int
+queue_init(
+	queue_t    *Q)
+{
+	pthread_mutex_init(&Q->qmutex, NULL);
+	pthread_cond_init(&Q->qcond_wait, NULL);
+	Q->head = Q->tail = NULL;
+	Q->waiters = 0;
+	Q->status = 0;
+	Q->fl.head = NULL;
+	Q->fl.cnt = 0;
+	pthread_mutex_init(&Q->fl.listmutex, NULL);
+
+	return 0;
+}
+
+/*
+ * This routine is useful for waking up blocked waiters on an
+ * empty queue
+ */
+int
+q_empty_wakeup_all(
+	queue_t		*Q)
+{
+	pthread_mutex_lock(&Q->qmutex);
+
+	if (Q->head == Q->tail) {
+		pthread_cond_broadcast(&Q->qcond_wait);
+		Q->status = 1;
+		pthread_mutex_unlock(&Q->qmutex);
+		return 0;
+	} else {
+		pthread_mutex_unlock(&Q->qmutex);
+		return 1;
+	}
+}
+
+/*
+ * This queue can be used in two modes namely blocking/non-blocking.
+ * In the blocking mode, threads issuing a delete wait till data is
+ * available.  Non blocking deletes return immediatly if the queue
+ * is empty. 
+ */
+int
+queue_remove(
+	queue_t		*Q,
+	qnode_t		**data,
+	int		blocking)
+{
+	pthread_mutex_lock(&Q->qmutex);
+
+	if (Q->status) {
+		pthread_mutex_unlock(&Q->qmutex);
+		return 0;
+	}
+
+	if (!blocking) {
+		if ((Q->head == NULL) && (Q->tail == NULL)) {
+			pthread_mutex_unlock(&Q->qmutex);
+			return 0;
+		}
+	}
+
+	Q->waiters++;
+
+	while ((Q->head == NULL) && (Q->tail == NULL) && (Q->status == 0)) {
+		pthread_cond_wait(&Q->qcond_wait, &Q->qmutex);
+	}
+
+	Q->waiters--;
+
+	if (Q->status) {
+		pthread_mutex_unlock(&Q->qmutex);
+		return 0;
+	}
+
+	*data = Q->tail;
+	if (Q->head == Q->tail)
+		Q->tail = Q->head = NULL;
+	else
+		Q->tail = Q->tail->next;
+
+	pthread_mutex_unlock(&Q->qmutex);
+	return 1;
+}
+
+void
+queue_insert(
+	queue_t		*Q,
+	qnode_t		*data)
+{
+
+	pthread_mutex_lock(&Q->qmutex);
+
+	if (Q->head == NULL) {
+		Q->head = Q->tail = data;
+	} else {
+		Q->head->next = data;
+		Q->head = data;
+	}
+
+	if (Q->waiters) {
+		pthread_cond_signal(&Q->qcond_wait);
+	}
+
+	pthread_mutex_unlock(&Q->qmutex);
+        return;
+}
+
+void
+free_qnode(
+	queue_t		*Q,
+	qnode_t		*node)
+{
+	pthread_mutex_lock(&Q->fl.listmutex);
+
+	node->next = Q->fl.head;
+	Q->fl.head = node;
+	Q->fl.cnt++;
+
+	pthread_mutex_unlock(&Q->fl.listmutex);
+        return;
+}
+
+qnode_t*
+alloc_qnode(
+	queue_t		*Q,
+	int		size)
+{
+	qnode_t		*node = NULL;
+	pthread_mutex_lock(&Q->fl.listmutex);
+
+	if (Q->fl.cnt > 0) {
+		node = Q->fl.head;
+		Q->fl.head = (Q->fl.head)->next;
+		Q->fl.cnt--;
+		node->next = NULL;
+	} else {
+		if ((node = (qnode_t*)malloc(sizeof(qnode_t))) == NULL) {
+			pthread_mutex_unlock(&Q->fl.listmutex);
+			return NULL;
+		}
+		if ((node->data = malloc(size)) == NULL) {
+			free(node);
+			pthread_mutex_unlock(&Q->fl.listmutex);
+			return NULL;
+		}
+		node->next = NULL;
+	}
+	pthread_mutex_unlock(&Q->fl.listmutex);
+	return node;
+}
+
diff -Nru xfsprogs-old/repair/queue.h xfsprogs-new2/repair/queue.h
--- xfsprogs-old/repair/queue.h	1969-12-31 16:00:00.000000000 -0800
+++ xfsprogs-new2/repair/queue.h	2007-01-22 11:32:33.000000000 -0800
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2006-2007 agami Systems, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public 
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Contact information:
+ *  agami Systems, Inc.,
+ *  1269 Innsbruck Drive,
+ *  Sunnyvale, CA  94089, or:
+ *
+ * http://www.agami.com 
+ */ 
+
+typedef struct qnode {
+	void		*data;
+	struct qnode 	*next;
+} qnode_t;
+
+typedef struct freelist {
+	qnode_t		*head;
+	int		cnt;
+	pthread_mutex_t	listmutex;
+} freelist_t;
+
+typedef struct queue {
+	qnode_t		*head;
+	qnode_t		*tail;
+	pthread_mutex_t	qmutex;
+	pthread_cond_t	qcond_wait;
+	int		waiters;
+	/*
+	 * status can be either 0 or 1.  0 signifying queue is being
+	 * used; 1 signifying queue no longer being used.
+	 */
+	int		status;
+	freelist_t	fl;
+} queue_t;
+
+int
+queue_init(
+	queue_t		*Q);
+
+void
+queue_insert(
+	queue_t		*Q,
+	qnode_t		*data);
+
+int
+queue_remove(
+	queue_t		*Q,
+	qnode_t		**data,
+	int		blocking);
+
+int
+q_empty_wakeup_all(
+	queue_t		*Q);
+
+qnode_t*
+alloc_qnode(
+	queue_t    *Q,
+	int        size);
+
+void
+free_qnode(
+	queue_t    *Q,
+	qnode_t    *node);
diff -Nru xfsprogs-old/repair/threads.c xfsprogs-new2/repair/threads.c
--- xfsprogs-old/repair/threads.c	1969-12-31 16:00:00.000000000 -0800
+++ xfsprogs-new2/repair/threads.c	2007-01-22 11:32:10.000000000 -0800
@@ -0,0 +1,821 @@
+/*
+ * Copyright (c) 2006-2007 agami Systems, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public 
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Contact information:
+ *  agami Systems, Inc.,
+ *  1269 Innsbruck Drive,
+ *  Sunnyvale, CA  94089, or:
+ *
+ * http://www.agami.com 
+ */ 
+
+/*
+ * this file consists of all the routines needed to implement the read
+ * ahead algorithm.  as of now, we do two kinds of read ahead namely
+ * 1) a complete inode chunk (denoted by ICHUNK in the queue node)
+ * 2) a directory inode (denoted by IDIR in the queue node)
+ * To begin with 'numthreads' threads are created by start_threads(),
+ * which is an exported routine.  the worker threads start with the
+ * thread_worker() routine.  this essentially plucks off nodes from
+ * the read ahead queue, and depending on their type, dispatches them
+ * to the appropriate routines.
+ *
+ * note: according to the current algorithm of xfs_repair, phase 3,4,
+ * and 7 issues ICHUNK read ahead requests.  during phase 3 and 4,
+ * process_aginodes() queues in nodes to the read ahead queue, while
+ * in phase 7, phase7() does it.  phase 6 issues IDIR requests.  The
+ * insertions to the read ahead queue happens in lf_block_dir_entry_check(),
+ * longform_dir2_entry_check_data(), shortform_dir_entry_check(),
+ * shortform_dir2_entry_check(), phase6().
+ */
+
+#include <libxfs.h>
+#include <pthread.h>
+#include "avl.h"
+#include "globals.h"
+#include "incore.h"
+#include "bmap.h"
+#include "versions.h"
+#include "dinode.h"
+#include "queue.h"
+#include "threads.h"
+#include "err_protos.h"
+#include "dir2.h"
+
+#define BBTOOFF64(bbs) (((xfs_off_t)(bbs)) << BBSHIFT)
+
+static pthread_t	*mythread;
+static xfs_mount_t	*mptr;
+static int 		fd;
+static int		chunklen;
+static char		*pool;
+static char		**buf;
+static int		*tid;
+/*
+ * phase 6 specific.  we maintain two global counters for the read ahead
+ * in phase 6.  'p6_processed' maintains the count of directory inodes that
+ * the main thread has completed processing.  'p6_read' maintains the count
+ * of directory inodes that the read ahead threads have fetched into memory.
+ * in order to avoid flooding the page cache, we allow read aheads only if
+ * the delta between 'p6_read' & 'p6_processed' is less than 'rahead', which
+ * is our global read ahead tunable.  in case the delta exceeds the value,
+ * the worker threads sleep on their individual conditional variables.
+ * before going to sleep, the threads queue their conditional variables in
+ * the 'p6_sleep_Q' queue.  this is done in the routine 'good_to_read()'.
+ * when the delta gets below the threshold, the main thread wakes up the
+ * sleeping worker threads.  this happens in 'wake_if_sleeping()'. 
+ */
+static int		p6_processed = 0;
+static int		p6_read = 0;
+static pthread_mutex_t	p6_mutex = PTHREAD_MUTEX_INITIALIZER;
+static queue_t		p6_sleep_Q;
+/*
+ * read ahead queue
+ */
+queue_t			Q;
+
+extern int	libxfs_bmapi_single(xfs_trans_t *, xfs_inode_t *, int,
+			xfs_fsblock_t *, xfs_fileoff_t);
+
+static void
+sleep100ms(void);
+
+static int
+ichunk_dirblks_rahead(
+	int		tid,
+	char		*ichunk);
+
+static int
+thread_read_dir2(
+	int		tid,
+	xfs_dinode_t	*dip,
+	blkmap_t	*blkmap);
+
+static int
+block_dir2_rahead(
+	int		tid,
+	blkmap_t	*blkmap);
+
+static int
+thread_read_exinode(
+	int		tid,
+	xfs_dinode_t	*dip,
+	__uint64_t	*nex,
+	blkmap_t	**blkmapp);
+
+static void
+ichunk_rahead(
+	int		tid,
+	xfs_daddr_t	blkno,
+	int		len,
+	int		readdirblks);
+
+static void
+idir_rahead(
+	int		tid,
+	xfs_ino_t	ino,
+	int		readdirblks);
+
+static void
+dir2_rahead(
+	int		tid,
+	xfs_inode_t	*ip);
+
+static int
+leaf_node_dir2_rahead(
+	int		tid,
+	blkmap_t	*blkmap);
+
+static void
+good_to_read(
+	pthread_cond_t	*cond);
+
+/*
+ * pluck nodes off the read ahead queue, and call the appropriate
+ * routine depending on the type i.e ICHUNK or IDIR
+ */
+
+static void*
+thread_worker(
+	void* arg)
+{
+	nodetype_t	type;
+	xfs_daddr_t	blkno;
+	int		len;
+	xfs_ino_t	ino;
+	int		readdirblks;
+	qnode_t		*node;
+	int		tid = *((int*)arg);
+	pthread_cond_t	p6_sleep_cond = PTHREAD_COND_INITIALIZER;
+
+	while (queue_remove(&Q, &node, 1)) {
+		type = ((rahead_t*)(node->data))->type;
+		readdirblks = ((rahead_t*)(node->data))->readdirblks;
+
+		switch (type) {
+		case ICHUNK:
+			blkno = ((rahead_t*)(node->data))->u_ra.ichunk.blkno;
+			len = ((rahead_t*)(node->data))->u_ra.ichunk.len;
+			ichunk_rahead(tid, blkno, len, readdirblks); 
+			break;
+		case IDIR:
+			ino = ((rahead_t*)(node->data))->u_ra.ino;
+			good_to_read(&p6_sleep_cond);
+			idir_rahead(tid, ino, readdirblks);
+			break;
+		default:
+			do_error(_("should never be reached\n"));
+			break;
+		}
+
+		free_qnode(&Q, node);
+	}
+
+	pthread_exit(NULL);
+	return arg;
+}
+
+/*
+ * read in an inode chunk.  if readdirblks is set, then read in the
+ * directory blocks of all the directory inodes within the chunk.
+ */
+static void
+ichunk_rahead(
+	int		tid,
+	xfs_daddr_t	blkno,
+	int		len,
+	int		readdirblks)
+{
+	if (pread64(fd, buf[tid], len, BBTOOFF64(blkno)) < 0) {
+		do_warn(_("failed read ahead of inode chunk at block %ld.\n"), blkno);
+		return;
+	}
+
+	if (readdirblks) {
+		if (ichunk_dirblks_rahead(tid, buf[tid])) {
+			do_warn(_("suspect inode chunk at block %ld.\n"), blkno);
+		}
+	}
+	return;
+}
+
+/*
+ * given an inode number, read in the inode.  if readdirblks is set,
+ * read in the directory blocks for the inode.
+ */
+static void
+idir_rahead(
+	int		tid,
+	xfs_ino_t	ino,
+	int		readdirblks)
+{
+	xfs_inode_t	*ip;
+	int		error;
+
+	if ((error = libxfs_iget(mptr, NULL, ino, 0, &ip, 0))) {
+		do_warn(_("couldn't map inode %llu, err = %d\n"),ino, error);
+		return;
+	}
+
+	if (readdirblks) {
+		switch (ip->i_d.di_format)  {
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			if (XFS_SB_VERSION_HASDIRV2(&mptr->m_sb))
+				dir2_rahead(tid, ip);
+			break;
+		default:
+			break;
+		}
+	}
+
+	libxfs_iput(ip, 0);
+}
+
+/*
+ * read in the block map for an extent type inode.  stripped down
+ * version of 'process_bmbt_reclist_int()'
+ *
+ * return: 0 on success, 1 on failure
+ */
+static int
+thread_read_exinode(
+	int		tid,
+	xfs_dinode_t	*dip,
+	__uint64_t	*nex,
+	blkmap_t	**blkmapp)
+{
+	int			i;
+	xfs_dfilblks_t		c;		/* count */
+	xfs_dfilblks_t		cp = 0;		/* prev count */
+	xfs_dfsbno_t		s;		/* start */
+	xfs_dfsbno_t		sp = 0;		/* prev start */
+	xfs_dfiloff_t		o = 0;		/* offset */
+	xfs_dfiloff_t		op = 0;		/* prev offset */
+	int			flag;		/* extent flag */
+	xfs_bmbt_rec_32_t	*rp;
+
+	rp = (xfs_bmbt_rec_32_t *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*nex = XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK);
+
+	for (i = 0; i < *nex; i++, rp++) {
+		convert_extent(rp, &o, &s, &c, &flag);
+
+		if (i > 0 && op + cp > o)  {
+			return 1;
+		}
+
+		op = o;
+		cp = c;
+		sp = s;
+
+		if (c == 0)  {
+			return 1;
+		}
+
+		if (!verify_dfsbno(mptr, s))  {
+			return 1;
+		}
+
+		if (!verify_dfsbno(mptr, s + c - 1))  {
+			return 1;
+		}
+
+		if (s + c - 1 < s) {
+			return 1;
+		}
+
+		if (o > fs_max_file_offset) {
+			return 1;
+		}
+
+		blkmap_set_ext(blkmapp, o, s, c);
+	}
+	return 0;
+}
+
+/*
+ * carve out disk inodes out of the inode chunk one by one.  if inode not 
+ * a v2 directory, ignore.  otherwise read in it's directory blocks. what
+ * do we do in case we get an error in any of the directory inodes within
+ * the chunk ?  we take the optimistic view, and move on to the next inode
+ * in the chunk.
+ *
+ * return: 0 if all the inodes in the chunk were read without any errors,
+ *         1 otherwise.
+ */
+static int
+ichunk_dirblks_rahead(
+	int     tid,
+	char    *ichunk)
+{
+	xfs_dinode_t		*dino;
+	xfs_dinode_core_t	*dinoc;
+	__uint64_t		nextents;
+	blkmap_t		*dblkmap = NULL;
+	int			done = 0;
+	int			icnt = 0;
+	int			irec_offset = 0;
+	int			err = 0;
+
+	while (!done) {
+		dino = (xfs_dinode_t*)(ichunk +
+				       (icnt << mptr->m_sb.sb_inodelog));
+
+		icnt++;
+		irec_offset++;
+
+		if(icnt == XFS_IALLOC_INODES(mptr) &&
+		   irec_offset == XFS_INODES_PER_CHUNK) {
+			done = 1;
+		} else if (irec_offset == XFS_INODES_PER_CHUNK) {
+			irec_offset = 0;
+		}
+
+		dinoc = &dino->di_core;
+
+		if (INT_GET(dinoc->di_magic, ARCH_CONVERT) != XFS_DINODE_MAGIC)
+			continue;
+
+		if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
+		    (!fs_inode_nlink &&
+		     dinoc->di_version > XFS_DINODE_VERSION_1))  {
+			continue;
+		}
+
+		if (INT_GET(dinoc->di_size, ARCH_CONVERT) < 0)
+			continue;
+
+		if ((INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT) !=
+		    S_IFDIR)
+			continue;
+
+		nextents = INT_GET(dinoc->di_nextents, ARCH_CONVERT);
+		if (nextents > INT_GET(dinoc->di_nblocks, ARCH_CONVERT) || 
+		    nextents > XFS_MAX_INCORE_EXTENTS)
+			nextents = 1;
+
+		if (INT_GET(dinoc->di_size, ARCH_CONVERT) <=
+		    XFS_DFORK_DSIZE(dino, mptr) &&
+		    (dinoc->di_format != XFS_DINODE_FMT_LOCAL))  {
+			continue;
+		}
+
+		if (dinoc->di_format == XFS_DINODE_FMT_EXTENTS) {
+			dblkmap = blkmap_alloc(nextents);
+		} else {
+			continue;
+		}
+
+		nextents = 0;
+		if (thread_read_exinode(tid, dino, &nextents, &dblkmap)) {
+			err = 1;
+			blkmap_free(dblkmap);
+			continue;
+		}
+
+		if (nextents > MAXEXTNUM)  {
+			blkmap_free(dblkmap);
+			continue;
+		}
+
+		if (nextents != INT_GET(dinoc->di_nextents, ARCH_CONVERT))  {
+			blkmap_free(dblkmap);
+			continue;
+		}
+
+		if (XFS_SB_VERSION_HASDIRV2(&mptr->m_sb))
+			if (thread_read_dir2(tid, dino, dblkmap))
+				err = 1;
+
+		blkmap_free(dblkmap);
+	}
+
+	return err;
+}
+
+/*
+ * call the appropriate directory routine based on the type i.e block/leaf.
+ *
+ * return: 0 if the directory blocks were read without any errors, 1 otherwise.
+ */
+static int
+thread_read_dir2(
+	int		tid,
+	xfs_dinode_t	*dip,
+	blkmap_t	*blkmap)
+{
+	int		res = 0;
+	xfs_dfiloff_t	last = 0;
+	
+	if (blkmap)
+		last = blkmap_last_off(blkmap);
+
+	if (last == mptr->m_dirblkfsbs &&
+	    dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS) {
+		res = block_dir2_rahead(tid, blkmap);
+	} else if (last >= mptr->m_dirleafblk + mptr->m_dirblkfsbs &&
+	           dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS) {
+		res = leaf_node_dir2_rahead(tid, blkmap);
+	}
+
+	return res;
+}
+
+/*
+ * read in the blocks of a block type v2 directory.  stripped down
+ * version of 'process_block_dir2()'.  the idea is to bring the blocks
+ * into the page cache so that the main thread has a cache hit.  it's
+ * fine to ignore any read error that we might see since the main
+ * thread will catch up behind us and clean things up.  we just log
+ * the failure and proceed.
+ *
+ * return: 0 on a successful read of the block, 1 otherwise.
+ */
+static int
+block_dir2_rahead(
+	int		tid,
+	blkmap_t	*blkmap)
+{
+	bmap_ext_t		lbmp;
+	bmap_ext_t		*bmp;
+	xfs_dir2_block_t	*block;
+	xfs_dabuf_t		*bp;
+	int			nex;
+
+	nex = blkmap_getn(blkmap, mptr->m_dirdatablk, mptr->m_dirblkfsbs, &bmp,
+			  &lbmp);
+	if (nex == 0) {
+		return 1;
+	}
+	bp = da_read_buf(mptr, nex, bmp);
+	if (bmp != &lbmp)
+		free(bmp);
+
+	if (bp == NULL) {
+		return 1;
+	}
+
+	block = bp->data;
+	if (INT_GET(block->hdr.magic, ARCH_CONVERT) != XFS_DIR2_BLOCK_MAGIC)
+		do_warn(_("bad directory block magic in block %lu\n"),
+		        XFS_FSB_TO_DADDR(mptr, bmp[0].startblock));
+
+	da_brelse(bp);
+	return 0;
+}
+
+static void sleep100ms(void)
+{
+	struct timespec ts;
+	ts.tv_sec = 0;
+	ts.tv_nsec = 100*1000*1000;
+
+	nanosleep(&ts, NULL);
+	return;
+}
+
+void start_threads(
+	xfs_mount_t	*mp)
+{
+	char*	temp;
+	int 	i;
+
+	if ((mptr = (xfs_mount_t*)malloc(sizeof(xfs_mount_t))) == NULL)
+		do_error("failed to allocate memory.\n");
+	memcpy(mptr, mp, sizeof(xfs_mount_t));
+	/*
+	 * chunklen is the length of an inode chunk
+	 */
+	chunklen = BBTOB(XFS_FSB_TO_BB(mptr, XFS_IALLOC_BLOCKS(mptr)));
+	/*
+	 * allocate enough memory for the worker threads
+	 */ 
+	if((pool = (char*)malloc(chunklen * numthreads)) == NULL)
+		do_error("failed to allocate memory.\n");
+	buf = (char**)malloc(numthreads * sizeof(char*));
+	if (buf == NULL)
+		do_error("failed to allocate memory.\n");
+	temp = pool;
+	for (i = 0; i < numthreads; i++) {
+		buf[i] = temp;
+		temp += chunklen;
+	}
+	fd = libxfs_device_to_fd(mptr->m_dev);
+	if (queue_init(&Q))
+		do_error("failed to initialize read ahead queue.\n");
+	if (queue_init(&p6_sleep_Q))
+		do_error("failed to initialize sleep queue for phase 6.\n");
+	mythread = (pthread_t*)malloc(numthreads * sizeof(pthread_t));
+	if (mythread == NULL)
+		do_error("failed to allocate memory.\n");
+	tid = (int*)malloc(numthreads * sizeof(int));
+	if (tid == NULL)
+		do_error("failed to allocate memory.\n");
+	for (i = 0; i < numthreads; i++) {
+	  tid[i] = i;
+	  if (pthread_create(&mythread[i], NULL, thread_worker, (void*)&tid[i]))
+	    do_error("failed to create worker threads.\n");
+	}
+	return;
+}
+
+void stop_threads(void) {
+
+	int i;
+
+	unblock_threads();
+
+	for (i = 0; i < numthreads; i++) {
+		if (pthread_join(mythread[i], NULL))
+			do_warn(_("thread %d failed to join.  continuing"), i);
+	}
+
+	free(mptr);
+	free(pool);
+	free(buf);
+	free(tid);
+
+	return;
+}
+
+void
+unblock_threads(void)
+{
+	/*
+	 * loop every 100ms to see if the read ahead queue is empty.
+	 * if so, wake up all worker threads.
+	 */
+	while (1) {
+		if (q_empty_wakeup_all(&Q)) {
+			sleep100ms();
+		} else {
+			break;
+		}
+	}
+}
+
+/*
+ * directory block read ahead code for phase 6.  the idea is to bring
+ * the blocks into the page cache so that the main thread has a cache hit.
+ * it's fine to ignore any read error that we might see since the main
+ * thread will catch up behind us and clean things up.  we just log the
+ * failure and proceed.
+ */
+static void
+dir2_rahead(
+	int		tid,
+	xfs_inode_t	*ip)
+{
+	xfs_fileoff_t		da_bno;
+	xfs_fileoff_t		next_da_bno;
+	int			j;
+	xfs_fsblock_t		fsb;
+	xfs_daddr_t		blkno;
+	int			len;
+	int			nfsb;
+	int			error;
+	char			*buf;
+
+	for (da_bno = 0, next_da_bno = 0; next_da_bno != NULLFILEOFF;
+	     da_bno = next_da_bno) {
+		
+		next_da_bno = da_bno + mptr->m_dirblkfsbs - 1;
+		if (libxfs_bmap_next_offset(NULL, ip, &next_da_bno,
+					    XFS_DATA_FORK))
+			break;
+
+		if (mptr->m_dirblkfsbs == 1) {
+			error = libxfs_bmapi_single(NULL, ip, XFS_DATA_FORK,
+						    &fsb, da_bno);
+			if (error != 0) {
+				do_warn("bmap block err: %d in inode: %llu\n",
+					error, ip->i_ino);
+				return;
+			}
+			if (fsb == NULLFSBLOCK) {
+				return;
+			}
+			blkno = XFS_FSB_TO_DADDR(mptr, fsb);
+			len =  XFS_FSB_TO_BB(mptr, 1);
+
+			if ((buf = (char*)malloc(BBTOB(len))) == NULL) {
+				do_error("malloc failed in thread %d\n", tid);
+			}
+
+			if (pread64(fd, buf, BBTOB(len), BBTOOFF64(blkno))< 0){
+				do_warn(_("failed read of block: %ld.  "
+					  "continuing\n"), blkno);
+			}
+
+			free(buf);
+		} else if ((nfsb = mptr->m_dirblkfsbs) > 1) {
+			xfs_fsblock_t	firstblock;
+			xfs_bmbt_irec_t	*mapp;
+			int		nmap;
+
+			mapp = malloc(sizeof(*mapp) * nfsb);
+
+			if (mapp == NULL) {
+				do_error("cannot allocate memory for map\n");
+			}
+
+			firstblock = NULLFSBLOCK;
+			nmap = nfsb;
+			error = libxfs_bmapi(NULL, ip, da_bno, nfsb,
+					     XFS_BMAPI_METADATA |
+					     XFS_BMAPI_AFLAG(XFS_DATA_FORK),
+					     &firstblock, 0, mapp, &nmap,
+					     NULL);
+			if (error) {
+				do_warn("bmap block err: %d in inode: %llu\n",
+					error, ip->i_ino);
+				free(mapp);
+				return;
+			}
+
+			for (j = 0; j < nmap; j++) {
+				blkno= XFS_FSB_TO_DADDR(mptr,
+							mapp[j].br_startblock);
+				len = XFS_FSB_TO_BB(mptr,
+						    mapp[j].br_blockcount);
+
+				if ((buf = (char*)malloc(BBTOB(len))) == NULL){
+				       do_error("malloc failed in thread %d\n",
+						tid);
+				}
+
+				if (pread64(fd, buf, BBTOB(len),
+					    BBTOOFF64(blkno)) < 0) {
+					do_warn(_("failed read of block: %ld. "
+						  "continuing\n"), blkno);
+				}
+				free(buf);
+			}
+			free(mapp);
+		} else {
+			do_warn("invalid mptr->m_dirblkfsbs: %d\n",
+				mptr->m_dirblkfsbs);
+			return;
+		}
+	}
+	return;
+}
+
+/*
+ * read in blocks of a leaf type v2 directory.  stripped down version
+ * of 'process_leaf_node_dir2()'.  the idea is to bring the blocks into
+ * the page cache so that the main thread has a cache hit.  it's fine to
+ * ignore any read error that we might see since the main thread will
+ * catch up behind us and clean things up.  we just log the failure and
+ * proceed.
+ *
+ * return: 0 on a successful read of all the blocks, 1 otherwise.
+ *
+ * Todo: this code reads only the directory data blocks.  need to enhance
+ * it to read the internal node and leaf blocks.
+ */
+static int
+leaf_node_dir2_rahead(
+	int          tid,
+	blkmap_t     *blkmap)
+{
+	xfs_dfiloff_t		dbno;
+	xfs_dfiloff_t		ndbno;
+	bmap_ext_t		lbmp;
+	bmap_ext_t		*bmp;
+	xfs_dabuf_t		*bp;
+	xfs_dir2_data_t		*data;
+	int			nex;
+	int			t;
+	int			err = 0;
+
+	ndbno = NULLDFILOFF;
+	while ((dbno = blkmap_next_off(blkmap,ndbno,&t)) < mptr->m_dirleafblk){
+		nex = blkmap_getn(blkmap, dbno, mptr->m_dirblkfsbs,
+				  &bmp, &lbmp);
+		ndbno = dbno + mptr->m_dirblkfsbs - 1;
+		if (nex == 0) {
+			err = 1;
+			continue;
+		}
+		bp = da_read_buf(mptr, nex, bmp);
+		if (bmp != &lbmp)
+			free(bmp);
+		if (bp == NULL) {
+			err = 1;
+			continue;
+		}
+		data = bp->data;
+		if (INT_GET(data->hdr.magic, ARCH_CONVERT) !=
+		    XFS_DIR2_DATA_MAGIC)
+			do_warn(_("bad directory block magic # %#x in "
+				  "block %lu\n"),
+				INT_GET(data->hdr.magic, ARCH_CONVERT),
+				XFS_FSB_TO_DADDR(mptr, bmp[0].startblock));
+		
+		da_brelse(bp);
+	}
+	return err;
+}
+
+int
+insert_nodes(
+	int		numnodes,
+	int		agno,
+	ino_tree_node_t	**first_ra_recp,
+	ino_tree_node_t	**ra_recp,
+	int		readdirblks,
+	int		chunklen)
+{
+	int		i, ra_inos;
+	xfs_agblock_t	agbno;
+	qnode_t		*ranode;
+
+	for (i = 0; i < numnodes && *ra_recp != NULL; i++) {
+		ra_inos = XFS_INODES_PER_CHUNK;
+		while (ra_inos < XFS_IALLOC_INODES(mptr) && *ra_recp != NULL) {
+			if ((*ra_recp = next_ino_rec(*ra_recp)) != NULL)
+				ra_inos += XFS_INODES_PER_CHUNK;
+		}
+		ranode = alloc_qnode(&Q, sizeof(rahead_t));
+		if (ranode != NULL) {
+			rahead_t *ra = (rahead_t*)(ranode->data);
+			agbno = XFS_AGINO_TO_AGBNO(mptr,
+			                      (*first_ra_recp)->ino_startnum);
+			ra->type = ICHUNK;
+			ra->u_ra.ichunk.blkno = XFS_AGB_TO_DADDR(mptr, agno,
+								 agbno);
+			ra->u_ra.ichunk.len = chunklen;
+			ra->readdirblks = readdirblks;
+			queue_insert(&Q, ranode);
+		} else {
+			return 1;
+		}
+		if (*ra_recp != NULL)
+			*first_ra_recp = *ra_recp = next_ino_rec(*ra_recp);
+	}
+	return 0;
+}
+/*
+ * refer to notes at the begining of the file for details about the
+ * working of this routine.
+ */
+static void
+good_to_read(
+	pthread_cond_t	*cond)
+{
+	qnode_t	*node;
+	pthread_mutex_lock(&p6_mutex);
+	p6_read++;
+	if (p6_read - p6_processed < rahead) {
+		pthread_mutex_unlock(&p6_mutex);
+		return;
+	} else {
+		node = alloc_qnode(&p6_sleep_Q, sizeof(pthread_cond_t*));
+		if (node != NULL) {
+			(pthread_cond_t*)(node->data) = cond;
+			queue_insert(&p6_sleep_Q, node);
+			pthread_cond_wait(cond, &p6_mutex);
+		} else {
+			do_error("failed to allocate memory.  aborting\n");
+		}
+		pthread_mutex_unlock(&p6_mutex);
+		return;
+	}
+}
+/*
+ * refer to notes at the begining of the file for details about the
+ * working of this routine.
+ */
+void
+wake_if_sleeping(void)
+{
+	qnode_t	*node;
+	pthread_mutex_lock(&p6_mutex);
+	p6_processed++;
+	if (queue_remove(&p6_sleep_Q, &node, 0)) {
+		pthread_cond_t *cond = (pthread_cond_t*)(node->data);
+		free_qnode(&p6_sleep_Q, node);
+		pthread_cond_signal(cond);
+		pthread_mutex_unlock(&p6_mutex);
+		return;
+	} else {
+		pthread_mutex_unlock(&p6_mutex);
+		return;
+	}
+}
diff -Nru xfsprogs-old/repair/threads.h xfsprogs-new2/repair/threads.h
--- xfsprogs-old/repair/threads.h	1969-12-31 16:00:00.000000000 -0800
+++ xfsprogs-new2/repair/threads.h	2007-01-22 11:32:16.000000000 -0800
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2006-2007 agami Systems, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public 
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Contact information:
+ *  agami Systems, Inc.,
+ *  1269 Innsbruck Drive,
+ *  Sunnyvale, CA  94089, or:
+ *
+ * http://www.agami.com 
+ */ 
+
+/*
+ * There are two kind of objects that are being prefetched right
+ * now namely inode chunks and directory inodes.  Inode chunks
+ * are operated on in phase 3, phase 4, and phase 7.  Phase 6
+ * operates on individual directory inodes.
+ */
+typedef enum nodetype {
+	ICHUNK,
+	IDIR
+} nodetype_t;
+
+typedef struct rahead {
+	nodetype_t     type;
+	union {
+		struct {
+			xfs_daddr_t    blkno;
+			int            len;
+		} ichunk;
+		xfs_ino_t      ino;
+	} u_ra;
+	/*
+	 * setting readdirblks to 1 signifies that the directory
+	 * blocks for the directory inodes within this inode chunk
+	 * should also be read in.
+	 */
+	int            readdirblks;
+} rahead_t;
+
+typedef struct buftype {
+	char	*buf;
+	int	len;
+} buf_t;
+
+void
+start_threads(
+	xfs_mount_t    *mptr);
+
+void
+stop_threads(void);
+
+void
+unblock_threads(void);
+
+void
+wake_if_sleeping(void);
+
+int
+insert_nodes(
+	int		numnodes,
+	int		agno,
+	ino_tree_node_t	**first_ra_recp,
+	ino_tree_node_t	**ra_recp,
+	int		readdirblks,
+	int		chunklen);
+
+extern queue_t    Q;
diff -Nru xfsprogs-old/repair/xfs_repair.c xfsprogs-new2/repair/xfs_repair.c
--- xfsprogs-old/repair/xfs_repair.c	2005-11-11 06:27:22.000000000 -0800
+++ xfsprogs-new2/repair/xfs_repair.c	2007-01-17 14:07:20.000000000 -0800
@@ -25,6 +25,8 @@
 #include "protos.h"
 #include "incore.h"
 #include "err_protos.h"
+#include "queue.h"
+#include "threads.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
@@ -52,6 +54,16 @@
 	"assume_xfs",
 #define PRE_65_BETA	1
 	"fs_is_pre_65_beta",
+#define	IHASH_SIZE	2
+	"ihash",
+#define	BHASH_SIZE	3
+	"bhash",
+#define NUMTHREADS	4
+	"numthreads",
+#define RAHEAD		5
+	"rahead",
+#define RADELTA		6
+	"radelta",
 	NULL
 };
 
@@ -171,6 +183,14 @@
 	fs_has_extflgbit_allowed = 1;
 	pre_65_beta = 0;
 	fs_shared_allowed = 1;
+	/*
+	 * default values of numthreads, rahead, and radelta if not
+	 * overriden by user supplied [-o] suboptions.
+	 */
+	numthreads = 10;
+	rahead = 100;
+	radelta = 10;
+
 
 	/*
 	 * XXX have to add suboption processing here
@@ -202,6 +222,27 @@
 							PRE_65_BETA);
 					pre_65_beta = 1;
 					break;
+				case NUMTHREADS:
+					if (!val)
+		do_error("value for 'numthreads' needs to be specified\n");
+					int inp_numthreads = atoi(val);
+					if (inp_numthreads > numthreads)
+						numthreads = inp_numthreads; 
+					break;
+				case RAHEAD:
+					if (!val)
+			do_error("value for 'rahead' needs to be specified\n");
+					int inp_rahead = atoi(val);
+					if (inp_rahead > rahead)
+						rahead = inp_rahead;
+					break;
+				case RADELTA:
+					if (!val)
+			do_error("value for 'radelta' needs to be specified\n");
+					int inp_radelta = atoi(val);
+					if (inp_radelta > radelta)
+						radelta = inp_radelta;
+					break;
 				default:
 					unknown('o', val);
 					break;
@@ -496,6 +537,9 @@
 
 	phase2(mp);
 
+#if defined(PHASE_3_4) || defined(PHASE_6) || defined(PHASE_7)
+	start_threads(mp);
+#endif
 	phase3(mp);
 
 	phase4(mp);
@@ -513,6 +557,9 @@
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
 	}
+#if defined(PHASE_3_4) || defined(PHASE_6) || defined(PHASE_7)
+	stop_threads();
+#endif
 
 	if (lost_quotas && !have_uquotino && !have_gquotino)  {
 		if (!no_modify)  {

--------------090708000700070403030802--
