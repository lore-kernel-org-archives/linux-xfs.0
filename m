Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 23:20:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5U6Ko5m017575
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:20:51 -0700
Message-ID: <48687B79.6050101@sgi.com>
Date: Mon, 30 Jun 2008 16:21:45 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix mount option parsing in remount
References: <20080518153539.GA5218@lst.de>
In-Reply-To: <20080518153539.GA5218@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Remount currently happily accept any option thrown at it, although the
> only filesystem specific option it actually handles is barrier/nobarrier.
> And it actually doesn't handle these correctly either because it only
> uses the value it parsed when we're doing a ro->rw transition.  In
> addition to that there's also a bad bug in xfs_parseargs which doesn't
> touch the actual option in the mount point except for a single one,
> XFS_MOUNT_SMALL_INUMS and thus forced any filesystem that's every
> remounted in some way to not support 64bit inodes with no way to recover
> unless unmounted.
> 
> This patch changes xfs_fs_remount to use it's own linux/parser.h based
> options parse instead of xfs_parseargs and reject all options except
> for barrier/nobarrier and to the right thing in general.  Eventually
> I'd like to have a single big option table used for mount aswell but
> that can wait for a while.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-18 15:22:23.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-18 15:59:32.000000000 +0200
> @@ -67,6 +67,7 @@
>  #include <linux/writeback.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> +#include <linux/parser.h>
>  
>  static struct quotactl_ops xfs_quotactl_operations;
>  static struct super_operations xfs_super_operations;
> @@ -1255,6 +1256,19 @@ xfs_fs_statfs(
>  	return 0;
>  }
>  
> +/*
> + * Eventually we should extend this table and use it for mount, too.
> + */
> +enum {
> +	Opt_barrier, Opt_nobarrier, Opt_err
> +};
> +
> +static match_table_t tokens = {
> +	{Opt_barrier, "barrier"},
> +	{Opt_nobarrier, "nobarrier"},
> +	{Opt_err, NULL}
> +};
> +
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1262,36 +1276,54 @@ xfs_fs_remount(
>  	char			*options)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> -	struct xfs_mount_args	*args;
> -	int			error;
> +	substring_t		args[MAX_OPT_ARGS];
> +	char			*p;
>  
> -	args = xfs_args_allocate(sb, 0);
> -	if (!args)
> -		return -ENOMEM;
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int token;
>  
> -	error = xfs_parseargs(mp, options, args, 1);
> -	if (error)
> -		goto out_free_args;
> +		if (!*p)
> +			continue;
>  
> -	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -		if (args->flags & XFSMNT_BARRIER) {
> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case Opt_barrier:
>  			mp->m_flags |= XFS_MOUNT_BARRIER;
> -			xfs_mountfs_check_barriers(mp);
> -		} else {
> +
> +			/*
> +			 * Test if barriers are actually working if we can,
> +			 * else delay this check until the filesystem is
> +			 * marked writeable.
> +			 */
> +			if (!(mp->m_flags & XFS_MOUNT_RDONLY))
> +				xfs_mountfs_check_barriers(mp);
> +			break;
> +		case Opt_nobarrier:
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> +			break;
> +		default:
> +			printk(KERN_INFO
> +	"XFS: mount option \"%s\" not support for remount\n", p);

typo: s/support/supported/

Looking at ext3 and other XFS out of curiosity:
"XFS: unknown mount option [%s].", this_char
"EXT3-fs: Unrecognized mount option \"%s\" "
./smbfs/getopt.c:	printk("%s: Unrecognized mount option %s\n", caller, token);
Though I see for remount it is more a question of support
versus recognising it or not. Ok.

> +			return -EINVAL;
>  		}
> -	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {	/* rw -> ro */
> +	}
> +
> +	/* rw/ro -> rw */
> +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
> +		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +		if (mp->m_flags & XFS_MOUNT_BARRIER)
> +			xfs_mountfs_check_barriers(mp);
> +	}
> +
> +	/* rw -> ro */
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
>  		xfs_filestream_flush(mp);
>  		xfs_sync(mp, SYNC_DATA_QUIESCE);
>  		xfs_attr_quiesce(mp);
>  		mp->m_flags |= XFS_MOUNT_RDONLY;
>  	}
>  
I'm a little confused why we call xfs_mountfs_check_barriers(mp) in 2 places.
Oh okay,
so you want it tested if we have barrier option and
currently not-readonly or after we transition to not-readonly.
And you have it around the parsing code because you don't care about
what it might transition to in the current not-readonly case.

I think we ideally should have a qa test for this.
We have 017 but it doesn't do any barrier or illegal options.

--Tim
