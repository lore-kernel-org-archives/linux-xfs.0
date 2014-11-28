Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3CDC97F3F
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2014 10:24:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D854304059
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2014 08:24:52 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9yJB9AtJwtMkvKBe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Nov 2014 08:24:50 -0800 (PST)
Date: Fri, 28 Nov 2014 17:24:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Message-ID: <20141128162445.GB27902@quack.suse.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-3-git-send-email-tytso@mit.edu>
	<20141127131421.GE30152@quack.suse.cz>
	<20141127230016.GH14091@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127230016.GH14091@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Thu 27-11-14 18:00:16, Ted Tso wrote:
> On Thu, Nov 27, 2014 at 02:14:21PM +0100, Jan Kara wrote:
> > * change queue_io() to also call
> > 	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io, time + 24hours)
> >   For this you need to tweak move_expired_inodes() to take pointer to
> >   timestamp instead of pointer to work but that's trivial. Also you want
> >   probably leave time ->older_than_this value (i.e. without +24 hours) if
> >   we are doing WB_SYNC_ALL writeback. With this you can remove
> >   flush_sb_dirty_time() completely.
> 
> Well.... it's not quite enough.  The problem is that for ext3 and
> ext4, the actual work of writing the inode happens in dirty_inode(),
> not in write_inode().  Which means we need to do something like this.
  Right, I didn't realize this problem.

> I'm not entirely sure whether or not this is too ugly to live;
> personally, I think my hack of handling this in update_time() might be
> preferable....
  Actually handling the copying of timestamps in __writeback_single_inode()
would look fine to me. You mention in your next email, calling
mark_inode_dirty_sync() from flusher may be problematic - why? How is this
any different from calling mark_inode_dirty_sync() from
flush_sb_dirty_time()?

I will note that for a while I thought copying the full inode to on-disk
buffer may be problematic because inode may be in an intermediate state of
some transactional change. But that isn't an issue - if there's any
transactional change in progress, it has a handle open and until the
change is node, thus the buffer with the partial change cannot go to the
journal (transaction cannot commit) until mark_inode_dirty_sync() copies
the final state of the inode.

Another solution may be to convey the information that copying of timestamps
is necessary to ->write_inode method. We could do that via a
flag bit in writeback_control. Each filesystem can then copy timestamps
when this bit is set. But calling mark_inode_dirty_sync() from
__writeback_single_inode() looks simpler to me.

								Honza

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index b93c529..95a42b3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -253,7 +253,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
>   */
>  static int move_expired_inodes(struct list_head *delaying_queue,
>  			       struct list_head *dispatch_queue,
> -			       struct wb_writeback_work *work)
> +			       unsigned long *older_than_this)
>  {
>  	LIST_HEAD(tmp);
>  	struct list_head *pos, *node;
> @@ -264,8 +264,8 @@ static int move_expired_inodes(struct list_head *delaying_queue,
>  
>  	while (!list_empty(delaying_queue)) {
>  		inode = wb_inode(delaying_queue->prev);
> -		if (work->older_than_this &&
> -		    inode_dirtied_after(inode, *work->older_than_this))
> +		if (older_than_this &&
> +		    inode_dirtied_after(inode, *older_than_this))
>  			break;
>  		list_move(&inode->i_wb_list, &tmp);
>  		moved++;
> @@ -309,9 +309,14 @@ out:
>  static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	int moved;
> +	unsigned long one_day_later = jiffies + (HZ * 86400);
> +
>  	assert_spin_locked(&wb->list_lock);
>  	list_splice_init(&wb->b_more_io, &wb->b_io);
> -	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, work);
> +	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io,
> +				    work->older_than_this);
> +	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
> +				     &one_day_later);
>  	trace_writeback_queue_io(wb, work, moved);
>  }
>  
> @@ -637,6 +642,17 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		}
>  
>  		/*
> +		 * If the inode is marked dirty time but is not dirty,
> +		 * then at last for ext3 and ext4 we need to call
> +		 * mark_inode_dirty_sync in order to get the inode
> +		 * timestamp transferred to the on disk inode, since
> +		 * write_inode is a no-op for those file systems.  HACK HACK HACK
> +		 */
> +		if ((inode->i_state & I_DIRTY_TIME) &&
> +		    ((inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) == 0))
> +			mark_inode_dirty_sync(inode);
> +
> +		/*
>  		 * Don't bother with new inodes or inodes being freed, first
>  		 * kind does not need periodic writeout yet, and for the latter
>  		 * kind writeout is handled by the freer.
> @@ -1233,9 +1249,10 @@ void inode_requeue_dirtytime(struct inode *inode)
>  	spin_lock(&bdi->wb.list_lock);
>  	spin_lock(&inode->i_lock);
>  	if ((inode->i_state & I_DIRTY_WB) == 0) {
> -		if (inode->i_state & I_DIRTY_TIME)
> +		if (inode->i_state & I_DIRTY_TIME) {
> +			inode->dirtied_when = jiffies;
>  			list_move(&inode->i_wb_list, &bdi->wb.b_dirty_time);
> -		else
> +		} else
>  			list_del_init(&inode->i_wb_list);
>  	}
>  	spin_unlock(&inode->i_lock);
> 
> Comments?
> 
> 						- Ted
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
