Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E7427CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 10:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64288304032
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 08:12:52 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id GCKftaN8C0lFmDfl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 08:12:46 -0700 (PDT)
Date: Mon, 5 Sep 2016 17:12:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160905151244.GA16726@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
	<20160819132736.GH10121@twins.programming.kicks-ass.net>
	<20160820063723.GA7013@lst.de>
	<20160822083455.GH10153@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822083455.GH10153@twins.programming.kicks-ass.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Peter, this is the fixed up patch.  Can you write a proper changelog
and add your signoff?

---
 include/linux/lockdep.h  | 18 ++++++++++++++++--
 kernel/locking/lockdep.c | 43 ++++++++++++++++++++++++++-----------------
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index eabe013..4cef9f8 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -338,9 +338,15 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+extern int _lock_is_held(struct lockdep_map *lock, int read);
 
-extern int lock_is_held(struct lockdep_map *lock);
+static inline int lock_is_held(struct lockdep_map *lock)
+{
+	return _lock_is_held(lock, -1);
+}
+
+#define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)
+#define _lockdep_is_held(lock, r)	_lock_is_held(&(lock)->dep_map, (r))
 
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
@@ -372,6 +378,14 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 		WARN_ON(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
 
+#define lockdep_assert_held_exclusive(l)	do {		\
+		WARN_ON(debug_locks && !_lockdep_is_held(l, 0));\
+	} while (0)
+
+#define lockdep_assert_held_read(l)	do {			\
+		WARN_ON(debug_locks && !_lockdep_is_held(l, 1));\
+	} while (0)
+
 #define lockdep_assert_held_once(l)	do {				\
 		WARN_ON_ONCE(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 589d763..f39573b 100644
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
@@ -3390,10 +3390,17 @@ print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	return 0;
 }
 
-static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
+static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock, int read)
 {
-	if (hlock->instance == lock)
-		return 1;
+	if (hlock->instance == lock) {
+		if (read == -1)
+			return 1;
+
+		if (hlock->read == read)
+			return 1;
+
+		return 0;
+	}
 
 	if (hlock->references) {
 		struct lock_class *class = lock->class_cache[0];
@@ -3420,6 +3427,8 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 
 		if (hlock->class_idx == class - lock_classes + 1)
 			return 1;
+
+		/* XXX do we want @read stuff for nested locks !? */
 	}
 
 	return 0;
@@ -3452,7 +3461,7 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (match_held_lock(hlock, lock))
+		if (match_held_lock(hlock, lock, -1))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3523,7 +3532,7 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (match_held_lock(hlock, lock))
+		if (match_held_lock(hlock, lock, -1))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3576,7 +3585,7 @@ found_it:
 	return 1;
 }
 
-static int __lock_is_held(struct lockdep_map *lock)
+static int __lock_is_held(struct lockdep_map *lock, int read)
 {
 	struct task_struct *curr = current;
 	int i;
@@ -3584,7 +3593,7 @@ static int __lock_is_held(struct lockdep_map *lock)
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		struct held_lock *hlock = curr->held_locks + i;
 
-		if (match_held_lock(hlock, lock))
+		if (match_held_lock(hlock, lock, read))
 			return 1;
 	}
 
@@ -3603,7 +3612,7 @@ static struct pin_cookie __lock_pin_lock(struct lockdep_map *lock)
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		struct held_lock *hlock = curr->held_locks + i;
 
-		if (match_held_lock(hlock, lock)) {
+		if (match_held_lock(hlock, lock, -1)) {
 			/*
 			 * Grab 16bits of randomness; this is sufficient to not
 			 * be guessable and still allows some pin nesting in
@@ -3630,7 +3639,7 @@ static void __lock_repin_lock(struct lockdep_map *lock, struct pin_cookie cookie
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		struct held_lock *hlock = curr->held_locks + i;
 
-		if (match_held_lock(hlock, lock)) {
+		if (match_held_lock(hlock, lock, -1)) {
 			hlock->pin_count += cookie.val;
 			return;
 		}
@@ -3650,7 +3659,7 @@ static void __lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		struct held_lock *hlock = curr->held_locks + i;
 
-		if (match_held_lock(hlock, lock)) {
+		if (match_held_lock(hlock, lock, -1)) {
 			if (WARN(!hlock->pin_count, "unpinning an unpinned lock\n"))
 				return;
 
@@ -3769,7 +3778,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
-int lock_is_held(struct lockdep_map *lock)
+int _lock_is_held(struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -3781,13 +3790,13 @@ int lock_is_held(struct lockdep_map *lock)
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
-	ret = __lock_is_held(lock);
+	ret = __lock_is_held(lock, read);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lock_is_held);
+EXPORT_SYMBOL_GPL(_lock_is_held);
 
 struct pin_cookie lock_pin_lock(struct lockdep_map *lock)
 {
@@ -3908,7 +3917,7 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (match_held_lock(hlock, lock))
+		if (match_held_lock(hlock, lock, -1))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3961,7 +3970,7 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (match_held_lock(hlock, lock))
+		if (match_held_lock(hlock, lock, -1))
 			goto found_it;
 		prev_hlock = hlock;
 	}
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
