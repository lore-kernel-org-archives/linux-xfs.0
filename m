Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdHPL5G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Aug 2017 07:57:06 -0400
Date: Wed, 16 Aug 2017 07:57:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: evict all inodes involved with log redo item
Message-ID: <20170816115704.GC54738@bfoster.bfoster>
References: <150274842319.16269.6356165894145725007.stgit@magnolia>
 <150274843988.16269.18072771696022634179.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150274843988.16269.18072771696022634179.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk

On Mon, Aug 14, 2017 at 03:07:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we introduced the bmap redo log items, we set MS_ACTIVE on the
> mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
> from being truncated prematurely during log recovery.  This also had the
> effect of putting linked inodes on the lru instead of evicting them.
> 
> Unfortunately, we neglected to find all those unreferenced lru inodes
> and evict them after finishing log recovery, which means that we leak
> them if anything goes wrong in the rest of xfs_mountfs, because the lru
> is only cleaned out on unmount.
> 
> Therefore, evict unreferenced inodes in the lru list immediately
> after clearing MS_ACTIVE.
> 
> Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: viro@ZenIV.linux.org.uk
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/inode.c         |    1 +
>  fs/internal.h      |    1 -
>  fs/xfs/xfs_log.c   |   12 ++++++++++++
>  include/linux/fs.h |    1 +
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 5037059..6a1626e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -637,6 +637,7 @@ void evict_inodes(struct super_block *sb)
>  
>  	dispose_list(&dispose);
>  }
> +EXPORT_SYMBOL_GPL(evict_inodes);
>  
>  /**
>   * invalidate_inodes	- attempt to free all inodes on a superblock
> diff --git a/fs/internal.h b/fs/internal.h
> index 9676fe1..fedfe94 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -132,7 +132,6 @@ static inline bool atime_needs_update_rcu(const struct path *path,
>  extern void inode_io_list_del(struct inode *inode);
>  
>  extern long get_nr_dirty_inodes(void);
> -extern void evict_inodes(struct super_block *);
>  extern int invalidate_inodes(struct super_block *, bool);
>  
>  /*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4ebd0ba..1c594e3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -757,12 +757,24 @@ xfs_log_mount_finish(
>  	 * inodes.  Turn it off immediately after recovery finishes
>  	 * so that we don't leak the quota inodes if subsequent mount
>  	 * activities fail.
> +	 *
> +	 * We let all inodes involved in redo item processing end up on
> +	 * the LRU instead of being evicted immediately so that if we do
> +	 * something to an unlinked inode, the irele won't cause
> +	 * premature truncation and freeing of the inode, which results
> +	 * in log recovery failure.  We have to evict the unreferenced
> +	 * lru inodes after clearing MS_ACTIVE because we don't
> +	 * otherwise clean up the lru if there's a subsequent failure in
> +	 * xfs_mountfs, which leads to us leaking the inodes if nothing
> +	 * else (e.g. quotacheck) references the inodes before the
> +	 * mount failure occurs.
>  	 */
>  	mp->m_super->s_flags |= MS_ACTIVE;
>  	error = xlog_recover_finish(mp->m_log);
>  	if (!error)
>  		xfs_log_work_queue(mp);
>  	mp->m_super->s_flags &= ~MS_ACTIVE;
> +	evict_inodes(mp->m_super);
>  
>  	return error;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7b5d681..e730438 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2830,6 +2830,7 @@ static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
>  #endif
>  extern void unlock_new_inode(struct inode *);
>  extern unsigned int get_next_ino(void);
> +extern void evict_inodes(struct super_block *sb);
>  
>  extern void __iget(struct inode * inode);
>  extern void iget_failed(struct inode *);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
