Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6J0B8Pm174140 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 19:11:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6E2E15C2E71
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 17:20:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	LqShcwoaMjtTOBDW for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 17:20:40 -0700 (PDT)
Date: Mon, 19 Jul 2010 10:14:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs:negative_icount.patch
Message-ID: <20100719001403.GC23223@dastard>
References: <1279306421.17689.38.camel@superior.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279306421.17689.38.camel@superior.americas.sgi.com>
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
To: Stuart Brodsky <sbrodsky@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 16, 2010 at 01:53:41PM -0500, Stuart Brodsky wrote:
> This patch fixes the stat -f icount field going negative.  The use of
> lazy counts means that the super block field sb_icount is not updated
> correctly and will allow over allocation of inodes above maxicount.
> 
> Signed-off-by: Stu Brodsky <sbrodsky@sgi.com>
> 
> Index: a/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- a/fs/xfs/xfs_ialloc.c.orig	2010-07-16 10:12:02.000000000 -0500
> +++ b/fs/xfs/xfs_ialloc.c	2010-07-16 10:19:56.312633030 -0500
> @@ -260,7 +260,7 @@
>  	 */
>  	newlen = XFS_IALLOC_INODES(args.mp);
>  	if (args.mp->m_maxicount &&
> -	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
> +	    atomic64_read(&args.mp->m_inodesinuse) + newlen >
> args.mp->m_maxicount)
>  		return XFS_ERROR(ENOSPC);
>  	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
>  	/*
> @@ -708,7 +708,7 @@
>  	 */
>  
>  	if (mp->m_maxicount &&
> -	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
> +	    atomic64_read(&mp->m_inodesinuse) + XFS_IALLOC_INODES(mp) >
> mp->m_maxicount)
>  		noroom = 1;
>  		okalloc = 0;
>  	}

.....

> Index: a/fs/xfs/xfs_trans.c
> ===================================================================
> --- a/fs/xfs/xfs_trans.c.orig	2010-07-16 10:12:02.000000000 -0500
> +++ b/fs/xfs/xfs_trans.c	2010-07-16 10:22:47.690249548 -0500
> @@ -805,6 +805,7 @@
>  	switch (field) {
>  	case XFS_TRANS_SB_ICOUNT:
>  		tp->t_icount_delta += delta;
> +		atomic64_add(delta,&tp->t_mountp->m_inodesinuse);
>  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
>  			flags &= ~XFS_TRANS_SB_DIRTY;
>  		break;

This is still racy. It may fix your specific reproducer but I can't see how
changing the in use inode count from late in xfs_trans_commit() to early in
xfs_trans_commit() solves the problem: if we look at it
like this:


	thread 1		thread 2
	check count
	<start alloc>
	.....
				check count
				<start alloc>
				....
	<update count>


All you've done if change where <update count> occurs rather than
solving the race that prevents negative inode counts.

Realistically, there is nothing wrong with XFS exceeding mp->m_maxicount by a
small amount - it's just an arbitrary limit that we use to prevent all the
filesytem space from being taken up by inodes.  I think the problem is just a
reporting problem here in xfs_fs_statfs():

1245         fakeinos = statp->f_bfree << sbp->sb_inopblog;
1246         statp->f_files =
1247             MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
1248         if (mp->m_maxicount)
1249                 statp->f_files = min_t(typeof(statp->f_files),
1250                                         statp->f_files,
1251                                         mp->m_maxicount);
1252         statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);

Assume no free space and no free inodes (statp->f_bfree = 0, => fakeinos = 0),
and we have just hit the above race condition to allocate more inodes than
mp->m_maxicount. Hence we have sbp->sb_icount > mp->m_maxicount and that gives:

	statp->f_files = min(sbp->sb_icount, mp->m_maxicount);
	statp->f_files = mp->m_maxicount;

And now we've allocated all the free inodes (sbp->sb_ifree = 0). Therefore:

	statp->f_ffree = mp->m_maxicount - (sbp->sb_icount - 0)

Which gives statp->f_ffree < 0 and hence negative free inodes. I think
all that is required to "fix" this is to clamp statp->f_ffree to zero.
i.e.:

	if (statp->f_ffree < 0)
		statp->f_ffree = 0;

Make sense?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
