Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfC1OJK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:09:10 -0400
Date: Thu, 28 Mar 2019 10:08:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: implement per-inode writeback completion
Message-ID: <20190328140859.GA17056@bfoster>
References: <20190327030550.GZ1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327030550.GZ1183@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 26, 2019 at 08:05:50PM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> Here's a quick patchset reworking writeback ioend completion processing
> into per-inode completion queues so that we don't have a thundering herd
> of unwritten/cow completion kworkers contending for the ILOCK.  The
> second patch will also combine adjacent ioends when possible to reduce
> the overhead further.  Let me know what you think. :)
> 

I assume the issue is that you get a bunch of ioends associated with COW
remaps or whatever and workqueue parallelism leads to a bunch contending
on inode locks because they happen to be associated with the same inode.
Hence, it's more efficient to have a single work item per inode, let
that task complete as many ioends as available for the inode and let the
workqueue spread around workers for different inodes. Sounds like a nice
idea to me. Is there a workload that measurably benefits from this or is
this just based on observation?

A couple small nits..

> --D
> ---
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Restructure the buffered writeback completion code to use a single work
> item per inode, since it's pointless to awaken a thundering herd of
> threads to contend on a single inode's ILOCK.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_aops.c   |   48 +++++++++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_aops.h   |    1 -
>  fs/xfs/xfs_icache.c |    3 +++
>  fs/xfs/xfs_inode.h  |    7 +++++++
>  4 files changed, 47 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3619e9e8d359..f7a9bb661826 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -234,11 +234,9 @@ xfs_setfilesize_ioend(
>   * IO write completion.
>   */
>  STATIC void
> -xfs_end_io(
> -	struct work_struct *work)
> +xfs_end_ioend(
> +	struct xfs_ioend	*ioend)
>  {
> -	struct xfs_ioend	*ioend =
> -		container_of(work, struct xfs_ioend, io_work);
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
> @@ -278,19 +276,48 @@ xfs_end_io(
>  	xfs_destroy_ioend(ioend, error);
>  }
>  
> +/* Finish all pending io completions. */
> +void
> +xfs_end_io(
> +	struct work_struct	*work)
> +{
> +	struct xfs_inode	*ip;
> +	struct xfs_ioend	*ioend;
> +	struct list_head	completion_list;
> +	unsigned long		flags;
> +
> +	ip = container_of(work, struct xfs_inode, i_iodone_work);
> +
> +	spin_lock_irqsave(&ip->i_iodone_lock, flags);
> +	list_replace_init(&ip->i_iodone_list, &completion_list);
> +	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
> +
> +	while (!list_empty(&completion_list)) {
> +		ioend = list_first_entry(&completion_list, struct xfs_ioend,
> +				io_list);
> +		list_del_init(&ioend->io_list);
> +		xfs_end_ioend(ioend);
> +	}
> +}
> +
>  STATIC void
>  xfs_end_bio(
>  	struct bio		*bio)
>  {
>  	struct xfs_ioend	*ioend = bio->bi_private;
> -	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	unsigned long		flags;
>  
>  	if (ioend->io_fork == XFS_COW_FORK ||
> -	    ioend->io_state == XFS_EXT_UNWRITTEN)
> -		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
> -	else if (ioend->io_append_trans)
> -		queue_work(mp->m_data_workqueue, &ioend->io_work);
> -	else
> +	    ioend->io_state == XFS_EXT_UNWRITTEN ||
> +	    ioend->io_append_trans != NULL) {
> +		spin_lock_irqsave(&ip->i_iodone_lock, flags);
> +		if (list_empty(&ip->i_iodone_list))
> +			queue_work(mp->m_unwritten_workqueue, &ip->i_iodone_work);
> +		list_add_tail(&ioend->io_list, &ip->i_iodone_list);
> +		spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
> +	} else

Ok, so there's no longer a need for multiple ioend workqueues because
all such operations are going to be processed by the single work
execution. Perhaps we should rename m_unwritten_workqueue or just use
m_data_workqueue since it happens to have a more generic name. We can
also kill off the other wq either way since it appears to be unused.

>  		xfs_destroy_ioend(ioend, blk_status_to_errno(bio->bi_status));
>  }
>  
> @@ -594,7 +621,6 @@ xfs_alloc_ioend(
>  	ioend->io_inode = inode;
>  	ioend->io_size = 0;
>  	ioend->io_offset = offset;
> -	INIT_WORK(&ioend->io_work, xfs_end_io);
>  	ioend->io_append_trans = NULL;
>  	ioend->io_bio = bio;
>  	return ioend;
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 6c2615b83c5d..f62b03186c62 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -18,7 +18,6 @@ struct xfs_ioend {
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	xfs_off_t		io_offset;	/* offset in the file */
> -	struct work_struct	io_work;	/* xfsdatad work queue */
>  	struct xfs_trans	*io_append_trans;/* xact. for size update */
>  	struct bio		*io_bio;	/* bio being built */
>  	struct bio		io_inline_bio;	/* MUST BE LAST! */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 245483cc282b..e70e7db29026 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -70,6 +70,9 @@ xfs_inode_alloc(
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
>  	memset(&ip->i_d, 0, sizeof(ip->i_d));
> +	INIT_WORK(&ip->i_iodone_work, xfs_end_io);
> +	INIT_LIST_HEAD(&ip->i_iodone_list);
> +	spin_lock_init(&ip->i_iodone_lock);
>  
>  	return ip;
>  }
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e62074a5257c..88239c2dd824 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -57,6 +57,11 @@ typedef struct xfs_inode {
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
> +
> +	/* pending io completions */
> +	spinlock_t		i_iodone_lock;
> +	struct work_struct	i_iodone_work;
> +	struct list_head	i_iodone_list;

A nit but I guess I'd name these with ioend instead of iodone. The
latter kind of confuses with buffer iodone callbacks (to me).

Brian

>  } xfs_inode_t;
>  
>  /* Convert from vfs inode to xfs inode */
> @@ -503,4 +508,6 @@ bool xfs_inode_verify_forks(struct xfs_inode *ip);
>  int xfs_iunlink_init(struct xfs_perag *pag);
>  void xfs_iunlink_destroy(struct xfs_perag *pag);
>  
> +void xfs_end_io(struct work_struct *work);
> +
>  #endif	/* __XFS_INODE_H__ */
