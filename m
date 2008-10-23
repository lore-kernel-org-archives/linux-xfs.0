Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 21:19:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N4JN5c032511
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 21:19:23 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49BC510D4068
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 21:21:06 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DWEjCeXdCa80ZBcZ for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 21:21:06 -0700 (PDT)
Date: Thu, 23 Oct 2008 15:20:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] Re: atime not written to disk
Message-ID: <20081023042053.GY18495@disturbed>
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com> <20081022081710.GL18495@disturbed> <ncctzb4nhss.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncctzb4nhss.fsf@itchy.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Utako Kusaka <u-kusaka@wm.jp.nec.com>, Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 01:53:23PM +1100, Niv Sardi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> [...]
> > As I mentioned on IRC, Tim, the following patch fixes the above test
> > case. It will make XFS behave like other filesystems w.r.t. atime,
> > instead of defaulting to relatime-like behaviour. This will have
> > performance impact unless ppl now add the relatime mount option.
>  ^^^^^^^^^^^^^^^^^^^
> 
> I don't really like it, and don't think there is a real justification to
> do it.

You probably missed the context of that patch (which I mentioned on
IRC to Tim).

That was that it is part of a larger patch set that tracks dirty state
in the XFS inode radix tree. In that case, the ->dirty_inode callout
is used to set a tag in the per-ag inode radix tree. I want to
do it this way so there is a single place that the dirty tag
is set, whether it is due to an unlogged change (XFS or VFS) or
a transaction commit....

Also, if you read the referenced thread, Christoph made the comment
that the VFS was not letting us know that the inode had been dirtied and
that we really needed to know about that.  The patch I sent isn't
intended to do this, not as a fix for atime updates...

> Why not only do:
>
> From 96be907a11f2cad0d6c8696737bb144b1275ce5a Mon Sep 17 00:00:00 2001
> From: Niv Sardi <xaiki@debian.org>
> Date: Thu, 23 Oct 2008 13:41:09 +1100
> Subject: [PATCH] Mark core as dirty when atime updated needed for XFS inode
> 
> Currently we're not writting atime updates back to disk on unmount
> if it's the only change that happened. One solution would be to implement
> ->dirty_inode() but that might be overkill and has a perf hit, instead
> just tag as needed for update in reclaim()
> 
> Signed-off-by: Niv Sardi <xaiki@debian.org>
> ---
>  fs/xfs/xfs_vnodeops.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index e257f65..828d398 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -2840,6 +2840,7 @@ int
>  xfs_reclaim(
>  	xfs_inode_t	*ip)
>  {
> +	struct inode	*inode = VFS_I(ip);
>  
>  	xfs_itrace_entry(ip);
>  
> @@ -2856,10 +2857,13 @@ xfs_reclaim(
>  	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
>  
>  	/*
> -	 * Make sure the atime in the XFS inode is correct before freeing the
> -	 * Linux inode.
> +	 * Mark dirty and update atime only if different from the linux inode one.
>  	 */
> -	xfs_synchronize_atime(ip);
> +	if (! timespec_equal(&inode->i_atime,
> +			     (struct timespec *) &ip->i_d.di_atime)) {
> +		xfs_synchronize_atime(ip);
> +		ip->i_update_core = 1;
> +	}

This doesn't avoid the performance problem - it simply shifts it to
the reclaim code.  Think about it - you traverse a million inodes
stat()ing them all (the nightly backup). Instead of having the now
dirty inodes written back as you go along, you wait until memory
reclaim turfs them out to mark them dirty and then write them back.
This means memory reclaim goes *much slower* because reclaiming the
memory now has to wait for I/O to complete.

The speed of inode reclaim is already a problem when we only have
clean inodes.  If we now have to write back all these inodes, we'll
get at best a couple of thousand inodes cleaned a second (with
current writeback algorithms) and it could be as little as 50
inodes/s when software RAID5 on SATA disks is involved. That means
reclaim will be very slow, as will unmount. This could make low
memory situations effectively unrecoverable when the inode caches
dominate memory usage (e.g. your build servers after the nightly
backup has run).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
