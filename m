Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8354C7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 13:11:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21B5FAC00B
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 11:11:21 -0700 (PDT)
Received: from mxip4-inbound.gatech.edu (mxip4-inbound.gatech.edu
	[130.207.182.13]) by cuda.sgi.com with ESMTP id
	x9nEPdV7r56sCJwy for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 11:11:16 -0700 (PDT)
Message-ID: <53920446.7060505@gatech.edu>
Date: Fri, 06 Jun 2014 14:11:18 -0400
From: Pranith Kumar <pranith@gatech.edu>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
	rwsem_is_locked
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
In-Reply-To: <5391FFFD.1060901@gatech.edu>
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
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mingo@redhat.com, davidlohr@hp.com, tim.c.chen@linux.intel.com

On 06/06/2014 01:53 PM, Pranith Kumar wrote:
> On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Now in general, I don't particularly like such superfluous changes, so
>> unless you can show that GCC actually generates better code, I'd prefer
>> to keep things as they are.
> 
> Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(
> 
> use bool as the return type for rwsem_is_locked() instead of int
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  include/linux/rwsem-spinlock.h  |    2 +-
>  include/linux/rwsem.h           |    2 +-
>  kernel/locking/rwsem-spinlock.c |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
> index d5b13bc..9026d2a 100644
> --- a/include/linux/rwsem-spinlock.h
> +++ b/include/linux/rwsem-spinlock.h
> @@ -39,7 +39,7 @@ extern int __down_write_trylock(struct rw_semaphore *sem);
>  extern void __up_read(struct rw_semaphore *sem);
>  extern void __up_write(struct rw_semaphore *sem);
>  extern void __downgrade_write(struct rw_semaphore *sem);
> -extern int rwsem_is_locked(struct rw_semaphore *sem);
> +extern bool rwsem_is_locked(struct rw_semaphore *sem);
>  
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_RWSEM_SPINLOCK_H */
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 03f3b05..b056780 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -40,7 +40,7 @@ extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
>  #include <asm/rwsem.h>
>  
>  /* In all implementations count != 0 means locked */
> -static inline int rwsem_is_locked(struct rw_semaphore *sem)
> +static inline bool rwsem_is_locked(struct rw_semaphore *sem)
>  {
>  	return sem->count != 0;
>  }
> diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
> index 9be8a91..3f8adf8 100644
> --- a/kernel/locking/rwsem-spinlock.c
> +++ b/kernel/locking/rwsem-spinlock.c
> @@ -20,9 +20,9 @@ struct rwsem_waiter {
>  	enum rwsem_waiter_type type;
>  };
>  
> -int rwsem_is_locked(struct rw_semaphore *sem)
> +bool rwsem_is_locked(struct rw_semaphore *sem)
>  {
> -	int ret = 1;
> +	bool ret = true;
>  	unsigned long flags;
>  
>  	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
> 


I observed one other user of rwsem_is_locked() in xfs, change accordingly

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 fs/xfs/xfs_inode.c |    2 +-
 fs/xfs/xfs_inode.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 768087b..9047eda 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -285,7 +285,7 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+bool
 xfs_isilocked(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f2fcde5..80649a1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -348,7 +348,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-- 
1.7.9.5



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
