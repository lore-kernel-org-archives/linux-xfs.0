Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53438 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbcJUQuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 12:50:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] locking/lockdep: Provide a type check for lock_is_held
Date: Fri, 21 Oct 2016 18:50:05 +0200
Message-Id: <1477068606-21936-2-git-send-email-hch@lst.de>
In-Reply-To: <1477068606-21936-1-git-send-email-hch@lst.de>
References: <1477068606-21936-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: peterz@infradead.org

From: Peter Zijlstra <peterz@infradead.org>

Christoph requested lockdep_assert_held() variants that distinguish
between held-for-read or held-for-write.

Provide:

  int lock_is_held_type(struct lockdep_map *lock, int read)

which takes the same argument as lock_acquire(.read) and matches it to
the held_lock instance.

Use of this function should be gated by the debug_locks variable. When
that is 0 the return value of the lock_is_held_type() function is
undefined. This is done to allow both negative and positive tests for
holding locks.

By default we provide (positive) lockdep_assert_held{,_exclusive,_read}()
macros.

Requested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/lockdep.h  | 23 +++++++++++++++++++++--
 kernel/locking/lockdep.c | 20 ++++++++++++--------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index c1458fe..5b46871 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -338,9 +338,18 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+/*
+ * Same "read" as for lock_acquire(), except -1 means any.
+ */
+extern int lock_is_held_type(struct lockdep_map *lock, int read);
+
+static inline int lock_is_held(struct lockdep_map *lock)
+{
+	return lock_is_held_type(lock, -1);
+}
 
-extern int lock_is_held(struct lockdep_map *lock);
+#define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)
+#define lockdep_is_held_type(lock, r)	lock_is_held_type(&(lock)->dep_map, (r))
 
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
@@ -372,6 +381,14 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 		WARN_ON(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
 
+#define lockdep_assert_held_exclusive(l)	do {			\
+		WARN_ON(debug_locks && !lockdep_is_held_type(l, 0));	\
+	} while (0)
+
+#define lockdep_assert_held_read(l)	do {				\
+		WARN_ON(debug_locks && !lockdep_is_held_type(l, 1));	\
+	} while (0)
+
 #define lockdep_assert_held_once(l)	do {				\
 		WARN_ON_ONCE(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
@@ -429,6 +446,8 @@ struct lock_class_key { };
 #define lockdep_depth(tsk)	(0)
 
 #define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held_exclusive(l)	do { (void)(l); } while (0)
+#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 589d763..cff580a 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3188,7 +3188,7 @@ print_lock_nested_lock_not_held(struct task_struct *curr,
 	return 0;
 }
 
-static int __lock_is_held(struct lockdep_map *lock);
+static int __lock_is_held(struct lockdep_map *lock, int read);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
@@ -3329,7 +3329,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	}
 	chain_key = iterate_chain_key(chain_key, class_idx);
 
-	if (nest_lock && !__lock_is_held(nest_lock))
+	if (nest_lock && !__lock_is_held(nest_lock, -1))
 		return print_lock_nested_lock_not_held(curr, hlock, ip);
 
 	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
@@ -3576,7 +3576,7 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 	return 1;
 }
 
-static int __lock_is_held(struct lockdep_map *lock)
+static int __lock_is_held(struct lockdep_map *lock, int read)
 {
 	struct task_struct *curr = current;
 	int i;
@@ -3584,8 +3584,12 @@ static int __lock_is_held(struct lockdep_map *lock)
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		struct held_lock *hlock = curr->held_locks + i;
 
-		if (match_held_lock(hlock, lock))
-			return 1;
+		if (match_held_lock(hlock, lock)) {
+			if (read == -1 || hlock->read == read)
+				return 1;
+
+			return 0;
+		}
 	}
 
 	return 0;
@@ -3769,7 +3773,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
-int lock_is_held(struct lockdep_map *lock)
+int lock_is_held_type(struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -3781,13 +3785,13 @@ int lock_is_held(struct lockdep_map *lock)
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
-	ret = __lock_is_held(lock);
+	ret = __lock_is_held(lock, read);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lock_is_held);
+EXPORT_SYMBOL_GPL(lock_is_held_type);
 
 struct pin_cookie lock_pin_lock(struct lockdep_map *lock)
 {
-- 
2.1.4

