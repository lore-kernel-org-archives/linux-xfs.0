Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:47598 "EHLO
        lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932467AbdJYI4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 04:56:33 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 7/9] completion: Add support for initializing completion with lockdep_map
Date: Wed, 25 Oct 2017 17:56:03 +0900
Message-Id: <1508921765-15396-8-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
References: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org, axboe@kernel.dk
Cc: johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

Sometimes, we want to initialize completions with sparate lockdep maps
to assign lock classes as desired. For example, the workqueue code
needs to directly manage lockdep maps, since only the code is aware of
how to classify lockdep maps properly.

Provide additional macros initializing completions in that way.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 include/linux/completion.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 9121803..4da4991 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -49,6 +49,13 @@ static inline void complete_release_commit(struct completion *x)
 	lock_commit_crosslock((struct lockdep_map *)&x->map);
 }
 
+#define init_completion_map(x, m)					\
+do {									\
+	lockdep_init_map_crosslock((struct lockdep_map *)&(x)->map,	\
+			(m)->name, (m)->key, 0);				\
+	__init_completion(x);						\
+} while (0)
+
 #define init_completion(x)						\
 do {									\
 	static struct lock_class_key __key;				\
@@ -58,6 +65,7 @@ static inline void complete_release_commit(struct completion *x)
 	__init_completion(x);						\
 } while (0)
 #else
+#define init_completion_map(x, m) __init_completion(x)
 #define init_completion(x) __init_completion(x)
 static inline void complete_acquire(struct completion *x) {}
 static inline void complete_release(struct completion *x) {}
@@ -73,6 +81,9 @@ static inline void complete_release_commit(struct completion *x) {}
 	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
 #endif
 
+#define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
+	(*({ init_completion_map(&(work), &(map)); &(work); }))
+
 #define COMPLETION_INITIALIZER_ONSTACK(work) \
 	(*({ init_completion(&work); &work; }))
 
@@ -102,8 +113,11 @@ static inline void complete_release_commit(struct completion *x) {}
 #ifdef CONFIG_LOCKDEP
 # define DECLARE_COMPLETION_ONSTACK(work) \
 	struct completion work = COMPLETION_INITIALIZER_ONSTACK(work)
+# define DECLARE_COMPLETION_ONSTACK_MAP(work, map) \
+	struct completion work = COMPLETION_INITIALIZER_ONSTACK_MAP(work, map)
 #else
 # define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
+# define DECLARE_COMPLETION_ONSTACK_MAP(work, map) DECLARE_COMPLETION(work)
 #endif
 
 /**
-- 
1.9.1

