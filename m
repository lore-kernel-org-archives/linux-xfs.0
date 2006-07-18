Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 01:17:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6I8GdDW012181
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 01:16:53 -0700
Date: Tue, 18 Jul 2006 18:15:49 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Annotating xfs_lock_inodes
Message-ID: <20060718181549.D1914501@wobbly.melbourne.sgi.com>
References: <20060706091535.B1548326@wobbly.melbourne.sgi.com> <20060706100712.GA6439@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060706100712.GA6439@elte.hu>; from mingo@elte.hu on Thu, Jul 06, 2006 at 12:07:12PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ingo Molnar <mingo@elte.hu>
Cc: xfs@oss.sgi.com

Hi Ingo,

On Thu, Jul 06, 2006 at 12:07:12PM +0200, Ingo Molnar wrote:
> ...
> you can do a subclass++ in the inode locking loop in xfs_lock_inodes(), 
> and pass that subclass index into a new function: 
> 
> 	xfs_ilock_nested(..., subclass)
> 
> or something like that.

I have something like that working now, and on to investigating
the next issue reported (unrelated to xfs_lock_inodes).  I found
that I needed to have the rwsem trylock variants available with a
subclass argument too though (like the non-trylock variants are
currently) in order to get that part of xfs_lock_inodes to play
ball.

Could you look over this change for me, and queue it up for lockdep
checking in mainline (no rush) if it looks OK?

thanks!

-- 
Nathan


diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 658afb3..d6d7d47 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -64,7 +64,9 @@ #ifdef CONFIG_DEBUG_LOCK_ALLOC
  * nested locking:
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
+extern int down_read_trylock_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
+extern int down_write_trylock_nested(struct rw_semaphore *sem, int subclass);
 /*
  * Take/release a lock when not the owner will release it:
  */
@@ -72,9 +74,11 @@ extern void down_read_non_owner(struct r
 extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
-# define down_write_nested(sem, subclass)	down_write(sem)
-# define down_read_non_owner(sem)		down_read(sem)
-# define up_read_non_owner(sem)			up_read(sem)
+# define down_read_trylock_nested(sem, subclass)	down_read_trylock(sem)
+# define down_write_nested(sem, subclass)		down_write(sem)
+# define down_write_trylock_nested(sem, subclass)	down_write_trylock(sem)
+# define down_read_non_owner(sem)			down_read(sem)
+# define up_read_non_owner(sem)				up_read(sem)
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index 291ded5..4b7eb74 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -116,6 +116,17 @@ void down_read_nested(struct rw_semaphor
 
 EXPORT_SYMBOL(down_read_nested);
 
+int down_read_trylock_nested(struct rw_semaphore *sem, int subclass)
+{
+	int ret = __down_read_trylock(sem);
+
+	if (ret == 1)
+		rwsem_acquire_read(&sem->dep_map, subclass, 1, _RET_IP_);
+	return ret;
+}
+
+EXPORT_SYMBOL(down_read_trylock_nested);
+
 void down_read_non_owner(struct rw_semaphore *sem)
 {
 	might_sleep();
@@ -135,6 +146,17 @@ void down_write_nested(struct rw_semapho
 
 EXPORT_SYMBOL(down_write_nested);
 
+int down_write_trylock_nested(struct rw_semaphore *sem, int subclass)
+{
+	int ret = __down_write_trylock(sem);
+
+	if (ret == 1)
+		rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
+	return ret;
+}
+
+EXPORT_SYMBOL(down_write_trylock_nested);
+
 void up_read_non_owner(struct rw_semaphore *sem)
 {
 	__up_read(sem);
