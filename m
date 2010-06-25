Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5P49Qk2067749 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 23:09:26 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05FE51D60C83
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 21:12:08 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 4RTIaJ0yEZOCKz04 for
	<xfs@oss.sgi.com>; Thu, 24 Jun 2010 21:12:08 -0700 (PDT)
Message-ID: <4C242C97.8060506@sandeen.net>
Date: Thu, 24 Jun 2010 23:12:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: unregister inode shrinker before freeing filesystem
	structures
References: <1277428120-27216-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1277428120-27216-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we don't remove the XFS mount from the shrinker list until late in
> the unmount path. By this time, we have already torn down the internals of the
> filesystem (e.g. the per-ag structures), and hence if the shrinker is executed
> between the teardown and the unregistering, the shrinker will get NULL per-ag
> structure pointers and panic trying to dereference them.
> 
> Fix this by removingthe xfs mount from the shrinker list before tearing down
> it's internal structures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks right to me, and is more symmetric with setup I think.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/linux-2.6/xfs_super.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index e3de46c..4605cd4 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1156,9 +1156,13 @@ xfs_fs_put_super(
>  
>  	XFS_bflush(mp->m_ddev_targp);
>  
> +	/*
> +	 * Unregister the memory shrinker before we tear down the mount
> +	 * structure so we don't have memory reclaim racing with us here.
> +	 */
> +	xfs_inode_shrinker_unregister(mp);
>  	xfs_unmountfs(mp);
>  	xfs_freesb(mp);
> -	xfs_inode_shrinker_unregister(mp);
>  	xfs_icsb_destroy_counters(mp);
>  	xfs_close_devices(mp);
>  	xfs_free_fsname(mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
