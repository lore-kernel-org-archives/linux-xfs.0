Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HsLkt079886 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:54:21 -0500
Message-ID: <506F1F21.6000104@sgi.com>
Date: Fri, 05 Oct 2012 12:55:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch v4 06/13] [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <20121005171853.985930109@sgi.com>
	<20121005171946.330155632@sgi.com>
In-Reply-To: <20121005171946.330155632@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On 10/05/12 12:18, Ben Myers wrote:
> Index: xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.h
> +++ xfs/fs/xfs/xfs_mount.h
> @@ -198,7 +198,6 @@ typedef struct xfs_mount {
>   #endif
>   	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>   	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> -	struct work_struct	m_flush_work;	/* background inode flush */
>   	__int64_t		m_update_flags;	/* sb flags we need to update
>   						   on the next remount,rw */
>   	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
> @@ -381,6 +380,27 @@ extern int	xfs_dev_is_read_only(struct x
>
>   extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
>
> +/*
> + * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> + * or a page lock.
> + *
> + * We have to hold the s_umount lock here, but because this call can nest
> + * inside i_mutex (the parent directory in the create case, held by the VFS),
> + * we have to use down_read_trylock() to avoid potential deadlocks. In
> + * practice, this trylock will succeed on almost every attempt as
> + * unmount/remount type operations are exceedingly rare.
> + */
> +static inline void
> +xfs_flush_inodes(struct xfs_mount *mp)
> +{
> +	struct super_block *sb = mp->m_super;
> +
> +	if (down_read_trylock(&sb->s_umount)) {
> +		sync_inodes_sb(sb);
> +		up_read(&sb->s_umount);
> +	}
> +}
> +


Was this suppose to be in xfs_inode.h? Otherwise....

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
