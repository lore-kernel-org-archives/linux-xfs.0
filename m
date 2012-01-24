Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O85GNw222207 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 02:05:16 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	McQSQ9wpyUH9VSb2 for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 00:05:13 -0800 (PST)
Date: Tue, 24 Jan 2012 19:05:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: Use generic writers counter instead of
	m_active_trans counter
Message-ID: <20120124080511.GN15102@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327091686-23177-7-git-send-email-jack@suse.cz>
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
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jan 20, 2012 at 09:34:44PM +0100, Jan Kara wrote:
> m_active_trans counter is racy wrt filesystem freezing. The patch replaces it
> with generic counter of running transactions which is properly synchronized
> with filesystem freezing. Things are a bit more complex because we need to log
> a dummy transaction and free block counters after the filesystem is frozen so
> we need to pass information to _xfs_trans_alloc() whether the transaction is
> part of filesystem freezing or not.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_fsops.c |    5 +++--
>  fs/xfs/xfs_fsops.h |    2 +-
>  fs/xfs/xfs_iomap.c |    4 ++--
>  fs/xfs/xfs_mount.c |    2 +-
>  fs/xfs/xfs_mount.h |    2 --
>  fs/xfs/xfs_super.c |    3 +--
>  fs/xfs/xfs_sync.c  |   13 +++----------
>  fs/xfs/xfs_trans.c |   19 ++++++++++++-------
>  fs/xfs/xfs_trans.h |    3 ++-
>  9 files changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 1c6fdeb..503fdfa 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -645,12 +645,13 @@ out:
>   */
>  int
>  xfs_fs_log_dummy(
> -	xfs_mount_t	*mp)
> +	xfs_mount_t	*mp,
> +	bool		for_freeze)

What does "for_freeze" mean? If it is true, does it mean we are in a
freeze or not in a freeze? I can't really tell from the code,
because it just passed true or false, and in one case the code
always passes false even though the code can be called after
SB_FREEZE_WRITE is set (xfs_quiesce_data() via sync_filesystem())

>  #endif	/* __XFS_FSOPS_H__ */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9afa282..fd47f6e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -679,8 +679,8 @@ xfs_iomap_write_unwritten(
>  		 * the same inode that we complete here and might deadlock
>  		 * on the iolock.
>  		 */
> -		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
> +		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE,
> +				KM_NOFS, false);

This is a documentation regression - the code was clearly self
documenting w.r.t. frozen filesystem behaviour. It isn't anymore.

I'd suggest that we need:

#define XFS_WAIT_FOR_FREEZE	false
#define XFS_IGNORE_FROZEN_SB	true

as the parameters here to makeit extremely clear when reading the
code exactly what that last parameter means. i.e. it is self
documenting. That will help clear up a lot of the confusion on what
these magic boolean parameters are supposed to mean....

> @@ -312,7 +311,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
>  
>  #define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)

I'd remove this, too, and just open code it.

> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index aa3dc1a..24f4d7c 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -373,7 +373,7 @@ xfs_quiesce_data(
>  
>  	/* mark the log as covered if needed */
>  	if (xfs_log_need_covered(mp))
> -		error2 = xfs_fs_log_dummy(mp);
> +		error2 = xfs_fs_log_dummy(mp, false);

This is the call that can occur inside SB_FREEZE_WRITE context as
well as outside it.

>  
>  	/* flush data-only devices */
>  	if (mp->m_rtdev_targp)
> @@ -421,18 +421,11 @@ xfs_quiesce_attr(
>  	int	error = 0;
>  
>  	/* wait for all modifications to complete */
> -	while (atomic_read(&mp->m_active_trans) > 0)
> -		delay(100);
> +	sb_wait_write(mp->m_super, SB_FREEZE_TRANS);
>  
>  	/* flush inodes and push all remaining buffers out to disk */
>  	xfs_quiesce_fs(mp);
>  
> -	/*
> -	 * Just warn here till VFS can correctly support
> -	 * read-only remount without racing.
> -	 */
> -	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
> -

Now there's an interesting question. Does this break read-only
remount?

/me checks the sb_wait_write() code

No, it looks like it should be fine.

>  	/* Push the superblock and write an unmount record */
>  	error = xfs_log_sbcount(mp);
>  	if (error)
> @@ -467,7 +460,7 @@ xfs_sync_worker(
>  		/* dgc: errors ignored here */
>  		if (mp->m_super->s_frozen == SB_UNFROZEN &&
>  		    xfs_log_need_covered(mp))
> -			error = xfs_fs_log_dummy(mp);
> +			error = xfs_fs_log_dummy(mp, false);
>  		else
>  			xfs_log_force(mp, 0);
>  		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 1f35b2f..e97014b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -577,24 +577,28 @@ xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type)
>  {
> -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> +	return _xfs_trans_alloc(mp, type, KM_SLEEP, false);
>  }
>  
>  xfs_trans_t *
>  _xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type,
> -	uint		memflags)
> +	uint		memflags,
> +	bool		freezing)
>  {
>  	xfs_trans_t	*tp;
>  
> -	atomic_inc(&mp->m_active_trans);
> -
> +	if (!freezing)
> +		sb_start_write(mp->m_super, SB_FREEZE_TRANS);
> +	else
> +		WARN_ON(xfs_test_for_freeze(mp) != SB_FREEZE_TRANS);

Just open code xfs_test_for_freeze() and add a line of whitespace
after this.

>  	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
>  	tp->t_magic = XFS_TRANS_MAGIC;
>  	tp->t_type = type;
>  	tp->t_mountp = mp;
> +	if (freezing)
> +		tp->t_flags |= XFS_TRANS_FREEZING;

Simply assign the value - tp->t_flags is guaranteed to be 0 right
now.

>  	INIT_LIST_HEAD(&tp->t_items);
>  	INIT_LIST_HEAD(&tp->t_busy);
>  	return tp;
> @@ -611,7 +615,8 @@ xfs_trans_free(
>  	xfs_alloc_busy_sort(&tp->t_busy);
>  	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
> -	atomic_dec(&tp->t_mountp->m_active_trans);
> +	if (!(tp->t_flags & XFS_TRANS_FREEZING))
> +		sb_end_write(tp->t_mountp->m_super, SB_FREEZE_TRANS);
>  	xfs_trans_free_dqinfo(tp);
>  	kmem_zone_free(xfs_trans_zone, tp);
>  }
> @@ -654,7 +659,7 @@ xfs_trans_dup(
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
>  
> -	atomic_inc(&tp->t_mountp->m_active_trans);
> +	sb_dup_write(tp->t_mountp->m_super, SB_FREEZE_TRANS);

That's strangly named. Isn't the normal thing to do here use a "__"
prefix for operations that just need an extra reference because they
already have one (i.e. __sb_start_write())?

This also looks broken with repsect to the new XFS_TRANS_FREEZING
flag. If it is set on the parent, it needs to be set on the
duplicated transaction. And if it is set, then no extra reference
should be taken.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
