Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756322AbdHYN5D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 09:57:03 -0400
Date: Fri, 25 Aug 2017 09:57:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: check for race with xfs_reclaim_inode() in
 xfs_ifree_cluster()
Message-ID: <20170825135659.GA40964@bfoster.bfoster>
References: <93321e051fb5f80c4727844748cca04604a8757a.1503618336.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93321e051fb5f80c4727844748cca04604a8757a.1503618336.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Thu, Aug 24, 2017 at 04:50:09PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> After xfs_ifree_cluster() finds an inode in the radix tree and verifies
> that the inode number is what it expected, xfs_reclaim_inode() can swoop
> in and free it. xfs_ifree_cluster() will then happily continue working
> on the freed inode. Most importantly, it will mark the inode stale,
> which will probably be overwritten when the inode slab object is
> reallocated, but if it has already been reallocated then we can end up
> with an inode spuriously marked stale.
> 
> In 8a17d7ddedb4 ("xfs: mark reclaimed inodes invalid earlier") we added
> a second check to xfs_iflush_cluster() to detect this race, but the
> similar RCU lookup in xfs_ifree_cluster() needs the same treatment.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Based on v4.13-rc6. Let me know if my reasoning here is completely off,
> the XFS inode machinery makes my head spin.
> 
>  fs/xfs/xfs_icache.c | 10 +++++-----
>  fs/xfs/xfs_inode.c  | 23 ++++++++++++++++++-----
>  2 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0a9e6985a0d0..34227115a5d6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1124,11 +1124,11 @@ xfs_reclaim_inode(
>  	 * Because we use RCU freeing we need to ensure the inode always appears
>  	 * to be reclaimed with an invalid inode number when in the free state.
>  	 * We do this as early as possible under the ILOCK so that
> -	 * xfs_iflush_cluster() can be guaranteed to detect races with us here.
> -	 * By doing this, we guarantee that once xfs_iflush_cluster has locked
> -	 * XFS_ILOCK that it will see either a valid, flushable inode that will
> -	 * serialise correctly, or it will see a clean (and invalid) inode that
> -	 * it can skip.
> +	 * xfs_iflush_cluster() and xfs_ifree_cluster() can be guaranteed to
> +	 * detect races with us here. By doing this, we guarantee that once
> +	 * xfs_iflush_cluster() or xfs_ifree_cluster() has locked XFS_ILOCK that
> +	 * it will see either a valid inode that will serialise correctly, or it
> +	 * will see an invalid inode that it can skip.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ff48f0096810..97045e8dfed5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2359,11 +2359,24 @@ xfs_ifree_cluster(
>  			 * already marked stale. If we can't lock it, back off
>  			 * and retry.
>  			 */
> -			if (ip != free_ip &&
> -			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> -				rcu_read_unlock();
> -				delay(1);
> -				goto retry;
> +			if (ip != free_ip) {
> +				if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> +					rcu_read_unlock();
> +					delay(1);
> +					goto retry;
> +				}
> +
> +				/*
> +				 * Check the inode number again in case we're
> +				 * racing with freeing in xfs_reclaim_inode().
> +				 * See the comments in that function for more
> +				 * information as to why the initial check is
> +				 * not sufficient.
> +				 */
> +				if (ip->i_ino != inum + i) {
> +					xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +					continue;
> +				}

Ok, so we're down in the codepath where we've removed the last inode in
a chunk and we've freed the inode chunk. We lock each cluster buffer,
lookup each inode in the cluster to mark it stale, then invalidate the
buffer.

Here, we check the inode number and stale state under the spinlock while
on the reclaim side, we do the lookup and set the reclaim flag under the
spinlock. It seems both paths can get at least that far without
necessarily stomping on eachother.

Next, both paths acquire the ilock...

If xfs_ifree_cluster() gets the lock it acquires the flush lock and
marks the inode stale (possibly attaching to the invalidated buffer if
it is dirty, which I think is irrelevant here). Hence when reclaim
acquires the lock, it sees a stale inode and immediately reclaims it. So
far so good.

If reclaim had acquired the lock, it (potentially) reclaims the inode
and resets i_ino = 0 before the ilock is released as indication. Then
the inode is removed from the tree and scheduled for rcu freeing. On the
xfs_ifree_cluster() side, each ilock trylock failure cycles the rcu read
lock and retries the initial lookup. I think that means there's a good
chance the previous i_ino check would either fail the lookup or detect
the reclaimed inode and skip it appropriately. That said, it does appear
like there's a very small window where if the lookup and i_flags_lock
checks (in xfs_ifree_cluster()) occur before reclaim resets i_ino but
reclaim releases ilock such that the (xfs_ifree_cluster()) ilock trylock
does not fail, we go on and stale a possibly free inode.

This code is hairy and it's easily possible that I'm missing something
as well. Even so, I think the additional check is harmless and
defensive and so this looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

I am curious whether you've hit a problem that this patch addresses or
if this is just an observation?

Brian

>  			}
>  			rcu_read_unlock();
>  
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
