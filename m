Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 930927CAF
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:13:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B6B78F8050
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:13:29 -0700 (PDT)
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com
	[15.241.48.72]) by cuda.sgi.com with ESMTP id kx8HiZLNfsV4EOpx
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 11:13:26 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH-tip 4/6] locking/rwsem: Change RWSEM_WAITING_BIAS for
	better disambiguation
Date: Tue, 14 Jun 2016 14:12:37 -0400
Message-Id: <1465927959-39719-5-git-send-email-Waiman.Long@hpe.com>
In-Reply-To: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

When the count value is in between 0 and RWSEM_WAITING_BIAS, there
are 2 possibilities. Either a writer is present and there is no
waiter or there are waiters and readers. There is no easy way to
know which is true unless the wait_lock is taken.

This patch changes the RWSEM_WAITING_BIAS from 0xffff (32-bit) or
0xffffffff (64-bit) to 0xc0000000 (32-bit) or 0xc000000000000000
(64-bit). By doing so, we will be able to determine if writers
are present by looking at the count value alone without taking the
wait_lock.

This patch has the effect of halving the maximum number of writers
that can attempt to take the write lock simultaneously. However,
even the reduced maximum of about 16k (32-bit) or 1G (64-bit) should
be more than enough for the foreseeable future.

With that change, the following identity is now no longer true:

  RWSEM_ACTIVE_WRITE_BIAS = RWSEM_WAITING_BIAS + RWSEM_ACTIVE_READ_BIAS

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 arch/alpha/include/asm/rwsem.h |    7 ++++---
 arch/ia64/include/asm/rwsem.h  |    6 +++---
 arch/s390/include/asm/rwsem.h  |    6 +++---
 arch/x86/include/asm/rwsem.h   |   13 ++++++++-----
 include/asm-generic/rwsem.h    |    9 +++++----
 kernel/locking/rwsem-xadd.c    |   32 ++++++++++++++++++++++++--------
 6 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 77873d0..0f08fad 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -17,9 +17,9 @@
 #define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS		0x0000000000000001L
 #define RWSEM_ACTIVE_MASK		0x00000000ffffffffL
-#define RWSEM_WAITING_BIAS		(-0x0000000100000000L)
+#define RWSEM_WAITING_BIAS		0xc000000000000000L
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS		(-RWSEM_ACTIVE_MASK)
 
 static inline void __down_read(struct rw_semaphore *sem)
 {
@@ -185,7 +185,8 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 	"2:	br	1b\n"
 	".previous"
 	:"=&r" (oldcount), "=m" (sem->count), "=&r" (temp)
-	:"Ir" (-RWSEM_WAITING_BIAS), "m" (sem->count) : "memory");
+	:"Ir" (-RWSEM_ACTIVE_WRITE_BIAS + RWSEM_ACTIVE_READ_BIAS),
+	 "m" (sem->count) : "memory");
 #endif
 	if (unlikely(oldcount < 0))
 		rwsem_downgrade_wake(sem);
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index 8fa98dd..db3693b 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -30,9 +30,9 @@
 #define RWSEM_UNLOCKED_VALUE		__IA64_UL_CONST(0x0000000000000000)
 #define RWSEM_ACTIVE_BIAS		(1L)
 #define RWSEM_ACTIVE_MASK		(0xffffffffL)
-#define RWSEM_WAITING_BIAS		(-0x100000000L)
+#define RWSEM_WAITING_BIAS		(-(1L << 62))
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS		(-RWSEM_ACTIVE_MASK)
 
 /*
  * lock for reading
@@ -144,7 +144,7 @@ __downgrade_write (struct rw_semaphore *sem)
 
 	do {
 		old = atomic_long_read(&sem->count);
-		new = old - RWSEM_WAITING_BIAS;
+		new = old - RWSEM_ACTIVE_WRITE_BIAS + RWSEM_ACTIVE_READ_BIAS;
 	} while (atomic_long_cmpxchg_release(&sem->count, old, new) != old);
 
 	if (old < 0)
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 597e7e9..e7f50f5 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -42,9 +42,9 @@
 #define RWSEM_UNLOCKED_VALUE	0x0000000000000000L
 #define RWSEM_ACTIVE_BIAS	0x0000000000000001L
 #define RWSEM_ACTIVE_MASK	0x00000000ffffffffL
-#define RWSEM_WAITING_BIAS	(-0x0000000100000000L)
+#define RWSEM_WAITING_BIAS	0xc000000000000000L
 #define RWSEM_ACTIVE_READ_BIAS	RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS	(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS	(-RWSEM_ACTIVE_MASK)
 
 /*
  * lock for reading
@@ -193,7 +193,7 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	signed long old, new, tmp;
 
-	tmp = -RWSEM_WAITING_BIAS;
+	tmp = -RWSEM_ACTIVE_WRITE_BIAS + RWSEM_ACTIVE_READ_BIAS;
 	asm volatile(
 		"	lg	%0,%2\n"
 		"0:	lgr	%1,%0\n"
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 089ced4..f1fb09f 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -41,21 +41,23 @@
 
 /*
  * The bias values and the counter type limits the number of
- * potential readers/writers to 32767 for 32 bits and 2147483647
- * for 64 bits.
+ * potential writers to 16383 for 32 bits and 1073741823 for 64 bits.
+ * The combined readers and writers can go up to 65534 for 32-bits and
+ * 4294967294 for 64-bits.
  */
 
 #ifdef CONFIG_X86_64
 # define RWSEM_ACTIVE_MASK		0xffffffffL
