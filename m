Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40695 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeEVCUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 22:20:08 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] [RFC] bcachefs: SIX locks (shared/intent/exclusive)
Date: Mon, 21 May 2018 22:19:51 -0400
Message-Id: <20180522021951.1453-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>

New lock for bcachefs, like read/write locks but with a third state,
intent.

Intent locks conflict with each other, but not with read locks; taking a
write lock requires first holding an intent lock.

The purpose is for multi node data structures (i.e. btrees), where if we were
using read/write locks we might need to hold a write lock for the duration of an
operation purely to avoid deadlocks.

For example, when splitting a btree node we lock a leaf node, allocate two new
nodes, copy the contents of the old node into the new nodes, then update the
parent node. With read write locks, we'd need to hold a write lock on the parent
node for the entire duration, because if we don't take it until we have to
update the parent we deadlock - because we still have a child locked - and we
can't unlock the child, because we need to free it as soon as we've deleted the
pointer to it. This blocks not only lookups, but updates that would only touch
unrelated leaf nodes.

With intent locks, we can hold an intent lock on the parent node for the
duration of the operation, only taking a write lock on it for the update to that
specific node.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---

I implemented these for bcachefs's btrees, but they're really not bcachefs
specific - I figure since I don't have the only btree implementation it might be
worth at least seeing if anyone else sees a use for them.

