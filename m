Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25392 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:43 -0400
Subject: [PATCH 10/22] xfs_scrub: thread-safe stats counter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:37 -0700
Message-ID: <150180531765.18784.15201552114192169638.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a threaded stats counter that we'll use to track scan progress.
This includes things like how much of the disk blocks we've scanned,
or later how much progress we've made in each phase.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile  |    2 +
 scrub/counter.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/counter.h |   29 +++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 scrub/counter.c
 create mode 100644 scrub/counter.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 13a0b55..deb352b 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,6 +18,7 @@ endif	# scrub_prereqs
 HFILES = \
 ../repair/threads.h \
 common.h \
+counter.h \
 disk.h \
 ioctl.h \
 scrub.h \
@@ -26,6 +27,7 @@ xfs.h
 CFILES = \
 ../repair/threads.c \
 common.c \
+counter.c \
 disk.c \
 ioctl.c \
 phase1.c \
diff --git a/scrub/counter.c b/scrub/counter.c
new file mode 100644
index 0000000..1aae0a3
--- /dev/null
+++ b/scrub/counter.c
@@ -0,0 +1,122 @@
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
+#include "libxfs.h"
+#include <stdio.h>
+#include <dirent.h>
+#include <sys/statvfs.h>
+#include <math.h>
+#include "../repair/threads.h"
+#include "path.h"
+#include "disk.h"
+#include "scrub.h"
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
+	pthread_key_t	key;
+	pthread_mutex_t	lock;
+	size_t		nr_used;
+	size_t		nr_counters;
+	uint64_t	counters[0];
+};
+#define PTCOUNTER_SIZE(nr) (sizeof(struct ptcounter) + sizeof(uint64_t) * (nr))
+
+/* Initialize per-thread counter. */
+struct ptcounter *
+ptcounter_init(
+	size_t			nr)
+{
+	struct ptcounter	*p;
+	int			ret;
+
+	p = malloc(PTCOUNTER_SIZE(nr));
+	if (!p)
+		return NULL;
+	p->nr_counters = nr;
+	p->nr_used = 0;
+	memset(p->counters, 0, sizeof(uint64_t) * nr);
+	ret = pthread_mutex_init(&p->lock, NULL);
+	if (ret)
+		goto out;
+	ret = pthread_key_create(&p->key, NULL);
+	if (ret)
+		goto out_mutex;
+	return p;
+
+out_mutex:
+	pthread_mutex_destroy(&p->lock);
+out:
+	free(p);
+	return NULL;
+}
+
+/* Free per-thread counter. */
+void
+ptcounter_free(
+	struct ptcounter	*ptc)
+{
+	pthread_key_delete(ptc->key);
+	pthread_mutex_destroy(&ptc->lock);
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
+	p = pthread_getspecific(ptc->key);
+	if (!p) {
+		pthread_mutex_lock(&ptc->lock);
+		assert(ptc->nr_used < ptc->nr_counters);
+		p = &ptc->counters[ptc->nr_used++];
+		pthread_setspecific(ptc->key, p);
+		pthread_mutex_unlock(&ptc->lock);
+	}
+	*p += nr;
+}
+
+/* Return the approximate value of this counter. */
+uint64_t
+ptcounter_value(
+	struct ptcounter	*ptc)
+{
+	size_t			i;
+	uint64_t		sum = 0;
+
+	pthread_mutex_lock(&ptc->lock);
+	for (i = 0; i < ptc->nr_used; i++)
+		sum += ptc->counters[i];
+	pthread_mutex_unlock(&ptc->lock);
+
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