+# define RWSEM_WAITING_BIAS		(-(1L << 62))
 #else
 # define RWSEM_ACTIVE_MASK		0x0000ffffL
+# define RWSEM_WAITING_BIAS		(-(1L << 30))
 #endif
 
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
 #define RWSEM_ACTIVE_BIAS		0x00000001L
-#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS		(-RWSEM_ACTIVE_MASK)
 
 /*
  * lock for reading
@@ -209,7 +211,8 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem), "er" (-RWSEM_ACTIVE_WRITE_BIAS +
+					 RWSEM_ACTIVE_READ_BIAS)
 		     : "memory", "cc");
 }
 
diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
index 5be122e..655e405 100644
--- a/include/asm-generic/rwsem.h
+++ b/include/asm-generic/rwsem.h
@@ -18,15 +18,16 @@
  */
 #ifdef CONFIG_64BIT
 # define RWSEM_ACTIVE_MASK		0xffffffffL
+# define RWSEM_WAITING_BIAS		(-(1L << 62))
 #else
 # define RWSEM_ACTIVE_MASK		0x0000ffffL
+# define RWSEM_WAITING_BIAS		(-(1L << 30))
 #endif
 
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
 #define RWSEM_ACTIVE_BIAS		0x00000001L
-#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+#define RWSEM_ACTIVE_WRITE_BIAS		(-RWSEM_ACTIVE_MASK)
 
 /*
  * lock for reading
@@ -120,8 +121,8 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 	 * read-locked region is ok to be re-ordered into the
 	 * write side. As such, rely on RELEASE semantics.
 	 */
-	tmp = atomic_long_add_return_release(-RWSEM_WAITING_BIAS,
-				     (atomic_long_t *)&sem->count);
+	tmp = atomic_long_add_return_release(-RWSEM_ACTIVE_WRITE_BIAS +
+			RWSEM_ACTIVE_READ_BIAS, (atomic_long_t *)&sem->count);
 	if (tmp < 0)
 		rwsem_downgrade_wake(sem);
 }
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 400e594..689a138 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -29,28 +29,30 @@
  * 0x00000000	rwsem is unlocked, and no one is waiting for the lock or
  *		attempting to read lock or write lock.
  *
- * 0xffff000X	(1) X readers active or attempting lock, with waiters for lock
+ * 0xc000000X	(1) X readers active or attempting lock, with waiters for lock
  *		    X = #active readers + # readers attempting lock
  *		    (X*ACTIVE_BIAS + WAITING_BIAS)
- *		(2) 1 writer attempting lock, no waiters for lock
+ *
+ * 0xffff000X	(1) 1 writer attempting lock, no waiters for lock
  *		    X-1 = #active readers + #readers attempting lock
  *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
- *		(3) 1 writer active, no waiters for lock
+ *		(2) 1 writer active, no waiters for lock
  *		    X-1 = #active readers + #readers attempting lock
  *		    ((X-1)*ACTIVE_BIAS + ACTIVE_WRITE_BIAS)
  *
- * 0xffff0001	(1) 1 reader active or attempting lock, waiters for lock
+ * 0xc0000001	(1) 1 reader active or attempting lock, waiters for lock
  *		    (WAITING_BIAS + ACTIVE_BIAS)
- *		(2) 1 writer active or attempting lock, no waiters for lock
+ *
+ * 0xffff0001	(1) 1 writer active or attempting lock, no waiters for lock
  *		    (ACTIVE_WRITE_BIAS)
  *
- * 0xffff0000	(1) There are writers or readers queued but none active
+ * 0xc0000000	(1) There are writers or readers queued but none active
  *		    or in the process of attempting lock.
  *		    (WAITING_BIAS)
  *		Note: writer can attempt to steal lock for this count by adding
  *		ACTIVE_WRITE_BIAS in cmpxchg and checking the old count
  *
- * 0xfffe0001	(1) 1 writer active, or attempting lock. Waiters on queue.
+ * 0xbfff0001	(1) 1 writer active, or attempting lock. Waiters on queue.
  *		    (ACTIVE_WRITE_BIAS + WAITING_BIAS)
  *
  * Note: Readers attempt to lock by adding ACTIVE_BIAS in down_read and checking
@@ -62,9 +64,23 @@
  *	 checking the count becomes ACTIVE_WRITE_BIAS for successful lock
  *	 acquisition (i.e. nobody else has lock or attempts lock).  If
  *	 unsuccessful, in rwsem_down_write_failed, we'll check to see if there
- *	 are only waiters but none active (5th case above), and attempt to
+ *	 are only waiters but none active (7th case above), and attempt to
  *	 steal the lock.
  *
+ *	 We can infer the reader/writer/waiter state of the lock by looking
+ *	 at the count value:
+ *	 (1) count > 0
+ *	     Only readers are present.
+ *	 (2) WAITING_BIAS - ACTIVE_WRITE_BIAS < count < 0
+ *	     Have writers, maybe readers, but no waiter
+ *	 (3) WAITING_BIAS < count <= WAITING_BIAS - ACTIVE_WRITE_BIAS
+ *	     Have readers and waiters, but no writer
+ *	 (4) count < WAITING_BIAS
+ *	     Have writers and waiters, maybe readers
+ *
+ *	 IOW, writers are present when
+ *	 (1) count < WAITING_BIAS, or
+ *	 (2) WAITING_BIAS - ACTIVE_WRITE_BIAS < count < 0
  */
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
