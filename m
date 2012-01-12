Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CMvjLA039387 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 16:57:46 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Ro8De5X2HbqrmSht for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 14:57:43 -0800 (PST)
Message-ID: <4F0F6566.4050202@sandeen.net>
Date: Thu, 12 Jan 2012 16:57:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-2-git-send-email-jack@suse.cz>
In-Reply-To: <1326331253-6497-2-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 1/11/12 7:20 PM, Jan Kara wrote:
> Currently, exclusion between ->page_mkwrite() and filesystem freezing has been
> handled by setting page dirty and then verifying s_frozen. This guaranteed that
> either the freezing code sees the faulted page, writes it, and writeprotects it
> again or we see s_frozen set and bail out of page fault. This works to protect
> from page being marked writeable while filesystem freezing is running but has
> an unpleasant artefact of leaving dirty (although unmodified and
> writeprotected) pages on frozen filesystem. This artefact then requires
> workarounds in writeback code and other places.
> 
> Also generally vfs_check_frozen() tests are racy since the filesystem can be
> frozen just after the test is performed. Thus in other write paths we can
> end up marking some pages or inodes dirty even though filesystem is already
> frozen. Again this creates problems with flusher thread hanging on frozen
> filesystem.
> 
> This patch aims at providing exclusion between write paths which dirty data (we
> don't have to worry about metadata since that is handled by filesystems in
> ->freeze_fs) and filesystem freezing. We implement a writer-freeze read-write
> semaphore in the superblock. Write paths which dirty data such as
> ->block_page_mkwrite() implementations, or ->aio_write() implementations hold
> reader side of the semaphore.  Filesystem freezing code holds the writer side.
> Only that we don't really want to bounce cachelines of the semaphore between
> CPUs for each write happening. So we implement the reader side of the semaphore
> as a per-cpu counter and the writer side is implemented using s_frozen
> superblock field.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/super.c         |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/fs.h |   14 ++++++
>  2 files changed, 134 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index afd0f1a..c85c64c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -32,12 +32,15 @@
>  #include <linux/backing-dev.h>
>  #include <linux/rculist_bl.h>
>  #include <linux/cleancache.h>
> +#include <linux/lockdep.h>
>  #include "internal.h"
>  
>  
>  LIST_HEAD(super_blocks);
>  DEFINE_SPINLOCK(sb_lock);
>  
> +static struct lock_class_key sb_writers_key;
> +
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -183,6 +186,13 @@ static struct super_block *alloc_super(struct file_system_type *type)
>  		s->s_shrink.seeks = DEFAULT_SEEKS;
>  		s->s_shrink.shrink = prune_super;
>  		s->s_shrink.batch = 1024;
> +
> +		init_waitqueue_head(&s->s_writers_wait);
> +#ifdef CONFIG_SMP
> +		s->s_page_faults = alloc_percpu(int);

isn't this s->s_writers?  s->s_page_faults isn't defined anywhere.

