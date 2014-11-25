Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA09A7F51
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 19:52:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6CE838F8035
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 17:52:45 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fOOHgY0Rr39OjSfB for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 17:52:43 -0800 (PST)
Date: Tue, 25 Nov 2014 12:52:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125015239.GD27262@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416599964-21892-3-git-send-email-tytso@mit.edu>
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 21, 2014 at 02:59:22PM -0500, Theodore Ts'o wrote:
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
> 
> Google-Bug-Id: 18297052
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/fs-writeback.c       | 38 +++++++++++++++++++++++++++++++++++++-
>  fs/inode.c              | 18 ++++++++++++++++++
>  fs/proc_namespace.c     |  1 +
>  fs/sync.c               |  7 +++++++
>  include/linux/fs.h      |  1 +
>  include/uapi/linux/fs.h |  1 +
>  6 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ef9bef1..ce7de22 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -483,7 +483,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		inode->i_state &= ~I_DIRTY_PAGES;
>  	dirty = inode->i_state & I_DIRTY;
> -	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> +	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_TIME);
>  	spin_unlock(&inode->i_lock);
>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
>  	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
> @@ -1277,6 +1277,41 @@ static void wait_sb_inodes(struct super_block *sb)
>  	iput(old_inode);
>  }
>  
> +/*
> + * This works like wait_sb_inodes(), but it is called *before* we kick
> + * the bdi so the inodes can get written out.
> + */
> +static void flush_sb_dirty_time(struct super_block *sb)
> +{
> +	struct inode *inode, *old_inode = NULL;
> +
> +	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> +	spin_lock(&inode_sb_list_lock);
> +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		int dirty_time;
> +
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}
> +		dirty_time = inode->i_state & I_DIRTY_TIME;
> +		__iget(inode);
> +		spin_unlock(&inode->i_lock);
> +		spin_unlock(&inode_sb_list_lock);
> +
> +		iput(old_inode);
> +		old_inode = inode;
> +
> +		if (dirty_time)
> +			mark_inode_dirty(inode);
> +		cond_resched();
> +		spin_lock(&inode_sb_list_lock);
> +	}
> +	spin_unlock(&inode_sb_list_lock);
> +	iput(old_inode);
> +}

This just seems wrong to me, not to mention extremely expensive when we have
millions of cached inodes on the superblock.

Why can't we just add a function like mark_inode_dirty_time() which
puts the inode on the dirty inode list with a writeback time 24
hours in the future rather than 30s in the future?



> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -534,6 +534,18 @@ static void evict(struct inode *inode)
>  	BUG_ON(!(inode->i_state & I_FREEING));
>  	BUG_ON(!list_empty(&inode->i_lru));
>  
> +	if (inode->i_nlink && inode->i_state & I_DIRTY_TIME) {
> +		if (inode->i_op->write_time)
> +			inode->i_op->write_time(inode);
> +		else if (inode->i_sb->s_op->write_inode) {
> +			struct writeback_control wbc = {
> +				.sync_mode = WB_SYNC_NONE,
> +			};
> +			mark_inode_dirty(inode);
> +			inode->i_sb->s_op->write_inode(inode, &wbc);
> +		}
> +	}
> +

Eviction is too late for this. I'm pretty sure that it won't get
this far as iput_final() should catch the I_DIRTY_TIME in the !drop
case via write_inode_now().


>  int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> +	struct inode *inode = file->f_mapping->host;
> +
>  	if (!file->f_op->fsync)
>  		return -EINVAL;
> +	if (!datasync && inode->i_state & I_DIRTY_TIME) {

FWIW, I'm surprised gcc isn't throwing warnings about that. Please
make sure there isn't any ambiguity in the code by writing those
checks like this:

	if (!datasync && (inode->i_state & I_DIRTY_TIME)) {

> +		spin_lock(&inode->i_lock);
> +		inode->i_state |= I_DIRTY_SYNC;
> +		spin_unlock(&inode->i_lock);
> +	}
>  	return file->f_op->fsync(file, start, end, datasync);

When we mark the inode I_DIRTY_TIME, we should also be marking it
I_DIRTY_SYNC so that all the sync operations know that they should
be writing this inode. That's partly why I also think these inodes
should be tracked on the dirty inode list....

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3633239..489b2f2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1721,6 +1721,7 @@ struct super_operations {
>  #define __I_DIO_WAKEUP		9
>  #define I_DIO_WAKEUP		(1 << I_DIO_WAKEUP)
>  #define I_LINKABLE		(1 << 10)
> +#define I_DIRTY_TIME		(1 << 11)
>  
>  #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)

Shouldn't I_DIRTY also include I_DIRTY_TIME now?

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
