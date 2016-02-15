Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F25F7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:26:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5054B304039
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:26:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ak99udxQTn1eorG6 for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 12:26:14 -0800 (PST)
Date: Tue, 16 Feb 2016 07:25:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: test for valid remount options, error if not
Message-ID: <20160215202521.GI14668@dastard>
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
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 986290c..3d4187c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -455,7 +455,7 @@ xfs_set_maxicount(xfs_mount_t *mp)
>   * We use smaller I/O sizes when the file system
>   * is being used for NFS service (wsync mount option).
>   */
> -STATIC void
> +void
>  xfs_set_rw_sizes(xfs_mount_t *mp)
>  {
>  	xfs_sb_t	*sbp = &(mp->m_sb);
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
> @@ -65,6 +65,8 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> +STATIC int xfs_finish_flags(struct xfs_mount *mp);
> +
>  /*
>   * Table driven mount option parser.
>   */
> @@ -1167,24 +1169,87 @@ xfs_quiesce_attr(
>  	xfs_log_quiesce(mp);
>  }
>  
> +#define XFS_BAD_REMOUNT_GOTO(mp, option, l)	\
> +	{ \
> +		xfs_warn(mp, \
> +		  option " options may not be changed via remount");	\
> +		goto l;	\
> +	}

I think hiding a goto like this is wrong - it forces you to go read
the macro, making the code harder to read and follow. Really, what's
wrong with the simple and obvious:


	if (bad option) {
		bad_option = "bad option string";
		goto out_warn;
	}
	.....

out_warn:
	xfs_warn(mp, "%s options may not be changed via remount",
		 bad_option);
	// free stuff
	return -EINVAL;
}

Yes, I know that this sort of logic flow hiding was done with the
XFS_WANT_CORRUPTED macros, but they were written back in 90s on Irix
when using macros to implement everything were all the rage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
