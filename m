Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42383 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966646AbdKQVBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:38 -0500
Subject: [PATCH 14/27] xfs_scrub: thread-safe stats counter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:33 -0800
Message-ID: <151095249367.4825.13078449139829472130.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a threaded stats counter that we'll use to track scan progress.
This includes things like how much of the disk blocks we've scanned,
or later how much progress we've made in each phase.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/ptvar.h  |   32 +++++++++++++
 libfrog/Makefile |    1 
 libfrog/ptvar.c  |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/Makefile   |    2 +
 scrub/counter.c  |  104 ++++++++++++++++++++++++++++++++++++++++++
 scrub/counter.h  |   29 ++++++++++++
 6 files changed, 301 insertions(+)
 create mode 100644 include/ptvar.h
 create mode 100644 libfrog/ptvar.c
 create mode 100644 scrub/counter.c
 create mode 100644 scrub/counter.h


diff --git a/include/ptvar.h b/include/ptvar.h
new file mode 100644
index 0000000..52d03a5
--- /dev/null
+++ b/include/ptvar.h
@@ -0,0 +1,32 @@
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
+ */
+#ifndef LIBFROG_PERCPU_H_
+#define LIBFROG_PERCPU_H_
+
+struct ptvar;
+
+typedef bool (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
+
+struct ptvar *ptvar_init(size_t nr, size_t size);
+void ptvar_free(struct ptvar *ptv);
+void *ptvar_get(struct ptvar *ptv);
+bool ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
+
+#endif /* LIBFROG_PERCPU_H_ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 4c15605..230b08f 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -16,6 +16,7 @@ convert.c \
 list_sort.c \
 paths.c \
 projects.c \
+ptvar.c \
 radix-tree.c \
 topology.c \
 util.c \
diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
new file mode 100644
index 0000000..818667c
--- /dev/null
+++ b/libfrog/ptvar.c
@@ -0,0 +1,133 @@
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
+ */
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <assert.h>
+#include <pthread.h>
+#include <unistd.h>
+#include "platform_defs.h"
+#include "ptvar.h"
+
+/*
+ * Per-thread Variables
+ *
+ * This data structure manages a lockless per-thread variable.  We
+ * implement this by allocating an array of memory regions, and as each
+ * thread tries to acquire its own region, we hand out the array
+ * elements to each thread.  This way, each thread gets its own
+ * cacheline and (after the first access) doesn't have to contend for a
+ * lock for each access.
+ */
+struct ptvar {
+	pthread_key_t	key;
+	pthread_mutex_t	lock;
+	size_t		nr_used;
+	size_t		nr_counters;
+	size_t		data_size;
+	unsigned char	data[0];
+};
+#define PTVAR_SIZE(nr, sz) (sizeof(struct ptvar) + ((nr) * (size)))
+
+/* Initialize per-thread counter. */
+struct ptvar *
+ptvar_init(
+	size_t		nr,
+	size_t		size)
+{
+	struct ptvar	*ptv;
+	int		ret;
+
+#ifdef _SC_LEVEL1_DCACHE_LINESIZE
+	/* Try to prevent cache pingpong by aligning to cacheline size. */
+	size = max(size, sysconf(_SC_LEVEL1_DCACHE_LINESIZE));
+#endif
+
+	ptv = malloc(PTVAR_SIZE(nr, size));
+	if (!ptv)
+		return NULL;
+	ptv->data_size = size;
+	ptv->nr_counters = nr;
+	ptv->nr_used = 0;
+	memset(ptv->data, 0, nr * size);
+	ret = pthread_mutex_init(&ptv->lock, NULL);
+	if (ret)
+		goto out;
+	ret = pthread_key_create(&ptv->key, NULL);
+	if (ret)
+		goto out_mutex;
+	return ptv;
+
+out_mutex:
+	pthread_mutex_destroy(&ptv->lock);
+out:
+	free(ptv);
+	return NULL;
+}
+
+/* Free per-thread counter. */
+void
+ptvar_free(
+	struct ptvar	*ptv)
+{
+	pthread_key_delete(ptv->key);
+	pthread_mutex_destroy(&ptv->lock);
+	free(ptv);
+}
+
+/* Get a reference to this thread's variable. */
+void *
+ptvar_get(
+	struct ptvar	*ptv)
+{
+	void		*p;
+
+	p = pthread_getspecific(ptv->key);
+	if (!p) {
+		pthread_mutex_lock(&ptv->lock);
+		assert(ptv->nr_used < ptv->nr_counters);
+		p = &ptv->data[(ptv->nr_used++) * ptv->data_size];
+		pthread_setspecific(ptv->key, p);
+		pthread_mutex_unlock(&ptv->lock);
+	}
+	return p;
+}
+
+/* Iterate all of the per-thread variables. */
+bool
+ptvar_foreach(
+	struct ptvar	*ptv,
+	ptvar_iter_fn	fn,
+	void		*foreach_arg)
+{
+	size_t		i;
+	bool		ret = true;
+
+	pthread_mutex_lock(&ptv->lock);
+	for (i = 0; i < ptv->nr_used; i++) {
+		ret = fn(ptv, &ptv->data[i * ptv->data_size], foreach_arg);
+		if (!ret)
+			break;
+	}
+	pthread_mutex_unlock(&ptv->lock);
+
+	return ret;
+}
diff --git a/scrub/Makefile b/scrub/Makefile
index b63fd92..71d80fb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -17,6 +17,7 @@ endif	# scrub_prereqs
 
 HFILES = \
 common.h \
+counter.h \
 disk.h \
 filemap.h \
 fscounters.h \
@@ -27,6 +28,7 @@ xfs_scrub.h
 
 CFILES = \
 common.c \
+counter.c \
 disk.c \
 filemap.c \
 fscounters.c \
diff --git a/scrub/counter.c b/scrub/counter.c
new file mode 100644
index 0000000..b503f7a
--- /dev/null
+++ b/scrub/counter.c
@@ -0,0 +1,104 @@
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
+ */
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <assert.h>
+#include <pthread.h>
+#include "ptvar.h"
+#include "counter.h"
+
+/*
+ * Per-Thread Counters
+ *
+ * This is a global counter object that uses per-thread counters to
+ * count things without having to content for a single shared lock.
+ * Provided we know the number of threads that will be accessing the
+ * counter, each thread gets its own thread-specific counter variable.
+ * Changing the value is fast, though retrieving the value is expensive
+ * and approximate.
+ */
+struct ptcounter {
+	struct ptvar	*var;
+};
+
+/* Initialize per-thread counter. */
+struct ptcounter *
+ptcounter_init(
+	size_t			nr)
+{
+	struct ptcounter	*p;
+
+	p = malloc(sizeof(struct ptcounter));
+	if (!p)
+		return NULL;
+	p->var = ptvar_init(nr, sizeof(uint64_t));
+	if (!p->var) {
+		free(p);
+		return NULL;
+	}
+	return p;
+}
+
+/* Free per-thread counter. */
+void
+ptcounter_free(
+	struct ptcounter	*ptc)
+{
+	ptvar_free(ptc->var);
+	free(ptc);
+}
+
+/* Add a quantity to the counter. */
+void
+ptcounter_add(
+	struct ptcounter	*ptc,
+	int64_t			nr)
+{
+	uint64_t		*p;
+
+	p = ptvar_get(ptc->var);
+	*p += nr;
+}
+
+static bool
+ptcounter_val_helper(
+	struct ptvar		*ptv,
+	void			*data,
+	void			*foreach_arg)
+{
+	uint64_t		*sum = foreach_arg;
+	uint64_t		*count = data;
+
+	*sum += *count;
+	return true;
+}
+
+/* Return the approximate value of this counter. */
+uint64_t
+ptcounter_value(
+	struct ptcounter	*ptc)
+{
+	uint64_t		sum = 0;
+
+	ptvar_foreach(ptc->var, ptcounter_val_helper, &sum);
+	return sum;
+}
diff --git a/scrub/counter.h b/scrub/counter.h
new file mode 100644
index 0000000..f6225b2
--- /dev/null
+++ b/scrub/counter.h
@@ -0,0 +1,29 @@
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
+ */
+#ifndef XFS_SCRUB_COUNTER_H_
+#define XFS_SCRUB_COUNTER_H_
+
+struct ptcounter;
+struct ptcounter *ptcounter_init(size_t nr);
+void ptcounter_free(struct ptcounter *ptc);
+void ptcounter_add(struct ptcounter *ptc, int64_t nr);
+uint64_t ptcounter_value(struct ptcounter *ptc);
+
+#endif /* XFS_SCRUB_COUNTER_H_ */

