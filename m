Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2133Ki7069454 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 21:03:20 -0600
Date: Wed, 29 Feb 2012 21:03:24 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120301030324.GX28391@sgi.com>
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
	<20120229005351.GV3592@dastard> <20120229014906.GX3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229014906.GX3592@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Hi Dave,

Eric mentioned a really excellent bugfix earlier.  This must be it.

On Wed, Feb 29, 2012 at 12:49:06PM +1100, Dave Chinner wrote:
> xfs: fix inode lookup race
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we get concurrent lookups of the same inode that is not in the
> per-AG inode cache, there is a race condition that triggers warnings
> in unlock_new_inode() indicating that we are initialising an inode
> that isn't in a the correct state for a new inode.
> 
> When we do an inode lookup via a file handle or a bulkstat, we don't
> serialise lookups at a higher level through the dentry cache (i.e.
> pathless lookup), and so we can get concurrent lookups of the same
> inode.
> 
> The race condition is between the insertion of the inode into the
> cache in the case of a cache miss and a concurrently lookup:
> 
> Thread 1			Thread 2
> xfs_iget()
>   xfs_iget_cache_miss()
>     xfs_iread()
>     lock radix tree
>     radix_tree_insert()
>     				rcu_read_lock
> 				radix_tree_lookup
> 				lock inode flags
> 				XFS_INEW not set
> 				igrab()
> 				unlock inode flags
> 				rcu_read_unlock
> 				use uninitialised inode
> 				.....
>     lock inode flags
>     set XFS_INEW
>     unlock inode flags
>     unlock radix tree
>   xfs_setup_inode()
>     inode flags = I_NEW
>     unlock_new_inode()
>       WARNING as inode flags != I_NEW
> 
> This can lead to inode corruption, inode list corruption, etc, and
> is generally a bad thing to occur.
> 
> Fix this by setting XFS_INEW before inserting the inode into the
> radix tree. This will ensure any concurrent lookup will find the new
> inode with XFS_INEW set and that forces the lookup to wait until the
> XFS_INEW flag is removed before allowing the lookup to succeed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iget.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index 05bed2b..2467ab7 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -350,9 +350,19 @@ xfs_iget_cache_miss(
>  			BUG();
>  	}
>  
> -	spin_lock(&pag->pag_ici_lock);
> +	/* These values _must_ be set before inserting the inode into the radix
> +	 * tree as the moment it is inserted a concurrent lookup (allowed by the
> +	 * RCU locking mechanism) can find it and that lookup must see that this
> +	 * is an inode currently under construction (i.e. that XFS_INEW is set).
> +	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
> +	 * memory barrier that ensures this detection works correctly at lookup
> +	 * time.
> +	 */
> +	xfs_iflags_set(ip, XFS_INEW);
> +	ip->i_udquot = ip->i_gdquot = NULL;
>  
>  	/* insert the new inode */
> +	spin_lock(&pag->pag_ici_lock);
>  	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
>  	if (unlikely(error)) {
>  		WARN_ON(error != -EEXIST);
> @@ -360,11 +370,6 @@ xfs_iget_cache_miss(
>  		error = EAGAIN;
>  		goto out_preload_end;
>  	}
> -
> -	/* These values _must_ be set before releasing the radix tree lock! */
							   ^^^ 
So, in this comment 'radix tree lock' refers to pag->pag_ici_lock?

And, pag_ici_lock lock provides no exclusion with radix_tree_lookup.

I believe I understand.  That isn't to say that I couldn't use a
brush-up on RCU.  Awesome.  ;)

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
