Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BB367F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 07:14:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19F42AC003
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 05:14:29 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0OA9z4rrN9LYWCV8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 05:14:26 -0800 (PST)
Date: Thu, 27 Nov 2014 14:14:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Message-ID: <20141127131421.GE30152@quack.suse.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416997437-26092-3-git-send-email-tytso@mit.edu>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Wed 26-11-14 05:23:52, Ted Tso wrote:
> Add a new mount option which enables a new "lazytime" mode.  This mode
> causes atime, mtime, and ctime updates to only be made to the
> in-memory version of the inode.  The on-disk times will only get
> updated when (a) if the inode needs to be updated for some non-time
> related change, (b) if userspace calls fsync(), syncfs() or sync(), or
> (c) just before an undeleted inode is evicted from memory.
> 
> This is OK according to POSIX because there are no guarantees after a
> crash unless userspace explicitly requests via a fsync(2) call.
> 
> For workloads which feature a large number of random write to a
> preallocated file, the lazytime mount option significantly reduces
> writes to the inode table.  The repeated 4k writes to a single block
> will result in undesirable stress on flash devices and SMR disk
> drives.  Even on conventional HDD's, the repeated writes to the inode
> table block will trigger Adjacent Track Interference (ATI) remediation
> latencies, which very negatively impact 99.9 percentile latencies ---
> which is a very big deal for web serving tiers (for example).
  So this looks better to me than previous versions but I'm still not 100%
happy :)

Looking into the code & your patch I'd prefer to do something like:
* add support for I_DIRTY_TIME in __mark_inode_dirty() - update_time will
  call __mark_inode_dirty() with this flag if any of the times was updated.
  That way we can just remove your ->write_time() callback - filesystems
  can just handle this in their ->dirty_inode() methods if they wish.
  __mark_inode_dirty() will take care of moving inode into proper writeback
  list (i_dirty / i_dirty_time), dirtied_when will be set to current time.
* change queue_io() to also call
	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io, time + 24hours)
  For this you need to tweak move_expired_inodes() to take pointer to
  timestamp instead of pointer to work but that's trivial. Also you want
  probably leave time ->older_than_this value (i.e. without +24 hours) if
  we are doing WB_SYNC_ALL writeback. With this you can remove
  flush_sb_dirty_time() completely.
* Changes for iput() & fsync stay as they are.

And this should be all that's necessary. I'm not 100% sure about your dirty
bits naming changes - let's see how that will look like when the above more
substantial changes are done.

One technical detail below:

> diff --git a/fs/inode.c b/fs/inode.c
> index 8f5c4b5..9e464cc 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1430,11 +1430,22 @@ static void iput_final(struct inode *inode)
>   */
>  void iput(struct inode *inode)
>  {
> -	if (inode) {
> -		BUG_ON(inode->i_state & I_CLEAR);
> -
> -		if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
> -			iput_final(inode);
> +	if (!inode)
> +		return;
> +	BUG_ON(inode->i_state & I_CLEAR);
  I think we can better handle this without retry at this place like:
	if (atomic_read(&inode->i_count) == 1 && inode->i_nlink &&
	    (inode->i_state & I_DIRTY_TIME)) {
		if (inode->i_op->write_time)
			inode->i_op->write_time(inode);
		else if (inode->i_sb->s_op->write_inode)
			mark_inode_dirty_sync(inode);
	}
  Sure it will be one more read of i_count in the fast path but that's IMO
negligible.

BTW: Is the test for ->write_inode really needed? We don't do it e.g. in
update_time().

> +retry:
> +	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
> +		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> +			atomic_inc(&inode->i_count);
> +			inode->i_state &= ~I_DIRTY_TIME;
> +			spin_unlock(&inode->i_lock);
> +			if (inode->i_op->write_time)
> +				inode->i_op->write_time(inode);
> +			else if (inode->i_sb->s_op->write_inode)
> +				mark_inode_dirty_sync(inode);
> +			goto retry;
> +		}
> +		iput_final(inode);
>  	}
>  }
>  EXPORT_SYMBOL(iput);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
