Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FD397CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:54:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2B43AC004
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W1EibelYFPo3lrlX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:40 -0800 (PST)
Date: Mon, 15 Feb 2016 13:54:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: test for valid remount options, error if not
Message-ID: <20160215185437.GC33291@bfoster.bfoster>
References: <56BBC982.50804@redhat.com>
 <56BBCB9D.6080404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56BBCB9D.6080404@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 05:45:33PM -0600, Eric Sandeen wrote:
> This patch attempts to check for a valid set of remount
> options.  As far as I can tell, it's tricky; as the old
> comment says, on remount we may get a long string of
> options from /proc/mounts and/or /etc/mtab, as well
> as options specified on the commandline.  Later options
> may negate previous options, etc.
> 
> At the most basic level, we may be handed a mount option
> which we do not handle on remount, but which may not actually
> be a change from the current mount option set.
> 
> Unfortunately our mount option state is somewhat far flung;
> a combinations of m_flags, and values in various other
> mount structure members; see the showargs function for
> a taste of that.
> 
> So this extends xfs_test_remount_options() to do a full set
> of mount processing of the options remount sees, to arrive
> at a final state, then compares that state to the current
> state, and determines if we can proceed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This is lightly tested; mostly just a sanity check to see
> if this approach is a "wtf?" or a "yeah, seems ok."
> 
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a4e03ab..bee9284 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -335,6 +335,7 @@ extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
>  
>  extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
>  
> +extern void	xfs_set_rw_sizes(xfs_mount_t *);
>  extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
>  
>  int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d1cd4fa..50e15d8 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -1167,24 +1169,87 @@ xfs_quiesce_attr(
...
>  STATIC int
>  xfs_test_remount_options(
>  	struct super_block	*sb,
>  	struct xfs_mount	*mp,
>  	char			*options)
>  {
...
> +	/* The only flags we can change on remount */
> +	ok_flags = XFS_MOUNT_BARRIER | XFS_MOUNT_RDONLY |
> +		   XFS_MOUNT_SMALL_INUMS | XFS_MOUNT_32BITINODES; 

Trailing whitespace at the end of the above line.

> +	/* This is only used internally, so OK as well */
> +	ok_flags |= XFS_MOUNT_WAS_CLEAN;
> +
> +	/* The flags that *did* change */
> +	changed_flags = (tmp_mp->m_flags ^ mp->m_flags);
> +
> +	error = -EINVAL;
> +
> +	if (tmp_mp->m_qflags != mp->m_qflags)
> +		XFS_BAD_REMOUNT_GOTO(mp, "quota", out);
> +
> +	if (tmp_mp->m_logbufs != mp->m_logbufs ||
> +	    tmp_mp->m_logbsize != mp->m_logbsize)
> +		XFS_BAD_REMOUNT_GOTO(mp, "logbufs/logbsize", out);
> +
> +	if (tmp_mp->m_readio_log != mp->m_readio_log ||
> +	    tmp_mp->m_writeio_log != mp->m_writeio_log)
> +		XFS_BAD_REMOUNT_GOTO(mp, "allocsize/biosize", out);
> +
> +	if ((tmp_mp->m_logname && mp->m_logname &&
> +	     strcmp(tmp_mp->m_logname, mp->m_logname)) ||
> +	    (tmp_mp->m_rtname &&  mp->m_rtname &&
> +	     strcmp(tmp_mp->m_rtname, mp->m_rtname)))
> +		XFS_BAD_REMOUNT_GOTO(mp, "logdev/rtdev", out);
> +

This warning won't trigger if rtname or logname is specified by the
remount and the current mount doesn't have either set (because the
current mp->m_logname == NULL, for example).

I was also wondering why we can't just check these values against the
defaults and complain if they are specified at all at remount time, but
looking back at the commit log it sounds like we have to handle the case
where a mount option string might essentially be copy/pasted from
/proc/mounts and slightly tweaked with a valid change. Does something
actually break if we don't handle that? Though I suppose if it works now
we probably shouldn't break it.

> +	/* Catch-all for anything else */
> +	if (changed_flags & ~ok_flags)
> +		XFS_BAD_REMOUNT_GOTO(mp, "specified", out);
> +
> +	error = 0;
> +out:
> +	xfs_free_fsname(tmp_mp);
> +	kfree(tmp_mp);
>  	return error;
>  }
>  
> @@ -1200,7 +1265,12 @@ xfs_fs_remount(
>  	char			*p;
>  	int			error;
>  
> -	/* First, check for complete junk; i.e. invalid options */
> +	/*
> +	 * Remounting is tricky; we get various combinations
> +	 * of options, both pre-existing and changed, here.
> +	 * This function tries to ensure that what we got
> +	 * is a sane set for remounting, and errors if not.
> +	 */
>  	error = xfs_test_remount_options(sb, mp, options);
>  	if (error)
>  		return error;
> @@ -1228,28 +1298,13 @@ xfs_fs_remount(
>  			break;
>  		default:
>  			/*
> -			 * Logically we would return an error here to prevent
> -			 * users from believing they might have changed
> -			 * mount options using remount which can't be changed.
> -			 *
> -			 * But unfortunately mount(8) adds all options from
> -			 * mtab and fstab to the mount arguments in some cases
> -			 * so we can't blindly reject options, but have to
> -			 * check for each specified option if it actually
> -			 * differs from the currently set option and only
> -			 * reject it if that's the case.
> -			 *
> -			 * Until that is implemented we return success for
> -			 * every remount request, and silently ignore all
> -			 * options that we can't actually change.
> +			 * xfs_test_remount_options really should have errored
> +			 * out on any non-remountable options; anything that got 

Trailing whitespace.

Brian

> +			 * here should be a no-op; a re-statement of existing
> +			 * options. If something slipped through: too bad!
> +			 * We'll just ignore it.
>  			 */
> -#if 0
> -			xfs_info(mp,
> -		"mount option \"%s\" not supported for remount", p);
> -			return -EINVAL;
> -#else
>  			break;
> -#endif
>  		}
>  	}
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
