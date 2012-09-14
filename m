Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EI5RR9155930 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 13:05:27 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id sO9f4Ld6SYoKi32N for <xfs@oss.sgi.com>;
	Fri, 14 Sep 2012 11:06:33 -0700 (PDT)
Message-ID: <50537229.1000801@sandeen.net>
Date: Fri, 14 Sep 2012 13:06:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: make inode64 as the default allocation mode
References: <1347641381-30050-1-git-send-email-cmaiolino@redhat.com>
	<1347641381-30050-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1347641381-30050-2-git-send-email-cmaiolino@redhat.com>
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

On 9/14/12 11:49 AM, Carlos Maiolino wrote:
> since 64-bit inodes can be accessed while using inode32, and these can also be
> used on 32-bit kernels, there is no reason to still keep inode32 as the default
> mount option.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f1f2968..967d024 100644
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
> @@ -198,7 +200,6 @@ xfs_parseargs(
>  	 */
>  	mp->m_flags |= XFS_MOUNT_BARRIER;
>  	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;

Self-note-taking.

XFS_BIG_INUMS means the kernel itself is capable of > 32 bit inode nrs in struct inode.

XFS_MOUNT_SMALL_INUMS is "users wants 32bit inodes "

XFS_MOUNT_32BITINODES is "do not create inodes above 32 bits"

MNTOPT_32BITINODE is the actual mount option string "inode32"

I think rather than removing the line above, you might need to keep it under
#if !XFS_BIG_INUMS
	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
#endif

so that "small" systems continue to enforce <= 32 bit inodes.

>  	/*
>  	 * These can be overridden by the mount option parsing.
> @@ -295,6 +296,13 @@ xfs_parseargs(
>  				return EINVAL;
>  			}
>  			dswidth = simple_strtoul(value, &eov, 10);
> +		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
> +			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +#if !XFS_BIG_INUMS
> +			xfs_warn(mp, "%s option not allowed on this system",
> +				this_char);
> +			return EINVAL;
> +#endif

This looks wrong.  If a user has a system which cannot handle 64 bit inodes,
you reject a request to mount with 32-bit inodes?

-Eric

>  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
>  			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
>  #if !XFS_BIG_INUMS
> @@ -493,13 +501,13 @@ xfs_showargs(
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
>  		{ 0, NULL }
>  	};
>  	struct proc_xfs_info	*xfs_infop;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