> +#endif
> +		lockdep_init_map(&s->s_writers_lock_map, "sb_writers",
> +				 &sb_writers_key, 0);
>  	}
>  out:
>  	return s;
> @@ -1126,6 +1136,84 @@ out:
>  }
>  
>  /**
> + * sb_start_write - drop write access to a superblock
      ^^^^^^^^^^^^^^

s/b sb_end_write

> + * @sb: the super we wrote to
> + *
> + * Decrement number of writers to the filesystem and wake up possible
> + * waiters wanting to freeze the filesystem.
> + */
> +void sb_end_write(struct super_block *sb)
> +{
> +#ifdef CONFIG_SMP
> +	this_cpu_dec(sb->s_writers);
> +#else
> +	preempt_disable();
> +	sb->s_writers--;
> +	preempt_enable();
> +#endif
> +	/*
> +	 * Make sure s_writers are updated before we wake up waiters in
> +	 * freeze_super().
> +	 */
> +	smp_mb();
> +	if (waitqueue_active(&sb->s_writers_wait))
> +		wake_up(&sb->s_writers_wait);
> +	rwsem_release(&sb->s_writers_lock_map, 1, _RET_IP_);
> +}
> +
> +/**
> + * sb_start_write - get write access to a superblock
> + * @sb: the super we write to
> + *
> + * When a process wants to write data to a filesystem (i.e. dirty a page),
> + * it should embed the operation in a sb_start_write() - sb_end_write() pair
> + * to get exclusion against filesystem freezing. This function increments
> + * number of writers to the filesystem and waits if filesystem is frozen until
> + * it is thawed.
> + */
> +void sb_start_write(struct super_block *sb)
> +{
> +retry:
> +	rwsem_acquire_read(&sb->s_writers_lock_map, 0, 0, _RET_IP_);
> +	vfs_check_frozen(sb, SB_FREEZE_WRITE);
> +#ifdef CONFIG_SMP
> +	this_cpu_inc(sb->s_writers);
> +#else
> +	preempt_disable();
> +	sb->s_writers++;
> +	preempt_enable();
> +#endif
> +	/*
> +	 * Make sure s_writers are updated before we check s_frozen.
> +	 * freeze_super() first sets s_frozen and then checks s_writers.
> +	 */
> +	smp_mb();
> +	if (sb->s_frozen != SB_UNFROZEN) {
> +		sb_end_write(sb);
> +		goto retry;
> +	}
> +}
> +
> +/*
> + * Get number of writers to the superblock
> + */
> +static int get_writers_count(struct super_block *sb)
> +{
> +	int writers;
> +#ifdef CONFIG_SMP
> +	int cpu;
> +
> +	writers = 0;
> +	for_each_possible_cpu(cpu) {
> +		writers += *per_cpu_ptr(sb->s_writers, cpu);
> +	}
> +#else
> +	writers = sb->s_writers;
> +#endif
> +	return writers;
> +}
> +
> +/**
>   * freeze_super - lock the filesystem and force it into a consistent state
>   * @sb: the super to lock
>   *
> @@ -1136,6 +1224,7 @@ out:
>  int freeze_super(struct super_block *sb)
>  {
>  	int ret;
> +	int writers;
>  
>  	atomic_inc(&sb->s_active);
>  	down_write(&sb->s_umount);
> @@ -1151,8 +1240,36 @@ int freeze_super(struct super_block *sb)
>  		return 0;
>  	}
>  
> +	rwsem_acquire(&sb->s_writers_lock_map, 0, 0, _THIS_IP_);
>  	sb->s_frozen = SB_FREEZE_WRITE;
> -	smp_wmb();
> +	/*
> +	 * Now wait for all page faults to finish. ->page_mkwrite()
> +	 * implementations must call vfs_check_frozen() before starting
> +	 * a fault so that we cannot livelock here. Because of that we
> +	 * are guaranteed that from this moment on new ->page_mkwrite()
> +	 * calls will block and we just have to wait for s_page_faults

wait for s_writers, right?

> +	 * to drop to zero (in a sum).
> +	 */
> +	do {
> +		DEFINE_WAIT(wait);
> +
> +		/*
> +		 * We use a barrier in prepare_to_wait() to separate setting
> +		 * of s_frozen and checking of s_writers
> +		 */
> +		prepare_to_wait(&sb->s_writers_wait, &wait,
> +				TASK_UNINTERRUPTIBLE);
> +		/*
> +		 * We must iterate over all (even offline) CPUs because of CPU
> + 		 * hotplug their entries could still be non-zero. This is slow
> +		 * when lots of CPUs are configured but hey, filesystem freezing
> +		 * isn't exactly cheap anyway.
> +		 */
> +		writers = get_writers_count(sb);
> +		if (writers)
> +			schedule();
> +		finish_wait(&sb->s_writers_wait, &wait);
> +	} while (writers);
>  
>  	sync_filesystem(sb);
>  
> @@ -1165,6 +1282,7 @@ int freeze_super(struct super_block *sb)
>  		if (ret) {
>  			printk(KERN_ERR
>  				"VFS:Filesystem freeze failed\n");
> +			rwsem_release(&sb->s_writers_lock_map, 1, _THIS_IP_);
>  			sb->s_frozen = SB_UNFROZEN;
>  			deactivate_locked_super(sb);
>  			return ret;
> @@ -1206,6 +1324,7 @@ int thaw_super(struct super_block *sb)
>  	}
>  
>  out:
> +	rwsem_release(&sb->s_writers_lock_map, 1, _THIS_IP_);
>  	sb->s_frozen = SB_UNFROZEN;
>  	smp_wmb();
>  	wake_up(&sb->s_wait_unfrozen);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e313022..297b263 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -10,6 +10,7 @@
>  #include <linux/ioctl.h>
>  #include <linux/blk_types.h>
>  #include <linux/types.h>
> +#include <linux/lockdep.h>
>  
>  /*
>   * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
> @@ -1445,6 +1446,16 @@ struct super_block {
>  
>  	int			s_frozen;
>  	wait_queue_head_t	s_wait_unfrozen;
> +#ifdef CONFIG_SMP
> +	int __percpu 		*s_writers;	/* counter of running writes */
> +#else
> +	int			s_writers;	/* counter of running writes */
> +#endif
> +	wait_queue_head_t	s_writers_wait;	/* queue for waiting for
> +						   writers to finish */
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lockdep_map	s_writers_lock_map;
> +#endif
>  
>  	char s_id[32];				/* Informational name */
>  	u8 s_uuid[16];				/* UUID */
> @@ -1501,6 +1512,9 @@ enum {
>  #define vfs_check_frozen(sb, level) \
>  	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
>  
> +void sb_end_write(struct super_block *sb);
> +void sb_start_write(struct super_block *sb);
> +
>  /*
>   * until VFS tracks user namespaces for inodes, just make all files
>   * belong to init_user_ns

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
