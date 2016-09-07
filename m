Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DF677CA7
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 02:43:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EFB8304039
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 00:43:17 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id IGonrzC1Xj1OgjSr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2016 00:43:14 -0700 (PDT)
Date: Wed, 7 Sep 2016 09:43:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160907074312.GQ10153@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
	<20160819132736.GH10121@twins.programming.kicks-ass.net>
	<20160820063723.GA7013@lst.de>
	<20160822083455.GH10153@twins.programming.kicks-ass.net>
	<20160905151244.GA16726@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160905151244.GA16726@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@kernel.org>, xfs@oss.sgi.com

On Mon, Sep 05, 2016 at 05:12:44PM +0200, Christoph Hellwig wrote:
> Peter, this is the fixed up patch.  Can you write a proper changelog
> and add your signoff?

Yes, sorry for the delay.

Did you get the workqueue thing sorted, where you rely on another task
holding the lock for you?

I simplified the implementation a little, since I noticed pushing the
@read argument all the way down to match_held_lock() didn't really make
all that much sense and caused a lot of churn.

I also added CONFIG_LOCKDEP=n stubs for the new lockdep_assert_held*()
macros (which you don't use :-).

Feel free to push this through the XFS tree where you add its first use.

---
Subject: locking/lockdep: Provide a type check for lock_is_held
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 5 Sep 2016 17:12:44 +0200

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

By default we provide (positive)
lockdep_assert_held{,_exclusive,_read}() macros.

Requested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/lockdep.h  |   23 +++++++++++++++++++++--
 kernel/locking/lockdep.c |   20 ++++++++++++--------
 2 files changed, 33 insertions(+), 10 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -338,9 +338,18 @@ extern void lock_acquire(struct lockdep_
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
@@ -372,6 +381,14 @@ extern void lock_unpin_lock(struct lockd
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
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3188,7 +3188,7 @@ print_lock_nested_lock_not_held(struct t
 	return 0;
 }
 
-static int __lock_is_held(struct lockdep_map *lock);
+static int __lock_is_held(struct lockdep_map *lock, int read);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
@@ -3329,7 +3329,7 @@ static int __lock_acquire(struct lockdep
 	}
 	chain_key = iterate_chain_key(chain_key, class_idx);
 
-	if (nest_lock && !__lock_is_held(nest_lock))
+	if (nest_lock && !__lock_is_held(nest_lock, -1))
 		return print_lock_nested_lock_not_held(curr, hlock, ip);
 
 	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
@@ -3576,7 +3576,7 @@ __lock_release(struct lockdep_map *lock,
 	return 1;
 }
 
-static int __lock_is_held(struct lockdep_map *lock)
+static int __lock_is_held(struct lockdep_map *lock, int read)
 {
 	struct task_struct *curr = current;
 	int i;
@@ -3584,8 +3584,12 @@ static int __lock_is_held(struct lockdep
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
@@ -3769,7 +3773,7 @@ void lock_release(struct lockdep_map *lo
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
-int lock_is_held(struct lockdep_map *lock)
+int lock_is_held_type(struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -3781,13 +3785,13 @@ int lock_is_held(struct lockdep_map *loc
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
