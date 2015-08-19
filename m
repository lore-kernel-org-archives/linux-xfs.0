Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDA257F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 17:50:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BA6DAC003
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 15:50:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mKh19zObnGpKlJCL for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 15:50:52 -0700 (PDT)
Message-ID: <55D5084B.8080500@sandeen.net>
Date: Wed, 19 Aug 2015 17:50:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: inode lockdep annotations broke non-lockdep build
References: <1439979814-18934-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1439979814-18934-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/19/15 5:23 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix CONFIG_LOCKDEP=n build, because asserts I put in to ensure we
> aren't overrunning lockdep subclasses in commit 0952c81 ("xfs:
> clean up inode lockdep annotations") use a define that doesn't
> exist when CONFIG_LOCKDEP=n
> 
> Only check the subclass limits when lockdep is actually enabled.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_inode.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index dd584da..30555f8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -362,6 +362,17 @@ int xfs_lots_retries;
>  int xfs_lock_delays;
>  #endif
>  
> +#ifdef CONFIG_LOCKDEP
> +static bool
> +xfs_lockdep_subclass_ok(
> +	int subclass)
> +{
> +	return subclass < MAX_LOCKDEP_SUBCLASSES;
> +}
> +#else
> +#define xfs_lockdep_subclass_ok(subclass)	(true)
> +#endif
> +
>  /*
>   * Bump the subclass so xfs_lock_inodes() acquires each lock with a different
>   * value. This can be called for any type of inode lock combination, including
> @@ -375,11 +386,12 @@ xfs_lock_inumorder(int lock_mode, int subclass)
>  
>  	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
>  			      XFS_ILOCK_RTSUM)));
> +	ASSERT(xfs_lockdep_subclass_ok(subclass));
>  
>  	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
>  		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
> -		ASSERT(subclass + XFS_IOLOCK_PARENT_VAL <
> -						MAX_LOCKDEP_SUBCLASSES);
> +		ASSERT(xfs_lockdep_subclass_ok(subclass +
> +						XFS_IOLOCK_PARENT_VAL));
>  		class += subclass << XFS_IOLOCK_SHIFT;
>  		if (lock_mode & XFS_IOLOCK_PARENT)
>  			class += XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
