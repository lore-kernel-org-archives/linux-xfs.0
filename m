Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727082AbfFXQG0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 12:06:26 -0400
Subject: Re: [PATCH 09/12] xfs: refactor the ioend merging code
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-10-hch@lst.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e42c54c4-4c64-8185-8ac3-cca38ad8e8a4@suse.com>
Date: Mon, 24 Jun 2019 19:06:22 +0300
MIME-Version: 1.0
In-Reply-To: <20190624055253.31183-10-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org



On 24.06.19 г. 8:52 ч., Christoph Hellwig wrote:
> Introduce two nicely abstracted helper, which can be moved to the
> iomap code later.  Also use list_pop and list_first_entry_or_null
> to simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 66 ++++++++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index acbd73976067..5d302ebe2a33 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -121,6 +121,19 @@ xfs_destroy_ioend(
>  	}
>  }
>  
> +static void
> +xfs_destroy_ioends(
> +	struct xfs_ioend	*ioend,
> +	int			error)
> +{
> +	struct list_head	tmp;
> +
> +	list_replace_init(&ioend->io_list, &tmp);
> +	xfs_destroy_ioend(ioend, error);
> +	while ((ioend = list_pop(&tmp, struct xfs_ioend, io_list)))
> +		xfs_destroy_ioend(ioend, error);

nit: I'd prefer if the list_pop patch is right before this one since
this is the first user of it. Additionally, I don't think list_pop is
really a net-negative win in comparison to list_for_each_entry_safe
here. In fact this "delete the list" would seems more idiomatic if
implemented via list_for_each_entry_safe

> +}
> +
>  /*
>   * Fast and loose check if this write could update the on-disk inode size.
>   */
> @@ -173,7 +186,6 @@ xfs_end_ioend(
>  	struct xfs_ioend	*ioend)
>  {
>  	unsigned int		nofs_flag = memalloc_nofs_save();
> -	struct list_head	ioend_list;
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
> @@ -207,16 +219,7 @@ xfs_end_ioend(
>  	if (!error && xfs_ioend_is_append(ioend))
>  		error = xfs_setfilesize(ip, offset, size);
>  done:
> -	list_replace_init(&ioend->io_list, &ioend_list);
> -	xfs_destroy_ioend(ioend, error);
> -
> -	while (!list_empty(&ioend_list)) {
> -		ioend = list_first_entry(&ioend_list, struct xfs_ioend,
> -				io_list);
> -		list_del_init(&ioend->io_list);
> -		xfs_destroy_ioend(ioend, error);
> -	}
> -
> +	xfs_destroy_ioends(ioend, error);
>  	memalloc_nofs_restore(nofs_flag);
>  }
>  
> @@ -246,15 +249,16 @@ xfs_ioend_try_merge(
>  	struct xfs_ioend	*ioend,
>  	struct list_head	*more_ioends)
>  {
> -	struct xfs_ioend	*next_ioend;
> +	struct xfs_ioend	*next;
>  
> -	while (!list_empty(more_ioends)) {
> -		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
> -				io_list);
> -		if (!xfs_ioend_can_merge(ioend, next_ioend))
> +	INIT_LIST_HEAD(&ioend->io_list);
> +
> +	while ((next = list_first_entry_or_null(more_ioends, struct xfs_ioend,
> +			io_list))) {
> +		if (!xfs_ioend_can_merge(ioend, next))
>  			break;
> -		list_move_tail(&next_ioend->io_list, &ioend->io_list);
> -		ioend->io_size += next_ioend->io_size;
> +		list_move_tail(&next->io_list, &ioend->io_list);
> +		ioend->io_size += next->io_size;
>  	}
>  }
>  
> @@ -277,29 +281,31 @@ xfs_ioend_compare(
>  	return 0;
>  }
>  
> +static void
> +xfs_sort_ioends(
> +	struct list_head	*ioend_list)
> +{
> +	list_sort(NULL, ioend_list, xfs_ioend_compare);
> +}
> +
>  /* Finish all pending io completions. */
>  void
>  xfs_end_io(
>  	struct work_struct	*work)
>  {
> -	struct xfs_inode	*ip;
> +	struct xfs_inode	*ip =
> +		container_of(work, struct xfs_inode, i_ioend_work);
>  	struct xfs_ioend	*ioend;
> -	struct list_head	completion_list;
> +	struct list_head	tmp;
>  	unsigned long		flags;
>  
> -	ip = container_of(work, struct xfs_inode, i_ioend_work);
> -
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> -	list_replace_init(&ip->i_ioend_list, &completion_list);
> +	list_replace_init(&ip->i_ioend_list, &tmp);
>  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
>  
> -	list_sort(NULL, &completion_list, xfs_ioend_compare);
> -
> -	while (!list_empty(&completion_list)) {
> -		ioend = list_first_entry(&completion_list, struct xfs_ioend,
> -				io_list);
> -		list_del_init(&ioend->io_list);
> -		xfs_ioend_try_merge(ioend, &completion_list);
> +	xfs_sort_ioends(&tmp);
> +	while ((ioend = list_pop(&tmp, struct xfs_ioend, io_list))) {
> +		xfs_ioend_try_merge(ioend, &tmp);
>  		xfs_end_ioend(ioend);

Here again, tmp is a local copy that is immutable so using while()
instead of list_for_each_entry_safe doesn't seem to be providing much.

>  	}
>  }
> 
