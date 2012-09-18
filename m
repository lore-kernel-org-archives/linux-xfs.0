Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I5nOiS011048 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 00:49:24 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WNwjZzoY5HLubmH0 for <xfs@oss.sgi.com>;
	Mon, 17 Sep 2012 22:50:34 -0700 (PDT)
Date: Tue, 18 Sep 2012 15:50:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: make inode64 as the default allocation mode
Message-ID: <20120918055029.GL13691@dastard>
References: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
	<1347900702-23421-2-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1347900702-23421-2-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 17, 2012 at 01:51:39PM -0300, Carlos Maiolino wrote:
> since 64-bit inodes can be accessed while using inode32, and these can also be
> used on 32-bit kernels, there is no reason to still keep inode32 as the default
> mount option.

This needs to explain why XFS_MOUNT_SMALL_INUMS is still the default
for !XFS_BIG_INUMS. i.e. inode64 is not an unconditional default
value.

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f1f2968..b1aa2db 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -88,6 +88,8 @@ mempool_t *xfs_ioend_pool;
>  					 * unwritten extent conversion */
>  #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
>  #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
> +#define MNTOPT_32BITINODE   "inode32"	/* inode allocation limited to
> +					 * XFS_MAXINUMBER_32 */
>  #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
>  #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
>  #define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
> @@ -198,7 +200,9 @@ xfs_parseargs(
>  	 */
>  	mp->m_flags |= XFS_MOUNT_BARRIER;
>  	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +#if !XFS_BIG_INUMS
>  	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +#endif
>  
>  	/*
>  	 * These can be overridden by the mount option parsing.
> @@ -295,6 +299,8 @@ xfs_parseargs(
>  				return EINVAL;
>  			}
>  			dswidth = simple_strtoul(value, &eov, 10);
> +		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
> +			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
>  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
>  			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
>  #if !XFS_BIG_INUMS
> @@ -493,13 +499,13 @@ xfs_showargs(
>  		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
>  		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
>  		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
> +		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
>  		{ 0, NULL }
>  	};
>  	static struct proc_xfs_info xfs_info_unset[] = {
>  		/* the few simple ones we can get from the mount struct */
>  		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
>  		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
> -		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },

I'd leave that in the table, that way people will still know if they
are using inode64 or not by grepping /proc/self/mounts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
