Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1D7E7F7B
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92F428F8059
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hp9q7MzE8FyKIZzA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] printk: enable interrupts before calling
	console_trylock_for_printk()
Date: Fri, 10 Oct 2014 16:23:31 +0200
Message-Id: <1412951028-4085-27-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

We need interrupts disabled when calling console_trylock_for_printk()
only so that cpu id we pass to can_use_console() remains valid (for
other things console_sem provides all the exclusion we need and
deadlocks on console_sem due to interrupts are impossible because we use
down_trylock()).  However if we are rescheduled, we are guaranteed to
run on an online cpu so we can easily just get the cpu id in
can_use_console().

We can lose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH
it can somewhat reduce interrupt latency caused by console_unlock().

We differ from (reverted) commit 939f04bec1a4 in that we avoid calling
console_unlock() from vprintk_emit() with lockdep enabled as that has
unveiled quite some bugs leading to system freezes during boot (e.g.
https://lkml.org/lkml/2014/5/30/242,
https://lkml.org/lkml/2014/6/28/521).

Tested-by: Andreas Bombe <aeb@debian.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

 Andrew, can you please queue this patch? Thanks.

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839dbca07..fe4154d83fe4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1416,10 +1416,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1432,8 +1431,10 @@ static inline int can_use_console(unsigned int cpu)
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1608,7 +1609,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1716,21 +1718,30 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
 	if (!in_sched) {
+		lockdep_off();
+		/*
+		 * Disable preemption to avoid being preempted while holding
+		 * console_sem which would prevent anyone from printing to
+		 * console
+		 */
+		preempt_disable();
+
 		/*
 		 * Try to acquire and then immediately release the console
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
-		if (console_trylock_for_printk(this_cpu))
+		if (console_trylock_for_printk())
 			console_unlock();
+		preempt_enable();
+		lockdep_on();
 	}
 
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
