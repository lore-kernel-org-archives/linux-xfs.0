Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751956AbeAWOzs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 09:55:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8A7CAADC3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 14:55:47 +0000 (UTC)
Subject: Re: [PATCH 4/4] Use list_head infra-structure for buffer's log items
 list
References: <20180119140847.22934-1-cmaiolino@redhat.com>
 <20180119140847.22934-5-cmaiolino@redhat.com>
 <b401788c-e6b4-0b0c-d9eb-042e93ce7bd4@suse.com>
 <20180123130526.5pr7kjlgq5j2e4e7@odin.usersys.redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e28ab86e-dad7-2310-b0d4-51e113835f18@suse.com>
Date: Tue, 23 Jan 2018 16:55:43 +0200
MIME-Version: 1.0
In-Reply-To: <20180123130526.5pr7kjlgq5j2e4e7@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 23.01.2018 15:05, Carlos Maiolino wrote:
>>> @@ -1025,17 +1016,19 @@ xfs_buf_do_callbacks(
>>>  		lip->li_cb(bp, lip);
>>>  	}
>>>  
>>> -	while ((lip = bp->b_li_list) != NULL) {
>>> -		bp->b_li_list = lip->li_bio_list;
>>> -		ASSERT(lip->li_cb != NULL);
>>> +	while(!list_empty(&bp->b_li_list))
>>> +	{
>>
>> nit: Since you are iterating the list why not the canonical
>> list_for_each_entry_safe it will also obviate the need for
>> list_first_entry.
> 
> Because the callback being called in lip->li_cb, can change the list internally,
> so, even list_for_each_entry_safe here is not really safe, because the "safe"
> pointer, can actually be gone before before the loop starts again
> (see xfs_iflush_done()).

But you invoke del_init before calling the callback, _safe suffix in
list_for_each_entry just means it's safe to call list deletion functions
without compromising list iteration.

> 
> 
>>
>>> +		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
>>> +				       li_bio_list);
>>> +
>>>  		/*
>>> -		 * Clear the next pointer so we don't have any
>>> +		 * Remove the item from the list, so we don't have any
>>>  		 * confusion if the item is added to another buf.
>>>  		 * Don't touch the log item after calling its
>>>  		 * callback, because it could have freed itself.
>>>  		 */
>>> -		lip->li_bio_list = NULL;
>>> -		lip->li_cb(bp, lip);
>>> +		list_del_init(&lip->li_bio_list);
>>> +		lip->li_cb(bp,lip);
>>>  	}
>>>  }
>>>  
>>> @@ -1051,8 +1044,7 @@ STATIC void
>>>  xfs_buf_do_callbacks_fail(
>>>  	struct xfs_buf		*bp)
>>>  {
>>> -	struct xfs_log_item	*lip = bp->b_li_list;
>>> -	struct xfs_log_item	*next;
>>> +	struct xfs_log_item	*lip;
>>>  	struct xfs_ail		*ailp;
>>>  
>>>  	/*
>>> @@ -1060,14 +1052,16 @@ xfs_buf_do_callbacks_fail(
>>>  	 * and xfs_buf_iodone_callback_error, and they have no IO error
>>>  	 * callbacks. Check only for items in b_li_list.
>>>  	 */
>>> -	if (lip == NULL)
>>> +	if (list_empty(&bp->b_li_list)) {
>>>  		return;
>>> -	else
>>> +	} else {
>>> +		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
>>> +				       li_bio_list);
>>>  		ailp = lip->li_ailp;
>>> +	}
>>>  
>>>  	spin_lock(&ailp->xa_lock);
>>> -	for (; lip; lip = next) {
>>> -		next = lip->li_bio_list;
>>> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>>>  		if (lip->li_ops->iop_error)
>>>  			lip->li_ops->iop_error(lip, bp);
>>>  	}
>>> @@ -1079,7 +1073,7 @@ xfs_buf_iodone_callback_error(
>>>  	struct xfs_buf		*bp)
>>>  {
>>>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>>> -	struct xfs_log_item	*lip = bp->b_li_list;
>>> +	struct xfs_log_item	*lip;
>>>  	struct xfs_mount	*mp;
>>>  	static ulong		lasttime;
>>>  	static xfs_buftarg_t	*lasttarg;
>>> @@ -1089,7 +1083,8 @@ xfs_buf_iodone_callback_error(
>>>  	 * The failed buffer might not have a buf_log_item attached or the
>>>  	 * log_item list might be empty. Get the mp from the available xfs_log_item
>>>  	 */
>>> -	if (bip == NULL)
>>> +	if ((lip = list_first_entry_or_null(&bp->b_li_list, struct xfs_log_item,
>>> +					   li_bio_list)))
>>>  		mp = lip->li_mountp;
>>>  	else
>>>  		mp = bip->bli_item.li_mountp;
>>> @@ -1203,7 +1198,7 @@ xfs_buf_iodone_callbacks(
>>>  
>>>  	xfs_buf_do_callbacks(bp);
>>>  	bp->b_log_item = NULL;
>>> -	bp->b_li_list = NULL;
>>> +	list_del_init(&bp->b_li_list);
>>>  	bp->b_iodone = NULL;
>>>  	xfs_buf_ioend(bp);
>>>  }
>>> @@ -1248,10 +1243,9 @@ xfs_buf_iodone(
>>>  bool
>>>  xfs_buf_resubmit_failed_buffers(
>>>  	struct xfs_buf		*bp,
>>> -	struct xfs_log_item	*lip,
>>>  	struct list_head	*buffer_list)
>>>  {
>>> -	struct xfs_log_item	*next;
>>> +	struct xfs_log_item	*lip;
>>>  
>>>  	/*
>>>  	 * Clear XFS_LI_FAILED flag from all items before resubmit
>>> @@ -1259,10 +1253,8 @@ xfs_buf_resubmit_failed_buffers(
>>>  	 * XFS_LI_FAILED set/clear is protected by xa_lock, caller  this
>>>  	 * function already have it acquired
>>>  	 */
>>> -	for (; lip; lip = next) {
>>> -		next = lip->li_bio_list;
>>> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
>>>  		xfs_clear_li_failed(lip);
>>> -	}
>>>  
>>>  	/* Add this buffer back to the delayed write list */
>>>  	return xfs_buf_delwri_queue(bp, buffer_list);
>>> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
>>> index 0febfbbf6ba9..643f53dcfe51 100644
>>> --- a/fs/xfs/xfs_buf_item.h
>>> +++ b/fs/xfs/xfs_buf_item.h
>>> @@ -71,7 +71,6 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>>>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>>>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
>>>  bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
>>> -					struct xfs_log_item *,
>>>  					struct list_head *);
>>>  
>>>  extern kmem_zone_t	*xfs_buf_item_zone;
>>> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
>>> index 664dea105e76..4a4539a4fad5 100644
>>> --- a/fs/xfs/xfs_dquot_item.c
>>> +++ b/fs/xfs/xfs_dquot_item.c
>>> @@ -179,7 +179,7 @@ xfs_qm_dquot_logitem_push(
>>>  		if (!xfs_buf_trylock(bp))
>>>  			return XFS_ITEM_LOCKED;
>>>  
>>> -		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
>>> +		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
>>>  			rval = XFS_ITEM_FLUSHING;
>>>  
>>>  		xfs_buf_unlock(bp);
>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>> index 0a4c2e48402f..8e26d3121be6 100644
>>> --- a/fs/xfs/xfs_inode.c
>>> +++ b/fs/xfs/xfs_inode.c
>>> @@ -2214,7 +2214,7 @@ xfs_ifree_cluster(
>>>  	struct xfs_buf		*bp;
>>>  	xfs_inode_t		*ip;
>>>  	xfs_inode_log_item_t	*iip;
>>> -	xfs_log_item_t		*lip;
>>> +	struct xfs_log_item	*lip;
>>>  	struct xfs_perag	*pag;
>>>  	xfs_ino_t		inum;
>>>  
>>> @@ -2272,8 +2272,7 @@ xfs_ifree_cluster(
>>>  		 * stale first, we will not attempt to lock them in the loop
>>>  		 * below as the XFS_ISTALE flag will be set.
>>>  		 */
>>> -		lip = bp->b_li_list;
>>> -		while (lip) {
>>> +		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>>>  			if (lip->li_type == XFS_LI_INODE) {
>>>  				iip = (xfs_inode_log_item_t *)lip;
>>>  				ASSERT(iip->ili_logged == 1);
>>> @@ -2283,7 +2282,6 @@ xfs_ifree_cluster(
>>>  							&iip->ili_item.li_lsn);
>>>  				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
>>>  			}
>>> -			lip = lip->li_bio_list;
>>>  		}
>>>  
>>>  
>>> @@ -3649,7 +3647,7 @@ xfs_iflush_int(
>>>  	/* generate the checksum. */
>>>  	xfs_dinode_calc_crc(mp, dip);
>>>  
>>> -	ASSERT(bp->b_li_list != NULL);
>>> +	ASSERT(!list_empty(&bp->b_li_list));
>>>  	ASSERT(bp->b_iodone != NULL);
>>>  	return 0;
>>>  
>>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>>> index 993736032b4b..ddfc2c80af5e 100644
>>> --- a/fs/xfs/xfs_inode_item.c
>>> +++ b/fs/xfs/xfs_inode_item.c
>>> @@ -521,7 +521,7 @@ xfs_inode_item_push(
>>>  		if (!xfs_buf_trylock(bp))
>>>  			return XFS_ITEM_LOCKED;
>>>  
>>> -		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
>>> +		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
>>>  			rval = XFS_ITEM_FLUSHING;
>>>  
>>>  		xfs_buf_unlock(bp);
>>> @@ -712,37 +712,23 @@ xfs_iflush_done(
>>>  	struct xfs_log_item	*lip)
>>>  {
>>>  	struct xfs_inode_log_item *iip;
>>> -	struct xfs_log_item	*blip;
>>> -	struct xfs_log_item	*next;
>>> -	struct xfs_log_item	*prev;
>>> +	struct xfs_log_item	*blip, *n;
>>>  	struct xfs_ail		*ailp = lip->li_ailp;
>>>  	int			need_ail = 0;
>>> +	LIST_HEAD(tmp);
>>>  
>>>  	/*
>>>  	 * Scan the buffer IO completions for other inodes being completed and
>>>  	 * attach them to the current inode log item.
>>>  	 */
>>> -	blip = bp->b_li_list;
>>> -	prev = NULL;
>>> -	while (blip != NULL) {
>>> -		if (blip->li_cb != xfs_iflush_done) {
>>> -			prev = blip;
>>> -			blip = blip->li_bio_list;
>>> -			continue;
>>> -		}
>>>  
>>> -		/* remove from list */
>>> -		next = blip->li_bio_list;
>>> -		if (!prev) {
>>> -			bp->b_li_list = next;
>>> -		} else {
>>> -			prev->li_bio_list = next;
>>> -		}
>>> +	list_add_tail(&lip->li_bio_list, &tmp);
>>>  
>>> -		/* add to current list */
>>> -		blip->li_bio_list = lip->li_bio_list;
>>> -		lip->li_bio_list = blip;
>>> +	list_for_each_entry_safe(blip, n, &bp->b_li_list, li_bio_list) {
>>> +		if (lip->li_cb != xfs_iflush_done)
>>> +			continue;
>>>  
>>> +		list_move_tail(&blip->li_bio_list, &tmp);
>>>  		/*
>>>  		 * while we have the item, do the unlocked check for needing
>>>  		 * the AIL lock.
>>> @@ -751,8 +737,6 @@ xfs_iflush_done(
>>>  		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
>>>  		    (blip->li_flags & XFS_LI_FAILED))
>>>  			need_ail++;
>>> -
>>> -		blip = next;
>>>  	}
>>>  
>>>  	/* make sure we capture the state of the initial inode. */
>>> @@ -775,7 +759,7 @@ xfs_iflush_done(
>>>  
>>>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>>>  		spin_lock(&ailp->xa_lock);
>>> -		for (blip = lip; blip; blip = blip->li_bio_list) {
>>> +		list_for_each_entry(blip, &tmp, li_bio_list) {
>>>  			if (INODE_ITEM(blip)->ili_logged &&
>>>  			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
>>>  				mlip_changed |= xfs_ail_delete_one(ailp, blip);
>>> @@ -801,15 +785,14 @@ xfs_iflush_done(
>>>  	 * ili_last_fields bits now that we know that the data corresponding to
>>>  	 * them is safely on disk.
>>>  	 */
>>> -	for (blip = lip; blip; blip = next) {
>>> -		next = blip->li_bio_list;
>>> -		blip->li_bio_list = NULL;
>>> -
>>> +	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
>>> +		list_del_init(&blip->li_bio_list);
>>>  		iip = INODE_ITEM(blip);
>>>  		iip->ili_logged = 0;
>>>  		iip->ili_last_fields = 0;
>>>  		xfs_ifunlock(iip->ili_inode);
>>>  	}
>>> +	list_del(&tmp);
>>>  }
>>>  
>>>  /*
>>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>>> index 861c84e1f674..1b5082aeb538 100644
>>> --- a/fs/xfs/xfs_log.c
>>> +++ b/fs/xfs/xfs_log.c
>>> @@ -1047,6 +1047,7 @@ xfs_log_item_init(
>>>  
>>>  	INIT_LIST_HEAD(&item->li_ail);
>>>  	INIT_LIST_HEAD(&item->li_cil);
>>> +	INIT_LIST_HEAD(&item->li_bio_list);
>>>  }
>>>  
>>>  /*
>>> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
>>> index 571fe499a48f..950cb9b4e36e 100644
>>> --- a/fs/xfs/xfs_trans.h
>>> +++ b/fs/xfs/xfs_trans.h
>>> @@ -50,7 +50,7 @@ typedef struct xfs_log_item {
>>>  	uint				li_type;	/* item type */
>>>  	uint				li_flags;	/* misc flags */
>>>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
>>> -	struct xfs_log_item		*li_bio_list;	/* buffer item list */
>>> +	struct list_head		li_bio_list;	/* buffer item list */
>>>  	void				(*li_cb)(struct xfs_buf *,
>>>  						 struct xfs_log_item *);
>>>  							/* buffer item iodone */
>>>
> 
