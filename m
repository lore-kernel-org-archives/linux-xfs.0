Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 00:24:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J7OWdD003076
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 00:24:32 -0700
Date: Fri, 19 Sep 2008 03:26:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Unlock inode before calling xfs_idestroy()
Message-ID: <20080919072603.GA26903@infradead.org>
References: <48D3193C.6060201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D3193C.6060201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Sep 19, 2008 at 01:15:08PM +1000, Lachlan McIlroy wrote:
> Lock debugging reported the ilock was being destroyed
> without being unlocked.
>
> --- a/fs/xfs/xfs_iget.c	2008-09-19 13:03:57.000000000 +1000
> +++ b/fs/xfs/xfs_iget.c	2008-09-19 13:12:38.000000000 +1000
> @@ -214,6 +214,7 @@ finish_inode:
> 		xfs_ilock(ip, lock_flags);
>
> 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> +		xfs_iunlock(ip, lock_flags);
> 		xfs_idestroy(ip);
> 		xfs_put_perag(mp, pag);
> 		return ENOENT;
> @@ -224,6 +225,7 @@ finish_inode:
> 	 * write spinlock.
> 	 */
> 	if (radix_tree_preload(GFP_KERNEL)) {
> +		xfs_iunlock(ip, lock_flags);
> 		xfs_idestroy(ip);
> 		delay(1);
> 		goto again;

Just move the xfs_ilock call after these two statements, there is no
need to have it locked before inserting it into the radix tree.

> @@ -239,6 +241,7 @@ finish_inode:
> 		BUG_ON(error != -EEXIST);
> 		write_unlock(&pag->pag_ici_lock);
> 		radix_tree_preload_end();
> +		xfs_iunlock(ip, lock_flags);
> 		xfs_idestroy(ip);
> 		XFS_STATS_INC(xs_ig_dup);
> 		goto again;

But here we still need the fix.  But as Tim mention we need to check
for lock_flags != 0 first.  Long-term it might make sense to just make
xfs_iunlock a no-op if lock_flags == 0, but let's do that separately.