Also, they use osq_lock()/unlock(), which Peter Zijlstra really doesn't want
exported, so if anyone else would like to use them they could be moved out of
fs/bcachefs/ and that would solve another problem for me :)

 fs/bcachefs/six.c | 516 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/bcachefs/six.h | 190 +++++++++++++++++
 2 files changed, 706 insertions(+)
 create mode 100644 fs/bcachefs/six.c
 create mode 100644 fs/bcachefs/six.h

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
new file mode 100644
index 0000000000..afa59a476a
--- /dev/null
+++ b/fs/bcachefs/six.c
@@ -0,0 +1,516 @@
+
+#include <linux/log2.h>
+#include <linux/preempt.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
+
+#include "six.h"
+
+#define six_acquire(l, t)	lock_acquire(l, 0, t, 0, 0, NULL, _RET_IP_)
+#define six_release(l)		lock_release(l, 0, _RET_IP_)
+
+struct six_lock_vals {
+	/* Value we add to the lock in order to take the lock: */
+	u64			lock_val;
+
+	/* If the lock has this value (used as a mask), taking the lock fails: */
+	u64			lock_fail;
+
+	/* Value we add to the lock in order to release the lock: */
+	u64			unlock_val;
+
+	/* Mask that indicates lock is held for this type: */
+	u64			held_mask;
+
+	/* Waitlist we wakeup when releasing the lock: */
+	enum six_lock_type	unlock_wakeup;
+};
+
+#define __SIX_LOCK_HELD_read	__SIX_VAL(read_lock, ~0)
+#define __SIX_LOCK_HELD_intent	__SIX_VAL(intent_lock, ~0)
+#define __SIX_LOCK_HELD_write	__SIX_VAL(seq, 1)
+
+#define LOCK_VALS {							\
+	[SIX_LOCK_read] = {						\
+		.lock_val	= __SIX_VAL(read_lock, 1),		\
+		.lock_fail	= __SIX_LOCK_HELD_write,		\
+		.unlock_val	= -__SIX_VAL(read_lock, 1),		\
+		.held_mask	= __SIX_LOCK_HELD_read,			\
+		.unlock_wakeup	= SIX_LOCK_write,			\
+	},								\
+	[SIX_LOCK_intent] = {						\
+		.lock_val	= __SIX_VAL(intent_lock, 1),		\
+		.lock_fail	= __SIX_LOCK_HELD_intent,		\
+		.unlock_val	= -__SIX_VAL(intent_lock, 1),		\
+		.held_mask	= __SIX_LOCK_HELD_intent,		\
+		.unlock_wakeup	= SIX_LOCK_intent,			\
+	},								\
+	[SIX_LOCK_write] = {						\
+		.lock_val	= __SIX_VAL(seq, 1),			\
+		.lock_fail	= __SIX_LOCK_HELD_read,			\
+		.unlock_val	= __SIX_VAL(seq, 1),			\
+		.held_mask	= __SIX_LOCK_HELD_write,		\
+		.unlock_wakeup	= SIX_LOCK_read,			\
+	},								\
+}
+
+static inline void six_set_owner(struct six_lock *lock, enum six_lock_type type,
+				 union six_lock_state old)
+{
+	if (type != SIX_LOCK_intent)
+		return;
+
+	if (!old.intent_lock) {
+		EBUG_ON(lock->owner);
+		lock->owner = current;
+	} else {
+		EBUG_ON(lock->owner != current);
+	}
+}
+
+static inline void six_clear_owner(struct six_lock *lock, enum six_lock_type type)
+{
+	if (type != SIX_LOCK_intent)
+		return;
+
+	EBUG_ON(lock->owner != current);
+
+	if (lock->state.intent_lock == 1)
+		lock->owner = NULL;
+}
+
+static __always_inline bool do_six_trylock_type(struct six_lock *lock,
+						enum six_lock_type type)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+	union six_lock_state old;
+	u64 v = READ_ONCE(lock->state.v);
+
+	EBUG_ON(type == SIX_LOCK_write && lock->owner != current);
+
+	do {
+		old.v = v;
+
+		EBUG_ON(type == SIX_LOCK_write &&
+			((old.v & __SIX_LOCK_HELD_write) ||
+			 !(old.v & __SIX_LOCK_HELD_intent)));
+
+		if (old.v & l[type].lock_fail)
+			return false;
+	} while ((v = atomic64_cmpxchg_acquire(&lock->state.counter,
+				old.v,
+				old.v + l[type].lock_val)) != old.v);
+
+	six_set_owner(lock, type, old);
+	return true;
+}
+
+__always_inline __flatten
+static bool __six_trylock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	if (!do_six_trylock_type(lock, type))
+		return false;
+
+	six_acquire(&lock->dep_map, 1);
+	return true;
+}
+
+__always_inline __flatten
+static bool __six_relock_type(struct six_lock *lock, enum six_lock_type type,
+			      unsigned seq)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+	union six_lock_state old;
+	u64 v = READ_ONCE(lock->state.v);
+
+	do {
+		old.v = v;
+
+		if (old.seq != seq || old.v & l[type].lock_fail)
+			return false;
+	} while ((v = atomic64_cmpxchg_acquire(&lock->state.counter,
+				old.v,
+				old.v + l[type].lock_val)) != old.v);
+
+	six_set_owner(lock, type, old);
+	six_acquire(&lock->dep_map, 1);
+	return true;
+}
+
+struct six_lock_waiter {
+	struct list_head	list;
+	struct task_struct	*task;
+};
+
+/* This is probably up there with the more evil things I've done */
+#define waitlist_bitnr(id) ilog2((((union six_lock_state) { .waiters = 1 << (id) }).l))
+
+#ifdef CONFIG_LOCK_SPIN_ON_OWNER
+
+static inline int six_can_spin_on_owner(struct six_lock *lock)
+{
+	struct task_struct *owner;
+	int retval = 1;
+
+	if (need_resched())
+		return 0;
+
+	rcu_read_lock();
+	owner = READ_ONCE(lock->owner);
+	if (owner)
+		retval = owner->on_cpu;
+	rcu_read_unlock();
+	/*
+	 * if lock->owner is not set, the mutex owner may have just acquired
+	 * it and not set the owner yet or the mutex has been released.
+	 */
+	return retval;
+}
+
+static inline bool six_spin_on_owner(struct six_lock *lock,
+				     struct task_struct *owner)
+{
+	bool ret = true;
+
+	rcu_read_lock();
+	while (lock->owner == owner) {
+		/*
+		 * Ensure we emit the owner->on_cpu, dereference _after_
+		 * checking lock->owner still matches owner. If that fails,
+		 * owner might point to freed memory. If it still matches,
+		 * the rcu_read_lock() ensures the memory stays valid.
+		 */
+		barrier();
+
+		if (!owner->on_cpu || need_resched()) {
+			ret = false;
+			break;
+		}
+
+		cpu_relax();
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline bool six_optimistic_spin(struct six_lock *lock, enum six_lock_type type)
+{
+	struct task_struct *task = current;
+
+	if (type == SIX_LOCK_write)
+		return false;
+
+	preempt_disable();
+	if (!six_can_spin_on_owner(lock))
+		goto fail;
+
+	if (!osq_lock(&lock->osq))
+		goto fail;
+
+	while (1) {
+		struct task_struct *owner;
+
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = READ_ONCE(lock->owner);
+		if (owner && !six_spin_on_owner(lock, owner))
+			break;
+
+		if (do_six_trylock_type(lock, type)) {
+			osq_unlock(&lock->osq);
+			preempt_enable();
+			return true;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax();
+	}
+
+	osq_unlock(&lock->osq);
+fail:
+	preempt_enable();
+
+	/*
+	 * If we fell out of the spin path because of need_resched(),
+	 * reschedule now, before we try-lock again. This avoids getting
+	 * scheduled out right after we obtained the lock.
+	 */
+	if (need_resched())
+		schedule();
+
+	return false;
+}
+
+#else /* CONFIG_LOCK_SPIN_ON_OWNER */
+
+static inline bool six_optimistic_spin(struct six_lock *lock, enum six_lock_type type)
+{
+	return false;
+}
+
+#endif
+
+noinline
+static void __six_lock_type_slowpath(struct six_lock *lock, enum six_lock_type type)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+	union six_lock_state old, new;
+	struct six_lock_waiter wait;
+	u64 v;
+
+	if (six_optimistic_spin(lock, type))
+		return;
+
+	lock_contended(&lock->dep_map, _RET_IP_);
+
+	INIT_LIST_HEAD(&wait.list);
+	wait.task = current;
+
+	while (1) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (type == SIX_LOCK_write)
+			EBUG_ON(lock->owner != current);
+		else if (list_empty_careful(&wait.list)) {
+			raw_spin_lock(&lock->wait_lock);
+			list_add_tail(&wait.list, &lock->wait_list[type]);
+			raw_spin_unlock(&lock->wait_lock);
+		}
+
+		v = READ_ONCE(lock->state.v);
+		do {
+			new.v = old.v = v;
+
+			if (!(old.v & l[type].lock_fail))
+				new.v += l[type].lock_val;
+			else if (!(new.waiters & (1 << type)))
+				new.waiters |= 1 << type;
+			else
+				break; /* waiting bit already set */
+		} while ((v = atomic64_cmpxchg_acquire(&lock->state.counter,
+					old.v, new.v)) != old.v);
+
+		if (!(old.v & l[type].lock_fail))
+			break;
+
+		schedule();
+	}
+
+	six_set_owner(lock, type, old);
+
+	__set_current_state(TASK_RUNNING);
+
+	if (!list_empty_careful(&wait.list)) {
+		raw_spin_lock(&lock->wait_lock);
+		list_del_init(&wait.list);
+		raw_spin_unlock(&lock->wait_lock);
+	}
+}
+
+__always_inline
+static void __six_lock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	six_acquire(&lock->dep_map, 0);
+
+	if (!do_six_trylock_type(lock, type))
+		__six_lock_type_slowpath(lock, type);
+
+	lock_acquired(&lock->dep_map, _RET_IP_);
+}
+
+static inline void six_lock_wakeup(struct six_lock *lock,
+				   union six_lock_state state,
+				   unsigned waitlist_id)
+{
+	struct list_head *wait_list = &lock->wait_list[waitlist_id];
+	struct six_lock_waiter *w, *next;
+
+	if (waitlist_id == SIX_LOCK_write && state.read_lock)
+		return;
+
+	if (!(state.waiters & (1 << waitlist_id)))
+		return;
+
+	clear_bit(waitlist_bitnr(waitlist_id),
+		  (unsigned long *) &lock->state.v);
+
+	if (waitlist_id == SIX_LOCK_write) {
+		struct task_struct *p = READ_ONCE(lock->owner);
+
+		if (p)
+			wake_up_process(p);
+		return;
+	}
+
+	raw_spin_lock(&lock->wait_lock);
+
+	list_for_each_entry_safe(w, next, wait_list, list) {
+		list_del_init(&w->list);
+
+		if (wake_up_process(w->task) &&
+		    waitlist_id != SIX_LOCK_read) {
+			if (!list_empty(wait_list))
+				set_bit(waitlist_bitnr(waitlist_id),
+					(unsigned long *) &lock->state.v);
+			break;
+		}
+	}
+
+	raw_spin_unlock(&lock->wait_lock);
+}
+
+__always_inline __flatten
+static void __six_unlock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+	union six_lock_state state;
+
+	EBUG_ON(!(lock->state.v & l[type].held_mask));
+	EBUG_ON(type == SIX_LOCK_write &&
+		!(lock->state.v & __SIX_LOCK_HELD_intent));
+
+	six_clear_owner(lock, type);
+
+	state.v = atomic64_add_return_release(l[type].unlock_val,
+					      &lock->state.counter);
+	six_release(&lock->dep_map);
+	six_lock_wakeup(lock, state, l[type].unlock_wakeup);
+}
+
+#ifdef SIX_LOCK_SEPARATE_LOCKFNS
+
+#define __SIX_LOCK(type)						\
+bool six_trylock_##type(struct six_lock *lock)				\
+{									\
+	return __six_trylock_type(lock, SIX_LOCK_##type);		\
+}									\
+									\
+bool six_relock_##type(struct six_lock *lock, u32 seq)			\
+{									\
+	return __six_relock_type(lock, SIX_LOCK_##type, seq);		\
+}									\
+									\
+void six_lock_##type(struct six_lock *lock)				\
+{									\
+	__six_lock_type(lock, SIX_LOCK_##type);				\
+}									\
+									\
+void six_unlock_##type(struct six_lock *lock)				\
+{									\
+	__six_unlock_type(lock, SIX_LOCK_##type);			\
+}
+
+__SIX_LOCK(read)
+__SIX_LOCK(intent)
+__SIX_LOCK(write)
+
+#undef __SIX_LOCK
+
+#else
+
+bool six_trylock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	return __six_trylock_type(lock, type);
+}
+
+bool six_relock_type(struct six_lock *lock, enum six_lock_type type,
+		     unsigned seq)
+{
+	return __six_relock_type(lock, type, seq);
+
+}
+
+void six_lock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	__six_lock_type(lock, type);
+}
+
+void six_unlock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	__six_unlock_type(lock, type);
+}
+
+#endif
+
+/* Convert from intent to read: */
+void six_lock_downgrade(struct six_lock *lock)
+{
+	six_lock_increment(lock, SIX_LOCK_read);
+	six_unlock_intent(lock);
+}
+
+bool six_lock_tryupgrade(struct six_lock *lock)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+	union six_lock_state old, new;
+	u64 v = READ_ONCE(lock->state.v);
+
+	do {
+		new.v = old.v = v;
+
+		EBUG_ON(!(old.v & l[SIX_LOCK_read].held_mask));
+
+		new.v += l[SIX_LOCK_read].unlock_val;
+
+		if (new.v & l[SIX_LOCK_intent].lock_fail)
+			return false;
+
+		new.v += l[SIX_LOCK_intent].lock_val;
+	} while ((v = atomic64_cmpxchg_acquire(&lock->state.counter,
+				old.v, new.v)) != old.v);
+
+	six_set_owner(lock, SIX_LOCK_intent, old);
+	six_lock_wakeup(lock, new, l[SIX_LOCK_read].unlock_wakeup);
+
+	return true;
+}
+
+bool six_trylock_convert(struct six_lock *lock,
+			 enum six_lock_type from,
+			 enum six_lock_type to)
+{
+	EBUG_ON(to == SIX_LOCK_write || from == SIX_LOCK_write);
+
+	if (to == from)
+		return true;
+
+	if (to == SIX_LOCK_read) {
+		six_lock_downgrade(lock);
+		return true;
+	} else {
+		return six_lock_tryupgrade(lock);
+	}
+}
+
+/*
+ * Increment read/intent lock count, assuming we already have it read or intent
+ * locked:
+ */
+void six_lock_increment(struct six_lock *lock, enum six_lock_type type)
+{
+	const struct six_lock_vals l[] = LOCK_VALS;
+
+	EBUG_ON(type == SIX_LOCK_write);
+	six_acquire(&lock->dep_map, 0);
+
+	/* XXX: assert already locked, and that we don't overflow: */
+
+	atomic64_add(l[type].lock_val, &lock->state.counter);
+}
diff --git a/fs/bcachefs/six.h b/fs/bcachefs/six.h
new file mode 100644
index 0000000000..f518c64c40
--- /dev/null
+++ b/fs/bcachefs/six.h
@@ -0,0 +1,190 @@
+#ifndef _BCACHEFS_SIX_H
+#define _BCACHEFS_SIX_H
+
+#include <linux/lockdep.h>
+#include <linux/osq_lock.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include "util.h"
+
+#define SIX_LOCK_SEPARATE_LOCKFNS
+
+/*
+ * LOCK STATES:
+ *
+ * read, intent, write (i.e. shared/intent/exclusive, hence the name)
+ *
+ * read and write work as with normal read/write locks - a lock can have
+ * multiple readers, but write excludes reads and other write locks.
+ *
+ * Intent does not block read, but it does block other intent locks. The idea is
+ * by taking an intent lock, you can then later upgrade to a write lock without
+ * dropping your read lock and without deadlocking - because no other thread has
+ * the intent lock and thus no other thread could be trying to take the write
+ * lock.
+ */
+
+union six_lock_state {
+	struct {
+		atomic64_t	counter;
+	};
+
+	struct {
+		u64		v;
+	};
+
+	struct {
+		/* for waitlist_bitnr() */
+		unsigned long	l;
+	};
+
+	struct {
+		unsigned	read_lock:26;
+		unsigned	intent_lock:3;
+		unsigned	waiters:3;
+		/*
+		 * seq works much like in seqlocks: it's incremented every time
+		 * we lock and unlock for write.
+		 *
+		 * If it's odd write lock is held, even unlocked.
+		 *
+		 * Thus readers can unlock, and then lock again later iff it
+		 * hasn't been modified in the meantime.
+		 */
+		u32		seq;
+	};
+};
+
+#define SIX_LOCK_MAX_RECURSE	((1 << 3) - 1)
+
+enum six_lock_type {
+	SIX_LOCK_read,
+	SIX_LOCK_intent,
+	SIX_LOCK_write,
+};
+
+struct six_lock {
+	union six_lock_state	state;
+	struct task_struct	*owner;
+	struct optimistic_spin_queue osq;
+
+	raw_spinlock_t		wait_lock;
+	struct list_head	wait_list[2];
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+static __always_inline void __six_lock_init(struct six_lock *lock,
+					    const char *name,
+					    struct lock_class_key *key)
+{
+	atomic64_set(&lock->state.counter, 0);
+	raw_spin_lock_init(&lock->wait_lock);
+	INIT_LIST_HEAD(&lock->wait_list[SIX_LOCK_read]);
+	INIT_LIST_HEAD(&lock->wait_list[SIX_LOCK_intent]);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	debug_check_no_locks_freed((void *) lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+#endif
+}
+
+#define six_lock_init(lock)						\
+do {									\
+	static struct lock_class_key __key;				\
+									\
+	__six_lock_init((lock), #lock, &__key);				\
+} while (0)
+
+#define __SIX_VAL(field, _v)	(((union six_lock_state) { .field = _v }).v)
+
+#ifdef SIX_LOCK_SEPARATE_LOCKFNS
+
+#define __SIX_LOCK(type)						\
+bool six_trylock_##type(struct six_lock *);				\
+bool six_relock_##type(struct six_lock *, u32);				\
+void six_lock_##type(struct six_lock *);				\
+void six_unlock_##type(struct six_lock *);
+
+__SIX_LOCK(read)
+__SIX_LOCK(intent)
+__SIX_LOCK(write)
+#undef __SIX_LOCK
+
+#define SIX_LOCK_DISPATCH(type, fn, ...)			\
+	switch (type) {						\
+	case SIX_LOCK_read:					\
+		return fn##_read(__VA_ARGS__);			\
+	case SIX_LOCK_intent:					\
+		return fn##_intent(__VA_ARGS__);		\
+	case SIX_LOCK_write:					\
+		return fn##_write(__VA_ARGS__);			\
+	default:						\
+		BUG();						\
+	}
+
+static inline bool six_trylock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	SIX_LOCK_DISPATCH(type, six_trylock, lock);
+}
+
+static inline bool six_relock_type(struct six_lock *lock, enum six_lock_type type,
+		     unsigned seq)
+{
+	SIX_LOCK_DISPATCH(type, six_relock, lock, seq);
+}
+
+static inline void six_lock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	SIX_LOCK_DISPATCH(type, six_lock, lock);
+}
+
+static inline void six_unlock_type(struct six_lock *lock, enum six_lock_type type)
+{
+	SIX_LOCK_DISPATCH(type, six_unlock, lock);
+}
+
+#else
+
+bool six_trylock_type(struct six_lock *, enum six_lock_type);
+bool six_relock_type(struct six_lock *, enum six_lock_type, unsigned);
+void six_lock_type(struct six_lock *, enum six_lock_type);
+void six_unlock_type(struct six_lock *, enum six_lock_type);
+
+#define __SIX_LOCK(type)						\
+static __always_inline bool six_trylock_##type(struct six_lock *lock)	\
+{									\
+	return six_trylock_type(lock, SIX_LOCK_##type);			\
+}									\
+									\
+static __always_inline bool six_relock_##type(struct six_lock *lock, u32 seq)\
+{									\
+	return six_relock_type(lock, SIX_LOCK_##type, seq);		\
+}									\
+									\
+static __always_inline void six_lock_##type(struct six_lock *lock)	\
+{									\
+	six_lock_type(lock, SIX_LOCK_##type);				\
+}									\
+									\
+static __always_inline void six_unlock_##type(struct six_lock *lock)	\
+{									\
+	six_unlock_type(lock, SIX_LOCK_##type);				\
+}
+
+__SIX_LOCK(read)
+__SIX_LOCK(intent)
+__SIX_LOCK(write)
+#undef __SIX_LOCK
+
+#endif
+
+void six_lock_downgrade(struct six_lock *);
+bool six_lock_tryupgrade(struct six_lock *);
+bool six_trylock_convert(struct six_lock *, enum six_lock_type,
+			 enum six_lock_type);
+
+void six_lock_increment(struct six_lock *, enum six_lock_type);
+
+#endif /* _BCACHEFS_SIX_H */
-- 
2.17.0

