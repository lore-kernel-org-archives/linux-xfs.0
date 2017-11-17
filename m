Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29942 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdKQUOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:14:12 -0500
Subject: [PATCH 06/12] libfrog: create a threaded workqueue
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:14:07 -0800
Message-ID: <151094964785.29763.1548614345004906846.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a thread pool that queues and runs discrete work items.  This
will be a namespaced version of the pool in repair/threads.c; a
subsequent patch will switch repair over.  xfs_scrub will use the
generic thread pool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/workqueue.h |   55 ++++++++++++++++
 libfrog/Makefile    |    3 +
 libfrog/workqueue.c |  177 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 include/workqueue.h
 create mode 100644 libfrog/workqueue.c


diff --git a/include/workqueue.h b/include/workqueue.h
new file mode 100644
index 0000000..b4b3541
--- /dev/null
+++ b/include/workqueue.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * This code was adapted from repair/threads.h.
+ */
+#ifndef	_WORKQUEUE_H_
+#define	_WORKQUEUE_H_
+
+struct workqueue;
+
+typedef void workqueue_func_t(struct workqueue *wq, uint32_t index, void *arg);
+
+struct workqueue_item {
+	struct workqueue	*queue;
+	struct workqueue_item	*next;
+	workqueue_func_t	*function;
+	void			*arg;
+	uint32_t		index;
+};
+
+struct workqueue {
+	void			*wq_ctx;
+	pthread_t		*threads;
+	struct workqueue_item	*next_item;
+	struct workqueue_item	*last_item;
+	pthread_mutex_t		lock;
+	pthread_cond_t		wakeup;
+	unsigned int		item_count;
+	unsigned int		thread_count;
+	bool			terminate;
+};
+
+int workqueue_create(struct workqueue *wq, void *wq_ctx,
+		unsigned int nr_workers);
+int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
+		uint32_t index, void *arg);
+void workqueue_destroy(struct workqueue *wq);
+
+#endif	/* _WORKQUEUE_H_ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 3fd42a4..9a43621 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -14,7 +14,8 @@ CFILES = \
 avl64.c \
 list_sort.c \
 radix-tree.c \
-util.c
+util.c \
+workqueue.c
 
 default: ltdepend $(LTLIBRARY)
 
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
new file mode 100644
index 0000000..d9217de
--- /dev/null
+++ b/libfrog/workqueue.c
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * This code was adapted from repair/threads.c.
+ */
+#include <pthread.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include "workqueue.h"
+
+/* Main processing thread */
+static void *
+workqueue_thread(void *arg)
+{
+	struct workqueue	*wq;
+	struct workqueue_item	*wi;
+
+	wq = (struct workqueue*)arg;
+
+	/*
+	 * Loop pulling work from the passed in work queue.
+	 * Check for notification to exit after every chunk of work.
+	 */
+	while (1) {
+		pthread_mutex_lock(&wq->lock);
+
+		/*
+		 * Wait for work.
+		 */
+		while (wq->next_item == NULL && !wq->terminate) {
+			assert(wq->item_count == 0);
+			pthread_cond_wait(&wq->wakeup, &wq->lock);
+		}
+		if (wq->next_item == NULL && wq->terminate) {
+			pthread_mutex_unlock(&wq->lock);
+			break;
+		}
+
+		/*
+		 *  Dequeue work from the head of the list.
+		 */
+		assert(wq->item_count > 0);
+		wi = wq->next_item;
+		wq->next_item = wi->next;
+		wq->item_count--;
+
+		pthread_mutex_unlock(&wq->lock);
+
+		(wi->function)(wi->queue, wi->index, wi->arg);
+		free(wi);
+	}
+
+	return NULL;
+}
+
+/* Allocate a work queue and threads. */
+int
+workqueue_create(
+	struct workqueue	*wq,
+	void			*wq_ctx,
+	unsigned int		nr_workers)
+{
+	unsigned int		i;
+	int			err = 0;
+
+	memset(wq, 0, sizeof(*wq));
+	pthread_cond_init(&wq->wakeup, NULL);
+	pthread_mutex_init(&wq->lock, NULL);
+
+	wq->wq_ctx = wq_ctx;
+	wq->thread_count = nr_workers;
+	wq->threads = malloc(nr_workers * sizeof(pthread_t));
+	wq->terminate = false;
+
+	for (i = 0; i < nr_workers; i++) {
+		err = pthread_create(&wq->threads[i], NULL, workqueue_thread,
+				wq);
+		if (err)
+			break;
+	}
+
+	if (err)
+		workqueue_destroy(wq);
+	return err;
+}
+
+/*
+ * Create a work item consisting of a function and some arguments and
+ * schedule the work item to be run via the thread pool.
+ */
+int
+workqueue_add(
+	struct workqueue	*wq,
+	workqueue_func_t	func,
+	uint32_t		index,
+	void			*arg)
+{
+	struct workqueue_item	*wi;
+
+	if (wq->thread_count == 0) {
+		func(wq, index, arg);
+		return 0;
+	}
+
+	wi = malloc(sizeof(struct workqueue_item));
+	if (wi == NULL)
+		return ENOMEM;
+
+	wi->function = func;
+	wi->index = index;
+	wi->arg = arg;
+	wi->queue = wq;
+	wi->next = NULL;
+
+	/*
+	 *  Now queue the new work structure to the work queue.
+	 */
+	pthread_mutex_lock(&wq->lock);
+	if (wq->next_item == NULL) {
+		wq->next_item = wi;
+		assert(wq->item_count == 0);
+		pthread_cond_signal(&wq->wakeup);
+	} else {
+		wq->last_item->next = wi;
+	}
+	wq->last_item = wi;
+	wq->item_count++;
+	pthread_mutex_unlock(&wq->lock);
+
+	return 0;
+}
+
+/*
+ * Wait for all pending work items to be processed and tear down the
+ * workqueue.
+ */
+void
+workqueue_destroy(
+	struct workqueue	*wq)
+{
+	unsigned int		i;
+
+	pthread_mutex_lock(&wq->lock);
+	wq->terminate = 1;
+	pthread_mutex_unlock(&wq->lock);
+
+	pthread_cond_broadcast(&wq->wakeup);
+
+	for (i = 0; i < wq->thread_count; i++)
+		pthread_join(wq->threads[i], NULL);
+
+	free(wq->threads);
+	pthread_mutex_destroy(&wq->lock);
+	pthread_cond_destroy(&wq->wakeup);
+	memset(wq, 0, sizeof(*wq));
+}

